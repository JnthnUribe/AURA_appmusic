"""Auth endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Request

from aura.api.deps import CurrentUser, SessionDep, SettingsDep
from aura.api.limiter import limiter
from aura.schemas.auth import LoginRequest, MeOut, RefreshRequest, TokenPair
from aura.services import auth as auth_service

router = APIRouter(prefix="/v1/auth", tags=["auth"])


@router.post("/login", response_model=TokenPair)
@limiter.limit("5/minute")
async def login(
    request: Request,
    body: LoginRequest,
    session: SessionDep,
    settings: SettingsDep,
) -> TokenPair:
    return await auth_service.login(
        session,
        settings,
        body.email,
        body.password,
        user_agent=request.headers.get("user-agent"),
    )


@router.post("/refresh", response_model=TokenPair)
@limiter.limit("30/minute")
async def refresh(
    request: Request,
    body: RefreshRequest,
    session: SessionDep,
    settings: SettingsDep,
) -> TokenPair:
    return await auth_service.rotate_refresh_token(
        session,
        settings,
        body.refresh_token,
        user_agent=request.headers.get("user-agent"),
    )


@router.post("/logout", status_code=204)
async def logout(
    body: RefreshRequest,
    session: SessionDep,
    user: CurrentUser,
) -> None:
    await auth_service.revoke_token(session, body.refresh_token)


@router.get("/me", response_model=MeOut, tags=["me"])
async def me(user: CurrentUser) -> MeOut:
    return MeOut(
        id=user.id,
        email=user.email,
        display_name=user.display_name,
        timezone=user.timezone,
        settings=user.settings,
        created_at=user.created_at,
    )
