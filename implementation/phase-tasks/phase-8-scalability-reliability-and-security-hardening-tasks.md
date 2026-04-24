# Phase 8 Tasks: Scalability, Reliability, and Security Hardening

## Goal
Harden the baseline platform for sustained load, failure tolerance, and security/compliance readiness.

## Tasks

### P8-T01: Define service SLO/SLI baseline
Owner: Human + Agent  
Type: Reliability design  
Dependencies: Phase 3 observability baseline  
Affected repos: `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-infra`
Action: Set measurable SLOs and SLIs for API availability and latency. Backend-worker processing SLOs are deferred to Phase 9. Initial baseline targets are provisional:
- API availability: `rc >= 99.0%` monthly, `prod >= 99.5%` monthly.
- API latency (p95): `rc <= 1000 ms`, `prod <= 750 ms`.
- Include a review checkpoint after first 30 days of prod traffic to tighten/adjust based on product SLAs.  
Output: SLO document and monitoring mapping.  
Done when: SLOs are approved, tied to dashboards/alerts, and tracked as tunable baseline targets (not permanent contractual SLAs).

### P8-T02: Configure HPA policies and resource requests/limits
Owner: Agent  
Type: Deployment config  
Dependencies: Phase 6 workloads deployed  
Affected repos: `backend-api`, `backend-worker`, `platform-infra`
Action: Tune CPU/memory requests and autoscaling thresholds for API workloads. Backend-worker scaling is deferred to Phase 9.  
Output: Updated Helm values and scaling configuration.  
Done when: Controlled load tests trigger expected scaling behavior.

### P8-T03: Execute baseline load tests and capture capacity profile
Owner: Human + Agent  
Type: Validation  
Dependencies: P8-T02  
Affected repos: `frontend-web`, `backend-api`, `platform-infra`
Action: Run load tests for authenticated frontend/API flows to identify bottlenecks. Backend-worker load testing is deferred to Phase 9.  
Output: Capacity report with thresholds and recommendations.  
Done when: Performance baseline is documented with reproducible scripts.

### P8-T04: Tune Cloud SQL performance and connectivity
Owner: Agent  
Type: Data optimization  
Dependencies: P8-T03  
Affected repos: `backend-api`, `platform-infra`
Action: Review query plans, add indexes, tune connection pooling and timeout settings.  
Output: DB tuning changes and rationale.  
Done when: Target query latency and DB utilization metrics meet baseline goals.

### P8-T05: Add pod disruption budgets and resilience controls
Owner: Agent  
Type: Reliability config  
Dependencies: Phase 6 charts  
Affected repos: `backend-api`, `backend-worker`, `platform-infra`
Action: Configure PDBs, anti-affinity/topology spread constraints, and graceful termination budgets.  
Output: Improved failure tolerance settings.  
Done when: Planned disruptions do not violate availability targets.

### P8-T06: Implement Kubernetes RBAC and network policies
Owner: Agent  
Type: Security config  
Dependencies: Phase 6 deployment baseline  
Affected repos: `platform-infra`, `backend-api`, `backend-worker`, `platform-ai-workers`
Action: Define least-privilege service account roles and namespace network segmentation rules.  
Output: Enforced cluster access boundaries.  
Done when: Unauthorized cross-service traffic is blocked by default policy.

### P8-T07: Implement secret rotation workflow
Owner: Human + Agent  
Type: Security operations  
Dependencies: Phase 5 GSM + ESO in use  
Affected repos: `platform-infra`, `backend-api`, `backend-worker`, `frontend-web`, `platform-ai-workers`
Action: Implement the baseline rotation policy and automate rollout-safe secret refresh:
- Cadence:
  - `rc`: every 30 days.
  - `prod`: every 90 days.
  - `prod` high-risk secrets (DB credentials, auth/provider secrets, observability/incident ingest keys): every 30 days.
- Emergency rotation SLA: within 4 hours of suspected compromise.
- Execution: rotate in GSM, sync via ESO, keep previous secret valid for 24 hours rollback window, then disable and delete after 7 days.
- Governance: weekly secret-age audit and manual approval gate for prod rotations.  
Output: Secret rotation runbook and automation hooks.  
Done when: Scheduled and emergency rotations can be executed without downtime and with auditable evidence.

### P8-T08: Add SBOM generation and artifact signing
Owner: Agent  
Type: Supply chain security  
Dependencies: Phase 4 CI pipeline  
Affected repos: `org-dot-github`, `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`, `platform-infra`
Action: Generate SBOMs for build artifacts and sign container images; verify signatures at deployment if possible.  
Output: Signed artifacts with SBOM traceability.  
Done when: Release artifacts include verifiable provenance metadata.

### P8-T09: Run security hardening audit
Owner: Human  
Type: Validation  
Dependencies: P8-T06..P8-T08  
Affected repos: `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-infra`, `org-dot-github`
Action: Validate RBAC, network policies, secret handling, and artifact controls against checklist.  
Output: Security gap report and closure plan.  
Done when: Target baseline checklist is passed or deviations are accepted with owner/date.

### P8-T10: Final baseline certification as reusable template
Owner: Human  
Type: Phase gate  
Dependencies: P8-T01..P8-T09, P8-T11..P8-T18
Affected repos: `platform-blueprint-specs`, `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`, `platform-infra`, `org-dot-github`
Action: Confirm all phase objectives and baseline MVP acceptance criteria are met; tag template release.  
Output: Reusable platform blueprint release record.  
Done when: Template release is tagged and handoff docs are complete.

### P8-T11: Define MCP-based diagnostic tool access model
Owner: Human + Agent  
Type: Architecture + security  
Dependencies: Phase 3 observability baseline, P8-T06  
Affected repos: `platform-ai-workers`, `backend-api`, `platform-infra`
Action: Define MCP integration boundaries for telemetry access (metrics/logs/traces), allowed tools/endpoints, credential isolation, and data redaction policy for AI diagnostics.  
Output: `docs/automation/ai-ops-mcp-model.md`.  
Done when: MCP/tool permissions and safe-data handling rules are approved for alert-driven diagnostics.

### P8-T12: Implement alert-driven AI diagnostic worker pipeline
Owner: Agent  
Type: Automation coding  
Dependencies: P8-T11, Phase 3 alert routing, Phase 1 `platform-ai-workers` baseline  
Affected repos: `platform-ai-workers`, `backend-api`, `platform-infra`
Action: Add worker pipeline triggered by Grafana Cloud / Prometheus-style alert events, retrieve telemetry context (metrics/logs/traces), run diagnostic analysis, and emit structured remediation proposals with evidence links.  
Output: Alert -> diagnostics worker implementation and deployment manifests/config.  
Done when: Synthetic alerts trigger deterministic diagnostics with linked telemetry evidence.

### P8-T13: Automate remediation task generation from diagnostics
Owner: Agent  
Type: Automation integration  
Dependencies: P8-T12, Phase 0 task workflow baseline  
Affected repos: `platform-ai-workers`, `platform-blueprint-specs`
Action: Convert validated diagnostic outputs into GitHub Issues/Project tasks with standard labels/priority suggestions, links to evidence, and optional worker-lane assignment for follow-up automation.  
Output: Diagnostics -> task generation integration.  
Done when: At least one synthetic alert produces a correctly formatted remediation issue in the project board.

### P8-T14: Resolve edge-provider layering decision with production evidence
Owner: Human + Agent  
Type: Security/perimeter decision  
Dependencies: Phase 6 ingress/CDN path in production-like load, P8-T03, P8-T09  
Affected repos: `frontend-web`, `backend-api`, `platform-infra`
Action: Evaluate internet edge strategy using observed traffic and threat signals; compare keeping GCP-native edge only versus adding an external edge provider layer (for example advanced WAF/bot controls), including cost, operational complexity, and lock-in implications.  
Output: ADR with selected direction, migration plan (if any), and rollback criteria.  
Done when: Decision is approved and reflected in platform spec, infra plan, and runbooks.

### P8-T15: Create or confirm Sentry baseline and integrate frontend/backend error tracking
Owner: Human + Agent  
Type: Provider account setup + integration  
Dependencies: Phase 6 deployed runtimes, Phase 3 baseline observability, P8-T09  
Affected repos: `frontend-web`, `backend-api`, `platform-infra`, `org-dot-github`
Action: Create or confirm Sentry organization on Developer (Free), create/configure frontend/backend projects, wire SDKs and DSN secrets, enforce release/environment tagging, and define quota watchpoints plus issue triage workflow.  
Output: Sentry integration implementation evidence and runbook.  
Done when: Synthetic frontend and API errors are grouped correctly in Sentry with release/environment metadata and linked back to platform runbooks.

### P8-T16: Create or confirm incident.io baseline and integrate incident routing/escalation
Owner: Human + Agent  
Type: Provider account setup + integration  
Dependencies: P8-T15, P3-T07
Affected repos: `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-infra`, `org-dot-github`
Action: Create or confirm incident.io workspace on Basic (Free), configure service catalog and escalation routing, then connect alert/event pathways (Grafana alerts and AI diagnostic outputs) to incident creation workflows aligned with severity policy.  
Output: incident.io workflow configuration docs and test evidence.  
Done when: Synthetic `P1` and escalated `P2` events produce incident records with expected routing/assignment behavior.

### P8-T17: Harden optional single-VM deployment preset
Owner: Human + Agent
Type: Architecture + infra + CI/CD coding
Dependencies: Phase 7 complete, P8-T03
Affected repos: `frontend-web`, `backend-api`, `platform-infra`, `org-dot-github`
Action: Build on the existing `platform-infra` single-VPS preset and finish the operational hardening needed for routine use. The task must:
- document when this path is appropriate versus Cloud Run or GKE (traffic, ops burden, cost, recovery expectations)
- define the VM runtime model (for example Docker Compose or equivalent process supervision on one host)
- extend Terraform support where needed for backups, recovery, and operator guardrails
- add GitHub Actions support for building and deploying to the VM path
- document operational tradeoffs, backup/recovery expectations, and migration path back to Cloud Run/GKE when scale or reliability needs increase
- prove the path with one end-to-end RC deployment and smoke test of frontend -> API -> DB
Output: VM-path architecture doc, infrastructure implementation, deployment workflow, and validation evidence.
Done when: The single-VM path is documented, provisionable, deployable from CI, and validated as an optional runtime for projects where its tradeoffs are acceptable.

### P8-T18: Backfill canonical ADRs and integrate ADR upkeep into the developer workflow
Owner: Human + Agent
Type: Documentation + workflow hardening
Dependencies: Phase 0 ADR template baseline, P8-T14..P8-T17
Affected repos: `platform-blueprint-specs`, `frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`, `platform-infra`
Action: Audit the accumulated planning and design sources (`platform-specification.md`, `common/standards/`, `ops/`, `implementation/`, cross-repo architecture docs, and accepted OpenSpec `design.md`/`spec.md` artifacts) for platform-level decisions that currently live only in docs or specs. Create or update the canonical ADR set in the dedicated docs repository, keep source docs linked to the matching ADRs, and update the workflow skills/checklists so normal planning and implementation work explicitly evaluates whether an ADR must be created, updated, or superseded whenever platform-level decisions change.
Output: ADR backfill set, source-to-ADR migration map, and updated workflow skills/checklists.
Done when: The major cross-repo architecture and governance decisions have canonical ADRs, source docs point to the relevant ADRs, and the normal developer workflow includes an explicit ADR-review step.

## Artifacts Checklist
- SLO/SLI baseline docs
- autoscaling/resource tuning configs
- load testing scripts and reports
- DB tuning notes
- PDB and resilience policy manifests
- RBAC/network policy manifests
- secret rotation runbook
- SBOM/signing CI outputs
- security audit report
- template certification record
- MCP/tool access model for AI diagnostics
- alert-driven diagnostic worker implementation evidence
- diagnostics-to-task generation validation evidence
- edge-provider layering ADR and implementation plan
- Sentry integration evidence and triage runbook
- incident.io routing/escalation configuration evidence
- single-VM deployment path architecture, infra, CI workflow, and validation evidence
- ADR backfill set, migration map, and workflow-skill updates
