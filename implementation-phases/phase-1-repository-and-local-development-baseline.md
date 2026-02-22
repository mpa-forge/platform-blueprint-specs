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
- Add Dockerfiles and `docker-compose.yml` for full local stack.
- Local stack scope is minimal by default: frontend, API, worker, and Postgres only (no local observability components required).

Exit criteria:
- `docker compose up` runs all core services.
- Basic health checks reachable for API and worker.

## Open Questions / Choices To Clarify Later
- None currently.
