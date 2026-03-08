# Repo Context: platform-infra

Load this file when working in `platform-infra`.

## Repo Role

- Own Terraform modules and environment roots.
- Own the centralized local development stack orchestration for frontend, API, and Postgres.
- Keep both Cloud Run and GKE paths available, with Cloud Run as the current baseline.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/implementation-phases/phase-1-repository-and-local-development-baseline.md`
- `../platform-blueprint-specs/ops/ephemeral-gke-cluster-lifecycle-requirements.md`

## Relevant Shared Constraints

- Cloud Run is the initial API runtime baseline.
- GKE remains a supported alternative path, but no cluster is created for the initial iteration.
- The local development stack is hybrid and centralized here.
- Terraform environment structure uses separate roots per environment with shared modules.

## Consult Conditionally

- `../platform-blueprint-specs/platform-specification.md` only when the task needs broader cross-platform architecture decisions.

## Typical Validation

- `make lint`
- repo-local compose or smoke commands when stack behavior changes
