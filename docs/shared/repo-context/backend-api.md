# Repo Context: backend-api

Load this file when working in `backend-api`.

## Repo Role

- Own the browser-facing Go API service.
- Serve protobuf-defined endpoints through Connect-compatible handlers.
- Use `chi` as the HTTP routing layer for the API skeleton baseline.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/implementation-phases/phase-2-contracts-service-skeletons-and-data-baseline.md`
- `../platform-blueprint-specs/implementation-phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`

## Relevant Shared Constraints

- API contract model is proto-first with Connect-compatible endpoints.
- Go HTTP baseline is `chi` with `connect-go` handlers.
- Config must fail fast on missing or malformed required environment variables once runtime startup is implemented.
- Typed DB access baseline is `sqlc` with handwritten SQL and `pgx` runtime.

## Consult Conditionally

- `../platform-blueprint-specs/platform-specification.md` only when the task needs broader platform architecture context beyond the API baseline.

## Typical Validation

- `make lint`
- `make test`
- `make format-check`
