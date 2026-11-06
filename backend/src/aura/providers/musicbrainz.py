"""MusicBrainz client with strict 1 request/second rate limiting."""

from __future__ import annotations

import asyncio
import time
from dataclasses import dataclass
from typing import Any

import httpx
from rapidfuzz import fuzz

from aura.core.normalize import normalize_text

BASE = "https://musicbrainz.org/ws/2"


@dataclass(slots=True)
class Match:
    mbid: str
    title: str
    artists: list[str]
    score: float
    release_mbid: str | None = None
    release_title: str | None = None
    year: int | None = None
    track_no: int | None = None
    disc_no: int | None = None
    isrc: str | None = None
    duration_ms: int | None = None


class MusicBrainzClient:
    def __init__(self, user_agent: str, *, client: httpx.AsyncClient | None = None) -> None:
        self.user_agent = user_agent
        self._client = client
        self._lock = asyncio.Lock()
        self._last_call = 0.0

    async def _get(self, path: str, params: dict[str, Any]) -> dict[str, Any]:
        async with self._lock:
            elapsed = time.monotonic() - self._last_call
            if elapsed < 1.0:
                await asyncio.sleep(1.0 - elapsed)
            self._last_call = time.monotonic()
            client = self._client or httpx.AsyncClient(
                timeout=12, headers={"User-Agent": self.user_agent}
            )
            try:
                response = await client.get(f"{BASE}{path}", params={**params, "fmt": "json"})
                response.raise_for_status()
                return response.json()
            finally:
                if self._client is None:
                    await client.aclose()

    async def search_recording(
        self,
        *,
        title: str,
        artist: str,
        duration_ms: int | None = None,
    ) -> Match | None:
        query = f'recording:"{title}" AND artist:"{artist}"'
        payload = await self._get("/recording", {"query": query, "limit": 5})
        best: Match | None = None
        for item in payload.get("recordings", []):
            duration = item.get("length")
            if duration_ms and duration and abs(duration - duration_ms) > 3000:
                continue
            credited = [a["artist"]["name"] for a in item.get("artist-credit", []) if "artist" in a]
            title_score = fuzz.token_set_ratio(normalize_text(title), normalize_text(item["title"]))
            artist_score = (
                max(
                    (
                        fuzz.token_set_ratio(normalize_text(artist), normalize_text(a))
                        for a in credited
                    ),
                    default=0,
                )
                if credited
                else 50
            )
            score = 0.6 * title_score + 0.4 * artist_score
            release = _pick_release(item.get("releases") or [])
            candidate = Match(
                mbid=item["id"],
                title=item["title"],
                artists=credited,
                score=score,
                release_mbid=(release or {}).get("id"),
                release_title=(release or {}).get("title"),
                year=_year(release),
                track_no=_track_number(release, item["id"]),
                disc_no=_disc_number(release, item["id"]),
                isrc=next(iter(item.get("isrcs") or []), None),
                duration_ms=duration,
            )
            if best is None or candidate.score > best.score:
                best = candidate
        if best is not None and best.score < 72:
            return None
        return best


def _pick_release(releases: list[dict[str, Any]]) -> dict[str, Any] | None:
    if not releases:
        return None
    official = [
        release
        for release in releases
        if release.get("status") == "Official"
        and release.get("release-group", {}).get("primary-type") == "Album"
    ]
    return (official or releases)[0]


def _year(release: dict[str, Any] | None) -> int | None:
    if not release or not release.get("date"):
        return None
    try:
        return int(str(release["date"])[:4])
    except ValueError:
        return None


def _medium(release: dict[str, Any] | None, recording_id: str) -> tuple[int | None, int | None]:
    if not release:
        return None, None
    for medium in release.get("media") or []:
        for track in medium.get("tracks") or []:
            if track.get("recording", {}).get("id") == recording_id:
                return track.get("number"), medium.get("position")
    return None, None


def _track_number(release: dict[str, Any] | None, recording_id: str) -> int | None:
    number, _ = _medium(release, recording_id)
    try:
        return int(str(number))
    except (TypeError, ValueError):
        return None


def _disc_number(release: dict[str, Any] | None, recording_id: str) -> int | None:
    _, position = _medium(release, recording_id)
    try:
        return int(str(position))
    except (TypeError, ValueError):
        return None
