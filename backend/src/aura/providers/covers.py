"""Cover art discovery, real-size selection, derivatives, palette and placeholders."""

from __future__ import annotations

import asyncio
import base64
import colorsys
import io
import math
import random
from dataclasses import dataclass, field
from typing import Any

import httpx
from PIL import Image, ImageFilter
from rapidfuzz import fuzz

from aura.core.normalize import normalize_text

DERIVATIVE_SIZES = (64, 128, 256, 512, 1024)
SOURCE_PRIORITY = {"apple": 4, "coverartarchive": 3, "deezer": 2, "youtube_music": 1}


@dataclass(slots=True)
class CoverCandidate:
    provider: str
    url: str
    image: bytes
    width: int
    height: int
    score: float = 0.0
    mime: str = "image/jpeg"


@dataclass(slots=True)
class CoverSelection:
    chosen: CoverCandidate
    candidates: list[CoverCandidate] = field(default_factory=list)


async def _fetch(client: httpx.AsyncClient, url: str, provider: str) -> CoverCandidate | None:
    try:
        response = await client.get(url, follow_redirects=True, timeout=10)
        response.raise_for_status()
        payload = response.content
        with Image.open(io.BytesIO(payload)) as image:
            width, height = image.size
        return CoverCandidate(
            provider=provider,
            url=url,
            image=payload,
            width=width,
            height=height,
            mime=response.headers.get("content-type", "image/jpeg").split(";")[0],
        )
    except Exception:
        return None


async def itunes_candidates(
    client: httpx.AsyncClient, artist: str, album: str | None
) -> list[CoverCandidate]:
    term = f"{artist} {album or ''}".strip()
    response = await client.get(
        "https://itunes.apple.com/search",
        params={"term": term, "entity": "album", "limit": 5},
        timeout=10,
    )
    response.raise_for_status()
    results = response.json().get("results", [])
    urls: list[str] = []
    for item in results:
        artwork = item.get("artworkUrl100")
        if not artwork:
            continue
        if (
            album
            and fuzz.token_set_ratio(
                normalize_text(album), normalize_text(item.get("collectionName", ""))
            )
            < 55
        ):
            continue
        urls.append(artwork.replace("100x100bb", "3000x3000bb"))
    candidates = await asyncio.gather(*(_fetch(client, url, "apple") for url in urls[:2]))
    return [candidate for candidate in candidates if candidate]


async def coverart_candidates(
    client: httpx.AsyncClient, release_mbid: str | None
) -> list[CoverCandidate]:
    if not release_mbid:
        return []
    url = f"https://coverartarchive.org/release/{release_mbid}/front-1200"
    candidate = await _fetch(client, url, "coverartarchive")
    return [candidate] if candidate else []


async def deezer_candidates(
    client: httpx.AsyncClient, artist: str, album: str | None
) -> list[CoverCandidate]:
    if not album:
        return []
    response = await client.get(
        "https://api.deezer.com/search/album",
        params={"q": f"{artist} {album}", "limit": 3},
        timeout=10,
    )
    response.raise_for_status()
    data = response.json().get("data", [])
    urls: list[str] = []
    for item in data:
        if fuzz.token_set_ratio(normalize_text(album), normalize_text(item.get("title", ""))) < 55:
            continue
        if item.get("cover_xl"):
            urls.append(item["cover_xl"])
    candidates = await asyncio.gather(*(_fetch(client, url, "deezer") for url in urls[:2]))
    return [candidate for candidate in candidates if candidate]


async def youtube_candidates(url: str | None) -> list[CoverCandidate]:
    if not url:
        return []
    upgraded = url
    for size in ("w60", "w120", "w226", "w544", "hqdefault", "mqdefault", "sddefault"):
        if size in upgraded:
            upgraded = upgraded.replace(size, "maxresdefault")
            break
    async with httpx.AsyncClient(follow_redirects=True) as client:
        candidate = await _fetch(client, upgraded, "youtube_music")
    return [candidate] if candidate else []


def _is_square(width: int, height: int) -> bool:
    if not width or not height:
        return False
    return abs(width - height) / max(width, height) <= 0.02


def select_cover(candidates: list[CoverCandidate], *, album: str | None = None) -> CoverSelection:
    valid = [candidate for candidate in candidates if _is_square(candidate.width, candidate.height)]
    if not valid:
        raise ValueError("No square cover candidates were found")
    for candidate in valid:
        size = min(candidate.width, candidate.height)
        priority = SOURCE_PRIORITY.get(candidate.provider, 0)
        candidate.score = round(0.7 * min(size / 3000, 1.0) + 0.3 * (priority / 4), 4)
    chosen = max(
        valid,
        key=lambda item: (
            min(item.width, item.height),
            item.score,
            SOURCE_PRIORITY.get(item.provider, 0),
        ),
    )
    return CoverSelection(
        chosen=chosen, candidates=sorted(valid, key=lambda c: c.score, reverse=True)
    )


def derivatives(image_bytes: bytes) -> dict[int, bytes]:
    output: dict[int, bytes] = {}
    with Image.open(io.BytesIO(image_bytes)) as image:
        image = image.convert("RGB")
        for size in DERIVATIVE_SIZES:
            if size > min(image.size):
                continue
            resized = image.copy()
            resized.thumbnail((size, size), Image.Resampling.LANCZOS)
            buffer = io.BytesIO()
            resized.save(buffer, format="WEBP", quality=85, method=6)
            output[size] = buffer.getvalue()
    return output


def palette(image_bytes: bytes, colors: int = 5) -> dict[str, Any]:
    """Dominant colors via k-means in Lab, plus a readable text color."""
    with Image.open(io.BytesIO(image_bytes)) as image:
        sample = image.convert("RGB").resize((64, 64))
        width, height = sample.size
        pixels: list[tuple[int, int, int]] = [
            (int(pixel[0]), int(pixel[1]), int(pixel[2]))
            for y in range(height)
            for x in range(width)
            for pixel in [sample.getpixel((x, y))]
            if isinstance(pixel, tuple)
        ]
    points = [
        _rgb_to_lab(pixel)
        for pixel in random.Random(7).sample(pixels, min(400, len(pixels)))  # noqa: S311
    ]
    centroids = _kmeans(points, colors)
    hexes = [_lab_to_hex(centroid) for centroid in centroids]
    text_color = _readable_text_color(hexes[0])
    return {"colors": hexes, "text_color": text_color, "source": "kmeans-lab"}


def placeholder(image_bytes: bytes, size: int = 16) -> str:
    with Image.open(io.BytesIO(image_bytes)) as image:
        tiny = image.convert("RGB").resize((size, size))
        tiny = tiny.filter(ImageFilter.GaussianBlur(0.6))
        buffer = io.BytesIO()
        tiny.save(buffer, format="WEBP", quality=60)
    return "data:image/webp;base64," + base64.b64encode(buffer.getvalue()).decode()


# ── color helpers ───────────────────────────────────────────────────────────────


def _rgb_to_lab(rgb: tuple[int, int, int]) -> tuple[float, float, float]:
    r, g, b = (channel / 255 for channel in rgb)
    r, g, b = (
        ((value + 0.055) / 1.055) ** 2.4 if value > 0.04045 else value / 12.92
        for value in (r, g, b)
    )
    x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
    y = r * 0.2126 + g * 0.7152 + b * 0.0722
    z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883

    def f(t: float) -> float:
        return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116

    fx, fy, fz = f(x), f(y), f(z)
    return 116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)


def _lab_to_rgb(lab: tuple[float, float, float]) -> tuple[int, int, int]:
    lightness, a, b = lab
    fy = (lightness + 16) / 116
    fx = fy + a / 500
    fz = fy - b / 200

    def inverse(t: float) -> float:
        return t**3 if t**3 > 0.008856 else (t - 16 / 116) / 7.787

    x, y, z = inverse(fx) * 0.95047, inverse(fy), inverse(fz) * 1.08883
    red = x * 3.2406 + y * -1.5372 + z * -0.4986
    green = x * -0.9689 + y * 1.8758 + z * 0.0415
    blue = x * 0.0557 + y * -0.2040 + z * 1.0570

    def gamma(value: float) -> int:
        value = max(0.0, min(1.0, value))
        encoded = 1.055 * value ** (1 / 2.4) - 0.055 if value > 0.0031308 else 12.92 * value
        return round(max(0.0, min(1.0, encoded)) * 255)

    return gamma(red), gamma(green), gamma(blue)


def _kmeans(
    points: list[tuple[float, float, float]], k: int, iterations: int = 12
) -> list[tuple[float, float, float]]:
    if not points:
        return [(50.0, 0.0, 0.0)] * k
    k = min(k, len(points))
    centroids = points[:: max(1, len(points) // k)][:k]
    for _ in range(iterations):
        buckets: list[list[tuple[float, float, float]]] = [[] for _ in centroids]
        for point in points:
            index = min(
                range(len(centroids)),
                key=lambda i: sum((point[j] - centroids[i][j]) ** 2 for j in range(3)),
            )
            buckets[index].append(point)
        centroids = [
            (
                sum(point[0] for point in bucket) / len(bucket),
                sum(point[1] for point in bucket) / len(bucket),
                sum(point[2] for point in bucket) / len(bucket),
            )
            if bucket
            else centroids[index]
            for index, bucket in enumerate(buckets)
        ]
    return centroids


def _lab_to_hex(lab: tuple[float, float, float]) -> str:
    return "#{:02X}{:02X}{:02X}".format(*_lab_to_rgb(lab))


def _relative_luminance(hex_color: str) -> float:
    values = [int(hex_color[i : i + 2], 16) / 255 for i in (1, 3, 5)]
    linear = [
        value / 12.92 if value <= 0.03928 else ((value + 0.055) / 1.055) ** 2.4 for value in values
    ]
    return 0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]


def contrast_ratio(first: str, second: str) -> float:
    a, b = _relative_luminance(first), _relative_luminance(second)
    lighter, darker = max(a, b), min(a, b)
    return (lighter + 0.05) / (darker + 0.05)


def _readable_text_color(background: str) -> str:
    if contrast_ratio(background, "#FFFFFF") >= 4.5:
        return "#FFFFFF"
    if contrast_ratio(background, "#000000") >= 4.5:
        return "#000000"
    # Fall back to the closest of white/black after darkening the background.
    return "#000000" if _relative_luminance(background) > 0.35 else "#FFFFFF"


def average_color(image_bytes: bytes) -> str:
    with Image.open(io.BytesIO(image_bytes)) as image:
        tiny = image.convert("RGB").resize((1, 1))
        pixel = tiny.getpixel((0, 0))
    if not isinstance(pixel, tuple) or len(pixel) < 3:
        return "#000000"
    red, green, blue = int(pixel[0]), int(pixel[1]), int(pixel[2])
    return f"#{red:02X}{green:02X}{blue:02X}"


def hue_shift(hex_color: str, amount: float) -> str:
    red, green, blue = (int(hex_color[i : i + 2], 16) / 255 for i in (1, 3, 5))
    hue, lightness, saturation = colorsys.rgb_to_hls(red, green, blue)
    red, green, blue = colorsys.hls_to_rgb((hue + amount) % 1.0, lightness, saturation)
    return f"#{round(red * 255):02X}{round(green * 255):02X}{round(blue * 255):02X}"


def _hex_to_rgb(value: str) -> tuple[int, int, int]:
    return (int(value[1:3], 16), int(value[3:5], 16), int(value[5:7], 16))


def distance(first: str, second: str) -> float:
    return math.dist(_rgb_to_lab(_hex_to_rgb(first)), _rgb_to_lab(_hex_to_rgb(second)))
