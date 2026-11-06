"""Async engine and session management."""

from __future__ import annotations

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from sqlalchemy import text
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from tenacity import retry, stop_after_attempt, wait_exponential_jitter

from aura.core.config import Settings


def create_engine(settings: Settings) -> AsyncEngine:
    connect_args: dict[str, object] = {
        "application_name": "aura-api",
        "prepare_threshold": None,  # Neon pooled connections (pgbouncer)
        "connect_timeout": 10,
    }
    return create_async_engine(
        settings.database_url,
        pool_size=settings.db_pool_size,
        max_overflow=settings.db_max_overflow,
        pool_pre_ping=True,
        pool_recycle=settings.db_pool_recycle_seconds,
        connect_args=connect_args,
        echo=False,
    )


def create_sessionmaker(engine: AsyncEngine) -> async_sessionmaker[AsyncSession]:
    return async_sessionmaker(engine, expire_on_commit=False, autoflush=False)


@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential_jitter(multiplier=0.3, max=3),
    reraise=True,
)
async def ping_database(engine: AsyncEngine) -> None:
    """Readiness probe. This DOES touch the database."""
    async with engine.connect() as conn:
        await conn.execute(text("SELECT 1"))


@asynccontextmanager
async def session_scope(
    sessionmaker: async_sessionmaker[AsyncSession],
) -> AsyncIterator[AsyncSession]:
    async with sessionmaker() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
