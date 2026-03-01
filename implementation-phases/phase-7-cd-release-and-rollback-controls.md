# Phase 7: CD, Release, and Rollback Controls

Detailed tasks: `implementation-phase-tasks/phase-7-cd-release-and-rollback-controls-tasks.md`

- Define promotion flow RC -> prod.
- Add manual approvals for production and allow on-demand deploy timing.
- Implement DB migration strategy in deployment pipeline.
- Baseline DB rollback policy is forward-fix only.
- Add rollback runbook and automated smoke tests post-deploy.
- Mandatory smoke-test blockers for prod promotion (initial baseline):
  - API liveness/readiness checks (`/healthz`, `/readyz`) pass for new release.
  - Authenticated user journey check passes (frontend token flow -> protected API endpoint).
  - DB path check passes through API (deterministic read query succeeds).
  - Worker heartbeat/scheduled no-op execution is observed for the deployed version when worker deployment path is enabled.
  - Release version check confirms expected image tag/digest is running in target runtime (Cloud Run revision baseline, GKE workload when enabled).

Exit criteria:
- One tagged release promoted across all environments.
- Rollback tested and documented.

## Open Questions / Choices To Clarify Later
- None currently.
