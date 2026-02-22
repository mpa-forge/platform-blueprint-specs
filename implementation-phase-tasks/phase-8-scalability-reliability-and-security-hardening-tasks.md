# Phase 8 Tasks: Scalability, Reliability, and Security Hardening

## Goal
Harden the baseline platform for sustained load, failure tolerance, and security/compliance readiness.

## Tasks

### P8-T01: Define service SLO/SLI baseline
Owner: Human + Agent  
Type: Reliability design  
Dependencies: Phase 3 observability baseline  
Action: Set measurable SLOs and SLIs for API availability, latency, and worker processing health. Initial baseline targets are provisional:
- API availability: `rc >= 99.0%` monthly, `prod >= 99.5%` monthly.
- API latency (p95): `rc <= 1000 ms`, `prod <= 750 ms`.
- Include a review checkpoint after first 30 days of prod traffic to tighten/adjust based on product SLAs.  
Output: SLO document and monitoring mapping.  
Done when: SLOs are approved, tied to dashboards/alerts, and tracked as tunable baseline targets (not permanent contractual SLAs).

### P8-T02: Configure HPA policies and resource requests/limits
Owner: Agent  
Type: Deployment config  
Dependencies: Phase 6 workloads deployed  
Action: Tune CPU/memory requests and autoscaling thresholds for API and worker workloads.  
Output: Updated Helm values and scaling configuration.  
Done when: Controlled load tests trigger expected scaling behavior.

### P8-T03: Execute baseline load tests and capture capacity profile
Owner: Human + Agent  
Type: Validation  
Dependencies: P8-T02  
Action: Run load tests for authenticated frontend/API flows and worker loop to identify bottlenecks.  
Output: Capacity report with thresholds and recommendations.  
Done when: Performance baseline is documented with reproducible scripts.

### P8-T04: Tune Cloud SQL performance and connectivity
Owner: Agent  
Type: Data optimization  
Dependencies: P8-T03  
Action: Review query plans, add indexes, tune connection pooling and timeout settings.  
Output: DB tuning changes and rationale.  
Done when: Target query latency and DB utilization metrics meet baseline goals.

### P8-T05: Add pod disruption budgets and resilience controls
Owner: Agent  
Type: Reliability config  
Dependencies: Phase 6 charts  
Action: Configure PDBs, anti-affinity/topology spread constraints, and graceful termination budgets.  
Output: Improved failure tolerance settings.  
Done when: Planned disruptions do not violate availability targets.

### P8-T06: Implement Kubernetes RBAC and network policies
Owner: Agent  
Type: Security config  
Dependencies: Phase 6 deployment baseline  
Action: Define least-privilege service account roles and namespace network segmentation rules.  
Output: Enforced cluster access boundaries.  
Done when: Unauthorized cross-service traffic is blocked by default policy.

### P8-T07: Implement secret rotation workflow
Owner: Human + Agent  
Type: Security operations  
Dependencies: Phase 5 GSM + ESO in use  
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
Action: Generate SBOMs for build artifacts and sign container images; verify signatures at deployment if possible.  
Output: Signed artifacts with SBOM traceability.  
Done when: Release artifacts include verifiable provenance metadata.

### P8-T09: Run security hardening audit
Owner: Human  
Type: Validation  
Dependencies: P8-T06..P8-T08  
Action: Validate RBAC, network policies, secret handling, and artifact controls against checklist.  
Output: Security gap report and closure plan.  
Done when: Target baseline checklist is passed or deviations are accepted with owner/date.

### P8-T10: Final baseline certification as reusable template
Owner: Human  
Type: Phase gate  
Dependencies: P8-T01..P8-T09  
Action: Confirm all phase objectives and baseline MVP acceptance criteria are met; tag template release.  
Output: Reusable platform blueprint release record.  
Done when: Template release is tagged and handoff docs are complete.

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
