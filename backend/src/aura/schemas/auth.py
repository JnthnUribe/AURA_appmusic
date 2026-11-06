"""Auth request/response models."""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=256)


class RefreshRequest(BaseModel):
    refresh_token: str = Field(min_length=10)


class TokenPair(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"  # noqa: S105
    access_expires_at: datetime
    refresh_expires_at: datetime


class MeOut(BaseModel):
    id: UUID
    email: str
    display_name: str | None
    timezone: str
    settings: dict[str, object]
    created_at: datetime
