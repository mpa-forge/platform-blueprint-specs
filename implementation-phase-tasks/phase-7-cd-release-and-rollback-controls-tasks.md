# Phase 7 Tasks: CD, Release, and Rollback Controls

## Goal
Define safe promotion and rollback mechanics so releases are predictable, auditable, and recoverable.

## Tasks

### P7-T01: Define environment promotion policy
Owner: Human  
Type: Release governance  
Dependencies: Phase 6 deploy baseline  
Action: Document promotion criteria from `rc` -> `prod` including required evidence, sign-offs, and on-demand production deployment timing.  
Output: Release promotion policy document.  
Done when: Release policy is approved and referenced by CI/CD workflows.

### P7-T02: Implement staged deployment workflows
Owner: Agent  
Type: CI/CD coding  
Dependencies: P7-T01  
Action: Add GitHub Actions workflows/jobs for staged promotion and environment-specific deployment parameters.  
Output: Automated multi-environment deployment pipeline.  
Done when: Tagged release can be promoted through environments with clear status tracking.

### P7-T03: Configure production manual approvals and protections
Owner: Human + Agent  
Type: Governance + config  
Dependencies: P7-T02  
Action: Set GitHub environment protection rules and required approvers for prod deployment jobs.  
Output: Controlled production gate configuration.  
Done when: Production deploy cannot proceed without explicit approval.

### P7-T04: Implement database migration execution strategy
Owner: Agent  
Type: CI/CD coding  
Dependencies: Phase 2 DB migration tooling, P7-T02  
Action: Define migration step ordering, failure handling, and idempotency strategy in deployment pipeline.  
Output: Automated migration stage in release flow.  
Done when: Deploy pipeline applies migrations safely before app rollout.

### P7-T05: Add post-deploy smoke tests per environment
Owner: Agent  
Type: QA automation  
Dependencies: P7-T02  
Action: Run mandatory baseline smoke tests after each deployment and gate promotion on results. Required blockers are:
- API health and readiness (`/healthz`, `/readyz`).
- Authenticated frontend -> protected API happy-path check.
- API -> DB deterministic read check.
- Worker heartbeat/no-op scheduled execution check.
- Release version check (expected image tag/digest running).  
Output: Automated post-deploy verification.  
Done when: Failed smoke tests block subsequent promotion stages.

### P7-T06: Define and implement rollback workflows
Owner: Agent  
Type: CI/CD coding  
Dependencies: P7-T02, P7-T04  
Action: Add rollback jobs for Helm releases and define DB rollback policy as forward-fix only.  
Output: Rollback pipeline actions.  
Done when: Team can execute rollback through repeatable documented commands/workflows.

### P7-T07: Write release and rollback runbooks
Owner: Agent  
Type: Documentation  
Dependencies: P7-T01..P7-T06  
Action: Document step-by-step release and rollback operations with failure branch paths.  
Output: `docs/runbooks/release.md` and `docs/runbooks/rollback.md`.  
Done when: On-call can execute procedures without tribal knowledge.

### P7-T08: Perform release fire-drill and rollback test
Owner: Human  
Type: Validation  
Dependencies: P7-T01..P7-T07  
Action: Execute one full simulated release and induced failure rollback in `rc`.  
Output: Drill report and remediation tasks.  
Done when: Release and rollback criteria are validated and signed off.

## Artifacts Checklist
- promotion policy
- staged deployment workflows
- production approval settings
- DB migration pipeline stage
- smoke test suite integration
- rollback workflow implementation
- release/rollback runbooks
- fire-drill evidence
