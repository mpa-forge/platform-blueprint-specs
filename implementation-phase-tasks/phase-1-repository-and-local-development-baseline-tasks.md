# Phase 1 Tasks: Repository & Local Development Baseline

## Goal
Establish runnable local repositories and developer workflows that mirror the cloud architecture shape.

## Tasks

### P1-T01: Create repositories and initialize branch protections
Owner: Human  
Type: Repo setup  
Dependencies: Phase 0 sign-off  
Status: Completed (`2026-03-06`); repositories finalized, initialized, made public, and branch protection baseline applied.  
Evidence: `docs/governance/repository-bootstrap-evidence.md`  
Action: Authoritatively provision the working repositories (`frontend-web`, `backend-api`, dedicated `backend-worker`, dedicated `platform-ai-workers`, `platform-contracts`, `platform-infra`) by creating any missing repos and converting Phase 0 placeholders into finalized repos; configure protected `main` branch with required checks and single-maintainer-compatible review rules (AI-generated PRs require human review).  
Output: Repositories created with baseline settings.  
Done when: All repos exist as finalized working repos, are accessible, and protected policies are active. Required status-check contexts may be attached later in `P4-T09` once CI workflows exist.

### P1-T02: Scaffold repo directory structures and baseline READMEs
Owner: Agent  
Type: Coding  
Dependencies: P1-T01  
Status: Completed (`2026-03-06`)  
Evidence: `docs/governance/repository-skeleton-evidence.md`  
Action: Create standard folders (`cmd/`, `internal/`, `pkg/`, `deploy/`, `docs/` for Go repos; `src/`, `public/`, `scripts/` for frontend).  
Output: Initial skeleton committed in each repo.  
Done when: Every repo includes setup, run, and test instructions.

### P1-T03: Set language/tool versions and local toolchain bootstrap
Owner: Agent  
Type: Config  
Dependencies: P1-T02  
Status: Completed (`2026-03-06`)  
Evidence: `docs/governance/toolchain-bootstrap-evidence.md`  
Action: Add `.tool-versions` or equivalent, Go version pinning, Node version pinning, `npm` as the standardized frontend package manager, and bootstrap scripts.  
Output: `make bootstrap` or equivalent task works on a clean machine.  
Done when: A new developer can install dependencies with one command.

### P1-T04: Add lint/format and pre-commit hooks
Owner: Agent  
Type: Config  
Dependencies: P1-T03  
Status: Completed (`2026-03-06`)  
Evidence: `docs/governance/lint-and-precommit-evidence.md`  
Action: Configure Go lint/format, TS lint/format, markdown/yaml lint, and pre-commit hook wiring.  
Output: Standardized lint commands in all repos.  
Done when: Pre-commit checks run locally and fail on known violations.

### P1-T05: Implement local environment variable strategy
Owner: Agent  
Type: Config  
Dependencies: P1-T02  
Status: Completed (`2026-03-07`)  
Evidence: `docs/governance/environment-contract-evidence.md`  
Action: Add `.env.example` files, environment naming conventions, and documented configuration contracts per service repo; define required vs optional variables and local placeholder/default expectations. Defer actual startup enforcement until Phase 2 when runnable service entrypoints exist.  
Output: Environment contract docs and examples.  
Done when: Each relevant repo has a clear `.env.example` baseline and documented env contract suitable for later startup validation in Phase 2.

### P1-T06: Add Dockerfiles for frontend and API
Owner: Agent  
Type: Coding  
Dependencies: P1-T02  
Status: Completed (`2026-03-07`)  
Evidence: `docs/governance/dockerfile-baseline-evidence.md`  
Action: Build multi-stage Dockerfiles for `frontend-web` and `backend-api` with minimal runtime images and healthcheck-compatible startup commands. Defer `backend-worker` and `platform-ai-workers` containerization until they are brought into the local stack or later worker-focused tasks.  
Output: Buildable local container images.  
Done when: `docker build` succeeds for `frontend-web` and `backend-api`.

### P1-T07: Create centralized local Compose stack in `platform-infra`
Owner: Agent  
Type: Coding  
Dependencies: P1-T05, P1-T06  
Status: Completed (`2026-03-07`)  
Evidence: `docs/governance/local-compose-stack-evidence.md`  
Action: Create the canonical local Compose orchestration in `platform-infra` for the shared development dependencies and supporting app services. The baseline model is hybrid:
- when developing frontend, run `frontend-web` natively and Compose runs `backend-api` + `postgres`
- when developing API, run `backend-api` natively and Compose runs `frontend-web` + `postgres`
- exclude `backend-worker` and `platform-ai-workers` from the default frontend/API flow for now
- expose repo-local `make` wrappers in app repos that invoke the centralized Compose definitions rather than duplicating stack files per repo
- keep local observability components out of scope by default  
Output: Centralized local stack orchestration plus repo-local developer entrypoints.  
Done when: A developer can start the frontend-focused or API-focused local stack from the relevant repo, with supporting services provided by Compose and the actively developed service running natively.

### P1-T08: Add health endpoints and smoke script
Owner: Agent  
Type: Coding  
Dependencies: P1-T07  
Status: Completed (`2026-03-07`)  
Evidence: `docs/governance/local-smoke-test-evidence.md`  
Action: Implement or stub `healthz` checks and add `scripts/local-smoke-test.sh`/`.ps1`.  
Output: Automated local sanity check script.  
Done when: Smoke script validates the frontend/API/Postgres development path, and worker health can remain deferred until worker runtime work is introduced.

### P1-T09: Define local data bootstrap
Owner: Agent  
Type: Coding  
Dependencies: P1-T07  
Status: Completed (`2026-03-07`)  
Evidence: `docs/governance/local-data-bootstrap-evidence.md`  
Action: Add init scripts for Postgres schema seed placeholders used by Phase 2.  
Output: Deterministic local DB startup data.  
Done when: Local stack starts with queryable baseline rows.

### P1-T10: Developer onboarding dry run
Owner: Human  
Type: Validation  
Dependencies: P1-T01..P1-T09  
Status: Completed (`2026-03-08`)  
Evidence: `docs/governance/onboarding-dry-run-evidence.md`  
Action: Have one fresh machine run bootstrap from docs without verbal help; capture friction points.  
Output: Updated onboarding docs and resolved blockers.  
Done when: New developer setup completes within targeted time window.

### P1-T11: Bootstrap `platform-ai-workers` repository baseline
Owner: Agent  
Type: Coding  
Dependencies: P1-T01, Phase 0 AI automation decisions, `ops/ai-comment-trigger-cloud-run-jobs.md`, `ops/ai-worker-local-cloud-parity.md`  
Status: Completed (`2026-03-08`)  
Evidence: `docs/governance/ai-worker-baseline-evidence.md`  
Action: Scaffold worker job codebase and container with configurable env vars (`WORKER_RUNTIME_MODE`, `WORKER_ID`, `TARGET_REPO`, `MAX_PENDING_REVIEW`, `POLL_INTERVAL`, credential secret refs), support for trigger context (`TRIGGER_SOURCE`, optional `TARGET_ISSUE`/`TARGET_PR`/`EVENT_ID`), shared GitHub poll-loop task selection logic (ready + rework candidates), task state transitions (`ai:ready` -> `ai:in-progress` -> `ai:ready-for-review`), and draft PR creation/update path aligned to `ops/ai-comment-trigger-cloud-run-jobs.md`. Implement the worker runtime as a Go application that invokes the coding agent as a subprocess CLI against the checked-out workspace. Implement one runtime entrypoint used by both local and Cloud Run executions, with environment-specific behavior only through lifecycle/config/adapters as defined in `ops/ai-worker-local-cloud-parity.md`.  
Output: Runnable automation worker baseline in dedicated repo.  
Done when: Worker can process one synthetic issue and produce a draft PR in a target sandbox repo, the agent is invoked through the documented subprocess CLI contract, and the same image/entrypoint can be invoked locally and in Cloud Run mode.

### P1-T12: Add worker lane safety and resume behavior
Owner: Agent  
Type: Coding  
Dependencies: P1-T11  
Action: Implement single-lane processing guard per worker id, deterministic claim-before-work behavior, retry/resume handling for `ai:in-progress` tasks, idempotent rework handling keyed by review/comment event id, and pending-review cap control with mode-specific lifecycle (`local`: wait and continue polling; `cloud`: exit and wait for next wake-up).  
Output: Safe worker execution loop with deterministic state transitions.  
Done when: Repeated runs do not duplicate claims and can resume interrupted tasks for the same worker lane.

### P1-T13: Run AI worker dry-run validation
Owner: Human + Agent  
Type: Validation  
Dependencies: P1-T11, P1-T12  
Action: Execute controlled dry-run against a sandbox repository and verify end-to-end path (issue selection, branch changes, draft PR creation, state updates, reviewer handoff, and comment/review-triggered rework updating the same PR) according to `ops/ai-comment-trigger-cloud-run-jobs.md`; include local/cloud parity checks per `ops/ai-worker-local-cloud-parity.md` by running equivalent inputs locally and via Cloud Run execution, including idle and outstanding-review-cap behavior.  
Output: `docs/automation/ai-worker-dry-run.md` with findings and fixes.  
Done when: One end-to-end task-to-draft-PR flow plus one rework loop succeeds under manual observation, and parity evidence confirms equivalent behavior for local and Cloud Run runs.

## Artifacts Checklist
- Repository settings screenshots/exports
- Baseline repo skeleton commits
- Toolchain/bootstrap scripts
- Lint/pre-commit configs
- `.env.example` contracts
- Dockerfiles for frontend/API
- `platform-ai-workers` bootstrap code and container
- `ops/ai-comment-trigger-cloud-run-jobs.md` conformance notes
- `ops/ai-worker-local-cloud-parity.md` conformance notes
- `platform-infra/local/compose.yml`
- local smoke test scripts
- AI worker dry-run report
- onboarding runbook updates
