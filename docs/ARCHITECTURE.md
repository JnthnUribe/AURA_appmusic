# Aura — Architecture

Aura is a personal, single-user (multi-user schema) music system. It downloads
audio on a home PC, enriches it, stores it in Cloudflare R2, and serves a Flutter
client that works offline.

```
┌──────────────────────────────┐        ┌──────────────────────────────┐
│ Flutter app                  │        │ Cloudflare R2                │
│ Android · iOS · Windows      │◄──────►│ audio · art · waveforms      │
│ Riverpod · Drift · just_audio│ signed │ private buckets, signed URLs │
└──────────────┬───────────────┘  URLs  └──────────────▲───────────────┘
               │ HTTPS + JWT                          │ upload (boto3/S3)
               ▼                                      │
┌──────────────────────────────┐        ┌──────────────┴───────────────┐
│ FastAPI (Render)             │        │ Worker (home PC)             │
│ auth · library · queue · API │◄──────►│ yt-dlp · ffmpeg · mutagen    │
│ no persistent disk           │  SQL   │ MusicBrainz · LRCLIB         │
└──────────────┬───────────────┘        └──────────────────────────────┘
               │
               ▼
┌──────────────────────────────┐
│ Neon Postgres                │
│ metadata · jobs · stats      │
└──────────────────────────────┘
```

## Components

| Component | Location | Responsibility |
| --- | --- | --- |
| API | `backend/src/aura` | Auth, library reads/writes, search, playlists, stats, jobs, signed URLs |
| Worker | `backend/src/aura/worker` | Claims jobs, downloads, analyzes, tags, uploads to R2 |
| App | `app/` | Offline-first library, player, lyrics, settings |
| Migrations | `backend/alembic` | Versioned PostgreSQL schema |
| Infra | `infra/`, `render.yaml` | Local Postgres and Render deployment |

### API layout

```
src/aura/
  api/            app factory, dependencies, error handlers, routers
  core/           config, logging, security, normalization, cursors, LRC
  db/             async engine/session, models, base types
  providers/      interchangeable audio/metadata/lyrics/cover sources
  schemas/        Pydantic request/response models
  services/       auth, library, storage, tagging, audio analysis, jobs
  worker/         long-poll loop and ingestion pipeline
```

Routers are thin: they validate input, call a service, and serialize. Services
own transactions. `db/session.py` creates the engine with `psycopg` async and a
short pool recycle suitable for Neon.

### App layout

```
lib/
  core/           config, design tokens, models, network, l10n
  data/           API repositories, Drift database
  features/       auth, library, search, player, lyrics, settings, gallery
  components/     design-system widgets
  router/         go_router with auth redirects
  shell/          tab shell + mini player
```

## Request flows

### 1. Library sync (app)

1. `LibraryRepository.sync()` calls `GET /v1/tracks`, `/v1/albums`,
   `/v1/artists`, `/v1/playlists` with cursor pagination.
2. Each page is upserted into Drift in one batch. Local-only fields
   (`favorite`, `localAudioPath`) are preserved because the companion marks them
   absent.
3. The last cursor is stored in `sync_meta`; the UI streams from SQLite, so it
   renders instantly and stays usable offline.
4. `syncIfStale()` runs at most every 15 minutes when the library opens.

### 2. Ingestion (worker)

`POST /v1/ingest` validates a query/URL and enqueues a job. The worker claims it
with `SELECT ... FOR UPDATE SKIP LOCKED`, then runs:

```
resolve → download → probe → analyze → enrich → tag → upload → finalize
```

- **resolve**: YouTube Music search or local file lookup.
- **download**: yt-dlp (`bestaudio[ext=m4a]`), no playlists, retries.
- **probe/analyze**: ffprobe, LUFS via ffmpeg `loudnorm`, ReplayGain, 128-point
  waveform, BPM/energy where available.
- **enrich**: MusicBrainz, cover candidates, lyrics lookup.
- **tag**: mutagen writes title/artist/album/cover and embedded lyrics.
- **upload**: one final audio object + one cover + one waveform, keyed by
  SHA-256 (`audio/ab/<sha256>.m4a`). Nothing is written to local disk on the API.
- **finalize**: assets/track/lyrics/cover candidates, job result, SSE event.

Every stage is idempotent; a retry reuses content-addressed assets. Progress and
heartbeats are written to `jobs` so the UI can show stages.

### 3. Idle worker (no database polling)

When no job exists, the worker calls `GET /v1/internal/worker/wait?timeout=30`.
That endpoint holds the request for up to 30 s and wakes as soon as a job is
enqueued (in-process notifier per API instance). The worker is idle on the
network, not in a SQL loop, so Neon can scale to zero and free compute lasts.

This is a deliberate deviation from the plan's "poll every N seconds" option and
is documented in `docs/DECISIONS/0004-worker-long-poll.md`.

### 4. Streaming and covers

- `GET /v1/tracks/{id}/stream` returns a short-lived signed URL plus MIME/size.
- `GET /v1/albums/{id}/cover` returns a signed cover URL, palette, thumbhash and
  dimensions. The client paints a palette gradient immediately, then fades in
  the image.
- Buckets are private; the API never proxies audio bytes.

### 5. Playback and history

- `QueueEngine` is pure Dart (shuffle, repeat, removal, jump) and unit-tested.
- `PlayerController` drives `just_audio`, applies ReplayGain, persists queue and
  position in SQLite, and writes play events to an outbox.
- Each play gets a client-generated `idempotency_key`; `POST /v1/plays/batch`
  deduplicates on `(user_id, idempotency_key)`, so retries never double-count.
- Batches are flushed on connectivity, app pause and playback completion.

### 6. Offline audio downloads

1. The app requests `/v1/tracks/{id}/stream` and receives a short-lived signed
   URL.
2. `DownloadController` keeps at most two transfers active; the rest wait in
   memory. Progress is streamed to the UI.
3. The file is written to `<app support>/audio/<trackId>.m4a` with a dedicated
   Dio instance, so the JWT is never sent to R2.
4. On success the path is stored in `local_tracks.local_audio_path`; the player
   prefers that file over streaming and works in airplane mode.
5. Removing a download deletes the file and clears the column. "Download
   favorites" queues every favorite in the library.

### 7. Statistics

`GET /v1/stats/overview?range=7d|30d|90d|all` aggregates plays, minutes,
unique tracks, streak, top tracks and top artists. The Flutter screen requests
one range at a time with a `FutureProvider.family`, so switching ranges is a
cheap refetch and nothing extra is persisted in SQLite.

## Deployment topology

| Piece | Host | Notes |
| --- | --- | --- |
| API | Render web service (`render.yaml`) | Docker image, `/healthz` liveness |
| Database | Neon Postgres | Pooled URL for the API, direct URL for migrations |
| Objects | Cloudflare R2 | Private buckets `aura-audio`, `aura-art` |
| Worker | Home PC | Residential IP, outbound only, systemd/Task Scheduler |
| App | Stores / sideload | Android, iOS, Windows |

Rules enforced by code and docs:

- `/healthz` never touches the database. `/readyz` does (and is the only probe
  allowed to wake Neon).
- The API keeps no persistent files; uploads happen only in the worker.
- Render's free Postgres is never used.
- Secrets live in environment variables, never in git.
- Production refuses the default JWT secret and a localhost database URL.

## Reliability

- **Jobs**: bounded attempts, exponential `run_after`, stuck-job recovery on
  worker start, cancel/retry endpoints, SSE events for progress.
- **Assets**: SHA-256 uniqueness means duplicate downloads converge to one R2
  key. Uploads overwrite the same key harmlessly.
- **HTTP**: RFC 9457 `application/problem+json` with `request_id`; the client
  maps it to Spanish messages.
- **Auth**: short access tokens (15 min), rotating refresh tokens with family
  revocation, Argon2 password hashes, constant-time comparisons.
- **Rate limits**: slowapi on auth and ingest endpoints.
- **Observability**: structured JSON logs with request IDs, optional Sentry,
  `/v1/version` build info.

## Milestones

The plan's milestones map to the repository as follows. "Done" means code and
tests exist in this repo; external services still require credentials.

| Milestone | Phases | Status |
| --- | --- | --- |
| M1 — cloud API + database | 0–3 | Done: repo, FastAPI, Neon-ready migrations, auth, library API, Dart client |
| M2 — first enriched song | 4–6 | Done: queue/worker, yt-dlp, R2, HD covers, synced lyrics |
| M3 — usable MVP | 7–9 | Done: Flutter design system, full player, Spotify-style lyrics |
| M4 — delight + offline | 10–12 | Partial: stats API + in-app statistics screen, achievements, metadata/lyrics cache, play outbox and audio downloads; no Home/Inbox UI, no home widgets, no resume-after-kill or LRU |
| M5 — quality + AI | 13–14 | Done for phase 13 quality/release; phase 14 AI is not implemented (only configuration placeholders exist) |

## Known limitations

- Runtime integrations (R2, MusicBrainz, LRCLIB, YouTube) need real credentials
  and network access; they are covered by unit tests with fakes, not live calls.
- Background audio and lock-screen controls depend on platform configuration and
  were not validated on physical devices in this environment.
- Windows playback needs `libmpv-2.dll` next to the executable.
- Phase 11 home-screen widgets and Phase 14 AI features are out of scope for
  this build.
- Phase 10 has stats/achievements endpoints and a statistics screen, but no
  Home or Inbox feed.
- Phase 12 caches metadata, lyrics, queue and play events and can download
  audio tracks to disk (two at a time, with progress, cancellation and removal).
  Resume after a killed process, SHA-256 verification, LRU eviction and a
  dedicated downloads screen are not implemented; the Wi-Fi-only preference is
  stored but not enforced.
- Golden tests are generated on Windows; other hosts skip them to avoid
  platform-specific text rasterization diffs.

## Further reading

- `docs/DATA_MODEL.md` — tables, indexes and invariants.
- `docs/DESIGN.md` — visual system and interaction rules.
- `docs/DECISIONS/` — architecture decision records.
- `docs/openapi.json` — generated API contract.
