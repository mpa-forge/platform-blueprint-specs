# P1-T07 Local Compose Stack Evidence

## Scope

Implemented the centralized Phase 1 local development stack in `platform-infra` and the repo-local wrappers needed by `frontend-web` and `backend-api`.

## Merged repositories

- `platform-infra`
  - PR: `mpa-forge/platform-infra#9`
  - merge commit: `9d7c6ae`
- `frontend-web`
  - PR: `mpa-forge/frontend-web#10`
  - merge commit: `029da02`
- `backend-api`
  - PR: `mpa-forge/backend-api#12`
  - merge commit: `8809614`

## Delivered artifacts

- Central compose definition:
  - `platform-infra/local/compose.yml`
- Central stack documentation:
  - `platform-infra/docs/local-development-stack.md`
- Central orchestration targets:
  - `platform-infra/Makefile`
- Frontend repo-local wrappers and runtime baseline:
  - `frontend-web/Makefile`
  - `frontend-web/package.json`
  - `frontend-web/Dockerfile`
  - `frontend-web/index.html`
  - `frontend-web/src/App.tsx`
  - `frontend-web/src/main.tsx`
  - `frontend-web/vite.config.ts`
- API repo-local wrappers:
  - `backend-api/Makefile`
  - `backend-api/README.md`

## Local stack model implemented

- Frontend-focused mode:
  - native `frontend-web`
  - compose `backend-api` + `postgres`
- API-focused mode:
  - native `backend-api`
  - compose `frontend-web` + `postgres`
- Default worker repos remain outside the stack.
- Native reload is manual: rerun `make run` after code changes.

## Validation performed

Validated successfully on this workstation:

- `frontend-web`
  - `npm run lint`
  - `npm run build`
- `platform-infra`
  - `docker compose -f local/compose.yml --profile frontend-support up -d --build --remove-orphans`
  - `Invoke-WebRequest http://localhost:8080/healthz` -> `ok`
  - `docker compose -f local/compose.yml --profile frontend-support --profile api-support down --remove-orphans`
  - `docker compose -f local/compose.yml --profile api-support up -d --build --remove-orphans`
  - `Invoke-WebRequest http://localhost:3000` -> frontend HTML returned
  - `docker compose -f local/compose.yml --profile frontend-support --profile api-support down --remove-orphans`

## Known validation limit

This workstation still does not have `go` or GNU `make` on `PATH`.

As a result:

- the native `backend-api` run path (`make run`) was implemented but not executed locally here
- the repo-local `make` wrapper entrypoints were implemented but their behavior was validated indirectly through the underlying `docker compose` and frontend npm commands rather than through `make` itself

This gap should be closed during `P1-T10` on a machine with the full toolchain installed.
