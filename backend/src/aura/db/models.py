"""SQLAlchemy 2.0 models. Mirrors docs/DATA_MODEL.md."""

from __future__ import annotations

from datetime import date, datetime
from typing import Any

from sqlalchemy import (
    BigInteger,
    Boolean,
    CheckConstraint,
    Computed,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    UniqueConstraint,
    Uuid,
    desc,
    func,
    text,
)
from sqlalchemy.dialects.postgresql import CITEXT, TSVECTOR
from sqlalchemy.orm import Mapped, mapped_column, relationship

from aura.db.base import Base, JSONType, TimestampMixin, UUIDPrimaryKey, new_uuid, utcnow


class User(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(
        String(320).with_variant(CITEXT(), "postgresql"), unique=True, nullable=False, index=True
    )
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    display_name: Mapped[str | None] = mapped_column(String(120))
    settings: Mapped[dict[str, Any]] = mapped_column(JSONType, default=dict, nullable=False)
    timezone: Mapped[str] = mapped_column(String(64), default="UTC", nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class Artist(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "artists"

    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_norm: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    sort_name: Mapped[str | None] = mapped_column(String(255))
    mbid: Mapped[str | None] = mapped_column(String(36), unique=True)
    image_asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )

    albums: Mapped[list[Album]] = relationship(back_populates="album_artist")

    __table_args__ = (
        Index(
            "ix_artists_name_norm_trgm",
            "name_norm",
            postgresql_using="gin",
            postgresql_ops={"name_norm": "gin_trgm_ops"},
        ),
    )


class Album(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "albums"

    title: Mapped[str] = mapped_column(String(255), nullable=False)
    title_norm: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    album_artist_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("artists.id", ondelete="SET NULL"), index=True
    )
    release_date: Mapped[date | None] = mapped_column(Date)
    year: Mapped[int | None] = mapped_column(Integer)
    total_tracks: Mapped[int | None] = mapped_column(Integer)
    total_discs: Mapped[int | None] = mapped_column(Integer)
    mbid: Mapped[str | None] = mapped_column(String(36), unique=True)
    cover_asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )

    album_artist: Mapped[Artist | None] = relationship(back_populates="albums")
    tracks: Mapped[list[Track]] = relationship(back_populates="album")

    __table_args__ = (
        Index(
            "ix_albums_title_norm_trgm",
            "title_norm",
            postgresql_using="gin",
            postgresql_ops={"title_norm": "gin_trgm_ops"},
        ),
    )


class Asset(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "assets"

    kind: Mapped[str] = mapped_column(String(32), nullable=False)
    bucket: Mapped[str] = mapped_column(String(80), nullable=False)
    storage_key: Mapped[str] = mapped_column(String(512), nullable=False)
    mime: Mapped[str] = mapped_column(String(120), nullable=False)
    bytes: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)
    sha256: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    width: Mapped[int | None] = mapped_column(Integer)
    height: Mapped[int | None] = mapped_column(Integer)
    duration_ms: Mapped[int | None] = mapped_column(Integer)
    bitrate_kbps: Mapped[int | None] = mapped_column(Integer)
    codec: Mapped[str | None] = mapped_column(String(32))
    source: Mapped[str | None] = mapped_column(String(80))
    is_upscaled: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    palette: Mapped[dict[str, Any] | None] = mapped_column(JSONType)
    thumbhash: Mapped[str | None] = mapped_column(String(255))

    __table_args__ = (Index("ix_assets_kind", "kind"),)


class Track(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "tracks"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    title_norm: Mapped[str] = mapped_column(String(255), nullable=False)
    version: Mapped[str | None] = mapped_column(String(120))
    album_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("albums.id", ondelete="SET NULL"), index=True
    )
    track_no: Mapped[int | None] = mapped_column(Integer)
    disc_no: Mapped[int | None] = mapped_column(Integer)
    duration_ms: Mapped[int | None] = mapped_column(Integer)
    isrc: Mapped[str | None] = mapped_column(String(12))
    mbid: Mapped[str | None] = mapped_column(String(36))
    explicit: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    language: Mapped[str | None] = mapped_column(String(8))
    source_provider: Mapped[str] = mapped_column(String(40), nullable=False)
    source_ref: Mapped[str] = mapped_column(String(255), nullable=False)
    audio_asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )
    waveform_asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )
    loudness_lufs: Mapped[float | None] = mapped_column(Float)
    replaygain_db: Mapped[float | None] = mapped_column(Float)
    bpm: Mapped[float | None] = mapped_column(Float)
    musical_key: Mapped[str | None] = mapped_column(String(8))
    energy: Mapped[float | None] = mapped_column(Float)
    status: Mapped[str] = mapped_column(String(24), default="processing", nullable=False)
    needs_review: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    added_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    album: Mapped[Album | None] = relationship(back_populates="tracks")
    artists: Mapped[list[TrackArtist]] = relationship(
        back_populates="track", cascade="all, delete-orphan"
    )
    audio_asset: Mapped[Asset | None] = relationship(foreign_keys=[audio_asset_id])

    __table_args__ = (
        UniqueConstraint("user_id", "source_provider", "source_ref", name="uq_tracks_source"),
        Index("ix_tracks_user_added", "user_id", desc("added_at")),
        Index(
            "ix_tracks_title_norm_trgm",
            "title_norm",
            postgresql_using="gin",
            postgresql_ops={"title_norm": "gin_trgm_ops"},
        ),
        CheckConstraint("status IN ('processing','ready','error')", name="track_status"),
    )


class TrackArtist(Base):
    __tablename__ = "track_artists"

    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), primary_key=True
    )
    artist_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("artists.id", ondelete="CASCADE"), primary_key=True
    )
    role: Mapped[str] = mapped_column(String(16), primary_key=True, default="primary")
    position: Mapped[int] = mapped_column(Integer, nullable=False, default=0)

    track: Mapped[Track] = relationship(back_populates="artists")
    artist: Mapped[Artist] = relationship()


class CoverCandidate(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "cover_candidates"

    album_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("albums.id", ondelete="CASCADE"), nullable=False
    )
    provider: Mapped[str] = mapped_column(String(40), nullable=False)
    url: Mapped[str] = mapped_column(Text, nullable=False)
    asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )
    width: Mapped[int | None] = mapped_column(Integer)
    height: Mapped[int | None] = mapped_column(Integer)
    score: Mapped[float] = mapped_column(Float, default=0.0, nullable=False)
    chosen: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)

    __table_args__ = (Index("ix_cover_candidates_album", "album_id"),)


class Lyrics(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "lyrics"

    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), nullable=False
    )
    source: Mapped[str] = mapped_column(String(40), nullable=False)
    kind: Mapped[str] = mapped_column(String(16), nullable=False, default="plain")
    language: Mapped[str | None] = mapped_column(String(8))
    raw_lrc: Mapped[str | None] = mapped_column(Text)
    plain_text: Mapped[str | None] = mapped_column(Text)
    plain_text_norm: Mapped[str | None] = mapped_column(Text)
    lines: Mapped[list[Any]] = mapped_column(JSONType, default=list, nullable=False)
    offset_ms: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    confidence: Mapped[float | None] = mapped_column(Float)
    fetched_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )
    recheck_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    search_tsv: Mapped[Any | None] = mapped_column(
        TSVECTOR,
        Computed("to_tsvector('simple', coalesce(plain_text_norm, ''))", persisted=True),
    )

    __table_args__ = (
        UniqueConstraint("track_id", "source", name="uq_lyrics_track_source"),
        Index("ix_lyrics_search_tsv", "search_tsv", postgresql_using="gin"),
        CheckConstraint("kind IN ('synced','plain','instrumental','aligned')", name="lyrics_kind"),
    )


class Playlist(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "playlists"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text)
    cover_asset_id: Mapped[Any | None] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("assets.id", ondelete="SET NULL")
    )
    kind: Mapped[str] = mapped_column(String(16), default="manual", nullable=False)
    rules: Mapped[dict[str, Any] | None] = mapped_column(JSONType)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    items: Mapped[list[PlaylistTrack]] = relationship(
        back_populates="playlist", cascade="all, delete-orphan"
    )

    __table_args__ = (
        CheckConstraint("kind IN ('manual','smart')", name="playlist_kind"),
        Index("ix_playlists_user", "user_id"),
    )


class PlaylistTrack(Base):
    __tablename__ = "playlist_tracks"

    playlist_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("playlists.id", ondelete="CASCADE"), primary_key=True
    )
    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), primary_key=True
    )
    position: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    added_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )

    playlist: Mapped[Playlist] = relationship(back_populates="items")
    track: Mapped[Track] = relationship()


class Favorite(Base):
    __tablename__ = "favorites"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), primary_key=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )


class Tag(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "tags"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    name: Mapped[str] = mapped_column(String(80), nullable=False)
    color: Mapped[str] = mapped_column(String(9), default="#7C9CFF", nullable=False)

    __table_args__ = (UniqueConstraint("user_id", "name", name="uq_tags_user_name"),)


class TrackTag(Base):
    __tablename__ = "track_tags"

    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), primary_key=True
    )
    tag_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tags.id", ondelete="CASCADE"), primary_key=True
    )


class Play(UUIDPrimaryKey, Base):
    __tablename__ = "plays"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    track_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("tracks.id", ondelete="CASCADE"), nullable=False
    )
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    ms_played: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    completed: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    source: Mapped[str | None] = mapped_column(String(40))
    device_id: Mapped[str | None] = mapped_column(String(120))
    idempotency_key: Mapped[str | None] = mapped_column(String(64))

    __table_args__ = (
        Index("ix_plays_user_started", "user_id", desc("started_at")),
        UniqueConstraint("user_id", "idempotency_key", name="uq_plays_idempotency"),
    )


class StatsDaily(Base):
    __tablename__ = "stats_daily"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    day: Mapped[date] = mapped_column(Date, primary_key=True)
    plays: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    ms_played: Mapped[int] = mapped_column(BigInteger, default=0, nullable=False)
    unique_tracks: Mapped[int] = mapped_column(Integer, default=0, nullable=False)


class Achievement(UUIDPrimaryKey, Base):
    __tablename__ = "achievements"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    code: Mapped[str] = mapped_column(String(64), nullable=False)
    unlocked_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )
    meta: Mapped[dict[str, Any] | None] = mapped_column(JSONType)

    __table_args__ = (UniqueConstraint("user_id", "code", name="uq_achievements_user_code"),)


class Job(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "jobs"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    kind: Mapped[str] = mapped_column(String(32), nullable=False)
    payload: Mapped[dict[str, Any]] = mapped_column(JSONType, default=dict, nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="queued", nullable=False)
    stage: Mapped[str | None] = mapped_column(String(32))
    progress: Mapped[float] = mapped_column(Float, default=0.0, nullable=False)
    attempts: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    max_attempts: Mapped[int] = mapped_column(Integer, default=3, nullable=False)
    run_after: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )
    locked_by: Mapped[str | None] = mapped_column(String(120))
    heartbeat_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    error: Mapped[str | None] = mapped_column(Text)
    result: Mapped[dict[str, Any] | None] = mapped_column(JSONType)
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    __table_args__ = (
        Index(
            "ix_jobs_queue",
            "run_after",
            postgresql_where=text("status = 'queued'"),
        ),
        Index("ix_jobs_user_created", "user_id", desc("created_at")),
        CheckConstraint(
            "status IN ('queued','running','succeeded','failed','cancelled')", name="job_status"
        ),
    )


class RefreshToken(UUIDPrimaryKey, Base):
    __tablename__ = "refresh_tokens"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    token_hash: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    family_id: Mapped[Any] = mapped_column(Uuid(as_uuid=True), default=new_uuid, nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    replaced_by: Mapped[Any | None] = mapped_column(Uuid(as_uuid=True))
    user_agent: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )

    __table_args__ = (Index("ix_refresh_tokens_user", "user_id"),)


class Device(UUIDPrimaryKey, TimestampMixin, Base):
    __tablename__ = "devices"

    user_id: Mapped[Any] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    platform: Mapped[str] = mapped_column(String(40), nullable=False)
    last_seen_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    __table_args__ = (UniqueConstraint("user_id", "name", name="uq_devices_user_name"),)


class ProviderCache(Base):
    __tablename__ = "provider_cache"

    provider: Mapped[str] = mapped_column(String(40), primary_key=True)
    cache_key: Mapped[str] = mapped_column(String(512), primary_key=True)
    payload: Mapped[dict[str, Any]] = mapped_column(JSONType, nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    fetched_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, server_default=func.now(), nullable=False
    )

    __table_args__ = (Index("ix_provider_cache_expires", "expires_at"),)
