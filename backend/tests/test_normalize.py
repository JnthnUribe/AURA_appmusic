"""Text normalization and title cleaning."""

from __future__ import annotations

import pytest

from aura.core.normalize import normalize_email, normalize_text, normalize_title, title_case_es


def test_normalize_accents_and_enie() -> None:
    assert normalize_text("Canción") == "cancion"
    assert normalize_text("  Niño   Español ") == "nino espanol"
    assert normalize_text("AC/DC") == "ac/dc"


@pytest.mark.parametrize(
    ("raw", "title", "version"),
    [
        ("Bad Bunny - Tití Me Preguntó (Official Video)", "Bad Bunny - Tití Me Preguntó", None),
        ("Daft Punk - Get Lucky (Official Audio)", "Daft Punk - Get Lucky", None),
        ("Rosalía - DESPECHÁ (Lyric Video)", "Rosalía - DESPECHÁ", None),
        (
            "The Weeknd - Blinding Lights (Official Music Video)",
            "The Weeknd - Blinding Lights",
            None,
        ),
        ("Shakira - La Tortura (Live)", "Shakira - La Tortura", "Live"),
        ("Dua Lipa - Levitating (Remix)", "Dua Lipa - Levitating", "Remix"),
        (
            "Queen - Bohemian Rhapsody (Remastered 2011)",
            "Queen - Bohemian Rhapsody",
            "Remastered 2011",
        ),
        ("Feid - Luna - Topic", "Feid - Luna", None),
        ("Karol G, Shakira - TQG (Official Video)", "Karol G, Shakira - TQG", None),
        ("Coldplay - Yellow [HD]", "Coldplay - Yellow", None),
        ("Adele - Hello (Official Video) ft. Someone", "Adele - Hello", None),
        (
            "Nirvana - Smells Like Teen Spirit (Official Music Video)",
            "Nirvana - Smells Like Teen Spirit",
            None,
        ),
    ],
)
def test_normalize_title(raw: str, title: str, version: str | None) -> None:
    cleaned, detected_version, _ = normalize_title(raw)
    assert cleaned == title
    assert detected_version == version


def test_normalize_title_featured() -> None:
    title, version, featured = normalize_title("Song (Official Video) feat. Bad Bunny & Rosalía")
    assert title == "Song"
    assert version is None
    assert featured == ["Bad Bunny", "Rosalía"]


def test_normalize_title_keeps_meaningful_version() -> None:
    title, version, _ = normalize_title("Song - Acoustic Version")
    assert title == "Song"
    assert version == "Acoustic Version"


def test_email_normalization() -> None:
    assert normalize_email("  User@Example.COM ") == "user@example.com"


def test_title_case() -> None:
    assert title_case_es("la canción del año") == "La Canción del Año"
