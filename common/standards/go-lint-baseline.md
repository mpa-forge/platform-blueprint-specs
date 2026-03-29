# Go Lint Baseline

Last updated: 2026-03-07

## Scope

This document defines the baseline Go lint contract for all Go repositories in the platform blueprint.

## Execution model

Go repositories use `golangci-lint` as the single lint entrypoint.

- `make lint` delegates to `make repo-lint`
- `make repo-lint` runs only `golangci-lint`
- Go formatting remains a separate concern handled by:
  - `make format`
  - `make format-check`

This keeps linting and formatting distinct while avoiding duplicated analysis between standalone checks and `golangci-lint`.

## Pinned runner

- Runner: `github.com/golangci/golangci-lint/cmd/golangci-lint`
- Version: `v1.64.8`

The pinned version lives in the Go-service bootstrap template:

- [templates/bootstrap/go-service/Makefile](c:/Users/Miquel/dev/platform-blueprint-specs/templates/bootstrap/go-service/Makefile)

## Baseline linter set

The baseline `.golangci.yml` enables:

- `errcheck`
- `govet`
- `ineffassign`
- `staticcheck`
- `unused`

These cover the minimum platform baseline:

- unchecked errors
- Go vet diagnostics
- ineffective assignments
- broad static analysis
- dead code / unused identifiers

## Baseline config

The canonical config template lives at:

- [templates/bootstrap/go-service/.golangci.yml](c:/Users/Miquel/dev/platform-blueprint-specs/templates/bootstrap/go-service/.golangci.yml)

All Go repositories should start from that file and only diverge with an explicit repo need.

## Design rules

- Do not run standalone `go vet` before `golangci-lint`; `govet` is enabled inside the linter suite.
- Do not run standalone `gofmt -l` inside `make lint`; formatting enforcement belongs in `make format-check`.
- Keep the baseline small and predictable. Add new linters only when they are justified across multiple Go repos or documented as a repo-specific extension.
