# 0007 — Enrich before one content-addressed upload

- **Status:** accepted (deviation from plan)
- **Date:** 2026-11-01

## Context

The plan described uploading audio as soon as it was downloaded, then patching
tags, cover art and analyses afterwards. That means several R2 writes per track,
partial objects if a later stage fails, and a client that may sync a track
before its artwork or loudness exists.

## Decision

- The worker runs **all** stages before the first R2 write:
  `resolve → download → probe → analyze → enrich → tag → upload → finalize`.
- Mutagen writes title/artist/album/cover/lyrics into the M4A; ffmpeg normalizes
  container/codec; loudness, ReplayGain, BPM, energy and the waveform are
  computed locally.
- One audio object, one cover object and one waveform JSON object are uploaded
  per track, keyed by SHA-256.
- `tracks.waveform_asset_id` was added to the schema (not in the original plan)
  so the client can request the waveform through the same signed-URL mechanism.

## Consequences

- A track is visible to the app only when it is complete (`status = 'ready'`).
- Fewer, larger writes; content-addressed keys make retries idempotent.
- The worker needs local disk for the temporary download and derived files; the
  API still needs none.
- A failure late in the pipeline leaves only local temp files and a failed job,
  not a half-tagged R2 object.
- The waveform now costs one more asset row and one small object per track.

## Alternatives considered

- **Upload early, patch later** (original plan): more moving parts and partial
  state.
- **Store the waveform in Postgres**: bloats rows and complicates signed URLs.
