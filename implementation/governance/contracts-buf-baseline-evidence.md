# Contracts Buf Baseline Evidence (`P2-T01`)

## Summary

`platform-contracts` was upgraded from a scaffold to an enforceable Buf-based contract repository baseline.

Merged PRs:

- `https://github.com/mpa-forge/platform-contracts/pull/13`
- `https://github.com/mpa-forge/platform-contracts/pull/14`

## Implemented

Repository: `platform-contracts`

Added or updated:

- `buf.yaml`
- `buf.gen.yaml`
- `.github/workflows/contracts-buf-check.yml`
- `scripts/buf-breaking.sh`
- `Makefile`
- `package.json`
- `README.md`
- `proto/blueprint/platform/v1/platform.proto`

## Baseline Policy

- Buf module path: `proto/`
- Buf module name: `buf.build/mpa-forge/platform-contracts`
- Lint policy: `STANDARD`
- Breaking-change policy: `FILE`
- Generation baseline:
  - `protoc-gen-go`
  - `protoc-gen-connect-go`
  - `protoc-gen-es`
- No paid BSR dependency was introduced in the baseline.

## Validation

Validated locally on `2026-03-22`:

- `buf lint`
- `bash scripts/buf-breaking.sh main`
- `make contracts-check`
- `npm run lint`
- `make lint`

Notes:

- The initial bootstrap branch cannot compare breaking changes against a target branch that does not yet contain a Buf baseline.
- `scripts/buf-breaking.sh` handles that bootstrap case cleanly and performs normal breaking checks once the baseline exists on `main`.
- After merge to `main`, `bash scripts/buf-breaking.sh main` and `make contracts-check` run without the bootstrap skip condition.
- Before the first `contracts-vX.Y.Z` release tag exists, the helper treats the contract surface as pre-release and skips strict breaking enforcement. After the first release tag, normal breaking enforcement applies.

## Outcome

- `P2-T01`: Completed (`2026-03-22`)
- `platform-contracts` now has a reproducible local and CI-friendly Buf validation baseline ready for `P2-T02` and `P2-T03`.
