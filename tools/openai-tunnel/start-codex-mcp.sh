#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
CODEX_BIN="${CODEX_BIN:-codex}"

cd "$REPO_ROOT"
"$CODEX_BIN" "mcp-server"
