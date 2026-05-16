#!/bin/bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)/skills"

mkdir -p "$SKILLS_DIR"

for skill in "$REPO_DIR"/*/; do
  name=$(basename "$skill")
  cp -r "$skill" "$SKILLS_DIR/$name"
  echo "✓ $name"
done

echo ""
echo "Done. $(ls "$REPO_DIR" | wc -l | tr -d ' ') skills installed to $SKILLS_DIR"
echo "Restart Claude Code, then run /kickoff to get started."
