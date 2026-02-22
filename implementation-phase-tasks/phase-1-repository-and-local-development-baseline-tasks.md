# Phase 1 Tasks: Repository & Local Development Baseline

## Goal
Establish runnable local repositories and developer workflows that mirror the cloud architecture shape.

## Tasks

### P1-T01: Create repositories and initialize branch protections
Owner: Human  
Type: Repo setup  
Dependencies: Phase 0 sign-off  
Action: Create `frontend-web`, `backend-api`, dedicated `backend-worker`, `platform-contracts`, `platform-infra`; configure protected `main` branch and required reviewers.  
Output: Repositories created with baseline settings.  
Done when: All repos are accessible and protected policies are active.

### P1-T02: Scaffold repo directory structures and baseline READMEs
Owner: Agent  
Type: Coding  
Dependencies: P1-T01  
Action: Create standard folders (`cmd/`, `internal/`, `pkg/`, `deploy/`, `docs/` for Go repos; `src/`, `public/`, `scripts/` for frontend).  
Output: Initial skeleton committed in each repo.  
Done when: Every repo includes setup, run, and test instructions.

### P1-T03: Set language/tool versions and local toolchain bootstrap
Owner: Agent  
Type: Config  
Dependencies: P1-T02  
Action: Add `.tool-versions` or equivalent, Go version pinning, Node version pinning, `npm` as the standardized frontend package manager, and bootstrap scripts.  
Output: `make bootstrap` or equivalent task works on a clean machine.  
Done when: A new developer can install dependencies with one command.

### P1-T04: Add lint/format and pre-commit hooks
Owner: Agent  
Type: Config  
Dependencies: P1-T03  
Action: Configure Go lint/format, TS lint/format, markdown/yaml lint, and pre-commit hook wiring.  
Output: Standardized lint commands in all repos.  
Done when: Pre-commit checks run locally and fail on known violations.

### P1-T05: Implement local environment variable strategy
Owner: Agent  
Type: Config  
Dependencies: P1-T02  
Action: Add `.env.example` files and config loading patterns per service with validation for required variables.  
Output: Environment contract docs and examples.  
Done when: Services fail fast with clear messages when env is missing.

### P1-T06: Add Dockerfiles for frontend/API/worker
Owner: Agent  
Type: Coding  
Dependencies: P1-T02  
Action: Build multi-stage Dockerfiles with minimal runtime images and healthcheck-compatible startup commands.  
Output: Buildable local container images.  
Done when: `docker build` succeeds for all services.

### P1-T07: Create root/local `docker-compose.yml`
Owner: Agent  
Type: Coding  
Dependencies: P1-T05, P1-T06  
Action: Compose file runs minimal local stack (frontend, API, worker, and Postgres) with stable networking and startup order; exclude local observability components by default.  
Output: Local stack orchestration.  
Done when: `docker compose up` brings all components to healthy state.

### P1-T08: Add health endpoints and smoke script
Owner: Agent  
Type: Coding  
Dependencies: P1-T07  
Action: Implement or stub `healthz` checks and add `scripts/local-smoke-test.sh`/`.ps1`.  
Output: Automated local sanity check script.  
Done when: Smoke script validates API and worker health.

### P1-T09: Define local data bootstrap
Owner: Agent  
Type: Coding  
Dependencies: P1-T07  
Action: Add init scripts for Postgres schema seed placeholders used by Phase 2.  
Output: Deterministic local DB startup data.  
Done when: Local stack starts with queryable baseline rows.

### P1-T10: Developer onboarding dry run
Owner: Human  
Type: Validation  
Dependencies: P1-T01..P1-T09  
Action: Have one fresh machine run bootstrap from docs without verbal help; capture friction points.  
Output: Updated onboarding docs and resolved blockers.  
Done when: New developer setup completes within targeted time window.

## Artifacts Checklist
- Repository settings screenshots/exports
- Baseline repo skeleton commits
- Toolchain/bootstrap scripts
- Lint/pre-commit configs
- `.env.example` contracts
- Dockerfiles for frontend/API/worker
- `docker-compose.yml`
- local smoke test scripts
- onboarding runbook updates
