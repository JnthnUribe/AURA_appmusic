"""Seed a synthetic library so the app can be explored without downloads.

Run from the backend directory:

    uv run python ../scripts/seed_demo.py --email demo@aura.local --password aura-demo-1234

The script is idempotent: if the user already exists it stops unless --reset is
passed. It never touches R2, so tracks have metadata but no audio.
"""

# ruff: noqa: S311

from __future__ import annotations

import argparse
import asyncio
import random
import sys
from datetime import UTC, datetime, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "backend" / "src"))

from sqlalchemy import delete

from aura.core.config import Settings
from aura.db.models import (
    Album,
    Artist,
    Favorite,
    Lyrics,
    Play,
    Playlist,
    PlaylistTrack,
    StatsDaily,
    Track,
    TrackArtist,
    User,
)
from aura.db.session import create_engine, create_sessionmaker
from aura.services.auth import create_user, get_user_by_email

ARTISTS = [
    ("Marina Azul", "Marina Azul"),
    ("Los Faros", "Faros, Los"),
    ("Nube Roja", "Nube Roja"),
    ("Eco Lejano", "Eco Lejano"),
]

ALBUMS = [
    ("Nocturno", 0, 2024, "Un disco lento para la ciudad dormida."),
    ("Marea", 1, 2023, "Guitarras y sintetizadores costeros."),
    ("Pulso", 2, 2025, "Ritmo y claridad."),
    ("Cartas", 3, 2022, "Canciones pequeñas."),
]

TRACKS = [
    ("Luz de luna", 0, 0, 1, 214000),
    ("Ventana abierta", 0, 0, 2, 198000),
    ("Calle vacía", 0, 0, 3, 232000),
    ("Marea baja", 1, 1, 1, 205000),
    ("Sal y viento", 1, 1, 2, 221000),
    ("Faro", 1, 1, 3, 189000),
    ("Pulso", 2, 2, 1, 201000),
    ("Gravedad", 2, 2, 2, 244000),
    ("Cerca", 2, 2, 3, 176000),
    ("Carta uno", 3, 3, 1, 167000),
    ("Carta dos", 3, 3, 2, 183000),
    ("Despedida", 3, 3, 3, 255000),
]

LYRICS = {
    "Luz de luna": [
        (0, 4200, "La luna entra por la ventana"),
        (4200, 8600, "y la ciudad se queda en calma"),
        (8600, 13000, "solo queda tu voz"),
        (13000, 0, "en la radio de la cocina"),
    ],
    "Marea baja": [
        (0, 3600, "Baja la marea"),
        (3600, 7900, "y el mundo respira"),
        (7900, 12400, "sin pedir nada"),
    ],
}


async def seed(email: str, password: str, reset: bool) -> None:
    settings = Settings()
    engine = create_engine(settings)
    sessionmaker = create_sessionmaker(engine)
    try:
        async with sessionmaker() as session:
            existing = await get_user_by_email(session, email)
            if existing is not None and not reset:
                print(f"User {email} already exists; nothing to do. Use --reset to rebuild.")
                return
            if existing is not None:
                await session.execute(delete(User).where(User.id == existing.id))
                await session.commit()

            user = await create_user(
                session,
                email=email,
                password=password,
                display_name="Demo",
                timezone="Europe/Madrid",
            )
            await session.flush()

            artists = []
            for name, sort_name in ARTISTS:
                artist = Artist(
                    name=name,
                    name_norm=name.lower(),
                    sort_name=sort_name,
                )
                session.add(artist)
                artists.append(artist)
            await session.flush()

            albums = []
            for title, artist_index, year, _description in ALBUMS:
                album = Album(
                    title=title,
                    title_norm=title.lower(),
                    album_artist_id=artists[artist_index].id,
                    year=year,
                    total_tracks=3,
                    total_discs=1,
                )
                session.add(album)
                albums.append(album)
            await session.flush()

            now = datetime.now(UTC)
            tracks: list[Track] = []
            for index, (title, album_index, artist_index, track_no, duration) in enumerate(TRACKS):
                track = Track(
                    user_id=user.id,
                    title=title,
                    title_norm=title.lower(),
                    album_id=albums[album_index].id,
                    track_no=track_no,
                    disc_no=1,
                    duration_ms=duration,
                    source_provider="demo",
                    source_ref=f"demo:{index + 1}",
                    loudness_lufs=random.uniform(-16.0, -9.0),
                    replaygain_db=random.uniform(-8.0, 4.0),
                    bpm=random.uniform(72, 132),
                    energy=random.uniform(0.2, 0.9),
                    status="ready",
                    added_at=now - timedelta(days=index * 2),
                )
                track.artists.append(
                    TrackArtist(
                        artist_id=artists[artist_index].id,
                        role="primary",
                        position=0,
                    )
                )
                session.add(track)
                tracks.append(track)
            await session.flush()

            for title, lines in LYRICS.items():
                track = next(item for item in tracks if item.title == title)
                session.add(
                    Lyrics(
                        track_id=track.id,
                        source="demo",
                        kind="synced",
                        language="es",
                        plain_text="\n".join(line[2] for line in lines),
                        plain_text_norm="\n".join(line[2].lower() for line in lines),
                        lines=[
                            {"t": start, "end": end, "text": text} for start, end, text in lines
                        ],
                        confidence=0.9,
                    )
                )

            for track in tracks[:6]:
                session.add(Favorite(user_id=user.id, track_id=track.id))

            playlist = Playlist(
                user_id=user.id,
                name="Noche",
                description="Para después de medianoche.",
                kind="manual",
            )
            session.add(playlist)
            await session.flush()
            for position, track in enumerate(tracks[:5]):
                session.add(
                    PlaylistTrack(
                        playlist_id=playlist.id,
                        track_id=track.id,
                        position=float(position),
                    )
                )

            random.seed(7)
            daily: dict = {}
            for index in range(80):
                track = random.choice(tracks)
                started = now - timedelta(
                    days=random.randint(0, 27),
                    hours=random.randint(0, 23),
                    minutes=random.randint(0, 59),
                )
                ms_played = min(track.duration_ms or 180000, random.randint(45000, 260000))
                session.add(
                    Play(
                        user_id=user.id,
                        track_id=track.id,
                        started_at=started,
                        ms_played=ms_played,
                        completed=ms_played >= (track.duration_ms or 180000) * 0.9,
                        source="seed",
                        device_id="demo-seed",
                        idempotency_key=f"seed-{index}",
                    )
                )
                day = started.date()
                row = daily.setdefault(day, {"plays": 0, "ms": 0, "tracks": set()})
                row["plays"] += 1
                row["ms"] += ms_played
                row["tracks"].add(track.id)

            for day, row in daily.items():
                session.add(
                    StatsDaily(
                        user_id=user.id,
                        day=day,
                        plays=row["plays"],
                        ms_played=row["ms"],
                        unique_tracks=len(row["tracks"]),
                    )
                )

            await session.commit()
            print(
                f"Seeded {len(artists)} artists, {len(albums)} albums, "
                f"{len(tracks)} tracks, 80 plays for {email}."
            )
            print("Tracks have metadata only; audio streaming will fail until a real ingest runs.")
    finally:
        await engine.dispose()


def main() -> None:
    parser = argparse.ArgumentParser(description="Seed a synthetic Aura library")
    parser.add_argument("--email", default="demo@aura.local")
    parser.add_argument("--password", default="aura-demo-1234")
    parser.add_argument("--reset", action="store_true", help="Delete and recreate the demo user")
    args = parser.parse_args()
    asyncio.run(seed(args.email, args.password, args.reset))


if __name__ == "__main__":
    main()
