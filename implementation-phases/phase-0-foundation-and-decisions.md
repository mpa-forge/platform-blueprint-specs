# Phase 0: Foundation & Decisions

Detailed tasks: `implementation-phase-tasks/phase-0-foundation-and-decisions-tasks.md`

- Confirmed: GCP + GKE as target platform.
- Confirmed: GKE Autopilot cluster mode.
- Confirmed: Polyrepo strategy (frontend and backend separated, with additional backend repos as needed).
- Confirmed: NGINX Ingress for portability.
- Deferred: queue/broker choice until product requirements justify it.
- Confirmed: Auth0 Free plan for external auth, B2C-first.
- Confirmed: Grafana Cloud managed observability (metrics, logs, traces, alerting).
- Confirmed: Proto-first contracts with Connect for browser compatibility.
- Confirmed: Native Go `net/http` runtime with `connect-go` handlers.
- Confirmed: Sentry for error tracking.
- Confirmed: incident.io for incident response workflow.
- Confirmed: GitHub Actions for CI/CD.
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

Exit criteria:
- Architecture decisions log created and approved.
- Initial repository structure agreed.

## Open Questions / Choices To Clarify Later
- None currently.
