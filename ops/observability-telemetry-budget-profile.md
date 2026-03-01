# Observability Telemetry Budget Profile Spec

## Purpose
Define one runtime-configurable observability control that works for both API runtime paths:
- Cloud Run baseline path (`direct_otlp`)
- GKE alternative path (`collector_gateway`)

The goal is to stay within Grafana Cloud free-tier limits while preserving consistent operational visibility.

## Scope
- Traces, metrics, and logs exported to Grafana Cloud.
- Applies to `rc` and `prod`.
- Applies to API and worker services using the shared backend observability package.

## Runtime Modes
- `OBS_RUNTIME_MODE=direct_otlp`
  - Baseline path for Cloud Run API.
  - Services export traces/metrics/logs via OTLP/HTTP directly to Grafana Cloud endpoints.
- `OBS_RUNTIME_MODE=collector_gateway`
  - Alternative path for GKE workloads.
  - Services export to collector/alloy; collector forwards to Grafana Cloud.

## Shared Library Requirement
Implement a reusable backend observability package consumed by API/worker services.

Required capabilities:
- Initialize traces/metrics/logs with one config contract.
- Support both runtime modes (`direct_otlp`, `collector_gateway`) without changing service instrumentation call sites.
- Expose consistent resource attributes and label conventions across modes.
- Apply profile-driven controls (sampling/filtering/export options) through configuration.
- Emit startup diagnostics that include active mode/profile/version.

Non-goal:
- Forked instrumentation logic per runtime path.

## Locked Control
- Runtime control value: `OBS_TELEMETRY_PROFILE`
- Allowed values:
  - `balanced` (default)
  - `cost`
  - `debug` (time-boxed incident window only)

## Profile Contract
- `balanced`:
  - Standard operating profile.
  - Must preserve baseline trace policy:
    - `rc` trace sampling: `25%`
    - `prod` trace sampling: `5%`
  - Keep force-sample rules for errors/high-latency/incident-debug traces.
- `cost`:
  - Reduced ingestion profile used when usage approaches free-tier limits.
  - More aggressive trace/log sampling and metric series filtering.
  - Must still preserve minimum critical visibility (errors, health signals, SLO alerts).
- `debug`:
  - Increased detail profile for active diagnosis.
  - Operator-approved and time-boxed.
  - Must auto-revert or be reverted back to `balanced` after investigation.

## Mode-Specific Implementation
- `direct_otlp` (Cloud Run baseline):
  - Profile behavior is applied by shared library/runtime config:
    - traces: sampling and force-sample exceptions
    - logs: severity/category sampling/filtering
    - metrics: cardinality hygiene and optional drop/filter rules before export
  - Changes are applied by Cloud Run config/env update and new revision rollout.

- `collector_gateway` (GKE path):
  - Shared library keeps instrumentation and baseline defaults consistent.
  - Collector/alloy applies additional profile policies:
    - sampling processors
    - log filtering/sampling
    - metric relabel/drop filters
  - Changes are applied by collector config update.

## Source Instrumentation Requirements
Source cardinality discipline is mandatory in both modes:

- Do not use high-cardinality metric labels:
  - `user_id`, `request_id`, `session_id`, `email`, unique identifiers
  - raw URL paths with IDs
- Use low-cardinality labels:
  - `service`, `endpoint_template`, `method`, `status_class`, `env`, `region`
- Put unique request/user identifiers in logs/traces, not metric labels.
- Normalize dynamic paths for metrics (for example `/users/:id/orders/:id`).

## Why Source Cardinality Rules Are Mandatory
Even with downstream filtering:
- app still creates/exports the telemetry
- network still carries payloads
- exporters/collectors still spend CPU/memory parsing before drops

Therefore:
- source-side cardinality control is required
- profile-based filtering is a safety layer, not a substitute

## Operational Procedure
1. Monitor Grafana Cloud usage dashboards for traces/logs/metrics.
2. If trend is unsafe, switch to `cost`.
3. Validate impact on usage and signal quality.
4. For incident deep-dive, switch to `debug` temporarily.
5. Revert to `balanced` when incident window closes.

## Suggested Threshold Policy (Initial)
- `>= 70%` of tier budget: watch and prepare.
- `>= 85%`: switch to `cost`.
- `>= 95%`: apply stricter `cost` filters and notify on-call.

## Change Path
- Standard path:
  - Update runtime configuration:
    - Cloud Run path: env/config revision rollout.
    - GKE path: collector/Helm config rollout.
  - Deploy via normal CI/CD pipeline.
- Emergency path:
  - Apply runtime-mode-specific hotfix (Cloud Run revision/env patch or collector runtime patch).
  - Backport configuration to git immediately after stabilization.

## Validation Requirements
- Demonstrate profile toggles in both runtime modes:
  - `balanced -> cost -> balanced`
  - optional `debug` window
- Confirm ingestion-volume changes in Grafana usage dashboards.
- Confirm critical telemetry remains intact in `cost` profile:
  - errors
  - health/readiness
  - core latency/error-rate alerts
- Confirm dashboards/alerts keep working across mode switches.

## Required Artifacts
- Shared observability library package design/usage docs.
- Mode-aware profile mapping config in source control.
- Operator runbook describing thresholds, mode-specific toggle mechanics, and rollback.
- Validation report with evidence links for both runtime modes.
