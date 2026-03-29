# Backend API Auth Middleware Evidence (`P2-T05`)

## Summary

`backend-api` now enforces the Phase 2 Clerk JWT baseline for protected Connect
procedures.

Merged PR:

- `https://github.com/mpa-forge/backend-api/pull/24`

Merged commit:

- `d2cb2f0` `feat: implement P2-T05 Clerk JWT verification`

Related consumer-doc PR:

- `https://github.com/mpa-forge/platform-contracts/pull/20`

Related consumer-doc commit:

- `6912d06` `docs: add api consumer auth usage guide`

## Implemented

Repository: `backend-api`

Added or updated:

- `internal/auth/principal.go`
- `internal/auth/errors.go`
- `internal/auth/interceptor.go`
- `internal/auth/jwks.go`
- `internal/auth/verifier.go`
- `internal/auth/interceptor_test.go`
- `internal/auth/verifier_test.go`
- `internal/api/runtime.go`
- `internal/api/runtime_test.go`
- `internal/usersvc/server.go`
- `docs/api-runtime.md`
- `docs/auth-implementation.md`
- `README.md`
- `go.mod`
- `go.sum`

Repository: `platform-contracts`

Added or updated:

- `docs/consumer-auth-usage.md`
- `docs/typescript-client-usage.md`
- `README.md`

## Auth Behavior

The protected Connect handler now:

- requires `Authorization: Bearer <token>`
- verifies JWT signature against Clerk JWKS from
  `AUTH_ISSUER_URL/.well-known/jwks.json`
- enforces `iss` using `AUTH_ISSUER_URL`
- enforces `aud` using `AUTH_AUDIENCE`
- maps token claims into the baseline principal:
  - required `sub`
  - optional `email`, `display_name`, `given_name`, `family_name`
  - optional `role` or `roles`
- maps recognized internal roles:
  - `user`
  - `admin`
- returns:
  - `401` for missing or invalid tokens
  - `403` for valid tokens with unsupported role claims

`UserService.GetCurrentUser` now reflects the verified principal from request
context rather than static placeholder identity.

## Validation

Validated locally on `2026-03-22`:

In `backend-api`:

- `go test ./...`
- `make lint`
- `make test`
- `make precommit-run`

In `platform-contracts`:

- `make lint`

Observed outcomes:

- auth interceptor tests passed
- JWKS-backed verifier tests passed
- mounted Connect procedure returned `401/403` as expected in route tests
- repo-local lint, tests, and pre-commit checks passed
- consumer auth usage docs were added for frontend and other API consumers

## Outcome

- `P2-T05`: Completed (`2026-03-22`)
- `backend-api` now enforces the baseline Clerk JWT contract required for
  `P2-T06` Clerk tenant configuration and `P2-T10` frontend protected calls.
