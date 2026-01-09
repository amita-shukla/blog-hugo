#!/usr/bin/env bash

set -e

CONTENT_DIR="content"

echo "Replacing <re-img> tags with Markdown images..."

find "$CONTENT_DIR" -type f -name "*.md" -print0 \
| xargs -0 sed -i '' -E \
's|<re-img[[:space:]]+src="([^"]+)"[[:space:]]*></re-img>|![image](\1)|g'

echo "Done."
