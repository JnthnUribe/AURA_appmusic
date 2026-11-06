"""Robust LRC parser (pure module, no network).

Handles: BOM, CRLF, multiple timestamps per line, [offset:±ms], metadata tags,
[mm:ss], [mm:ss.xx], [mm:ss.xxx], enhanced <mm:ss.xx> word timing and empty
lines with a timestamp (instrumental pauses).
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any

TIMESTAMP = re.compile(r"\[(\d{1,3}):(\d{2})(?:[.:](\d{1,3}))?\]")
WORD_TIMESTAMP = re.compile(r"<(\d{1,3}):(\d{2})(?:[.:](\d{1,3}))?>")
OFFSET_TAG = re.compile(r"\[offset:\s*([+-]?\d+)\s*\]", re.IGNORECASE)
META_TAG = re.compile(r"^\[(ar|ti|al|by|re|ve|length):(.*)\]$", re.IGNORECASE)


@dataclass(slots=True)
class LyricLine:
    t: int
    end: int
    text: str
    words: list[dict[str, Any]] = field(default_factory=list)


@dataclass(slots=True)
class LyricDocument:
    lines: list[LyricLine]
    offset_ms: int = 0
    meta: dict[str, str] = field(default_factory=dict)

    @property
    def plain_text(self) -> str:
        return "\n".join(line.text for line in self.lines if line.text)

    def to_dict(self) -> dict[str, Any]:
        return {
            "lines": [
                {
                    "t": line.t,
                    "end": line.end,
                    "text": line.text,
                    **({"words": line.words} if line.words else {}),
                }
                for line in self.lines
            ],
            "offset_ms": self.offset_ms,
            "meta": self.meta,
        }


def _fraction_to_ms(fraction: str | None) -> int:
    if not fraction:
        return 0
    if len(fraction) == 1:
        return int(fraction) * 100
    if len(fraction) == 2:
        return int(fraction) * 10
    return int(fraction[:3])


def _stamp_to_ms(minutes: str, seconds: str, fraction: str | None) -> int:
    return (int(minutes) * 60 + int(seconds)) * 1000 + _fraction_to_ms(fraction)


def _parse_words(text: str) -> tuple[str, list[dict[str, Any]]]:
    """Split enhanced LRC into plain text + word timings."""
    matches = list(WORD_TIMESTAMP.finditer(text))
    if not matches:
        return text.strip(), []
    words: list[dict[str, Any]] = []
    for index, match in enumerate(matches):
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        chunk = text[start:end].strip()
        if chunk:
            words.append(
                {
                    "t": _stamp_to_ms(match.group(1), match.group(2), match.group(3)),
                    "text": chunk,
                }
            )
    plain = WORD_TIMESTAMP.sub("", text).strip()
    plain = re.sub(r"\s+", " ", plain)
    return plain, words


def parse_lrc(raw: str, *, duration_ms: int | None = None) -> LyricDocument:
    if not raw:
        return LyricDocument(lines=[])
    text = raw.lstrip("\ufeff").replace("\r\n", "\n").replace("\r", "\n")

    offset_ms = 0
    if match := OFFSET_TAG.search(text):
        offset_ms = int(match.group(1))
        text = OFFSET_TAG.sub("", text)

    meta: dict[str, str] = {}
    timed: list[tuple[int, str]] = []

    for raw_line in text.split("\n"):
        line = raw_line.strip()
        if not line:
            continue
        if match := META_TAG.match(line):
            meta[match.group(1).lower()] = match.group(2).strip()
            continue

        stamps = list(TIMESTAMP.finditer(line))
        if not stamps:
            continue
        lyric = TIMESTAMP.sub("", line).strip()
        for stamp in stamps:
            start = _stamp_to_ms(stamp.group(1), stamp.group(2), stamp.group(3))
            timed.append((max(0, start - offset_ms), lyric))

    timed.sort(key=lambda item: item[0])
    lines: list[LyricLine] = []
    for index, (start, lyric) in enumerate(timed):
        if index + 1 < len(timed):
            end = timed[index + 1][0]
        elif duration_ms and duration_ms > start:
            end = duration_ms
        else:
            end = start + (5000 if lyric else 3000)
        plain, words = _parse_words(lyric)
        lines.append(
            LyricLine(
                t=start,
                end=max(end, start + (1 if plain else 500)),
                text=plain,
                words=words,
            )
        )
    return LyricDocument(lines=lines, offset_ms=offset_ms, meta=meta)


def plain_to_document(text: str) -> LyricDocument:
    lines = [
        LyricLine(t=0, end=0, text=line.strip())
        for line in text.replace("\r\n", "\n").split("\n")
        if line.strip()
    ]
    return LyricDocument(lines=lines)
