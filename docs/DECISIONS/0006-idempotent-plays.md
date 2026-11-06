# 0006 — Idempotent play events and a client outbox

- **Status:** accepted
- **Date:** 2026-11-01

## Context

Plays drive stats, achievements and Wrapped. Mobile clients go offline mid-play
and retry batches; a naive POST would double-count plays on every retry.

## Decision

- Each playback session generates a UUID `idempotency_key` on the device.
- Events are written to the SQLite `outbox_plays` table with `sent = false`.
- `POST /v1/plays/batch` skips keys already stored for the user and returns the
  number accepted. A unique index `(user_id, idempotency_key)` is the final
  guard against a race.
- The client marks rows sent only after a successful response; batches flush on
  playback completion, pause, a 15-minute timer and app start.
- `stats_daily` is updated from accepted plays only.

## Consequences

- Retries are safe and stats are exact.
- The outbox is bounded by `pendingPlays(limit: 200)`; old rows can be pruned.
- The server keeps a unique index on `(user_id, idempotency_key)`; keys are
  scoped per user.
- Clock skew does not matter for deduplication, only for ordering.

## Alternatives considered

- **Server-generated IDs**: cannot deduplicate a retried request that never
  reached the server.
- **Client timestamp uniqueness**: fragile with clock changes.
