SHELL := bash

NODE_VERSION := 24.13.1
NPM_VERSION := 11.8.0

.PHONY: help bootstrap doctor install-tools check-tools print-toolchain install-dev-tools precommit-install precommit-run lint format format-check repo-lint repo-format repo-format-check

help:
	@echo "Targets:"
	@echo "  bootstrap         Install toolchain when possible and run baseline setup"
	@echo "  doctor            Run shared workstation checks from sibling platform-blueprint-specs"
	@echo "  install-tools     Install pinned tools with mise/asdf if available"
	@echo "  check-tools       Validate pinned tool versions"
	@echo "  print-toolchain   Print pinned tool versions"
	@echo "  install-dev-tools Install Python and npm development tooling"
	@echo "  precommit-install Install git pre-commit hooks"
	@echo "  precommit-run     Run the configured pre-commit checks on all files"
	@echo "  lint              Run repo lint checks"
	@echo "  format            Apply repo formatting"
	@echo "  format-check      Check repo formatting without writing changes"

bootstrap: install-tools check-tools install-dev-tools
	npm ci

doctor:
	@if [[ -f ../platform-blueprint-specs/scripts/windows-tooling-doctor.ps1 ]]; then \
		powershell -ExecutionPolicy Bypass -File ../platform-blueprint-specs/scripts/windows-tooling-doctor.ps1; \
	else \
		echo "Shared doctor script not found at ../platform-blueprint-specs/scripts/windows-tooling-doctor.ps1" >&2; \
		echo "Keep platform-blueprint-specs as a sibling checkout to use make doctor in this workspace." >&2; \
		exit 1; \
	fi

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

print-toolchain:
	@echo "Node.js $(NODE_VERSION)"
	@echo "npm $(NPM_VERSION)"

install-dev-tools:
	python -m pip install --user -r requirements-dev.txt
	npm install

precommit-install: install-dev-tools
	python -m pre_commit install

precommit-run:
	python -m pre_commit run --all-files --show-diff-on-failure

lint: repo-lint

format: repo-format

format-check: repo-format-check

repo-lint:
	npm run lint

repo-format:
	npm run format

repo-format-check:
	npm run format:check
