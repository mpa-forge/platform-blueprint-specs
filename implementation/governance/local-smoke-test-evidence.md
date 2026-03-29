# P1-T08 Local Smoke Test Evidence

## Scope

Implemented the first reusable local smoke test for the Phase 1 stack and introduced a dedicated frontend health endpoint.

## Merged repositories

- `platform-infra`
  - PR: `mpa-forge/platform-infra#11`
  - merge commit: `725df45`
- `frontend-web`
  - PR: `mpa-forge/frontend-web#11`
  - merge commit: `b4aaf03`

## Delivered artifacts

- Central smoke scripts:
  - `platform-infra/scripts/local-smoke-test.ps1`
  - `platform-infra/scripts/local-smoke-test.sh`
- Central smoke entrypoint:
  - `platform-infra/Makefile` -> `make local-smoke-test`
- Central stack docs updated:
  - `platform-infra/README.md`
  - `platform-infra/docs/local-development-stack.md`
- Frontend dedicated health surface:
  - `frontend-web/public/healthz`

## Health surfaces in scope

- frontend: `http://localhost:3000/healthz`
- backend API: `http://localhost:8080/healthz`
- Postgres: container health managed through Docker Compose `--wait`

## Validation performed

Validated successfully on this workstation:

- `frontend-web`
  - `npm run build`
- `platform-infra`
  - `powershell -ExecutionPolicy Bypass -File scripts/local-smoke-test.ps1`
  - result:
    - `postgres health check passed`
    - `frontend check passed`
    - `backend-api check passed`
    - `Local smoke test passed`

## Known validation limit

This workstation does not currently have a working `bash` runtime available to the shell tooling.

As a result:

- `scripts/local-smoke-test.sh` was implemented but not executed here
- the PowerShell smoke path is the validated reference on this machine

The shell variant should be rechecked during `P1-T10` on a machine with a working bash-compatible runtime.
