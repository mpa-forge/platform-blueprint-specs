# Phase 2: Contracts, Service Skeletons, and Data Baseline

Detailed tasks: `implementation-phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`
Observability package contract artifact: `ops/observability-telemetry-budget-profile.md`

- Define protobuf contracts as the single source of truth for browser and internal APIs.
- Configure Buf workspace/module and generation templates.
- Keep Buf usage CLI-only in local/CI for baseline (no paid BSR dependency).
- Implement proto convention baseline:
  - package format `blueprint.<domain>.v<major>`
  - domain/version folder layout
  - `buf.yaml` lint and breaking policy (`STANDARD` + `FILE`)
  - pre-release shaping allowed until the first `contracts-vX.Y.Z` tag exists; strict breaking enforcement applies after the first contract release
  - deprecation/removal policy (one release-cycle grace, then next-major removal)
- Generate:
  - Go service stubs/handlers and message types.
  - TypeScript frontend clients/types via Connect ES.
  - Package generated TypeScript client with npm metadata for GitHub Packages publishing.
  - Commit generated artifacts to git as part of normal development flow.
- Implement Go API skeleton:
  - `chi`-based HTTP server, health/readiness, config loading, structured logging, auth middleware scaffold.
  - Enforce startup validation of the environment contract defined in Phase 1 and fail fast on missing or malformed required config.
  - Connect handlers mounted for proto-defined endpoints.
- Configure Clerk integration baseline:
  - OIDC/OAuth application setup for SPA + API.
  - Direct SPA bearer token model for baseline (no BFF token handling in this phase).
  - JWT validation against Clerk JWKS.
  - B2C claims mapping to the baseline profile (`sub`, optional `email`/`display_name`/`given_name`/`family_name`) and internal `user`/`admin` roles (no Organizations/SCIM assumptions).
- Create shared backend observability library package skeleton:
  - runtime mode config (`direct_otlp` for Cloud Run, `collector_gateway` for GKE path)
  - common resource attributes and telemetry initialization API
  - centralized `OBS_TELEMETRY_PROFILE` config contract hooks
- Add PostgreSQL migrations and seed script.
- Implement persistence layer scaffolding using `sqlc` with handwritten SQL and `pgx` runtime.

Exit criteria:
- API can query DB and return health/meta endpoint.
- At least one protected API endpoint validates JWT and enforces one role-based policy.
- Frontend consumes at least one generated TypeScript client from protobuf definitions (no manual DTO drift).
- Contract repo includes TypeScript package metadata and release conventions for GitHub Packages distribution.
- Contract repo includes documented versioning policy and release tags consumed by app repos.
- Shared observability library package compiles and is consumed by API startup in baseline mode; backend-worker integration is deferred to Phase 9.

## Open Questions / Choices To Clarify Later
- None currently.
