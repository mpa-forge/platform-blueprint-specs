# Ephemeral GKE Cluster Lifecycle Requirements

## Purpose
Define the requirements to create, deploy, destroy, and recover a separate production-grade GKE cluster on demand, minimizing cost while preserving repeatability and safety.

## Context
- Baseline development operates with one active RC GKE Autopilot cluster.
- Prod cluster remains separate but is not kept running continuously until needed.
- The same lifecycle model should support temporary environments for future projects.

## Scope
- GKE Autopilot cluster lifecycle (`create -> deploy -> validate -> destroy -> recover`).
- Terraform-managed infrastructure orchestration.
- Helm-managed workload deployment.
- Operational runbooks and safety controls.

## Non-Goals
- Running prod and RC in the same cluster.
- Manual, ad-hoc cluster creation without IaC.
- Stateful data hosted only inside cluster-local storage.

## Core Requirements

### 1) Separation and Safety
- Prod and RC remain separate environments by design (projects, namespaces, secrets, DB boundaries, domains).
- Prod cluster creation is explicit and gated (never created implicitly by RC deploys).
- Destroy operations must require explicit enable flags and approvals.

### 2) Terraform Lifecycle Controls
- Use per-environment roots (`rc`, `prod`) with shared modules; no workspaces.
- Add explicit prod enable gate variables (for example `enable_prod_cluster`).
- Keep remote state persistent and protected (GCS backend, locking, versioning).
- `apply` and `destroy` must be idempotent and repeatable from clean state.
- Document ordered execution:
  - bootstrap network/identity prerequisites
  - create cluster and dependencies
  - deploy workloads
  - validate
  - destroy cluster resources when requested

### 3) Helm and Workload Reproducibility
- All cluster workloads must be deployable from Helm charts with environment values.
- No manual in-cluster drift as a dependency for successful startup.
- Cluster add-ons (ingress, ESO, collector/alloy, policy components) must be charted and reproducible.
- One command/workflow path should restore workloads after cluster recreation.

### 4) State and Data Durability
- Persistent data systems must be external to cluster lifecycle (for example Cloud SQL, GSM).
- Destroying cluster must not destroy persistent prod data unless explicitly intended.
- Recovery path must include DB connectivity validation and migration compatibility checks.
- Backups/restores are required for externally managed stateful systems.

### 5) Secrets and Identity Recovery
- Secrets sourced from GSM and synced via ESO after cluster recreation.
- IAM bindings and workload identity must be re-applied automatically via Terraform/Helm.
- No static credentials stored in repos.

### 6) Networking, DNS, and TLS
- DNS and ingress configuration must support cluster replacement without redesign.
- Certificates and routing must be re-provisionable via IaC/Helm flows.
- External endpoints should recover through documented cutover steps.

### 7) Observability Recovery
- Recreated clusters must re-register telemetry pipelines (logs/metrics/traces).
- `OBS_TELEMETRY_PROFILE` behavior must remain configurable after recovery.
- Baseline dashboards/alerts must remain valid or be automatically recreated.

### 8) CI/CD and Operational Automation
- CI/CD must support:
  - prod cluster create/deploy flow (approved)
  - prod cluster destroy flow (approved)
  - prod cluster recover/redeploy flow (approved)
- Include required smoke-test gates post-create and post-recover.
- Include dry-run/plan visibility before destructive actions.

## Required Runbooks
- `create-prod-cluster.md`: full bring-up sequence and expected checkpoints.
- `destroy-prod-cluster.md`: safe teardown scope and confirmation checklist.
- `recover-prod-cluster.md`: rehydrate cluster + redeploy workloads + validate service.
- `ephemeral-project-environment.md`: reusable pattern for future temporary projects.

## Validation Requirements
- Demonstrate from empty state:
  1. Create prod cluster.
  2. Deploy API/worker + required add-ons.
  3. Pass smoke tests (`healthz/readyz`, frontend->API->DB path, worker heartbeat).
  4. Destroy cluster compute/control-plane resources.
  5. Recreate cluster and recover workloads successfully.
- Capture timings, failures, rollback actions, and evidence artifacts.

## Acceptance Criteria
- Prod cluster can be created and destroyed on demand through documented IaC+CD workflow.
- Recovery to a healthy deployed state is reproducible without manual drift fixes.
- Persistent data and secrets survive cluster teardown/recreation as designed.
- Operational cost is controlled by keeping only required clusters active.

