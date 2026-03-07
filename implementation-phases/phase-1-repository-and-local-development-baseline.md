# Phase 1: Repository & Local Development Baseline

Detailed tasks: `implementation-phase-tasks/phase-1-repository-and-local-development-baseline-tasks.md`

- Create repository structure:
  - `frontend-web/` React app shell for authenticated product experience.
  - optional `frontend-public/` for corporate website/blog surface.
  - `backend-api/` Go API shell.
  - `backend-worker/` dedicated worker repository from day one.
  - `platform-ai-workers/` dedicated automation worker repository for task-to-code job runners.
  - additional backend repos for workers/processes when needed.
  - shared contracts repo (`platform-contracts/`) if cross-repo protobuf sharing is required.
  - infra repo (`platform-infra/`) for Terraform and Helm (recommended for centralized ops control).
- Add dev tooling:
  - Makefile/task runner.
  - pre-commit hooks.
  - lint/format configs for JS/TS and Go.
  - frontend package manager standardized to `npm`.
- Add Dockerfiles for `frontend-web` and `backend-api`.
- Centralize local Compose orchestration in `platform-infra`.
- Use a hybrid local-dev model by default:
  - when developing frontend, run `frontend-web` natively and Compose runs `backend-api` + `postgres`
  - when developing API, run `backend-api` natively and Compose runs `frontend-web` + `postgres`
  - keep workers out of the default frontend/API stack until later phase work requires them
- Expose repo-local `make` targets that invoke the centralized Compose setup rather than duplicating stack definitions in each repo.
- Local observability components remain out of scope by default.
- Ensure AI worker baseline supports poll-loop processing for both ready tasks and rework tasks, with event-triggered cloud wake-ups for review rework loops.
- Ensure AI worker uses one poll-loop logic across runtimes: local runs continuously (sleep + re-poll), cloud runs bounded and exits on idle/limits waiting for next wake-up trigger.
- Ensure AI worker local/cloud parity: same container image and runtime entrypoint must run locally and in Cloud Run Jobs (config/adapters only differ).

Exit criteria:
- Developers can bring up the frontend-focused or API-focused local stack from the relevant repo using shared Compose definitions in `platform-infra`.
- Basic health checks are reachable for the frontend/API/Postgres local flow.

## Open Questions / Choices To Clarify Later
- None currently.
