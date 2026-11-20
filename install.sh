#!/usr/bin/env bash
# Подключить инструменты (плагин Claude Code "instruments").
#   bash install.sh                -> для всех проектов на этой машине (user scope)
#   bash install.sh /path/to/proj  -> в проект: пишет .claude/settings.json, плагин
#                                     включится у всех, кто откроет проект (и в облаке)
set -euo pipefail
REPO="stelzxnoob-ops/Instruments"

if [ -z "${1:-}" ]; then
  claude plugin marketplace add "$REPO"
  for n in instruments ponytail agent-skills; do claude plugin install "$n@instruments"; done
  exit 0
fi

P="$(cd "$1" && pwd)"
mkdir -p "$P/.claude"
python3 - "$P/.claude/settings.json" "$REPO" <<'PY'
import json, os, sys
path, repo = sys.argv[1], sys.argv[2]
s = json.load(open(path)) if os.path.exists(path) and os.path.getsize(path) else {}
s.setdefault("extraKnownMarketplaces", {})["instruments"] = {"source": {"source": "github", "repo": repo}}
for n in ("instruments", "ponytail", "agent-skills"):
    s.setdefault("enabledPlugins", {})[n + "@instruments"] = True
json.dump(s, open(path, "w"), indent=2, ensure_ascii=False); open(path, "a").write("\n")
PY
grep -qx "graphify-out/" "$P/.gitignore" 2>/dev/null || echo "graphify-out/" >> "$P/.gitignore"
echo "готово: $P/.claude/settings.json — закоммить его в проект"
