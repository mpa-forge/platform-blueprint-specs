# Provider Account Inventory

Last updated: 2026-03-04

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

## P0-T03C: Clerk auth baseline

Status: Partially documented (`2026-03-22`); development-instance domain and
Phase 2 auth mappings are now recorded, while final secret-reference and
production-domain details remain pending.

### Identity and ownership evidence

| Field | Value |
| --- | --- |
| Provider | `Clerk` |
| Plan | `Free` |
| Clerk app | `MPA Forge Blueprint` |
| Authenticated maintainer | `MiquelPiza` (human owner model) |
| Account accessibility | `Confirmed` |

### Environment mapping decision (locked)

| Environment | Clerk mapping |
| --- | --- |
| `local` | Clerk app `Development` instance (same lane as `rc`) |
| `rc` | Clerk app `Development` instance |
| `prod` | Clerk app `Production` instance |

Decision: `Option A` (single Clerk app with dev/prod instances).

### Baseline checks

| Check | Result | Evidence |
| --- | --- | --- |
| Clerk account/dashboard accessible | PASS | User-confirmed |
| Free plan confirmed | PASS | User-confirmed |
| Env mapping (`rc`/`prod`) selected | PASS | Option A locked in planning |
| Redirect/logout/origin placeholders recorded | PARTIAL | Local frontend redirect env mappings recorded in `implementation/governance/clerk-app-configuration-evidence.md` |
| Key reference names recorded (no raw secrets in git) | PENDING | Needs key naming entries |
| Issuer/JWKS metadata references recorded | PASS | `implementation/governance/clerk-app-configuration-evidence.md` |

### Remaining actions to close P0-T03C

1. Record Clerk app name and instance identifiers used for `Development` and `Production`.
2. Record remaining non-local URL placeholders:
   - `rc` redirect/logout/origin
   - `prod` redirect/logout/origin
3. Record key reference names only (not values), for example:
   - `CLERK_PUBLISHABLE_KEY_LOCAL`
   - `CLERK_PUBLISHABLE_KEY_RC`
   - `CLERK_PUBLISHABLE_KEY_PROD`
   - `CLERK_SECRET_KEY_RC`
   - `CLERK_SECRET_KEY_PROD`
4. Keep `implementation/governance/clerk-app-configuration-evidence.md` aligned with any
   future claim or audience changes.

Done when: all pending items above are filled in this section.

Deferral rationale: finalize secret-reference and production-domain mappings
after frontend runtime integration and later environment rollout tasks.

## P0-T03D: Grafana Cloud baseline

Status: Completed (`2026-03-04`) for `rc` baseline scope. `prod` token/secrets are deferred until prod activation.

### Identity and stack evidence

| Field | Value |
| --- | --- |
| Provider | `Grafana Cloud` |
| Org name | `MPA Forge` |
| Stack name | `miquelpizaairas` |
| Stack URL | `https://miquelpizaairas.grafana.net` |
| Plan | `Free` |
| Desired instance name | `mpaforge.grafana.net` |

### Baseline checks

| Check | Result | Evidence |
| --- | --- | --- |
| Grafana Cloud account accessible | PASS | User-confirmed |
| Org name identified | PASS | User-provided |
| Stack identified | PASS | User-provided |
| Stack URL identified | PASS | User-provided |
| Plan tier locked to Free | PASS | Prior Phase 0 decision |
| Access policies/tokens baseline created | PASS | Policies `o11y-ingest-rc-write` and `o11y-read` confirmed; mapped to RC GSM secrets |
| OTLP endpoint and auth details recorded | PASS | OTLP endpoint + instance ID + header contract documented |
| Mandatory label partitioning locked | PASS | `env`, `project`, `service` required on all telemetry |

### Notes

- Instance rename attempt returned `An internal error occurred`; keep current stack URL as baseline until rename is successful.
- If retrying rename, use the stack rename flow in Cloud Portal and verify uniqueness/permissions.

### GSM secret references (recorded)

Project: `mpa-forge-bp-rc`

| Secret name | Intended scope | Labels |
| --- | --- | --- |
| `grafana-otlp-ingest-token-rc` | RC ingest token | `app=platform-blueprint`, `env=rc`, `managed_by=manual`, `provider=grafana-cloud`, `scope=ingest`, `secret_type=api-token`, `service=observability`, `tier=free` |
| `grafana-otlp-read-token` | RC/read token for observability queries | `app=platform-blueprint`, `env=rc`, `managed_by=manual`, `provider=grafana-cloud`, `scope=read`, `secret_type=api-token`, `service=observability` |

### Grafana access policy inventory (recorded)

| Policy name | Intended scopes | Environment | Backing GSM secret |
| --- | --- | --- | --- |
| `o11y-ingest-rc-write` | `metrics:write`, `logs:write`, `traces:write` | `rc` | `grafana-otlp-ingest-token-rc` |
| `o11y-read` | `metrics:read`, `logs:read`, `traces:read` | `rc` | `grafana-otlp-read-token` |
| `o11y-ingest-prod-write` | `metrics:write`, `logs:write`, `traces:write` | `prod` | deferred until prod activation |

### Ingestion details (recorded)

| Field | Value |
| --- | --- |
| OTLP endpoint | `https://otlp-gateway-prod-us-east-3.grafana.net/otlp` |
| Grafana Cloud instance ID | `1546554` |

### OTLP auth usage contract (locked)

Use the following runtime env configuration for services exporting telemetry to Grafana Cloud:

- `OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf`
- `OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp-gateway-prod-us-east-3.grafana.net/otlp`
- `OTEL_EXPORTER_OTLP_HEADERS=Authorization=Basic <base64(1546554:<ingest_token>)>`

Token handling rules:

- Do not store raw OTLP tokens in git.
- Read ingest tokens from Google Secret Manager (GSM) at runtime.
- Build the Basic auth payload from `instance_id:token` where instance ID is `1546554`.
- The token shown on Grafana's OpenTelemetry connection page is not a source-of-truth secret for this platform; managed policy tokens stored in GSM are the source of truth.

### OTLP token source mapping (GSM)

| Environment | GCP project | Secret name | Usage |
| --- | --- | --- | --- |
| `rc` | `mpa-forge-bp-rc` | `grafana-otlp-ingest-token-rc` | OTLP ingest auth token for traces/metrics/logs export |
| `rc` | `mpa-forge-bp-rc` | `grafana-otlp-read-token` | Read/query token for observability automation tooling |
| `prod` | `mpa-forge-bp-prod` | `grafana-otlp-ingest-token-prod` | OTLP ingest auth token for prod (pending creation) |

### Remaining actions to close P0-T03D

None for Phase 0 `rc` scope.

Deferred follow-ups (pre-prod / later phases):

1. Create `prod` ingest/read secrets in `mpa-forge-bp-prod` and map to prod policies.
2. Validate runtime wiring in `rc` (`Cloud Run` and later `GKE`) so OTLP headers are composed from GSM token material using instance ID `1546554`. This is intentionally deferred until a deployable service exists (Phase 3+ implementation).
3. Extend mandatory label contract with `cloud.provider` and `cloud.region` after runtime wiring and hardening review (post first running workload).

Done when (Phase 0): `rc` policy/token inventory, OTLP metadata/auth contract, and label partitioning rules are recorded in this section.

### Locked label partitioning baseline (current)

Mandatory labels for all telemetry signals (metrics, logs, traces):

- `env`
- `project`
- `service`
