"""RFC 9457 problem+json errors."""

from __future__ import annotations

from typing import Any

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

PROBLEM_CONTENT_TYPE = "application/problem+json"


class AppError(Exception):
    """Domain error rendered as an RFC 9457 problem document."""

    def __init__(
        self,
        status: int,
        title: str,
        detail: str | None = None,
        *,
        code: str | None = None,
        extra: dict[str, Any] | None = None,
    ) -> None:
        super().__init__(detail or title)
        self.status = status
        self.title = title
        self.detail = detail
        self.code = code
        self.extra = extra or {}


class NotFoundError(AppError):
    def __init__(self, detail: str = "Resource not found") -> None:
        super().__init__(404, "Not found", detail, code="not_found")


class ConflictError(AppError):
    def __init__(self, detail: str = "Conflict") -> None:
        super().__init__(409, "Conflict", detail, code="conflict")


class AuthError(AppError):
    def __init__(self, detail: str = "Invalid credentials") -> None:
        super().__init__(401, "Unauthorized", detail, code="unauthorized")


class ForbiddenError(AppError):
    def __init__(self, detail: str = "Forbidden") -> None:
        super().__init__(403, "Forbidden", detail, code="forbidden")


def _problem(
    request: Request,
    status: int,
    title: str,
    detail: str | None = None,
    *,
    code: str | None = None,
    extra: dict[str, Any] | None = None,
) -> JSONResponse:
    body: dict[str, Any] = {
        "type": f"https://aura.local/problems/{code or status}",
        "title": title,
        "status": status,
        "detail": detail,
        "instance": request.url.path,
        "request_id": getattr(request.state, "request_id", None),
    }
    if extra:
        body.update(extra)
    return JSONResponse(status_code=status, content=body, media_type=PROBLEM_CONTENT_TYPE)


def install_error_handlers(app: FastAPI) -> None:
    @app.exception_handler(AppError)
    async def _app_error(request: Request, exc: AppError) -> JSONResponse:
        return _problem(
            request,
            exc.status,
            exc.title,
            exc.detail,
            code=exc.code,
            extra=exc.extra,
        )

    @app.exception_handler(StarletteHTTPException)
    async def _http_error(request: Request, exc: StarletteHTTPException) -> JSONResponse:
        detail = exc.detail if isinstance(exc.detail, str) else None
        return _problem(request, exc.status_code, "HTTP error", detail)

    @app.exception_handler(RequestValidationError)
    async def _validation_error(request: Request, exc: RequestValidationError) -> JSONResponse:
        errors = [
            {"loc": list(err.get("loc", [])), "msg": err.get("msg"), "type": err.get("type")}
            for err in exc.errors()
        ]
        return _problem(
            request,
            422,
            "Validation error",
            "The request body or query is invalid",
            code="validation_error",
            extra={"errors": errors},
        )

    @app.exception_handler(Exception)
    async def _unhandled(request: Request, exc: Exception) -> JSONResponse:
        return _problem(request, 500, "Internal server error", "Unexpected error")
