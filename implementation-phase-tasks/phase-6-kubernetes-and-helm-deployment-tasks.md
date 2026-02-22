# Phase 6 Tasks: Kubernetes + Helm Deployment

## Goal
Deploy API and worker to GKE via Helm and establish authenticated frontend CDN delivery with API ingress routing.

## Tasks

### P6-T01: Define Kubernetes namespace and release naming standards
Owner: Agent  
Type: Deployment design  
Dependencies: Phase 5 infra baseline  
Action: Document namespace strategy per environment and Helm release naming scheme, including strict RC isolation boundaries (separate namespaces, DB boundaries, secret scope, and domains).  
Output: Deployment naming conventions doc.  
Done when: All manifests/charts reference consistent namespace/release names.

### P6-T02: Build Helm chart for API service
Owner: Agent  
Type: Coding  
Dependencies: P6-T01, Phase 2 API  
Action: Create chart templates for deployment, service, ingress, resources, probes, config, and secrets references.  
Output: API chart with env-specific values files.  
Done when: Chart deploys API successfully in `rc`.

### P6-T03: Build Helm chart for worker service
Owner: Agent  
Type: Coding  
Dependencies: P6-T01, Phase 2 worker  
Action: Create worker deployment chart templates with resources, probes, and config/secret injection.  
Output: Worker chart with env-specific values files.  
Done when: Worker deploys and reports healthy status in `rc`.

### P6-T04: Deploy and configure External Secrets Operator
Owner: Agent  
Type: Deployment/config  
Dependencies: Phase 5 GSM/IAM setup  
Action: Install ESO chart, define `SecretStore`/`ExternalSecret` objects for API/worker and related tokens.  
Output: Secrets sync runtime path operational.  
Done when: Kubernetes secrets are materialized from GSM and consumed by workloads.

### P6-T05: Configure NGINX ingress and TLS baseline
Owner: Agent  
Type: Deployment/config  
Dependencies: P6-T02  
Action: Define ingress resources using a single domain with path-based routing, managed TLS certificates, and baseline security headers; ensure `/api/*` routing is explicitly mapped to backend ingress/service targets.  
Output: API ingress routing configuration.  
Done when: API reachable securely through expected endpoint.

### P6-T06: Configure frontend CDN origin and delivery path
Owner: Human + Agent  
Type: Provider config + CI  
Dependencies: Phase 4 CI + Phase 5 infra  
Action: Set up authenticated frontend delivery on Cloud CDN + External HTTPS Load Balancer + Cloud Storage backend bucket, including cache headers, invalidation mechanism, and path rules compatible with `/api/*` backend routing under the same domain.  
Output: CDN-backed frontend hosting path.  
Done when: Authenticated frontend static assets are served via Cloud CDN in `rc` and coexist with working `/api/*` routing.

### P6-T07: Implement CI deployment jobs for Helm releases
Owner: Agent  
Type: CI/CD coding  
Dependencies: P6-T02, P6-T03, Phase 4 CI  
Action: Add GitHub Actions jobs that deploy API/worker charts on merge with environment protections.  
Output: Automated Helm-based deployment pipeline.  
Done when: Merge to `main` updates running workloads in `rc`.

### P6-T08: Implement CI frontend publish and CDN cache invalidation
Owner: Agent  
Type: CI/CD coding  
Dependencies: P6-T06, Phase 4 CI  
Action: Build frontend artifacts, publish to origin path, invalidate cache for changed files.  
Output: Automated frontend delivery pipeline.  
Done when: Frontend changes are visible after pipeline run without manual publish steps.

### P6-T09: Configure rollout safeguards and availability controls
Owner: Agent  
Type: Deployment config  
Dependencies: P6-T02, P6-T03  
Action: Add rolling strategy controls, min ready seconds, pod disruption constraints, and basic HPA placeholders.  
Output: Safer baseline rollout behavior.  
Done when: Deployment update does not cause service downtime in smoke tests.

### P6-T10: Execute end-to-end RC deployment validation
Owner: Human  
Type: Validation  
Dependencies: P6-T01..P6-T09  
Action: Validate full cloud path: frontend CDN -> Auth0 -> API ingress -> DB and worker health.  
Output: Deployment validation report with defects/issues.  
Done when: Phase 6 exit criteria are met and documented.

## Artifacts Checklist
- Helm charts for API and worker
- ESO manifests and secret mappings
- ingress and TLS configs
- frontend CDN configuration docs
- CI deployment workflows (backend and frontend)
- rollout safety configurations
- end-to-end deployment validation evidence
