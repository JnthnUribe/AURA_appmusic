.PHONY: help install run test lint fmt typecheck verify migrate revision seed worker client

help:
	@echo "install    uv sync (backend) + flutter pub get (app)"
	@echo "run        FastAPI dev server"
	@echo "worker     local ingest worker"
	@echo "test       backend + app tests"
	@echo "lint       ruff check + flutter analyze"
	@echo "fmt        ruff format + dart format"
	@echo "typecheck  pyright"
	@echo "verify     fmt-check, lint, typecheck, tests"
	@echo "migrate    alembic upgrade head"
	@echo "revision   alembic revision --autogenerate -m \"msg\""
	@echo "seed       load synthetic demo library"
	@echo "client     regenerate the Dart API client"

install:
	cd backend && uv sync
	cd app && flutter pub get

run:
	cd backend && uv run fastapi dev src/aura/main.py

worker:
	cd backend && uv run python -m aura.worker

test:
	cd backend && uv run pytest
	cd app && flutter test

lint:
	cd backend && uv run ruff check .
	cd app && flutter analyze

fmt:
	cd backend && uv run ruff format .
	cd app && dart format lib test

typecheck:
	cd backend && uv run pyright

verify: lint typecheck test

migrate:
	cd backend && uv run alembic upgrade head

revision:
	cd backend && uv run alembic revision --autogenerate -m "$(m)"

seed:
	cd backend && uv run python ../scripts/seed_demo.py

client:
	bash scripts/gen_client.sh
