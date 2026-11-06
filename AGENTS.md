# AGENTS.md

Instructions for coding agents (Claude Code, Codex, Cursor, Antigravity, …)
working in this repository. `CLAUDE.md` has the short version; the skills in
`.claude/skills/` have the detailed workflows.

## Project

Aura is a personal music app with three parts:

1. **API** (`backend/src/aura`): FastAPI, SQLAlchemy 2 async, Alembic, PostgreSQL.
2. **Worker** (`backend/src/aura/worker`): yt-dlp/ffmpeg/mutagen pipeline on a
   home PC, writes to Cloudflare R2.
3. **App** (`app/`): Flutter, Riverpod, Drift, go_router, just_audio.

Deployment: Render (API), Neon (Postgres), Cloudflare R2 (objects), home PC
(worker). The API is stateless and keeps no media files.

## Commands

```bash
cd backend && uv sync --dev
uv run pytest -q
uv run ruff check . && uv run ruff format --check .
uv run pyright
uv run alembic upgrade head
uv run aura export-openapi --output ../docs/openapi.json

cd backend && uv run python -m aura.worker

cd app && flutter pub get
dart run build_runner build --force-jit
flutter analyze && flutter test
```

Local Postgres: `docker compose -f infra/docker-compose.yml up -d postgres`.

## Hard constraints

- `/healthz` must never open a database connection.
- No periodic database polling. Idle worker = long poll on
  `/v1/internal/worker/wait` (30 s).
- Downloads only in the worker; the API disk is ephemeral.
- R2 buckets stay private; serve via short-lived signed URLs.
- Never use Render's free Postgres.
- No secrets in git. Copy `.env.example` to `.env` locally.
- Code and commits in English; UI copy in Spanish.

## Workflow

1. Read `docs/ARCHITECTURE.md` and the relevant ADR before changing a boundary.
2. Backend change: model → migration → service → router → tests → OpenAPI export
   → docs. Expand/contract migrations only.
3. Pipeline change: keep stages idempotent; update progress; test failure and
   cancellation paths with fakes.
4. Flutter change: tokens first, component second, screen last; add loading,
   empty, error and offline states; run analyze and tests.
5. Run the full verification suite from `CLAUDE.md` before declaring done.
6. Commit with Conventional Commits (`feat:`, `fix:`, `docs:`, `test:`,
   `chore:`). One logical change per commit.

## Code conventions

### Python

- Python 3.13, full type hints, `from __future__ import annotations`.
- Ruff format (100 cols), Pyright strict-ish. No `Any` unless unavoidable.
- Async SQLAlchemy only; sessions per request; services own transactions.
- Problem details: `application/problem+json`, include `request_id`.
- Cursor pagination for lists; no offset pages.
- Structlog events in `snake_case`.

### Dart

- `dart format`; `flutter_lints` clean.
- Riverpod providers are hand-written (no codegen); Drift/l10n use build_runner.
- Widgets read `context.auraColors` and tokens; no hard-coded colors.
- Repositories own HTTP + SQLite; widgets never call Dio.
- Spanish strings come from ARB files (`app/lib/l10n/app_es.arb` is the template).

### SQL

- UUIDv7 PKs, `timestamptz` UTC, `citext` for email, `JSONB` for documents.
- Named constraints via the metadata naming convention.
- Index every foreign key used by a list query; trigram indexes for fuzzy text.
- Soft-delete tracks with `deleted_at`; filter it in every query.

## Testing

- Backend: pytest + respx; no live network. PG integration tests auto-skip
  without `AURA_TEST_DATABASE_URL`.
- App: `flutter test`; Drift tests use `AuraDatabase.memory()`. Widget tests use
  the fakes in `app/test/support/test_harness.dart`.
- Golden tests are generated on Windows and skipped elsewhere.
- A bug fix needs a regression test.

## Known environment issues

- `uv run pyright` may be blocked by Windows App Control; use
  `npx --yes pyright` as a fallback.
- `dart run build_runner build` fails with AOT build hooks; always add
  `--force-jit`.
- `uv sync` may report success on stderr; check the exit code.
- Windows desktop audio needs `libmpv-2.dll` beside the executable.
- Goldens and native audio cannot be validated in this environment.

## Review checklist

- [ ] Does it violate a hard constraint above?
- [ ] Are errors problem+json with a request id?
- [ ] Is the migration reversible and tested both ways?
- [ ] Are new endpoints in `docs/openapi.json` and the Flutter models?
- [ ] Are loading, empty, error and offline states handled?
- [ ] Are secrets and signed URLs absent from logs?
- [ ] Do tests avoid the network?
