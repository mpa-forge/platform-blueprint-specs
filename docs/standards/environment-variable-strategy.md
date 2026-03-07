# Environment Variable Strategy

Last updated: 2026-03-07

## Scope

This document defines the Phase 1 local environment variable baseline for the platform blueprint.

## Phase split

Phase 1 defines the environment contract only:

- `.env.example` is committed for each relevant repo
- required vs optional variables are documented
- local placeholder and default expectations are explicit

Actual runtime enforcement is deferred until Phase 2 when runnable service entrypoints exist.

## Local file policy

- Commit `.env.example`
- Do not commit `.env`
- Do not commit `.env.local`
- Use local `.env` files only for developer-specific values

## Naming rules

- Shared service runtime variables use all-caps snake case:
  - `APP_ENV`
  - `LOG_LEVEL`
  - `DATABASE_URL`
- Frontend browser-exposed variables use the frontend bundler prefix:
  - `VITE_*`
- Durations use Go-style duration strings where applicable:
  - `30s`
  - `5m`
- Booleans use lowercase `true` or `false`

## Local baseline by repo

### `frontend-web`

Required:

- `VITE_APP_ENV`
- `VITE_API_BASE_URL`
- `VITE_CLERK_PUBLISHABLE_KEY`

Optional:

- `VITE_CLERK_SIGN_IN_URL`
- `VITE_CLERK_SIGN_UP_URL`

### `backend-api`

Required:

- `APP_ENV`
- `LOG_LEVEL`
- `HTTP_PORT`
- `DATABASE_URL`

Planned and documented now, enforced in Phase 2:

- `AUTH_ISSUER_URL`
- `AUTH_AUDIENCE`
- `OTEL_MODE`
- `OTEL_EXPORTER_OTLP_ENDPOINT`
- `OTEL_EXPORTER_OTLP_HEADERS`

### `backend-worker`

Required:

- `APP_ENV`
- `LOG_LEVEL`
- `DATABASE_URL`
- `WORKER_TICK_INTERVAL`

Planned and documented now, enforced in Phase 2:

- `OTEL_MODE`
- `OTEL_EXPORTER_OTLP_ENDPOINT`
- `OTEL_EXPORTER_OTLP_HEADERS`

### `platform-ai-workers`

Required:

- `APP_ENV`
- `LOG_LEVEL`
- `WORKER_RUNTIME_MODE`
- `WORKER_ID`
- `TARGET_REPO`
- `MAX_PENDING_REVIEW`
- `POLL_INTERVAL`

Planned and documented now, enforced in later runtime work:

- `GITHUB_TOKEN`
- `OPENAI_API_KEY`
- `TRIGGER_SOURCE`
- `TARGET_ISSUE`
- `TARGET_PR`
- `EVENT_ID`

## Design rules

- Defaults may be used for local convenience only when they are low-risk and obvious.
- Secret values must always be placeholders in `.env.example`.
- Required variables should be promoted into typed startup config in Phase 2 and validated before service startup.
- The environment contract should evolve in repo-local `.env.example` files first, then be reflected back here when the change is common across multiple repos.
