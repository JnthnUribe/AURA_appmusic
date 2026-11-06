"""Postgres job queue and the in-memory wake-up signal for the worker.

The worker never polls the database: it long-polls `/v1/internal/worker/wait`,
which is pure in-memory. The database is touched once at worker startup and after
each job, keeping Neon free to scale to zero.
"""

from __future__ import annotations

import asyncio
from datetime import timedelta
from typing import Any
from uuid import UUID

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from aura.db.base import utcnow
from aura.db.models import Job


class WorkerNotifier:
    """In-process event shared by the API. No database access."""

    def __init__(self) -> None:
        self._event = asyncio.Event()

    def notify(self) -> None:
        self._event.set()

    async def wait(self, wait_seconds: float = 25.0) -> bool:
        try:
            await asyncio.wait_for(self._event.wait(), timeout=wait_seconds)
        except TimeoutError:
            return False
        self._event.clear()
        return True

    @property
    def pending(self) -> bool:
        return self._event.is_set()


async def enqueue(
    session: AsyncSession,
    *,
    user_id: UUID,
    kind: str,
    payload: dict[str, Any],
    notifier: WorkerNotifier | None = None,
) -> Job:
    job = Job(user_id=user_id, kind=kind, payload=payload, status="queued")
    session.add(job)
    await session.flush()
    if notifier is not None:
        notifier.notify()
    return job


async def claim_next_job(session: AsyncSession, worker_id: str) -> Job | None:
    """Atomically claim one queued job. Safe with N workers."""
    from sqlalchemy import text

    result = await session.execute(
        text(
            """
            UPDATE jobs SET
                status = 'running',
                locked_by = :worker_id,
                heartbeat_at = now(),
                attempts = attempts + 1,
                stage = 'claimed',
                updated_at = now()
            WHERE id = (
                SELECT id FROM jobs
                WHERE status = 'queued' AND run_after <= now()
                ORDER BY run_after ASC
                FOR UPDATE SKIP LOCKED
                LIMIT 1
            )
            RETURNING id
            """
        ),
        {"worker_id": worker_id},
    )
    row = result.first()
    if row is None:
        return None
    return await session.get(Job, row[0])


async def heartbeat(session: AsyncSession, job_id: UUID, *, stage: str, progress: float) -> None:
    await session.execute(
        update(Job)
        .where(Job.id == job_id)
        .values(stage=stage, progress=min(max(progress, 0.0), 1.0), heartbeat_at=utcnow())
    )


async def finish_job(
    session: AsyncSession, job_id: UUID, *, result: dict[str, Any] | None = None
) -> None:
    await session.execute(
        update(Job)
        .where(Job.id == job_id)
        .values(
            status="succeeded",
            stage="done",
            progress=1.0,
            result=result or {},
            finished_at=utcnow(),
            error=None,
        )
    )


async def fail_job(session: AsyncSession, job_id: UUID, error: str) -> Job | None:
    job = await session.get(Job, job_id)
    if job is None:
        return None
    if job.attempts < job.max_attempts:
        delay = min(300, 5 * 2 ** max(job.attempts - 1, 0))
        job.status = "queued"
        job.run_after = utcnow() + timedelta(seconds=delay)
        job.stage = "retry_wait"
    else:
        job.status = "failed"
        job.finished_at = utcnow()
        job.stage = "failed"
    job.error = error[:4000]
    job.locked_by = None
    job.heartbeat_at = None
    return job


async def cancel_job(session: AsyncSession, job_id: UUID) -> Job | None:
    job = await session.get(Job, job_id)
    if job is None:
        return None
    if job.status in {"queued", "running"}:
        job.status = "cancelled"
        job.finished_at = utcnow()
        job.stage = "cancelled"
    return job


async def recover_stuck_jobs(session: AsyncSession, stale_seconds: int = 120) -> int:
    cutoff = utcnow() - timedelta(seconds=stale_seconds)
    result = await session.execute(
        update(Job)
        .where(Job.status == "running", Job.heartbeat_at < cutoff)
        .values(status="queued", stage="recovered", locked_by=None, heartbeat_at=None)
    )
    return getattr(result, "rowcount", 0) or 0


async def is_cancelled(session: AsyncSession, job_id: UUID) -> bool:
    status = (
        await session.execute(select(Job.status).where(Job.id == job_id))
    ).scalar_one_or_none()
    return status == "cancelled"


async def due_lyrics_rechecks(session: AsyncSession, limit: int = 20) -> list[Job]:
    result = await session.execute(
        select(Job)
        .where(Job.kind == "recheck_lyrics", Job.status == "queued", Job.run_after <= utcnow())
        .limit(limit)
    )
    return list(result.scalars())
