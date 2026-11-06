"""Worker entry point: python -m aura.worker.

Runs on a residential IP (your PC). It never opens ports. Idle behaviour is a
long-poll to the API, so the database can sleep and Neon's free compute lasts.
"""

from __future__ import annotations

import asyncio
import os
import shutil
import socket
import sys
import time
from pathlib import Path

import httpx
from sqlalchemy import select

from aura.core.config import Settings
from aura.core.logging import configure_logging, get_logger
from aura.db.models import Lyrics
from aura.db.session import create_engine, create_sessionmaker
from aura.providers.local_file import LocalFileProvider
from aura.providers.youtube_music import YouTubeMusicProvider
from aura.services import jobs as queue
from aura.services.storage import Storage
from aura.worker.pipeline import IngestionPipeline

log = get_logger("aura.worker")
WAIT_TIMEOUT = 30.0


def _keep_awake(enable: bool) -> None:
    if sys.platform != "win32":
        return
    import contextlib
    import ctypes

    ES_CONTINUOUS = 0x80000000
    ES_SYSTEM_REQUIRED = 0x00000001
    flags = ES_CONTINUOUS | (ES_SYSTEM_REQUIRED if enable else 0)
    with contextlib.suppress(Exception):
        ctypes.windll.kernel32.SetThreadExecutionState(flags)


def _maybe_update_ytdlp() -> None:
    if os.environ.get("AURA_AUTO_UPDATE_YTDLP", "1") == "0":
        return
    marker = Path.home() / ".aura" / "ytdlp-last-update"
    marker.parent.mkdir(parents=True, exist_ok=True)
    if marker.exists() and time.time() - marker.stat().st_mtime < 7 * 86400:
        return
    try:
        import subprocess

        subprocess.run(
            [sys.executable, "-m", "pip", "install", "--upgrade", "--quiet", "yt-dlp"],
            check=False,
            timeout=180,
        )
        marker.write_text(str(int(time.time())), encoding="utf-8")
    except Exception as exc:
        log.warning("ytdlp_update_failed", error=str(exc))


def _check_dependencies() -> None:
    if shutil.which("ffmpeg") is None:
        log.warning("ffmpeg_missing", detail="Install ffmpeg; downloads cannot be converted")
    if shutil.which("deno") is None:
        log.warning(
            "deno_missing",
            detail="yt-dlp >= 2025.11.12 needs a JS runtime for YouTube; install Deno",
        )


class Worker:
    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        self.worker_id = f"{socket.gethostname()}:{os.getpid()}"
        self.engine = create_engine(settings)
        self.sessionmaker = create_sessionmaker(self.engine)
        self.storage = Storage(settings)
        self.youtube = YouTubeMusicProvider()
        local_dir = Path(os.environ.get("AURA_LOCAL_MUSIC_DIR", Path.home() / "Music"))
        self.local = LocalFileProvider(local_dir)

    async def start(self) -> None:
        configure_logging(self.settings.log_level)
        _check_dependencies()
        _maybe_update_ytdlp()
        async with self.sessionmaker() as session:
            recovered = await queue.recover_stuck_jobs(session)
            pending_rechecks = await self._due_rechecks(session)
            await session.commit()
        log.info(
            "worker_started",
            worker_id=self.worker_id,
            recovered=recovered,
            rechecks=pending_rechecks,
            ytdlp=self._ytdlp_version(),
        )
        semaphore = asyncio.Semaphore(max(1, self.settings.worker_concurrency))
        await asyncio.gather(
            *(self._loop(semaphore) for _ in range(self.settings.worker_concurrency))
        )

    def _ytdlp_version(self) -> str:
        try:
            from yt_dlp.version import __version__

            return __version__
        except Exception:
            return "unknown"

    async def _loop(self, semaphore: asyncio.Semaphore) -> None:
        while True:
            async with semaphore:
                job = await self._claim()
                if job is None:
                    await self._wait_for_work()
                    continue
                await self._run_job(job)

    async def _claim(self):
        async with self.sessionmaker() as session:
            job = await queue.claim_next_job(session, self.worker_id)
            await session.commit()
            if job is not None:
                log.info("job_claimed", job_id=str(job.id), kind=job.kind)
            return job

    async def _wait_for_work(self) -> None:
        if not self.settings.worker_token:
            await asyncio.sleep(5)
            return
        try:
            async with httpx.AsyncClient(timeout=WAIT_TIMEOUT + 10) as client:
                await client.get(
                    f"{self.settings.app_base_url}/v1/internal/worker/wait",
                    params={"timeout": int(WAIT_TIMEOUT)},
                    headers={"Authorization": f"Bearer {self.settings.worker_token}"},
                )
        except httpx.HTTPError:
            await asyncio.sleep(5)

    async def _run_job(self, job) -> None:
        _keep_awake(True)
        try:
            async with self.sessionmaker() as session:
                provider = self.local if job.payload.get("provider") == "local" else self.youtube
                pipeline = IngestionPipeline(
                    session=session,
                    settings=self.settings,
                    storage=self.storage,
                    provider=provider,
                    worker_id=self.worker_id,
                )
                try:
                    result = await pipeline.run(job)
                    log.info("job_finished", job_id=str(job.id), **result)
                except Exception as exc:
                    await session.rollback()
                    await queue.fail_job(session, job.id, f"{type(exc).__name__}: {exc}")
                    await session.commit()
                    log.exception("job_failed", job_id=str(job.id), error=str(exc))
        finally:
            _keep_awake(False)

    async def _due_rechecks(self, session) -> int:
        """Enqueue lyrics rechecks that are due (7 and 30 day retries)."""
        from aura.db.base import utcnow

        result = await session.execute(
            select(Lyrics)
            .where(Lyrics.recheck_at.is_not(None), Lyrics.recheck_at <= utcnow())
            .limit(20)
        )
        count = 0
        for lyrics in result.scalars():
            job = await queue.enqueue(
                session,
                user_id=await self._track_owner(session, lyrics.track_id),
                kind="recheck_lyrics",
                payload={"track_id": str(lyrics.track_id)},
            )
            job.status = "queued"
            lyrics.recheck_at = None
            count += 1
        return count

    async def _track_owner(self, session, track_id):
        from aura.db.models import Track

        track = await session.get(Track, track_id)
        if track is None:
            raise ValueError("Track not found for lyrics recheck")
        return track.user_id


async def main() -> None:
    settings = Settings()
    settings.validate_runtime()
    worker = Worker(settings)
    try:
        await worker.start()
    finally:
        await worker.engine.dispose()


if __name__ == "__main__":
    import contextlib

    with contextlib.suppress(KeyboardInterrupt):
        asyncio.run(main())
