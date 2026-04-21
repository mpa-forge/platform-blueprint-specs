# Phase 5 Tasks: Terraform Infrastructure

## Goal
Provision reproducible cloud infrastructure for `rc` and `prod` with safe state management, strict RC isolation boundaries, and fully separate prod isolation.

## Tasks

### P5-T01: Define Terraform repository layout and module boundaries
Owner: Agent  
Type: IaC design  
Dependencies: Phase 0 naming standards  
Status: Completed (`2026-04-21`)  
Evidence: `platform-infra` PR #25 (`Add Phase 5 Terraform skeleton and docs`), validated with `make terraform-validate`, `make terraform-plan ENV=rc`, and `make terraform-plan ENV=prod`.  
Action: Create module structure (`network`, `cloudrun_api`, optional `gke`, `gar`, `cloudsql`, `secrets`, optional observability support), shared variables, and explicit per-environment project boundaries (`rc` project, `prod` project). Enforce one root per environment (for example `infra/envs/rc` and `infra/envs/prod`) with shared modules under `infra/modules`, and avoid workspace-based environment switching. This task also creates the deployable Terraform root/module baseline required to finish `P3-T02` Cloud Run observability secret delivery beyond the current documented placeholder contract.
Output: Terraform project skeleton.  
Done when: `terraform validate` runs for all modules/stacks and each environment can be planned from its own root directory.

### P5-T02: Configure remote state backend and locking
Owner: Human + Agent  
Type: IaC + platform config  
Dependencies: P5-T01  
Status: Completed (`2026-04-21`)  
Evidence: Dedicated state project `mpa-forge-bp-tfstate`, protected buckets `mpa-forge-bp-tfstate-rc` and `mpa-forge-bp-tfstate-prod`, `platform-infra` branch `codex/p5-t02-remote-state`, and `implementation/governance/terraform-remote-state-evidence.md`. Validated with `make terraform-validate`, `make terraform-plan ENV=rc`, and `make terraform-plan ENV=prod`.  
Action: Configure Terraform `backend \"gcs\"` using a dedicated state project, separate buckets for `rc` and `prod`, prefix convention `<env>/<root-module>`, bucket safeguards (Object Versioning, Uniform bucket-level access, Public Access Prevention), and CI/apply lock timeout (`-lock-timeout=5m`).  
Output: Secure remote state setup.  
Done when: Team and CI run plan/apply against shared remote state, locks prevent concurrent state writes, and environment IAM separation is enforced.

### P5-T03: Implement VPC/network module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Action: Define network, subnets, private service access, and routing needed for Cloud Run-to-Cloud SQL connectivity baseline and optional GKE path.  
Output: Network module with outputs for downstream modules.  
Done when: Network resources apply cleanly and are consumable by runtime/DB modules.

### P5-T04: Implement Cloud Run API module (baseline runtime)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Action: Provision Cloud Run service module for API with revision settings, min/max instances, concurrency, service account/IAM, secret/env wiring, and Cloud SQL connectivity settings for `rc`/`prod`.  
Output: Cloud Run API module and environment bindings.  
Done when: RC API service can be planned/applied and deployed with healthy revisions in Cloud Run.

### P5-T05: Implement GAR module and IAM bindings
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Action: Provision GAR repos and roles for CI push and runtime pull principals.  
Output: Artifact registry resources and IAM policies.  
Done when: CI can push and Cloud Run runtime (and optional GKE runtime) can pull images.

### P5-T06: Implement Cloud SQL PostgreSQL module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Action: Provision instance, backups, maintenance window, private networking, and DB/IAM auth baseline.  
Output: Managed Postgres infrastructure.  
Done when: API connectivity path from selected runtime (Cloud Run baseline, optional GKE) to DB is validated.

### P5-T07: Implement GSM + IAM + ESO integration resources
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Action: Provision secret placeholders and access bindings for runtimes; include Cloud Run direct secret access baseline and ESO/workload identity permissions for optional GKE/controller/workloads.  
Output: Secret management infrastructure baseline.  
Done when: Cloud Run API can read expected secrets directly and GKE path can retrieve expected secrets via ESO sync when enabled.

### P5-T08: Implement Cloud Run Jobs + Scheduler module for AI workers
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01, P5-T05, P5-T07  
Action: Provision Cloud Run Job definitions (and optional low-frequency Scheduler backstop), service accounts/IAM, and Secret Manager bindings for `platform-ai-workers` execution. Support multiple worker-job deployments, each targeting a repository with environment-specific configuration (`WORKER_RUNTIME_MODE=cloud`, `WORKER_ID`, `TARGET_REPO`, `MAX_PENDING_REVIEW`, `POLL_INTERVAL`, credential refs), and grant least-privilege on-demand execution permissions for GitHub Actions event-trigger wake-up workflows as defined in `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`. Ensure Cloud Run Job command/args invoke the same runtime entrypoint used for local execution, per `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`.  
Output: AI worker runtime infrastructure module.  
Done when: At least one worker-job deployment can be created per environment and triggered on-demand with least privilege (with optional scheduler backstop enabled when configured).

### P5-T09: Build environment stacks (`rc`, `prod`)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03..P5-T08  
Action: Create per-environment root stack composition and parameter files with minimal drift, while enforcing prod full separation and RC internal isolation boundaries; keep environment selection explicit by root path, not Terraform workspace; include explicit runtime gates so baseline enables Cloud Run API and keeps GKE modules disabled until explicit enable decision, aligned with `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.  
Output: Environment-specific IaC layers.  
Done when: `terraform plan` works for all environments from their dedicated root paths.

### P5-T09A: Implement Grafana dashboard provisioning module and env wiring
Owner: Agent  
Type: IaC coding  
Dependencies: P3-T01, P3-T06, P5-T01, P5-T09  
Action: Add `platform-infra` observability support for authoritative Grafana dashboard provisioning using the scoped Grafana API token and stack inputs established earlier in Phase 3. Define provider and module wiring for Grafana folders and baseline dashboards, and ensure the env roots consume the source-controlled dashboard definitions prepared by `P3-T06` from `../platform-infra/docs/grafana-dashboards/manifest.json`, `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`, `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`, and `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json` without manual UI re-authoring.  
Output: Grafana dashboard provisioning module and environment bindings.  
Done when: `terraform plan` from each env root shows Grafana folder and dashboard resources that recreate the baseline dashboards from the prepared source-controlled definitions.

### P5-T10: Add IaC policy checks and formatting in CI
Owner: Agent  
Type: CI/IaC  
Dependencies: P5-T01, P5-T09A  
Action: Add formatting, validation, static analysis, and policy checks to PR pipelines, including checks that cover Grafana dashboard provisioning assets and their Terraform wiring once the dashboard module exists.  
Output: Infrastructure quality gates.  
Done when: Invalid infra changes are blocked in CI before apply.

### P5-T10A: Implement `rc` Terraform apply workflow through CI
Owner: Human + Agent  
Type: CI/IaC deployment automation  
Dependencies: P5-T02, P5-T09, P5-T10  
Action: Implement a dedicated CI workflow that runs Terraform apply for the `rc` environment from the `platform-infra` repository using the shared remote state backend, workload identity/OIDC authentication, explicit root-path targeting, plan visibility, and concurrency protection. The workflow must define the trigger model for `rc` apply (for example merge to `main`, manual approval, or approved workflow dispatch), ensure `terraform plan` output is preserved or surfaced before apply, use the shared lock timeout convention, and prevent accidental prod execution from the same path. Document the operational contract, including who can trigger the workflow, what branch/event gates it, rollback expectations, and how it interacts with follow-up verification/runbook tasks.
Output: CI-managed `rc` Terraform apply workflow and operator guidance.  
Done when: A reviewed change merged to the approved branch or an approved dispatch can run `terraform apply` for `environments/rc` from CI against shared remote state, with authenticated least-privilege access, visible plan/apply logs, and protections that prevent `prod` apply from the `rc` workflow.

### P5-T11: Execute `rc` clean-state apply and document runbook
Owner: Human + Agent  
Type: Validation  
Dependencies: P5-T01..P5-T10, P5-T10A, P5-T09A, P5-T15  
Action: Apply full stack from empty state, including authoritative Grafana dashboard provisioning where configured, and capture timings, rollback instructions, and known caveats.  
Output: Provisioning evidence and runbook.  
Done when: `rc` can be recreated from scratch reproducibly, including restoration of the baseline Grafana dashboards from source-controlled definitions.

### P5-T12: Implement prod cluster lifecycle runbooks and guarded workflows
Owner: Human + Agent  
Type: IaC operations design  
Dependencies: P5-T09, P5-T10, P5-T13  
Action: Define and implement guarded Terraform workflow paths for prod cluster `create`, `destroy`, and `recover` operations (explicit enable flags, approval gates, plan visibility, and state protections), and document procedures per `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.  
Output: `docs/operations/create-prod-cluster.md`, `docs/operations/destroy-prod-cluster.md`, and `docs/operations/recover-prod-cluster.md`.  
Done when: Operators can run controlled create/destroy/recover flows for prod cluster without manual infrastructure drift.

### P5-T13: Implement optional GKE Autopilot module (deferred runtime path)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Action: Provision Autopilot cluster module with workload identity config and baseline node/network policies, but keep module disabled by default in env stacks; include explicit enable flags and safe defaults for later activation.  
Output: Optional GKE cluster module and gated environment bindings.  
Done when: GKE cluster can be enabled/disabled by configuration without restructuring Terraform roots.

### P5-T14: Implement API runtime switch controls and migration runbook
Owner: Human + Agent  
Type: IaC operations design  
Dependencies: P5-T04, P5-T09, P5-T13  
Action: Define and document a reversible runtime switch procedure (Cloud Run baseline <-> GKE optional) covering Terraform toggles, routing changes, secret wiring differences, observability mode switch, and validation checkpoints.  
Output: `docs/operations/api-runtime-switch-runbook.md`.  
Done when: Team can enable/disable either API runtime path with documented steps and no manual infrastructure drift.

### P5-T15: Provision Cloud Run edge routing resources for `/api/*`
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T04, P5-T05, P5-T09  
Action: Implement Terraform resources required to route single-domain `/api/*` traffic to Cloud Run API baseline path (for example serverless NEG/backend wiring, URL map/path matcher integration, TLS/certificate references as applicable). Keep configuration compatible with later runtime switch to GKE backend path.  
Output: Runtime-routing infrastructure definitions for Cloud Run API path.  
Done when: RC environment can route `/api/*` requests to Cloud Run API through IaC-managed configuration.

### P5-T16: Build environment suspend/resume cost-control tool
Owner: Human + Agent  
Type: IaC operations automation  
Dependencies: P5-T04, P5-T05, P5-T06, P5-T08, P5-T09  
Action: Implement a script/tooling package (in `platform-infra`) that can suspend an environment to near-zero run cost and later restore it with data integrity. The tool must support deterministic `suspend <env>` and `resume <env>` commands, and follow the contract in `ops/cost-suspend-resume-automation.md`. Suspend flow must include Cloud SQL backup/export, Cloud Storage backup/sync, artifact image metadata snapshot (and optional image copy/export policy), scale-to-zero where possible (Cloud Run), and deletion/disablement of always-costing resources where required (for example Cloud SQL instance, schedulers, optional GKE resources when enabled). Resume flow must recreate resources via Terraform and restore required datasets/artifacts before reopening traffic.  
Output: Suspend/resume tooling, state snapshot manifest format, and operations runbook.  
Done when: `rc` can be suspended and restored end-to-end with documented evidence, successful smoke validation after resume, and measured idle cost reduction consistent with near-zero objective (except retained backup/archive storage).

## Artifacts Checklist
- Terraform module/stacks structure
- remote state backend/locking configuration
- network, Cloud Run API, optional GKE cluster, GAR, Cloud SQL, GSM modules
- Grafana dashboard provisioning module and environment bindings
- `../platform-infra/docs/grafana-dashboards/manifest.json`
- `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`
- `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`
- `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json`
- Cloud Run API runtime module validation evidence
- Cloud Run Job/Scheduler module for AI workers
- `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md` IAM mapping reference
- `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md` runtime parity mapping reference
- `../backend-api/docs/api-runtime-paths-cloud-run-gke.md` runtime selection reference
- `ops/ephemeral-gke-cluster-lifecycle-requirements.md` conformance mapping
- `ops/cost-suspend-resume-automation.md` suspend/resume contract
- API runtime switch runbook
- suspend/resume tooling and runbook
- Cloud Run `/api/*` routing infrastructure definitions
- environment variable files and outputs
- IaC CI validation checks
- `rc` Terraform apply CI workflow and trigger/approval contract
- `rc` apply evidence and infra runbook
- Grafana dashboard recreate-from-source evidence
