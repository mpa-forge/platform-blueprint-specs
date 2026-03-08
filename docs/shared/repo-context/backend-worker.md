# Repo Context: backend-worker

Load this file when working in `backend-worker`.

## Repo Role

- Own the product background worker runtime, separate from the AI automation worker.
- Start with a pluggable async adapter and no queue technology locked in yet.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/implementation-phases/phase-2-contracts-service-skeletons-and-data-baseline.md`
- `../platform-blueprint-specs/implementation-phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`

## Relevant Shared Constraints

- Queue strategy remains deferred until product requirements justify it.
- Worker should still have a clean runtime skeleton, health surface, structured logs, and startup config validation.
- Shared backend observability library will be introduced so API and worker use one telemetry contract.

## Consult Conditionally

- `../platform-blueprint-specs/platform-specification.md` only when the task needs broader platform architecture or deployment decisions.

## Typical Validation

- `make lint`
- `make test`
- `make format-check`
