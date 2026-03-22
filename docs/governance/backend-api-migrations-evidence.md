# Backend API Migrations Evidence (`P2-T08`)

## Summary

`backend-api` now carries repo-local Postgres schema migration and deterministic
seed tooling for the Phase 2 persistence baseline.

Merged PR:

- `https://github.com/mpa-forge/backend-api/pull/25`

Merged commit:

- `b224e8b` `feat: add postgres migration baseline`

## Implemented

Repository: `backend-api`

Added or updated:

- `cmd/migrate/main.go`
- `internal/database/migrations.go`
- `internal/database/migrations_test.go`
- `internal/database/migrations/000001_create_user_profiles.up.sql`
- `internal/database/migrations/000001_create_user_profiles.down.sql`
- `internal/database/seeds/001_user_profiles.sql`
- `docs/database-migrations.md`
- `docs/auth-implementation.md`
- `Makefile`
- `README.md`
- `go.mod`
- `go.sum`

## Migration Baseline

The repo now provides:

- repo-local migration entrypoint through `go run ./cmd/migrate ...`
- embedded SQL schema migrations using `golang-migrate`
- deterministic seed execution from embedded SQL files
- Makefile entrypoints:
  - `make migrate-up`
  - `make migrate-down`
  - `make db-seed`
  - `make db-prepare`

The baseline schema creates:

- `user_profiles`

The baseline seed inserts:

- one placeholder `user` row
- one placeholder `admin` row

Identity mapping decision recorded during implementation:

- verified Clerk `sub` values map directly to `user_profiles.clerk_user_id`

## Validation

Validated locally on `2026-03-22`:

- `go test ./...`
- `make lint`
- `make test`
- `make precommit-run`
- `make -C ../platform-infra local-db-reset`
- `make db-prepare`
- `docker exec platform-blueprint-local-postgres psql -U postgres -d platform_blueprint -c "SELECT clerk_user_id, email, role FROM user_profiles ORDER BY clerk_user_id;"`
- `make support-down`

Observed outcomes:

- migration package tests passed
- repo lint, tests, and pre-commit checks passed
- fresh local Postgres could be migrated and seeded automatically
- seeded rows were present with the expected `clerk_user_id` and role values

## Outcome

- `P2-T08`: Completed (`2026-03-22`)
- `backend-api` now has the migration and seed baseline required for `P2-T09`
  typed database access.
