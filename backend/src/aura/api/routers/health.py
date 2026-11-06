"""Health, readiness and version endpoints."""

from __future__ import annotations

import os

from fastapi import APIRouter, Request, Response

from aura import __version__
from aura.db.session import ping_database
from aura.schemas.common import VersionOut

router = APIRouter(tags=["system"])


@router.get("/healthz", include_in_schema=False)
async def healthz() -> Response:
    """Keep-alive endpoint. NEVER touches the database."""
    return Response(content='{"status":"ok"}', media_type="application/json")


@router.get("/readyz", include_in_schema=False)
async def readyz(request: Request) -> Response:
    try:
        await ping_database(request.app.state.engine)
    except Exception:
        return Response(
            content='{"status":"unavailable"}', status_code=503, media_type="application/json"
        )
    return Response(content='{"status":"ready"}', media_type="application/json")


@router.get("/v1/version", response_model=VersionOut)
async def version(request: Request) -> VersionOut:
    settings = request.app.state.settings
    return VersionOut(
        version=__version__,
        git_sha=os.environ.get("GIT_SHA", "dev"),
        environment=settings.app_env,
    )
