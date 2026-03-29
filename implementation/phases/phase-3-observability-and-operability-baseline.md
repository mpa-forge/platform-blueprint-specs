# Phase 3: Observability & Operability Baseline

Detailed tasks: `implementation/phase-tasks/phase-3-observability-and-operability-baseline-tasks.md`
Specification artifact: `ops/observability-telemetry-budget-profile.md`

- Instrument API with OpenTelemetry and keep backend-worker instrumentation deferred to Phase 9.
- Implement dual observability runtime modes with one shared configuration contract:
  - Cloud Run baseline path: direct OTLP/HTTP export to Grafana Cloud.
  - GKE alternative path: cluster-level collector gateway (Grafana Alloy / OTel Collector).
- Configure telemetry export to Grafana Cloud (OTLP endpoints + API auth).
- Use free-tier provider baseline in this phase: Grafana Cloud Free.
- Apply initial trace sampling policy:
  - `rc`: 25% baseline trace sampling.
  - `prod`: 5% baseline trace sampling.
  - Force sample 100% for error traces, high-latency traces (>1s initial threshold), and explicit debug/incident traffic.
- Implement one centrally changeable telemetry budget profile (`OBS_TELEMETRY_PROFILE`) that works in both runtime modes to control traces/logs/metrics ingestion and stay within tier caps.
- Configure Grafana Cloud dashboards (golden signals + service deep-dive views).
- Set up log export for both modes:
  - direct OTLP/HTTP export for Cloud Run baseline
  - Alloy/collector shipping for GKE path
- Define ingestion/cardinality guardrails and retention budgets per environment.
- Add alert rules for critical platform signals.
- Apply alert severity routing policy in baseline:
  - `P1` routes to immediate pager/webhook path.
  - `P2`, `P3`, and `P4` notify-only by default.
  - Escalate unacknowledged `P2` after 15 minutes.
- Reserve incident auto-open behavior for Phase 8 when incident.io integration is enabled.
- Implement automated alert-to-AI workflow:
  - Grafana alert webhook -> automation service endpoint.
  - Enrichment queries to Grafana Cloud APIs (metrics/logs/traces).
  - AI analysis output routed to webhook/Slack with links to source evidence.
- Defer Sentry and incident.io provider integrations to Phase 8 hardening after baseline infrastructure and deploy paths are stable.
- Defer advanced AI Ops automation to later phases:
  - alert-triggered diagnostic worker lanes using MCP-integrated telemetry access.
  - automatic remediation task generation in GitHub from diagnostics.

Exit criteria:
- Traces visible end-to-end for one synthetic flow.
- Dashboard and at least 3 actionable alerts active.
- Alert-to-AI flow produces deterministic, testable incident summaries from synthetic alerts.
- Telemetry budget profile can be toggled (`balanced`/`cost`/`debug`) through configuration only, and the effect is visible in ingestion volume dashboards.

Phase 3 checklist:
- Provision Grafana Cloud org/stack and service accounts.
- Create and store telemetry/API tokens in secret manager.
- Configure OTEL env vars in API deployments.
- Configure shared observability library mode (`direct_otlp` vs `collector_gateway`) and verify profile parity.
- Deploy collector/alloy config only for GKE mode and verify ingest for logs/metrics/traces.
- Verify `OBS_TELEMETRY_PROFILE` toggle path and ingestion impact without application redeploy.
- Provision baseline dashboards from code (JSON or Terraform provider).
- Create alert routing and webhook endpoint with signature validation.
- Run synthetic observability test suite and record evidence.

## Open Questions / Choices To Clarify Later
- None currently.
