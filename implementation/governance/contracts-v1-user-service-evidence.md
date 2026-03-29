# Contracts v1 User Service Evidence (`P2-T02`)

## Summary

`platform-contracts` now includes the first real blueprint-generic service contract.

Merged PR:

- `https://github.com/mpa-forge/platform-contracts/pull/16`

## Implemented

Repository: `platform-contracts`

Added:

- `proto/blueprint/user/v1/user.proto`

Removed:

- `proto/blueprint/platform/v1/platform.proto`

Updated:

- `README.md`

## Contract Shape

Package:

- `blueprint.user.v1`

Service:

- `UserService`

Unary RPC:

- `GetCurrentUser(GetCurrentUserRequest) returns (GetCurrentUserResponse)`

Messages:

- `GetCurrentUserRequest`
- `GetCurrentUserResponse`
- `UserProfile`

`UserProfile` fields:

- `user_id`
- `email`
- `display_name`
- `role`

## Why This Baseline

The first contract is intentionally generic and reusable across applications built
from the blueprint.

It avoids product-specific domain modeling and matches the authentication path
already planned for Phase 2:

- SPA authenticates with Clerk
- API validates bearer token
- API returns current authenticated user data

## Validation

Validated locally on `2026-03-22`:

- `buf lint`
- `make contracts-check`
- `npm run lint`
- `make lint`

Notes:

- `make contracts-check` currently skips strict Buf breaking enforcement until the
  first `contracts-vX.Y.Z` release tag exists, as documented in the Phase 2
  contract policy.

## Outcome

- `P2-T02`: Completed (`2026-03-22`)
- The contract repo now has one protected-endpoint baseline ready for generation
  work in `P2-T03` and API wiring in `P2-T04` and `P2-T05`.

