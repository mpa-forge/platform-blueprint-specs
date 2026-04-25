# Phase 5 Tasks: Terraform Infrastructure

## Goal
Provision reproducible cloud infrastructure for `rc` and `prod` with safe state management, strict RC isolation boundaries, and fully separate prod isolation.

## Tasks

### P5-T01: Define Terraform repository layout and module boundaries
Owner: Agent  
Type: IaC design  
Dependencies: Phase 0 naming standards  
Affected repos: `platform-infra`, `backend-api`, `frontend-web`, `platform-ai-workers`
Status: Completed (`2026-04-21`)  
Evidence: `platform-infra` PR #25 (`Add Phase 5 Terraform skeleton and docs`), validated with `make terraform-validate`, `make terraform-plan ENV=rc`, and `make terraform-plan ENV=prod`.  
Action: Create module structure (`network`, `cloudrun_api`, optional `gke`, `gar`, `cloudsql`, `secrets`, optional observability support), shared variables, and explicit per-environment project boundaries (`rc` project, `prod` project). Enforce one root per environment (for example `infra/envs/rc` and `infra/envs/prod`) with shared modules under `infra/modules`, and avoid workspace-based environment switching. This task also creates the deployable Terraform root/module baseline required to finish `P3-T02` Cloud Run observability secret delivery beyond the current documented placeholder contract.
Output: Terraform project skeleton.  
Done when: `terraform validate` runs for all modules/stacks and each environment can be planned from its own root directory.

### P5-T02: Configure remote state backend and locking
Owner: Human + Agent  
Type: IaC + platform config  
Dependencies: P5-T01  
Affected repos: `platform-infra`
Status: Completed (`2026-04-21`)  
Evidence: Dedicated state project `mpa-forge-bp-tfstate`, protected buckets `mpa-forge-bp-tfstate-rc` and `mpa-forge-bp-tfstate-prod`, `platform-infra` branch `codex/p5-t02-remote-state`, and `implementation/governance/terraform-remote-state-evidence.md`. Validated with `make terraform-validate`, `make terraform-plan ENV=rc`, and `make terraform-plan ENV=prod`.  
Action: Configure Terraform `backend \"gcs\"` using a dedicated state project, separate buckets for `rc` and `prod`, prefix convention `<env>/<root-module>`, bucket safeguards (Object Versioning, Uniform bucket-level access, Public Access Prevention), and CI/apply lock timeout (`-lock-timeout=5m`).  
Output: Secure remote state setup.  
Done when: Team and CI run plan/apply against shared remote state, locks prevent concurrent state writes, and environment IAM separation is enforced.

### P5-T03: Implement VPC/network module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Affected repos: `platform-infra`, `backend-api`
Status: Completed (`2026-04-21`)
Evidence: `platform-infra` OpenSpec change `p5-t03-implement-vpc-network-module`; network module exports VPC, subnet, private service access range, and service networking connection contracts. Validated with `make terraform-validate`, default-disabled `make terraform-plan ENV=rc` and `make terraform-plan ENV=prod`, plus network-enabled Terraform plans for both environment roots showing 4 network resources to add.
Action: Define network, subnets, private service access, and routing needed for Cloud Run-to-Cloud SQL connectivity baseline and optional GKE path.  
Output: Network module with outputs for downstream modules.  
Done when: Network resources apply cleanly and are consumable by runtime/DB modules.

### P5-T04: Implement Cloud Run API module (baseline runtime)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Affected repos: `platform-infra`, `backend-api`
Status: Completed (`2026-04-22`)  
Evidence: `platform-infra` PR #28 (`Implement P5-T04 Cloud Run API baseline`), with archived OpenSpec change `2026-04-22-p5-t04-cloudrun-api-baseline-runtime`. Validated with `make terraform-validate`, `make terraform-plan ENV=rc`, `make terraform-plan ENV=prod`, an RC Cloud Run/secrets-enabled plan, and `openspec validate --specs --strict`.  
Action: Provision Cloud Run service module for API with revision settings, min/max instances, concurrency, service account/IAM, secret/env wiring, and Cloud SQL connectivity settings for `rc`/`prod`.  
Output: Cloud Run API module and environment bindings.  
Done when: RC API service can be planned/applied and deployed with healthy revisions in Cloud Run.

### P5-T05: Implement GAR module and IAM bindings
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Affected repos: `platform-infra`, `org-dot-github`, `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`
Status: Completed (`2026-04-22`)  
Evidence: `platform-infra` PR #29 (`Implement P5-T05 GAR module IAM bindings`), with archived OpenSpec change `2026-04-22-p5-t05-gar-module-iam-bindings`. Validated with `terraform fmt -recursive`, `make terraform-validate`, `make terraform-plan ENV=rc`, `make terraform-plan ENV=prod`, GAR-enabled plans for both environment roots, and `openspec validate --specs --strict`.  
Action: Provision GAR repos and roles for CI push and runtime pull principals.  
Output: Artifact registry resources and IAM policies.  
Done when: CI can push and Cloud Run runtime (and optional GKE runtime) can pull images.

### P5-T06: Implement Cloud SQL PostgreSQL module
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Affected repos: `platform-infra`, `backend-api`
Status: Completed (`2026-04-23`)
Evidence: `platform-infra` PR #30 (`Add Cloud SQL Postgres baseline`) and `backend-api` PR #43 (`Add Cloud SQL split database config`). OpenSpec change archived as `2026-04-23-p5-t06-cloudsql-postgres-module`. Validated with `make terraform-validate`, `openspec validate --specs --strict`, `openspec validate --changes --strict`, `make lint`, `make test`, `make format-check`, and passing backend CI checks including Sonar.
Action: Provision instance, backups, maintenance window, private networking, application database/user baseline, and DB/IAM auth baseline. Define the API database credential contract so Terraform creates or references only a password secret placeholder, never a committed full connection string with embedded credentials. The backend runtime must build its database connection string from non-secret inputs (`DB_HOST` or Cloud SQL socket path, `DB_NAME`, `DB_USER`) plus a secret-backed `DB_PASSWORD`.  
Output: Managed Postgres infrastructure and API database credential contract.  
Done when: API connectivity path from selected runtime (Cloud Run baseline, optional GKE) to DB is validated using a password sourced from Secret Manager rather than a plaintext or placeholder password in Terraform environment values.

### P5-T07: Implement GSM + IAM + ESO integration resources
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01  
Affected repos: `platform-infra`, `backend-api`, `backend-worker`, `platform-ai-workers`
Status: Completed (`2026-04-24`)
Evidence: `implementation/governance/p5-t07-runtime-secret-delivery-evidence.md`, archived OpenSpec change `2026-04-24-implement-p5-t07-gsm-iam-eso-integration-resources`, and validation via `make terraform-validate`, `make test`, `make lint`, `make format-check`, and `go test ./...` across the touched repos.
Action: Provision secret placeholders and access bindings for runtimes; include Cloud Run direct secret access baseline and ESO/workload identity permissions for optional GKE/controller/workloads. For the backend API database credential, store only the database password in Secret Manager (for example an environment-scoped `api-db-password` secret) and grant the selected API runtime access to that password secret; do not store the full `DATABASE_URL` as the canonical secret unless a later ADR explicitly changes this decision.  
Output: Secret management infrastructure baseline, including password-only API database secret delivery.  
Done when: Cloud Run API can read expected secrets directly, including `DB_PASSWORD`, the backend can construct its DB connection string from secret and non-secret parts, and GKE path can retrieve expected secrets via ESO sync when enabled.

### P5-T08: Implement Cloud Run Jobs + Scheduler module for AI workers
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T01, P5-T05, P5-T07  
Affected repos: `platform-infra`, `platform-ai-workers`, `org-dot-github`
Status: Deferred to Phase 10 (`P10-T06`).  
Action: Moved out of the core Terraform baseline so Phase 5 can focus on the frontend/API infrastructure needed for the platform MVP path.  
Output: Deferral linkage to `P10-T06`.  
Done when: Phase 5 does not depend on AI-worker runtime infrastructure.

### P5-T09: Build environment stacks (`rc`, `prod`)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03..P5-T07  
Affected repos: `platform-infra`
Status: Completed (`2026-04-24`)
Evidence: `platform-infra` PR #31 (`Add deployment presets for Terraform environments`), `implementation/governance/deployment-preset-environment-evidence.md`, and validation via `make terraform-validate`.
Action: Create per-environment root stack composition and parameter files with minimal drift, while enforcing prod full separation and RC internal isolation boundaries; keep environment selection explicit by root path, not Terraform workspace; derive runtime/module activation from deployment presets so roots choose topology through `deployment_preset` + `deployment_enabled`; keep Cloud Run as the managed baseline, GKE gated until explicitly enabled, and allow a single-VPS preset for low-scale environments.
Output: Environment-specific IaC layers.  
Done when: `terraform plan` works for all environments from their dedicated root paths.

### P5-T09A: Implement Grafana dashboard provisioning module and env wiring
Owner: Agent  
Type: IaC coding  
Dependencies: P3-T01, P3-T06, P5-T01, P5-T09  
Affected repos: `platform-infra`
Status: Completed (`2026-04-25`)
Evidence: `platform-infra` PR #32 (`Add Grafana dashboard provisioning`) and follow-up PR #33 (`Fix stack plan-safe contracts`). Validated with `make terraform-validate`, `make terraform-plan ENV=rc`, and `make terraform-plan ENV=prod`, with both env-root plans showing the Grafana folder and baseline dashboard resources sourced from `docs/grafana-dashboards/*.json`.
Action: Add `platform-infra` observability support for authoritative Grafana dashboard provisioning using the scoped Grafana API token and stack inputs established earlier in Phase 3. Define provider and module wiring for Grafana folders and baseline dashboards, and ensure the env roots consume the source-controlled dashboard definitions prepared by `P3-T06` from `../platform-infra/docs/grafana-dashboards/manifest.json`, `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`, `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`, and `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json` without manual UI re-authoring.  
Output: Grafana dashboard provisioning module and environment bindings.  
Done when: `terraform plan` from each env root shows Grafana folder and dashboard resources that recreate the baseline dashboards from the prepared source-controlled definitions.

### P5-T10: Add IaC policy checks and formatting in CI
Owner: Agent  
Type: CI/IaC  
Dependencies: P5-T01, P5-T09A  
Affected repos: `platform-infra`, `org-dot-github`
Status: Completed (`2026-04-25`)
Evidence: `implementation/governance/p5-t10-iac-ci-policy-evidence.md`, `platform-infra` CI workflow updates, and shared `org-dot-github` reusable infra workflow updates. Validated with `make repo-format-check`, `make repo-lint`, `make terraform-validate`, and `make repo-policy-check`.
Action: Add formatting, validation, static analysis, and policy checks to PR pipelines, including checks that cover Grafana dashboard provisioning assets and their Terraform wiring once the dashboard module exists.  
Output: Infrastructure quality gates.  
Done when: Invalid infra changes are blocked in CI before apply.

### P5-T10A: Implement `rc` Terraform apply workflow through CI
Owner: Human + Agent  
Type: CI/IaC deployment automation  
Dependencies: P5-T02, P5-T09, P5-T10  
Affected repos: `platform-infra`, `org-dot-github`
Action: Implement a dedicated CI workflow that runs Terraform apply for the `rc` environment from the `platform-infra` repository using the shared remote state backend, workload identity/OIDC authentication, explicit root-path targeting, plan visibility, and concurrency protection. The workflow must define the trigger model for `rc` apply (for example merge to `main`, manual approval, or approved workflow dispatch), ensure `terraform plan` output is preserved or surfaced before apply, use the shared lock timeout convention, and prevent accidental prod execution from the same path. Document the operational contract, including who can trigger the workflow, what branch/event gates it, rollback expectations, and how it interacts with follow-up verification/runbook tasks.
Output: CI-managed `rc` Terraform apply workflow and operator guidance.  
Done when: A reviewed change merged to the approved branch or an approved dispatch can run `terraform apply` for `environments/rc` from CI against shared remote state, with authenticated least-privilege access, visible plan/apply logs, and protections that prevent `prod` apply from the `rc` workflow.

### P5-T11: Execute `rc` clean-state apply and document runbook
Owner: Human + Agent  
Type: Validation  
Dependencies: P5-T01..P5-T10, P5-T10A, P5-T09A, P5-T15, P5-T15A  
Affected repos: `platform-infra`
Action: Apply full stack from empty state, including authoritative Grafana dashboard provisioning where configured, and capture timings, rollback instructions, and known caveats.  
Output: Provisioning evidence and runbook.  
Done when: `rc` can be recreated from scratch reproducibly, including restoration of the baseline Grafana dashboards from source-controlled definitions.

### P5-T12: Implement prod cluster lifecycle runbooks and guarded workflows
Owner: Human + Agent  
Type: IaC operations design  
Dependencies: P5-T09, P5-T10, P5-T13  
Affected repos: `platform-infra`
Action: Define and implement guarded Terraform workflow paths for prod cluster `create`, `destroy`, and `recover` operations (explicit enable flags, approval gates, plan visibility, and state protections), and document procedures per `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.  
Output: `docs/operations/create-prod-cluster.md`, `docs/operations/destroy-prod-cluster.md`, and `docs/operations/recover-prod-cluster.md`.  
Done when: Operators can run controlled create/destroy/recover flows for prod cluster without manual infrastructure drift.

### P5-T13: Implement optional GKE Autopilot module (deferred runtime path)
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T03  
Affected repos: `platform-infra`
Action: Provision Autopilot cluster module with workload identity config and baseline node/network policies, but keep module disabled by default in env stacks; include explicit enable flags and safe defaults for later activation.  
Output: Optional GKE cluster module and gated environment bindings.  
Done when: GKE cluster can be enabled/disabled by configuration without restructuring Terraform roots.

### P5-T14: Implement API runtime switch controls and migration runbook
Owner: Human + Agent  
Type: IaC operations design  
Dependencies: P5-T04, P5-T09, P5-T13  
Affected repos: `platform-infra`, `backend-api`
Action: Define and document a reversible runtime switch procedure (Cloud Run baseline <-> GKE optional) covering Terraform toggles, routing changes, secret wiring differences, observability mode switch, and validation checkpoints.  
Output: `docs/operations/api-runtime-switch-runbook.md`.  
Done when: Team can enable/disable either API runtime path with documented steps and no manual infrastructure drift.

### P5-T15: Provision Cloud Run edge routing resources for `/api/*`
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T04, P5-T05, P5-T09  
Affected repos: `platform-infra`, `frontend-web`, `backend-api`
Action: Implement Terraform resources required to route single-domain `/api/*` traffic to Cloud Run API baseline path (for example serverless NEG/backend wiring, URL map/path matcher integration, TLS/certificate references as applicable). Keep configuration compatible with later runtime switch to GKE backend path.  
Output: Runtime-routing infrastructure definitions for Cloud Run API path.  
Done when: RC environment can route `/api/*` requests to Cloud Run API through IaC-managed configuration.

### P5-T15A: Provision frontend runtime infrastructure for RC and gated prod delivery
Owner: Agent  
Type: IaC coding  
Dependencies: P5-T05, P5-T09, P5-T15  
Affected repos: `platform-infra`, `frontend-web`, `org-dot-github`
Action: Implement Terraform resources for the authenticated frontend runtime split: provision a Cloud Run frontend path for `rc` with service account, runtime configuration, image contract, and same-domain routing compatibility; also define the prod authenticated frontend static delivery path using Cloud CDN + External HTTPS Load Balancer + Cloud Storage backend bucket. Keep prod frontend resources disabled/gated by default so the infrastructure shape exists without enabling prod traffic or unnecessary baseline spend before the intentional prod rollout phase.
Output: Frontend runtime infrastructure definitions for Cloud Run (`rc`) and gated CDN/static delivery (`prod`).
Done when: `rc` frontend can be planned/applied as a Cloud Run service, the prod CDN/static path can be planned behind explicit enable flags, and both paths remain compatible with single-domain `/api/*` backend routing.

### P5-T16: Build environment suspend/resume cost-control tool
Owner: Human + Agent  
Type: IaC operations automation  
Dependencies: P5-T04, P5-T05, P5-T06, P5-T09  
Affected repos: `platform-infra`
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
- password-only API database secret contract and runtime env wiring
- `../backend-api/docs/api-runtime-paths-cloud-run-gke.md` runtime selection reference
- `ops/ephemeral-gke-cluster-lifecycle-requirements.md` conformance mapping
- `ops/cost-suspend-resume-automation.md` suspend/resume contract
- API runtime switch runbook
- suspend/resume tooling and runbook
- Cloud Run `/api/*` routing infrastructure definitions
- frontend runtime infrastructure definitions for `rc` Cloud Run and gated `prod` CDN/static delivery
- environment variable files and outputs
- IaC CI validation checks
- `rc` Terraform apply CI workflow and trigger/approval contract
- `rc` apply evidence and infra runbook
- Grafana dashboard recreate-from-source evidence
