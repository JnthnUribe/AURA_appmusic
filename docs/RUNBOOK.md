# Aura — Runbook

Operational guide for running, deploying and recovering Aura. Configuration is
environment-driven; no secret belongs in git.

## 1. First-time setup

```bash
cp .env.example .env
```

Fill at least:

```dotenv
APP_ENV=dev
APP_BASE_URL=http://localhost:8000
DATABASE_URL=postgresql+psycopg://aura:aura@localhost:5432/aura
DIRECT_DATABASE_URL=postgresql+psycopg://aura:aura@localhost:5432/aura
JWT_SECRET=<openssl rand -hex 32>
WORKER_TOKEN=<openssl rand -hex 32>
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET_AUDIO=aura-audio
R2_BUCKET_ART=aura-art
```

Generate secrets:

```bash
openssl rand -hex 32
# or PowerShell:
# -join ((48..57) + (97..102) | Get-Random -Count 64 | % {[char]$_})
```

Install and migrate:

```bash
cd backend
uv sync --dev
uv run alembic upgrade head
uv run aura create-user --email you@example.com --password 'a-long-password' --timezone Europe/Madrid
```

Run the API:

```bash
uv run fastapi dev src/aura/main.py     # development
# or
uv run uvicorn aura.main:app --host 0.0.0.0 --port 8000
```

Local database:

```bash
docker compose -f infra/docker-compose.yml up -d postgres
```

## 2. Worker

The worker needs `ffmpeg`, `deno` and `yt-dlp` on `PATH`. It uses
`DIRECT_DATABASE_URL`, `WORKER_TOKEN`, `APP_BASE_URL` and the `R2_*` variables.

```bash
cd backend
uv run python -m aura.worker
```

Expected startup logs: `worker_started`, provider availability, then idle
long-polls. It never listens on a port.

### Windows (Task Scheduler)

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install_worker_windows.ps1 -StartNow
Get-ScheduledTask -TaskName 'Aura Worker'
Get-Content worker.log -Tail 50 -Wait
```

Remove it with `-Uninstall`. The task runs in the user session so it can reach
the residential network and wake the display state while working.

### Linux (systemd user unit)

```bash
cp scripts/worker.service ~/.config/systemd/user/aura-worker.service
# edit WorkingDirectory and EnvironmentFile
systemctl --user daemon-reload
systemctl --user enable --now aura-worker
journalctl --user -u aura-worker -f
```

### Troubleshooting downloads

| Symptom | Check |
| --- | --- |
| `yt-dlp` fails with bot/signature errors | Install/upgrade Deno; the worker updates yt-dlp weekly unless `AURA_AUTO_UPDATE_YTDLP=0` |
| Jobs stay `queued` | Worker running? `WORKER_TOKEN` valid? `APP_BASE_URL` reachable? |
| Jobs fail at upload | R2 credentials, bucket names, endpoint; signed URLs are never logged |
| Job stuck `running` | Restart the worker; stale jobs are recovered at startup |
| Missing ffmpeg | Install it and ensure it is on the service `PATH` |

## 3. Deployment

### Render (API)

`render.yaml` defines a Docker web service with `/healthz` as the probe. Required
environment variables are marked `sync: false`; set them in the Render dashboard.
Migrations are not run automatically by the health check. Run them as a release
step or manually before the rollout:

```bash
cd backend
uv run alembic upgrade head
```

The API keeps no persistent disk and never uploads media.

### Neon (PostgreSQL)

- Use the **pooled** connection string for `DATABASE_URL`.
- Use the **direct** connection string for `DIRECT_DATABASE_URL` and Alembic.
- Keep a branch or snapshot before destructive migrations.
- `/healthz` never touches the database; only `/readyz` may wake it.

### Cloudflare R2

- Two private buckets: `aura-audio` and `aura-art`.
- CORS only if a web build needs direct reads.
- Keys are content-addressed (`audio/ab/<sha256>.m4a`,
  `art/ab/<sha256>.webp`, `waveform/ab/<sha256>.json`).
- Scope the token to these buckets; never commit it.

### Flutter

```bash
cd app
flutter pub get
dart run build_runner build --force-jit
flutter build apk --release --dart-define-from-file=env/prod.json
flutter build windows --release --dart-define-from-file=env/prod.json
```

Android signing keys and `key.properties` stay outside the repository. For iOS,
use a macOS runner with the appropriate provisioning profile. On Windows,
`libmpv-2.dll` must sit beside the executable for `just_audio_media_kit`.

## 4. Migrations

Expand/contract only:

1. Add nullable columns or new tables; deploy code that tolerates both shapes.
2. Backfill with a script or job and verify counts.
3. Tighten constraints or drop old columns in a later release.

Commands:

```bash
cd backend
uv run alembic revision --autogenerate -m "short message"
# review the generated file: types, indexes, ON DELETE, checks, extensions
uv run alembic upgrade head
uv run alembic downgrade -1
uv run alembic upgrade head
```

Never edit an applied migration. Test downgrade on a copy, never production.

## 5. Backups and restore

- **Neon:** enable PITR/branching on the plan; take a weekly logical dump.
- **R2:** enable object versioning or a lifecycle rule. Because keys are
  content-addressed, restoring the metadata is enough to relink objects.
- Keep dumps encrypted and out of git.

Logical dump:

```bash
pg_dump "$DIRECT_DATABASE_URL" --format=custom --file=aura-$(date +%F).dump
```

Restore into a fresh branch/database:

```bash
pg_restore --clean --if-exists --no-owner \
  --dbname "$RESTORE_DATABASE_URL" aura-2026-11-06.dump
cd backend && DIRECT_DATABASE_URL="$RESTORE_DATABASE_URL" uv run alembic upgrade head
```

Verify row counts for `users`, `tracks`, `assets`, `jobs` and `plays` before
pointing the API at the restored database. Test this quarterly.

## 6. Rollback

1. Stop the worker so mixed-version jobs cannot run.
2. Roll back the Render image to the last known good deploy.
3. Prefer a forward fix over a schema downgrade.
4. If a downgrade is unavoidable, confirm the previous release reads the older
   shape and restore from a tested snapshot as a last resort.
5. Restart the worker and confirm the queue drains.

## 7. Monitoring

- UptimeRobot: `https://<api>/healthz` every 5 minutes (does not wake Neon).
- Optional: `/readyz` with a longer interval if you accept occasional wake-ups.
- Sentry: set `SENTRY_DSN` on the API and worker; the Flutter integration is not
  wired yet.
- Logs are structured JSON with `request_id`; never log tokens or signed URLs.

## 8. Routine checks

```bash
cd backend
uv run pytest
uv run ruff check . && uv run ruff format --check .
uv run pyright

cd ../app
flutter analyze
flutter test
```

Before a release also verify:

- [ ] `JWT_SECRET` ≥ 32 bytes and not the default
- [ ] `WORKER_TOKEN` ≥ 24 bytes
- [ ] CORS has no `*`
- [ ] `docs/openapi.json` matches the routers
- [ ] Migrations applied and reversible
- [ ] `/healthz` works with the database paused
- [ ] A downloaded track plays in airplane mode

## 9. Demo data

Seed a synthetic library (no audio, so streaming will fail until a real ingest):

```bash
cd backend
uv run python ../scripts/seed_demo.py --email demo@aura.local --password aura-demo-1234
```

Add `--reset` to rebuild the demo user.
