"""Ingestion, jobs and the internal worker wake-up channel."""

from __future__ import annotations

import asyncio
import json
import re
import uuid
from collections.abc import AsyncIterator
from datetime import datetime
from pathlib import Path
from typing import Annotated

from fastapi import APIRouter, Depends, Query, Request
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import select

from aura.api.deps import CurrentUser, SessionDep, require_worker_token
from aura.core.errors import AppError, NotFoundError
from aura.db.models import Job
from aura.services import jobs as queue
from aura.services.storage import content_key

router = APIRouter(prefix="/v1", tags=["ingest"])

YOUTUBE_ID = re.compile(r"^[A-Za-z0-9_-]{11}$")
ALLOWED_URL = re.compile(
    r"^https?://(?:www\.|music\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([A-Za-z0-9_-]{11})"
)


class SearchIn(BaseModel):
    query: str = Field(min_length=1, max_length=200)


class IngestIn(BaseModel):
    provider: str = Field(default="youtube_music", pattern="^(youtube_music|local)$")
    ref: str = Field(min_length=1, max_length=500)


class ImportIn(BaseModel):
    filename: str = Field(min_length=1, max_length=255)


class ImportCompleteIn(BaseModel):
    storage_key: str = Field(min_length=1, max_length=500)
    title: str | None = Field(default=None, max_length=255)
    artists: list[str] = Field(default_factory=list)
    album: str | None = None
    duration_ms: int | None = Field(default=None, ge=0)


class JobOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    kind: str
    status: str
    stage: str | None
    progress: float
    attempts: int
    error: str | None
    result: dict | None
    created_at: datetime


@router.post("/ingest/search")
async def ingest_search(body: SearchIn, request: Request, user: CurrentUser):
    provider = request.app.state.youtube
    try:
        results = await provider.search(body.query, limit=10)
    except Exception as exc:
        raise AppError(502, "Upstream error", f"YouTube Music search failed: {exc}") from exc
    return [
        {
            "provider": item.provider,
            "ref": item.ref,
            "title": item.title,
            "artists": item.artists,
            "album": item.album,
            "duration_ms": item.duration_ms,
            "thumbnail_url": item.thumbnail_url,
            "year": item.year,
        }
        for item in results
    ]


@router.post("/ingest", status_code=202)
async def start_ingest(body: IngestIn, request: Request, session: SessionDep, user: CurrentUser):
    ref = body.ref.strip()
    if body.provider == "youtube_music":
        if not YOUTUBE_ID.match(ref):
            match = ALLOWED_URL.match(ref)
            if not match:
                raise AppError(400, "Invalid reference", "Send a YouTube video id or URL")
            ref = match.group(1)
    else:
        if not ref.startswith(("/", "\\")) and ":" not in ref:
            raise AppError(400, "Invalid local path")
    job = await queue.enqueue(
        session,
        user_id=user.id,
        kind="ingest",
        payload={"provider": body.provider, "ref": ref},
        notifier=request.app.state.notifier,
    )
    return {"job_id": str(job.id), "status": job.status}


@router.post("/import", status_code=201)
async def prepare_import(body: ImportIn, request: Request, user: CurrentUser):
    suffix = Path(body.filename).suffix.lower() or ".mp3"
    key = content_key("imports", uuid.uuid4().hex, suffix)
    url = await request.app.state.storage.presign_put(
        request.app.state.settings.r2_bucket_audio, key
    )
    return {"upload_url": url, "storage_key": key, "method": "PUT"}


@router.post("/import/complete", status_code=202)
async def complete_import(
    body: ImportCompleteIn, request: Request, session: SessionDep, user: CurrentUser
):
    if not body.storage_key.startswith("imports/"):
        raise AppError(400, "Invalid storage key")
    job = await queue.enqueue(
        session,
        user_id=user.id,
        kind="ingest",
        payload={
            "provider": "upload",
            "storage_key": body.storage_key,
            "title": body.title,
            "artists": body.artists,
            "album": body.album,
            "duration_ms": body.duration_ms,
        },
        notifier=request.app.state.notifier,
    )
    return {"job_id": str(job.id), "status": job.status}


@router.get("/jobs", response_model=list[JobOut])
async def list_jobs(
    session: SessionDep,
    user: CurrentUser,
    status: str | None = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 30,
):
    stmt = select(Job).where(Job.user_id == user.id).order_by(Job.created_at.desc()).limit(limit)
    if status:
        stmt = stmt.where(Job.status == status)
    return list((await session.execute(stmt)).scalars())


async def _owned_job(session, user_id, job_id) -> Job:
    job = await session.get(Job, job_id)
    if job is None or job.user_id != user_id:
        raise NotFoundError("Job not found")
    return job


@router.get("/jobs/{job_id}", response_model=JobOut)
async def get_job(job_id: uuid.UUID, session: SessionDep, user: CurrentUser):
    return await _owned_job(session, user.id, job_id)


@router.get("/jobs/{job_id}/events")
async def job_events(job_id: uuid.UUID, request: Request, session: SessionDep, user: CurrentUser):
    await _owned_job(session, user.id, job_id)

    async def stream() -> AsyncIterator[str]:
        terminal = {"succeeded", "failed", "cancelled"}
        last = None
        while True:
            if await request.is_disconnected():
                break
            job = await _owned_job(session, user.id, job_id)
            payload = {
                "id": str(job.id),
                "status": job.status,
                "stage": job.stage,
                "progress": job.progress,
                "error": job.error,
                "result": job.result,
            }
            serialized = json.dumps(payload, default=str)
            if serialized != last:
                last = serialized
                yield f"event: progress\ndata: {serialized}\n\n"
            if job.status in terminal:
                yield f"event: done\ndata: {serialized}\n\n"
                break
            await asyncio.sleep(2)
        yield ": heartbeat\n\n"

    return StreamingResponse(
        stream(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@router.post("/jobs/{job_id}/cancel", status_code=202)
async def cancel_job(job_id: uuid.UUID, session: SessionDep, user: CurrentUser):
    await _owned_job(session, user.id, job_id)
    job = await queue.cancel_job(session, job_id)
    return {"status": job.status if job else "missing"}


@router.post("/jobs/{job_id}/retry", status_code=202)
async def retry_job(job_id: uuid.UUID, request: Request, session: SessionDep, user: CurrentUser):
    job = await _owned_job(session, user.id, job_id)
    if job.status not in {"failed", "cancelled"}:
        raise AppError(409, "Job is not finished", "Only failed or cancelled jobs can be retried")
    job.status = "queued"
    job.attempts = 0
    job.error = None
    job.stage = None
    job.progress = 0.0
    from aura.db.base import utcnow

    job.run_after = utcnow()
    request.app.state.notifier.notify()
    return {"status": job.status}


@router.get("/internal/worker/wait", dependencies=[Depends(require_worker_token)])
async def worker_wait(
    request: Request,
    timeout: Annotated[float, Query(ge=1, le=30)] = 25,  # noqa: ASYNC109 — public query name
) -> dict[str, bool]:
    """Long-poll for the worker. Pure in-memory: never touches the database."""
    wake = await request.app.state.notifier.wait(wait_seconds=timeout)
    return {"wake": wake}
