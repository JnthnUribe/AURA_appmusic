---
name: aura-lyrics
description: Use when working with lyrics, LRC parsing, timing/offset, LRCLIB, lyric search, embedding lyrics in files, or the lyrics UI. Do not use for general audio playback.
---

# Aura lyrics

## LRC grammar

- One line may carry multiple `[mm:ss.xx]` timestamps: emit one entry per
  timestamp, not one per text line.
- Apply `[offset:±ms]` once, in milliseconds. Keep output sorted by `t`.
- Empty text with a timestamp is an instrumental pause; render it as `···`.
- Enhanced `<mm:ss.xx>` timestamps fill per-word `words[]` when present.
- Accept CRLF and a UTF-8 BOM; reject nothing silently — drop malformed lines
  and record a warning.
- Store `lines: [{t, end, text, words: [{t, text}]}]` plus `offset_ms` and
  `plain_text`; `end` is the next line start or `0` when unknown.

## Sources

- LRCLIB first: `/api/get` with track name, artist, album and **duration in
  seconds**. On 404, use `/api/search` and pick by normalized title/artist
  similarity and duration within ±2 s.
- Send `Aura/0.1 (+repo URL)` as User-Agent.
- `instrumental: true` means no lyrics: stop, do not retry.
- Persist `(track_id, source)` uniquely; schedule rechecks at 7 and 30 days via
  `recheck_at`.
- AI word alignment is optional and not implemented; never fake confidence.

## Sync and UI

- `offset_ms` shifts lyric time, not audio seek time.
- Interpolate position with a ticker; do not rely only on `positionStream`.
- Highlight the active line, keep it near 35% of the viewport, and let a tap
  seek to that line.
- Respect reduce motion (no continuous auto-scroll animation) and avoid blur in
  long lists.
- Plain lyrics render as selectable text; instrumental shows a single message.
- Copy is Spanish: `Sin letra`, `Sincronizar`, `Ajustar −/＋`.

## Tests

Fixtures belong in `backend/tests/fixtures/lrc/`: CRLF, BOM, multiple timestamps,
no decimals, offset, empty lines, malformed timestamps. The Flutter parser has
its own tests in `app/test/lrc_utils_test.dart`; keep both behaviors aligned.

## Definition of done

Round-trip tests pass, timings are monotonic, offset is applied once, and the
lyrics screen handles synced/plain/instrumental/error states.
