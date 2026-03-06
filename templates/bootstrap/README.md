# Bootstrap Templates

Canonical bootstrap `Makefile` templates for the baseline repository types.

## Repo types

- `frontend/Makefile`
- `go-service/Makefile`
- `contracts/Makefile`
- `infra/Makefile`

## Usage

Copy the matching template into the target repository root as `Makefile`.

The copied file then becomes the repo-specific bootstrap entrypoint and may diverge as the
repository grows. Common improvements can be backported manually to these templates when
useful.

## Developer prerequisites

- Required: a `make` implementation compatible with GNU Make
- Recommended: `mise` or `asdf` for automatic tool installation from `.tool-versions`
- Fallback: if no version manager is installed, developers must install the pinned tool
  versions manually before running `make bootstrap`

## Baseline contract

Each template provides:

- `make bootstrap`
- `make check-tools`
- `make print-toolchain`

The template validates pinned toolchain versions and performs the minimum repository setup
for the current phase.
