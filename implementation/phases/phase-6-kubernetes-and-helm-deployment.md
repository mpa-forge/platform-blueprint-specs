# Phase 6: Runtime Deployment (Cloud Run Baseline + GKE Helm Alternative)

Detailed tasks: `implementation/phase-tasks/phase-6-kubernetes-and-helm-deployment-tasks.md`
Runtime selection artifact: `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`

- Baseline path (first iteration): deploy API on Cloud Run.
  - configure service revisions, probes/timeouts/concurrency/scaling parameters
  - configure GSM-based secret injection and Cloud SQL connectivity
  - route `/api/*` to Cloud Run backend through single-domain edge routing
- Alternative path (when enabled): deploy API on GKE via Helm in the baseline phases; backend-worker deployment is deferred to Phase 9.
  - configure probes, resources, autoscaling
  - configmaps/secrets wiring
  - deploy External Secrets Operator and define SecretStore/ExternalSecret mappings
  - ingress (NGINX) and TLS
- Implement pipeline-driven deployment via GitHub Actions for selected runtime path.
- Ensure Helm deployment path supports cluster recreation (fresh cluster bootstrap and redeploy without manual drift) when GKE path is enabled.
- API ingress routing uses a single domain with path-based routing.
- TLS certificate management defaults to managed certificates.
- Authenticated frontend delivery is standardized on Cloud CDN + External HTTPS Load Balancer + Cloud Storage backend bucket.
- Path routing baseline on the single domain:
  - frontend app/static assets served from CDN path.
  - `/api/*` routed to selected backend runtime path (Cloud Run baseline, ingress/service path for GKE).
- Frontend serving path execution:
  - Authenticated app: deploy static assets via CDN path (CI publish + cache invalidation) and route API via `/api/*` backend mapping.
  - Public website/blog: choose between CDN/static hosting path and in-cluster hosting path.

Exit criteria:
- End-to-end deployment running in RC environment with Cloud Run API baseline.
- RC isolation boundaries validated (DB boundary, secret scope, and domain separation; namespace boundary when GKE path is enabled).
- Safe rollout behavior validated for selected runtime path.

## Open Questions / Choices To Clarify Later
- None currently.
