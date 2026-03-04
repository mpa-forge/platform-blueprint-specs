# Phase 8: Scalability, Reliability, and Security Hardening

Detailed tasks: `implementation-phase-tasks/phase-8-scalability-reliability-and-security-hardening-tasks.md`

- Add HPA policies and load tests.
- Tune DB indexes/connections and capacity baselines.
- Add pod disruption budgets and multi-AZ considerations.
- Baseline provisional SLO targets (to be tightened once product requirements are defined):
  - API availability SLO:
    - `rc`: >= 99.0% monthly
    - `prod`: >= 99.5% monthly
  - API latency SLO (protected read/write baseline endpoints):
    - `rc`: p95 <= 1000 ms
    - `prod`: p95 <= 750 ms
  - Revisit cadence: review and adjust after the first 30 days of production traffic and product-specific SLA definition.
- Baseline secret rotation policy:
  - Cadence:
    - `rc`: every 30 days
    - `prod`: every 90 days
    - `prod` high-risk secrets (DB credentials, auth/provider secrets, observability/incident ingest keys): every 30 days
  - Emergency rotation SLA for suspected compromise: rotate within 4 hours.
  - Rotation execution model:
    - rotate in Google Secret Manager first and sync with ESO;
    - keep prior secret valid for 24 hours for rollback;
    - disable prior version after validation, then delete after 7 days.
  - Governance:
    - weekly secret-age audit job;
    - prod rotation requires manual approval.
- Add alert-driven AI diagnostic workers (later-phase extension):
  - Triggered by Grafana Cloud / Prometheus-style alert events.
  - Use MCP-integrated tool access to read metrics, logs, and traces.
  - Generate diagnosis summaries and open GitHub tasks for remediation.
  - Reuse the worker-lane deployment model used for task-to-code automation where applicable.
- Integrate deferred provider workflows after baseline infrastructure is stable:
  - Sentry Developer (Free) for frontend/backend error aggregation.
  - incident.io Basic (Free) for incident escalation/workflow routing.
- Enforce security controls:
  - RBAC
  - network policies
  - secret rotation
  - SBOM and signed images
  - deployment-time signature verification deferred to a later phase
- Resolve deferred edge-provider layering decision:
  - Evaluate whether to keep GCP-native edge only, or add external provider capabilities (for example advanced WAF/bot controls) based on real traffic/threat/cost signals.

Exit criteria:
- Performance SLO baseline documented.
- Security checklist passes for target environment.

## Open Questions / Choices To Clarify Later
- None currently.
