# Provider Account Inventory

Last updated: 2026-03-03

## Scope
This file stores provider account baselines and evidence for Phase 0 tasks (`P0-T03*`).

## P0-T03A: GitHub organization baseline

### Identity and ownership evidence

| Field | Value |
| --- | --- |
| Organization | `mpa-forge` |
| Organization URL | `https://github.com/mpa-forge` |
| Organization ID | `265360873` |
| Created at | `2026-03-03T19:31:45Z` |
| Plan | `free` |
| Authenticated maintainer account | `MiquelPiza` |
| Maintainer role in org | `admin` |

### Baseline checks

| Check | Result | Evidence |
| --- | --- | --- |
| GitHub org exists and is reachable | PASS | `gh api orgs/mpa-forge` |
| Org is writable by maintainer | PASS | `gh api user/memberships/orgs` shows `mpa-forge active admin` |
| Repositories can be created in org | PASS | `members_can_create_repositories=true` |
| 2FA requirement enforced for org members | PASS | `two_factor_requirement_enabled=true` |
| Org-level Projects capability accessible | PASS | GraphQL projects query returned `0` (feature reachable) |
| GitHub Actions org policy verified | PASS | `gh api orgs/mpa-forge/actions/permissions` returned `enabled_repositories=all`, `allowed_actions=all` |
| GitHub Packages availability verified | PASS | `gh api orgs/mpa-forge/packages?...` succeeded for `container` and `npm` (empty arrays are valid baseline state) |

### Current CLI auth context

| Field | Value |
| --- | --- |
| GitHub host | `github.com` |
| Git operations protocol | `https` |
| Token scopes | `admin:org`, `gist`, `read:packages`, `repo`, `workflow` |

### Remaining actions to close P0-T03A

None. `P0-T03A` baseline checks are complete.

### Command log (executed)

```powershell
# Auth and identity
& "C:\Program Files\GitHub CLI\gh.exe" auth status -h github.com
& "C:\Program Files\GitHub CLI\gh.exe" api user --jq '.login'
& "C:\Program Files\GitHub CLI\gh.exe" api user/memberships/orgs --paginate --jq '.[] | [.organization.login,.state,.role] | @tsv'

# Org baseline
& "C:\Program Files\GitHub CLI\gh.exe" api orgs/mpa-forge --jq '{login,id,html_url,plan: .plan.name,default_repository_permission,members_can_create_repositories,two_factor_requirement_enabled,created_at}'

# Projects availability (GraphQL)
& "C:\Program Files\GitHub CLI\gh.exe" api graphql -f query='query($org:String!) { organization(login:$org) { projectsV2(first:1) { totalCount } } }' -F org=mpa-forge --jq '.data.organization.projectsV2.totalCount'

# Actions policy check
& "C:\Program Files\GitHub CLI\gh.exe" api orgs/mpa-forge/actions/permissions

# 2FA API patch attempt (no effective change observed)
& "C:\Program Files\GitHub CLI\gh.exe" api -X PATCH orgs/mpa-forge -f two_factor_requirement_enabled=true

# Package checks (blocked by missing scope)
& "C:\Program Files\GitHub CLI\gh.exe" api "orgs/mpa-forge/packages?package_type=container&per_page=1"
& "C:\Program Files\GitHub CLI\gh.exe" api "orgs/mpa-forge/packages?package_type=npm&per_page=1"

# Package checks (after read:packages scope)
& "C:\Program Files\GitHub CLI\gh.exe" auth status -h github.com
& "C:\Program Files\GitHub CLI\gh.exe" api orgs/mpa-forge --jq '{login,two_factor_requirement_enabled,members_can_create_repositories,default_repository_permission,plan: .plan.name}'
& "C:\Program Files\GitHub CLI\gh.exe" api "orgs/mpa-forge/packages?package_type=container&per_page=1"
& "C:\Program Files\GitHub CLI\gh.exe" api "orgs/mpa-forge/packages?package_type=npm&per_page=1"
```
