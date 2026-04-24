#!/usr/bin/env bash
# Copy all skills from this repo into Cursor's user skills directory.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
mkdir -p "$DEST"
for d in "$REPO_ROOT"/skills/*/; do
  name="$(basename "$d")"
  if [[ -f "$d/SKILL.md" ]]; then
    mkdir -p "$DEST/$name"
    cp -f "$d/SKILL.md" "$DEST/$name/SKILL.md"
    echo "Installed $name -> $DEST/$name/SKILL.md"
  fi
done
echo "Done. Restart Cursor if it is running."
