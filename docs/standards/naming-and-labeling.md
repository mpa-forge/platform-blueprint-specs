# Naming and Labeling Standard

## Purpose
Define consistent naming and labeling conventions for repositories, build artifacts, infrastructure resources, and runtime workloads.

## Scope
Applies to:
- GitHub repositories under `mpa-forge`
- Google Artifact Registry (GAR) repositories/images/tags
- Terraform roots/modules/resource names
- Cloud Run services/jobs
- Optional GKE namespaces (when GKE runtime path is enabled)
- Labels/tags used for cost attribution, ownership, and filtering

## Canonical Tokens
- Organization slug: `mpa-forge`
- Platform slug: `platform-blueprint`
- Environment: `local` | `rc` | `prod`
- Region baseline: `us-east4`

## Repository Naming
Pattern:
- `<domain>-<component>`

Baseline repos:
- `platform-blueprint-specs`
- `frontend-web`
- `backend-api`
- `backend-worker`
- `platform-ai-workers`
- `platform-contracts`
- `platform-infra`

Rules:
- Lowercase, hyphen-separated.
- Names should be stable and technology-agnostic where possible.

## GAR Naming
Image URI pattern:
- `${REGION}-docker.pkg.dev/${PROJECT_ID}/${GAR_REPOSITORY}/${IMAGE_NAME}:${TAG}`

Conventions:
- `GAR_REPOSITORY`: workload class (`apps`, `workers`, `tools`) or equivalent fixed set.
- `IMAGE_NAME`: match service/repo identity (for example `backend-api`, `backend-worker`, `platform-ai-workers`).
- `TAG`:
  - required immutable tag: `sha-<git_sha_12>`
  - optional release tag: `v<semver>`

Rules:
- Deployment references must use immutable tags (or digest).
- Do not use mutable `latest` for deploy targets.

## Terraform Naming
Terraform root layout:
- `environments/rc`
- `environments/prod`
- `modules/*` shared modules

Resource naming pattern:
- `<service>-<env>` for environment-scoped resources
- `<org>-<service>-<env>` when global uniqueness is needed

Examples:
- Cloud Run service: `api-rc`
- Cloud Run job: `ai-worker-backend-api-rc`
- Secret name: `grafana-otlp-ingest-token-rc`

## Cloud Run Naming
Service/job pattern:
- Services: `<service>-<env>`
- Jobs: `<job>-<target>-<env>`

Examples:
- `api-rc`, `api-prod`
- `worker-rc`, `worker-prod`
- `ai-worker-backend-api-rc`

Revision naming:
- Keep Cloud Run auto-generated revision names.
- Traceability must come from labels/metadata and image tag/digest, not custom revision naming.

## Optional GKE Namespace Naming
Only when `API_RUNTIME_PATH=gke`:
- `<domain>-<env>`

Examples:
- `platform-rc`
- `platform-prod`
- `ops-rc` (shared operational components in RC)

## Required Labels
Mandatory labels for infrastructure and workloads:
- `env`: `local|rc|prod`
- `project`: project/system identifier (for example `platform-blueprint`)
- `service`: workload identifier (`api`, `worker`, `frontend`, `ai-worker`, etc.)
- `managed_by`: `terraform|manual|github-actions`

Recommended labels:
- `region`
- `owner`
- `tier`
- `cost_center` (if/when introduced)

Observability label baseline (already locked):
- `env`
- `project`
- `service`

## Validation Rules
- All names use lowercase + `-`.
- No environment-ambiguous names in deployed resources.
- CI must fail deployment manifests/IaC if required labels are missing.
- Branch protection enforces CI checks before merge.
