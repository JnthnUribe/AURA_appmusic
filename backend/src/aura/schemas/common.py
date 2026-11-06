"""Shared response schemas."""

from __future__ import annotations

from datetime import date, datetime
from typing import Generic, TypeVar
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

T = TypeVar("T")


class Schema(BaseModel):
    model_config = ConfigDict(from_attributes=True)


class Page(BaseModel, Generic[T]):  # noqa: UP046
    items: list[T]
    next_cursor: str | None = None


class ArtistRef(Schema):
    id: UUID
    name: str


class AlbumRef(Schema):
    id: UUID
    title: str
    year: int | None = None
    cover_asset_id: UUID | None = None


class AlbumOut(AlbumRef):
    album_artist: ArtistRef | None = None
    total_tracks: int | None = None
    release_date: date | None = None
    created_at: datetime
    updated_at: datetime


class ArtistOut(ArtistRef):
    sort_name: str | None = None
    image_asset_id: UUID | None = None
    created_at: datetime
    updated_at: datetime


class TrackOut(Schema):
    id: UUID
    title: str
    version: str | None = None
    title_norm: str
    album: AlbumRef | None = None
    artists: list[ArtistRef] = Field(default_factory=list)
    track_no: int | None = None
    disc_no: int | None = None
    duration_ms: int | None = None
    isrc: str | None = None
    language: str | None = None
    explicit: bool = False
    source_provider: str
    source_ref: str
    audio_asset_id: UUID | None = None
    loudness_lufs: float | None = None
    replaygain_db: float | None = None
    bpm: float | None = None
    energy: float | None = None
    status: str
    needs_review: bool
    added_at: datetime
    updated_at: datetime
    deleted_at: datetime | None = None


class TrackPatch(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    version: str | None = Field(default=None, max_length=120)
    album_id: UUID | None = None
    track_no: int | None = Field(default=None, ge=0, le=999)
    disc_no: int | None = Field(default=None, ge=0, le=99)
    language: str | None = Field(default=None, max_length=8)
    explicit: bool | None = None
    needs_review: bool | None = None


class PlaylistOut(Schema):
    id: UUID
    name: str
    description: str | None = None
    kind: str
    rules: dict[str, object] | None = None
    cover_asset_id: UUID | None = None
    created_at: datetime
    updated_at: datetime


class TagOut(Schema):
    id: UUID
    name: str
    color: str


class VersionOut(BaseModel):
    version: str
    git_sha: str
    environment: str
