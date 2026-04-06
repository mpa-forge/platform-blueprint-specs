# Phase 5: Terraform Infrastructure

Detailed tasks: `implementation/phase-tasks/phase-5-terraform-infrastructure-tasks.md`
Specification artifact: `ops/ephemeral-gke-cluster-lifecycle-requirements.md`
Runtime selection artifact: `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`
Cost suspend/resume artifact: `ops/cost-suspend-resume-automation.md`

- Create Terraform modules for:
  - network/VPC
  - Cloud Run API service baseline
  - optional GKE Autopilot cluster
  - Google Artifact Registry repositories and IAM bindings
  - Cloud SQL for PostgreSQL instances, networking, backups, and IAM/database auth integration
  - Google Secret Manager secrets and IAM policies (plus workload identity bindings for ESO on GKE path)
  - Edge routing resources for single-domain `/api/*` mapping to Cloud Run baseline path
  - Cloud Run Jobs + Cloud Scheduler + IAM for AI task-to-code workers, including on-demand execution permissions for event-trigger workflows
  - observability dependencies (as needed), including Grafana dashboard provisioning support
- Create env stacks (`rc`, `prod`) with separate project-level isolation for prod.
- Apply runtime guardrail: Cloud Run API path enabled by default for first iteration; GKE cluster resources remain disabled/gated until explicitly enabled.
- Implement lifecycle controls so GKE cluster (when enabled) can be created/destroyed/recovered on demand via Terraform + Helm workflows.
- Enforce one Terraform root per environment (`rc`, `prod`) with shared modules.
- Do not use Terraform workspaces for environment isolation/switching.
- Add remote state and locking.
- Enforce separate GCP projects for `rc` and `prod`.
- Allow minimal infra subset pull-forward when needed to unblock early AI worker automation bootstrap (Cloud Run Job + Scheduler + GSM/IAM).
- Build suspend/resume tooling to drop idle environment cost to near zero and restore deterministically (including Cloud SQL backup/restore, Cloud Storage sync/restore, and artifact metadata/archive handling).
- Standardize Terraform remote state pattern on GCS backend:
  - Dedicated Terraform state project.
  - Separate state bucket per environment (`rc`, `prod`) with strict IAM isolation.
  - Prefix convention per root module: `<env>/<root-module>`.
  - Bucket safeguards: Object Versioning, Uniform bucket-level access, Public Access Prevention.
  - Locking via Terraform GCS backend with CI/apply `-lock-timeout=5m`.

Exit criteria:
- `rc` infra provisioned reproducibly from clean state.
- baseline Grafana dashboards can be recreated from source-controlled definitions through the Phase 5 provisioning path.
- baseline `rc` API runtime is Cloud Run (no GKE cluster required).
- prod infra is provisioned as a fully separate environment.
- IaC plan/apply integrated with CI checks.

## Open Questions / Choices To Clarify Later
- None currently.
