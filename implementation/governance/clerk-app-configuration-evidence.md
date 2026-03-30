# Clerk App Configuration Evidence (`P2-T06`)

## Summary

The Clerk development instance has been configured for the Phase 2 SPA + API
baseline. The provider-side configuration is recorded here so backend and
frontend repos can consume the same auth contract.

Current status:

- provider configuration recorded
- local/backend env mappings recorded
- frontend redirect env mappings recorded
- final frontend sign-in and token-acquisition proof completed through the
  merged `frontend-web` integration work recorded in:
  - `implementation/governance/frontend-protected-api-integration-evidence.md`

## Clerk Development Instance

| Field | Value |
| --- | --- |
| Clerk development domain | `enough-mollusk-18.clerk.accounts.dev` |
| Backend issuer env value | `https://enough-mollusk-18.clerk.accounts.dev` |
| API audience | `https://api.local.mpa-forge` |

## Session Token Claims

Configured Clerk session token claims:

```json
{
  "aud": "https://api.local.mpa-forge",
  "email": "{{user.primary_email_address}}",
  "display_name": "{{user.full_name}}",
  "given_name": "{{user.first_name}}",
  "family_name": "{{user.last_name}}",
  "role": "{{user.public_metadata.role}}"
}
```

These match the Phase 2 backend auth baseline implemented in:

- `implementation/governance/backend-api-auth-middleware-evidence.md`

## Environment Mappings

### `backend-api`

Use:

```env
AUTH_ISSUER_URL=https://enough-mollusk-18.clerk.accounts.dev
AUTH_AUDIENCE=https://api.local.mpa-forge
```

### `frontend-web`

Planned frontend redirect env values:

```env
VITE_CLERK_SIGN_IN_URL=/sign-in
VITE_CLERK_SIGN_UP_URL=/sign-up
VITE_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL=/
VITE_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL=/
```

These are frontend-app configuration values, not Clerk Dashboard redirect
settings.

## Test-User Role Setup

The baseline expects at least:

- one normal user
- one admin user

Current setup:

- one admin user with public metadata:

```json
{
  "role": "admin"
}
```

- one normal user with no explicit `role` metadata

Recommended explicit normal-user metadata for future setups:

```json
{
  "role": "user"
}
```

Admin user reference:

```json
{
  "role": "admin"
}
```

Note:

- the backend currently defaults a missing role to `user`
- a token with an unsupported explicit role such as `viewer` is rejected with
  `403`

## Closure Proof

The provider-side task is now fully closed because the frontend local flow has
proven that:

1. the Clerk SPA integration can authenticate successfully
2. the frontend obtains a token accepted by `backend-api`
3. the protected endpoint returns authenticated user data to the frontend

Outcome:

- `P2-T06`: Completed (`2026-03-31`)
