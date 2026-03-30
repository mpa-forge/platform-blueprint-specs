# Frontend Routing And App-Shell Evidence (`P2-T10A`)

## Summary

`frontend-web` now has the baseline authenticated route structure and protected
app-shell behavior needed for the first frontend-to-API feature flow.

Merged PR:

- `https://github.com/mpa-forge/frontend-web/pull/19`

Merged commit:

- `fcf4506` `feat: add frontend routing app shell baseline`

## Implemented

Repository: `frontend-web`

Added or updated:

- `src/App.tsx`
- `src/routes/routes.ts`
- `src/app/AppChrome.tsx`
- `src/auth/FrontendAuthProvider.tsx`
- `src/features/current-user/CurrentUserProfilePage.tsx`
- `src/App.test.tsx`
- `tests/e2e/app.spec.ts`
- `playwright.config.ts`
- `docs/frontend-runtime.md`
- `docs/frontend-auth-bootstrap.md`
- `openspec/specs/frontend-routing-app-shell/spec.md`
- `openspec/specs/frontend-protected-user-profile/spec.md`
- archived OpenSpec change record under:
  - `openspec/changes/archive/2026-03-30-define-frontend-routing-and-protected-app-shell/`

## Frontend Baseline

The frontend now documents and implements:

- the baseline route map for public and protected screens
- the protected application shell structure
- Clerk-driven auth-provider placement and handoff points
- unauthorized/loading behavior for protected screens
- the first protected profile page location inside the app shell

This gives later tasks a stable place to wire:

- Clerk sign-in/sign-up flows
- generated client calls
- the protected current-user bootstrap/read sequence

## Validation

Validation was performed in `frontend-web` before merge through the repo-local
frontend stack and test baseline introduced with the task.

Observed outcome:

- `frontend-web` now has a documented and implemented route/app-shell baseline
- protected-feature placement is explicit
- the repo docs point to the new frontend auth bootstrap and runtime behavior

## Outcome

- `P2-T10A`: Completed (`2026-03-30`)
- the frontend route/app-shell baseline is ready for generated-client wiring in
  `P2-T10B` and sign-in/sign-up implementation in `P2-T10D`.
