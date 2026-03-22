# Backend API Profile Provisioning Evidence (`P2-T09`)

## Summary

`platform-contracts` and `backend-api` now implement the Phase 2 typed
persistence layer and explicit profile bootstrap flow for authenticated users.

Merged PRs:

- `https://github.com/mpa-forge/platform-contracts/pull/21`
- `https://github.com/mpa-forge/backend-api/pull/26`

Merged commits:

- `f5956f8` `feat: add user profile provisioning rpc`
- `8d2320c` `feat: add db-backed user profile provisioning`

## Implemented

Repository: `platform-contracts`

Added or updated:

- `proto/blueprint/user/v1/user.proto`
- `gen/go/blueprint/user/v1/user.pb.go`
- `gen/go/blueprint/user/v1/userv1connect/user.connect.go`
- `packages/typescript-client/src/gen/blueprint/user/v1/user_pb.ts`
- `packages/typescript-client/src/gen/blueprint/user/v1/user_connect.ts`
- `README.md`
- `docs/typescript-client-usage.md`
- `docs/go-server-usage.md`
- `docs/consumer-auth-usage.md`
- `packages/typescript-client/README.md`
- `scripts/install-codegen-tools.sh`

Repository: `backend-api`

Added or updated:

- `sqlc.yaml`
- `internal/database/queries/user_profiles.sql`
- `internal/database/sqlc/`
- `internal/database/pool.go`
- `internal/database/profiles.go`
- `internal/database/profiles_integration_test.go`
- `internal/usersvc/server.go`
- `internal/usersvc/server_test.go`
- `internal/api/runtime.go`
- `internal/api/runtime_test.go`
- `internal/api/runtime_integration_test.go`
- `cmd/api/main.go`
- `Makefile`
- `README.md`
- `docs/api-runtime.md`
- `docs/auth-implementation.md`
- `docs/database-migrations.md`
- `go.mod`
- `go.sum`

## Provisioning And Read Flow

The contract and API now provide two protected procedures:

- `EnsureCurrentUserProfile`
- `GetCurrentUser`

Baseline behavior:

- frontend authenticates through Clerk
- frontend obtains the API bearer token
- frontend calls `EnsureCurrentUserProfile`
- backend verifies the token and upserts the local `user_profiles` row keyed by
  `clerk_user_id`
- frontend then calls `GetCurrentUser`
- backend reads the persisted row from Postgres through the typed `sqlc` layer

Identity mapping decision used by the implementation:

- verified Clerk `sub` values map directly to `user_profiles.clerk_user_id`

## Validation

Validated locally on `2026-03-22`:

In `platform-contracts`:

- `make buf-lint`
- `bash scripts/buf-breaking.sh main`
- `bash scripts/go-run.sh test ./gen/go/...`
- `npm run build --workspace @mpa-forge/platform-contracts-client`
- `npm run lint`

In `backend-api`:

- `go test ./...`
- `make lint`
- `make test`
- `make precommit-run`

Real Postgres-backed validation:

- `make -C ../platform-infra local-db-reset`
- `TEST_DATABASE_URL=postgres://postgres:postgres@localhost:5432/platform_blueprint?sslmode=disable`
- `go test ./internal/database ./internal/api -run 'TestProfileStoreRoundTrip|TestProvisioningAndGetCurrentUserWithPostgres' -count=1`
- `make support-down`

Observed outcomes:

- contract lint and generation-related checks passed
- TypeScript client package built with the new provisioning RPC
- backend unit tests passed
- backend lint and pre-commit checks passed
- real local Postgres integration tests passed for both:
  - direct typed store round-trip
  - API-level provision-then-read flow

## Outcome

- `P2-T09`: Completed (`2026-03-22`)
- the platform now has explicit local profile provisioning and DB-backed user
  reads, ready for frontend integration in `P2-T10`.
