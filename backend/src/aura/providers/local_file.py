"""Local files provider: import your own MP3 / M4A / FLAC (no network)."""

from __future__ import annotations

import asyncio
import shutil
from collections.abc import Callable
from pathlib import Path
from typing import Any

from aura.providers.base import DownloadResult, ResolvedTrack, SearchResult

SUPPORTED = {".mp3", ".m4a", ".flac", ".aac", ".opus", ".ogg", ".wav"}


class LocalFileProvider:
    name = "local"

    def __init__(self, base_dir: Path) -> None:
        self.base_dir = base_dir

    async def search(self, query: str, limit: int = 10) -> list[SearchResult]:
        def _search() -> list[SearchResult]:
            if not self.base_dir.exists():
                return []
            needle = query.casefold()
            results: list[SearchResult] = []
            for path in sorted(self.base_dir.rglob("*")):
                if path.suffix.lower() not in SUPPORTED:
                    continue
                if needle and needle not in path.stem.casefold():
                    continue
                results.append(
                    SearchResult(
                        provider=self.name,
                        ref=str(path),
                        title=path.stem,
                        artists=[],
                    )
                )
                if len(results) >= limit:
                    break
            return results

        return await asyncio.to_thread(_search)

    async def resolve(self, ref: str) -> ResolvedTrack:
        path = Path(ref).resolve()  # noqa: ASYNC240 — trivial local check
        if not path.is_file() or path.suffix.lower() not in SUPPORTED:
            raise FileNotFoundError(ref)
        base = self.base_dir.resolve()
        if base not in path.parents and path != base:
            raise PermissionError("File is outside the configured music folder")
        return await asyncio.to_thread(_probe, path)

    async def download(
        self,
        track: ResolvedTrack,
        target_dir: Path,
        *,
        progress_hook: Callable[[dict[str, Any]], None] | None = None,
    ) -> DownloadResult:
        source = Path(track.ref)
        await asyncio.to_thread(target_dir.mkdir, parents=True, exist_ok=True)
        target = target_dir / source.name
        await asyncio.to_thread(shutil.copyfile, source, target)
        if progress_hook:
            progress_hook({"status": "finished", "downloaded_bytes": target.stat().st_size})
        return DownloadResult(
            path=target,
            mime="audio/flac" if source.suffix.lower() == ".flac" else "audio/mp4",
            codec=source.suffix.lstrip(".").lower(),
        )


def _probe(path: Path) -> ResolvedTrack:
    from mutagen import File as MutagenFile

    audio = MutagenFile(path, easy=True)
    title = path.stem
    artists: list[str] = []
    album = None
    track_no = None
    disc_no = None
    duration_ms = None
    if audio is not None:
        tags = audio.tags or {}
        if tags.get("title"):
            title = str(tags["title"][0])
        artists = [str(value) for value in tags.get("artist", [])]
        album = str(tags["album"][0]) if tags.get("album") else None
        try:
            track_no = int(str(tags["tracknumber"][0]).split("/")[0])
        except (KeyError, IndexError, ValueError):
            track_no = None
        try:
            disc_no = int(str(tags["discnumber"][0]).split("/")[0])
        except (KeyError, IndexError, ValueError):
            disc_no = None
        if audio.info is not None:
            duration_ms = int(audio.info.length * 1000)
    return ResolvedTrack(
        provider="local",
        ref=str(path),
        title=title,
        artists=artists,
        album=album,
        duration_ms=duration_ms,
        track_no=track_no,
        disc_no=disc_no,
    )
