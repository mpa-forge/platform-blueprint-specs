# Frontend Module Boundaries Evidence (`P2-T10C`)

## Summary

`frontend-web` now has a documented and embodied module-boundary convention for
routes, shared UI, app bootstrap, protected API wiring, and feature-local
current-user code.

Merged PR:

- `https://github.com/mpa-forge/frontend-web/pull/21`

Merged commit:

- `e433f60` `Implement frontend module boundary conventions`

## Implemented

Repository: `frontend-web`

Added or updated:

- `docs/frontend-module-boundaries.md`
- `README.md`
- `src/app/providers/AppProviders.tsx`
- `src/app/providers/FrontendAuthProvider.tsx`
- `src/app/shell/AppChrome.tsx`
- `src/app/shell/ProtectedAppShell.tsx`
- `src/routes/AppRouter.tsx`
- `src/routes/auth/AuthEntryRoute.tsx`
- `src/routes/boundaries/ProtectedRouteBoundary.tsx`
- `src/routes/paths.ts`
- `src/api/protected/protectedApiClient.ts`
- `src/api/query/queryClient.ts`
- `src/features/current-user/api/useCurrentUserProfileData.ts`
- `src/features/current-user/components/CurrentUserProfileDetails.tsx`
- `src/features/current-user/pages/CurrentUserProfilePage.tsx`
- `src/stores/runtime/runtimeStore.ts`
- `src/ui/data/DetailList.tsx`
- archived OpenSpec change record under:
  - `openspec/changes/archive/2026-03-30-define-frontend-feature-module-boundary-conventions/`

## Frontend Baseline

The frontend now documents and implements:

- route modules separated from app-shell providers and boundaries
- shared app bootstrap/provider modules
- protected API wiring kept in shared API-focused modules
- feature-local current-user modules split into `api`, `components`, and `pages`
- shared UI modules separated from feature-local presentation code
- explicit rules for when code stays feature-scoped versus moves to app/shared

This gives later feature work a layout that can grow without collapsing into a
flat `src/` tree.

## Validation

Validation was performed in `frontend-web` before merge through the repo-local
frontend validation workflow.

Observed outcome:

- the repo layout now reflects the documented boundary rules
- route, app, feature, store, and API responsibilities are easier to read
- later frontend tasks can extend the established structure instead of
  inventing a new layout

## Outcome

- `P2-T10C`: Completed (`2026-03-31`)
- the frontend now has a stable module-boundary convention for later protected
  feature work
