"""Pagination cursors."""

from __future__ import annotations

from datetime import UTC, datetime

import pytest

from aura.core.cursors import decode_cursor, encode_cursor
from aura.core.errors import AppError


def test_cursor_roundtrip() -> None:
    moment = datetime(2026, 11, 1, 12, 30, 45, 123456, tzinfo=UTC)
    encoded = encode_cursor(moment, "01901234-5678-7abc-8def-0123456789ab")
    decoded = decode_cursor(encoded)
    assert decoded is not None
    assert decoded.added_at == moment
    assert decoded.id == "01901234-5678-7abc-8def-0123456789ab"


def test_empty_cursor_is_none() -> None:
    assert decode_cursor(None) is None
    assert decode_cursor("") is None


def test_invalid_cursor_raises_problem() -> None:
    with pytest.raises(AppError) as error:
        decode_cursor("not-base64!!!")
    assert error.value.status == 400
    assert error.value.code is not None
