"""Embed metadata, cover art and lyrics with mutagen."""

from __future__ import annotations

import io
from pathlib import Path
from typing import Any

from PIL import Image


def _jpeg_cover(image_bytes: bytes, max_size: int = 3000) -> bytes:
    with Image.open(io.BytesIO(image_bytes)) as image:
        image = image.convert("RGB")
        if max(image.size) > max_size:
            image.thumbnail((max_size, max_size), Image.Resampling.LANCZOS)
        buffer = io.BytesIO()
        image.save(buffer, format="JPEG", quality=95, optimize=True)
    return buffer.getvalue()


def embed(
    path: Path,
    *,
    title: str,
    artists: list[str],
    album: str | None,
    year: int | None,
    track_no: int | None,
    disc_no: int | None,
    isrc: str | None,
    mbid: str | None,
    album_mbid: str | None,
    cover: bytes | None,
    lyrics: str | None,
) -> None:
    suffix = path.suffix.lower()
    if suffix in {".m4a", ".mp4", ".aac"}:
        _embed_mp4(
            path,
            title=title,
            artists=artists,
            album=album,
            year=year,
            track_no=track_no,
            disc_no=disc_no,
            isrc=isrc,
            mbid=mbid,
            album_mbid=album_mbid,
            cover=cover,
            lyrics=lyrics,
        )
    elif suffix == ".mp3":
        _embed_mp3(
            path,
            title=title,
            artists=artists,
            album=album,
            year=year,
            track_no=track_no,
            disc_no=disc_no,
            isrc=isrc,
            mbid=mbid,
            cover=cover,
            lyrics=lyrics,
        )
    elif suffix == ".flac":
        _embed_flac(
            path,
            title=title,
            artists=artists,
            album=album,
            year=year,
            track_no=track_no,
            disc_no=disc_no,
            cover=cover,
            lyrics=lyrics,
        )


def _embed_mp4(path: Path, **meta: Any) -> None:
    from mutagen.mp4 import MP4, MP4Cover

    audio = MP4(path)
    if audio.tags is None:
        audio.add_tags()
    tags = audio.tags
    assert tags is not None
    tags["\xa9nam"] = [meta["title"]]
    if meta["artists"]:
        tags["\xa9ART"] = ["; ".join(meta["artists"])]
        tags["aART"] = [meta["artists"][0]]
    if meta["album"]:
        tags["\xa9alb"] = [meta["album"]]
    if meta["year"]:
        tags["\xa9day"] = [str(meta["year"])]
    if meta["track_no"]:
        tags["trkn"] = [(int(meta["track_no"]), 0)]
    if meta["disc_no"]:
        tags["disk"] = [(int(meta["disc_no"]), 0)]
    if meta["isrc"]:
        tags["----:com.apple.iTunes:ISRC"] = [meta["isrc"].encode()]
    if meta["mbid"]:
        tags["----:com.apple.iTunes:MusicBrainz Track Id"] = [meta["mbid"].encode()]
    if meta["album_mbid"]:
        tags["----:com.apple.iTunes:MusicBrainz Album Id"] = [meta["album_mbid"].encode()]
    if meta["cover"]:
        tags["covr"] = [MP4Cover(_jpeg_cover(meta["cover"]), imageformat=MP4Cover.FORMAT_JPEG)]
    if meta["lyrics"]:
        tags["\xa9lyr"] = [meta["lyrics"]]
    audio.save()


def _embed_mp3(path: Path, **meta: Any) -> None:
    from mutagen.id3 import APIC, ID3, TALB, TDRC, TIT2, TPE1, TPOS, TRCK, TXXX, USLT

    try:
        tags = ID3(path)
    except Exception:
        tags = ID3()
    tags.delall("TIT2")
    tags.add(TIT2(encoding=3, text=meta["title"]))
    tags.delall("TPE1")
    tags.add(TPE1(encoding=3, text="; ".join(meta["artists"])))
    if meta["album"]:
        tags.add(TALB(encoding=3, text=meta["album"]))
    if meta["year"]:
        tags.add(TDRC(encoding=3, text=str(meta["year"])))
    if meta["track_no"]:
        tags.add(TRCK(encoding=3, text=str(meta["track_no"])))
    if meta["disc_no"]:
        tags.add(TPOS(encoding=3, text=str(meta["disc_no"])))
    if meta["isrc"]:
        tags.add(TXXX(encoding=3, desc="ISRC", text=meta["isrc"]))
    if meta["mbid"]:
        tags.add(TXXX(encoding=3, desc="MusicBrainz Track Id", text=meta["mbid"]))
    if meta["cover"]:
        tags.add(
            APIC(
                encoding=3,
                mime="image/jpeg",
                type=3,
                desc="Cover",
                data=_jpeg_cover(meta["cover"]),
            )
        )
    if meta["lyrics"]:
        tags.add(USLT(encoding=3, lang="spa", desc="", text=meta["lyrics"]))
    tags.save(path)


def _embed_flac(path: Path, **meta: Any) -> None:
    from mutagen.flac import FLAC, Picture

    audio = FLAC(path)
    audio["title"] = meta["title"]
    if meta["artists"]:
        audio["artist"] = meta["artists"]
    if meta["album"]:
        audio["album"] = meta["album"]
    if meta["year"]:
        audio["date"] = str(meta["year"])
    if meta["track_no"]:
        audio["tracknumber"] = str(meta["track_no"])
    if meta["disc_no"]:
        audio["discnumber"] = str(meta["disc_no"])
    if meta["lyrics"]:
        audio["lyrics"] = meta["lyrics"]
    if meta["cover"]:
        picture = Picture()
        picture.type = 3
        picture.mime = "image/jpeg"
        picture.data = _jpeg_cover(meta["cover"])
        audio.add_picture(picture)
    audio.save()
