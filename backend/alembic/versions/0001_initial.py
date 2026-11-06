"""initial schema

Revision ID: 0001_initial
Revises:
Create Date: 2026-11-01
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

revision: str = "0001_initial"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")
    op.execute("CREATE EXTENSION IF NOT EXISTS citext")
    op.execute("CREATE EXTENSION IF NOT EXISTS unaccent")

    op.create_table(
        "users",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("email", postgresql.CITEXT(), nullable=False),
        sa.Column("password_hash", sa.String(255), nullable=False),
        sa.Column("display_name", sa.String(120)),
        sa.Column(
            "settings", postgresql.JSONB(), server_default=sa.text("'{}'::jsonb"), nullable=False
        ),
        sa.Column("timezone", sa.String(64), server_default="UTC", nullable=False),
        sa.Column("is_active", sa.Boolean(), server_default=sa.true(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("id", name="pk_users"),
        sa.UniqueConstraint("email", name="uq_users_email"),
    )
    op.create_index("ix_users_email", "users", ["email"])

    op.create_table(
        "assets",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("kind", sa.String(32), nullable=False),
        sa.Column("bucket", sa.String(80), nullable=False),
        sa.Column("storage_key", sa.String(512), nullable=False),
        sa.Column("mime", sa.String(120), nullable=False),
        sa.Column("bytes", sa.BigInteger(), server_default="0", nullable=False),
        sa.Column("sha256", sa.String(64), nullable=False),
        sa.Column("width", sa.Integer()),
        sa.Column("height", sa.Integer()),
        sa.Column("duration_ms", sa.Integer()),
        sa.Column("bitrate_kbps", sa.Integer()),
        sa.Column("codec", sa.String(32)),
        sa.Column("source", sa.String(80)),
        sa.Column("is_upscaled", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column("palette", postgresql.JSONB()),
        sa.Column("thumbhash", sa.String(255)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("id", name="pk_assets"),
        sa.UniqueConstraint("sha256", name="uq_assets_sha256"),
    )
    op.create_index("ix_assets_kind", "assets", ["kind"])

    op.create_table(
        "artists",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("name_norm", sa.String(255), nullable=False),
        sa.Column("sort_name", sa.String(255)),
        sa.Column("mbid", sa.String(36)),
        sa.Column("image_asset_id", sa.Uuid()),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["image_asset_id"],
            ["assets.id"],
            name="fk_artists_image_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("id", name="pk_artists"),
        sa.UniqueConstraint("mbid", name="uq_artists_mbid"),
    )
    op.create_index("ix_artists_name_norm", "artists", ["name_norm"])
    op.create_index(
        "ix_artists_name_norm_trgm",
        "artists",
        ["name_norm"],
        postgresql_using="gin",
        postgresql_ops={"name_norm": "gin_trgm_ops"},
    )

    op.create_table(
        "albums",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("title", sa.String(255), nullable=False),
        sa.Column("title_norm", sa.String(255), nullable=False),
        sa.Column("album_artist_id", sa.Uuid()),
        sa.Column("release_date", sa.Date()),
        sa.Column("year", sa.Integer()),
        sa.Column("total_tracks", sa.Integer()),
        sa.Column("total_discs", sa.Integer()),
        sa.Column("mbid", sa.String(36)),
        sa.Column("cover_asset_id", sa.Uuid()),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["album_artist_id"],
            ["artists.id"],
            name="fk_albums_album_artist_id_artists",
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["cover_asset_id"],
            ["assets.id"],
            name="fk_albums_cover_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("id", name="pk_albums"),
        sa.UniqueConstraint("mbid", name="uq_albums_mbid"),
    )
    op.create_index("ix_albums_title_norm", "albums", ["title_norm"])
    op.create_index("ix_albums_album_artist_id", "albums", ["album_artist_id"])
    op.create_index(
        "ix_albums_title_norm_trgm",
        "albums",
        ["title_norm"],
        postgresql_using="gin",
        postgresql_ops={"title_norm": "gin_trgm_ops"},
    )

    op.create_table(
        "tracks",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("title", sa.String(255), nullable=False),
        sa.Column("title_norm", sa.String(255), nullable=False),
        sa.Column("version", sa.String(120)),
        sa.Column("album_id", sa.Uuid()),
        sa.Column("track_no", sa.Integer()),
        sa.Column("disc_no", sa.Integer()),
        sa.Column("duration_ms", sa.Integer()),
        sa.Column("isrc", sa.String(12)),
        sa.Column("mbid", sa.String(36)),
        sa.Column("explicit", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column("language", sa.String(8)),
        sa.Column("source_provider", sa.String(40), nullable=False),
        sa.Column("source_ref", sa.String(255), nullable=False),
        sa.Column("audio_asset_id", sa.Uuid()),
        sa.Column("waveform_asset_id", sa.Uuid()),
        sa.Column("loudness_lufs", sa.Float()),
        sa.Column("replaygain_db", sa.Float()),
        sa.Column("bpm", sa.Float()),
        sa.Column("musical_key", sa.String(8)),
        sa.Column("energy", sa.Float()),
        sa.Column("status", sa.String(24), server_default="processing", nullable=False),
        sa.Column("needs_review", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column(
            "added_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False
        ),
        sa.Column("deleted_at", sa.DateTime(timezone=True)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_tracks_user_id_users", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["album_id"], ["albums.id"], name="fk_tracks_album_id_albums", ondelete="SET NULL"
        ),
        sa.ForeignKeyConstraint(
            ["audio_asset_id"],
            ["assets.id"],
            name="fk_tracks_audio_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["waveform_asset_id"],
            ["assets.id"],
            name="fk_tracks_waveform_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("id", name="pk_tracks"),
        sa.UniqueConstraint("user_id", "source_provider", "source_ref", name="uq_tracks_source"),
        sa.CheckConstraint(
            "status IN ('processing','ready','error')", name="ck_tracks_track_status"
        ),
    )
    op.create_index("ix_tracks_user_added", "tracks", ["user_id", sa.text("added_at DESC")])
    op.create_index("ix_tracks_album_id", "tracks", ["album_id"])
    op.create_index(
        "ix_tracks_title_norm_trgm",
        "tracks",
        ["title_norm"],
        postgresql_using="gin",
        postgresql_ops={"title_norm": "gin_trgm_ops"},
    )

    op.create_table(
        "track_artists",
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column("artist_id", sa.Uuid(), nullable=False),
        sa.Column("role", sa.String(16), server_default="primary", nullable=False),
        sa.Column("position", sa.Integer(), server_default="0", nullable=False),
        sa.ForeignKeyConstraint(
            ["track_id"], ["tracks.id"], name="fk_track_artists_track_id_tracks", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["artist_id"],
            ["artists.id"],
            name="fk_track_artists_artist_id_artists",
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("track_id", "artist_id", "role", name="pk_track_artists"),
    )

    op.create_table(
        "cover_candidates",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("album_id", sa.Uuid(), nullable=False),
        sa.Column("provider", sa.String(40), nullable=False),
        sa.Column("url", sa.Text(), nullable=False),
        sa.Column("asset_id", sa.Uuid()),
        sa.Column("width", sa.Integer()),
        sa.Column("height", sa.Integer()),
        sa.Column("score", sa.Float(), server_default="0", nullable=False),
        sa.Column("chosen", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["album_id"],
            ["albums.id"],
            name="fk_cover_candidates_album_id_albums",
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["asset_id"],
            ["assets.id"],
            name="fk_cover_candidates_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("id", name="pk_cover_candidates"),
    )
    op.create_index("ix_cover_candidates_album", "cover_candidates", ["album_id"])

    op.create_table(
        "lyrics",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column("source", sa.String(40), nullable=False),
        sa.Column("kind", sa.String(16), server_default="plain", nullable=False),
        sa.Column("language", sa.String(8)),
        sa.Column("raw_lrc", sa.Text()),
        sa.Column("plain_text", sa.Text()),
        sa.Column("plain_text_norm", sa.Text()),
        sa.Column(
            "lines", postgresql.JSONB(), server_default=sa.text("'[]'::jsonb"), nullable=False
        ),
        sa.Column("offset_ms", sa.Integer(), server_default="0", nullable=False),
        sa.Column("confidence", sa.Float()),
        sa.Column(
            "fetched_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column("recheck_at", sa.DateTime(timezone=True)),
        sa.Column(
            "search_tsv",
            postgresql.TSVECTOR(),
            sa.Computed("to_tsvector('simple', coalesce(plain_text_norm, ''))", persisted=True),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["track_id"], ["tracks.id"], name="fk_lyrics_track_id_tracks", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_lyrics"),
        sa.UniqueConstraint("track_id", "source", name="uq_lyrics_track_source"),
        sa.CheckConstraint(
            "kind IN ('synced','plain','instrumental','aligned')", name="ck_lyrics_lyrics_kind"
        ),
    )
    op.create_index("ix_lyrics_search_tsv", "lyrics", ["search_tsv"], postgresql_using="gin")

    op.create_table(
        "playlists",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("description", sa.Text()),
        sa.Column("cover_asset_id", sa.Uuid()),
        sa.Column("kind", sa.String(16), server_default="manual", nullable=False),
        sa.Column("rules", postgresql.JSONB()),
        sa.Column("deleted_at", sa.DateTime(timezone=True)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_playlists_user_id_users", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["cover_asset_id"],
            ["assets.id"],
            name="fk_playlists_cover_asset_id_assets",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("id", name="pk_playlists"),
        sa.CheckConstraint("kind IN ('manual','smart')", name="ck_playlists_playlist_kind"),
    )
    op.create_index("ix_playlists_user", "playlists", ["user_id"])

    op.create_table(
        "playlist_tracks",
        sa.Column("playlist_id", sa.Uuid(), nullable=False),
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column("position", sa.Float(), server_default="0", nullable=False),
        sa.Column(
            "added_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["playlist_id"],
            ["playlists.id"],
            name="fk_playlist_tracks_playlist_id_playlists",
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["track_id"],
            ["tracks.id"],
            name="fk_playlist_tracks_track_id_tracks",
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("playlist_id", "track_id", name="pk_playlist_tracks"),
    )

    op.create_table(
        "favorites",
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_favorites_user_id_users", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["track_id"], ["tracks.id"], name="fk_favorites_track_id_tracks", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("user_id", "track_id", name="pk_favorites"),
    )

    op.create_table(
        "tags",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("name", sa.String(80), nullable=False),
        sa.Column("color", sa.String(9), server_default="#7C9CFF", nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_tags_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_tags"),
        sa.UniqueConstraint("user_id", "name", name="uq_tags_user_name"),
    )

    op.create_table(
        "track_tags",
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column("tag_id", sa.Uuid(), nullable=False),
        sa.ForeignKeyConstraint(
            ["track_id"], ["tracks.id"], name="fk_track_tags_track_id_tracks", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["tag_id"], ["tags.id"], name="fk_track_tags_tag_id_tags", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("track_id", "tag_id", name="pk_track_tags"),
    )

    op.create_table(
        "plays",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("track_id", sa.Uuid(), nullable=False),
        sa.Column("started_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("ms_played", sa.Integer(), server_default="0", nullable=False),
        sa.Column("completed", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column("source", sa.String(40)),
        sa.Column("device_id", sa.String(120)),
        sa.Column("idempotency_key", sa.String(64)),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_plays_user_id_users", ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["track_id"], ["tracks.id"], name="fk_plays_track_id_tracks", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_plays"),
        sa.UniqueConstraint("user_id", "idempotency_key", name="uq_plays_idempotency"),
    )
    op.create_index("ix_plays_user_started", "plays", ["user_id", sa.text("started_at DESC")])

    op.create_table(
        "stats_daily",
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("day", sa.Date(), nullable=False),
        sa.Column("plays", sa.Integer(), server_default="0", nullable=False),
        sa.Column("ms_played", sa.BigInteger(), server_default="0", nullable=False),
        sa.Column("unique_tracks", sa.Integer(), server_default="0", nullable=False),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_stats_daily_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("user_id", "day", name="pk_stats_daily"),
    )

    op.create_table(
        "achievements",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("code", sa.String(64), nullable=False),
        sa.Column(
            "unlocked_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column("meta", postgresql.JSONB()),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_achievements_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_achievements"),
        sa.UniqueConstraint("user_id", "code", name="uq_achievements_user_code"),
    )

    op.create_table(
        "jobs",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("kind", sa.String(32), nullable=False),
        sa.Column(
            "payload", postgresql.JSONB(), server_default=sa.text("'{}'::jsonb"), nullable=False
        ),
        sa.Column("status", sa.String(16), server_default="queued", nullable=False),
        sa.Column("stage", sa.String(32)),
        sa.Column("progress", sa.Float(), server_default="0", nullable=False),
        sa.Column("attempts", sa.Integer(), server_default="0", nullable=False),
        sa.Column("max_attempts", sa.Integer(), server_default="3", nullable=False),
        sa.Column(
            "run_after", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False
        ),
        sa.Column("locked_by", sa.String(120)),
        sa.Column("heartbeat_at", sa.DateTime(timezone=True)),
        sa.Column("error", sa.Text()),
        sa.Column("result", postgresql.JSONB()),
        sa.Column("finished_at", sa.DateTime(timezone=True)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_jobs_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_jobs"),
        sa.CheckConstraint(
            "status IN ('queued','running','succeeded','failed','cancelled')",
            name="ck_jobs_job_status",
        ),
    )
    op.create_index(
        "ix_jobs_queue",
        "jobs",
        ["run_after"],
        postgresql_where=sa.text("status = 'queued'"),
    )
    op.create_index("ix_jobs_user_created", "jobs", ["user_id", sa.text("created_at DESC")])

    op.create_table(
        "refresh_tokens",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("token_hash", sa.String(64), nullable=False),
        sa.Column("family_id", sa.Uuid(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("revoked_at", sa.DateTime(timezone=True)),
        sa.Column("replaced_by", sa.Uuid()),
        sa.Column("user_agent", sa.String(255)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_refresh_tokens_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_refresh_tokens"),
        sa.UniqueConstraint("token_hash", name="uq_refresh_tokens_token_hash"),
    )
    op.create_index("ix_refresh_tokens_user", "refresh_tokens", ["user_id"])

    op.create_table(
        "devices",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("name", sa.String(120), nullable=False),
        sa.Column("platform", sa.String(40), nullable=False),
        sa.Column("last_seen_at", sa.DateTime(timezone=True)),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["user_id"], ["users.id"], name="fk_devices_user_id_users", ondelete="CASCADE"
        ),
        sa.PrimaryKeyConstraint("id", name="pk_devices"),
        sa.UniqueConstraint("user_id", "name", name="uq_devices_user_name"),
    )

    op.create_table(
        "provider_cache",
        sa.Column("provider", sa.String(40), nullable=False),
        sa.Column("cache_key", sa.String(512), nullable=False),
        sa.Column("payload", postgresql.JSONB(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column(
            "fetched_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("provider", "cache_key", name="pk_provider_cache"),
    )
    op.create_index("ix_provider_cache_expires", "provider_cache", ["expires_at"])


def downgrade() -> None:
    for table in (
        "provider_cache",
        "devices",
        "refresh_tokens",
        "jobs",
        "achievements",
        "stats_daily",
        "plays",
        "track_tags",
        "tags",
        "favorites",
        "playlist_tracks",
        "playlists",
        "lyrics",
        "cover_candidates",
        "track_artists",
        "tracks",
        "albums",
        "artists",
        "assets",
        "users",
    ):
        op.drop_table(table)
    op.execute("DROP EXTENSION IF EXISTS unaccent")
    op.execute("DROP EXTENSION IF EXISTS citext")
    op.execute("DROP EXTENSION IF EXISTS pg_trgm")
