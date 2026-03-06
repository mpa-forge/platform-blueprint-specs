# Toolchain Bootstrap Evidence (`P1-T03`)

Last updated: 2026-03-06

## Scope

This document records the toolchain version pins and bootstrap baseline delivered for `P1-T03`.

## Version baseline

| Repo | Version pin files | Pinned toolchain |
| --- | --- | --- |
| `frontend-web` | `.tool-versions`, `package.json`, `package-lock.json` | Node.js `24.13.1`, npm `11.8.0` |
| `backend-api` | `.tool-versions`, `go.mod` | Go `1.24.12` |
| `backend-worker` | `.tool-versions`, `go.mod` | Go `1.24.12` |
| `platform-ai-workers` | `.tool-versions`, `go.mod` | Go `1.24.12` |
| `platform-contracts` | `.tool-versions`, `package.json`, `package-lock.json` | Node.js `24.13.1`, npm `11.8.0`, Buf `1.65.0` |
| `platform-infra` | `.tool-versions`, `versions.tf` | Terraform `1.14.5` |

## Bootstrap baseline

Each repository now includes:

- a repo-type-specific `Makefile` copied from the canonical templates in
  `templates/bootstrap/`
- README setup instructions pointing to `make bootstrap`

Bootstrap behavior:

- require a `make` implementation compatible with GNU Make
- use `mise install` when `mise` is available
- use `asdf install` when `asdf` is available
- otherwise validate locally installed tools against the pinned versions
- run `npm ci` in npm-based repos
- run `go mod download` in Go repos

Template mapping:

- `frontend-web` -> `templates/bootstrap/frontend/Makefile`
- `backend-api` -> `templates/bootstrap/go-service/Makefile`
- `backend-worker` -> `templates/bootstrap/go-service/Makefile`
- `platform-ai-workers` -> `templates/bootstrap/go-service/Makefile`
- `platform-contracts` -> `templates/bootstrap/contracts/Makefile`
- `platform-infra` -> `templates/bootstrap/infra/Makefile`

## Merge evidence

`P1-T03` landed in two steps:

- initial version pins and repo-local bootstrap scripts
- follow-up migration to template-driven `Makefile` bootstrap entrypoints

| Repo | Initial bootstrap PR | Makefile migration PR |
| --- | --- | --- |
| `frontend-web` | `https://github.com/mpa-forge/frontend-web/pull/2` | `https://github.com/mpa-forge/frontend-web/pull/3` |
| `backend-api` | `https://github.com/mpa-forge/backend-api/pull/2` | `https://github.com/mpa-forge/backend-api/pull/3` |
| `backend-worker` | `https://github.com/mpa-forge/backend-worker/pull/2` | `https://github.com/mpa-forge/backend-worker/pull/4` |
| `platform-ai-workers` | `https://github.com/mpa-forge/platform-ai-workers/pull/2` | `https://github.com/mpa-forge/platform-ai-workers/pull/4` |
| `platform-contracts` | `https://github.com/mpa-forge/platform-contracts/pull/2` | `https://github.com/mpa-forge/platform-contracts/pull/4` |
| `platform-infra` | `https://github.com/mpa-forge/platform-infra/pull/2` | `https://github.com/mpa-forge/platform-infra/pull/4` |

## Validation performed

- `make` is not installed on the current machine, so the new `Makefile`-based bootstrap
  path could not be executed locally in this session.
- `backend-api`, `backend-worker`, `platform-ai-workers`: not executed locally because Go is not installed on the current machine.
- `platform-contracts`: not fully executed locally because Buf is not installed on the current machine.
- `platform-infra`: not executed locally because Terraform is not installed on the current machine.

## Follow-up

- `P1-T10` should include a fresh-machine validation that covers all pinned toolchains end to end.
- `P1-T04` and later tasks will add actual lint/test commands on top of this baseline.
