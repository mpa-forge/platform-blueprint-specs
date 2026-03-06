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

## Baseline contract

Each template provides:

- `make bootstrap`
- `make check-tools`
- `make print-toolchain`

The template validates pinned toolchain versions and performs the minimum repository setup
for the current phase.

All templates assume a `make` implementation compatible with GNU Make is available in the
developer environment or CI runner.
