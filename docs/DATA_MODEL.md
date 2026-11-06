# Aura — Data Model

PostgreSQL 17 is the source of truth. Every table uses UUIDv7 primary keys
(time-ordered, index-friendly) except join tables and caches. Timestamps are
`timestamptz` in UTC. `JSONType` maps to `JSONB` on PostgreSQL.

Schema changes only through Alembic (`backend/alembic/versions`). The initial
migration is `0001_initial.py`; ORM models live in `backend/src/aura/db/models.py`.

## Entity map

```
users ─┬─< refresh_tokens
       ├─< devices
       ├─< tracks ─┬─< track_artists >─ artists
       │           ├─< lyrics
       │           ├─< plays
       │           ├─< favorites >─ tracks
       │           ├─< track_tags >─ tags
       │           └── audio_asset / waveform_asset ──> assets
       ├─< albums ─┬─< tracks
       │           ├─< cover_candidates
       │           └── cover_asset / album_artist
       ├─< playlists ─< playlist_tracks >─ tracks
       ├─< jobs
       ├─< stats_daily
       └─< achievements
```

`assets` is shared: audio, cover, waveform and artist images are all rows in the
same table, distinguished by `kind` and `mime`.

## Core tables

### `users`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | uuid PK | UUIDv7 |
| `email` | citetext | unique, case-insensitive |
| `password_hash` | varchar(255) | Argon2id |
| `display_name` | varchar(120) | nullable |
| `settings` | jsonb | client preferences |
| `timezone` | varchar(64) | IANA name, default `UTC` |
| `is_active` | bool | soft disable |
| `created_at`, `updated_at` | timestamptz | |

Single-user in practice, multi-user in schema so the app can grow without a
migration.

### `artists`

`name`, `name_norm` (lowercase, accent-folded), `sort_name`, `mbid` (unique),
`image_asset_id → assets`. GIN trigram index on `name_norm` powers fuzzy search.

### `albums`

`title`, `title_norm`, `album_artist_id → artists`, `release_date`, `year`,
`total_tracks`, `total_discs`, `mbid` (unique), `cover_asset_id → assets`.
GIN trigram index on `title_norm`. Deleting an artist sets `album_artist_id`
to `NULL`; deleting the cover asset only clears the reference.

### `assets`

Content-addressed object metadata. One row per unique file.

| Column | Notes |
| --- | --- |
| `kind` | `audio`, `cover`, `waveform`, `artist_image` |
| `bucket`, `storage_key` | R2 location (`audio/ab/<sha256>.m4a`) |
| `mime`, `bytes` | |
| `sha256` | **unique**; deduplicates re-downloads |
| `width`, `height` | covers / images |
| `duration_ms`, `bitrate_kbps`, `codec` | audio |
| `source`, `is_upscaled` | provenance of cover art |
| `palette`, `thumbhash` | JSON palette and tiny WebP data URI |

Assets are never deleted automatically when a track is removed; the worker can
garbage-collect unreferenced keys in R2.

### `tracks`

| Column | Notes |
| --- | --- |
| `user_id` | owner, `ON DELETE CASCADE` |
| `title`, `title_norm`, `version` | display and search forms |
| `album_id` | `ON DELETE SET NULL` |
| `track_no`, `disc_no`, `duration_ms` | |
| `isrc`, `mbid`, `language`, `explicit` | |
| `source_provider`, `source_ref` | provenance (`youtube_music`, `local`, …) |
| `audio_asset_id`, `waveform_asset_id` | `ON DELETE SET NULL` |
| `loudness_lufs`, `replaygain_db`, `bpm`, `musical_key`, `energy` | analysis |
| `status` | `processing` \| `ready` \| `error` (check constraint) |
| `needs_review` | low-confidence metadata |
| `added_at`, `deleted_at` | soft delete |

Constraints and indexes:

- `UNIQUE (user_id, source_provider, source_ref)` — re-imports update the same
  track.
- `(user_id, added_at DESC)` — library feed.
- GIN trigram on `title_norm` — search.
- `deleted_at IS NULL` is applied by every library query.

`waveform_asset_id` is an addition to the original plan: the waveform is
generated before the single upload so the client can render it without a second
write.

### `track_artists`

Join table `(track_id, artist_id, role)` with `position`. Roles distinguish
primary/featured. Deleting a track cascades; deleting an artist cascades the
credit.

### `lyrics`

One row per `(track_id, source)`. Fields: `kind` (`synced`, `plain`,
`instrumental`, `aligned`), `language`, `raw_lrc`, `plain_text`,
`plain_text_norm`, `lines` (jsonb word/line timings), `offset_ms`, `confidence`,
`fetched_at`, `recheck_at`.

- `search_tsv` is a generated `tsvector` over `plain_text_norm`, GIN-indexed for
  full-text lyric search.
- Rechecks are scheduled at 7 and 30 days (`recheck_at`), then enqueued by the
  worker on start.
- `kind` is check-constrained.

### `cover_candidates`

Per album: `provider`, `url`, `asset_id`, `width`, `height`, `score`, `chosen`.
The pipeline stores every candidate, scores resolution/quality, marks one
`chosen`, and sets `albums.cover_asset_id` to the winner.

## Library features

### `playlists` / `playlist_tracks`

Playlists belong to a user, have a `kind` (`manual` \| `smart`) and optional
`rules` jsonb. Items use a float `position` so a drag can insert between rows
without renumbering. Deleting a playlist cascades its items; deleting a track
cascades the item.

Smart playlist generation is not implemented; the schema is ready for it.

### `favorites`

`(user_id, track_id)` composite PK + `created_at`. Idempotent toggle endpoints.

### `tags` / `track_tags`

Per-user tags with a hex color; unique `(user_id, name)`. Many-to-many with
tracks, both sides cascade.

## History and gamification

### `plays`

`user_id`, `track_id`, `started_at`, `ms_played`, `completed`, `source`,
`device_id`, `idempotency_key`.

- Index `(user_id, started_at DESC)` for recents and Wrapped.
- `UNIQUE (user_id, idempotency_key)` makes batch uploads retry-safe. The key is
  generated on the device per playback session.
- Client rows live in the `outbox_plays` SQLite table until acknowledged.

### `stats_daily`

Pre-aggregated per `(user_id, day)`: `plays`, `ms_played`, `unique_tracks`.
Updated when plays are ingested. Overview and Wrapped endpoints read this table
instead of scanning `plays`.

### `achievements`

`(user_id, code)` unique, `unlocked_at`, `meta` jsonb. Awarded from stats
thresholds; listing is idempotent.

## Operations

### `jobs`

The queue is a table, not an external broker.

| Column | Notes |
| --- | --- |
| `user_id`, `kind`, `payload` | `ingest`, `recheck_lyrics`, … |
| `status` | `queued` \| `running` \| `succeeded` \| `failed` \| `cancelled` |
| `stage`, `progress` | last pipeline stage and 0–1 progress |
| `attempts`, `max_attempts` | default 3 |
| `run_after` | backoff / scheduled work |
| `locked_by`, `heartbeat_at` | worker ownership and liveness |
| `error`, `result`, `finished_at` | outcome |

- Partial index on `run_after` where `status = 'queued'`.
- `(user_id, created_at DESC)` for the jobs UI.
- Claims use `FOR UPDATE SKIP LOCKED`, so multiple workers are safe.
- Stuck `running` jobs are recovered on worker start.

The API instance holds an in-process notifier; `GET /internal/worker/wait`
long-polls it. No periodic SQL polling is required.

### `refresh_tokens`

Stores only `sha256` of the refresh token, with `family_id`, `expires_at`,
`revoked_at`, `replaced_by`, `user_agent`. Rotation revokes the old row and
records the replacement. Reuse of a revoked token revokes the whole family.

### `devices`

Optional device registry: `(user_id, name)` unique, `platform`,
`last_seen_at`. Used to label play sources.

### `provider_cache`

`(provider, cache_key)` PK, `payload` jsonb, `expires_at`, `fetched_at`. Shared
cache for MusicBrainz/LRCLIB-ish lookups to respect rate limits and avoid
repeated calls. Indexed by expiry for cleanup.

## Client cache (SQLite / Drift)

The app mirrors a subset of the server, plus local-only state:

| Table | Purpose |
| --- | --- |
| `local_tracks` | library rows + `favorite`, `local_audio_path`, `cached_at` |
| `local_albums`, `local_artists` | navigation and display |
| `local_playlists`, `local_playlist_tracks` | playlist cache |
| `queue_entries` | persistent queue order |
| `playback_states` | single row (`key = 'current'`) with track, position, repeat, shuffle, speed, volume |
| `outbox_plays` | play events awaiting upload, unique `idempotency_key` |
| `cached_lyrics` | lyrics document per track |
| `sync_meta` | cursors and sync timestamps |

Rules:

- Server upserts never overwrite `favorite` or `local_audio_path`; the Drift
  companion leaves those columns absent on conflict.
- Soft-deleted tracks are excluded from every stream.
- `clear_library()` wipes cached library and lyrics, but not the queue, playback
  state, outbox or settings.

## Deletion and retention

- Library deletes are soft (`tracks.deleted_at`); the UI hides them and the
  server can purge later.
- User deletion cascades tracks, playlists, jobs, plays, tokens and devices.
- Assets and R2 objects survive track deletion until a separate GC runs; this
  prevents a re-import from re-downloading the same file.
- `provider_cache` rows expire; `refresh_tokens` are revoked, not deleted, to
  preserve reuse detection.

## Not included

- `track_embeddings` and any AI-generated metadata (phase 14 was not built).
- Home-screen widgets (phase 11) have no server-side model.
