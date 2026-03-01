# Phase 0: Foundation & Decisions

Detailed tasks: `implementation-phase-tasks/phase-0-foundation-and-decisions-tasks.md`

- Confirmed: GCP as target cloud platform.
- Confirmed: API runtime baseline is Cloud Run (scale-to-zero) for first iteration.
- Confirmed: GKE Autopilot remains an alternative runtime path; initial cluster creation is deferred until explicitly needed.
- Confirmed: Runtime selection contract is documented in `ops/api-runtime-paths-cloud-run-gke.md`.
- Confirmed: Polyrepo strategy (frontend and backend separated, with additional backend repos as needed).
- Confirmed: NGINX Ingress for GKE portability path.
- Deferred: queue/broker choice until product requirements justify it.
- Confirmed: Auth0 Free plan for external auth, B2C-first.
- Confirmed: Grafana Cloud managed observability (metrics, logs, traces, alerting).
  - Tier locked: Grafana Cloud Free (baseline).
- Confirmed: Observability runtime must support both Cloud Run direct OTLP export and GKE collector-gateway export through one shared configuration contract.
- Confirmed: Proto-first contracts with Connect for browser compatibility.
- Confirmed: Native Go `net/http` runtime with `connect-go` handlers.
- Confirmed: `platform-contracts` publishes generated TypeScript API client packages to GitHub Packages for frontend consumption.
- Confirmed: Sentry for error tracking.
  - Tier locked: Sentry Developer (Free).
- Confirmed: incident.io for incident response workflow.
  - Tier locked: incident.io Basic (Free).
- Confirmed: GitHub Actions for CI/CD.
- Confirmed: GitHub Issues + GitHub Projects as task management platform.
- Confirmed: Single cross-repo project board workflow with standardized issue types, labels, states, and automation.
- Confirmed: AI task-to-code automation will be implemented via a dedicated `platform-ai-workers` repository.
- Confirmed: AI workers use one shared GitHub poll-loop logic across local and cloud runtimes.
- Confirmed: Cloud runtime uses bounded Cloud Run Job executions and is primarily event-woken from GitHub task/review changes (optional scheduler backstop), one worker-job deployment per target repository.
- Confirmed: Worker-job configuration is environment-driven (target repo, worker id, credentials refs, and automation limits).
- Confirmed: AI workers must keep local/cloud runtime parity (same worker image and runtime entrypoint in local runs and Cloud Run Jobs).
- Confirmed: Human review remains mandatory through draft PR + branch protection before merge.
- Confirmed: Google Artifact Registry for container images/artifacts.
- Confirmed: Cloud SQL for PostgreSQL hosting.
- Confirmed: Google Secret Manager for secrets (direct integration on Cloud Run baseline; ESO on GKE path).
- Confirmed: CD baseline path is pipeline-driven deployment with GitHub Actions to Cloud Run; Helm path remains for GKE alternative.
- Confirmed: Environment model is Local + RC + prod, with prod fully separate.
- Confirmed: RC must enforce strict internal isolation boundaries (DB boundaries, secrets, and domains; namespaces when GKE path is enabled).
- Confirmed: Primary GCP region for RC and prod is `us-east4`.
- Confirmed: Provider/account ownership model is single owner.
- Confirmed: Shared documentation and ADRs live in a dedicated docs repository.
- Confirmed: Frontend sequencing is authenticated app first.
- Confirmed: Authenticated frontend serving path is CDN-first.
- Confirmed: Queue/broker decision remains deferred until after the first end-to-end baseline implementation is complete.
- Confirmed: External edge-provider layering decision (GCP-native edge only vs Cloudflare-like overlay) is deferred to hardening phase review; baseline remains GCP-native edge stack.
- Define naming conventions, branch strategy, semantic versioning.
- Confirmed: SonarQube Cloud Free as baseline repository quality tier.

Exit criteria:
- Architecture decisions log created and approved.
- Initial repository structure agreed.

## Open Questions / Choices To Clarify Later
- None currently.
