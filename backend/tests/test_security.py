"""Password hashing and JWT behaviour."""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

import jwt
import pytest

from aura.core.config import Settings
from aura.core.security import (
    create_access_token,
    decode_access_token,
    hash_password,
    hash_refresh_token,
    new_refresh_token,
    verify_password,
)


@pytest.fixture
def settings() -> Settings:
    return Settings(
        app_env="test",
        jwt_secret="x" * 40,
        database_url="postgresql+psycopg://aura:aura@localhost:5432/aura",
    )


def test_password_hash_is_argon2_and_verifies() -> None:
    hashed = hash_password("correct horse battery staple")
    assert hashed.startswith("$argon2")
    assert verify_password("correct horse battery staple", hashed)
    assert not verify_password("wrong", hashed)


def test_access_token_roundtrip(settings: Settings) -> None:
    token, expires = create_access_token(user_id="abc", settings=settings)
    claims = decode_access_token(token, settings)
    assert claims["sub"] == "abc"
    assert claims["type"] == "access"
    assert expires > datetime.now(UTC)


def test_expired_token_is_rejected(settings: Settings) -> None:
    expired = jwt.encode(
        {
            "sub": "abc",
            "type": "access",
            "exp": int((datetime.now(UTC) - timedelta(seconds=1)).timestamp()),
        },
        settings.jwt_secret,
        algorithm=settings.jwt_algorithm,
    )
    with pytest.raises(jwt.InvalidTokenError):
        decode_access_token(expired, settings)


def test_refresh_token_is_opaque_and_hashed() -> None:
    plaintext, hashed = new_refresh_token()
    assert plaintext.startswith("aura_rt_")
    assert hashed == hash_refresh_token(plaintext)
    assert hashed != plaintext
    assert len(hashed) == 64
