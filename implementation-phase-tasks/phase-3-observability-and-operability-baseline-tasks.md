# Phase 3 Tasks: Observability & Operability Baseline

## Goal
Deliver production-grade visibility and incident wiring for the baseline stack with minimal operational blind spots.

## Tasks

### P3-T01: Provision Grafana Cloud stack and service accounts
Owner: Human  
Type: Provider configuration  
Dependencies: Phase 0 accounts  
Action: Create Grafana Cloud Free stack(s), define env labeling strategy, create scoped API tokens for metrics/logs/traces/alerts, and document free-tier limits/watchpoints.  
Output: Provider credentials inventory.  
Done when: All required endpoints and tokens are available for integration.

### P3-T02: Store observability credentials in GSM and wire runtime-specific delivery
Owner: Agent  
Type: Infra/config  
Dependencies: P3-T01, Phase 5 baseline GSM availability (plus ESO when GKE path is enabled) or temporary local secret strategy  
Action: Create secret definitions for Grafana Cloud OTLP/auth credentials and wire runtime-specific delivery:
- Cloud Run baseline path: direct GSM-based secret injection for API/worker runtime envs.
- GKE path: ESO sync manifests for API/worker/collector components.  
Output: Secrets wired into workloads without plaintext in repo.  
Done when: Services read credentials through their selected runtime path without plaintext credentials in repo.

### P3-T03: Instrument API with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 API ready, P2-T13  
Action: Implement/consume a shared observability library package for backend services and instrument API with traces/metrics/logs context propagation, semantic resource attributes, error status mapping, and runtime-mode support (`direct_otlp`, `collector_gateway`) controlled by config.  
Output: API telemetry instrumentation.  
Done when: API requests produce correlated traces and metrics in Grafana Cloud.

### P3-T04: Instrument worker with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 worker ready, P2-T13  
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
Action: Define dashboards for API golden signals, worker health, edge/runtime path status, and DB connectivity symptoms.  
Output: Dashboard JSON/Terraform definitions.  
Done when: Dashboards can be recreated from source-controlled definitions.

### P3-T07: Configure alert rules and routing
Owner: Agent  
Type: Observability config  
Dependencies: P3-T06  
Action: Implement at least 3 actionable alerts (availability, latency, error rate), route to incident channels, and apply severity policy (auto-open `P1`; notify-only `P2/P3/P4`; escalate unacknowledged `P2` to auto-open after 15 minutes).  
Output: Alert rules and routing policy docs.  
Done when: Synthetic trigger tests demonstrate expected routing behavior.

### P3-T08: Configure Sentry projects and SDK integration
Owner: Human + Agent  
Type: Provider config + coding  
Dependencies: Phase 2 services  
Action: Create Sentry Developer (Free) projects (frontend/backend), add DSNs, verify release/environment tagging, and document quota watchpoints.  
Output: Sentry ingestion in both app tiers.  
Done when: Test errors from frontend/API appear with release metadata.

### P3-T09: Configure incident.io workflow integration
Owner: Human + Agent  
Type: Provider config + integration  
Dependencies: P3-T07  
Action: Set incident.io Basic (Free) escalation policies, service catalog mapping, and incident creation pathways aligned with severity policy (auto-open `P1`, deferred auto-open for unacknowledged `P2` after 15 minutes); document any tier-driven constraints.  
Output: Incident response routing baseline.  
Done when: Alert-generated incidents are created and assigned as expected.

### P3-T10: Implement alert -> AI automation service contract and endpoint
Owner: Agent  
Type: Coding  
Dependencies: P3-T07  
Action: Build webhook endpoint with signature validation, parse payload, request enrichment data from Grafana APIs, and emit machine-readable diagnostic payloads that can be consumed by later-phase AI diagnostic/task-generation workers.  
Output: Automation service baseline running with deterministic output format.  
Done when: Synthetic alert generates a structured AI-ready incident summary payload.

### P3-T11: Add enrichment integrations and evidence links
Owner: Agent  
Type: Coding  
Dependencies: P3-T10, P3-T08  
Action: Query metrics/logs/traces/Sentry APIs for correlated context and include links in result payload.  
Output: Enriched incident summary artifacts.  
Done when: Output includes direct evidence links and bounded analysis window.

### P3-T12: Run synthetic observability E2E tests
Owner: Human  
Type: Validation  
Dependencies: P3-T01..P3-T11  
Action: Trigger synthetic load/errors and verify dashboard, alerts, incident routing, and AI workflow output.  
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
- OTel instrumentation PRs for API and worker
- shared observability library configuration and usage evidence
- Cloud Run direct OTLP configuration evidence
- collector/alloy configs (GKE path)
- `OBS_TELEMETRY_PROFILE` mapping config and runbook
- `ops/observability-telemetry-budget-profile.md` conformance evidence
- dashboard definitions as code
- alert rules and routing policies
- Sentry integration evidence
- incident.io workflow configuration docs
- alert->AI webhook spec and service implementation
- synthetic observability validation report
