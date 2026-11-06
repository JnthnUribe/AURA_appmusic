#!/usr/bin/env bash
# Export the canonical OpenAPI contract and optionally generate a reference
# Dart client. The production client in app/lib is hand-written on purpose
# (explicit models, no codegen), so generated code goes to app/build and is not
# committed.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/backend"

echo "==> Exporting docs/openapi.json"
uv run aura export-openapi --output "$ROOT/docs/openapi.json"

if [[ "${1:-}" == "--generate" ]]; then
  if ! command -v openapi-generator-cli >/dev/null 2>&1; then
    echo "openapi-generator-cli not found; skipping reference client generation." >&2
    echo "Install it with: npm i -g @openapitools/openapi-generator-cli" >&2
    exit 0
  fi
  OUT="$ROOT/app/build/openapi-client"
  rm -rf "$OUT"
  echo "==> Generating reference Dart client into $OUT"
  openapi-generator-cli generate \
    --input-spec "$ROOT/docs/openapi.json" \
    --generator-name dart-dio \
    --output "$OUT" \
    --additional-properties=pubName=aura_api,pubVersion=0.1.0,serializationLibrary=json_serializable
  echo "Reference client generated. The shipped app uses lib/core/models/models.dart."
else
  echo "Contract updated. Run with --generate for a reference Dart client."
fi
