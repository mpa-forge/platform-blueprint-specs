# Phase 6: Kubernetes + Helm Deployment

Detailed tasks: `implementation-phase-tasks/phase-6-kubernetes-and-helm-deployment-tasks.md`

- Build Helm charts for API, worker, and required in-cluster dependencies.
- Configure:
  - probes, resources, autoscaling
  - configmaps/secrets wiring
  - deploy External Secrets Operator and define SecretStore/ExternalSecret mappings
  - ingress (NGINX) and TLS
- Implement pipeline-driven deployment via GitHub Actions invoking Helm releases.
- Ensure Helm deployment path supports cluster recreation (fresh cluster bootstrap and redeploy without manual drift).
- API ingress routing uses a single domain with path-based routing.
- TLS certificate management defaults to managed certificates.
- Authenticated frontend delivery is standardized on Cloud CDN + External HTTPS Load Balancer + Cloud Storage backend bucket.
- Path routing baseline on the single domain:
  - frontend app/static assets served from CDN path.
  - `/api/*` routed to backend ingress/service path.
- Frontend serving path execution:
  - Authenticated app: deploy static assets via CDN path (CI publish + cache invalidation) and route API via ingress.
  - Public website/blog: choose between CDN/static hosting path and in-cluster hosting path.

Exit criteria:
- End-to-end deployment running in RC cluster/environment.
- RC isolation boundaries validated (namespace, DB boundary, secret scope, and domain separation).
- Zero-downtime app rollout validated.

## Open Questions / Choices To Clarify Later
- None currently.
