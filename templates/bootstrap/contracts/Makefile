SHELL := bash

NODE_VERSION := 24.13.1
NPM_VERSION := 11.8.0
BUF_VERSION := 1.65.0

.PHONY: help bootstrap install-tools check-tools print-toolchain

help:
	@echo "Targets:"
	@echo "  bootstrap       Install toolchain when possible and run baseline setup"
	@echo "  install-tools    Install pinned tools with mise/asdf if available"
	@echo "  check-tools      Validate pinned tool versions"
	@echo "  print-toolchain  Print pinned tool versions"

bootstrap: install-tools check-tools
	npm ci

install-tools:
	@if command -v mise >/dev/null 2>&1; then \
		echo "Installing pinned tools with mise..."; \
		mise install; \
	elif command -v asdf >/dev/null 2>&1; then \
		echo "Installing pinned tools with asdf..."; \
		asdf install; \
	else \
		echo "No supported version manager detected. Validating local tools only."; \
	fi

check-tools:
	@actual_node="$$(node --version 2>/dev/null || true)"; \
	if [[ -z "$$actual_node" ]]; then \
		echo "Node.js is required but not installed. Expected $(NODE_VERSION)." >&2; \
		exit 1; \
	fi; \
	if [[ "$$actual_node" != *"$(NODE_VERSION)"* ]]; then \
		echo "Node.js version mismatch. Expected $(NODE_VERSION), got: $$actual_node" >&2; \
		exit 1; \
	fi
	@actual_npm="$$(npm --version 2>/dev/null || true)"; \
	if [[ -z "$$actual_npm" ]]; then \
		echo "npm is required but not installed. Expected $(NPM_VERSION)." >&2; \
		exit 1; \
	fi; \
	if [[ "$$actual_npm" != *"$(NPM_VERSION)"* ]]; then \
		echo "npm version mismatch. Expected $(NPM_VERSION), got: $$actual_npm" >&2; \
		exit 1; \
	fi
	@actual_buf="$$(buf --version 2>/dev/null || true)"; \
	if [[ -z "$$actual_buf" ]]; then \
		echo "Buf is required but not installed. Expected $(BUF_VERSION)." >&2; \
		exit 1; \
	fi; \
	if [[ "$$actual_buf" != *"$(BUF_VERSION)"* ]]; then \
		echo "Buf version mismatch. Expected $(BUF_VERSION), got: $$actual_buf" >&2; \
		exit 1; \
	fi

print-toolchain:
	@echo "Node.js $(NODE_VERSION)"
	@echo "npm $(NPM_VERSION)"
	@echo "Buf $(BUF_VERSION)"
