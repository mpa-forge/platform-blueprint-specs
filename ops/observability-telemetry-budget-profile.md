# Observability Telemetry Budget Profile Spec

## Purpose
Define a single, easy-to-change control for observability ingestion so the platform can stay within Grafana Cloud free-tier limits while preserving consistent operational visibility.

## Scope
- Applies to telemetry routed through the cluster collector gateway (Grafana Alloy / OTel Collector).
- Covers traces, logs, and metrics export behavior to Grafana Cloud.
- Applies to `rc` and `prod`.

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

## Implementation Model
- Control location:
  - Collector/alloy config (not service code).
  - Exposed through Helm values/env so one config change updates policy.
- Processing behavior by signal:
  - Traces:
    - probabilistic sampling by profile
    - force-sample exceptions for error/high-latency/incident traffic
  - Logs:
    - severity/category filters and sampling by profile
    - preserve warning/error logs in all profiles
  - Metrics:
    - drop/filter noisy series and high-cardinality labels by profile
    - enforce metric allow/deny patterns for budget control

## Source Instrumentation Requirements
Collector filtering is the budget control plane, but source instrumentation must avoid telemetry explosions.

- Do not use high-cardinality metric labels at source:
  - `user_id`, `request_id`, `session_id`, `email`, unique identifiers
  - raw URL paths with IDs
- Use low-cardinality labels for metrics:
  - `service`, `endpoint_template`, `method`, `status_class`, `env`, `region`
- Put unique request/user identifiers in logs/traces, not metric labels.
- Normalize dynamic paths for metrics (for example `/users/:id/orders/:id`).

## Why Source Cardinality Rules Are Mandatory
Collector drops protect vendor ingestion cost, but do not eliminate upstream runtime overhead:
- app still creates/exports the series
- app -> collector network still carries the payload
- collector still spends CPU/memory parsing before dropping

Therefore:
- Source-side cardinality discipline is mandatory.
- Collector profile control is the safety layer.

## Operational Procedure
1. Monitor ingestion usage dashboards for traces/logs/metrics.
2. If usage trend is unsafe, switch profile to `cost`.
3. Validate impact in usage and signal quality dashboards.
4. If incident debugging requires detail, switch to `debug` temporarily.
5. Revert to `balanced` after the debugging window.

## Suggested Threshold Policy (Initial)
- `>= 70%` of tier budget: watch and prepare.
- `>= 85%`: switch to `cost`.
- `>= 95%`: apply stricter `cost` filters and notify on-call.

## Change Path
- Standard path:
  - Update Helm/env configuration for `OBS_TELEMETRY_PROFILE`.
  - Deploy via normal CI/CD pipeline.
- Emergency path:
  - Patch collector runtime profile directly in cluster.
  - Backport the same setting to git immediately after stabilization.

## Validation Requirements
- Demonstrate profile toggles (`balanced -> cost -> balanced`, optional `debug` window).
- Confirm ingestion-volume changes in Grafana usage dashboards.
- Confirm critical telemetry remains intact in `cost` profile:
  - error signals
  - health/readiness behavior
  - core latency/error-rate alerts

## Required Artifacts
- Collector/alloy profile mapping config in source control.
- Operator runbook describing thresholds and rollback.
- Validation report with evidence links for each profile transition.

