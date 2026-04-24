## Why

Phase 5 needs deployable secret-management infrastructure so the Cloud Run baseline and optional GKE path can consume runtime credentials without plaintext secrets in Terraform values, repos, or broad project IAM grants. This change is needed now because P5-T06 established the database credential contract around a Secret Manager-backed `DB_PASSWORD`, and Phase 6 runtime delivery depends on concrete GSM, IAM, and ESO resources rather than placeholders.

## What Changes

- Add a runtime secret-delivery capability that standardizes environment-scoped Google Secret Manager placeholders, version handling expectations, and least-privilege IAM grants for workload service accounts.
- Define the baseline Cloud Run secret-access path so API and worker runtimes can read expected secrets directly from Secret Manager, including password-only database delivery for the backend API.
- Define the alternative GKE secret-delivery path so ESO can sync approved secrets from Secret Manager through workload identity without changing the canonical secret source.
- Establish the ownership boundary between Terraform-managed secret infrastructure and application/runtime configuration in `backend-api`, `backend-worker`, and `platform-ai-workers`.
- Capture implementation sequencing so later apply work can coordinate `platform-infra` secret resources with the runtime contract updates required in dependent repositories.

## Capabilities

### New Capabilities
- `runtime-secret-delivery`: Defines how environment-scoped secrets are provisioned in Google Secret Manager, exposed to Cloud Run workloads, and synchronized to GKE workloads through ESO while preserving least-privilege IAM and password-only database secret handling.

### Modified Capabilities
None.

## Impact

- Affected repos: `platform-infra`, `backend-api`, `backend-worker`, `platform-ai-workers`
- Affected systems: Google Secret Manager, IAM, Cloud Run runtime secret access, optional GKE workload identity and ESO sync
- Dependencies: P5-T01 networking/project baseline, P5-T06 Cloud SQL/database credential contract, and Phase 6 runtime deployment work that consumes these secrets
- Operational impact: secrets remain environment-scoped and service-account specific, with `DB_PASSWORD` stored as the canonical database secret rather than a full `DATABASE_URL`
