# Phase 2: Contracts, Service Skeletons, and Data Baseline

Detailed tasks: `implementation-phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`

- Define protobuf contracts as the single source of truth for browser and internal APIs.
- Configure Buf workspace/module and generation templates.
- Keep Buf usage CLI-only in local/CI for baseline (no paid BSR dependency).
- Implement proto convention baseline:
  - package format `dynamicplaylists.<domain>.v<major>`
  - domain/version folder layout
  - `buf.yaml` lint and breaking policy (`STANDARD` + `FILE`)
  - deprecation/removal policy (one release-cycle grace, then next-major removal)
- Generate:
  - Go service stubs/handlers and message types.
  - TypeScript frontend clients/types via Connect ES.
  - Commit generated artifacts to git as part of normal development flow.
- Implement Go API skeleton:
  - Native `net/http` server, health/readiness, config loading, structured logging, auth middleware scaffold.
  - Connect handlers mounted for proto-defined endpoints.
- Configure Auth0 integration baseline:
  - OIDC/OAuth application setup for SPA + API.
  - Direct SPA bearer token model for baseline (no BFF token handling in this phase).
  - JWT validation against Auth0 JWKS.
  - B2C claims mapping to internal roles (no Organizations/SCIM assumptions).
- Implement worker skeleton:
  - background process loop, graceful shutdown, and pluggable async adapter (queue can be added later).
- Add PostgreSQL migrations and seed script.
- Implement persistence layer scaffolding using `sqlc` with handwritten SQL and `pgx` runtime.

Exit criteria:
- API can query DB and return health/meta endpoint.
- Worker process runs scheduled or triggered no-op jobs with health/readiness.
- At least one protected API endpoint validates JWT and enforces one role-based policy.
- Frontend consumes at least one generated TypeScript client from protobuf definitions (no manual DTO drift).
- Contract repo includes documented versioning policy and release tags consumed by app repos.

## Open Questions / Choices To Clarify Later
- None currently.
