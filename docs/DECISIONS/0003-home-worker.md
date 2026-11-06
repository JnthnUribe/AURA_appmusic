# 0003 — Worker on a home PC, outbound only

- **Status:** accepted
- **Date:** 2026-11-01

## Context

YouTube blocks datacenter IPs, and downloads are CPU/network heavy. Running
yt-dlp inside the API would tie the web dyno to a long task and violate the
ephemeral-disk rule. The user already has a PC that is on most of the day.

## Decision

- The worker is a separate Python process (`python -m aura.worker`) on the home
  PC, using the residential IP.
- It opens **no inbound ports**. It authenticates to the API with a bearer
  `WORKER_TOKEN` and claims jobs from Postgres.
- Dependencies: `ffmpeg`, `deno` (yt-dlp JS runtime), and yt-dlp; the worker
  self-updates yt-dlp at most once a week.
- Job claims use `FOR UPDATE SKIP LOCKED`; heartbeats and a `locked_by` id make
  crashes recoverable.
- It sets Windows `SetThreadExecutionState` while a job runs and releases it
  afterwards.

## Consequences

- The API can run on the smallest Render plan; the worker does the heavy work.
- When the PC is off, jobs stay queued; the app shows them as pending.
- The worker needs outbound HTTPS, ffmpeg and Deno. A missing dependency is
  logged loudly at startup.
- Multi-worker is possible but the default concurrency is 1.

## Alternatives considered

- **Run yt-dlp in the API**: blocked by datacenter IPs and disk limits.
- **Run in GitHub Actions**: no persistent queue, rate limits, awkward secrets.
- **Self-hosted server**: more reliable, but not available and not free.
