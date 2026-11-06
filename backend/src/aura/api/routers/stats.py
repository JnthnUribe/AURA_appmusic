"""Playback events, statistics, streaks and achievements."""

from __future__ import annotations

from datetime import UTC, date, datetime, timedelta
from uuid import UUID
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Query
from pydantic import BaseModel, Field
from sqlalchemy import func, select

from aura.api.deps import CurrentUser, SessionDep
from aura.db.models import Achievement, Play, StatsDaily, Track
from aura.schemas.common import TrackOut
from aura.services import library
from aura.services.serializers import track_out

router = APIRouter(prefix="/v1", tags=["stats"])


class PlayIn(BaseModel):
    track_id: UUID
    started_at: datetime
    ms_played: int = Field(ge=0)
    completed: bool = False
    source: str | None = None
    device_id: str | None = None
    idempotency_key: str | None = Field(default=None, max_length=64)


class PlaysBatchIn(BaseModel):
    plays: list[PlayIn] = Field(max_length=200)


class OverviewOut(BaseModel):
    range: str
    plays: int
    minutes: float
    unique_tracks: int
    streak_days: int
    top_tracks: list[TrackOut]
    top_artists: list[dict]


@router.post("/plays/batch", status_code=202)
async def plays_batch(body: PlaysBatchIn, session: SessionDep, user: CurrentUser):
    accepted = 0
    timezone = ZoneInfo(user.timezone or "UTC")
    for item in body.plays:
        if item.idempotency_key:
            existing = (
                await session.execute(
                    select(Play.id).where(
                        Play.user_id == user.id,
                        Play.idempotency_key == item.idempotency_key,
                    )
                )
            ).first()
            if existing:
                continue
        track = await session.get(Track, item.track_id)
        if track is None or track.user_id != user.id:
            continue
        session.add(
            Play(
                user_id=user.id,
                track_id=item.track_id,
                started_at=item.started_at,
                ms_played=item.ms_played,
                completed=item.completed,
                source=item.source,
                device_id=item.device_id,
                idempotency_key=item.idempotency_key,
            )
        )
        day = item.started_at.astimezone(timezone).date()
        daily = await session.get(StatsDaily, {"user_id": user.id, "day": day})
        if daily is None:
            daily = StatsDaily(user_id=user.id, day=day, plays=0, ms_played=0, unique_tracks=0)
            session.add(daily)
        daily.plays += 1
        daily.ms_played += item.ms_played
        accepted += 1
    return {"accepted": accepted}


@router.get("/stats/overview", response_model=OverviewOut)
async def overview(
    session: SessionDep,
    user: CurrentUser,
    range: str = Query(default="30d", pattern="^(7d|30d|90d|all)$"),
):
    since = _range_start(range)
    stmt = select(Play).where(Play.user_id == user.id)
    if since:
        stmt = stmt.where(Play.started_at >= since)
    plays = list((await session.execute(stmt)).scalars())
    top_counts: dict[UUID, int] = {}
    for play in plays:
        top_counts[play.track_id] = top_counts.get(play.track_id, 0) + 1
    top_ids = sorted(top_counts, key=top_counts.get, reverse=True)[:10]  # type: ignore[arg-type]
    top_tracks: list[TrackOut] = []
    artist_counter: dict[str, int] = {}
    for track_id in top_ids:
        try:
            top_tracks.append(track_out(await library.get_track(session, user.id, track_id)))
        except Exception:  # noqa: S112 — deleted tracks are skipped
            continue
    for track in top_tracks:
        for artist in track.artists:
            artist_counter[artist.name] = artist_counter.get(artist.name, 0) + top_counts[track.id]
    return OverviewOut(
        range=range,
        plays=len(plays),
        minutes=round(sum(play.ms_played for play in plays) / 60000, 1),
        unique_tracks=len(top_counts),
        streak_days=await _streak(session, user.id, timezone=ZoneInfo(user.timezone or "UTC")),
        top_tracks=top_tracks,
        top_artists=[
            {"name": name, "plays": count}
            for name, count in sorted(artist_counter.items(), key=lambda kv: kv[1], reverse=True)[
                :10
            ]
        ],
    )


@router.get("/stats/wrapped")
async def wrapped(session: SessionDep, user: CurrentUser, year: int = Query(ge=2000, le=2100)):
    start = datetime(year, 1, 1, tzinfo=UTC)
    end = datetime(year + 1, 1, 1, tzinfo=UTC)
    plays = list(
        (
            await session.execute(
                select(Play).where(
                    Play.user_id == user.id, Play.started_at >= start, Play.started_at < end
                )
            )
        ).scalars()
    )
    counts: dict[UUID, int] = {}
    hours = [0] * 24
    for play in plays:
        counts[play.track_id] = counts.get(play.track_id, 0) + 1
        hours[play.started_at.hour] += 1
    top = sorted(counts.items(), key=lambda item: item[1], reverse=True)[:10]
    tracks = []
    for track_id, count in top:
        try:
            track = track_out(await library.get_track(session, user.id, track_id))
        except Exception:  # noqa: S112 — deleted tracks are skipped
            continue
        tracks.append({**track.model_dump(), "plays": count})
    daily = list(
        (
            await session.execute(
                select(StatsDaily).where(
                    StatsDaily.user_id == user.id,
                    StatsDaily.day >= date(year, 1, 1),
                    StatsDaily.day < date(year + 1, 1, 1),
                )
            )
        ).scalars()
    )
    return {
        "year": year,
        "plays": len(plays),
        "minutes": round(sum(play.ms_played for play in plays) / 60000, 1),
        "unique_tracks": len(counts),
        "top_tracks": tracks,
        "busiest_hour": hours.index(max(hours)) if any(hours) else None,
        "active_days": len(daily),
    }


@router.get("/achievements")
async def achievements(session: SessionDep, user: CurrentUser):
    unlocked = {
        row.code: row
        for row in (
            await session.execute(select(Achievement).where(Achievement.user_id == user.id))
        ).scalars()
    }
    total_plays = (
        await session.execute(select(func.count(Play.id)).where(Play.user_id == user.id))
    ).scalar() or 0
    streak = await _streak(session, user.id, timezone=ZoneInfo(user.timezone or "UTC"))
    candidates = [
        ("first_100", "100 canciones", total_plays >= 100, {"plays": total_plays}),
        ("streak_7", "Racha de 7 días", streak >= 7, {"streak": streak}),
        ("night_owl", "Búho nocturno", await _night_owl(session, user.id), {}),
    ]
    for code, _title, condition, meta in candidates:
        if condition and code not in unlocked:
            row = Achievement(user_id=user.id, code=code, meta=meta)
            session.add(row)
            unlocked[code] = row
    return [
        {
            "code": code,
            "title": title,
            "unlocked": code in unlocked,
            "unlocked_at": unlocked[code].unlocked_at if code in unlocked else None,
        }
        for code, title, _, _ in candidates
    ]


async def _night_owl(session, user_id: UUID) -> bool:
    row = (
        await session.execute(
            select(Play.id)
            .where(
                Play.user_id == user_id,
                func.extract("hour", Play.started_at).between(0, 4),
            )
            .limit(1)
        )
    ).first()
    return row is not None


async def _streak(session, user_id: UUID, *, timezone: ZoneInfo) -> int:
    rows = list(
        (
            await session.execute(
                select(StatsDaily.day)
                .where(StatsDaily.user_id == user_id, StatsDaily.ms_played >= 600_000)
                .order_by(StatsDaily.day.desc())
            )
        ).scalars()
    )
    if not rows:
        return 0
    today = datetime.now(timezone).date()
    streak = 0
    expected = today if rows[0] == today else today - timedelta(days=1)
    for day in rows:
        if day == expected:
            streak += 1
            expected -= timedelta(days=1)
        elif day < expected:
            break
    return streak


def _range_start(range: str) -> datetime | None:
    now = datetime.now(UTC)
    return {
        "7d": now - timedelta(days=7),
        "30d": now - timedelta(days=30),
        "90d": now - timedelta(days=90),
        "all": None,
    }[range]
