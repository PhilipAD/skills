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
    if [[ -d "$d/references" ]]; then
      mkdir -p "$DEST/$name/references"
      shopt -s nullglob
      for ref in "$d/references"/*; do
        [[ -f "$ref" ]] && cp -f "$ref" "$DEST/$name/references/"
      done
      shopt -u nullglob
    fi
    echo "Installed $name -> $DEST/$name/"
  fi
done
# Repo-root design.md is the canonical Aetherweave spec; bundle it for the skill install.
if [[ -f "$REPO_ROOT/design.md" ]]; then
  mkdir -p "$DEST/aetherweave-design-system/references"
  cp -f "$REPO_ROOT/design.md" "$DEST/aetherweave-design-system/references/design-spec.md"
  echo "Synced design.md -> $DEST/aetherweave-design-system/references/design-spec.md"
fi
echo "Done. Restart Cursor if it is running."
