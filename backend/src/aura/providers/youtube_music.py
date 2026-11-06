"""YouTube Music provider: search with ytmusicapi, download with yt-dlp."""

from __future__ import annotations

import asyncio
import os
from collections.abc import Callable
from pathlib import Path
from typing import Any, cast

from aura.providers.base import DownloadResult, ResolvedTrack, SearchResult

YOUTUBE_ID = r"^[A-Za-z0-9_-]{11}$"


class ProviderError(RuntimeError):
    pass


class YouTubeMusicProvider:
    name = "youtube_music"

    def __init__(self) -> None:
        self._ytm: Any | None = None

    def _client(self) -> Any:
        if self._ytm is None:
            from ytmusicapi import YTMusic

            self._ytm = YTMusic()
        return self._ytm

    async def search(self, query: str, limit: int = 10) -> list[SearchResult]:
        def _search() -> list[SearchResult]:
            raw = self._client().search(query, filter="songs", limit=limit)
            results: list[SearchResult] = []
            for item in raw:
                video_id = item.get("videoId")
                if not video_id:
                    continue
                results.append(
                    SearchResult(
                        provider=self.name,
                        ref=video_id,
                        title=item.get("title", ""),
                        artists=[a.get("name", "") for a in item.get("artists") or []],
                        album=(item.get("album") or {}).get("name"),
                        duration_ms=_seconds_to_ms(item.get("duration_seconds")),
                        thumbnail_url=_best_thumb(item.get("thumbnails") or []),
                        year=item.get("year"),
                    )
                )
            return results

        return await asyncio.to_thread(_search)

    async def resolve(self, ref: str) -> ResolvedTrack:
        def _resolve() -> ResolvedTrack:
            song = self._client().get_song(ref)
            if not song:
                raise ProviderError(f"YouTube Music has no song for {ref}")
            details = song.get("videoDetails") or {}
            album = song.get("album")
            return ResolvedTrack(
                provider=self.name,
                ref=ref,
                title=details.get("title") or song.get("title") or "",
                artists=_split_artists(details.get("author")),
                album=album,
                album_artist=None,
                duration_ms=_seconds_to_ms(details.get("lengthSeconds")),
                thumbnail_url=_best_thumb(song.get("thumbnails") or []),
                extra={"video_id": ref},
            )

        return await asyncio.to_thread(_resolve)

    async def download(
        self,
        track: ResolvedTrack,
        target_dir: Path,
        *,
        progress_hook: Callable[[dict[str, Any]], None] | None = None,
    ) -> DownloadResult:
        await asyncio.to_thread(target_dir.mkdir, parents=True, exist_ok=True)
        output = target_dir / f"{track.ref}.%(ext)s"

        def _download() -> DownloadResult:
            import yt_dlp

            def _hook(data: dict[str, Any]) -> None:
                if progress_hook and data.get("status") == "downloading":
                    progress_hook(data)

            options: dict[str, Any] = {
                "format": "bestaudio[ext=m4a]/bestaudio",
                "outtmpl": str(output),
                "noplaylist": True,
                "quiet": True,
                "no_warnings": True,
                "socket_timeout": 30,
                "retries": 3,
                "fragment_retries": 3,
                "progress_hooks": [_hook],
                "nopostoverwrites": False,
                "paths": {"home": str(target_dir)},
            }
            if os.environ.get("AURA_YTDLP_COOKIES"):
                options["cookiefile"] = os.environ["AURA_YTDLP_COOKIES"]
            with yt_dlp.YoutubeDL(cast(Any, options)) as ydl:
                info = ydl.extract_info(
                    f"https://music.youtube.com/watch?v={track.ref}", download=True
                )
                if info is None:
                    raise ProviderError("yt-dlp returned no information")
                path = Path(ydl.prepare_filename(info))
            if not path.exists():
                candidates = list(target_dir.glob(f"{track.ref}.*"))
                if not candidates:
                    raise ProviderError("Download finished but no file was found")
                path = candidates[0]
            return DownloadResult(
                path=path,
                mime="audio/mp4" if path.suffix == ".m4a" else "audio/webm",
                codec="aac" if path.suffix == ".m4a" else "opus",
                source_url=f"https://music.youtube.com/watch?v={track.ref}",
            )

        return await asyncio.to_thread(_download)


def _seconds_to_ms(value: Any) -> int | None:
    try:
        return int(float(value) * 1000) if value is not None else None
    except (TypeError, ValueError):
        return None


def _best_thumb(thumbs: list[dict[str, Any]]) -> str | None:
    if not thumbs:
        return None
    ordered = sorted(thumbs, key=lambda item: (item.get("width") or 0) * (item.get("height") or 0))
    return ordered[-1].get("url")


def _split_artists(value: Any) -> list[str]:
    if not value:
        return []
    if isinstance(value, list):
        return [str(item) for item in value]
    return [part.strip() for part in str(value).split(",") if part.strip()]
