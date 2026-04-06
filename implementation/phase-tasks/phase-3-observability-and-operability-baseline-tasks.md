# Phase 3 Tasks: Observability & Operability Baseline

## Goal
Deliver production-grade visibility and incident wiring for the baseline stack with minimal operational blind spots.

## Tasks

### P3-T01: Provision Grafana Cloud stack and service accounts
Owner: Human  
Type: Provider configuration  
Dependencies: Phase 0 accounts  
Status: Completed (`2026-04-04`) for `rc` baseline scope; prod OTLP ingest secret in GSM is deferred until prod activation.
Evidence: `implementation/governance/provider-account-inventory.md`
Action: Create Grafana Cloud Free stack(s), define env labeling strategy, create scoped API tokens for metrics/logs/traces/alerts, and document free-tier limits/watchpoints. For the baseline phase, `rc` inventory and token readiness are required; prod ingest policy may exist ahead of time, but the prod GSM secret may remain deferred until prod activation.
Output: Provider credentials inventory.  
Done when: All required Grafana endpoints and tokens are available for `rc` integration, alert and rules read access is documented, and any prod OTLP ingest secret deferral is explicit in the provider inventory.

### P3-T02: Store observability credentials in GSM and wire runtime-specific delivery
Owner: Agent  
Type: Infra/config  
Dependencies: P3-T01, Phase 5 baseline GSM availability (plus ESO when GKE path is enabled) or temporary local secret strategy  
Status: Open. The token-ingredient runtime contract, Cloud Run delivery model, and GKE ESO placeholders are documented, but the task stays open until Phase 5 introduces deployable Terraform roots that can own the real Cloud Run/GSM wiring.
Evidence in progress: `implementation/governance/observability-secret-delivery-evidence.md`
Action: Create secret definitions for Grafana Cloud OTLP/auth credentials and wire runtime-specific delivery:
- Cloud Run baseline path: direct GSM-based secret injection for API runtime envs using the token-ingredient contract (`OTEL_EXPORTER_OTLP_ENDPOINT`, `GRAFANA_CLOUD_INSTANCE_ID`, `GRAFANA_OTLP_INGEST_TOKEN`) with header composition inside the shared runtime.
- GKE path: ESO sync manifests for API/collector components. Backend-worker secret delivery is deferred to Phase 9.  
Output: Secrets wired into workloads without plaintext in repo.  
Done when: Services read credentials through their selected runtime path without plaintext credentials in repo. Pre-Phase-5 repo work may document the exact Cloud Run delivery contract plus GKE ESO placeholders without inventing undeployed Terraform roots, but final completion waits for Phase 5 Terraform roots and workload wiring.

### P3-T03: Instrument API with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 API ready, P2-T13  
Action: Implement/consume a shared observability library package for backend services and instrument API with traces/metrics/logs context propagation, semantic resource attributes, error status mapping, and runtime-mode support (`direct_otlp`, `collector_gateway`) controlled by config.  
Output: API telemetry instrumentation.  
Done when: API requests produce correlated traces and metrics in Grafana Cloud.

### P3-T03A: Scaffold shared frontend observability package
Owner: Agent
Type: Coding
Dependencies: Phase 2 frontend ready, P3-T01
Status: Completed (`2026-04-06`)
Evidence: `implementation/governance/frontend-observability-package-evidence.md`
Action: Create a reusable frontend observability package/module for browser apps with:
- initialization API for browser telemetry wiring
- shared labeling contract for app/environment/release/user context
- hook points for page-view tracking, client-side errors, and Web Vitals or equivalent UX signals
- trace/correlation helpers so protected frontend flows can be tied back to backend request telemetry
- environment-based enable/disable and ingest-config hook points without hardcoding provider secrets in repo
Output: Shared frontend observability package/module and integration contract docs.
Done when: The shared frontend package compiles, exposes one stable initialization path, and is ready to be consumed by `frontend-web`.

### P3-T03B: Consume shared frontend observability package in `frontend-web`
Owner: Agent
Type: Coding
Dependencies: P3-T03A, P3-T01, Phase 2 frontend ready
Action: Integrate the shared frontend observability package in `frontend-web` so the authenticated app shell emits baseline browser telemetry, client-side errors, and frontend-to-backend correlation metadata for protected API flows.
Output: Frontend observability integration baseline.
Done when: `frontend-web` initializes browser observability through the shared package and one protected flow emits correlated frontend telemetry without bespoke wiring in page components.

### P3-T03C: Add browser telemetry ingest endpoint in `backend-api`
Owner: Agent
Type: Coding
Dependencies: P3-T03B, Phase 2 API ready
Action: Create a browser-safe telemetry ingest endpoint in `backend-api` that accepts the shared frontend observability event envelope emitted by `frontend-web` and `platform-frontend-observability`, then hands those events into the backend observability/export path without requiring browser-held secrets. Implement it using the existing API runtime and middleware patterns in `../backend-api/docs/api-runtime.md`, `../backend-api/openspec/specs/api-runtime/spec.md`, `../backend-api/openspec/specs/api-observability/spec.md`, `../backend-api/internal/api/runtime.go`, `../backend-api/internal/api/middleware.go`, `../backend-api/internal/api/runtime_test.go`, and `../backend-api/internal/api/observability_test.go`. Treat the sender contract in `../frontend-web/src/app/observability/runtime.ts` and `../platform-frontend-observability/src/runtime.ts` as the frontend event-shape reference until a dedicated ingest spec is added.
Output: Backend browser telemetry ingest endpoint, tests, and implementation notes.
Done when: The browser can POST the shared frontend observability event envelope to a documented `backend-api` endpoint with the required CORS behavior, the endpoint validates or normalizes the event payload without relying on frontend secrets, and the backend is ready to forward those accepted events into the Phase 3 Grafana delivery path.

### P3-T04: Instrument worker with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: P9-T01, P9-T02  
Status: Moved to Phase 9 (`P9-T03`).  
Action: Use the shared observability library in worker runtime to emit traces/metrics/logs for scheduled tasks, retries, and failures; include consistent service/resource labels and runtime-mode compatibility.  
Output: Worker telemetry instrumentation.  
Done when: Worker loop activity is visible in traces and dashboard metrics.

### P3-T05: Implement dual-mode telemetry pipeline (Cloud Run direct OTLP + GKE collector path)
Owner: Agent  
Type: Deployment/config  
Dependencies: P3-T01  
Action: Implement telemetry export and budget controls for both runtime modes:
- Cloud Run baseline path: direct OTLP/HTTP export config to Grafana Cloud for traces/metrics/logs via shared library.
- GKE alternative path: collector/alloy receivers/processors/exporters for OTLP traces, metrics scrape forwarding, and log shipping.
- Apply initial trace sampling policy (`rc` 25%, `prod` 5%) and force-sample rules for errors, high-latency traces (>1s initial threshold), and explicit debug/incident traffic.
- Add centralized `OBS_TELEMETRY_PROFILE` mapping (`balanced`/`cost`/`debug`) with equivalent profile behavior across both modes, aligned with `ops/observability-telemetry-budget-profile.md`.  
Output: Dual-mode telemetry config artifacts (library/runtime config + optional collector/alloy manifests) aligned with `ops/observability-telemetry-budget-profile.md`.  
Done when: Logs/metrics/traces arrive in Grafana Cloud with expected labels in Cloud Run direct mode and GKE collector mode, and profile controls can be changed without instrumentation code changes.

### P3-T06: Build baseline dashboards from code
Owner: Agent  
Type: Observability config  
Dependencies: P3-T03..P3-T05  
Action: Define dashboards for API golden signals, edge/runtime path status, and DB connectivity symptoms. Backend-worker dashboards are deferred to Phase 9.  
Output: Dashboard JSON/Terraform definitions.  
Done when: Dashboards can be recreated from source-controlled definitions.

### P3-T07: Configure alert rules and routing
Owner: Agent  
Type: Observability config  
Dependencies: P3-T06  
Action: Implement at least 3 actionable alerts (availability, latency, error rate), route to webhook/Slack channels, and apply baseline severity policy (`P1` immediate page/webhook; `P2/P3/P4` notify-only; escalate unacknowledged `P2` after 15 minutes).  
Output: Alert rules and routing policy docs.  
Done when: Synthetic trigger tests demonstrate expected routing behavior.

### P3-T08: Configure Sentry projects and SDK integration
Owner: Human + Agent  
Type: Provider config + coding  
Dependencies: Phase 2 services  
Status: Deferred to Phase 8 (`P8-T15`).  
Action: Defer Sentry provider setup until late-phase hardening after baseline infrastructure/deploy stabilization.  
Output: Deferral linkage to `P8-T15`.  
Done when: Phase 3 does not depend on Sentry provisioning.

### P3-T09: Configure incident.io workflow integration
Owner: Human + Agent  
Type: Provider config + integration  
Dependencies: P3-T07  
Status: Deferred to Phase 8 (`P8-T16`).  
Action: Defer incident.io workspace and routing integration until late-phase hardening.  
Output: Deferral linkage to `P8-T16`.  
Done when: Phase 3 does not depend on incident.io provisioning.

### P3-T10: Implement alert -> AI automation service contract and endpoint
Owner: Agent  
Type: Coding  
Dependencies: P3-T07  
Action: Build webhook endpoint with signature validation, parse payload, request enrichment data from Grafana APIs, and emit machine-readable diagnostic payloads that can be consumed by later-phase AI diagnostic/task-generation workers, following `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md`.  
Output: Automation service baseline running with deterministic output format and conformance notes to `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md`.  
Done when: Synthetic alert generates a structured AI-ready incident summary payload.

### P3-T11: Add enrichment integrations and evidence links
Owner: Agent  
Type: Coding  
Dependencies: P3-T10  
Action: Query metrics/logs/traces APIs for correlated context and include links in result payload.  
Output: Enriched incident summary artifacts.  
Done when: Output includes direct evidence links and bounded analysis window.

### P3-T12: Run synthetic observability E2E tests
Owner: Human  
Type: Validation  
Dependencies: P3-T01..P3-T07, P3-T10, P3-T11  
Action: Trigger synthetic load/errors and verify dashboard, alerts, webhook/Slack routing, and AI workflow output.  
Output: Test report and remediation list.  
Done when: All phase 3 exit criteria are objectively validated.

### P3-T13: Validate telemetry budget profile controls and runbook
Owner: Human + Agent  
Type: Validation + operations documentation  
Dependencies: P3-T05, P3-T06, P3-T12  
Action: Execute controlled toggles of `OBS_TELEMETRY_PROFILE` (`balanced` -> `cost` -> `balanced`, optional `debug` window) in both runtime modes, validate expected ingestion-volume changes for traces/logs/metrics, and document safe operating thresholds plus rollback steps for free-tier cap protection.  
Output: `docs/operations/telemetry-budget-profile-runbook.md`, validation evidence, and conformance notes to `ops/observability-telemetry-budget-profile.md`.  
Done when: Operators can adjust telemetry ingestion within one config change, observe impact in dashboards, and revert safely.

### P3-T14: Validate Cloud Run direct OTLP observability path
Owner: Human + Agent  
Type: Validation  
Dependencies: P3-T03, P3-T05, P5-T04  
Action: Validate end-to-end Cloud Run API telemetry export without a cluster collector: traces, metrics, and logs are exported via OTLP/HTTP to Grafana Cloud; verify resource labels, profile behavior, and correlation ids.  
Output: Cloud Run observability validation report with evidence links.  
Done when: Cloud Run API observability is fully operational with direct OTLP export and no dependency on in-cluster scraping/collector components.

## Artifacts Checklist
- Grafana Cloud stack/token inventory
- OTel instrumentation PRs for API
- shared frontend observability package/module evidence
- frontend observability integration evidence
- shared observability library configuration and usage evidence
- Cloud Run direct OTLP configuration evidence
- collector/alloy configs (GKE path)
- `OBS_TELEMETRY_PROFILE` mapping config and runbook
- `ops/observability-telemetry-budget-profile.md` conformance evidence
- dashboard definitions as code
- alert rules and routing policies
- `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md` implementation reference
- alert->AI webhook spec and service implementation
- synthetic observability validation report
