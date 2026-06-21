#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
PROFILE="${PROFILE:-dot-nixos-codex}"
TUNNEL_ID="${TUNNEL_ID:-${1:-}}"
MCP_COMMAND="$REPO_ROOT/tools/openai-tunnel/start-codex-mcp.sh"

if [[ -z "$TUNNEL_ID" ]]; then
  echo "Usage: TUNNEL_ID=tunnel_xxx CONTROL_PLANE_API_KEY=sk-... $0" >&2
  echo "   or: CONTROL_PLANE_API_KEY=sk-... $0 tunnel_xxx" >&2
  exit 2
fi

if [[ -z "${CONTROL_PLANE_API_KEY:-}" ]]; then
  echo "CONTROL_PLANE_API_KEY is required and must not be committed to git." >&2
  exit 2
fi

if ! command -v tunnel-client >/dev/null 2>&1; then
  echo "tunnel-client is not in PATH." >&2
  exit 127
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "codex is not in PATH." >&2
  exit 127
fi

chmod +x "$MCP_COMMAND"

tunnel-client init \
  --sample sample_mcp_stdio_local \
  --profile "$PROFILE" \
  --tunnel-id "$TUNNEL_ID" \
  --mcp-command "$MCP_COMMAND"

tunnel-client doctor --profile "$PROFILE" --explain
