#!/usr/bin/env bash
# Install the skills for every project on this machine, and optionally
# wire graphify (CLAUDE.md rules + hooks) into one project.
#   bash install.sh                 -> skills into ~/.claude/skills
#   bash install.sh /path/to/proj   -> also graphify rules + hooks into that project
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.claude/skills
cp -r "$HERE"/.claude/skills/* ~/.claude/skills/
echo "skills -> ~/.claude/skills: $(ls "$HERE/.claude/skills" | tr '\n' ' ')"
if [ "${1:-}" ]; then
  P="$(cd "$1" && pwd)"
  mkdir -p "$P/.claude"
  [ -f "$P/.claude/settings.json" ] || cp "$HERE/templates/project/settings.json" "$P/.claude/settings.json"
  grep -q "## graphify" "$P/CLAUDE.md" 2>/dev/null || cat "$HERE/templates/project/CLAUDE.md" >> "$P/CLAUDE.md"
  grep -qx "graphify-out/" "$P/.gitignore" 2>/dev/null || echo "graphify-out/" >> "$P/.gitignore"
  command -v graphify >/dev/null || pip install -q graphifyy || echo "install graphify: pip install graphifyy"
  (cd "$P" && graphify update . >/dev/null 2>&1) && echo "graph built in $P/graphify-out" || true
  echo "project $P: graphify rules + hooks added"
fi
