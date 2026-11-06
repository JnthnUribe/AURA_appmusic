"""FastAPI application factory."""

from __future__ import annotations

import time
import uuid
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from slowapi.middleware import SlowAPIMiddleware
from starlette.middleware.base import BaseHTTPMiddleware

from aura.api.deps import CurrentUser
from aura.api.limiter import limiter
from aura.api.routers import auth, health, ingest, media, playlists, stats, tracks
from aura.core.config import Settings, get_settings
from aura.core.errors import install_error_handlers
from aura.core.logging import configure_logging
from aura.db.session import create_engine, create_sessionmaker
from aura.schemas.auth import MeOut
from aura.services.jobs import WorkerNotifier
from aura.services.storage import Storage

ACCESS_LOGGER = structlog.get_logger("aura.access")


class RequestContextMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        request_id = request.headers.get("x-request-id") or str(uuid.uuid4())
        request.state.request_id = request_id
        structlog.contextvars.bind_contextvars(request_id=request_id)
        started = time.perf_counter()
        try:
            response = await call_next(request)
        finally:
            structlog.contextvars.unbind_contextvars("request_id")
        elapsed_ms = round((time.perf_counter() - started) * 1000, 2)
        response.headers["X-Request-ID"] = request_id
        response.headers["X-Response-Time-ms"] = str(elapsed_ms)
        if request.url.path not in {"/healthz", "/readyz"}:
            ACCESS_LOGGER.info(
                "request",
                method=request.method,
                path=request.url.path,
                status=response.status_code,
                ms=elapsed_ms,
            )
        return response


def create_app(settings: Settings | None = None) -> FastAPI:
    settings = settings or get_settings()
    settings.validate_runtime()
    configure_logging(settings.log_level, json_logs=settings.app_env != "dev")

    @asynccontextmanager
    async def lifespan(app: FastAPI) -> AsyncIterator[None]:
        engine = create_engine(settings)
        app.state.engine = engine
        app.state.sessionmaker = create_sessionmaker(engine)
        app.state.settings = settings
        app.state.storage = Storage(settings)
        app.state.notifier = WorkerNotifier()
        app.state.limiter = limiter
        from aura.providers.youtube_music import YouTubeMusicProvider

        app.state.youtube = YouTubeMusicProvider()

        if settings.sentry_dsn:
            import sentry_sdk

            sentry_sdk.init(
                dsn=settings.sentry_dsn,
                environment=settings.app_env,
                traces_sample_rate=0.1,
            )
        structlog.get_logger("aura.startup").info(
            "app_started", env=settings.app_env, version="0.1.0"
        )
        try:
            yield
        finally:
            await engine.dispose()

    app = FastAPI(
        title="Aura API",
        version="0.1.0",
        description="Personal music library: ingestion, covers, lyrics and playback.",
        lifespan=lifespan,
        docs_url="/docs" if settings.app_env != "prod" else None,
        redoc_url=None,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"],
        allow_headers=["Authorization", "Content-Type", "If-None-Match", "X-Request-ID"],
        expose_headers=["ETag", "X-Request-ID", "X-Response-Time-ms"],
    )
    app.add_middleware(GZipMiddleware, minimum_size=1024)
    app.add_middleware(SlowAPIMiddleware)
    app.add_middleware(RequestContextMiddleware)

    install_error_handlers(app)
    for router in (
        health.router,
        auth.router,
        tracks.router,
        playlists.router,
        media.router,
        ingest.router,
        stats.router,
    ):
        app.include_router(router)

    @app.get("/v1/me", response_model=MeOut, include_in_schema=False)
    async def me_alias(user: CurrentUser) -> MeOut:
        return MeOut(
            id=user.id,
            email=user.email,
            display_name=user.display_name,
            timezone=user.timezone,
            settings=user.settings,
            created_at=user.created_at,
        )

    return app


app = create_app()
