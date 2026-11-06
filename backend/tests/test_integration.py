"""Integration tests against a real PostgreSQL.

Skipped automatically unless AURA_TEST_DATABASE_URL is set (CI provides one).
"""

from __future__ import annotations

import os
from datetime import UTC, datetime

import pytest
import pytest_asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import async_sessionmaker, create_async_engine

from aura.core.config import Settings
from aura.core.errors import AuthError
from aura.core.normalize import normalize_text
from aura.db.base import Base
from aura.db.models import Album, Artist, Track, TrackArtist
from aura.services import auth as auth_service
from aura.services import jobs as queue
from aura.services import library

TEST_URL = os.environ.get("AURA_TEST_DATABASE_URL")
pytestmark = pytest.mark.skipif(not TEST_URL, reason="no PostgreSQL test database")

os.environ.setdefault("JWT_SECRET", "integration-secret-that-is-long-enough")


@pytest_asyncio.fixture(loop_scope="function")
async def engine():
    assert TEST_URL
    engine = create_async_engine(TEST_URL)
    async with engine.begin() as connection:
        await connection.execute(text("CREATE EXTENSION IF NOT EXISTS pg_trgm"))
        await connection.execute(text("CREATE EXTENSION IF NOT EXISTS citext"))
    async with engine.begin() as connection:
        await connection.run_sync(Base.metadata.drop_all)
        await connection.run_sync(Base.metadata.create_all)
    yield engine
    await engine.dispose()


@pytest_asyncio.fixture
async def session(engine):
    maker = async_sessionmaker(engine, expire_on_commit=False)
    async with maker() as session:
        yield session


@pytest.fixture
def settings() -> Settings:
    return Settings(
        app_env="test",
        jwt_secret="integration-secret-that-is-long-enough",
        database_url=TEST_URL or "postgresql+psycopg://aura:aura@localhost:5432/aura",
    )


async def _make_user(session, email: str = "one@example.com"):
    user = await auth_service.create_user(
        session, email=email, password="a-very-long-password", display_name="One"
    )
    await session.flush()
    return user


async def _make_track(session, user, title: str, *, source_ref: str) -> Track:
    artist = Artist(name="Rosalía", name_norm="rosalia")
    album = Album(title="El Mal Querer", title_norm="el mal querer", year=2018)
    session.add_all([artist, album])
    await session.flush()
    track = Track(
        user_id=user.id,
        title=title,
        title_norm=normalize_text(title),
        album_id=album.id,
        source_provider="youtube_music",
        source_ref=source_ref,
        status="ready",
        added_at=datetime.now(UTC),
    )
    session.add(track)
    await session.flush()
    session.add(TrackArtist(track_id=track.id, artist_id=artist.id, role="primary", position=0))
    return track


async def test_user_isolation(session, settings) -> None:
    first = await _make_user(session, "one@example.com")
    second = await _make_user(session, "two@example.com")
    await _make_track(session, first, "Canción", source_ref="a")
    await _make_track(session, second, "Otra", source_ref="b")
    await session.commit()

    items, _ = await library.list_tracks(session, first.id)
    assert [item.title for item in items] == ["Canción"]
    items, _ = await library.list_tracks(session, second.id)
    assert [item.title for item in items] == ["Otra"]


async def test_refresh_rotation_and_reuse_detection(session, settings) -> None:
    await _make_user(session)
    await session.commit()
    pair = await auth_service.login(session, settings, "one@example.com", "a-very-long-password")
    await session.commit()

    rotated = await auth_service.rotate_refresh_token(session, settings, pair.refresh_token)
    await session.commit()
    assert rotated.refresh_token != pair.refresh_token

    with pytest.raises(AuthError):
        await auth_service.rotate_refresh_token(session, settings, pair.refresh_token)

    with pytest.raises(AuthError):
        await auth_service.rotate_refresh_token(session, settings, rotated.refresh_token)


async def test_search_handles_accents_and_typos(session) -> None:
    user = await _make_user(session)
    track = await _make_track(session, user, "Canción del Año", source_ref="c")
    first_artist = Artist(name="Rosalía", name_norm="rosalia")
    session.add(first_artist)
    await session.flush()
    session.add(
        TrackArtist(track_id=track.id, artist_id=first_artist.id, role="primary", position=1)
    )
    await session.commit()

    result = await library.search_library(session, user.id, "cancion")
    assert any(item.title == "Canción del Año" for item in result["tracks"])
    result = await library.search_library(session, user.id, "canciond")
    assert any(item.title == "Canción del Año" for item in result["tracks"])


async def test_soft_delete_tombstone(session) -> None:
    user = await _make_user(session)
    track = await _make_track(session, user, "Borrar", source_ref="d")
    await session.commit()
    await library.soft_delete_track(session, user.id, track.id)
    await session.commit()

    visible, _ = await library.list_tracks(session, user.id)
    assert visible == []
    with_tombstones, _ = await library.list_tracks(session, user.id, include_deleted=True)
    assert len(with_tombstones) == 1
    assert with_tombstones[0].deleted_at is not None


async def test_two_workers_never_claim_the_same_job(engine) -> None:
    maker = async_sessionmaker(engine, expire_on_commit=False)
    async with maker() as setup:
        user = await _make_user(setup)
        await queue.enqueue(setup, user_id=user.id, kind="ingest", payload={"ref": "a"})
        await queue.enqueue(setup, user_id=user.id, kind="ingest", payload={"ref": "b"})
        await setup.commit()

    async with maker() as first, maker() as second:
        job_a = await queue.claim_next_job(first, "worker-a")
        await first.commit()
        job_b = await queue.claim_next_job(second, "worker-b")
        await second.commit()
    assert job_a is not None and job_b is not None
    assert job_a.id != job_b.id
    assert job_a.status == "running"
    assert job_a.attempts == 1


async def test_stuck_jobs_are_recovered(engine) -> None:
    maker = async_sessionmaker(engine, expire_on_commit=False)
    async with maker() as setup:
        user = await _make_user(setup)
        job = await queue.enqueue(setup, user_id=user.id, kind="ingest", payload={"ref": "a"})
        await setup.commit()

    async with maker() as claiming:
        await queue.claim_next_job(claiming, "worker-a")
        await claiming.commit()

    async with maker() as recovering:
        recovered = await queue.recover_stuck_jobs(recovering, stale_seconds=-1)
        await recovering.commit()
    assert recovered == 1
    async with maker() as check:
        refreshed = await check.get(type(job), job.id)
        assert refreshed is not None
        assert refreshed.status == "queued"
