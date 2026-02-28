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

### P3-T02: Store observability credentials in GSM and sync via ESO
Owner: Agent  
Type: Infra/config  
Dependencies: P3-T01, Phase 5 baseline GSM/ESO availability or temporary local secret strategy  
Action: Create secret definitions and sync manifests for API/worker/collector components.  
Output: Secrets wired into workloads without plaintext in repo.  
Done when: Services read credentials from synced Kubernetes secrets.

### P3-T03: Instrument API with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 API ready  
Action: Add traces/metrics context propagation, semantic resource attributes, and error status mapping.  
Output: API telemetry instrumentation.  
Done when: API requests produce correlated traces and metrics in Grafana Cloud.

### P3-T04: Instrument worker with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 worker ready  
Action: Emit traces and metrics for scheduled tasks, retries, and failures; include service/resource labels.  
Output: Worker telemetry instrumentation.  
Done when: Worker loop activity is visible in traces and dashboard metrics.

### P3-T05: Deploy telemetry pipeline via cluster-level collector gateway (Grafana Alloy / OTel Collector)
Owner: Agent  
Type: Deployment/config  
Dependencies: P3-T01  
Action: Configure collector gateway receivers/processors/exporters for OTLP traces, metrics scrape forwarding, and log shipping before forwarding to Grafana Cloud; implement initial trace sampling policy (`rc` 25%, `prod` 5%) and force-sample rules for errors, high-latency traces (>1s initial threshold), and explicit debug/incident traffic; add centralized `OBS_TELEMETRY_PROFILE` mapping (`balanced`/`cost`/`debug`) to adjust trace sampling, log sampling/drop rules, and metric cardinality/drop filters from one config toggle, aligned with `ops/observability-telemetry-budget-profile.md`.  
Output: Collector/alloy deployment manifests and profile mapping aligned with `ops/observability-telemetry-budget-profile.md`.  
Done when: Logs/metrics/traces arrive in Grafana Cloud with expected labels and profile-based ingestion controls can be changed without code changes.

### P3-T06: Build baseline dashboards from code
Owner: Agent  
Type: Observability config  
Dependencies: P3-T03..P3-T05  
Action: Define dashboards for API golden signals, worker health, ingress status, and DB connectivity symptoms.  
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
Action: Execute controlled toggles of `OBS_TELEMETRY_PROFILE` (`balanced` -> `cost` -> `balanced`, optional `debug` window), validate expected ingestion-volume changes for traces/logs/metrics, and document safe operating thresholds plus rollback steps for free-tier cap protection.  
Output: `docs/operations/telemetry-budget-profile-runbook.md`, validation evidence, and conformance notes to `ops/observability-telemetry-budget-profile.md`.  
Done when: Operators can adjust telemetry ingestion within one config change, observe impact in dashboards, and revert safely.

## Artifacts Checklist
- Grafana Cloud stack/token inventory
- OTel instrumentation PRs for API and worker
- collector/alloy configs
- `OBS_TELEMETRY_PROFILE` mapping config and runbook
- `ops/observability-telemetry-budget-profile.md` conformance evidence
- dashboard definitions as code
- alert rules and routing policies
- Sentry integration evidence
- incident.io workflow configuration docs
- alert->AI webhook spec and service implementation
- synthetic observability validation report
