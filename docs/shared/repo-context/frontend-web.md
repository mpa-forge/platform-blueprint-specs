# Repo Context: frontend-web

Load this file when working in `frontend-web`.

## Repo Role

- Own the React SPA for the authenticated product application baseline.
- Consume generated TypeScript API clients from `platform-contracts`.
- In local development, usually run natively while support services come from `platform-infra`.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/implementation-phases/phase-1-repository-and-local-development-baseline.md`
- `../platform-blueprint-specs/implementation-phases/phase-2-contracts-service-skeletons-and-data-baseline.md`

## Relevant Shared Constraints

- Frontend is an authenticated SPA, CDN-oriented in cloud deployment.
- Frontend should consume generated contract clients rather than hand-written DTOs once Phase 2 integration is in place.
- Local frontend work should respect the hybrid local stack model documented in `platform-infra`.

## Typical Validation

- `make lint`
- `make format-check`
- repo-local build command from `README.md` when task touches runtime behavior
