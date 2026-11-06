"""Audio analysis and conversion with ffmpeg/ffprobe (worker only)."""

from __future__ import annotations

import asyncio
import json
import re
import shutil
from dataclasses import dataclass
from pathlib import Path


@dataclass(slots=True)
class AudioInfo:
    duration_ms: int
    codec: str
    bitrate_kbps: int | None
    mime: str
    path: Path
    loudness_lufs: float | None = None
    replaygain_db: float | None = None
    waveform: list[float] | None = None


async def probe(path: Path) -> AudioInfo:
    ffprobe = shutil.which("ffprobe")
    if not ffprobe:
        raise RuntimeError("ffprobe is not installed")
    process = await asyncio.create_subprocess_exec(
        ffprobe,
        "-v",
        "error",
        "-print_format",
        "json",
        "-show_format",
        "-show_streams",
        str(path),
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()
    if process.returncode != 0:
        raise RuntimeError(f"ffprobe failed: {stderr.decode(errors='replace')[:400]}")
    payload = json.loads(stdout)
    stream = next(
        (item for item in payload.get("streams", []) if item.get("codec_type") == "audio"), {}
    )
    fmt = payload.get("format", {})
    duration_s = float(fmt.get("duration") or stream.get("duration") or 0)
    bitrate = fmt.get("bit_rate") or stream.get("bit_rate")
    codec = stream.get("codec_name", "unknown")
    return AudioInfo(
        duration_ms=int(duration_s * 1000),
        codec=codec,
        bitrate_kbps=int(bitrate) // 1000 if bitrate else None,
        mime="audio/mp4" if codec in {"aac", "alac"} else f"audio/{codec}",
        path=path,
    )


async def ensure_m4a(path: Path) -> Path:
    """Convert to AAC/M4A only when the source is not already AAC in MP4."""
    if path.suffix.lower() in {".m4a", ".mp4"}:
        return path
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        raise RuntimeError("ffmpeg is not installed")
    target = path.with_suffix(".m4a")
    process = await asyncio.create_subprocess_exec(
        ffmpeg,
        "-y",
        "-i",
        str(path),
        "-vn",
        "-c:a",
        "aac",
        "-b:a",
        "256k",
        "-movflags",
        "+faststart",
        str(target),
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    _, stderr = await process.communicate()
    if process.returncode != 0:
        raise RuntimeError(f"ffmpeg conversion failed: {stderr.decode(errors='replace')[:400]}")
    return target


async def measure_loudness(path: Path) -> tuple[float | None, float | None]:
    """EBU R128 integrated loudness via ffmpeg's loudnorm filter."""
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        return None, None
    process = await asyncio.create_subprocess_exec(
        ffmpeg,
        "-hide_banner",
        "-nostats",
        "-i",
        str(path),
        "-af",
        "loudnorm=I=-14:TP=-1:LRA=11:print_format=json",
        "-f",
        "null",
        "-",
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    _, stderr = await process.communicate()
    text = stderr.decode(errors="replace")
    match = re.search(r"\{[\s\S]*?\}", text)
    if not match:
        return None, None
    try:
        data = json.loads(match.group(0))
        lufs = float(data["input_i"])
    except (KeyError, ValueError, json.JSONDecodeError):
        return None, None
    gain = -14.0 - lufs
    return round(lufs, 2), round(gain, 2)


async def waveform(path: Path, points: int = 128) -> list[float]:
    """Decode to mono 8 kHz PCM and keep `points` normalized peaks."""
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        return []
    process = await asyncio.create_subprocess_exec(
        ffmpeg,
        "-v",
        "error",
        "-i",
        str(path),
        "-ac",
        "1",
        "-ar",
        "8000",
        "-f",
        "s16le",
        "-",
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, _ = await process.communicate()
    if not stdout:
        return []
    samples = memoryview(stdout).cast("h")
    if not samples:
        return []
    bucket = max(1, len(samples) // points)
    peaks: list[float] = []
    for index in range(points):
        chunk = samples[index * bucket : (index + 1) * bucket]
        if not chunk:
            peaks.append(0.0)
            continue
        peak = max(abs(value) for value in chunk) / 32768
        peaks.append(round(min(peak, 1.0), 3))
    return peaks


async def analyze(path: Path, *, with_waveform: bool = True) -> AudioInfo:
    info = await probe(path)
    info.loudness_lufs, info.replaygain_db = await measure_loudness(path)
    if with_waveform:
        info.waveform = await waveform(path)
    return info
