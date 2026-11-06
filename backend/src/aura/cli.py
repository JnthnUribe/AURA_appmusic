"""Command line utilities: create-user, export-openapi."""

from __future__ import annotations

import argparse
import asyncio
import json
from pathlib import Path

from aura.core.config import Settings
from aura.db.session import create_engine, create_sessionmaker


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="aura")
    sub = parser.add_subparsers(dest="command", required=True)

    create = sub.add_parser("create-user", help="Create a user (single-user app, multiuser schema)")
    create.add_argument("--email", required=True)
    create.add_argument("--password", required=True)
    create.add_argument("--name", default=None)
    create.add_argument("--timezone", default="UTC")

    export = sub.add_parser("export-openapi", help="Write docs/openapi.json")
    export.add_argument("--output", default="../docs/openapi.json")
    return parser


async def _create_user(args: argparse.Namespace) -> None:
    from aura.services.auth import create_user

    settings = Settings()
    engine = create_engine(settings)
    sessionmaker = create_sessionmaker(engine)
    try:
        async with sessionmaker() as session:
            user = await create_user(
                session,
                email=args.email,
                password=args.password,
                display_name=args.name,
                timezone=args.timezone,
            )
            await session.commit()
            print(f"Created user {user.email} ({user.id})")
    finally:
        await engine.dispose()


def _export_openapi(output: str) -> None:
    from aura.main import create_app

    schema = create_app().openapi()
    path = Path(output)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(schema, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"OpenAPI written to {path}")


def main() -> None:
    args = build_parser().parse_args()
    if args.command == "create-user":
        asyncio.run(_create_user(args))
    elif args.command == "export-openapi":
        _export_openapi(args.output)


if __name__ == "__main__":
    main()
