# Phase 2: Contracts, Service Skeletons, and Data Baseline

Detailed tasks: `implementation/phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`
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
- Define the frontend application architecture baseline needed for the first
  authenticated feature flow:
  - route map and protected-route behavior
  - real sign-in and sign-up route flow rather than placeholder auth links
  - app-shell/page structure for authenticated pages
  - generated client transport/wiring pattern
  - baseline query/mutation conventions for frontend data access
  - feature-folder and shared-module boundaries in `frontend-web`
- Implement Go API skeleton:
  - `chi`-based HTTP server, health/readiness, config loading, structured logging, auth middleware scaffold.
  - Enforce startup validation of the environment contract defined in Phase 1 and fail fast on missing or malformed required config.
  - Connect handlers mounted for proto-defined endpoints.
- Configure Clerk integration baseline:
  - OIDC/OAuth application setup for SPA + API.
  - Direct SPA bearer token model for baseline (no BFF token handling in this phase).
  - JWT validation against Clerk JWKS.
  - B2C claims mapping to the baseline profile (`sub`, optional `email`/`display_name`/`given_name`/`family_name`) and internal `user`/`admin` roles (no Organizations/SCIM assumptions).
  - Persisted user lookups use the verified Clerk `sub` directly as the local external identity key.
- Create shared backend observability library package skeleton:
  - runtime mode config (`direct_otlp` for Cloud Run, `collector_gateway` for GKE path)
  - common resource attributes and telemetry initialization API
  - centralized `OBS_TELEMETRY_PROFILE` config contract hooks
- Add PostgreSQL migrations and seed script.
- Implement persistence layer scaffolding using `sqlc` with handwritten SQL and `pgx` runtime.
- Add explicit local profile provisioning after authentication so the first
  authenticated frontend flow can create a `user_profiles` row keyed by Clerk
  `sub` before the standard read path is used.

Exit criteria:
- API can query DB and return health/meta endpoint.
- At least one protected API endpoint validates JWT and enforces one role-based policy.
- Frontend consumes at least one generated TypeScript client from protobuf definitions (no manual DTO drift).
- Frontend bootstrap for published contract packages includes a documented
  GitHub Packages consumer-auth path that future frontend repos can reuse
  without committing credentials.
- Frontend route structure, protected-route behavior, and data-access pattern are
  explicit enough that the next feature can follow the existing baseline instead
  of inventing new app structure.
- Frontend auth entry routes (`/sign-in`, `/sign-up`, or the documented
  equivalent) lead to a real Clerk auth flow and return the user to the
  protected app path after successful sign-in.
- Contract repo includes TypeScript package metadata and release conventions for GitHub Packages distribution.
- Contract repo includes documented versioning policy and release tags consumed by app repos.
- Shared observability library package compiles and is consumed by API startup in baseline mode; backend-worker integration is deferred to Phase 9.

## Open Questions / Choices To Clarify Later
- None currently.
