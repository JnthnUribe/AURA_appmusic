"""Object storage: Cloudflare R2 via the S3 API, with a local dev fallback.

The API disk is ephemeral: in production every byte lives in R2. In development,
when R2 credentials are absent, objects go to `backend/var/objects` and are served
by a guarded dev route.
"""

from __future__ import annotations

import asyncio
import hashlib
import shutil
from pathlib import Path

from aura.core.config import Settings

DEV_ROOT = Path(__file__).resolve().parents[3] / "var" / "objects"


class Storage:
    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        self._client = None

    @property
    def configured(self) -> bool:
        return bool(
            self.settings.r2_account_id
            and self.settings.r2_access_key_id
            and self.settings.r2_secret_access_key
        )

    def _s3(self):
        if self._client is None:
            import boto3

            endpoint = self.settings.r2_endpoint_url or (
                f"https://{self.settings.r2_account_id}.r2.cloudflarestorage.com"
            )
            self._client = boto3.client(
                "s3",
                endpoint_url=endpoint,
                aws_access_key_id=self.settings.r2_access_key_id,
                aws_secret_access_key=self.settings.r2_secret_access_key,
                region_name="auto",
            )
        return self._client

    def _local_path(self, bucket: str, key: str) -> Path:
        return DEV_ROOT / bucket / key

    async def upload_file(self, bucket: str, key: str, path: Path, mime: str) -> None:
        if not self.configured:
            target = self._local_path(bucket, key)
            target.parent.mkdir(parents=True, exist_ok=True)
            await asyncio.to_thread(shutil.copyfile, path, target)
            return

        def _upload() -> None:
            self._s3().upload_file(
                str(path),
                bucket,
                key,
                ExtraArgs={"ContentType": mime, "CacheControl": "private, max-age=31536000"},
            )

        await asyncio.to_thread(_upload)

    async def upload_bytes(self, bucket: str, key: str, payload: bytes, mime: str) -> None:
        if not self.configured:
            target = self._local_path(bucket, key)
            target.parent.mkdir(parents=True, exist_ok=True)
            await asyncio.to_thread(target.write_bytes, payload)
            return

        def _put() -> None:
            self._s3().put_object(
                Bucket=bucket,
                Key=key,
                Body=payload,
                ContentType=mime,
                CacheControl="private, max-age=31536000",
            )

        await asyncio.to_thread(_put)

    async def presign_put(self, bucket: str, key: str, *, expires: int = 900) -> str:
        if not self.configured:
            return f"{self.settings.app_base_url}/v1/dev/upload/{bucket}/{key}"
        return await asyncio.to_thread(
            self._s3().generate_presigned_url,
            "put_object",
            Params={"Bucket": bucket, "Key": key},
            ExpiresIn=expires,
        )

    async def download_to(self, bucket: str, key: str, target: Path) -> Path:
        target.parent.mkdir(parents=True, exist_ok=True)
        if not self.configured:
            source = self._local_path(bucket, key)
            await asyncio.to_thread(shutil.copyfile, source, target)
            return target
        await asyncio.to_thread(self._s3().download_file, bucket, key, str(target))
        return target

    async def presign_get(self, bucket: str, key: str, *, expires: int | None = None) -> str:
        if not self.configured:
            return f"{self.settings.app_base_url}/v1/dev/media/{bucket}/{key}"
        ttl = expires or self.settings.signed_url_ttl_seconds

        def _sign() -> str:
            return self._s3().generate_presigned_url(
                "get_object",
                Params={"Bucket": bucket, "Key": key},
                ExpiresIn=ttl,
            )

        return await asyncio.to_thread(_sign)

    async def read_local(self, bucket: str, key: str) -> bytes | None:
        path = self._local_path(bucket, key)
        if not await asyncio.to_thread(path.exists):
            return None
        return await asyncio.to_thread(path.read_bytes)

    async def delete(self, bucket: str, key: str) -> None:
        if not self.configured:
            await asyncio.to_thread(self._local_path(bucket, key).unlink, True)
            return
        await asyncio.to_thread(self._s3().delete_object, Bucket=bucket, Key=key)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def content_key(prefix: str, sha256: str, suffix: str) -> str:
    return f"{prefix}/{sha256[:2]}/{sha256}{suffix}"
