# 0001 — FastAPI + SQLAlchemy 2 async + Alembic

- **Status:** accepted
- **Date:** 2026-11-01

## Context

The API runs on a small Render instance against Neon Postgres. It must handle
short bursts from one user, cold starts, and a strict no-polling budget. The
codebase should be typed, testable and easy for an agent to navigate.

## Decision

- Python 3.13 with `uv` for dependency and environment management.
- FastAPI for routing, validation and OpenAPI generation.
- SQLAlchemy 2.0 async ORM with `psycopg` 3, sessions scoped per request.
- Pydantic v2 / pydantic-settings for the environment.
- Alembic for the schema, with a single hand-written initial migration
  (`0001_initial.py`) that enables `citext`, `pg_trgm` and the generated
  `tsvector` column.
- `structlog` JSON logs and RFC 9457 `application/problem+json` errors.

## Consequences

- One async stack end to end; no sync drivers in the request path.
- The OpenAPI schema is the contract for the Flutter client and is exported to
  `docs/openapi.json` in CI/local runs.
- Pool settings (`pool_recycle_seconds=240`) keep Neon connections fresh.
- Pyright and Ruff are part of CI, so type drift fails the build.
- Alembic migrations must be generated against PostgreSQL, not SQLite; the local
  test suite skips PG integration tests when no test database is configured.

## Alternatives considered

- **Django + DRF**: heavier, sync-first, more scaffolding than needed.
- **SQLModel**: convenient, but less control over PostgreSQL-specific types.
- **Sync SQLAlchemy**: simpler, but blocks the event loop on every query.
