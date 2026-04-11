# Bootstrap Templates

Canonical bootstrap `Makefile` templates for the baseline repository types.

## Repo types

- `frontend/Makefile`
- `go-service/Makefile`
- `go-service/.golangci.yml`
- `contracts/Makefile`
- `infra/Makefile`

GitHub Actions starter templates live separately in:

- `../github-actions/`

## Usage

Copy the matching template into the target repository root as `Makefile`.

The copied file then becomes the repo-specific bootstrap entrypoint and may diverge as the
repository grows. Common improvements can be backported manually to these templates when
useful.

In the current shared workspace model, `make doctor` expects `platform-blueprint-specs` to
exist as a sibling checkout of the working repository so it can call the shared doctor
script. The same sibling checkout is also required for `make sync-agent-skills` and the
managed-skill pre-push drift check.

## Developer prerequisites

- Required: a `make` implementation compatible with GNU Make and a bash-compatible shell
- Recommended: `mise` or `asdf` for automatic tool installation from `.tool-versions`
- Fallback: if no version manager is installed, developers must install the pinned tool
  versions manually before running `make bootstrap`

Windows note:

- use a POSIX-friendly GNU Make such as `ezwinports.make` or MSYS2 `make`
- ensure Git for Windows `bash.exe` is on `PATH`
- do not use `GnuWin32` make with these templates
- use `scripts/windows-tooling-doctor.ps1` from `platform-blueprint-specs` to verify the workstation baseline

Reference:

- `common/standards/windows-developer-tooling.md`

## Baseline contract

Each template provides:

- `make bootstrap`
- `make doctor`
- `make sync-agent-skills`
- `make sync-agent-skills-check`
- `make check-tools`
- `make print-toolchain`
- `make precommit-install`
- `make precommit-run`
- `make lint`
- `make format`
- `make format-check`

The frontend and Go-service templates also include hybrid local-stack wrapper
targets:

- `make support-up`
- `make support-up BUILD=1`
- `make support-down`
- `make support-logs`
- `make support-ps`

The infra template includes the corresponding centralized stack targets:

- `make local-frontend-support-up`
- `make local-frontend-support-up BUILD=1`
- `make local-api-support-up`
- `make local-api-support-up BUILD=1`
- `make local-down`

The template validates pinned toolchain versions and performs the minimum repository setup
for the current phase.

The lint and hook baseline is intentionally split so that:

- `pre-commit` owns common markdown, YAML, JSON, line-ending, and merge-conflict checks
- `pre-push` verifies managed common skill copies are up to date with
  `platform-blueprint-specs`
- repo-specific checks live behind repo-local `Makefile` targets
- top-level `make lint` and `make format-check` do not invoke `pre-commit`, which avoids
  recursive hook execution when the pre-commit config calls back into repo-local targets
