"""Authentication: login, refresh rotation with reuse detection, logout."""

from __future__ import annotations

from uuid import UUID

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession
from uuid_utils import uuid7

from aura.core.config import Settings
from aura.core.errors import AuthError
from aura.core.normalize import normalize_email
from aura.core.security import (
    create_access_token,
    hash_refresh_token,
    new_refresh_token,
    refresh_expiry,
    verify_password,
)
from aura.db.base import utcnow
from aura.db.models import RefreshToken, User
from aura.schemas.auth import TokenPair


async def get_user_by_email(session: AsyncSession, email: str) -> User | None:
    result = await session.execute(select(User).where(User.email == normalize_email(email)))
    return result.scalar_one_or_none()


async def authenticate(session: AsyncSession, email: str, password: str) -> User:
    user = await get_user_by_email(session, email)
    if user is None or not user.is_active or not verify_password(password, user.password_hash):
        raise AuthError("Email or password is incorrect")
    return user


async def _issue_pair(
    session: AsyncSession,
    settings: Settings,
    user: User,
    *,
    family_id: UUID | None = None,
    user_agent: str | None = None,
) -> TokenPair:
    access, access_exp = create_access_token(user_id=str(user.id), settings=settings)
    plaintext, token_hash = new_refresh_token()
    refresh = RefreshToken(
        user_id=user.id,
        token_hash=token_hash,
        family_id=family_id or uuid7(),
        expires_at=refresh_expiry(settings),
        user_agent=user_agent,
    )
    session.add(refresh)
    await session.flush()
    return TokenPair(
        access_token=access,
        refresh_token=plaintext,
        access_expires_at=access_exp,
        refresh_expires_at=refresh.expires_at,
    )


async def login(
    session: AsyncSession,
    settings: Settings,
    email: str,
    password: str,
    *,
    user_agent: str | None = None,
) -> TokenPair:
    user = await authenticate(session, email, password)
    return await _issue_pair(session, settings, user, user_agent=user_agent)


async def rotate_refresh_token(
    session: AsyncSession,
    settings: Settings,
    plaintext: str,
    *,
    user_agent: str | None = None,
) -> TokenPair:
    token_hash = hash_refresh_token(plaintext)
    result = await session.execute(
        select(RefreshToken).where(RefreshToken.token_hash == token_hash).with_for_update()
    )
    token = result.scalar_one_or_none()
    if token is None:
        raise AuthError("Invalid refresh token")

    now = utcnow()
    if token.revoked_at is not None:
        # Reuse of a rotated token: revoke the whole family.
        await session.execute(
            update(RefreshToken)
            .where(RefreshToken.family_id == token.family_id, RefreshToken.revoked_at.is_(None))
            .values(revoked_at=now)
        )
        await session.commit()
        raise AuthError("Refresh token already used; session revoked")

    if token.expires_at <= now:
        raise AuthError("Refresh token expired")

    user = await session.get(User, token.user_id)
    if user is None or not user.is_active:
        raise AuthError("User is not active")

    token.revoked_at = now
    pair = await _issue_pair(
        session,
        settings,
        user,
        family_id=token.family_id,
        user_agent=user_agent,
    )
    await session.flush()
    new_token = (
        await session.execute(
            select(RefreshToken).where(
                RefreshToken.token_hash == hash_refresh_token(pair.refresh_token)
            )
        )
    ).scalar_one()
    token.replaced_by = new_token.id
    return pair


async def revoke_token(session: AsyncSession, plaintext: str) -> None:
    token_hash = hash_refresh_token(plaintext)
    token = (
        await session.execute(select(RefreshToken).where(RefreshToken.token_hash == token_hash))
    ).scalar_one_or_none()
    if token is None:
        return
    await session.execute(
        update(RefreshToken)
        .where(RefreshToken.family_id == token.family_id, RefreshToken.revoked_at.is_(None))
        .values(revoked_at=utcnow())
    )


async def create_user(
    session: AsyncSession,
    *,
    email: str,
    password: str,
    display_name: str | None = None,
    timezone: str = "UTC",
) -> User:
    from aura.core.security import hash_password

    normalized = normalize_email(email)
    existing = await get_user_by_email(session, normalized)
    if existing:
        raise ValueError("A user with that email already exists")
    user = User(
        email=normalized,
        password_hash=hash_password(password),
        display_name=display_name or normalized.split("@")[0],
        timezone=timezone,
    )
    session.add(user)
    await session.flush()
    return user


async def list_active_sessions(session: AsyncSession, user_id: UUID) -> list[RefreshToken]:
    result = await session.execute(
        select(RefreshToken)
        .where(RefreshToken.user_id == user_id, RefreshToken.revoked_at.is_(None))
        .order_by(RefreshToken.created_at.desc())
    )
    return list(result.scalars())
