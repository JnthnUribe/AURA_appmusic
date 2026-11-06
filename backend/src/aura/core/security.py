"""Password hashing, JWT access tokens and opaque refresh tokens."""

from __future__ import annotations

import hashlib
import secrets
from datetime import UTC, datetime, timedelta
from typing import Any

import jwt
from pwdlib import PasswordHash

from aura.core.config import Settings

_password_hash = PasswordHash.recommended()
REFRESH_PREFIX = "aura_rt_"


def hash_password(password: str) -> str:
    return _password_hash.hash(password)


def verify_password(password: str, password_hash: str) -> bool:
    try:
        return _password_hash.verify(password, password_hash)
    except Exception:
        return False


def create_access_token(*, user_id: str, settings: Settings) -> tuple[str, datetime]:
    now = datetime.now(UTC)
    expires = now + timedelta(minutes=settings.access_token_minutes)
    claims: dict[str, Any] = {
        "sub": str(user_id),
        "type": "access",
        "iat": int(now.timestamp()),
        "exp": int(expires.timestamp()),
        "jti": secrets.token_urlsafe(12),
    }
    token = jwt.encode(claims, settings.jwt_secret, algorithm=settings.jwt_algorithm)
    return token, expires


def decode_access_token(token: str, settings: Settings) -> dict[str, Any]:
    claims = jwt.decode(
        token,
        settings.jwt_secret,
        algorithms=[settings.jwt_algorithm],
        options={"require": ["sub", "exp", "type"]},
    )
    if claims.get("type") != "access":
        raise jwt.InvalidTokenError("not an access token")
    return claims


def new_refresh_token() -> tuple[str, str]:
    """Return (plaintext, sha256 hash). Only the hash is stored."""
    plaintext = REFRESH_PREFIX + secrets.token_urlsafe(48)
    return plaintext, hash_refresh_token(plaintext)


def hash_refresh_token(plaintext: str) -> str:
    return hashlib.sha256(plaintext.encode()).hexdigest()


def refresh_expiry(settings: Settings) -> datetime:
    return datetime.now(UTC) + timedelta(days=settings.refresh_token_days)
