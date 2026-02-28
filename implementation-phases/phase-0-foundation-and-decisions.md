# Phase 0: Foundation & Decisions

Detailed tasks: `implementation-phase-tasks/phase-0-foundation-and-decisions-tasks.md`

- Confirmed: GCP + GKE as target platform.
- Confirmed: GKE Autopilot cluster mode.
- Confirmed: Polyrepo strategy (frontend and backend separated, with additional backend repos as needed).
- Confirmed: NGINX Ingress for portability.
- Deferred: queue/broker choice until product requirements justify it.
- Confirmed: Auth0 Free plan for external auth, B2C-first.
- Confirmed: Grafana Cloud managed observability (metrics, logs, traces, alerting).
  - Tier locked: Grafana Cloud Free (baseline).
- Confirmed: Proto-first contracts with Connect for browser compatibility.
- Confirmed: Native Go `net/http` runtime with `connect-go` handlers.
- Confirmed: Sentry for error tracking.
  - Tier locked: Sentry Developer (Free).
- Confirmed: incident.io for incident response workflow.
  - Tier locked: incident.io Basic (Free).
- Confirmed: GitHub Actions for CI/CD.
- Confirmed: GitHub Issues + GitHub Projects as task management platform.
- Confirmed: Single cross-repo project board workflow with standardized issue types, labels, states, and automation.
- Confirmed: AI task-to-code automation will be implemented via a dedicated `platform-ai-workers` repository.
- Confirmed: AI workers run as Cloud Run Jobs with hybrid triggering (scheduled cadence plus event-driven on-demand execution), one worker-job deployment per target repository.
- Confirmed: Worker-job configuration is environment-driven (target repo, worker id, credentials refs, and automation limits).
- Confirmed: Human review remains mandatory through draft PR + branch protection before merge.
- Confirmed: Google Artifact Registry for container images/artifacts.
- Confirmed: Cloud SQL for PostgreSQL hosting.
- Confirmed: Google Secret Manager + External Secrets Operator for secrets.
- Confirmed: CD operating model is pipeline-driven deployment with GitHub Actions + Helm.
- Confirmed: Environment model is Local + RC + prod, with prod fully separate.
- Confirmed: RC must enforce strict internal isolation boundaries (namespaces, DB boundaries, secrets, and domains).
- Confirmed: Primary GCP region for RC and prod is `us-east4`.
- Confirmed: Provider/account ownership model is single owner.
- Confirmed: Shared documentation and ADRs live in a dedicated docs repository.
- Confirmed: Frontend sequencing is authenticated app first.
- Confirmed: Authenticated frontend serving path is CDN-first.
- Confirmed: Queue/broker decision remains deferred until after the first end-to-end baseline implementation is complete.
- Define naming conventions, branch strategy, semantic versioning.
- Confirmed: SonarQube Cloud Free as baseline repository quality tier.

Exit criteria:
- Architecture decisions log created and approved.
- Initial repository structure agreed.

## Open Questions / Choices To Clarify Later
- None currently.
