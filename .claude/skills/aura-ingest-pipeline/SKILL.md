---
name: aura-ingest-pipeline
description: Use when touching the Aura worker, job queue, yt-dlp/local downloads, ffmpeg analysis, metadata enrichment, cover selection, R2 uploads or ingestion tests. Do not use for API-only or Flutter UI work.
---

# Aura ingestion pipeline

## Contract

`SourceProvider` (in `providers/base.py`) exposes `resolve`, `download` and
search. YouTube Music and local files implement it; new sources must not leak
into the pipeline.

Stages, in order:

```
resolve -> download -> probe -> analyze -> enrich -> tag -> upload -> finalize
```

Every stage is idempotent and reports progress through `jobs.stage/progress`.
Never upload before tagging: one audio object and one cover are written per
track (see `docs/DECISIONS/0007-enrich-before-upload.md`).

## Queue rules

- Claims use `FOR UPDATE SKIP LOCKED`; a job is owned by `locked_by` until it
  finishes or its heartbeat goes stale.
- Retries use `attempts`/`max_attempts` and exponential `run_after`.
- Stuck jobs are recovered at worker startup.
- Idle workers long-poll `/v1/internal/worker/wait`; they must never run a
  continuous SQL polling loop.
- Cancellation is checked between stages.

## Downloads

- yt-dlp: audio only, no playlists, retries, socket timeout, `bestaudio[ext=m4a]`.
- yt-dlp needs a JS runtime (Deno) on modern YouTube; log a clear warning when
  it is missing. Auto-update at most weekly and allow opt-out with
  `AURA_AUTO_UPDATE_YTDLP=0`.
- Convert with ffmpeg only when the source is not already M4A/AAC.
- Place downloads only in the worker's temp dir; the API disk stays empty.

## Analysis and tags

- LUFS/ReplayGain via ffmpeg `loudnorm`; waveform downsampled to 128 points;
  store BPM/energy when reliably detected.
- Covers: gather candidates, score resolution and quality, never upscale, store
  palette (Lab k-means) and a tiny thumbhash data URI.
- Mutagen writes title, artists, album, track/disc, cover and lyrics.
- Normalize titles with `core/normalize.py`; never lowercase display text.

## R2

- Keys are content-addressed: `audio/ab/<sha256>.m4a`, `art/ab/<sha256>.webp`,
  `waveform/ab/<sha256>.json`.
- Buckets are private. Do not log presigned URLs or secrets.
- A failed upload may be retried; the same key is overwritten harmlessly.

## External services

- Always send a descriptive User-Agent with the repo URL.
- Respect rate limits; cache lookups in `provider_cache`.
- Tests use fakes; no live calls in CI.

## Definition of done

Pipeline tests cover reuse, failure and cancellation; `docs/DATA_MODEL.md` and
the job schema stay in sync; the worker starts cleanly with ffmpeg/Deno present.
