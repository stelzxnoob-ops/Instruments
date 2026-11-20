#!/usr/bin/env bash
# SessionStart: make sure graphify is installed, keep the graph fresh,
# and hand Claude the graphify rules when the project has a graph.
# Never fails the session: every step is best-effort.
HERE="$(cd "$(dirname "$0")" && pwd)"
INPUT="$(cat || true)"
DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
SOURCE="$(printf '%s' "$INPUT" | sed -n 's/.*"source" *: *"\([a-z]*\)".*/\1/p')"

if ! command -v graphify >/dev/null 2>&1; then
  (pip install -q graphifyy || pip install -q --user graphifyy || pipx install graphifyy) >/dev/null 2>&1 || true
  hash -r
fi

if command -v graphify >/dev/null 2>&1; then
  if [ "$SOURCE" = "compact" ]; then
    printf '%s' "$INPUT" | graphify hook-guard compact 2>/dev/null || true
  fi
  # keep graphify-out out of git, then build/refresh the graph (AST only, no API cost)
  if git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    grep -qx "graphify-out/" "$DIR/.gitignore" 2>/dev/null || echo "graphify-out/" >> "$DIR/.gitignore"
  fi
  # in the background so a big project never slows session start
  (cd "$DIR" && nohup timeout 600 graphify update . >/dev/null 2>&1 </dev/null &) || true
fi

if [ -f "$DIR/graphify-out/graph.json" ]; then
  cat "$HERE/graphify-rules.md"
fi
exit 0
