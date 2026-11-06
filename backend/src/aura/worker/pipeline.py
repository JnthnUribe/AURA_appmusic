"""Idempotent ingestion pipeline.

Stages: resolve → download → probe → analyze → enrich → tag → upload → finalize.

The original plan uploads before enrichment; we enrich and tag first so the file is
written to R2 exactly once. Every stage is safe to repeat: assets are content
addressed by sha256 and tracks are unique on (user, provider, ref).
"""

from __future__ import annotations

import asyncio
import shutil
import tempfile
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any
from uuid import UUID

import httpx
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession

from aura.core.config import Settings
from aura.core.lrc import parse_lrc
from aura.core.normalize import normalize_text, normalize_title
from aura.db.base import utcnow
from aura.db.models import (
    Album,
    Artist,
    Asset,
    CoverCandidate,
    Job,
    Lyrics,
    Track,
    TrackArtist,
)
from aura.providers.base import DownloadResult, ResolvedTrack, SourceProvider
from aura.providers.covers import (
    coverart_candidates,
    deezer_candidates,
    derivatives,
    itunes_candidates,
    palette,
    placeholder,
    select_cover,
    youtube_candidates,
)
from aura.providers.lyrics import LRCLIBProvider
from aura.providers.musicbrainz import MusicBrainzClient
from aura.services import jobs as queue
from aura.services.audio import analyze, ensure_m4a
from aura.services.storage import Storage, content_key, sha256_file
from aura.services.tagging import embed


class CancelledJob(Exception):
    pass


@dataclass
class PipelineContext:
    job: Job
    track: Track | None = None
    resolved: ResolvedTrack | None = None
    audio_path: Path | None = None
    download: DownloadResult | None = None
    cover: bytes | None = None
    cover_candidates: list[Any] = field(default_factory=list)
    lrc: str | None = None
    plain_lyrics: str | None = None
    warnings: list[str] = field(default_factory=list)
    result: dict[str, Any] = field(default_factory=dict)


class Progress:
    """At most one database write per second for job progress."""

    def __init__(self, session: AsyncSession, job_id: UUID) -> None:
        self.session = session
        self.job_id = job_id
        self._last = 0.0

    async def update(self, stage: str, progress: float, *, force: bool = False) -> None:
        now = time.monotonic()
        if not force and now - self._last < 1.0:
            return
        self._last = now
        await queue.heartbeat(self.session, self.job_id, stage=stage, progress=progress)
        await self.session.commit()


class IngestionPipeline:
    def __init__(
        self,
        *,
        session: AsyncSession,
        settings: Settings,
        storage: Storage,
        provider: SourceProvider,
        worker_id: str,
    ) -> None:
        self.session = session
        self.settings = settings
        self.storage = storage
        self.provider = provider
        self.worker_id = worker_id

    async def run(self, job: Job) -> dict[str, Any]:
        if job.kind == "recheck_lyrics":
            return await self._recheck_lyrics(job)
        context = PipelineContext(job=job)
        progress = Progress(self.session, job.id)
        tmp = Path(tempfile.mkdtemp(prefix="aura-job-"))
        try:
            await progress.update("resolve", 0.05, force=True)
            if job.payload.get("provider") == "upload":
                key = str(job.payload["storage_key"])
                imported = tmp / "import"
                await self.storage.download_to(self.settings.r2_bucket_audio, key, imported)
                context.download = DownloadResult(path=imported, mime="audio/mpeg")
                context.resolved = ResolvedTrack(
                    provider="upload",
                    ref=key,
                    title=str(job.payload.get("title") or imported.stem),
                    artists=[str(item) for item in job.payload.get("artists") or []],
                    album=job.payload.get("album"),
                    duration_ms=job.payload.get("duration_ms"),
                )
            else:
                ref = str(job.payload.get("ref") or job.payload.get("video_id") or "")
                if not ref:
                    raise ValueError("Job payload has no ref")
                context.resolved = await self.provider.resolve(ref)

            existing = await self._find_track(job.user_id, context.resolved)
            if existing is not None and existing.status == "ready":
                await queue.finish_job(
                    self.session, job.id, result={"track_id": str(existing.id), "reused": True}
                )
                return {"track_id": str(existing.id), "reused": True}

            await self._ensure_cancelled(job.id)
            await progress.update("download", 0.15, force=True)
            if context.download is None:
                context.download = await self.provider.download(context.resolved, tmp)
            context.audio_path = await ensure_m4a(context.download.path)

            await progress.update("probe", 0.3, force=True)
            info = await analyze(context.audio_path)
            if info.duration_ms:
                context.resolved.duration_ms = info.duration_ms

            await progress.update("enrich", 0.45, force=True)
            await self._enrich(context)

            await self._ensure_cancelled(job.id)
            await progress.update("tag", 0.65, force=True)
            if context.cover:
                embed(
                    context.audio_path,
                    title=context.resolved.title,
                    artists=context.resolved.artists,
                    album=context.resolved.album,
                    year=context.resolved.year,
                    track_no=context.resolved.track_no,
                    disc_no=context.resolved.disc_no,
                    isrc=context.resolved.isrc,
                    mbid=context.resolved.extra.get("mbid"),
                    album_mbid=context.resolved.extra.get("album_mbid"),
                    cover=context.cover,
                    lyrics=context.lrc or context.plain_lyrics,
                )

            await progress.update("upload", 0.8, force=True)
            asset = await self._upload_audio(context.audio_path)
            waveform_asset = await self._upload_waveform(info.waveform)

            await progress.update("finalize", 0.95, force=True)
            track = await self._persist(context, asset, info, waveform_asset)
            context.result = {"track_id": str(track.id), "status": "ready"}
            await queue.finish_job(self.session, job.id, result=context.result)
            return context.result
        except CancelledJob:
            await queue.cancel_job(self.session, job.id)
            return {"cancelled": True}
        finally:
            await self.session.commit()
            await asyncio.to_thread(shutil.rmtree, tmp, True)

    async def _ensure_cancelled(self, job_id: UUID) -> None:
        if await queue.is_cancelled(self.session, job_id):
            raise CancelledJob

    async def _recheck_lyrics(self, job: Job) -> dict[str, Any]:
        from datetime import timedelta

        track = await self.session.get(Track, UUID(str(job.payload["track_id"])))
        if track is None:
            await queue.finish_job(self.session, job.id, result={"skipped": "track_missing"})
            return {"skipped": "track_missing"}
        artist = "Unknown artist"
        if track.artists:
            artist = track.artists[0].artist.name
        client = LRCLIBProvider(self.settings.lrclib_user_agent)
        result = await client.fetch(
            track_name=track.title,
            artist_name=artist,
            album_name=track.album.title if track.album else None,
            duration_seconds=int((track.duration_ms or 0) / 1000) or None,
        )
        existing = (
            await self.session.execute(
                select(Lyrics).where(Lyrics.track_id == track.id, Lyrics.source == "lrclib")
            )
        ).scalar_one_or_none()
        if result is None:
            target = existing or Lyrics(track_id=track.id, source="lrclib", kind="plain")
            if existing is None:
                self.session.add(target)
            target.recheck_at = utcnow() + timedelta(days=30)
        else:
            target = existing or Lyrics(track_id=track.id, source="lrclib", kind="plain")
            if existing is None:
                self.session.add(target)
            document = parse_lrc(result.raw_lrc or "", duration_ms=track.duration_ms)
            target.kind = result.kind
            target.raw_lrc = result.raw_lrc
            target.plain_text = result.plain_text or document.plain_text
            target.plain_text_norm = normalize_text(target.plain_text or "")
            target.lines = document.to_dict()["lines"] if result.raw_lrc else []
            target.confidence = result.confidence
            target.fetched_at = utcnow()
            target.recheck_at = None if result.kind == "synced" else utcnow() + timedelta(days=7)
        await queue.finish_job(self.session, job.id, result={"track_id": str(track.id)})
        return {"track_id": str(track.id)}

    async def _find_track(self, user_id: UUID, resolved: ResolvedTrack) -> Track | None:
        result = await self.session.execute(
            select(Track).where(
                Track.user_id == user_id,
                Track.source_provider == resolved.provider,
                Track.source_ref == resolved.ref,
            )
        )
        return result.scalar_one_or_none()

    async def _enrich(self, context: PipelineContext) -> None:
        resolved = context.resolved
        assert resolved is not None
        artist = resolved.artists[0] if resolved.artists else "Unknown artist"
        title, version, featured = normalize_title(resolved.title)
        resolved.title = title or resolved.title
        if version:
            resolved.extra["version"] = version
        if featured:
            resolved.artists = list(dict.fromkeys([*resolved.artists, *featured]))

        mb_client = MusicBrainzClient(self.settings.musicbrainz_user_agent)
        match = None
        try:
            match = await mb_client.search_recording(
                title=resolved.title,
                artist=artist,
                duration_ms=resolved.duration_ms,
            )
        except Exception as exc:
            context.warnings.append(f"musicbrainz: {exc}")
        if match:
            resolved.extra["mbid"] = match.mbid
            resolved.extra["album_mbid"] = match.release_mbid
            resolved.isrc = match.isrc or resolved.isrc
            resolved.track_no = match.track_no or resolved.track_no
            resolved.disc_no = match.disc_no or resolved.disc_no
            resolved.year = match.year or resolved.year
            if match.release_title:
                resolved.album = match.release_title
            if match.artists:
                resolved.artists = match.artists
        else:
            context.warnings.append("no confident MusicBrainz match")
            resolved.extra["needs_review"] = True

        candidates: list[Any] = []
        try:
            async with httpx.AsyncClient(
                headers={"User-Agent": self.settings.musicbrainz_user_agent}
            ) as client:
                tasks = [
                    itunes_candidates(client, artist, resolved.album),
                    coverart_candidates(client, resolved.extra.get("album_mbid")),
                    deezer_candidates(client, artist, resolved.album),
                ]
                batches = await asyncio.gather(*tasks, return_exceptions=True)
                for batch in batches:
                    if isinstance(batch, list):
                        candidates.extend(batch)
            candidates.extend(await youtube_candidates(resolved.thumbnail_url))
        except Exception as exc:
            context.warnings.append(f"covers: {exc}")

        if candidates:
            try:
                selection = select_cover(candidates)
                context.cover = selection.chosen.image
                context.cover_candidates = selection.candidates
                resolved.extra["cover_provider"] = selection.chosen.provider
            except ValueError as exc:
                context.warnings.append(str(exc))

        lyrics_client = LRCLIBProvider(self.settings.lrclib_user_agent)
        try:
            lyrics = await lyrics_client.fetch(
                track_name=resolved.title,
                artist_name=artist,
                album_name=resolved.album,
                duration_seconds=int((resolved.duration_ms or 0) / 1000) or None,
            )
            if lyrics and not lyrics.instrumental:
                context.lrc = lyrics.raw_lrc
                context.plain_lyrics = lyrics.plain_text
                resolved.extra["lyrics_source"] = lyrics.source
                resolved.extra["lyrics_kind"] = lyrics.kind
            elif lyrics and lyrics.instrumental:
                resolved.extra["lyrics_kind"] = "instrumental"
        except Exception as exc:
            context.warnings.append(f"lyrics: {exc}")

    async def _upload_audio(self, path: Path) -> Asset:
        digest = sha256_file(path)
        existing = (
            await self.session.execute(select(Asset).where(Asset.sha256 == digest))
        ).scalar_one_or_none()
        if existing is not None:
            return existing
        key = content_key("audio", digest, ".m4a")
        await self.storage.upload_file(self.settings.r2_bucket_audio, key, path, "audio/mp4")
        asset = Asset(
            kind="audio",
            bucket=self.settings.r2_bucket_audio,
            storage_key=key,
            mime="audio/mp4",
            bytes=await asyncio.to_thread(lambda: path.stat().st_size),
            sha256=digest,
        )
        self.session.add(asset)
        await self.session.flush()
        return asset

    async def _upload_waveform(self, peaks: list[float] | None) -> Asset | None:
        if not peaks:
            return None
        import hashlib
        import json

        payload = json.dumps({"peaks": peaks}, separators=(",", ":")).encode()
        digest = hashlib.sha256(payload).hexdigest()
        existing = (
            await self.session.execute(select(Asset).where(Asset.sha256 == digest))
        ).scalar_one_or_none()
        if existing is not None:
            return existing
        key = content_key("waveform", digest, ".json")
        await self.storage.upload_bytes(
            self.settings.r2_bucket_art, key, payload, "application/json"
        )
        asset = Asset(
            kind="waveform",
            bucket=self.settings.r2_bucket_art,
            storage_key=key,
            mime="application/json",
            bytes=len(payload),
            sha256=digest,
        )
        self.session.add(asset)
        await self.session.flush()
        return asset

    async def _persist(
        self, context: PipelineContext, asset: Asset, info: Any, waveform_asset: Asset | None = None
    ) -> Track:
        resolved = context.resolved
        assert resolved is not None
        job = context.job

        artist_models: list[Artist] = []
        for index, name in enumerate(resolved.artists or ["Unknown artist"]):
            artist = await self._get_or_create_artist(
                name, resolved.extra.get("mbid") if index == 0 else None
            )
            artist_models.append(artist)

        album = None
        if resolved.album:
            album = await self._get_or_create_album(
                title=resolved.album,
                album_artist=artist_models[0] if artist_models else None,
                year=resolved.year,
                mbid=resolved.extra.get("album_mbid"),
            )

        cover_asset = None
        if context.cover:
            cover_asset = await self._store_cover(album, context.cover, context.cover_candidates)

        track = await self._find_track(job.user_id, resolved)
        if track is None:
            track = Track(
                user_id=job.user_id,
                title=resolved.title,
                title_norm=normalize_text(resolved.title),
                source_provider=resolved.provider,
                source_ref=resolved.ref,
            )
            self.session.add(track)
            await self.session.flush()

        track.title = resolved.title
        track.title_norm = normalize_text(resolved.title)
        track.version = resolved.extra.get("version")
        track.album_id = album.id if album else None
        track.track_no = resolved.track_no
        track.disc_no = resolved.disc_no
        track.duration_ms = info.duration_ms or resolved.duration_ms
        track.isrc = resolved.isrc
        track.mbid = resolved.extra.get("mbid")
        track.language = resolved.extra.get("language")
        track.audio_asset_id = asset.id
        track.waveform_asset_id = waveform_asset.id if waveform_asset else None
        track.loudness_lufs = info.loudness_lufs
        track.replaygain_db = info.replaygain_db
        track.status = "ready"
        track.needs_review = bool(resolved.extra.get("needs_review", False))
        track.updated_at = utcnow()

        await self.session.execute(delete(TrackArtist).where(TrackArtist.track_id == track.id))
        for index, artist in enumerate(artist_models):
            self.session.add(
                TrackArtist(
                    track_id=track.id,
                    artist_id=artist.id,
                    role="primary" if index == 0 else "featured",
                    position=index,
                )
            )

        await self._store_lyrics(track, context)
        await self.session.flush()
        if album and cover_asset:
            album.cover_asset_id = cover_asset.id
        return track

    async def _get_or_create_artist(self, name: str, mbid: str | None) -> Artist:
        normalized = normalize_text(name)
        result = await self.session.execute(select(Artist).where(Artist.name_norm == normalized))
        artist = result.scalars().first()
        if artist is None:
            artist = Artist(name=name, name_norm=normalized, mbid=mbid)
            self.session.add(artist)
            await self.session.flush()
        elif mbid and not artist.mbid:
            artist.mbid = mbid
        return artist

    async def _get_or_create_album(
        self, *, title: str, album_artist: Artist | None, year: int | None, mbid: str | None
    ) -> Album:
        normalized = normalize_text(title)
        stmt = select(Album).where(
            Album.title_norm == normalized,
            Album.album_artist_id == (album_artist.id if album_artist else None),
        )
        album = (await self.session.execute(stmt)).scalars().first()
        if album is None:
            album = Album(
                title=title,
                title_norm=normalized,
                album_artist_id=album_artist.id if album_artist else None,
                year=year,
                mbid=mbid,
            )
            self.session.add(album)
            await self.session.flush()
        return album

    async def _store_cover(
        self, album: Album | None, image: bytes, candidates: list[Any]
    ) -> Asset | None:
        import hashlib

        digest = hashlib.sha256(image).hexdigest()
        asset = (
            await self.session.execute(select(Asset).where(Asset.sha256 == digest))
        ).scalar_one_or_none()
        if asset is None:
            key = content_key("art", digest, ".jpg")
            await self.storage.upload_bytes(self.settings.r2_bucket_art, key, image, "image/jpeg")
            for size, payload in derivatives(image).items():
                await self.storage.upload_bytes(
                    self.settings.r2_bucket_art,
                    f"art/{digest}/{size}.webp",
                    payload,
                    "image/webp",
                )
            import io

            from PIL import Image

            with Image.open(io.BytesIO(image)) as picture:
                width, height = picture.size
            asset = Asset(
                kind="cover",
                bucket=self.settings.r2_bucket_art,
                storage_key=key,
                mime="image/jpeg",
                bytes=len(image),
                sha256=digest,
                width=width,
                height=height,
                source=candidates[0].provider if candidates else None,
                palette=palette(image),
                thumbhash=placeholder(image),
            )
            self.session.add(asset)
            await self.session.flush()

        if album is not None:
            for candidate in candidates:
                self.session.add(
                    CoverCandidate(
                        album_id=album.id,
                        provider=candidate.provider,
                        url=candidate.url,
                        asset_id=asset.id if candidate.image is image else None,
                        width=candidate.width,
                        height=candidate.height,
                        score=candidate.score,
                        chosen=candidate.image is image,
                    )
                )
        return asset

    async def _store_lyrics(self, track: Track, context: PipelineContext) -> None:
        kind = context.resolved.extra.get("lyrics_kind") if context.resolved else None
        if not context.lrc and not context.plain_lyrics and kind != "instrumental":
            return
        document = parse_lrc(context.lrc or "", duration_ms=track.duration_ms)
        plain = context.plain_lyrics or document.plain_text
        existing = (
            await self.session.execute(
                select(Lyrics).where(Lyrics.track_id == track.id, Lyrics.source == "lrclib")
            )
        ).scalar_one_or_none()
        if existing is None:
            existing = Lyrics(track_id=track.id, source="lrclib", kind=kind or "plain")
            self.session.add(existing)
        existing.kind = kind or ("synced" if context.lrc else "plain")
        existing.raw_lrc = context.lrc
        existing.plain_text = plain
        existing.plain_text_norm = normalize_text(plain or "")
        existing.lines = document.to_dict()["lines"]
        existing.offset_ms = existing.offset_ms or 0
        existing.fetched_at = utcnow()
        existing.recheck_at = None if context.lrc else utcnow()
