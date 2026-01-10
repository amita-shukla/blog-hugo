#!/usr/bin/env bash

set -e

ROOT="content/blog"

find "$ROOT" -name "index.md" | while read -r file; do
  # Skip if already present
  if grep -q "^showTableOfContents:" "$file"; then
    continue
  fi

  # Insert before the closing ---
  awk '
    BEGIN { inserted=0 }
    /^---$/ && NR>1 && !inserted {
      print "showTableOfContents: true"
      inserted=1
    }
    { print }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

  echo "Updated: $file"
done
