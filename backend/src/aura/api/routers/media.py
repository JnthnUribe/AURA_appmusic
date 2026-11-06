"""Streaming, waveform, covers and lyrics."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter, Request
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field
from sqlalchemy import select

from aura.api.deps import CurrentUser, SessionDep, SettingsDep
from aura.core.errors import NotFoundError
from aura.core.lrc import parse_lrc, plain_to_document
from aura.core.normalize import normalize_text
from aura.db.base import utcnow
from aura.db.models import Asset, CoverCandidate, Lyrics
from aura.services import library

router = APIRouter(prefix="/v1", tags=["media"])


@router.get("/tracks/{track_id}/stream")
async def stream(track_id: UUID, request: Request, session: SessionDep, user: CurrentUser):
    track = await library.get_track(session, user.id, track_id)
    if track.audio_asset_id is None:
        raise NotFoundError("Track has no audio")
    asset = await session.get(Asset, track.audio_asset_id)
    if asset is None:
        raise NotFoundError("Audio asset not found")
    storage = request.app.state.storage
    url = await storage.presign_get(asset.bucket, asset.storage_key)
    return {
        "url": url,
        "expires_in": request.app.state.settings.signed_url_ttl_seconds,
        "mime": asset.mime,
        "bytes": asset.bytes,
    }


@router.get("/tracks/{track_id}/waveform")
async def waveform(track_id: UUID, request: Request, session: SessionDep, user: CurrentUser):
    track = await library.get_track(session, user.id, track_id)
    if track.waveform_asset_id is None:
        return {"peaks": []}
    asset = await session.get(Asset, track.waveform_asset_id)
    if asset is None:
        return {"peaks": []}
    url = await request.app.state.storage.presign_get(asset.bucket, asset.storage_key)
    return {"url": url, "peaks": []}


@router.get("/albums/{album_id}/cover")
async def album_cover(
    album_id: UUID, request: Request, session: SessionDep, user: CurrentUser
) -> dict[str, object]:
    """Signed URL plus palette/thumbhash for the offline-first client."""
    album = await library.get_album(session, album_id)
    if album.cover_asset_id is None:
        raise NotFoundError("Album has no cover")
    asset = await session.get(Asset, album.cover_asset_id)
    if asset is None:
        raise NotFoundError("Cover asset not found")
    storage = request.app.state.storage
    url = await storage.presign_get(asset.bucket, asset.storage_key)
    return {
        "url": url,
        "expires_in": request.app.state.settings.signed_url_ttl_seconds,
        "width": asset.width,
        "height": asset.height,
        "mime": asset.mime,
        "palette": asset.palette,
        "thumbhash": asset.thumbhash,
    }


@router.get("/albums/{album_id}/covers")
async def covers(album_id: UUID, session: SessionDep, user: CurrentUser):
    album = await library.get_album(session, album_id)
    rows = (
        await session.execute(
            select(CoverCandidate)
            .where(CoverCandidate.album_id == album.id)
            .order_by(CoverCandidate.score.desc())
        )
    ).scalars()
    return [
        {
            "id": str(row.id),
            "provider": row.provider,
            "url": row.url,
            "width": row.width,
            "height": row.height,
            "score": row.score,
            "chosen": row.chosen,
        }
        for row in rows
    ]


class CoverChoice(BaseModel):
    candidate_id: UUID


@router.put("/albums/{album_id}/cover", status_code=204)
async def choose_cover(album_id: UUID, body: CoverChoice, session: SessionDep, user: CurrentUser):
    album = await library.get_album(session, album_id)
    candidate = await session.get(CoverCandidate, body.candidate_id)
    if candidate is None or candidate.album_id != album.id:
        raise NotFoundError("Cover candidate not found")
    rows = (
        await session.execute(select(CoverCandidate).where(CoverCandidate.album_id == album.id))
    ).scalars()
    for row in rows:
        row.chosen = row.id == candidate.id
    if candidate.asset_id:
        album.cover_asset_id = candidate.asset_id


class LyricsIn(BaseModel):
    lrc: str | None = Field(default=None, max_length=200_000)
    text: str | None = Field(default=None, max_length=200_000)
    language: str | None = Field(default=None, max_length=8)


@router.get("/tracks/{track_id}/lyrics")
async def get_lyrics(track_id: UUID, session: SessionDep, user: CurrentUser):
    track = await library.get_track(session, user.id, track_id)
    row = (
        (await session.execute(select(Lyrics).where(Lyrics.track_id == track.id))).scalars().first()
    )
    if row is None:
        raise NotFoundError("No lyrics for this track")
    return {
        "id": str(row.id),
        "kind": row.kind,
        "source": row.source,
        "language": row.language,
        "lines": row.lines,
        "offset_ms": row.offset_ms,
        "confidence": row.confidence,
        "plain_text": row.plain_text,
        "fetched_at": row.fetched_at,
    }


@router.put("/tracks/{track_id}/lyrics")
async def put_lyrics(track_id: UUID, body: LyricsIn, session: SessionDep, user: CurrentUser):
    track = await library.get_track(session, user.id, track_id)
    document = parse_lrc(body.lrc or "", duration_ms=track.duration_ms)
    plain = body.text or document.plain_text
    row = (
        await session.execute(
            select(Lyrics).where(Lyrics.track_id == track.id, Lyrics.source == "manual")
        )
    ).scalar_one_or_none()
    if row is None:
        row = Lyrics(track_id=track.id, source="manual", kind="plain")
        session.add(row)
    row.kind = "synced" if body.lrc else "plain"
    row.raw_lrc = body.lrc
    row.plain_text = plain
    row.plain_text_norm = normalize_text(plain or "")
    row.lines = (
        document.to_dict()["lines"]
        if body.lrc
        else plain_to_document(plain or "").to_dict()["lines"]
    )
    row.language = body.language or row.language
    row.fetched_at = utcnow()
    row.recheck_at = None
    await session.flush()
    return {"id": str(row.id), "kind": row.kind, "lines": row.lines}


class OffsetIn(BaseModel):
    offset_ms: int = Field(ge=-30_000, le=30_000)


@router.patch("/tracks/{track_id}/lyrics/offset")
async def patch_offset(track_id: UUID, body: OffsetIn, session: SessionDep, user: CurrentUser):
    track = await library.get_track(session, user.id, track_id)
    row = (
        (await session.execute(select(Lyrics).where(Lyrics.track_id == track.id))).scalars().first()
    )
    if row is None:
        raise NotFoundError("No lyrics for this track")
    row.offset_ms = body.offset_ms
    return {"offset_ms": row.offset_ms}


@router.post("/tracks/{track_id}/lyrics/refetch", status_code=202)
async def refetch_lyrics(track_id: UUID, request: Request, session: SessionDep, user: CurrentUser):
    from aura.services import jobs as queue

    track = await library.get_track(session, user.id, track_id)
    job = await queue.enqueue(
        session,
        user_id=user.id,
        kind="recheck_lyrics",
        payload={"track_id": str(track.id)},
        notifier=request.app.state.notifier,
    )
    return {"job_id": str(job.id)}


@router.get("/dev/media/{bucket}/{path:path}", include_in_schema=False)
async def dev_media(bucket: str, path: str, request: Request, settings: SettingsDep):
    if settings.app_env == "prod":
        raise NotFoundError()
    if "/" in path and ".." in path:
        raise NotFoundError()
    from aura.services.storage import DEV_ROOT

    target = (DEV_ROOT / bucket / path).resolve()
    if not str(target).startswith(str(DEV_ROOT.resolve())) or not target.exists():
        raise NotFoundError("Object not found")
    media_type = "application/octet-stream"
    if target.suffix == ".m4a":
        media_type = "audio/mp4"
    elif target.suffix in {".jpg", ".jpeg"}:
        media_type = "image/jpeg"
    elif target.suffix == ".webp":
        media_type = "image/webp"
    elif target.suffix == ".json":
        media_type = "application/json"
    return FileResponse(target, media_type=media_type)
