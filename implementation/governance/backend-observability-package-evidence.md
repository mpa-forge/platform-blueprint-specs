# P2-T13 Backend Observability Package Evidence

## Summary

`P2-T13` is complete.

The task created a new shared repository,
`github.com/mpa-forge/platform-observability`, added the Phase 2 backend
observability runtime package there, archived the completed OpenSpec change into
canonical repo specs, and wired `backend-api` startup to initialize and shut
down the shared runtime.

## Merged Changes

### platform-observability implementation

- PR: `https://github.com/mpa-forge/platform-observability/pull/1`
- Merged commit: `3487966`
- Result:
  - new repo bootstrap baseline for the shared package
  - Go module `github.com/mpa-forge/platform-observability`
  - package `github.com/mpa-forge/platform-observability/backendobs`
  - shared runtime config for:
    - `disabled`
    - `direct_otlp`
    - `collector_gateway`
  - shared profile hook for:
    - `balanced`
    - `cost`
    - `debug`
  - shared startup metadata and shutdown lifecycle handle
  - traces, metrics, and logs exporter initialization path for enabled modes

### platform-observability archive follow-up

- PR: `https://github.com/mpa-forge/platform-observability/pull/2`
- Merged commit: `97b702e`
- Result:
  - archived OpenSpec change
  - canonical spec created at:
    - `openspec/specs/backend-observability-runtime/spec.md`

### backend-api integration

- PR: `https://github.com/mpa-forge/backend-api/pull/33`
- Merged commit: `c5583a7`
- Result:
  - `OBS_TELEMETRY_PROFILE` added to runtime config parsing with allowed values
    `balanced`, `cost`, and `debug`
  - `cmd/api` now initializes the shared `backendobs` runtime
  - startup logs now surface observability metadata including mode and profile
  - API shutdown now closes the shared runtime cleanly
  - runtime docs and OpenSpec spec updated to reflect the new shared contract

## Validation

### platform-observability checks

- `make lint`
- `make test`
- `make format-check`
- `make sync-agent-skills-check`
- `python -m pre_commit run --files ... --show-diff-on-failure` on:
  - `.gitattributes`
  - `README.md`
  - `AGENTS.md`
  - `.pre-commit-config.yaml`
  - `docs/backend-observability-runtime.md`
  - `openspec/changes/scaffold-backend-observability-package/proposal.md`
  - `openspec/changes/scaffold-backend-observability-package/design.md`
  - `openspec/changes/scaffold-backend-observability-package/tasks.md`
  - `openspec/changes/scaffold-backend-observability-package/specs/backend-observability-runtime/spec.md`
- `python -m pre_commit run --files ... --show-diff-on-failure` on:
  - `openspec/specs/backend-observability-runtime/spec.md`
  - `openspec/changes/archive/2026-04-04-scaffold-backend-observability-package/proposal.md`
  - `openspec/changes/archive/2026-04-04-scaffold-backend-observability-package/design.md`
  - `openspec/changes/archive/2026-04-04-scaffold-backend-observability-package/tasks.md`
  - `openspec/changes/archive/2026-04-04-scaffold-backend-observability-package/specs/backend-observability-runtime/spec.md`

### backend-api checks

- `go test ./...`
- `make lint`
- `make format-check`
- `python -m pre_commit run --files ... --show-diff-on-failure` on:
  - `cmd/api/main.go`
  - `cmd/api/main_test.go`
  - `internal/config/config.go`
  - `internal/config/config_test.go`
  - `internal/api/runtime.go`
  - `README.md`
  - `docs/api-runtime.md`
  - `docs/api-runtime-paths-cloud-run-gke.md`
  - `go.mod`
  - `go.sum`
  - `openspec/specs/api-runtime/spec.md`

## Notes

- The Phase 2 package intentionally centralizes startup configuration,
  resource labels, exporter bootstrap, and lifecycle handling only.
  Richer instrumentation policy is still deferred to Phase 3.
- `backend-worker` adoption remains deferred to Phase 9.
