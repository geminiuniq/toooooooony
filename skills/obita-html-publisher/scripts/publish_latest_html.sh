#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

bash skills/obita-html-publisher/scripts/sync_latest_html.sh

if git diff --quiet -- index.html; then
  echo "No changes in index.html, skip publish"
  exit 0
fi

git add index.html
git commit -m "Publish latest html with auth gate"
git push

echo "Published index.html to GitHub"
