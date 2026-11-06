"""Application configuration.

Everything comes from the environment. Production refuses to boot with a default
secret, and the app never reads a YAML config file.
"""

from __future__ import annotations

from functools import lru_cache
from typing import Literal

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

DEFAULT_JWT_SECRET = "dev-only-change-me"  # noqa: S105
DEFAULT_DATABASE_URL = "postgresql+psycopg://aura:aura@localhost:5432/aura"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=(".env", "../.env"),
        env_file_encoding="utf-8",
        extra="ignore",
        case_sensitive=False,
    )

    app_name: str = "Aura"
    app_env: Literal["dev", "test", "prod"] = "dev"
    app_base_url: str = "http://localhost:8000"
    log_level: str = "INFO"
    cors_origins: list[str] = Field(default_factory=lambda: ["http://localhost:3000"])

    database_url: str = DEFAULT_DATABASE_URL
    direct_database_url: str | None = None
    db_pool_size: int = 5
    db_max_overflow: int = 5
    db_pool_recycle_seconds: int = 240

    jwt_secret: str = DEFAULT_JWT_SECRET
    jwt_algorithm: str = "HS256"
    access_token_minutes: int = 15
    refresh_token_days: int = 30

    r2_account_id: str | None = None
    r2_access_key_id: str | None = None
    r2_secret_access_key: str | None = None
    r2_bucket_audio: str = "aura-audio"
    r2_bucket_art: str = "aura-art"
    r2_endpoint_url: str | None = None
    signed_url_ttl_seconds: int = 3600

    worker_token: str | None = None
    worker_poll_seconds: int = 25
    worker_concurrency: int = 1

    sentry_dsn: str | None = None
    anthropic_api_key: str | None = None
    ai_daily_budget_usd: float = 0.50
    ai_monthly_budget_usd: float = 5.00

    musicbrainz_user_agent: str = "Aura/0.1 (+https://github.com/jnthnuribe/aura)"
    lrclib_user_agent: str = "Aura/0.1 (+https://github.com/jnthnuribe/aura)"

    @field_validator("cors_origins", mode="before")
    @classmethod
    def _split_origins(cls, value: object) -> object:
        if isinstance(value, str) and not value.strip().startswith("["):
            return [item.strip() for item in value.split(",") if item.strip()]
        return value

    @property
    def is_prod(self) -> bool:
        return self.app_env == "prod"

    def validate_runtime(self) -> None:
        """Fail fast on insecure production configuration."""
        if self.is_prod:
            if self.jwt_secret == DEFAULT_JWT_SECRET or len(self.jwt_secret) < 32:
                raise RuntimeError(
                    "JWT_SECRET must be set to at least 32 random characters in prod"
                )
            if self.database_url == DEFAULT_DATABASE_URL:
                raise RuntimeError("DATABASE_URL must point to the production database")
            if "*" in self.cors_origins:
                raise RuntimeError("CORS_ORIGINS cannot contain '*' in prod")
        if self.app_env == "prod" and self.worker_token and len(self.worker_token) < 24:
            raise RuntimeError("WORKER_TOKEN must be at least 24 characters")


@lru_cache
def get_settings() -> Settings:
    return Settings()


def reset_settings_cache() -> None:
    get_settings.cache_clear()
