"""LRC parser fixtures."""

from __future__ import annotations

from pathlib import Path

import pytest

from aura.core.lrc import parse_lrc, plain_to_document

FIXTURES = Path(__file__).parent / "fixtures" / "lrc"


def read(name: str) -> str:
    return (FIXTURES / name).read_text(encoding="utf-8")


def test_basic_metadata_and_times() -> None:
    document = parse_lrc(read("basic.lrc"))
    assert document.meta == {"ar": "Artist", "ti": "Title"}
    assert [line.t for line in document.lines] == [1000, 3500, 6250]
    assert [line.text for line in document.lines] == ["First line", "Second line", "Third line"]
    assert document.lines[0].end == 3500
    assert document.plain_text == "First line\nSecond line\nThird line"


def test_multiple_timestamps_per_line() -> None:
    document = parse_lrc(read("multi.lrc"))
    assert [line.t for line in document.lines] == [10000, 20000, 40000]
    assert all(line.text == "Chorus" for line in document.lines if line.t in {10000, 40000})


def test_empty_lines_are_instrumental_pauses() -> None:
    document = parse_lrc(read("empty_pause.lrc"))
    assert len(document.lines) == 3
    assert document.lines[0].text == ""
    assert document.lines[0].end == 5000
    assert document.lines[1].text == "After the intro"
    assert document.lines[2].text == ""


def test_enhanced_word_timings() -> None:
    document = parse_lrc(read("enhanced.lrc"))
    line = document.lines[0]
    assert line.text == "Hello world again"
    assert [word["text"] for word in line.words] == ["Hello", "world", "again"]
    assert [word["t"] for word in line.words] == [1000, 1500, 2000]


def test_offset_is_applied() -> None:
    document = parse_lrc(read("offset.lrc"))
    assert document.offset_ms == 500
    assert document.lines[0].t == 500


def test_timestamps_without_decimals() -> None:
    document = parse_lrc(read("no_decimals.lrc"))
    assert [line.t for line in document.lines] == [5000, 62000]


def test_crlf_and_bom() -> None:
    crlf = parse_lrc(read("crlf.lrc"))
    assert [line.text for line in crlf.lines] == ["Uno", "Dos"]
    bom = parse_lrc(read("bom.lrc"))
    assert bom.lines[0].text == "Con BOM"


def test_brackets_inside_lyrics_are_kept() -> None:
    document = parse_lrc(read("brackets.lrc"))
    assert document.lines[0].text == "Line [with] brackets"


def test_plain_lyrics_document() -> None:
    document = plain_to_document("Line one\n\nLine two\n")
    assert [line.text for line in document.lines] == ["Line one", "Line two"]


def test_duration_sets_last_end() -> None:
    document = parse_lrc("[00:01.00]Only", duration_ms=10_000)
    assert document.lines[0].end == 10_000


def test_hundreds_fraction() -> None:
    document = parse_lrc("[00:01.5]Tenths\n[00:02.50]Hundredths\n[00:03.500]Millis")
    assert [line.t for line in document.lines] == [1500, 2500, 3500]


@pytest.mark.parametrize("raw", ["", "no timestamps here", "[ar:Only metadata]"])
def test_empty_documents(raw: str) -> None:
    assert parse_lrc(raw).lines == []
