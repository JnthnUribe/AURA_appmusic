"""API surface without a database."""

from __future__ import annotations

from collections.abc import Iterator

import pytest
from fastapi.testclient import TestClient

from aura.core.config import Settings
from aura.main import create_app


@pytest.fixture(scope="module")
def client() -> Iterator[TestClient]:
    settings = Settings(
        app_env="test",
        jwt_secret="y" * 40,
        database_url="postgresql+psycopg://aura:aura@localhost:5432/aura",
        cors_origins=["http://localhost:3000"],
    )
    with TestClient(create_app(settings)) as test_client:
        yield test_client


def test_healthz_does_not_need_database(client: TestClient) -> None:
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_version(client: TestClient) -> None:
    response = client.get("/v1/version")
    assert response.status_code == 200
    body = response.json()
    assert body["version"] == "0.1.0"
    assert body["environment"] == "test"


def test_protected_route_returns_problem_json(client: TestClient) -> None:
    response = client.get("/v1/tracks")
    assert response.status_code == 401
    assert response.headers["content-type"].startswith("application/problem+json")
    body = response.json()
    assert body["status"] == 401
    assert body["request_id"]


def test_invalid_body_returns_problem_json(client: TestClient) -> None:
    response = client.post("/v1/auth/login", json={"email": "not-an-email", "password": "short"})
    assert response.status_code == 422
    assert response.headers["content-type"].startswith("application/problem+json")
    assert response.json()["errors"]


def test_request_id_is_echoed(client: TestClient) -> None:
    response = client.get("/healthz", headers={"X-Request-ID": "test-123"})
    assert response.headers["x-request-id"] == "test-123"


def test_openapi_contains_contract_groups(client: TestClient) -> None:
    schema = client.get("/openapi.json").json()
    assert "/v1/auth/login" in schema["paths"]
    assert "/v1/ingest" in schema["paths"]
    assert "/v1/jobs/{job_id}/events" in schema["paths"]
    assert "/v1/search" in schema["paths"]
    assert schema["info"]["title"] == "Aura API"
