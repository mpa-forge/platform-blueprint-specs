# Implementation Plan

## 1. Delivery Principles
- Build the platform first, then product features.
- Keep every phase deployable and testable.
- Prefer incremental hardening over premature complexity.
- Complete one minimal end-to-end implementation (with near-zero business logic) as a reusable blueprint for future projects.

## 2. Phased Roadmap
- Phase 0: `implementation/phases/phase-0-foundation-and-decisions.md`
- Phase 1: `implementation/phases/phase-1-repository-and-local-development-baseline.md`
- Phase 2: `implementation/phases/phase-2-contracts-service-skeletons-and-data-baseline.md`
- Phase 3: `implementation/phases/phase-3-observability-and-operability-baseline.md`
- Phase 4: `implementation/phases/phase-4-ci-pipeline.md`
- Phase 5: `implementation/phases/phase-5-terraform-infrastructure.md`
- Phase 6: `implementation/phases/phase-6-kubernetes-and-helm-deployment.md`
- Phase 7: `implementation/phases/phase-7-cd-release-and-rollback-controls.md`
- Phase 8: `implementation/phases/phase-8-scalability-reliability-and-security-hardening.md`
- Phase 9: `implementation/phases/phase-9-backend-worker-and-async-extensions.md`
- Milestone quick reference: `implementation/milestone-quick-reference.md`

### 2.1 Phase Task Packs
- Phase 0 tasks: `implementation/phase-tasks/phase-0-foundation-and-decisions-tasks.md`
- Phase 1 tasks: `implementation/phase-tasks/phase-1-repository-and-local-development-baseline-tasks.md`
- Phase 2 tasks: `implementation/phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`
- Phase 3 tasks: `implementation/phase-tasks/phase-3-observability-and-operability-baseline-tasks.md`
- Phase 4 tasks: `implementation/phase-tasks/phase-4-ci-pipeline-tasks.md`
- Phase 5 tasks: `implementation/phase-tasks/phase-5-terraform-infrastructure-tasks.md`
- Phase 6 tasks: `implementation/phase-tasks/phase-6-kubernetes-and-helm-deployment-tasks.md`
- Phase 7 tasks: `implementation/phase-tasks/phase-7-cd-release-and-rollback-controls-tasks.md`
- Phase 8 tasks: `implementation/phase-tasks/phase-8-scalability-reliability-and-security-hardening-tasks.md`
- Phase 9 tasks: `implementation/phase-tasks/phase-9-backend-worker-and-async-extensions-tasks.md`

## 3. Baseline MVP Definition (Template Build)

Objective:
- Deliver a fully operational platform slice from commit to running workloads, with minimal domain logic, so it can be reused as a blueprint.

Target repositories (polyrepo):
- `platform-contracts`: protobuf APIs, Buf config, generated artifact policy, and versioned TypeScript client package publishing to GitHub Packages.
- `backend-api`: Go API service (`net/http` + `connect-go`) with Clerk token validation and Cloud SQL connectivity.
- `backend-worker`: Go worker service reserved for deferred async/background additions after the frontend + API baseline is proven end to end.
- `platform-ai-workers`: AI task-to-code worker runtime (Cloud Run Jobs with event-driven wake-ups and optional scheduler backstop) that converts GitHub tasks into PRs with human review gates.
- `frontend-web`: authenticated React app using generated TypeScript client from protobuf contracts.
- `platform-infra`: Terraform + GitHub Actions deployment workflows for preset-driven environment assembly, with Cloud Run as the managed baseline, optional GKE path, and a single-VPS preset for low-scale environments.
- dedicated docs repository: ADRs, platform standards, runbooks, and cross-repo operational documentation.
- code documentation standard: `common/standards/code-documentation.md` defines comment/doc expectations for repos as code-bearing phases start.

Minimum functional scope (no business logic):
- Frontend:
  - Authenticated shell app with login/logout flow through Clerk.
  - One protected page that calls one protected API endpoint using generated client code.
- API:
  - `GET /healthz` and `GET /readyz`.
  - One protected Connect/proto endpoint that returns deterministic placeholder data from Postgres.
  - JWT verification middleware with role check (`user` and `admin` baseline claim mapping).
- Database:
  - One migration creating a minimal table.
  - One seed script inserting deterministic sample records.
- Contracts:
  - One service, one unary RPC, request/response messages versioned under `v1`.

Pipeline and deployment path (must be proven end-to-end):
- Commit/PR:
  - lint, unit tests, `buf lint`, `buf breaking`, generated-code drift check.
- Merge to `main`:
  - Build containers, scan, push immutable image tags to GAR.
  - Deploy frontend to Cloud Run in `rc`.
  - Deploy API to Cloud Run in `rc` (baseline path).
  - Keep optional GKE/Helm deployment path runnable but disabled by default.
  - For later gated `prod`, publish frontend build to CDN origin bucket/path and invalidate changed assets.
- Post-deploy:
  - Smoke test: authenticated frontend -> protected API -> DB read.
  - Smoke test: trace/log/metric visibility in Grafana Cloud.
  - Prod promotion gate: require passing baseline blockers (API health/readiness, authenticated protected API path, DB read path, deployed version match).

Required platform integrations in MVP:
- Auth: Clerk (B2C, free plan) wired in frontend and API.
- Secrets:
  - Cloud Run baseline path: GSM secret integration for runtime envs.
  - GKE path: GSM + ESO for runtime secret sync.
- Data: Cloud SQL Postgres connectivity from Cloud Run baseline runtime (and from GKE when enabled).
- Observability: Grafana Cloud Free (metrics/logs/traces + alert) in baseline MVP.
- Deferred observability providers: Sentry Developer (Free) and incident.io Basic (Free) in Phase 8 hardening.
- CD:
  - baseline path: GitHub Actions pipeline-driven deploy to Cloud Run.
  - optional path: GitHub Actions + Helm for GKE.

Acceptance checklist (Definition of Done for baseline):
- Local:
- The local development stack uses centralized Compose definitions in `platform-infra` with a hybrid model:
  - frontend development runs frontend natively and Compose-provisions API + Postgres
  - API development runs API natively and Compose-provisions frontend + Postgres
  - workers stay out of the default frontend/API development path initially
  - Local authenticated flow reaches protected API endpoint.
- Cloud RC:
  - Terraform provisions/updates required infrastructure from clean state.
  - API deploys successfully to Cloud Run with revisioned rollout.
  - Frontend is served through Cloud Run in `rc` and can call RC API through single-domain `/api/*` routing.
  - RC isolation boundaries are enforced: separate databases (or DB names), secrets, and domains; namespace boundaries apply when GKE path is enabled.
- Operability:
  - Dashboard exists with API latency and error rate.
  - At least 3 actionable alerts configured and tested.
  - One synthetic alert triggers the alert -> AI workflow and produces an incident summary artifact.
- Security/governance:
  - No plaintext secrets in repos.
  - CI uses Workload Identity Federation (no static cloud keys).
  - Branch protection enforces required checks.
- Reusability:
  - `README` + runbook documents exact bootstrap steps for a new project using this template.
  - Repo templates/boilerplates are tagged with a baseline release.

Out of scope until baseline completion:
- Product/domain-specific business workflows.
- Queue/broker implementation and async delivery semantics.
- Public website/blog implementation path.

### 3.1 Fast-Track AI Automation Bootstrap
- Priority intent:
  - Implement minimal AI task-to-code automation as early as possible to accelerate execution of later phase tasks while preserving merge control.
- Delivery order:
  - Phase 0: lock automation architecture, task state machine, and credential model.
- Phase 1: bootstrap `platform-ai-workers` repo and validate one end-to-end task -> PR flow in a sandbox repo.
  - Phase 5 (minimal subset pulled earlier as needed): provision Cloud Run Job + GSM/IAM bindings plus on-demand execute permissions for worker runtime (optional low-frequency scheduler backstop).
  - Phase 4: enforce governance checks for AI-generated PRs (required review/checks/metadata) and event-trigger workflows for immediate rework runs.
- Guardrails:
- PR only, no direct protected-branch writes.
  - Required human review and existing CI checks remain mandatory.
- Human review feedback should trigger rework on the same PR branch by default.
  - Worker lanes are configured per target repo using environment variables and least-privilege credentials.

### 3.2 Later-Phase AI Ops Automation
- Objective:
  - Automate alert-driven diagnostics and remediation task creation from production telemetry signals.
- Delivery target:
  - Phase 8 hardening (after baseline observability and task workflow are stable).
- Core flow:
  - Grafana Cloud / Prometheus-style alert triggers diagnostic worker lanes.
  - Workers use MCP-integrated access to metrics, logs, and traces for bounded diagnosis.
  - Validated outputs create GitHub Issues/Project tasks with evidence links and suggested priority labels.
- Governance:
  - Keep human approval for high-impact actions; task creation is automated, code changes still follow PR review controls.

## 4. Workstreams (Parallel)
- App Platform: frontend/api skeletons first; backend-worker deferred to Phase 9.
- Infrastructure: Terraform foundations (Cloud Run baseline, optional GKE path).
- Quality & Security: CI, scans, policies.
- Operations: observability, runbooks, alerts.

## 5. Decision Log Template
For each decision capture:
- Context
- Options considered
- Decision
- Consequences
- Review date

## 6. Risks & Mitigations
- Over-engineering early:
  - Mitigation: strict phase exit criteria.
- Tooling complexity:
  - Mitigation: prefer managed services first.
- Slow feedback loops in CI/CD:
  - Mitigation: cache dependencies, parallel jobs.
- Environment drift:
  - Mitigation: immutable infra through Terraform + Helm values discipline.

## 7. Immediate Next Iteration
- Define Clerk application/instance configuration for local, RC, and prod environments.
- Define Grafana Cloud org/stack setup and telemetry credentials for local, RC, and prod.
- Define a single observability ingestion control (`OBS_TELEMETRY_PROFILE`) and implement dual-mode mappings for traces/logs/metrics (`balanced`/`cost`/`debug`) across Cloud Run direct OTLP and GKE collector paths with one shared observability library contract.
- Specification artifact for dual-mode observability budget control: `ops/observability-telemetry-budget-profile.md`.
- Keep Sentry and incident.io provider setup deferred until Phase 8 hardening.
- Define GitHub Actions environments/secrets and GCP Workload Identity Federation for CI auth.
- Define GitHub Issues/Projects task-management workflow baseline (issue templates, labels, board states, automation) across repos.
- Define and codify CI code-quality/security tooling standards (`golangci-lint`, `eslint`, `tsc`, `sonar`/`SonarQube Cloud`, `trivy`, `gitleaks`, `semgrep/codeql`, IaC checks) with swap criteria.
  - Lock SonarQube Cloud Free as baseline tier.
- Define and bootstrap `platform-ai-workers` repo with task-state machine and PR flow (`ai:ready` -> `ai:in-progress` -> `ai:ready-for-review`).
- Build shared backend observability library package supporting `direct_otlp` (Cloud Run) and `collector_gateway` (GKE) modes with one `OBS_TELEMETRY_PROFILE` contract.
- Provision minimal AI worker runtime prerequisites early (Cloud Run Job + GSM/IAM + on-demand execute permissions; optional scheduler backstop) to enable task-to-code automation before full platform completion.
- Define per-target-repo worker deployment config model (`WORKER_RUNTIME_MODE`, `WORKER_ID`, `TARGET_REPO`, limits, credential refs).
- Define shared poll-loop behavior (ready tasks + rework tasks + outstanding-review cap) with mode-specific lifecycle: local keeps polling; cloud exits on cap/idle and is re-woken by GitHub events.
- Define event-trigger rules for cloud wake-up runs (`ai:ready`, PR `changes requested`, `/ai rework`) and idempotent rework behavior tied to review/comment ids.
- Enforce local/cloud runtime parity for AI workers (same image + runtime entrypoint) and validate with local dry-run plus Cloud Run execution using equivalent inputs.
  - Specification artifact: `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`.
- Define Cloud SQL instance topology and connectivity model for RC/prod.
- Lock API runtime baseline to Cloud Run for first iteration and defer initial GKE cluster creation until needed.
- Keep Terraform modules for both API runtimes (Cloud Run baseline enabled; GKE module available but disabled by default).
  - Specification artifact: `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`.
- Define and implement ephemeral prod cluster lifecycle requirements (create/destroy/recover) to control cost while keeping prod fully separate.
  - Specification artifact: `ops/ephemeral-gke-cluster-lifecycle-requirements.md`.
- Apply `us-east4` as the primary region baseline for RC/prod infrastructure components.
- Define RC isolation model implementation details (DB boundaries, secret scopes, and domain layout; namespace boundaries for GKE path).
- Define Google Secret Manager namespace/secret naming and ESO sync mappings for all services.
- Expand managed frontend delivery on top of the new preset layer, including Cloud Run or CDN/static presets where the frontend should be provisioned by Terraform instead of remaining colocated or external/manual.
- Keep public website/blog scope deferred until authenticated app baseline is complete.
- Keep queue/broker scope deferred until post-baseline feature implementation requires async messaging.
- Keep external edge-provider layering decision deferred (GCP-native edge only in baseline; evaluate Cloudflare-like overlay during hardening).
- Define proto package/versioning conventions and set up Buf generation pipeline.
  - Create `buf.yaml`, `buf.gen.yaml`, and conventions doc in contracts repo template.
  - Keep baseline workflow on Buf CLI in local/CI (no paid BSR dependency).
  - Define TypeScript contract package metadata (`name`, scope, versioning) and publish path to GitHub Packages.
- Define GitHub Packages npm auth model (`.npmrc` scoped registry, CI publish/install permissions) for contract package producer/consumers.
- Define webhook payload contract and auth scheme for alert-to-AI service.
  - Specification artifact: `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md`.
- Establish dedicated docs/ADR repository and migrate shared architecture decision records there.
- Standardize frontend tooling on `Bun` across repo templates and CI.
- Apply single-domain path-based `/api/*` routing and managed TLS certificate defaults in deployment design (Cloud Run backend baseline, ingress backend for GKE path).
- Scaffold repo folders and minimal service skeletons.
- Stand up local end-to-end via Docker Compose.

## 8. Living Change Log
- v0.1 (2026-02-17): Initial high-level phased implementation plan.
- v0.2 (2026-02-17): Applied locked decisions (GCP/GKE, polyrepo, NGINX ingress), deferred queue decision, and added auth milestones.
- v0.3 (2026-02-19): Locked Clerk Free plan for B2C-first auth and updated implementation tasks accordingly.
- v0.4 (2026-02-19): Locked Loki + Grafana and expanded observability implementation tasks for Prometheus operations.
- v0.5 (2026-02-19): Locked self-managed Prometheus and updated Phase 3 to Helm-based in-cluster deployment tasks.
- v0.6 (2026-02-19): Switched observability implementation to Grafana Cloud managed stack and added alert-to-AI automation tasks.
- v0.7 (2026-02-19): Added concrete Phase 3 Grafana Cloud setup checklist and alert webhook contract task.
- v0.8 (2026-02-19): Locked proto-first + Connect contract model and updated Phase 2/CI tasks for generated Go/TypeScript contract enforcement.
- v0.9 (2026-02-19): Added protobuf package/versioning implementation checklist aligned with Buf policies.
- v1.0 (2026-02-19): Locked Sentry + incident.io and added Phase 3 setup tasks for both integrations.
- v1.1 (2026-02-19): Locked GitHub Actions + Google Artifact Registry and updated CI/IaC tasks accordingly.
- v1.2 (2026-02-19): Locked GKE Autopilot mode and updated infrastructure tasks.
- v1.3 (2026-02-19): Locked Cloud SQL for PostgreSQL hosting and updated infrastructure planning tasks.
- v1.4 (2026-02-19): Locked Google Secret Manager + External Secrets Operator and updated infra/deployment tasks.
- v1.5 (2026-02-19): Locked CD operating model to pipeline-driven GitHub Actions + Helm deployment.
- v1.6 (2026-02-19): Added dual frontend delivery options and implementation checkpoints for public site and authenticated app paths.
- v1.7 (2026-02-19): Locked frontend sequencing to authenticated app first and prioritized production static delivery for the authenticated frontend.
- v1.8 (2026-02-20): Confirmed blueprint-first strategy (minimal end-to-end implementation before business logic) and deferred queue decision until post-baseline completion.
- v1.9 (2026-02-20): Added concrete Baseline MVP Definition checklist (repos, minimal scope, CI/CD flow, integrations, and acceptance criteria).
- v2.0 (2026-02-20): Split phased roadmap into separate files under `implementation/phases/` and converted this file into the index entrypoint.
- v2.1 (2026-02-20): Added detailed per-phase task packs with agent/human ownership, dependencies, outputs, and done criteria; phase files now include open questions/choices.
- v2.2 (2026-02-20): Locked non-local environment model to RC + prod, updated promotion flow assumptions, and added explicit RC isolation boundary requirements.
- v2.3 (2026-02-20): Locked primary GCP region baseline to `us-east4` for RC and prod and aligned immediate implementation tasks.
- v2.4 (2026-02-20): Applied additional locked decisions (single owner, dedicated docs repo, dedicated worker repo, npm, committed generated artifacts, reusable workflows, separate RC/prod projects, path-based ingress, managed TLS, on-demand prod deploys, forward-fix rollback, deferred deploy-time signature verification).
- v2.5 (2026-02-20): Locked local environment baseline to minimal stack only (frontend, API, worker, Postgres), excluding local observability components by default.
- v2.6 (2026-02-20): Locked baseline auth model to direct SPA bearer tokens (no BFF token handling in baseline phase).
- v2.7 (2026-02-20): Locked typed DB access approach to `sqlc` + handwritten SQL with `pgx` runtime.
- v2.8 (2026-02-20): Locked observability telemetry routing to cluster-level collector gateway (Grafana Alloy / OTel Collector) before export to Grafana Cloud.
- v2.9 (2026-02-20): Locked initial trace sampling policy (`rc` 25%, `prod` 5%) with force-sampling for error/high-latency/debug traces.
- v2.10 (2026-02-20): Locked alert incident severity policy (`P1` auto-open, `P2/P3/P4` notify-only, unacknowledged `P2` escalates after 15 minutes).
- v2.11 (2026-02-20): Locked CI vulnerability merge-gate policy (block `Critical`; block runtime `High` when fix exists; notify-only for non-blocking classes with time-boxed waivers).
- v2.12 (2026-02-20): Locked PR CI runtime SLO baseline (`p50 <= 10 min`, `p95 <= 15 min`, hard cap `20 min` for required checks).
- v2.13 (2026-02-20): Locked Terraform remote state/locking pattern on GCS (dedicated state project, per-env buckets, prefix convention, bucket safeguards, lock-timeout).
- v2.14 (2026-02-20): Locked Terraform environment structure to separate roots per env (`rc`, `prod`) with shared modules; no workspace-based env switching.
- v2.15 (2026-02-20): Locked authenticated frontend production delivery to Cloud CDN + External HTTPS Load Balancer + Cloud Storage, with single-domain `/api/*` routing to backend ingress.
- v2.43 (2026-04-23): Split authenticated frontend runtime by environment: Cloud Run frontend in `rc`, gated Cloud CDN + External HTTPS Load Balancer + Cloud Storage in `prod`.
- v2.16 (2026-02-21): Locked baseline mandatory smoke-test blockers for prod promotion and aligned Phase 7 gating criteria.
- v2.17 (2026-02-21): Locked provisional baseline API SLO targets for RC/prod (availability and p95 latency) with a defined post-launch recalibration checkpoint.
- v2.18 (2026-02-21): Locked baseline secret rotation cadence/policy for RC and prod, including emergency rotation SLA, rollback window, and prod approval governance.
- v2.19 (2026-02-22): Locked task management baseline to GitHub Issues + GitHub Projects with a standardized cross-repo workflow model.
- v2.20 (2026-02-22): Added fast-track AI task-to-code automation bootstrap plan (dedicated worker repo, early Cloud Run Job/Scheduler prerequisites, per-repo worker lanes, and review governance).
- v2.21 (2026-02-22): Added later-phase AI Ops automation plan for alert-driven diagnostics using MCP-integrated telemetry access and automatic remediation task generation.
- v2.22 (2026-02-22): Added explicit CI code-quality/security tooling integration plan with approved alternatives and migration criteria.
- v2.23 (2026-02-22): Added Sonar (`SonarCloud` free-tier path where eligible) to the CI quality baseline and near-term rollout tasks.
- v2.24 (2026-02-22): Added hybrid AI worker trigger model (scheduled + event-driven) and review-feedback rework workflow requirements.
- v2.25 (2026-02-28): Locked contracts workflow to Buf CLI-only in local/CI with no paid BSR dependency for baseline.
- v2.26 (2026-02-28): Locked baseline provider tiers to free plans for Grafana Cloud, Sentry, incident.io, and SonarQube Cloud.
- v2.27 (2026-02-28): Added a single telemetry budget profile control (`OBS_TELEMETRY_PROFILE`) for adjustable trace/log/metric ingestion under tier limits.
- v2.28 (2026-02-28): Added observability ops specification artifact `ops/observability-telemetry-budget-profile.md` and linked Phase 3 implementation references.
- v2.29 (2026-02-28): Locked `platform-contracts` TypeScript client package publishing to GitHub Packages and added producer/consumer setup tasks.
- v2.30 (2026-02-28): Added GKE credit guardrail to keep one active Autopilot cluster during baseline and defer prod cluster provisioning until production cutover.
- v2.31 (2026-02-28): Added ephemeral prod cluster lifecycle requirements artifact and linked Phase 5/6 create-destroy-recover validation tasks.
- v2.32 (2026-02-28): Deferred external edge-provider layering decision to hardening phase while keeping baseline internet edge path GCP-native.
- v2.33 (2026-02-28): Added AI worker local/cloud runtime parity requirement and linked implementation artifact `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`.
- v2.34 (2026-02-28): Locked AI worker shared poll-loop runtime model (local continuous polling, cloud bounded wake-up runs with optional scheduler backstop).
- v2.35 (2026-03-01): Switched first-iteration API deployment baseline to Cloud Run and deferred initial GKE cluster creation to an optional later path.
- v2.36 (2026-03-01): Added dual-runtime observability implementation model and shared observability library requirement for Cloud Run direct OTLP and GKE collector modes.
- v2.37 (2026-03-04): Deferred Sentry and incident.io integration from early phases to Phase 8 hardening; Phase 0/3 now baseline on Grafana Cloud only.
- v2.38 (2026-03-07): Locked Phase 1 local development to a hybrid stack model with centralized Compose in `platform-infra`, native active-service development, and workers excluded from the default frontend/API local flow.
- v2.39 (2026-03-08): Added a late-phase optional single-VM deployment path task for cost-sensitive or low-scale projects, to be implemented only after the primary runtime path is running and tested.
- v2.40 (2026-03-22): Deferred `backend-worker` implementation and worker-specific deploy/observability/hardening work to new Phase 9 so the blueprint proves the frontend + backend API path end to end first.
- v2.41 (2026-03-29): Switched the frontend tooling baseline from npm to Bun and added Vitest, Playwright, and Zustand to the frontend stack baseline.
- v2.42 (2026-04-04): Added Phase 3 frontend observability tasks for a shared browser observability package/module plus `frontend-web` consumption.
- v2.44 (2026-04-24): Documented preset-driven Terraform environment assembly with committed `platform-infra` defaults of `rc=single-vps` and `prod=cloudrun-cloudsql`.
