# Bootstrap Templates

Canonical bootstrap `Makefile` templates for the baseline repository types.

## Repo types

- `frontend/Makefile`
- `go-service/Makefile`
- `go-service/.golangci.yml`
- `contracts/Makefile`
- `infra/Makefile`

## Usage

Copy the matching template into the target repository root as `Makefile`.

The copied file then becomes the repo-specific bootstrap entrypoint and may diverge as the
repository grows. Common improvements can be backported manually to these templates when
useful.

## Developer prerequisites

- Required: a `make` implementation compatible with GNU Make and a bash-compatible shell
- Recommended: `mise` or `asdf` for automatic tool installation from `.tool-versions`
- Fallback: if no version manager is installed, developers must install the pinned tool
  versions manually before running `make bootstrap`

## Baseline contract

Each template provides:

- `make bootstrap`
- `make check-tools`
- `make print-toolchain`
- `make precommit-install`
- `make precommit-run`
- `make lint`
- `make format`
- `make format-check`

The template validates pinned toolchain versions and performs the minimum repository setup
for the current phase.

The lint and hook baseline is intentionally split so that:

- `pre-commit` owns common markdown, YAML, JSON, line-ending, and merge-conflict checks
- repo-specific checks live behind repo-local `Makefile` targets
- top-level `make lint` and `make format-check` do not invoke `pre-commit`, which avoids
  recursive hook execution when the pre-commit config calls back into repo-local targets
