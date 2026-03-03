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

## P0-T03B: GCP project baseline

### Identity and ownership evidence

| Field | Value |
| --- | --- |
| Organization | `miquel-piza-airas-org` |
| Organization ID | `140507280052` |
| Billing account | `0191F2-169FC2-7A8CFF` |
| Billing account display name | `Mi cuenta de facturacion` |
| Authenticated maintainer account | `miquel.piza.airas@gmail.com` |

### Project baseline

| Environment | Project ID | Project Number | Parent | Lifecycle | Billing linked |
| --- | --- | --- | --- | --- | --- |
| `rc` | `mpa-forge-bp-rc` | `942423016043` | `organization/140507280052` | `ACTIVE` | `true` |
| `prod` | `mpa-forge-bp-prod` | `219047743362` | `organization/140507280052` | `ACTIVE` | `true` |

### Baseline checks

| Check | Result | Evidence |
| --- | --- | --- |
| Separate projects exist for `rc` and `prod` | PASS | `gcloud projects describe mpa-forge-bp-rc|mpa-forge-bp-prod` |
| Billing is linked for both projects | PASS | `gcloud billing projects describe ...` shows `billingEnabled=true` |
| Primary region baseline set to `us-east4` | PASS | `gcloud config set run/region us-east4` and `gcloud config set compute/region us-east4` |
| Required baseline APIs enabled in both projects | PASS | `run`, `sqladmin`, `artifactregistry`, `secretmanager`, `iam`, `logging`, `monitoring` found in enabled service list |

### Enabled API baseline (required set)

- `run.googleapis.com`
- `sqladmin.googleapis.com`
- `artifactregistry.googleapis.com`
- `secretmanager.googleapis.com`
- `iam.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`

### Notes

- Additional dependent services were auto-enabled by Google Cloud when enabling required APIs; this is expected.
- Earlier exploratory project IDs (`blueprint-rc`, `blueprint-prod`) are not part of the selected baseline naming and should not be used for further planning artifacts.
- Cost guardrails configured: per-project monthly budget alerts at `1 EUR`.

### Budget guardrails

| Budget | Scope | Amount | Thresholds |
| --- | --- | --- | --- |
| `Budget mpa-forge-bp-rc monthly 1` | `projects/942423016043` (`mpa-forge-bp-rc`) | `1 EUR / month` | `50% current`, `90% current`, `100% forecasted` |
| `Budget mpa-forge-bp-prod monthly 1` | `projects/219047743362` (`mpa-forge-bp-prod`) | `1 EUR / month` | `50% current`, `90% current`, `100% forecasted` |

### Command log (executed)

```powershell
# Context
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" auth list --filter=status:ACTIVE --format="value(account)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" organizations list --format="value(name,displayName)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing accounts list --format="value(name,displayName,open)"

# Create projects
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects create mpa-forge-bp-rc --name=mpa-forge-bp-rc --organization=140507280052 --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects create mpa-forge-bp-prod --name=mpa-forge-bp-prod --organization=140507280052 --quiet

# Link billing
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing projects link mpa-forge-bp-rc --billing-account=0191F2-169FC2-7A8CFF --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing projects link mpa-forge-bp-prod --billing-account=0191F2-169FC2-7A8CFF --quiet

# Enable required APIs
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services enable run.googleapis.com sqladmin.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com iam.googleapis.com logging.googleapis.com monitoring.googleapis.com --project=mpa-forge-bp-rc --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services enable run.googleapis.com sqladmin.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com iam.googleapis.com logging.googleapis.com monitoring.googleapis.com --project=mpa-forge-bp-prod --quiet

# Set region defaults
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" config set project mpa-forge-bp-rc --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" config set run/region us-east4 --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" config set compute/region us-east4 --quiet

# Verify
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects describe mpa-forge-bp-rc --format="json(projectId,name,projectNumber,parent,createTime,lifecycleState)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" projects describe mpa-forge-bp-prod --format="json(projectId,name,projectNumber,parent,createTime,lifecycleState)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing projects describe mpa-forge-bp-rc --format="json(projectId,billingEnabled,billingAccountName)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing projects describe mpa-forge-bp-prod --format="json(projectId,billingEnabled,billingAccountName)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services list --enabled --project=mpa-forge-bp-rc --format="value(config.name)"
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services list --enabled --project=mpa-forge-bp-prod --format="value(config.name)"

# Budget guardrails
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services enable billingbudgets.googleapis.com --project=mpa-forge-bp-rc --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" services enable cloudresourcemanager.googleapis.com --project=mpa-forge-bp-rc --quiet
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing budgets create --billing-account=0191F2-169FC2-7A8CFF --project=mpa-forge-bp-rc --display-name="Budget mpa-forge-bp-rc monthly 1" --budget-amount=1 --calendar-period=month --filter-projects=projects/mpa-forge-bp-rc --threshold-rule=percent=0.50 --threshold-rule=percent=0.90 --threshold-rule=percent=1.00,basis=forecasted-spend
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing budgets create --billing-account=0191F2-169FC2-7A8CFF --project=mpa-forge-bp-rc --display-name="Budget mpa-forge-bp-prod monthly 1" --budget-amount=1 --calendar-period=month --filter-projects=projects/mpa-forge-bp-prod --threshold-rule=percent=0.50 --threshold-rule=percent=0.90 --threshold-rule=percent=1.00,basis=forecasted-spend
& "C:\Users\Miquel\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" billing budgets list --billing-account=0191F2-169FC2-7A8CFF --project=mpa-forge-bp-rc --format="table(name,displayName,amount.specifiedAmount.units,amount.specifiedAmount.currencyCode,budgetFilter.projects,thresholdRules.spendBasis,thresholdRules.thresholdPercent)"
```
