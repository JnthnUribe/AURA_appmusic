# 0005 — Offline-first Flutter with Drift and Riverpod

- **Status:** accepted
- **Date:** 2026-11-01

## Context

The app is used on a phone during commutes and on a Windows desktop. Network
availability is not guaranteed, and the library should open instantly. The
design must stay consistent across platforms without a heavy state framework.

## Decision

- Flutter with Riverpod 3 providers written by hand (no riverpod codegen).
- Drift (SQLite) mirrors the library; every screen reads from streams backed by
  SQLite, never directly from HTTP.
- Repositories own sync: fetch pages with cursor pagination, upsert in batches,
  persist the cursor in `sync_meta`.
- `go_router` with an auth redirect and a stateful tab shell.
- `just_audio` for playback, with `just_audio_media_kit` on Windows/Linux.
- Design tokens as a `ThemeExtension`; no color literals in widgets.
- ARB localization with Spanish as the template and the UI fixed to `es`.

## Consequences

- Cold start renders cached data immediately; sync updates it in place.
- Server upserts must not clobber local fields — the Drift companion leaves
  `favorite` and `local_audio_path` absent on conflict (covered by tests).
- Schema changes require a Drift migration and `build_runner`.
- Hand-written providers are more verbose but avoid generated-code friction on
  Windows (the `objective_c` build hook breaks AOT builds; use
  `build_runner --force-jit`).

## Alternatives considered

- **Fetch-on-build**: simple, but blank screens offline.
- **Hive/Isar**: fast, but weaker relational queries and less mature tooling.
- **BLoC**: more ceremony for a single-user app.
