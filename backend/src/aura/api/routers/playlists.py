"""Playlists, favorites and tags."""

from __future__ import annotations

from uuid import UUID

from fastapi import APIRouter
from pydantic import BaseModel, Field
from sqlalchemy import select

from aura.api.deps import CurrentUser, SessionDep
from aura.core.errors import NotFoundError
from aura.db.models import Playlist, PlaylistTrack, Tag, TrackTag
from aura.schemas.common import Page, PlaylistOut, TagOut, TrackOut
from aura.services import library
from aura.services.serializers import playlist_out, track_out

router = APIRouter(prefix="/v1", tags=["library"])


class PlaylistCreate(BaseModel):
    name: str = Field(min_length=1, max_length=255)
    description: str | None = Field(default=None, max_length=2000)
    kind: str = Field(default="manual", pattern="^(manual|smart)$")
    rules: dict[str, object] | None = None


class PlaylistUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = Field(default=None, max_length=2000)
    rules: dict[str, object] | None = None


class PlaylistTrackAdd(BaseModel):
    track_id: UUID


class PlaylistReorder(BaseModel):
    track_ids: list[UUID]


class TagCreate(BaseModel):
    name: str = Field(min_length=1, max_length=80)
    color: str = Field(default="#7C9CFF", pattern="^#[0-9A-Fa-f]{6}$")


@router.get("/playlists", response_model=list[PlaylistOut])
async def list_playlists(session: SessionDep, user: CurrentUser):
    return await library.list_playlists(session, user.id)


@router.post("/playlists", response_model=PlaylistOut, status_code=201)
async def create_playlist(body: PlaylistCreate, session: SessionDep, user: CurrentUser):
    playlist = Playlist(
        user_id=user.id,
        name=body.name,
        description=body.description,
        kind=body.kind,
        rules=body.rules,
    )
    session.add(playlist)
    await session.flush()
    return playlist_out(playlist)


@router.get("/playlists/{playlist_id}")
async def get_playlist(playlist_id: UUID, session: SessionDep, user: CurrentUser):
    playlist = await library.get_playlist(session, user.id, playlist_id)
    rows = (
        await session.execute(
            select(PlaylistTrack)
            .where(PlaylistTrack.playlist_id == playlist.id)
            .order_by(PlaylistTrack.position)
        )
    ).scalars()
    items: list[TrackOut] = []
    for link in rows:
        try:
            track = await library.get_track(session, user.id, link.track_id)
        except NotFoundError:
            continue
        items.append(track_out(track))
    return {**playlist_out(playlist).model_dump(), "tracks": items}


@router.patch("/playlists/{playlist_id}", response_model=PlaylistOut)
async def update_playlist(
    playlist_id: UUID, body: PlaylistUpdate, session: SessionDep, user: CurrentUser
):
    playlist = await library.get_playlist(session, user.id, playlist_id)
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(playlist, field, value)
    return playlist_out(playlist)


@router.delete("/playlists/{playlist_id}", status_code=204)
async def delete_playlist(playlist_id: UUID, session: SessionDep, user: CurrentUser):
    playlist = await library.get_playlist(session, user.id, playlist_id)
    from aura.db.base import utcnow

    playlist.deleted_at = utcnow()


@router.post("/playlists/{playlist_id}/tracks", status_code=204)
async def add_track(
    playlist_id: UUID, body: PlaylistTrackAdd, session: SessionDep, user: CurrentUser
):
    await library.add_track_to_playlist(session, user.id, playlist_id, body.track_id)


@router.delete("/playlists/{playlist_id}/tracks/{track_id}", status_code=204)
async def remove_track(playlist_id: UUID, track_id: UUID, session: SessionDep, user: CurrentUser):
    await library.remove_track_from_playlist(session, user.id, playlist_id, track_id)


@router.put("/playlists/{playlist_id}/order", status_code=204)
async def reorder(playlist_id: UUID, body: PlaylistReorder, session: SessionDep, user: CurrentUser):
    await library.reorder_playlist(session, user.id, playlist_id, body.track_ids)


@router.get("/favorites", response_model=Page[TrackOut])
async def list_favorites(
    session: SessionDep, user: CurrentUser, limit: int = 100
) -> Page[TrackOut]:
    items = await library.list_favorites(session, user.id, limit=min(limit, 200))
    return Page(items=items)


@router.put("/favorites/{track_id}", status_code=204)
async def add_favorite(track_id: UUID, session: SessionDep, user: CurrentUser):
    await library.set_favorite(session, user.id, track_id, favorite=True)


@router.delete("/favorites/{track_id}", status_code=204)
async def remove_favorite(track_id: UUID, session: SessionDep, user: CurrentUser):
    await library.set_favorite(session, user.id, track_id, favorite=False)


@router.get("/tags", response_model=list[TagOut])
async def list_tags(session: SessionDep, user: CurrentUser):
    tags = await library.list_tags(session, user.id)
    return [TagOut(id=tag.id, name=tag.name, color=tag.color) for tag in tags]


@router.post("/tags", response_model=TagOut, status_code=201)
async def create_tag(body: TagCreate, session: SessionDep, user: CurrentUser):
    tag = Tag(user_id=user.id, name=body.name, color=body.color)
    session.add(tag)
    await session.flush()
    return TagOut(id=tag.id, name=tag.name, color=tag.color)


@router.delete("/tags/{tag_id}", status_code=204)
async def delete_tag(tag_id: UUID, session: SessionDep, user: CurrentUser):
    tag = await session.get(Tag, tag_id)
    if tag is None or tag.user_id != user.id:
        raise NotFoundError("Tag not found")
    await session.delete(tag)


@router.put("/tracks/{track_id}/tags/{tag_id}", status_code=204)
async def tag_track(track_id: UUID, tag_id: UUID, session: SessionDep, user: CurrentUser):
    await library.get_track(session, user.id, track_id)
    tag = await session.get(Tag, tag_id)
    if tag is None or tag.user_id != user.id:
        raise NotFoundError("Tag not found")
    existing = await session.get(TrackTag, {"track_id": track_id, "tag_id": tag_id})
    if existing is None:
        session.add(TrackTag(track_id=track_id, tag_id=tag_id))


@router.delete("/tracks/{track_id}/tags/{tag_id}", status_code=204)
async def untag_track(track_id: UUID, tag_id: UUID, session: SessionDep, user: CurrentUser):
    existing = await session.get(TrackTag, {"track_id": track_id, "tag_id": tag_id})
    if existing is not None:
        await session.delete(existing)
