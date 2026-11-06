"""LRCLIB client: synced lyrics with a search fallback."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import httpx
from rapidfuzz import fuzz

from aura.core.normalize import normalize_text

BASE = "https://lrclib.net/api"


@dataclass(slots=True)
class LyricsResult:
    source: str
    kind: str
    raw_lrc: str | None
    plain_text: str | None
    language: str | None = None
    confidence: float | None = None
    instrumental: bool = False


class LRCLIBProvider:
    name = "lrclib"

    def __init__(self, user_agent: str, *, client: httpx.AsyncClient | None = None) -> None:
        self.user_agent = user_agent
        self._client = client

    async def fetch(
        self,
        *,
        track_name: str,
        artist_name: str,
        album_name: str | None,
        duration_seconds: int | None,
    ) -> LyricsResult | None:
        headers = {"User-Agent": self.user_agent}
        client = self._client or httpx.AsyncClient(timeout=15, headers=headers)
        try:
            response = await client.get(
                f"{BASE}/get",
                params={
                    "track_name": track_name,
                    "artist_name": artist_name,
                    "album_name": album_name or "",
                    "duration": duration_seconds or 0,
                },
            )
            if response.status_code == 200:
                return _to_result(response.json(), confidence=1.0)
            if response.status_code != 404:
                return None
            return await self._search(client, track_name, artist_name, duration_seconds)
        finally:
            if self._client is None:
                await client.aclose()

    async def _search(
        self,
        client: httpx.AsyncClient,
        track_name: str,
        artist_name: str,
        duration_seconds: int | None,
    ) -> LyricsResult | None:
        response = await client.get(
            f"{BASE}/search",
            params={"track_name": track_name, "artist_name": artist_name},
        )
        if response.status_code != 200:
            return None
        best: tuple[float, dict[str, Any]] | None = None
        for item in response.json():
            if (
                duration_seconds
                and item.get("duration")
                and abs(float(item["duration"]) - duration_seconds) > 2
            ):
                continue
            title_score = fuzz.token_set_ratio(
                normalize_text(track_name), normalize_text(item.get("trackName", ""))
            )
            artist_score = fuzz.token_set_ratio(
                normalize_text(artist_name), normalize_text(item.get("artistName", ""))
            )
            score = 0.6 * title_score + 0.4 * artist_score
            if best is None or score > best[0]:
                best = (score, item)
        if best is None or best[0] < 70:
            return None
        return _to_result(best[1], confidence=round(best[0] / 100, 3))


def _to_result(item: dict[str, Any], *, confidence: float) -> LyricsResult | None:
    if item.get("instrumental"):
        return LyricsResult(
            source="lrclib",
            kind="instrumental",
            raw_lrc=None,
            plain_text=None,
            confidence=confidence,
            instrumental=True,
        )
    synced = item.get("syncedLyrics")
    plain = item.get("plainLyrics")
    if synced:
        return LyricsResult(
            source="lrclib",
            kind="synced",
            raw_lrc=synced,
            plain_text=plain,
            confidence=confidence,
        )
    if plain:
        return LyricsResult(
            source="lrclib",
            kind="plain",
            raw_lrc=None,
            plain_text=plain,
            confidence=confidence,
        )
    return None
