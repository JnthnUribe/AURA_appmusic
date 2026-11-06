"""ORM → API schema serializers (explicit to keep responses stable)."""

from __future__ import annotations

from aura.db.models import Album, Artist, Playlist, Track
from aura.schemas.common import AlbumOut, AlbumRef, ArtistOut, ArtistRef, PlaylistOut, TrackOut


def artist_ref(artist: Artist) -> ArtistRef:
    return ArtistRef(id=artist.id, name=artist.name)


def album_ref(album: Album) -> AlbumRef:
    return AlbumRef(
        id=album.id, title=album.title, year=album.year, cover_asset_id=album.cover_asset_id
    )


def track_out(track: Track) -> TrackOut:
    artists = [
        ArtistRef(id=link.artist.id, name=link.artist.name)
        for link in sorted(track.artists, key=lambda item: item.position)
        if link.artist is not None
    ]
    return TrackOut(
        id=track.id,
        title=track.title,
        version=track.version,
        title_norm=track.title_norm,
        album=album_ref(track.album) if track.album else None,
        artists=artists,
        track_no=track.track_no,
        disc_no=track.disc_no,
        duration_ms=track.duration_ms,
        isrc=track.isrc,
        language=track.language,
        explicit=track.explicit,
        source_provider=track.source_provider,
        source_ref=track.source_ref,
        audio_asset_id=track.audio_asset_id,
        loudness_lufs=track.loudness_lufs,
        replaygain_db=track.replaygain_db,
        bpm=track.bpm,
        energy=track.energy,
        status=track.status,
        needs_review=track.needs_review,
        added_at=track.added_at,
        updated_at=track.updated_at,
        deleted_at=track.deleted_at,
    )


def album_out(album: Album) -> AlbumOut:
    return AlbumOut(
        id=album.id,
        title=album.title,
        year=album.year,
        cover_asset_id=album.cover_asset_id,
        album_artist=artist_ref(album.album_artist) if album.album_artist else None,
        total_tracks=album.total_tracks,
        release_date=album.release_date,
        created_at=album.created_at,
        updated_at=album.updated_at,
    )


def artist_out(artist: Artist) -> ArtistOut:
    return ArtistOut(
        id=artist.id,
        name=artist.name,
        sort_name=artist.sort_name,
        image_asset_id=artist.image_asset_id,
        created_at=artist.created_at,
        updated_at=artist.updated_at,
    )


def playlist_out(playlist: Playlist) -> PlaylistOut:
    return PlaylistOut(
        id=playlist.id,
        name=playlist.name,
        description=playlist.description,
        kind=playlist.kind,
        rules=playlist.rules,
        cover_asset_id=playlist.cover_asset_id,
        created_at=playlist.created_at,
        updated_at=playlist.updated_at,
    )
