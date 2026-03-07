# Lint and Pre-Commit Evidence (`P1-T04`)

Last updated: 2026-03-06

## Scope

This document records the lint, format, and pre-commit baseline delivered for `P1-T04`.

## Baseline delivered

Every working repository now includes:

- `.pre-commit-config.yaml`
- `.markdownlint-cli2.jsonc`
- `.yamllint.yml`
- `requirements-dev.txt`
- a repo-specific `.gitignore` baseline
- expanded `Makefile` targets for lint, format, and hook installation
- README instructions for the new developer commands

Additional Node/TypeScript tooling was added in:

- `frontend-web`
- `platform-contracts`

Those two repositories now also include:

- `eslint.config.mjs`
- `prettier.config.mjs`
- `tsconfig.json`
- updated `package.json` scripts
- refreshed `package-lock.json`

## Canonical template contract

The canonical templates in `templates/bootstrap/` now provide these shared targets:

- `make precommit-install`
- `make precommit-run`
- `make lint`
- `make format`
- `make format-check`

For Go repositories, the lint baseline is defined separately in:

- [docs/standards/go-lint-baseline.md](c:/Users/Miquel/dev/platform-blueprint-specs/docs/standards/go-lint-baseline.md)

The pre-commit baseline is intentionally split this way:

- repo-local checks live behind `make repo-lint` and `make repo-format-check`
- common markdown, YAML, JSON, line-ending, and merge-conflict checks run through `pre-commit`
- `make lint` and `make format-check` do not invoke `pre-commit` directly, which avoids recursive hook execution

## Repo mapping

| Repo | Repo type | Merge PR |
| --- | --- | --- |
| `frontend-web` | `frontend` | `https://github.com/mpa-forge/frontend-web/pull/7` |
| `backend-api` | `go-service` | `https://github.com/mpa-forge/backend-api/pull/7` |
| `backend-worker` | `go-service` | `https://github.com/mpa-forge/backend-worker/pull/8` |
| `platform-ai-workers` | `go-service` | `https://github.com/mpa-forge/platform-ai-workers/pull/8` |
| `platform-contracts` | `contracts` | `https://github.com/mpa-forge/platform-contracts/pull/8` |
| `platform-infra` | `infra` | `https://github.com/mpa-forge/platform-infra/pull/8` |

## Merge evidence

| Repo | PR | Merged at | Merge commit |
| --- | --- | --- | --- |
| `frontend-web` | `https://github.com/mpa-forge/frontend-web/pull/7` | `2026-03-06T22:13:03Z` | `522b6f1a1badc1a145295f168bef16c7af7e1685` |
| `backend-api` | `https://github.com/mpa-forge/backend-api/pull/7` | `2026-03-06T22:13:06Z` | `73fb692672b2be80804dce96d4664d5d934aac65` |
| `backend-worker` | `https://github.com/mpa-forge/backend-worker/pull/8` | `2026-03-06T22:13:09Z` | `27bc6240ca71a9dc21fa150254a0e2419b52cd2e` |
| `platform-ai-workers` | `https://github.com/mpa-forge/platform-ai-workers/pull/8` | `2026-03-06T22:13:12Z` | `0ff8d5f27e8b4008527633fecede993452f7ea79` |
| `platform-contracts` | `https://github.com/mpa-forge/platform-contracts/pull/8` | `2026-03-06T22:13:15Z` | `4faa13132866794c6187e39f6e7f0b66b2610fe5` |
| `platform-infra` | `https://github.com/mpa-forge/platform-infra/pull/8` | `2026-03-06T22:13:18Z` | `bb30890db59236c7d2f078dc19aaad4bf5613142` |

## Validation performed

Validated successfully on this workstation:

- `frontend-web`
  - `npm run lint`
  - `npm run format:check`
- `platform-contracts`
  - `npm run lint`
  - `npm run format:check`

Validated with an injected tracked-file failure and recovery:

- `frontend-web`
  - `python -m pre_commit run --all-files` failed when `.markdownlint-cli2.jsonc` was deliberately corrupted
  - `python -m pre_commit run --all-files` passed again after restoring the valid config
- `platform-contracts`
  - `python -m pre_commit run --all-files` failed when `.markdownlint-cli2.jsonc` was deliberately corrupted
  - `python -m pre_commit run --all-files` passed again after restoring the valid config

## Validation limits on the current workstation

- GNU Make is not installed on the current Windows host.
- Git Bash exists locally but is not on `PATH`.
- For the two Node repositories, the pre-commit execution path was validated by temporarily providing an untracked local `make.cmd` shim during the validation run. This was only for validation and was not committed.
- The Go repositories were not executed end to end in this session because Go is not installed on the current machine.
- The infra repository was not executed end to end in this session because Terraform is not installed on the current machine.

## Follow-up

- `P1-T10` should validate the full hook path on a clean developer machine with a real GNU Make installation and a bash-compatible shell on `PATH`.
- `P4-T09` will later attach required CI check contexts to the protected branches once workflows exist.
