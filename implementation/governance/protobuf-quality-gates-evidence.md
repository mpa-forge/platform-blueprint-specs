# Protobuf Quality Gates Evidence (`P4-T03`)

## Summary

The shared contracts CI path now includes first-class protobuf quality gates for
lint, breaking-change detection, and generated-code drift, with
`platform-contracts` wired to the updated reusable workflow contract.

## Implemented

Shared workflow updates:

- `.github/workflows/reusable-ci-contracts.yml`
- `templates/github-actions/org-dot-github/reusable-ci-contracts.yml`

Repo wiring updates:

- `platform-contracts/.github/workflows/ci.yml`
- `templates/github-actions/repo-entrypoints/ci-contracts.yml`

## Required Check Names

For `platform-contracts`, the expected GitHub required check names are:

- `ci / buf-lint`
- `ci / buf-breaking`
- `ci / generated-code-drift`

The workflow continues to expose the existing top-level caller job namespace
through the repo-local `ci.yml` entrypoint.

## Validation

Validated locally on `2026-04-12`:

- YAML parse succeeded for:
  - `.github/workflows/reusable-ci-contracts.yml`
  - `platform-contracts/.github/workflows/ci.yml`
  - `templates/github-actions/org-dot-github/reusable-ci-contracts.yml`
  - `templates/github-actions/repo-entrypoints/ci-contracts.yml`
- `make contracts-check-ci`
  - `buf lint`
  - `bash scripts/buf-breaking.sh "origin/main"`
  - `make generate-check`
  - `make go-generated-check`
  - `make ts-client-build`

Notes:

- `buf breaking` still respects the existing bootstrap rule and skips strict
  enforcement until the first contract release tag exists.
- The reusable workflow calls repo-native validation commands instead of
  duplicating Buf or generation logic in YAML.

## Outcome

- `P4-T03`: Implemented locally
- Shared contracts CI now exposes stable protobuf quality-gate check names for
  Phase 4 branch-protection follow-up
