# 0004 — Worker idle uses a long poll, not a SQL loop

- **Status:** accepted
- **Date:** 2026-11-01

## Context

Neon's free tier charges compute time. A worker that queries `jobs` every few
seconds keeps the database awake 24/7 and burns the monthly budget. The plan
allowed a polling loop, but it conflicts with the "no continuous DB polling"
constraint.

## Decision

- When idle, the worker calls `GET /v1/internal/worker/wait?timeout=30` with its
  bearer token.
- The endpoint waits on an in-process `asyncio.Event` (per API instance) and
  returns as soon as `enqueue` fires, or after the timeout.
- The worker re-checks the queue after each wake; on network errors it backs off
  5 s.
- If `WORKER_TOKEN` is unset (local development), the worker falls back to a 5 s
  sleep loop.

## Consequences

- Neon sees a heartbeat-sized query every 30 s at most, and can scale down when
  both the app and worker are idle.
- The notifier is per API instance. With multiple Render instances, a job
  enqueued on instance A wakes only A's waiters; other instances fall back to
  the 30 s timeout. This is acceptable for a single-user deployment.
- The wait endpoint must not be exposed publicly without the worker token.

## Alternatives considered

- **Fixed 5 s polling**: simple, but violates the compute budget.
- **Postgres LISTEN/NOTIFY**: elegant, but holds a dedicated connection and is
  awkward through Neon's pooler.
- **External queue (SQS/Redis)**: extra service and cost for one user.
