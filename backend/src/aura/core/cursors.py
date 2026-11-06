"""Opaque keyset pagination cursors (base64 JSON, validated)."""

from __future__ import annotations

import base64
import binascii
import json
from dataclasses import dataclass
from datetime import UTC, datetime

from aura.core.errors import AppError


@dataclass(frozen=True, slots=True)
class Cursor:
    added_at: datetime
    id: str


def encode_cursor(added_at: datetime, item_id: str) -> str:
    payload = {"t": added_at.astimezone(UTC).isoformat(), "i": str(item_id)}
    raw = json.dumps(payload, separators=(",", ":")).encode()
    return base64.urlsafe_b64encode(raw).decode().rstrip("=")


def decode_cursor(value: str | None) -> Cursor | None:
    if not value:
        return None
    padded = value + "=" * (-len(value) % 4)
    try:
        payload = json.loads(base64.urlsafe_b64decode(padded))
        parsed = datetime.fromisoformat(payload["t"])
        if parsed.tzinfo is None:
            parsed = parsed.replace(tzinfo=UTC)
        return Cursor(added_at=parsed, id=str(payload["i"]))
    except (
        KeyError,
        ValueError,
        TypeError,
        binascii.Error,
        json.JSONDecodeError,
        UnicodeDecodeError,
    ) as exc:
        raise AppError(
            400, "Invalid cursor", "The pagination cursor is malformed", code="invalid_cursor"
        ) from exc
