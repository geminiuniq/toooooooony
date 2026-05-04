#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

latest_html="$(ls -t *.html 2>/dev/null | head -n 1 || true)"
if [[ -z "$latest_html" ]]; then
  echo "No html file found in $ROOT_DIR" >&2
  exit 1
fi

echo "Latest html: $latest_html"

# Keep index.html aligned to latest html.
if [[ "$latest_html" != "index.html" ]]; then
  cp "$latest_html" index.html
  echo "Copied $latest_html -> index.html"
fi

# Verify auth gate credentials exist.
if ! rg -q "tony" index.html || ! rg -q "tototony" index.html; then
  echo "Auth gate credentials not found in index.html. Please add auth block first." >&2
  exit 1
fi

echo "Auth gate verified in index.html"
echo "Done"
