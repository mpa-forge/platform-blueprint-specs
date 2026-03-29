# Backend API Runtime Skeleton Evidence (`P2-T04`)

## Summary

`backend-api` now includes the Phase 2 runtime skeleton built with `chi` and
generated `connect-go` handlers.

Merged PR:

- `https://github.com/mpa-forge/backend-api/pull/23`

Merged commit:

- `6dc54c0` `feat: implement P2-T04 API runtime skeleton`

## Implemented

Repository: `backend-api`

Added or updated:

- `cmd/api/main.go`
- `internal/config/config.go`
- `internal/config/config_test.go`
- `internal/api/runtime.go`
- `internal/api/runtime_test.go`
- `internal/api/middleware.go`
- `internal/usersvc/server.go`
- `docs/api-runtime.md`
- `README.md`
- `Makefile`
- `Dockerfile`
- `go.mod`
- `go.sum`

Removed:

- `cmd/api-placeholder/main.go`

## Runtime Shape

The runtime now provides:

- `chi` router baseline
- generated `connect-go` `UserService` handler mounted into the router
- health endpoint
- readiness endpoint
- structured request logging
- typed startup config
- fail-fast environment validation before binding a port
- graceful shutdown handling

## Contract Usage

The API runtime imports the generated Go contract from:

- `github.com/mpa-forge/platform-contracts/gen/go/blueprint/user/v1`
- `github.com/mpa-forge/platform-contracts/gen/go/blueprint/user/v1/userv1connect`

Current placeholder service implementation:

- `UserService.GetCurrentUser`

## Validation

Validated locally on `2026-03-22`:

- `make lint`
- `go test ./...`

Observed outcomes:

- API runtime tests passed
- config validation tests passed
- generated Connect route is mounted and exercised by tests
- startup validation enforces required environment contract

## Outcome

- `P2-T04`: Completed (`2026-03-22`)
- `backend-api` now has the runnable contract-first API skeleton required for
  auth middleware work in `P2-T05`.

