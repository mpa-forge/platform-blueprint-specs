# Repository Bootstrap Evidence (`P0-T00`, `P1-T01`)

Last updated: 2026-03-06

## Scope
This document records the minimal repository bootstrap required by `P0-T00` and the
Phase 1 repository finalization work completed in `P1-T01`.

## Bootstrap result

| Repo | URL | Repo ID | Visibility | Maintainer | Status |
| --- | --- | --- | --- | --- | --- |
| `platform-blueprint-specs` | `https://github.com/mpa-forge/platform-blueprint-specs` | `R_kgDORdrAUg` | `public` | `MiquelPiza` | `finalized` |
| `frontend-web` | `https://github.com/mpa-forge/frontend-web` | `R_kgDORdrAZg` | `public` | `MiquelPiza` | `finalized` |
| `backend-api` | `https://github.com/mpa-forge/backend-api` | `R_kgDORdrAgQ` | `public` | `MiquelPiza` | `finalized` |
| `backend-worker` | `https://github.com/mpa-forge/backend-worker` | `R_kgDORdrAlQ` | `public` | `MiquelPiza` | `finalized` |
| `platform-ai-workers` | `https://github.com/mpa-forge/platform-ai-workers` | `R_kgDORdrAsA` | `public` | `MiquelPiza` | `finalized` |
| `platform-contracts` | `https://github.com/mpa-forge/platform-contracts` | `R_kgDORdrA0A` | `public` | `MiquelPiza` | `finalized` |
| `platform-infra` | `https://github.com/mpa-forge/platform-infra` | `R_kgDORdrA6g` | `public` | `MiquelPiza` | `finalized` |

## Phase 1 repository settings evidence

The following settings were applied to all six working repositories as part of `P1-T01`.

| Repo | Visibility | Default branch | Issues | Projects | Wiki | Squash merge | Merge commit | Rebase merge | Delete branch on merge | Allow update branch |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `frontend-web` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |
| `backend-api` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |
| `backend-worker` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |
| `platform-ai-workers` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |
| `platform-contracts` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |
| `platform-infra` | `public` | `main` | enabled | enabled | disabled | enabled | disabled | disabled | enabled | enabled |

## Initial repository initialization

- Each finalized working repo received a minimal bootstrap commit:
  - `README.md`
  - commit message: `chore: initialize repository`
- This was required because GitHub cannot apply branch protection until the target branch
  exists as a real branch object.

## Branch protection baseline

- `main` branch protection is active on all six working repositories.
- Applied protection settings:
  - pull request review gate enabled with `required_approving_review_count = 0`
  - `enforce_admins = true`
  - `required_linear_history = true`
  - `required_conversation_resolution = true`
  - `allow_force_pushes = false`
  - `allow_deletions = false`
- `required_approving_review_count = 0` is the deliberate single-maintainer compromise.
  It keeps the pull-request protection model active without blocking the sole human
  maintainer from merging after review of AI-generated PRs.
- Required CI status-check contexts are not configured yet because Phase 4 workflows do not
  exist yet. They must be added in `P4-T09` once CI check names are stable.

## Notes

- `P0-T00` covered identity/bootstrap only for Phase 0 governance artifacts.
- `P1-T01` finalized the six working repositories, converted them to public visibility, and
  applied active branch protection plus baseline merge-policy settings.
- `platform-blueprint-specs` remains outside this Phase 1 working-repo set and is not
  changed by this record.
- Required CI status checks remain a later enforcement step once CI exists.

## Command log

```powershell
# Create repositories (idempotent check + create)
& "C:\Program Files\GitHub CLI\gh.exe" repo view mpa-forge/<repo> --json nameWithOwner
& "C:\Program Files\GitHub CLI\gh.exe" repo create mpa-forge/<repo> --private --description "<...>" --disable-wiki

# Retrieve bootstrap evidence
& "C:\Program Files\GitHub CLI\gh.exe" repo view mpa-forge/<repo> --json nameWithOwner,id,url,isPrivate,createdAt

# Convert working repos to public visibility so branch protection is available on the free plan
& "C:\Program Files\GitHub CLI\gh.exe" api repos/mpa-forge/<repo> -X PATCH -f visibility=public

# Apply baseline repository settings
& "C:\Program Files\GitHub CLI\gh.exe" repo edit mpa-forge/<repo> --enable-issues --enable-projects --enable-wiki=false --enable-squash-merge --enable-merge-commit=false --enable-rebase-merge=false --delete-branch-on-merge --allow-update-branch

# Create initial branch object for empty repos
& "C:\Program Files\GitHub CLI\gh.exe" api repos/mpa-forge/<repo>/contents/README.md -X PUT -f message="chore: initialize repository" -f content="<base64-readme>"

# Retrieve repository settings evidence
& "C:\Program Files\GitHub CLI\gh.exe" api repos/mpa-forge/<repo> --jq '{visibility,default_branch,has_issues,has_projects,has_wiki,allow_squash_merge,allow_merge_commit,allow_rebase_merge,delete_branch_on_merge,allow_update_branch}'

# Apply branch protection
& "C:\Program Files\GitHub CLI\gh.exe" api repos/mpa-forge/<repo>/branches/main/protection -X PUT --input branch-protection.json

# Retrieve branch protection evidence
& "C:\Program Files\GitHub CLI\gh.exe" api repos/mpa-forge/<repo>/branches/main/protection
```
