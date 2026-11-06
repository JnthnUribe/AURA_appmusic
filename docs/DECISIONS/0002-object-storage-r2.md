# 0002 — Private R2 buckets and signed URLs

- **Status:** accepted
- **Date:** 2026-11-01

## Context

Audio and high-resolution artwork are large. The API runs on an ephemeral disk
and must not proxy media bytes. The library is personal and must not be public.

## Decision

- Cloudflare R2 with two private buckets: `aura-audio` and `aura-art`.
- Objects are content-addressed: `audio/ab/<sha256>.m4a`,
  `art/ab/<sha256>.webp`, `waveform/ab/<sha256>.json`.
- The API stores only metadata (`assets`) and returns short-lived presigned
  URLs (`signed_url_ttl_seconds`, default 1 h).
- The Flutter client loads audio and images directly from R2.
- No object is ever uploaded by the API process.

## Consequences

- The API stays stateless and can be restarted at any time.
- Signed URLs can be cached by the client until expiry; the player refreshes on
  401/403.
- Buckets are private; a leaked URL expires.
- A separate garbage collector is required to delete unreferenced keys (not in
  this build).
- CORS on the buckets must allow the Flutter web origin if web is used.

## Alternatives considered

- **Public buckets**: simplest, but unacceptable for personal audio.
- **Stream through the API**: hides R2, but doubles bandwidth and breaks the
  no-disk/stateless constraint.
- **S3**: compatible, but R2 has no egress fees for this use case.
