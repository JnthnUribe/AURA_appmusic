"""Library queries: tracks, albums, artists, playlists, favorites, tags."""

from __future__ import annotations

from datetime import datetime
from typing import Any
from uuid import UUID

from sqlalchemy import Select, delete, func, or_, select, tuple_, update
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from aura.core.cursors import Cursor, encode_cursor
from aura.core.errors import NotFoundError
from aura.core.normalize import normalize_text
from aura.db.base import utcnow
from aura.db.models import (
    Album,
    Artist,
    Favorite,
    Playlist,
    PlaylistTrack,
    Tag,
    Track,
    TrackArtist,
    TrackTag,
)
from aura.services.serializers import album_out, artist_out, playlist_out, track_out


def _track_query() -> Select[Any]:
    return select(Track).options(
        selectinload(Track.album),
        selectinload(Track.artists).selectinload(TrackArtist.artist),
    )


async def list_tracks(
    session: AsyncSession,
    user_id: UUID,
    *,
    limit: int = 50,
    cursor: Cursor | None = None,
    q: str | None = None,
    artist_id: UUID | None = None,
    album_id: UUID | None = None,
    tag_id: UUID | None = None,
    favorite: bool | None = None,
    added_since: datetime | None = None,
    updated_since: datetime | None = None,
    include_deleted: bool = False,
) -> tuple[list[Any], str | None]:
    stmt = _track_query().where(Track.user_id == user_id)
    if not include_deleted:
        stmt = stmt.where(Track.deleted_at.is_(None))
    if q:
        stmt = stmt.where(Track.title_norm.contains(normalize_text(q)))
    if album_id:
        stmt = stmt.where(Track.album_id == album_id)
    if artist_id:
        stmt = stmt.where(
            Track.id.in_(select(TrackArtist.track_id).where(TrackArtist.artist_id == artist_id))
        )
    if tag_id:
        stmt = stmt.where(Track.id.in_(select(TrackTag.track_id).where(TrackTag.tag_id == tag_id)))
    if favorite is not None:
        favorite_ids = select(Favorite.track_id).where(Favorite.user_id == user_id)
        stmt = stmt.where(Track.id.in_(favorite_ids) if favorite else Track.id.notin_(favorite_ids))
    if added_since:
        stmt = stmt.where(Track.added_at >= added_since)
    if updated_since:
        stmt = stmt.where(Track.updated_at >= updated_since)
    if cursor:
        stmt = stmt.where(tuple_(Track.added_at, Track.id) < tuple_(cursor.added_at, cursor.id))
    stmt = stmt.order_by(Track.added_at.desc(), Track.id.desc()).limit(limit + 1)

    rows = list((await session.execute(stmt)).scalars())
    next_cursor = None
    if len(rows) > limit:
        last = rows[limit - 1]
        next_cursor = encode_cursor(last.added_at, str(last.id))
        rows = rows[:limit]
    return [track_out(track) for track in rows], next_cursor


async def get_track(session: AsyncSession, user_id: UUID, track_id: UUID) -> Track:
    result = await session.execute(
        _track_query().where(
            Track.id == track_id, Track.user_id == user_id, Track.deleted_at.is_(None)
        )
    )
    track = result.scalar_one_or_none()
    if track is None:
        raise NotFoundError("Track not found")
    return track


async def soft_delete_track(session: AsyncSession, user_id: UUID, track_id: UUID) -> None:
    track = await get_track(session, user_id, track_id)
    track.deleted_at = utcnow()
    track.updated_at = utcnow()


async def list_albums(
    session: AsyncSession, user_id: UUID, *, limit: int = 50, q: str | None = None
) -> list[Any]:
    stmt = (
        select(Album)
        .options(selectinload(Album.album_artist))
        .where(Album.id.in_(select(Track.album_id).where(Track.user_id == user_id)))
        .order_by(Album.title_norm)
        .limit(limit)
    )
    if q:
        stmt = stmt.where(Album.title_norm.contains(normalize_text(q)))
    return [album_out(album) for album in (await session.execute(stmt)).scalars()]


async def list_artists(
    session: AsyncSession, user_id: UUID, *, limit: int = 50, q: str | None = None
) -> list[Any]:
    artist_ids = (
        select(TrackArtist.artist_id)
        .join(Track, Track.id == TrackArtist.track_id)
        .where(Track.user_id == user_id)
    )
    stmt = select(Artist).where(Artist.id.in_(artist_ids)).order_by(Artist.name_norm).limit(limit)
    if q:
        stmt = stmt.where(Artist.name_norm.contains(normalize_text(q)))
    return [artist_out(artist) for artist in (await session.execute(stmt)).scalars()]


async def get_album(session: AsyncSession, album_id: UUID) -> Album:
    result = await session.execute(
        select(Album).options(selectinload(Album.album_artist)).where(Album.id == album_id)
    )
    album = result.scalar_one_or_none()
    if album is None:
        raise NotFoundError("Album not found")
    return album


async def get_artist(session: AsyncSession, artist_id: UUID) -> Artist:
    artist = await session.get(Artist, artist_id)
    if artist is None:
        raise NotFoundError("Artist not found")
    return artist


async def list_playlists(session: AsyncSession, user_id: UUID) -> list[Any]:
    stmt = (
        select(Playlist)
        .where(Playlist.user_id == user_id, Playlist.deleted_at.is_(None))
        .order_by(Playlist.updated_at.desc())
    )
    return [playlist_out(playlist) for playlist in (await session.execute(stmt)).scalars()]


async def get_playlist(session: AsyncSession, user_id: UUID, playlist_id: UUID) -> Playlist:
    result = await session.execute(
        select(Playlist).where(
            Playlist.id == playlist_id,
            Playlist.user_id == user_id,
            Playlist.deleted_at.is_(None),
        )
    )
    playlist = result.scalar_one_or_none()
    if playlist is None:
        raise NotFoundError("Playlist not found")
    return playlist


async def add_track_to_playlist(
    session: AsyncSession, user_id: UUID, playlist_id: UUID, track_id: UUID
) -> None:
    playlist = await get_playlist(session, user_id, playlist_id)
    await get_track(session, user_id, track_id)
    max_position = (
        await session.execute(
            select(func.max(PlaylistTrack.position)).where(PlaylistTrack.playlist_id == playlist.id)
        )
    ).scalar()
    session.add(
        PlaylistTrack(
            playlist_id=playlist.id,
            track_id=track_id,
            position=(max_position or 0.0) + 1024.0,
        )
    )


async def remove_track_from_playlist(
    session: AsyncSession, user_id: UUID, playlist_id: UUID, track_id: UUID
) -> None:
    playlist = await get_playlist(session, user_id, playlist_id)
    await session.execute(
        delete(PlaylistTrack).where(
            PlaylistTrack.playlist_id == playlist.id, PlaylistTrack.track_id == track_id
        )
    )


async def reorder_playlist(
    session: AsyncSession, user_id: UUID, playlist_id: UUID, ordered_track_ids: list[UUID]
) -> None:
    playlist = await get_playlist(session, user_id, playlist_id)
    for index, track_id in enumerate(ordered_track_ids):
        await session.execute(
            update(PlaylistTrack)
            .where(
                PlaylistTrack.playlist_id == playlist.id,
                PlaylistTrack.track_id == track_id,
            )
            .values(position=float(index + 1) * 1024.0)
        )


async def set_favorite(
    session: AsyncSession, user_id: UUID, track_id: UUID, *, favorite: bool
) -> None:
    await get_track(session, user_id, track_id)
    if favorite:
        exists = await session.get(Favorite, {"user_id": user_id, "track_id": track_id})
        if exists is None:
            session.add(Favorite(user_id=user_id, track_id=track_id))
    else:
        await session.execute(
            delete(Favorite).where(Favorite.user_id == user_id, Favorite.track_id == track_id)
        )


async def list_favorites(session: AsyncSession, user_id: UUID, limit: int = 100) -> list[Any]:
    stmt = (
        _track_query()
        .join(Favorite, Favorite.track_id == Track.id)
        .where(Favorite.user_id == user_id, Track.deleted_at.is_(None))
        .order_by(Favorite.created_at.desc())
        .limit(limit)
    )
    return [track_out(track) for track in (await session.execute(stmt)).scalars()]


async def list_tags(session: AsyncSession, user_id: UUID) -> list[Tag]:
    result = await session.execute(select(Tag).where(Tag.user_id == user_id).order_by(Tag.name))
    return list(result.scalars())


async def search_library(
    session: AsyncSession, user_id: UUID, query: str, limit: int = 20
) -> dict[str, Any]:
    normalized = normalize_text(query)
    if not normalized:
        return {"tracks": [], "albums": [], "artists": []}

    track_stmt = (
        _track_query()
        .where(Track.user_id == user_id, Track.deleted_at.is_(None))
        .where(
            or_(
                Track.title_norm.contains(normalized),
                func.similarity(Track.title_norm, normalized) > 0.25,
            )
        )
        .order_by(
            func.similarity(Track.title_norm, normalized).desc(),
            Track.added_at.desc(),
        )
        .limit(limit)
    )
    album_stmt = (
        select(Album)
        .options(selectinload(Album.album_artist))
        .where(Album.id.in_(select(Track.album_id).where(Track.user_id == user_id)))
        .where(
            or_(
                Album.title_norm.contains(normalized),
                func.similarity(Album.title_norm, normalized) > 0.25,
            )
        )
        .order_by(func.similarity(Album.title_norm, normalized).desc())
        .limit(limit)
    )
    artist_ids = (
        select(TrackArtist.artist_id)
        .join(Track, Track.id == TrackArtist.track_id)
        .where(Track.user_id == user_id)
    )
    artist_stmt = (
        select(Artist)
        .where(Artist.id.in_(artist_ids))
        .where(
            or_(
                Artist.name_norm.contains(normalized),
                func.similarity(Artist.name_norm, normalized) > 0.25,
            )
        )
        .order_by(func.similarity(Artist.name_norm, normalized).desc())
        .limit(limit)
    )
    tracks = [track_out(track) for track in (await session.execute(track_stmt)).scalars()]
    albums = [album_out(album) for album in (await session.execute(album_stmt)).scalars()]
    artists = [artist_out(artist) for artist in (await session.execute(artist_stmt)).scalars()]
    return {"tracks": tracks, "albums": albums, "artists": artists}
