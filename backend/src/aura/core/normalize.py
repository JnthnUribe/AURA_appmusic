"""Text normalization shared by ingestion, storage and search.

`unaccent` in PostgreSQL is not IMMUTABLE, so it cannot be used in generated
columns or expression indexes. We normalize in Python and store the result in
`*_norm` columns; queries are normalized with the same function.
"""

from __future__ import annotations

import re
import unicodedata

_WHITESPACE = re.compile(r"\s+")
_BRACKETS = re.compile(r"[\(\[\{].*?[\)\]\}]")
_FEAT = re.compile(
    r"\b(?:feat(?:uring)?|ft|con)\.?\s+(.+?)(?:\s*[-–—]\s*|$)",
    flags=re.IGNORECASE,
)
_NOISE = re.compile(
    r"\b(?:official\s*(?:music\s*)?video|official\s*audio|lyric\s*video|lyrics?|"
    r"audio|hd|hq|4k|visualizer|videoclip|video\s*oficial|audio\s*oficial|"
    r"letra|con\s*letra|remastered\s*\d{4})\b",
    flags=re.IGNORECASE,
)
_TOPIC = re.compile(r"\s*-\s*topic\s*$", flags=re.IGNORECASE)
_VERSION = re.compile(
    r"(?:[\(\[]|\s[-–—]\s)\s*"
    r"((?:remix|live|acoustic|unplugged|remaster(?:ed)?|demo|edit|version|"
    r"instrumental|karaoke|sped\s*up|slowed)\b.*)$",
    flags=re.IGNORECASE,
)


def normalize_text(value: str) -> str:
    """NFKD, casefold, strip diacritics and collapse whitespace.

    `ñ` becomes `n` in the normalized form (this function only feeds *_norm
    columns and search queries, never display text).
    """
    if not value:
        return ""
    decomposed = unicodedata.normalize("NFKD", value)
    stripped = "".join(ch for ch in decomposed if not unicodedata.combining(ch))
    return _WHITESPACE.sub(" ", stripped.casefold()).strip()


def normalize_email(value: str) -> str:
    """Emails are matched case-insensitively, without touching the local part."""
    return value.strip().casefold()


def normalize_title(raw: str) -> tuple[str, str | None, list[str]]:
    """Clean a video title into (title, version, featured_artists).

    Keeps meaningful suffixes (Remix, Live, Remastered) in `version`.
    """
    if not raw:
        return "", None, []
    text = unicodedata.normalize("NFC", raw).strip()
    text = _TOPIC.sub("", text)
    text = text.replace("_", " ")

    featured: list[str] = []
    if match := _FEAT.search(text):
        featured = [part.strip() for part in re.split(r",|&| y ", match.group(1)) if part.strip()]
        text = text[: match.start()] + text[match.end() :]

    version: str | None = None
    if match := _VERSION.search(text):
        version = match.group(1).strip(" )]").title()
        text = text[: match.start()]

    text = _BRACKETS.sub(" ", text)
    text = _NOISE.sub(" ", text)

    text = _WHITESPACE.sub(" ", text).strip(" -–—|•·(")
    return text, version, featured


def title_case_es(value: str) -> str:
    """Light title casing that keeps Spanish particles lowercase."""
    small = {"de", "del", "la", "las", "el", "los", "y", "o", "a", "en", "con", "por", "para"}
    words = value.split()
    return " ".join(
        word.lower() if index and word.lower() in small else word[:1].upper() + word[1:]
        for index, word in enumerate(words)
    )
