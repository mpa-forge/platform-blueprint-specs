# Phase 5 Tasks: Terraform Infrastructure

## Goal
Provision reproducible cloud infrastructure for `rc` and `prod` with safe state management, strict RC isolation boundaries, and fully separate prod isolation.

## Tasks

### P5-T01: Define Terraform repository layout and module boundaries
Owner: Agent  
Type: IaC design  
Dependencies: Phase 0 naming standards  
Action: Create module structure (`network`, `gke`, `gar`, `cloudsql`, `secrets`, optional observability support), shared variables, and explicit per-environment project boundaries (`rc` project, `prod` project). Enforce one root per environment (for example `infra/envs/rc` and `infra/envs/prod`) with shared modules under `infra/modules`, and avoid workspace-based environment switching.  
Output: Terraform project skeleton.  
Done when: `terraform validate` runs for all modules/stacks and each environment can be planned from its own root directory.

### P5-T02: Configure remote state backend and locking
Owner: Human + Agent  
Type: IaC + platform config  
Dependencies: P5-T01  
Action: Configure Terraform `backend \"gcs\"` using a dedicated state project, separate buckets for `rc` and `prod`, prefix convention `<env>/<root-module>`, bucket safeguards (Object Versioning, Uniform bucket-level access, Public Access Prevention), and CI/apply lock timeout (`-lock-timeout=5m`).  
Output: Secure remote state setup.  
Done when: Team and CI run plan/apply against shared remote state, locks prevent concurrent state writes, and environment IAM separation is enforced.

### P5-T03: Implement VPC/network module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Action: Define network, subnets, private service access, and routing needed for GKE and Cloud SQL.  
Output: Network module with outputs for downstream modules.  
Done when: Network resources apply cleanly and are consumable by cluster/DB modules.

### P5-T04: Implement GKE Autopilot module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Action: Provision Autopilot cluster module with workload identity config and node/network policies as baseline; enforce baseline cost guardrail so only RC cluster is active initially, with prod cluster creation behind an explicit production enable flag/gate.  
Output: Cluster module and environment bindings.  
Done when: RC cluster is reachable and ready for namespace/workload deployment, and prod cluster provisioning is safely gated for later cutover.

### P5-T05: Implement GAR module and IAM bindings
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Action: Provision GAR repos and roles for CI push and runtime pull principals.  
Output: Artifact registry resources and IAM policies.  
Done when: CI can push and GKE workloads can pull images.

### P5-T06: Implement Cloud SQL PostgreSQL module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Action: Provision instance, backups, maintenance window, private networking, and DB/IAM auth baseline.  
Output: Managed Postgres infrastructure.  
Done when: API connectivity path from cluster to DB is validated.

### P5-T07: Implement GSM + IAM + ESO integration resources
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T04  
Action: Provision secret placeholders, access bindings, and workload identity permissions for ESO/controller/workloads.  
Output: Secret management infrastructure baseline.  
Done when: Workloads can retrieve expected secrets via ESO sync path.

### P5-T08: Implement Cloud Run Jobs + Scheduler module for AI workers
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01, P5-T05, P5-T07  
Action: Provision Cloud Run Job definitions (and optional low-frequency Scheduler backstop), service accounts/IAM, and Secret Manager bindings for `platform-ai-workers` execution. Support multiple worker-job deployments, each targeting a repository with environment-specific configuration (`WORKER_RUNTIME_MODE=cloud`, `WORKER_ID`, `TARGET_REPO`, `MAX_PENDING_REVIEW`, `POLL_INTERVAL`, credential refs), and grant least-privilege on-demand execution permissions for GitHub Actions event-trigger wake-up workflows as defined in `ops/ai-comment-trigger-cloud-run-jobs.md`. Ensure Cloud Run Job command/args invoke the same runtime entrypoint used for local execution, per `ops/ai-worker-local-cloud-parity.md`.  
Output: AI worker runtime infrastructure module.  
Done when: At least one worker-job deployment can be created per environment and triggered both on schedule and on-demand with least privilege.

### P5-T09: Build environment stacks (`rc`, `prod`)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03..P5-T08  
Action: Create per-environment root stack composition and parameter files with minimal drift, while enforcing prod full separation and RC internal isolation boundaries; keep environment selection explicit by root path, not Terraform workspace; include explicit gating variable(s) so baseline provisions only one active RC cluster until prod enable decision, aligned with `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.  
Output: Environment-specific IaC layers.  
Done when: `terraform plan` works for all environments from their dedicated root paths.

### P5-T10: Add IaC policy checks and formatting in CI
Owner: Agent  
Type: CI/IaC  
Dependencies: P5-T01  
Action: Add formatting, validation, static analysis, and policy checks to PR pipelines.  
Output: Infrastructure quality gates.  
Done when: Invalid infra changes are blocked in CI before apply.

### P5-T11: Execute `rc` clean-state apply and document runbook
Owner: Human + Agent  
Type: Validation  
Dependencies: P5-T01..P5-T10  
Action: Apply full stack from empty state, capture timings, rollback instructions, and known caveats.  
Output: Provisioning evidence and runbook.  
Done when: `rc` can be recreated from scratch reproducibly.

### P5-T12: Implement prod cluster lifecycle runbooks and guarded workflows
Owner: Human + Agent  
Type: IaC operations design  
Dependencies: P5-T04, P5-T09, P5-T10  
Action: Define and implement guarded Terraform workflow paths for prod cluster `create`, `destroy`, and `recover` operations (explicit enable flags, approval gates, plan visibility, and state protections), and document procedures per `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.  
Output: `docs/operations/create-prod-cluster.md`, `docs/operations/destroy-prod-cluster.md`, and `docs/operations/recover-prod-cluster.md`.  
Done when: Operators can run controlled create/destroy/recover flows for prod cluster without manual infrastructure drift.

## Artifacts Checklist
- Terraform module/stacks structure
- remote state backend/locking configuration
- network, cluster, GAR, Cloud SQL, GSM modules
- Cloud Run Job/Scheduler module for AI workers
- `ops/ai-comment-trigger-cloud-run-jobs.md` IAM mapping reference
- `ops/ai-worker-local-cloud-parity.md` runtime parity mapping reference
- `ops/ephemeral-gke-cluster-lifecycle-requirements.md` conformance mapping
- environment variable files and outputs
- IaC CI validation checks
- `rc` apply evidence and infra runbook
