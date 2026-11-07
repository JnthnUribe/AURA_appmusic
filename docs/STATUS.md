# Aura — Project Status

Last updated: 2026-11-06. This file tracks what is implemented, what is partial
and what is intentionally out of scope. It is the honest complement to the
README's feature list.

## Summary

| Area | State | Notes |
| --- | --- | --- |
| Backend API | Complete | 43 documented paths, auth, library, queue, stats |
| Database schema | Complete | One Alembic migration, PostgreSQL-specific indexes |
| Worker pipeline | Complete | resolve → download → probe → analyze → enrich → tag → upload → finalize |
| Flutter app | Complete for M1–M3 | Library, search, player, lyrics, settings, gallery |
| Offline metadata | Complete | Drift mirror, lyrics cache, queue, play outbox |
| Offline audio | Partial | Download manager with progress/cancel; no resume or hash check |
| Statistics UI | Complete | Ranges, totals, streak, top artists and tracks |
| Home/Inbox | Not built | No recommendation or activity feed |
| System widgets | Not built | No Android/iOS home-screen widgets |
| AI features | Not built | Configuration placeholders only |

## Phases

| Phase | Status | Evidence |
| --- | --- | --- |
| 0 — Foundations | Done | Monorepo, `pyproject.toml`, CI, docs, agent skills |
| 1 — API base | Done | FastAPI factory, `/healthz`, `/readyz`, version endpoint, Dockerfile |
| 2 — Database | Done | `db/models.py`, `alembic/versions/0001_initial.py`, UUIDv7, `citext`, `pg_trgm`, generated `tsvector` |
| 3 — Auth + library | Done | JWT access/refresh rotation, Argon2, cursor pagination, Flutter client |
| 4 — Ingestion | Done | Job table, `FOR UPDATE SKIP LOCKED`, long poll, yt-dlp, R2, local-file provider |
| 5 — Covers + metadata | Done | Candidate scoring, WebP, palette, thumbhash, MusicBrainz cache |
| 6 — Lyrics | Done | LRCLIB client, LRC parser, offsets, rechecks, embedded lyrics |
| 7 — Design system | Done | Tokens, glass, motion, components, dark/light, Spanish copy |
| 8 — Player | Done | Queue engine, shuffle/repeat, ReplayGain, speed, sleep timer, persistence |
| 9 — Lyrics UI | Done | Synced highlighting, tap-to-seek, offset controls, plain/instrumental states |
| 10 — Delight | Partial | Stats/achievements/Wrapped API and stats screen; no Home or Inbox |
| 11 — Widgets | Not built | Requires platform widget projects |
| 12 — Offline | Partial | Drift cache, lyrics, queue, idempotent outbox, audio download manager; no resume-after-kill, SHA-256 verification, LRU, or downloads screen |
| 13 — Quality/release | Done in code | CI, Ruff, Pyright, pytest, gitleaks, pre-commit, Sentry hooks, release docs; live providers untested |
| 14 — AI | Not built | `ANTHROPIC_API_KEY` is read but no endpoint or UI uses it |

## Verification (local, 2026-11-06)

| Check | Result |
| --- | --- |
| `uv run pytest` | 44 passed, 6 skipped (PostgreSQL URL not set) |
| `uv run ruff check .` | Clean |
| `uv run ruff format --check .` | 55 files formatted |
| `uv run pyright` (via `npx pyright`) | 0 errors, 0 warnings |
| `flutter analyze` | No issues |
| `flutter test` | 41 passed |
| OpenAPI export | 43 paths |
| PowerShell/bash script syntax | OK |

Golden tests run only on Windows; CI skips the golden and runs the rest.

## Deliberate deviations from the plan

| Deviation | Why |
| --- | --- |
| Worker idle long-poll instead of timed SQL polling | Protects Neon free compute (ADR 0004) |
| Enrich before the single R2 upload | Avoids partial objects and several writes (ADR 0007) |
| `tracks.waveform_asset_id` added | Waveform served through the same signed-URL path |
| `plays.idempotency_key` unique per user | Retry-safe play batches (ADR 0006) |
| Hand-written Riverpod providers and API models | Removes generator friction on Windows |
| Hand-written migration instead of initial autogenerate | Full control of PostgreSQL types and indexes |
| Drift `database.g.dart` committed | CI can analyze and test without `build_runner` |

## Known gaps

1. **No live E2E run.** Neon, R2, YouTube Music, MusicBrainz and LRCLIB require
   credentials and network access that are not part of the repository.
2. **Offline audio is not fully hardened.** Downloads are content-addressed by
   track id, not SHA-256; a killed transfer restarts; no LRU eviction; the
   Wi-Fi-only switch is stored but not enforced because no connectivity package
   is included.
3. **Background audio is unverified on devices.** The code uses `just_audio`
   with `audio_session`; lock-screen metadata was not tested here.
4. **Windows audio needs `libmpv-2.dll`.** It is not committed.
5. **Phase 11 and 14 are absent.**
6. **Smart playlists** are schema-ready but not generated.
7. **No automated R2 garbage collector** for unreferenced objects.

## Recommended next steps

1. Provision Neon + R2, fill `.env`, and run the manual E2E checklist below.
2. Verify background playback and lock-screen controls on a physical Android
   device; add the Windows `libmpv-2.dll` beside the debug executable.
3. Harden downloads: resume with HTTP Range, SHA-256 verification, LRU cache
   limits and a dedicated Downloads screen.
4. Build Home/Inbox if the product needs discovery, or remove the unused
   endpoints from the roadmap.
5. Add Sentry projects and UptimeRobot monitors, then test the restore runbook.

## Manual end-to-end checklist

- [ ] `alembic upgrade head` against a fresh Neon branch
- [ ] `aura create-user` succeeds and login returns a token pair
- [ ] Start the worker; it logs `worker_started` and long-polls
- [ ] `POST /v1/ingest` with a URL; job reaches `succeeded`
- [ ] R2 contains audio, cover and waveform objects; rows exist in `assets`
- [ ] App syncs the track, shows the cover, plays audio and displays lyrics
- [ ] Download a track, enable airplane mode, and play it from disk
- [ ] Favorite, queue and play events survive offline and sync later
- [ ] `GET /v1/stats/overview` reflects the plays after the outbox flushes
- [ ] `/healthz` responds with the database stopped
