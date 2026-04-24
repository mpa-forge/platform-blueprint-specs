# Milestone Quick Reference

Purpose:
- Provide a short checkpoint list that answers "what do we have once these tasks are done?" and "what is still missing for the next objective?"

Status legend:
- `Complete`: milestone exit tasks are already complete.
- `Partial`: some prerequisite work exists, but the milestone outcome is not yet true end to end.
- `Not started`: milestone depends mostly on future phase work.

## Milestones

| Milestone | Reached after | What this milestone means | Status today | What is still missing |
| --- | --- | --- | --- | --- |
| Foundation locked | Phase 0 sign-off (`P0-T15`) | Core platform decisions, provider baseline, repo ownership, access model, task workflow, and AI-worker control model are fixed enough to execute with low rework risk. | `Complete` | Nothing for this milestone. |
| Local repos and developer workflow ready | Phase 1 local baseline (`P1-T01`..`P1-T10`) | Repos exist, branch protections are in place, toolchains are pinned, local Compose works, smoke scripts exist, and a new developer can bootstrap the project. | `Complete` | Nothing for this milestone. |
| Local RC-shaped app slice works end to end | Phase 2 local E2E validation (`P2-T01`..`P2-T12`) | The baseline user flow works locally: sign-in -> protected frontend page -> protected API -> Postgres read. This is the first proof that the main elements connect correctly. | `Complete` | Nothing for this milestone. |
| Shared observability contract is ready to wire into cloud | Phase 2 observability package plus Phase 3 code/config baseline (`P2-T13`, `P3-T03`, `P3-T03A`, `P3-T03B`, `P3-T05`, `P3-T06`, `P3-T07`) | Backend and frontend telemetry code paths, dashboard definitions, alert rules, and telemetry-profile controls exist in source control and are ready for real environment wiring. | `Partial` | Real GSM delivery for observability secrets (`P3-T02`), deployed `rc` runtime validation (`P3-T12`, `P3-T13`, `P3-T14`), and live dashboard/alert evidence. |
| CI quality gate baseline active | Phase 4 CI baseline (`P4-T02`..`P4-T10`) | PRs are guarded by lint, tests, contract checks, security scans, image builds, and required branch checks; merges can safely produce deployable artifacts. | `Partial` | GAR/WIF cloud auth path (`P4-T05`, `P4-T06`) and any remaining enforcement work needed to make the full merge-to-deploy path operational. |
| RC cloud resources created from clean state | Phase 5 infra apply (`P5-T01`..`P5-T11`, `P5-T15`, `P5-T15A`) | The required `rc` cloud foundation exists in a reproducible way: network, Cloud Run service base for API and frontend, Cloud SQL, GAR, GSM, `/api/*` routing resources, and dashboard provisioning. | `Not started` | Most of Phase 5, especially environment stacks (`P5-T09`), frontend/runtime routing (`P5-T15`, `P5-T15A`), and clean-state apply validation (`P5-T11`). |
| First cloud backend deployment live | First Cloud Run deployment (`P6-T12`, `P6-T13`, `P6-T15`) | The API is deployed in `rc`, healthy on Cloud Run, connected to Cloud SQL and secrets, and updated by CI/CD instead of manual steps. | `Not started` | Phase 5 infra readiness plus Cloud Run deploy/config validation in Phase 6. |
| Frontend, auth, API, DB, and routing all connected in `rc` | RC E2E deployment validation (`P6-T06`, `P6-T08`, `P6-T14`, `P6-T10`) | The main cloud objective is achieved: Cloud Run-served frontend uses Clerk auth and same-domain `/api/*` routing to reach the deployed API, which reads from the cloud DB in `rc`. | `Not started` | RC frontend Cloud Run path, same-domain routing, frontend delivery pipeline, and formal `rc` validation report. |
| RC observability working end to end | Live observability validation (`P3-T02`, `P3-T12`, `P3-T13`, `P3-T14`) after Phase 5/6 deployment wiring | Real `rc` traces, logs, metrics, dashboards, alerts, and telemetry-budget controls are visible and validated against deployed traffic. | `Not started` | Cloud secret delivery, deployed runtime telemetry proof, synthetic E2E observability tests, and live dashboard/alert verification. |
| Production deployment path ready | Release-control baseline (`P7-T01`..`P7-T07`) | The project can promote from `rc` to `prod` with approvals, migration ordering, smoke-test blockers, and rollback workflows/runbooks. | `Not started` | All Phase 7 work. |
| Production working and recoverable | Release fire-drill complete (`P7-T08`) | `prod` can be promoted intentionally, validated after deploy, and rolled back or forward-fixed through documented workflows. | `Not started` | Phase 7 staged deployment, approval, smoke, rollback, and drill evidence. |
| Security and reliability hardening baseline complete | Hardening baseline (`P8-T01`..`P8-T09`, `P8-T15`, `P8-T16`) | The platform has defined SLOs, load/capacity evidence, DB tuning, resilience controls, RBAC/network policies, secret rotation, SBOM/signing, security audit closure, error tracking, and incident routing. | `Not started` | Most of Phase 8, which depends on the deployed runtime and production-like traffic. |
| AI automation lane operational | Phase 10 AI automation (`P10-T01`..`P10-T09`) | The deferred AI-worker lane is running with guarded PR governance, managed Cloud Run execution, and optional alert-driven diagnostics that can create bounded remediation tasks. | `Not started` | All of Phase 10. |
| Everything online, operational, and reusable as the template baseline | Final certification (`P8-T10`, plus ADR upkeep in `P8-T18`) | The blueprint is not only running, but also hardened, documented, governable, and ready to be reused as the standard starting point for future projects. | `Not started` | Final hardening sign-off, template release tagging, and ADR/workflow backfill. |

## Fast-read sequence

1. `P2-T12` means the main product path already works locally.
2. `P5-T11` means the required `rc` cloud foundation can be recreated from zero.
3. `P6-T12` + `P6-T13` + `P6-T15` mean the first real cloud backend is deployed.
4. `P6-T06` + `P6-T08` + `P6-T14` + `P6-T10` mean `rc` is truly connected end to end.
5. `P3-T12` + `P3-T13` + `P3-T14` mean observability in `rc` is not just configured on paper, but actually working.
6. `P7-T08` means the project is operationally ready for controlled production use.
7. `P8-T10` means the platform is fully online, hardened, and ready to serve as the reusable blueprint baseline.

## Notes

- The current strongest completed milestone is the local end-to-end baseline (`P2-T12`).
- The main gap between "works locally" and "works in cloud" is Phase 5 plus the Cloud Run frontend/API routing work in Phase 6, with the gated prod CDN path following later.
- Observability is ahead at the code-and-runbook level, but not yet complete as a live `rc` capability because deployment wiring and validation are still pending.
- AI-worker implementation is now explicitly deferred to Phase 10 and no longer blocks the core platform baseline milestones.
- Production readiness is intentionally a later milestone; the plan requires `rc` deployment, smoke validation, and release-control workflows before claiming `prod` is ready.
