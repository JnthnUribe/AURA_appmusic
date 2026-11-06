"""FastAPI dependencies."""

from __future__ import annotations

from collections.abc import AsyncIterator
from typing import Annotated
from uuid import UUID

import jwt
from fastapi import Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession

from aura.core.config import Settings, get_settings
from aura.core.errors import AuthError, ForbiddenError
from aura.core.security import decode_access_token
from aura.db.models import User

bearer = HTTPBearer(auto_error=False)


async def get_session(request: Request) -> AsyncIterator[AsyncSession]:
    sessionmaker = request.app.state.sessionmaker
    async with sessionmaker() as session:
        yield session


SessionDep = Annotated[AsyncSession, Depends(get_session)]
SettingsDep = Annotated[Settings, Depends(get_settings)]


async def get_current_user(
    session: SessionDep,
    settings: SettingsDep,
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer)],
) -> User:
    if credentials is None:
        raise AuthError("Missing bearer token")
    try:
        claims = decode_access_token(credentials.credentials, settings)
        user_id = UUID(str(claims["sub"]))
    except (jwt.InvalidTokenError, ValueError, KeyError) as exc:
        raise AuthError("Invalid or expired access token") from exc
    user = await session.get(User, user_id)
    if user is None or not user.is_active:
        raise AuthError("User no longer exists")
    return user


CurrentUser = Annotated[User, Depends(get_current_user)]


async def require_worker_token(
    settings: SettingsDep,
    authorization: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer)],
) -> None:
    provided = authorization.credentials if authorization is not None else None
    if not settings.worker_token:
        raise ForbiddenError("Worker interface is disabled")
    import hmac

    if provided is None or not hmac.compare_digest(provided, settings.worker_token):
        raise AuthError("Invalid worker token")
