# Phase 3: Observability & Operability Baseline

Detailed tasks: `implementation-phase-tasks/phase-3-observability-and-operability-baseline-tasks.md`

- Instrument API and worker with OpenTelemetry.
- Route telemetry through a cluster-level collector gateway (Grafana Alloy / OTel Collector baseline).
- Configure telemetry export to Grafana Cloud (OTLP endpoints + API auth).
- Apply initial trace sampling policy:
  - `rc`: 25% baseline trace sampling.
  - `prod`: 5% baseline trace sampling.
  - Force sample 100% for error traces, high-latency traces (>1s initial threshold), and explicit debug/incident traffic.
- Configure Grafana Cloud dashboards (golden signals + service deep-dive views).
- Set up log shipping via Grafana Alloy to Grafana Cloud Logs.
- Define ingestion/cardinality guardrails and retention budgets per environment.
- Add alert rules for critical platform signals.
- Apply incident opening severity policy:
  - Auto-open incidents for `P1` alerts.
  - Notify-only for `P2`, `P3`, and `P4` alerts by default.
  - Escalate unacknowledged `P2` alerts to auto-open incident after 15 minutes.
- Configure Sentry projects and SDK ingestion for frontend and backend.
- Configure incident.io escalation/workflow integration and alert routing.
- Implement automated alert-to-AI workflow:
  - Grafana alert webhook -> automation service endpoint.
  - Enrichment queries to Grafana Cloud APIs (metrics/logs/traces) and optional Sentry API.
  - AI analysis output routed to incident.io/Slack with links to source evidence.
- Defer advanced AI Ops automation to later phases:
  - alert-triggered diagnostic worker lanes using MCP-integrated telemetry access.
  - automatic remediation task generation in GitHub from diagnostics.

Exit criteria:
- Traces visible end-to-end for one synthetic flow.
- Dashboard and at least 3 actionable alerts active.
- Alert-to-AI flow produces deterministic, testable incident summaries from synthetic alerts.

Phase 3 checklist:
- Provision Grafana Cloud org/stack and service accounts.
- Create and store telemetry/API tokens in secret manager.
- Configure OTEL env vars in API/worker deployments.
- Deploy collector/alloy config and verify ingest for logs/metrics/traces.
- Provision baseline dashboards from code (JSON or Terraform provider).
- Create alert routing and webhook endpoint with signature validation.
- Run synthetic observability test suite and record evidence.

## Open Questions / Choices To Clarify Later
- None currently.
