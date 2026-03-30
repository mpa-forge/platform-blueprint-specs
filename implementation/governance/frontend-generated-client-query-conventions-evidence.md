# Frontend Generated Client Query Conventions Evidence (`P2-T10B`)

## Summary

`frontend-web` now has a shared generated-client integration path and a reusable
TanStack Query pattern for protected API access.

Merged PR:

- `https://github.com/mpa-forge/frontend-web/pull/20`

Merged commit:

- `1e5b484` `feat: add shared generated client query conventions`

## Implemented

Repository: `frontend-web`

Added or updated:

- `package.json`
- `bun.lock`
- `src/api/protected/protectedApiClient.ts`
- `src/api/query/queryClient.ts`
- `src/api/currentUserProfile.ts`
- `src/main.tsx`
- `src/features/current-user/CurrentUserProfilePage.tsx`
- `src/features/current-user/CurrentUserProfilePage.test.tsx`
- `docs/frontend-runtime.md`
- `docs/frontend-auth-bootstrap.md`
- archived OpenSpec change record under:
  - `openspec/changes/archive/2026-03-30-define-generated-client-wiring-and-data-fetching-conventions/`

## Frontend Baseline

The frontend now documents and implements:

- one shared generated client construction path for `platform-contracts`
- environment-based API base URL selection
- shared Clerk bearer-token injection for protected API calls
- root TanStack Query bootstrap through the app entrypoint
- one canonical bootstrap-then-read pattern for the protected current-user flow
- explicit classified frontend handling for protected API failures

This gives later frontend features one reusable pattern for protected server
data without inventing new client, token, or cache conventions.

## Validation

Validation was performed in `frontend-web` before merge through the repo-local
frontend validation workflow.

Observed outcome:

- generated client consumption is shared instead of feature-local
- protected current-user loading follows the shared query pattern
- the docs now describe the client/query baseline future features should copy

## Outcome

- `P2-T10B`: Completed (`2026-03-31`)
- the generated-client and data-fetching baseline is ready for module-boundary
  definition in `P2-T10C` and the real Clerk auth entry flow in `P2-T10D`
