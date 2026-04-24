# Decision Matrix

## Purpose
Cross-link major platform decisions to their current status and source of truth.

Status legend:
- `Locked`: accepted and active for current implementation phases.
- `Deferred`: intentionally postponed to a later phase.

## Matrix

| Domain | Decision | Status | Source of truth |
| --- | --- | --- | --- |
| Cloud provider | GCP selected | Locked | `platform-specification.md` (Section 10) |
| Environment model | `local` + `rc` + `prod`; prod fully separate | Locked | `common/standards/environment-and-region.md` |
| Primary region | `us-east4` for `rc` and `prod` | Locked | `common/standards/environment-and-region.md` |
| API runtime path | Cloud Run managed baseline; GKE Autopilot + Helm alternative; single-VPS preset allowed for low-scale/cost-sensitive environments | Locked | `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`, `implementation/governance/deployment-preset-environment-evidence.md` |
| Initial cluster policy | Do not create initial GKE cluster; enable when needed | Locked | `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`, `platform-specification.md` |
| Repo strategy | Polyrepo with dedicated repos per frontend/api/worker/contracts/infra/ai-workers | Locked | `platform-specification.md` (Section 10), `implementation/governance/repo-ownership.md` |
| Auth provider | Clerk Free, B2C-first | Locked | `platform-specification.md` (Section 10), `implementation/governance/provider-account-inventory.md` (`P0-T03C`) |
| Browser/API contracts | Proto-first with Connect compatibility | Locked | `platform-specification.md` (Sections 10, 13) |
| Go HTTP stack | Native `net/http` + `connect-go` | Locked | `platform-specification.md` (Section 10) |
| Database technology | PostgreSQL | Locked | `platform-specification.md` (Sections 3, 4) |
| Database hosting | Cloud SQL for PostgreSQL | Locked | `platform-specification.md` (Section 4) |
| Typed DB access | `sqlc` + handwritten SQL + `pgx` | Locked | `platform-specification.md` (Section 10) |
| Queue/broker | Deferred until product needs async semantics | Deferred | `platform-specification.md` (Sections 9, 10) |
| Secrets model | GSM direct on Cloud Run; GSM + ESO on GKE | Locked | `platform-specification.md` (Sections 4, 10), `common/standards/access-model.md` |
| Observability platform | Grafana Cloud Free (metrics/logs/traces/alerts) | Locked | `platform-specification.md` (Sections 4, 10, 14) |
| Observability runtime modes | `direct_otlp` (Cloud Run) + `collector_gateway` (GKE) through shared library | Locked | `ops/observability-telemetry-budget-profile.md`, `platform-specification.md` (Sections 10, 14) |
| Telemetry budget control | Single `OBS_TELEMETRY_PROFILE` (`balanced`/`cost`/`debug`) | Locked | `ops/observability-telemetry-budget-profile.md` |
| Error tracking provider | Sentry integration moved to Phase 8 | Deferred | `implementation/phase-tasks/phase-8-scalability-reliability-and-security-hardening-tasks.md` (`P8-T15`) |
| Incident response provider | incident.io integration moved to Phase 8 | Deferred | `implementation/phase-tasks/phase-8-scalability-reliability-and-security-hardening-tasks.md` (`P8-T16`) |
| CI/CD platform | GitHub Actions | Locked | `platform-specification.md` (Section 10) |
| CD operating model | Pipeline-driven deploy to Cloud Run baseline; Helm for GKE path | Locked | `platform-specification.md` (Section 10), `implementation/implementation-plan.md` |
| Artifact registry | Google Artifact Registry | Locked | `platform-specification.md` (Section 10) |
| Contract generation mode | Buf CLI in local/CI, no paid BSR dependency | Locked | `platform-specification.md` (Section 10) |
| Contracts package distribution | TS client published from `platform-contracts` to GitHub Packages | Locked | `platform-specification.md` (Sections 10, 13) |
| Task management | GitHub Issues + GitHub Projects (cross-repo board) | Locked | `platform-specification.md` (Section 10) |
| AI task-to-code runtime | Dedicated `platform-ai-workers` with local/cloud parity, Cloud Run Jobs wake-ups | Locked | `platform-specification.md` (Sections 10, 17), `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md` |
| Frontend serving path | Authenticated app first; CDN-first (`Cloud CDN + HTTPS LB + Cloud Storage`) | Locked | `platform-specification.md` (Sections 5, 10) |
| Ingress routing | Single domain, path-based (`/api/*`) | Locked | `platform-specification.md` (Section 10) |
| TLS management | Managed certificates | Locked | `platform-specification.md` (Section 10) |
| Terraform env structure | Separate roots per env (`rc`, `prod`); shared modules plus preset-driven topology selection | Locked | `platform-specification.md` (Section 10), `implementation/governance/deployment-preset-environment-evidence.md` |
| Terraform state backend | GCS backend with per-env isolation and lock timeout policy | Locked | `platform-specification.md` (Section 10) |
| Prod deploy control | On-demand promotion with approvals | Locked | `platform-specification.md` (Section 10) |
| DB migration rollback policy | Forward-fix only | Locked | `platform-specification.md` (Section 10) |
| Security/access model | Least-privilege roles, WIF for CI, environment-scoped secrets | Locked | `common/standards/access-model.md` |
| Edge provider layering | Keep GCP-native edge baseline; evaluate external edge later | Deferred | `platform-specification.md` (Sections 9, 10), Phase 8 `P8-T14` |
| Deploy-time image signature verification | Deferred to hardening phase | Deferred | `platform-specification.md` (Section 10) |

## Review Triggers
- New provider/tool introduced.
- Runtime path switch (`cloud_run` <-> `gke`).
- Any decision currently marked `Deferred` is pulled forward.
- Security/compliance requirement changes merge/deploy controls.
