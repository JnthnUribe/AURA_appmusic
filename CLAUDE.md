# Aura — project memory

## What it is

Personal music app: FastAPI API on Render + Python worker on a home PC + Flutter
app. Neon PostgreSQL, files in Cloudflare R2. Single user, multi-user schema.
Spanish UI, English code.

## Architecture in one screen

- API: `backend/src/aura` — auth, library, search, playlists, stats, jobs,
  signed URLs. Stateless, no persistent disk.
- Worker: `backend/src/aura/worker` — claims jobs, yt-dlp, ffmpeg, mutagen,
  MusicBrainz/LRCLIB, uploads to R2. Outbound only.
- App: `app/` — Flutter + Riverpod + Drift + go_router + just_audio, offline-first.
- Docs: `docs/ARCHITECTURE.md`, `docs/DATA_MODEL.md`, `docs/DESIGN.md`,
  `docs/DECISIONS/`, `docs/openapi.json`.

## Commands

```bash
# Backend
cd backend
uv sync --dev
uv run fastapi dev src/aura/main.py
uv run pytest
uv run ruff check . && uv run ruff format --check .
uv run pyright
uv run alembic revision --autogenerate -m "message"
uv run alembic upgrade head
uv run aura create-user --email you@example.com --password 'long-password'
uv run aura export-openapi --output ../docs/openapi.json

# Worker
cd backend
uv run python -m aura.worker
# needs ffmpeg + deno + yt-dlp on PATH

# App
cd app
flutter pub get
dart run build_runner build --force-jit   # after Drift/l10n changes
flutter analyze
flutter test
flutter run --dart-define-from-file=env/dev.json
```

Dev services: `docker compose -f infra/docker-compose.yml up -d postgres`.
Health: `/healthz` (never DB), `/readyz` (DB), `/v1/version`.

## Rules

- Code, identifiers, commits and docs in English; user-facing copy in Spanish.
- Async end to end in the API; no blocking work in endpoints. Heavy work only in
  the worker.
- `/healthz` never touches the database. No continuous DB polling loops. The
  worker idle path is a 30 s long poll (`/v1/internal/worker/wait`).
- Downloads happen only in the worker. The API disk stays empty; R2 is private
  with signed URLs.
- Migrations only with Alembic, expand/contract. Never edit an applied migration
  or generated files by hand (`database.g.dart`, `app_localizations*.dart`).
- Every pipeline stage is idempotent. Upload once, after enrichment.
- Tests never use the network; fake providers or `respx`.
- Never use Render's free Postgres.

## Never

- Commit secrets, `.env`, tokens, dumps or R2 keys.
- Build SQL by string concatenation.
- Store media on the API server.
- Add a background loop that queries Postgres on a timer.
- Change an API response shape without updating `docs/openapi.json` and the
  Flutter models.

## Definition of done

Tests green, Ruff/Pyright clean, `flutter analyze` clean, migrations tested up
and down, docs/ADR updated, OpenAPI exported, current-state section refreshed.

## Current state (2026-11)

- Phases 0–9 implemented. Phase 10 has stats/achievements APIs and a statistics
  screen (no Home/Inbox feed). Phase 12 caches metadata/lyrics, queues plays and
  downloads audio on demand (no resume-after-kill, SHA-256 verification or LRU).
  Phase 11 widgets and phase 14 AI are not implemented.
- Backend: 44 tests pass, 6 integration tests skip without
  `AURA_TEST_DATABASE_URL`; Pyright 0 errors.
- App: 41 tests pass; analyzer clean; goldens generated on Windows.
- Known local blockers: no Docker/Postgres/R2 credentials; background audio and
  Windows `libmpv-2.dll` unverified; `uv run pyright` is blocked by Windows App
  Control (use `npx --yes pyright`).

## Where to look first

| Task | Files |
| --- | --- |
| Add an endpoint | `api/routers/`, `services/`, `schemas/` |
| Change schema | `db/models.py`, `alembic/versions/`, `docs/DATA_MODEL.md` |
| Worker/ingest | `worker/pipeline.py`, `providers/`, `services/jobs.py` |
| Player | `app/lib/features/player/` |
| Downloads | `app/lib/features/downloads/`, `components/track_tile.dart` |
| Stats | `app/lib/features/stats/`, `api/routers/stats.py` |
| Design | `app/lib/core/design/tokens.dart`, `docs/DESIGN.md` |
| Release | `.claude/skills/aura-release/SKILL.md`, `render.yaml` |

## Known gotchas

- `build_runner` must use `--force-jit`; AOT fails on the `objective_c` hook.
- `uv sync` can print to stderr and look like a failure while succeeding.
- PowerShell 5.1: no heredocs, no `-Encoding utf8NoBOM`; use the editor tools.
- Drift upserts intentionally leave `favorite` and `local_audio_path` absent.
- Golden tests are Windows-only; other hosts skip them.
