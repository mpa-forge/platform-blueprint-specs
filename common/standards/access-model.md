# Security Access Model (P0-T07)

## Purpose
Define least-privilege access ownership for platform administration, development, CI/CD, and incident response.

## Current Operating Context
- Current human model: single maintainer (`MiquelPiza`).
- AI agents can propose changes via PR only; no merge/admin authority.
- Model must support adding more humans later without redesign.

## Role Baseline

| Role | Scope | Access level | Assigned now |
| --- | --- | --- | --- |
| `org-admin` | GitHub organization and provider account governance | Admin | `MiquelPiza` |
| `repo-maintainer` | Repository code, reviews, releases | Write + PR approve | `MiquelPiza` |
| `ci-deployer` | GitHub Actions -> GCP deploy path | Workload identity, least-privilege IAM only | GitHub OIDC principal |
| `runtime-service` | API/worker runtime identity | Service-specific IAM only | Cloud Run service accounts |
| `observability-admin` | Grafana stack policies/tokens | Admin for o11y config only | `MiquelPiza` |
| `oncall-responder` | Alert triage and incident actions | Ops access only | `MiquelPiza` |
| `break-glass` | Emergency privileged actions | Time-bound elevated access | `MiquelPiza` (documented override only) |

## GitHub Access Model
- Organization:
  - enforce 2FA for members.
  - `main` protected branch policy applies per repo.
- Repository permissions:
  - default contributors should have no direct merge bypass.
  - PR + required checks + human approval required.
- Automation:
  - GitHub Actions tokens use minimum required permissions per workflow.
  - AI workers use scoped credentials per target repo and cannot bypass protections.

## GCP Access Model
- Environment separation:
  - separate projects for `rc` and `prod`.
- Human access:
  - `prod` admin operations are explicit and audited.
  - no standing broad owner/editor grants to automation identities.
- CI access:
  - Workload Identity Federation only (no static service account keys).
  - CI principal gets minimal roles needed to deploy and read required artifacts/secrets.
- Runtime access:
  - one service account per workload class where practical.
  - service account scopes limited to required resources only (for example specific GSM secrets, Cloud SQL connection).

## Secret and Token Access
- Source of truth:
  - Google Secret Manager for runtime and provider credentials.
- Access rules:
  - secrets are environment-scoped (`rc` vs `prod`).
  - read grants are service-account specific, not project-wide broad grants.
  - no plaintext secrets in repositories or CI logs.

## Incident and Escalation Ownership
- Current baseline:
  - primary on-call and escalation owner: `MiquelPiza`.
  - acknowledge/triage route via Grafana alerting + webhook/Slack baseline.
- Future-ready model:
  - add secondary on-call owner once team size > 1.
  - incident.io integration and routing ownership is introduced in Phase 8.

## Emergency Access Flow (Break-Glass)
1. Declare incident context and reason for elevated action.
2. Execute the minimum required privileged change.
3. Record action summary and affected systems in ops notes.
4. Revoke elevated access state and rotate impacted credentials if needed.

## Enforcement Checklist
- Branch protection enabled on `main` in all active repos.
- WIF-based CI authentication enabled for deploy workflows.
- Service accounts are scoped per workload responsibility.
- GSM secret access restricted by environment and service identity.
- Provider admin surfaces limited to `org-admin` role.

## Review Cadence
- Revalidate this model at each phase gate.
- Trigger immediate review when:
  - a new maintainer is added
  - a new provider is introduced
  - prod deployment path is activated
  - break-glass action is used
