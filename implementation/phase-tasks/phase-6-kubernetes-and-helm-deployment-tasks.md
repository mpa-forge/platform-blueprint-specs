# Phase 6 Tasks: Runtime Deployment (Cloud Run Baseline + GKE Helm Alternative)

## Goal
Deploy the API runtime for RC with Cloud Run baseline and keep GKE+Helm deployment path fully documented/automatable as an alternative.

## Tasks

### P6-T01: Define runtime deployment naming standards
Owner: Agent  
Type: Deployment design  
Dependencies: Phase 5 infra baseline  
Affected repos: `backend-api`, `frontend-web`, `backend-worker`, `platform-ai-workers`, `platform-infra`
Action: Document deployment naming for both runtime paths:
- Cloud Run baseline: service names, revision tags, env/service-account conventions.
- GKE path: namespace strategy and Helm release naming scheme, including strict RC isolation boundaries (separate namespaces, DB boundaries, secret scope, and domains).  
Output: Deployment naming conventions doc.  
Done when: All manifests/charts reference consistent namespace/release names.

### P6-T12: Deploy API service on Cloud Run (baseline runtime)
Owner: Agent  
Type: Deployment/config  
Dependencies: P6-T01, P5-T04, Phase 2 API  
Affected repos: `backend-api`, `platform-infra`
Action: Configure and deploy API to Cloud Run with runtime settings (timeout, concurrency, min/max instances, CPU/memory), revision labeling, health endpoints, and zero-traffic validation before promotion.  
Output: Cloud Run API deployment configuration and first deployed revision in `rc`.  
Done when: API is reachable through Cloud Run URL and reports healthy readiness checks.

### P6-T13: Configure Cloud Run API secret and Cloud SQL integration
Owner: Agent  
Type: Deployment/config  
Dependencies: P6-T12, P5-T06, P5-T07  
Affected repos: `backend-api`, `platform-infra`
Action: Wire API runtime secrets from GSM and configure Cloud SQL connectivity for Cloud Run runtime (connector/connection settings, IAM/service account permissions, environment config).  
Output: Secure runtime connectivity configuration.  
Done when: Deployed Cloud Run API can perform authenticated DB reads with no plaintext secrets in deployment config.

### P6-T14: Configure single-domain `/api/*` routing to Cloud Run backend
Owner: Human + Agent  
Type: Provider config + deployment  
Dependencies: P6-T12, P6-T06, P5-T15  
Affected repos: `frontend-web`, `backend-api`, `platform-infra`
Action: Configure edge routing so the `rc` frontend remains Cloud Run-backed while `/api/*` routes to Cloud Run backend under the same domain, with managed TLS and required headers.  
Output: Unified domain routing config (`rc` frontend Cloud Run + Cloud Run API path, compatible with later prod CDN path).  
Done when: Frontend uses same-domain API path successfully in `rc`.

### P6-T15: Implement CI deployment jobs for Cloud Run API
Owner: Agent  
Type: CI/CD coding  
Dependencies: P6-T12, Phase 4 CI  
Affected repos: `backend-api`, `org-dot-github`
Action: Add GitHub Actions jobs to deploy API image revisions to Cloud Run on merge/tag, including rollout status checks and failure diagnostics.  
Output: Automated Cloud Run API deployment pipeline.  
Done when: Merge to `main` updates running Cloud Run API revision in `rc`.

### P6-T16: Validate Cloud Run scaling behavior and cold-start envelope
Owner: Human + Agent  
Type: Validation  
Dependencies: P6-T12, P6-T15  
Affected repos: `backend-api`
Action: Validate scale-to-zero behavior, cold-start recovery, readiness, and basic latency envelope under low/high traffic profiles; document operational settings and tradeoffs.  
Output: Cloud Run scaling validation report.  
Done when: Team has documented baseline scaling/cold-start expectations and tuning defaults.

### P6-T02: Build Helm chart for API service
Owner: Agent  
Type: Coding  
Dependencies: P6-T01, Phase 2 API  
Affected repos: `backend-api`, `platform-infra`
Action: GKE alternative path: create chart templates for deployment, service, ingress, resources, probes, config, and secrets references.  
Output: API chart with env-specific values files.  
Done when: Chart deploys API successfully in `rc`.

### P6-T03: Build Helm chart for worker service
Owner: Agent  
Type: Coding  
Dependencies: P6-T01, Phase 9 worker  
Affected repos: `backend-worker`, `platform-infra`
Status: Moved to Phase 9 (`P9-T04`)  
Action: GKE alternative path: create worker deployment chart templates with resources, probes, and config/secret injection.  
Output: Worker chart with env-specific values files.  
Done when: Worker deploys and reports healthy status in `rc`.

### P6-T04: Deploy and configure External Secrets Operator
Owner: Agent  
Type: Deployment/config  
Dependencies: Phase 5 GSM/IAM setup  
Affected repos: `platform-infra`, `backend-api`, `backend-worker`
Action: GKE alternative path: install ESO chart, define `SecretStore`/`ExternalSecret` objects for API and related tokens. Backend-worker secret wiring is deferred to Phase 9.  
Output: Secrets sync runtime path operational.  
Done when: Kubernetes secrets are materialized from GSM and consumed by workloads.

### P6-T05: Configure NGINX ingress and TLS baseline
Owner: Agent  
Type: Deployment/config  
Dependencies: P6-T02  
Affected repos: `platform-infra`, `backend-api`
Action: GKE alternative path: define ingress resources using a single domain with path-based routing, managed TLS certificates, and baseline security headers; ensure `/api/*` routing is explicitly mapped to backend ingress/service targets.  
Output: API ingress routing configuration.  
Done when: API reachable securely through expected endpoint.

### P6-T06: Configure frontend Cloud Run delivery path for RC
Owner: Human + Agent  
Type: Provider config + CI  
Dependencies: Phase 4 CI + Phase 5 infra  
Affected repos: `frontend-web`, `platform-infra`, `org-dot-github`
Action: Set up authenticated frontend delivery on Cloud Run for `rc`, including image/runtime configuration, service settings, domain/routing compatibility, and env contract needed to call the same-domain API path.  
Output: Cloud Run-backed frontend hosting path for `rc`.  
Done when: Authenticated frontend is served from Cloud Run in `rc` and coexists with working `/api/*` routing.

### P6-T06A: Configure gated prod frontend CDN origin and delivery path
Owner: Human + Agent  
Type: Provider config + CI  
Dependencies: Phase 4 CI, Phase 5 infra, P6-T06  
Affected repos: `frontend-web`, `platform-infra`, `org-dot-github`
Action: Define the prod authenticated frontend static delivery path on Cloud CDN + External HTTPS Load Balancer + Cloud Storage backend bucket, including cache headers, invalidation mechanism, and path rules compatible with `/api/*` backend routing under the same domain. Keep the prod frontend path disabled until prod rollout is intentional.  
Output: Gated prod CDN-backed frontend hosting path.  
Done when: The prod frontend CDN/static path can be planned and deployed behind explicit prod enablement controls without changing the `rc` Cloud Run frontend path.

### P6-T07: Implement CI deployment jobs for Helm releases
Owner: Agent  
Type: CI/CD coding  
Dependencies: P6-T02, P6-T03, Phase 4 CI  
Affected repos: `backend-api`, `backend-worker`, `org-dot-github`
Action: GKE alternative path: add GitHub Actions jobs that deploy API charts on merge with environment protections. Backend-worker deployment jobs are deferred to Phase 9.  
Output: Automated Helm-based deployment pipeline.  
Done when: Merge to `main` updates running workloads in `rc`.

### P6-T08: Implement CI frontend publish and CDN cache invalidation
Owner: Agent  
Type: CI/CD coding  
Dependencies: P6-T06, Phase 4 CI  
Affected repos: `frontend-web`, `org-dot-github`
Action: Build and deliver the frontend through the selected environment path: deploy the `rc` frontend to Cloud Run, and prepare the prod static publish + CDN cache invalidation flow for later gated prod enablement.  
Output: Automated frontend delivery pipeline for `rc`, plus gated prod static publish path.  
Done when: `rc` frontend changes are visible after pipeline run without manual deployment steps, and the prod static publish path is defined for later use.

### P6-T09: Configure rollout safeguards and availability controls
Owner: Agent  
Type: Deployment config  
Dependencies: P6-T02, P6-T03  
Affected repos: `backend-api`, `backend-worker`, `platform-infra`
Action: GKE alternative path: add rolling strategy controls, min ready seconds, pod disruption constraints, and basic HPA placeholders for the API path. Backend-worker rollout controls are deferred to Phase 9.  
Output: Safer baseline rollout behavior.  
Done when: Deployment update does not cause service downtime in smoke tests.

### P6-T10: Execute end-to-end RC deployment validation
Owner: Human  
Type: Validation  
Dependencies: P6-T01, P6-T06, P6-T12..P6-T16  
Affected repos: `frontend-web`, `backend-api`, `platform-infra`
Action: Validate full cloud path (Cloud Run baseline): frontend Cloud Run -> Clerk -> `/api/*` -> Cloud Run API -> DB read path.  
Output: Deployment validation report with defects/issues.  
Done when: Phase 6 exit criteria are met and documented.

### P6-T11: Validate cluster recreation deployment recovery path
Owner: Human + Agent  
Type: Validation  
Dependencies: P6-T01, P6-T02..P6-T09, P5-T12  
Affected repos: `platform-infra`, `backend-api`, `backend-worker`
Action: GKE alternative path: execute a controlled fresh-cluster deployment validation (bootstrap add-ons + Helm releases + smoke checks) using the prod/reusable lifecycle model defined in `ops/ephemeral-gke-cluster-lifecycle-requirements.md`; record steps needed to restore a cluster from zero to healthy workloads.  
Output: Cluster recreation validation report and deployment recovery checklist.  
Done when: Team can recover workloads on a newly created cluster with documented, repeatable steps and no manual drift corrections.

## Artifacts Checklist
- Cloud Run API service configuration and deployment evidence
- Helm charts for API
- ESO manifests and secret mappings
- ingress and TLS configs
- frontend Cloud Run configuration docs for `rc`
- gated prod frontend CDN/static delivery configuration docs
- CI deployment workflows (Cloud Run baseline backend + optional GKE backend + frontend)
- rollout safety configurations
- end-to-end deployment validation evidence
- cluster recreation/recovery validation evidence
- Cloud Run scaling/cold-start validation evidence
- runtime selection/runbook reference (`../backend-api/docs/api-runtime-paths-cloud-run-gke.md`)
