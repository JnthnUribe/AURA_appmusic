---
name: aura-backend
description: Use when creating or changing Aura API endpoints, Pydantic schemas, SQLAlchemy models, Alembic migrations, auth, pagination or backend tests. Do not use for worker downloads or Flutter rendering.
---

# Aura backend

## Layering

- Router: validate input, call one service, serialize. No business logic, no raw SQL.
- Service: transactions, invariants, provider calls.
- Models: SQLAlchemy 2 typed mappings in `src/aura/db/models.py`.
- Schemas: Pydantic v2 in `src/aura/schemas`; never return ORM objects directly.

## Contract rules

- Errors use RFC 9457 `application/problem+json` via the exception helpers. Every
  error includes `request_id`.
- Lists use cursor pagination (`core/cursors.py`), never offset pages.
- Timestamps are timezone-aware UTC; serialize with `Z`.
- New routes must appear in the router registry and in `docs/openapi.json`
  (`cd backend && uv run aura export-openapi`).
- `/healthz` never touches the database. Only `/readyz` may.

## Async rules

- One `AsyncSession` per request (`SessionDep`); do not share sessions across
  tasks.
- No blocking I/O in the event loop: use `run_in_threadpool` or an async client.
- Do not add background polling loops; enqueue a job instead.

## Database changes

1. Edit the model.
2. `uv run alembic revision --autogenerate -m "short message"` against Postgres.
3. Review the migration (naming convention, indexes, `ON DELETE`, check
   constraints, `citext`, `pg_trgm`, generated `tsvector`).
4. `uv run alembic upgrade head`, then `downgrade -1`, then `upgrade head`.
5. Update `docs/DATA_MODEL.md`.

Expand/contract only: add nullable columns first, backfill, then tighten. Never
edit an applied migration.

## Tests

- Unit tests must not hit the network; fake providers with `respx` or stubs.
- PostgreSQL integration tests live in `tests/test_integration.py` and skip when
  `AURA_TEST_DATABASE_URL` is unset.
- Cover success, validation failure (422 problem+json), auth failure (401), and
  pagination boundaries.

## Definition of done

`ruff check`, `ruff format --check`, Pyright and pytest are clean; the OpenAPI
export is refreshed; docs mention any behavioral change.
