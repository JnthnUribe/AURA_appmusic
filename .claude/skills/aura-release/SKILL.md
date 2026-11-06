---
name: aura-release
description: Use when deploying, migrating, backing up, rolling back or publishing Aura, or when changing environment variables, CI, Render/R2/Neon configuration or release versioning.
---

# Aura release

## Environments

| Piece | Dev | Prod |
| --- | --- | --- |
| API | `uv run fastapi dev` | Render (`render.yaml`) |
| DB | docker compose Postgres 17 | Neon (pooled URL) |
| Objects | optional fake/R2 | R2 private buckets |
| Worker | local process | home PC service |
| App | `flutter run` | signed builds |

Never use Render's free Postgres. Never store files on the API disk. Never commit
`.env`, tokens, dumps or R2 credentials.

## Pre-deploy checklist

1. `cd backend && uv sync --dev`
2. `uv run ruff check . && uv run ruff format --check . && uv run pyright`
3. `uv run pytest -q` (integration tests need `AURA_TEST_DATABASE_URL`)
4. `uv run alembic upgrade head && uv run alembic downgrade base && uv run alembic upgrade head`
5. `uv run aura export-openapi` and commit `docs/openapi.json` if it changed.
6. `cd app && flutter analyze && flutter test`
7. Check `/healthz` (no DB), `/readyz` (DB), `/v1/version`.
8. Confirm `JWT_SECRET` ≥ 32 chars, `WORKER_TOKEN` ≥ 24, CORS has no `*`.

## Migration order

Backward-compatible expand/contract only:

1. Expand: add nullable column/table, deploy API that tolerates both shapes.
2. Backfill in a job or SQL, verify counts.
3. Contract: drop/rename in a later release after the new code is live.

Take a Neon branch or `pg_dump` before destructive changes. Test downgrade on a
copy, not production.

## Deploy

- API: push to `main`; CI builds the Docker image and triggers the Render deploy
  hook. Migrations run as a release step or manually before the web rollout.
- Worker: update the home PC (`git pull`, `uv sync`), restart the service, confirm
  `worker_started` in the logs and a claimed job.
- App: bump `version`, build signed artifacts, smoke-test login, sync, playback,
  lyrics and offline mode.

## Rollback

1. Stop the worker (prevents mixed-version jobs).
2. Roll back the API image on Render.
3. Only downgrade the schema if the previous release requires it; prefer a
   forward fix.
4. Re-enable the worker and verify the queue drains.
5. Restore the DB only as a last resort, from a tested snapshot.

## Backups

- Neon: enable PITR/branching on the plan; weekly logical dump.
- R2: object versioning or a lifecycle rule; assets are content-addressed, so
  restoring metadata is enough to relink.
- Keep dumps encrypted and out of git; test a restore quarterly.

## Versioning

- API and app version in `pyproject.toml` / `pubspec.yaml`.
- Git tags `vX.Y.Z`; Conventional Commits for history.
- `docs/openapi.json` is a release artifact; a diff means a client-visible
  change.
