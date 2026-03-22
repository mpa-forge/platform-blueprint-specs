# Clerk App Configuration Evidence (`P2-T06`)

## Summary

The Clerk development instance has been configured for the Phase 2 SPA + API
baseline. The provider-side configuration is recorded here so backend and
frontend repos can consume the same auth contract.

Current status:

- provider configuration recorded
- local/backend env mappings recorded
- frontend redirect env mappings recorded
- final end-to-end sign-in and token acquisition still depends on later
  frontend integration work in `P2-T10`

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

- `docs/governance/backend-api-auth-middleware-evidence.md`

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

## Remaining Work Before Full Task Closure

To close `P2-T06` completely, the blueprint still needs:

1. frontend Clerk wiring in `frontend-web`
2. real sign-in flow validation that produces a token accepted by `backend-api`
3. final documentation of any publishable-key secret references used by the
   frontend runtime
