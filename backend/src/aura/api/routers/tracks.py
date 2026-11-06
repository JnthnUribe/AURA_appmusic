"""Track library endpoints."""

from __future__ import annotations

import hashlib
from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Query, Request, Response

from aura.api.deps import CurrentUser, SessionDep
from aura.core.cursors import decode_cursor
from aura.core.errors import AppError, NotFoundError
from aura.core.normalize import normalize_text
from aura.db.models import Album
from aura.schemas.common import Page, TrackOut, TrackPatch
from aura.services import library

router = APIRouter(prefix="/v1", tags=["library"])


@router.get("/tracks", response_model=Page[TrackOut])
async def list_tracks(
    request: Request,
    response: Response,
    session: SessionDep,
    user: CurrentUser,
    limit: Annotated[int, Query(ge=1, le=200)] = 50,
    cursor: str | None = None,
    q: str | None = None,
    artist_id: UUID | None = None,
    album_id: UUID | None = None,
    tag: UUID | None = None,
    favorite: bool | None = None,
    added_since: datetime | None = None,
    updated_since: datetime | None = None,
    include_deleted: bool = False,
) -> Page[TrackOut] | Response:
    items, next_cursor = await library.list_tracks(
        session,
        user.id,
        limit=limit,
        cursor=decode_cursor(cursor),
        q=q,
        artist_id=artist_id,
        album_id=album_id,
        tag_id=tag,
        favorite=favorite,
        added_since=added_since,
        updated_since=updated_since,
        include_deleted=include_deleted,
    )
    etag = _etag([f"{item.id}:{item.updated_at.isoformat()}" for item in items])
    if request.headers.get("if-none-match") == etag:
        return Response(status_code=304, headers={"ETag": etag})
    response.headers["ETag"] = etag
    return Page(items=items, next_cursor=next_cursor)


@router.get("/tracks/{track_id}", response_model=TrackOut)
async def get_track(track_id: UUID, session: SessionDep, user: CurrentUser) -> TrackOut:
    track = await library.get_track(session, user.id, track_id)
    from aura.services.serializers import track_out

    return track_out(track)


@router.patch("/tracks/{track_id}", response_model=TrackOut)
async def patch_track(
    track_id: UUID, body: TrackPatch, session: SessionDep, user: CurrentUser
) -> TrackOut:
    from aura.services.serializers import track_out

    track = await library.get_track(session, user.id, track_id)
    data = body.model_dump(exclude_unset=True)
    if "album_id" in data and data["album_id"] is not None:
        album = await session.get(Album, data["album_id"])
        if album is None:
            raise NotFoundError("Album not found")
    for field, value in data.items():
        setattr(track, field, value)
    if "title" in data:
        track.title_norm = normalize_text(track.title)
    return track_out(track)


@router.delete("/tracks/{track_id}", status_code=204)
async def delete_track(track_id: UUID, session: SessionDep, user: CurrentUser) -> None:
    await library.soft_delete_track(session, user.id, track_id)


@router.get("/albums")
async def list_albums(
    session: SessionDep,
    user: CurrentUser,
    limit: Annotated[int, Query(ge=1, le=200)] = 50,
    q: str | None = None,
):
    return await library.list_albums(session, user.id, limit=limit, q=q)


@router.get("/albums/{album_id}")
async def get_album(album_id: UUID, session: SessionDep, user: CurrentUser):
    from aura.services.serializers import album_out

    return album_out(await library.get_album(session, album_id))


@router.get("/artists")
async def list_artists(
    session: SessionDep,
    user: CurrentUser,
    limit: Annotated[int, Query(ge=1, le=200)] = 50,
    q: str | None = None,
):
    return await library.list_artists(session, user.id, limit=limit, q=q)


@router.get("/artists/{artist_id}")
async def get_artist(artist_id: UUID, session: SessionDep, user: CurrentUser):
    from aura.services.serializers import artist_out

    return artist_out(await library.get_artist(session, artist_id))


@router.get("/search")
async def search(
    session: SessionDep,
    user: CurrentUser,
    q: Annotated[str, Query(min_length=1, max_length=200)],
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
):
    if len(q) > 200:
        raise AppError(400, "Query too long")
    return await library.search_library(session, user.id, q, limit=limit)


def _etag(parts: list[str]) -> str:
    digest = hashlib.sha256("|".join(parts).encode()).hexdigest()[:32]
    return f'W/"{digest}"'
