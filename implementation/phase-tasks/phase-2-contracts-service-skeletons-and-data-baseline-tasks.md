# Phase 2 Tasks: Contracts, Service Skeletons, and Data Baseline

## Goal
Implement the contract-first frontend/API baseline with authenticated API access and persistent data foundations.

## Tasks

### P2-T01: Bootstrap `platform-contracts` with Buf configuration
Owner: Agent  
Type: Coding  
Dependencies: Phase 1 complete  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/contracts-buf-baseline-evidence.md`  
Action: Add `buf.yaml`, `buf.gen.yaml`, lint/breaking rules, module naming, and README; standardize on Buf CLI execution in local/CI and avoid paid BSR dependencies in baseline.  
Output: Contract repo with enforceable policy.  
Done when: `buf lint` and `buf breaking` pass locally and in CI with no dependency on paid Buf features.

### P2-T02: Define v1 protobuf service and messages
Owner: Agent  
Type: Coding  
Dependencies: P2-T01  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/contracts-v1-user-service-evidence.md`  
Action: Create one `v1` service, unary RPC, and request/response models for placeholder data retrieval.  
Output: Initial protobuf contract committed.  
Done when: Contract represents one protected endpoint used by frontend and API.

### P2-T03: Configure code generation pipelines for Go and TypeScript
Owner: Agent  
Type: Coding  
Dependencies: P2-T02  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/contracts-codegen-evidence.md`  
Action: Generate `connect-go` and Connect ES clients/types; add reproducible generation scripts and commit generated artifacts to git; add npm package metadata in `platform-contracts` for the generated TypeScript client intended for GitHub Packages publishing.  
Output: Generated code artifacts, package metadata, and generation command docs.  
Done when: Regeneration produces zero drift after clean checkout and package metadata is version-ready.

### P2-T04: Implement API runtime skeleton (`chi` + `connect-go`)
Owner: Agent  
Type: Coding  
Dependencies: P2-T03  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/backend-api-runtime-skeleton-evidence.md`  
Action: Add server bootstrapping, `chi` routing, health/readiness endpoints, structured logging, config loading, and startup validation of required environment variables defined in `P1-T05`, with fail-fast errors for missing or malformed config. Follow `common/standards/code-documentation.md` for package docs, exported symbol comments, and non-obvious runtime behavior.
Output: Runnable API service skeleton.  
Done when: API starts and serves health endpoints with valid config, and exits early with clear messages when required env is missing or invalid.

### P2-T05: Implement Clerk JWT verification middleware
Owner: Agent  
Type: Coding  
Dependencies: P2-T04  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/backend-api-auth-middleware-evidence.md`  
Action: Integrate Clerk issuer/audience checks, JWKS retrieval, claim extraction, role mapping (`user`/`admin`).  
Output: Auth middleware and tests.  
Done when: Protected endpoint returns `401/403` correctly and passes auth tests.

### P2-T06: Configure Clerk app/instances for SPA and API
Owner: Human  
Type: Provider configuration  
Dependencies: P2-T05  
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/clerk-app-configuration-evidence.md`
Action: Create SPA app, API audience, callback/logout URLs, test user roles, token lifetimes, configure direct SPA bearer token usage (no BFF in baseline), and ensure session token claims expose the baseline profile/role fields expected by the API (`sub`, optional `email`/`display_name`/`given_name`/`family_name`, and optional `role` or `roles`).  
Output: Clerk config values and environment mappings documented.  
Done when: Frontend can authenticate and obtain valid access token for API.

### P2-T07: Build worker skeleton with pluggable async adapter
Owner: Agent  
Type: Coding  
Dependencies: P2-T04  
Status: Moved to Phase 9 (`P9-T01`)  
Action: Add worker startup loop, graceful shutdown, periodic no-op job, health endpoint, structured logs, and startup validation of required environment variables defined in `P1-T05`, with fail-fast errors for missing or malformed config. Follow `common/standards/code-documentation.md` for package docs, exported symbol comments, and non-obvious runtime behavior.
Output: Runnable worker service baseline.  
Done when: Worker executes periodic task and exposes health with valid config, and exits early with clear messages when required env is missing or invalid.

### P2-T08: Implement Postgres schema migration and seed baseline
Owner: Agent  
Type: Coding  
Dependencies: P2-T04  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/backend-api-migrations-evidence.md`  
Action: Add migration tooling, one baseline table, and deterministic seed dataset.  
Output: Migration + seed scripts committed.  
Done when: Fresh DB can be migrated and seeded automatically.

### P2-T09: Add typed DB access layer (`sqlc` + handwritten SQL with `pgx` runtime)
Owner: Agent  
Type: Coding  
Dependencies: P2-T08  
Status: Completed (`2026-03-22`)  
Evidence: `implementation/governance/backend-api-profile-provisioning-evidence.md`  
Action: Define handwritten SQL queries, generate typed accessors with `sqlc`, and wire one API handler to DB read through `pgx`, using the verified Clerk `sub` directly as `user_profiles.clerk_user_id`. Add explicit profile provisioning so the first authenticated user flow creates the local `user_profiles` row before `GetCurrentUser` performs its read path.  
Output: Typed persistence layer plus explicit profile bootstrap flow used by protected endpoint.  
Done when: An authenticated user without a local row can be provisioned explicitly, and the endpoint then returns placeholder data from Postgres rather than static in-memory data.

### P2-T10: Integrate generated TypeScript client in frontend
Owner: Agent  
Type: Coding  
Dependencies: P2-T03, P2-T06  
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/frontend-protected-api-integration-evidence.md`
Action: Use generated client in authenticated page call to API with bearer token flow; structure consumption so it can switch from local/workspace source to versioned GitHub Packages dependency without code changes. Include the repo-local GitHub Packages consumer-auth/bootstrap pattern needed for Bun-based frontend repos to install the published package without committing credentials, and document how future frontend repos forked from this baseline preserve that bootstrap path. This task also provides the final frontend token-acquisition proof needed to close `P2-T06`.  
Output: Frontend-to-API typed integration.  
Done when: Frontend protected page renders data from protected API call, the resulting sign-in/token flow is sufficient to mark `P2-T06` complete, and the frontend repo documents the GitHub Packages consumer bootstrap path for future frontend forks.

### P2-T10A: Define frontend routing and protected app-shell baseline
Owner: Agent
Type: Documentation/Coding
Dependencies: P2-T06
Status: Completed (`2026-03-30`)
Evidence: `implementation/governance/frontend-routing-app-shell-evidence.md`
Action: Establish the authenticated frontend route map and app-shell structure in
`frontend-web`, including public entry routes if needed, protected route
behavior, Clerk-driven sign-in/sign-out handoff, unauthorized/loading states,
and the minimum page layout expected for the first protected feature flow.
Output: Canonical frontend routing/app-shell baseline and initial route wiring.
Done when: `frontend-web` has a documented and implemented baseline route
structure that makes it clear where protected feature pages live and how
unauthenticated users are redirected or blocked.

### P2-T10B: Define generated client wiring and data-fetching conventions
Owner: Agent
Type: Documentation/Coding
Dependencies: P2-T03, P2-T10A
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/frontend-generated-client-query-conventions-evidence.md`
Action: Define and implement the frontend integration pattern for generated
`platform-contracts` clients, including transport/client construction,
bearer-token injection, environment-based API base URL selection, error mapping,
and the baseline query/mutation conventions for frontend data access. Align the
conventions with the locked React Router + TanStack Query frontend stack so the
first protected flow establishes the reusable fetch pattern for later features.
Output: Shared frontend API-client wiring and documented data-fetching/query
conventions.
Done when: `frontend-web` contains one reusable generated-client integration
path and one documented query/mutation pattern that later feature work can copy
without inventing new transport or cache conventions.

### P2-T10C: Define frontend feature/module boundary conventions
Owner: Agent
Type: Documentation/Coding
Dependencies: P2-T10A, P2-T10B
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/frontend-module-boundaries-evidence.md`
Action: Define the initial frontend source layout for pages, shared UI,
feature-local components, stores, API adapters, and route modules so feature
work can grow without collapsing into a flat `src/` tree. Document when code
belongs in app-wide shared modules versus feature-scoped folders.
Output: Baseline frontend folder/module-boundary convention and initial repo
layout changes in `frontend-web`.
Done when: The repo contains a documented and embodied module layout that
future feature work can follow consistently for routes, stores, and API-facing
code.

### P2-T10D: Implement frontend sign-in and sign-up route flow
Owner: Agent
Type: Coding
Dependencies: P2-T06, P2-T10A
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/frontend-auth-entry-flow-evidence.md`
Action: Implement the missing `/sign-in` and `/sign-up` route flow in
`frontend-web` using the chosen Clerk SPA route model so auth links no longer
reload the same shell. The task must render real auth UI or perform the intended
Clerk redirect behavior, then return the user to the protected app flow after
successful authentication.
Output: Working frontend auth entry routes and post-auth redirect behavior.
Done when: Navigating to `/sign-in` or `/sign-up` reaches a real auth flow,
successful authentication returns the user to the protected app path, and the
frontend is capable of completing the protected profile proof required by
`P2-T10` and `P2-T12`.

### P2-T11: Contract versioning and release workflow setup
Owner: Agent  
Type: Documentation/CI  
Dependencies: P2-T01..P2-T03  
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/contract-release-workflow-evidence.md`
Action: Document release/tag policy for contracts, GitHub Packages npm publish conventions for the TypeScript client (`npm.pkg.github.com`, package scope/name, semver alignment with `contracts-vX.Y.Z` tags), and dependency pinning in consuming repos.  
Output: Versioning policy and release checklist.  
Done when: Teams can publish and consume a tagged contract release and have a clear package publish/install contract.

### P2-T12: End-to-end local validation
Owner: Human  
Type: Validation  
Dependencies: P2-T01..P2-T11  
Status: Completed (`2026-03-31`)
Evidence: `implementation/governance/phase-2-end-to-end-local-validation-evidence.md`
Action: Execute local full flow: login -> protected frontend call -> API -> DB.  
Output: Validation evidence and defect list.  
Done when: Baseline protected request works end-to-end locally.

### P2-T13: Scaffold shared backend observability library package
Owner: Agent  
Type: Coding  
Dependencies: P2-T04  
Status: Completed (`2026-04-04`)
Evidence: `implementation/governance/backend-observability-package-evidence.md`
Action: Create a reusable observability package for backend services with:
- runtime mode switch (`direct_otlp` for Cloud Run baseline, `collector_gateway` for GKE path),
- common resource/service labeling contract,
- initialization API for traces/metrics/logs exporters,
- `OBS_TELEMETRY_PROFILE` config hook points for later Phase 3 policy mapping,
- usage wiring in API startup (without final provider credentials hardcoding), aligned with `ops/observability-telemetry-budget-profile.md`. Backend-worker integration is deferred to Phase 9.  
Output: Shared observability library package and API integration stubs.  
Done when: API initializes observability through the shared package and runtime mode can be selected by config.

## Artifacts Checklist
- `buf.yaml`, `buf.gen.yaml`, generation scripts
- v1 protobuf definitions
- generated Go and TS clients
- TypeScript client package metadata and GitHub Packages publish conventions
- API runtime skeleton and auth middleware
- Clerk application/instance config docs
- DB migration and seed scripts
- typed query layer and API integration
- frontend protected page using generated client
- frontend routing/protected-route baseline
- frontend generated-client wiring and query conventions
- frontend module-boundary/layout convention
- local end-to-end validation notes
- shared observability library package skeleton and API integration stubs
