# Frontend Protected API Integration Evidence (`P2-T10`)

## Summary

The Phase 2 frontend now authenticates through Clerk, obtains a bearer token
accepted by `backend-api`, provisions the current-user profile, and renders
protected user data from the generated API client path.

Merged frontend PRs:

- `https://github.com/mpa-forge/frontend-web/pull/20`
- `https://github.com/mpa-forge/frontend-web/pull/21`
- `https://github.com/mpa-forge/frontend-web/pull/22`

Representative merged commits:

- `1e5b484` `feat: add shared generated client query conventions`
- `e433f60` `Implement frontend module boundary conventions`
- `b384679` `feat: implement frontend auth entry flow`

## End-To-End Frontend Outcome

The frontend baseline now includes:

- generated `platform-contracts` client consumption through one shared browser
  transport path
- Clerk bearer-token acquisition and injection for protected API calls
- TanStack Query bootstrap and the canonical protected bootstrap-then-read flow
- real `/sign-in` and `/sign-up` auth-entry behavior
- protected rendering of current-user data returned by the API

## Provider Closure

This work also supplies the missing proof needed to close `P2-T06`.

Validated outcome recorded from the local development flow:

- the frontend can log in through Clerk
- the frontend obtains a valid access token for the API
- the protected endpoint returns user data to the frontend after authentication

## Outcome

- `P2-T10`: Completed (`2026-03-31`)
- the remaining proof needed for `P2-T06` is satisfied
- Phase 2 is ready to move from frontend/API integration into final local
  end-to-end validation in `P2-T12`
