# Repository Bootstrap Evidence (P0-T00)

Last updated: 2026-03-03

## Scope
This document records the minimal repository bootstrap required by `P0-T00`.

## Bootstrap result

| Repo | URL | Repo ID | Visibility | Maintainer | Status |
| --- | --- | --- | --- | --- | --- |
| `platform-blueprint-specs` | `https://github.com/mpa-forge/platform-blueprint-specs` | `R_kgDORdrAUg` | `private` | `MiquelPiza` | `finalized` |
| `frontend-web` | `https://github.com/mpa-forge/frontend-web` | `R_kgDORdrAZg` | `private` | `MiquelPiza` | `placeholder` |
| `backend-api` | `https://github.com/mpa-forge/backend-api` | `R_kgDORdrAgQ` | `private` | `MiquelPiza` | `placeholder` |
| `backend-worker` | `https://github.com/mpa-forge/backend-worker` | `R_kgDORdrAlQ` | `private` | `MiquelPiza` | `placeholder` |
| `platform-ai-workers` | `https://github.com/mpa-forge/platform-ai-workers` | `R_kgDORdrAsA` | `private` | `MiquelPiza` | `placeholder` |
| `platform-contracts` | `https://github.com/mpa-forge/platform-contracts` | `R_kgDORdrA0A` | `private` | `MiquelPiza` | `placeholder` |
| `platform-infra` | `https://github.com/mpa-forge/platform-infra` | `R_kgDORdrA6g` | `private` | `MiquelPiza` | `placeholder` |

## Notes

- This is identity/bootstrap only for Phase 0 governance artifacts.
- Full repository scaffolding, branch protection, and required checks are explicitly deferred to `P1-T01`.

## Command log

```powershell
# Create repositories (idempotent check + create)
& "C:\Program Files\GitHub CLI\gh.exe" repo view mpa-forge/<repo> --json nameWithOwner
& "C:\Program Files\GitHub CLI\gh.exe" repo create mpa-forge/<repo> --private --description "<...>" --disable-wiki

# Retrieve evidence
& "C:\Program Files\GitHub CLI\gh.exe" repo view mpa-forge/<repo> --json nameWithOwner,id,url,isPrivate,createdAt
```

