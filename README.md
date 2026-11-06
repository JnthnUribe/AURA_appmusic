# Aura

Aura is a personal music app: download and organize your library, get high-resolution
cover art, synchronized lyrics, and an offline-first player that feels native.

```
Flutter app (Android / Windows / iOS)
      │ HTTPS + JWT            │ audio + art (signed URLs)
      ▼                        ▼
FastAPI API (Render) ◄────► Cloudflare R2
      │ SQL                    ▲ uploads
      ▼                        │
  Neon Postgres ◄────── Worker (your PC)
  (metadata, queue)      yt-dlp · ffmpeg · mutagen · MusicBrainz · LRCLIB
```

- **Backend**: Python 3.13, FastAPI, SQLAlchemy 2 async, Alembic, PostgreSQL.
- **Worker**: separate Python process on a residential IP. It never opens ports.
- **App**: Flutter + Riverpod + Drift + go_router + Dio, offline-first.
- **Files**: R2 (S3 compatible). Nothing persistent on the API disk.

Read `docs/ARCHITECTURE.md`, `docs/DATA_MODEL.md` and `docs/DECISIONS/` first.

## Quick start (development)

```bash
# 1. Install Python 3.13 and backend dependencies
cd backend
uv sync

# 2. Copy environment variables (never commit .env)
cp ../.env.example ../.env

# 3. Start Postgres 17 + API
docker compose -f ../infra/docker-compose.yml up -d postgres
uv run alembic upgrade head
uv run aura create-user --email you@example.com --password 'a-long-password'
uv run fastapi dev src/aura/main.py

# 4. Worker (separate terminal, needs ffmpeg + Deno + yt-dlp)
uv run python -m aura.worker

# 5. Flutter app
cd ../app
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

Health checks: `GET /healthz` (never touches the database), `GET /readyz`
(database), `GET /v1/version`.

## Tests

```bash
cd backend
uv run pytest
uv run ruff check . && uv run ruff format --check .
uv run pyright

cd ../app
flutter analyze
flutter test
```

Integration tests that need PostgreSQL are skipped automatically when
`AURA_TEST_DATABASE_URL` is not set. The CI runs them with a service container.

## Repository layout

| Path | Contents |
| --- | --- |
| `backend/src/aura/api` | FastAPI routers, dependencies, error handling |
| `backend/src/aura/core` | settings, logging, security, normalization, cursors |
| `backend/src/aura/db` | SQLAlchemy models, session, base |
| `backend/src/aura/providers` | interchangeable metadata / audio / lyrics sources |
| `backend/src/aura/services` | auth, library, search, storage, queue-facing services |
| `backend/src/aura/worker` | job loop, pipeline stages |
| `backend/alembic` | versioned migrations |
| `app/` | Flutter client |
| `infra/` | docker-compose for local development |
| `docs/` | architecture, data model, design, ADRs, runbooks |
| `.claude/skills/` | project skills for coding agents |

## License and usage

Private, personal use only. Downloading audio from YouTube is against its Terms of
Service and may infringe copyright; lyrics are copyrighted too. Keep the app private,
never expose a public bucket, and use the interchangeable `SourceProvider` interface
with your own files (CDs, purchases, Bandcamp, Creative Commons) whenever possible.
