# Environment and Region Standard

## Purpose
Lock the baseline environment model, region standard, and runtime-path constraints so infrastructure and deployment work stays consistent across phases.

## Locked Environment Model
- `local`: developer machine runtime for fast feedback.
- `rc`: release-candidate environment used for integration, validation, and continuous deploy from `main`.
- `prod`: production environment for real users.

Notes:
- There is no separate long-lived `dev` or `staging` cloud environment in the current baseline.
- `rc` is the single non-prod cloud lane.

## Region Standard
- Primary region for `rc` and `prod`: `us-east4`.
- This standard applies to API runtime resources, Cloud SQL primary placement, artifact flows, and default deployment targets unless an ADR explicitly overrides it.

## Separation and Isolation Requirements

### Prod vs RC
- `prod` must remain fully separate from `rc`.
- Separation baseline includes:
  - separate GCP projects
  - separate databases (or at minimum separate DB names with isolated credentials)
  - separate secrets and IAM bindings
  - separate public domains/hostnames

### RC Internal Isolation
- RC must enforce strict boundary hygiene per service surface:
  - database boundary
  - secret scope boundary
  - domain boundary
- If GKE path is enabled later, namespace isolation is also required.

## API Runtime Path Baseline
- Baseline runtime path for first iteration: `Cloud Run`.
- Alternative runtime path: `GKE Autopilot + Helm`.
- Initial GKE cluster provisioning is deferred until explicitly needed.
- Runtime selection contract is defined in `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`.

Runtime selector baseline:
- `API_RUNTIME_PATH=cloud_run` (default)
- `API_RUNTIME_PATH=gke` (alternative, enable later)

## Compliance Rule
Any deviation from this standard (environment model, region, separation policy, or runtime default) requires an ADR update before implementation.
