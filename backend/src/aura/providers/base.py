"""Interchangeable ingestion providers.

The pipeline only knows this protocol, so YouTube Music, local files, Bandcamp or
any future source can feed the same metadata / cover / lyrics stages.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Protocol, runtime_checkable


@dataclass(slots=True)
class SearchResult:
    provider: str
    ref: str
    title: str
    artists: list[str]
    album: str | None = None
    duration_ms: int | None = None
    thumbnail_url: str | None = None
    year: int | None = None


@dataclass(slots=True)
class ResolvedTrack:
    provider: str
    ref: str
    title: str
    artists: list[str]
    album: str | None = None
    album_artist: str | None = None
    duration_ms: int | None = None
    year: int | None = None
    track_no: int | None = None
    disc_no: int | None = None
    isrc: str | None = None
    thumbnail_url: str | None = None
    extra: dict[str, Any] = field(default_factory=dict)


@dataclass(slots=True)
class DownloadResult:
    path: Path
    mime: str = "audio/mp4"
    codec: str = "aac"
    bitrate_kbps: int | None = None
    source_url: str | None = None


@runtime_checkable
class SourceProvider(Protocol):
    name: str

    async def search(self, query: str, limit: int = 10) -> list[SearchResult]: ...

    async def resolve(self, ref: str) -> ResolvedTrack: ...

    async def download(self, track: ResolvedTrack, target_dir: Path) -> DownloadResult: ...


@runtime_checkable
class LyricsProvider(Protocol):
    name: str

    async def fetch(
        self,
        *,
        track_name: str,
        artist_name: str,
        album_name: str | None,
        duration_seconds: int | None,
    ) -> Any | None: ...
