.PHONY: help codex-mcp codex-tunnel codex-tunnel-init codex-tunnel-run codex-tunnel-doctor

ifneq (,$(wildcard .env))
include .env
export
endif

PROFILE ?= dot-nixos-codex
CODEX_BIN ?= codex

export PROFILE
export CODEX_BIN
export TUNNEL_ID
export CONTROL_PLANE_API_KEY

help:
	@echo "Targets:"
	@echo "  make codex-tunnel       Initialize/check the local tunnel when TUNNEL_ID is set, then run it"
	@echo "  make codex-tunnel-init  Initialize/check the local tunnel profile only"
	@echo "  make codex-tunnel-run   Run an already initialized local tunnel profile"
	@echo "  make codex-mcp          Run Codex MCP directly from this repository"
	@echo ""
	@echo "Config: copy .env.example to .env and set TUNNEL_ID plus the required OpenAI tunnel API key."

codex-mcp:
	@chmod +x tools/openai-tunnel/start-codex-mcp.sh
	@tools/openai-tunnel/start-codex-mcp.sh

codex-tunnel:
	@chmod +x tools/openai-tunnel/*.sh
	@if [ -n "$(TUNNEL_ID)" ]; then \
		tools/openai-tunnel/init-codex-tunnel.sh "$(TUNNEL_ID)"; \
	else \
		echo "TUNNEL_ID is not set; skipping init and running existing profile $(PROFILE)."; \
	fi
	@tunnel-client run --profile "$(PROFILE)"

codex-tunnel-init:
	@chmod +x tools/openai-tunnel/*.sh
	@tools/openai-tunnel/init-codex-tunnel.sh "$(TUNNEL_ID)"

codex-tunnel-run:
	@tunnel-client run --profile "$(PROFILE)"

codex-tunnel-doctor:
	@tunnel-client doctor --profile "$(PROFILE)" --explain
