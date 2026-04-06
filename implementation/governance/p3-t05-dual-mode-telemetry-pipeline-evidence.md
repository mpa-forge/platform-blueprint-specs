# P3-T05 Dual-Mode Telemetry Pipeline Evidence

## Summary

This note records the `2026-04-06` implementation pass for the
cross-repository `P3-T05` change.

The work completed in this session makes the dual-mode telemetry contract
concrete across:

- `platform-observability`
- `backend-api`
- `platform-infra`
- this planning repository

It does **not** claim that the overall Phase 3 task is fully complete in live
infrastructure yet. The remaining gap is deployable GKE runtime wiring and live
collector-path validation after Phase 5/6 roots exist.

## Repo Outputs

### `platform-observability`

Updated the shared `backendobs` runtime to make the profile hook operational:

- resolved profile policies now derive concrete trace-sampling behavior
- direct-mode trace export now preserves force-sample rules for:
  - errors
  - spans slower than `1s`
  - explicitly tagged debug or incident traffic
- direct-mode log export now honors a profile-derived minimum severity
- direct-mode request-duration metrics now reduce successful traffic in the
  `cost` profile
- startup diagnostics can now expose the resolved runtime policy through
  `Runtime.Policy()`

Primary files:

- `../platform-observability/backendobs/policy.go`
- `../platform-observability/backendobs/runtime.go`
- `../platform-observability/backendobs/helpers.go`
- `../platform-observability/backendobs/runtime_test.go`
- `../platform-observability/docs/backend-observability-runtime.md`

### `backend-api`

Updated the API service to consume and verify the richer shared runtime
contract:

- startup diagnostics now log the resolved trace sample ratio and force-sample
  threshold
- runtime tests now assert the direct OTLP path preserves the expected resource
  labels for:
  - service identity
  - deployment environment
  - runtime mode
  - telemetry profile
- service docs now describe the new direct-mode validation expectations

Primary files:

- `../backend-api/cmd/api/main.go`
- `../backend-api/cmd/api/main_test.go`
- `../backend-api/internal/api/observability_test.go`
- `../backend-api/docs/api-runtime.md`
- `../backend-api/docs/api-runtime-paths-cloud-run-gke.md`

### `platform-infra`

Made the collector path concrete without pretending the repo already has
deployable GKE roots:

- retained the ESO placeholder manifest for Grafana token delivery
- added a placeholder collector configuration with OTLP receivers,
  profile-derived tail sampling, and Grafana OTLP export
- added a placeholder workload env fragment for the future
  `collector_gateway` deployment path
- documented the rollout boundary between current Phase 3 placeholders and the
  later Phase 5/6 deployable implementation

Primary files:

- `../platform-infra/docs/placeholders/gke/backend-api-otlp-external-secret.yaml`
- `../platform-infra/docs/placeholders/gke/backend-api-observability-env.yaml`
- `../platform-infra/docs/placeholders/gke/backend-api-collector-gateway.yaml`
- `../platform-infra/docs/observability-secret-delivery.md`

### `platform-blueprint-specs`

Added the shared validation runbook and this evidence record so the repo
ownership and validation boundary are explicit.

Primary files:

- `docs/operations/telemetry-budget-profile-runbook.md`
- `implementation/governance/p3-t05-dual-mode-telemetry-pipeline-evidence.md`

## Validation

### `platform-observability`

- `go test ./...`
- `make format-check`
- `make lint`

### `backend-api`

- `go test ./...`
- `make format-check`
- `make lint`

### `platform-infra`

- `make format-check`
  - result: no Terraform format check is configured in the current baseline

## Remaining Gap

The following items are still deferred and should not be overstated:

- live GKE collector deployment from `platform-infra`
- live Grafana Cloud validation for the GKE collector path
- final evidence that both runtime paths satisfy the full Phase 3 acceptance
  target in deployed infrastructure

Until those are complete, this session should be treated as the code and
documentation baseline for `P3-T05`, not the final closeout of the overall
phase task.
