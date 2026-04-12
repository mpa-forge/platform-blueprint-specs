## Why

`platform-contracts` already has a Buf baseline and reproducible code
generation, but Phase 4 still lacks the PR quality gates that enforce those
checks in the shared CI model. Adding protobuf-specific CI gates now closes a
major contract-integrity gap before later release automation depends on the
contracts repo.

## What Changes

- Add a protobuf quality-gate capability for `platform-contracts` CI covering
  `buf lint`, `buf breaking`, and generated-code drift detection.
- Extend the shared contracts reusable workflow and repo entrypoint templates so
  protobuf validation can run as required PR checks instead of one-off baseline
  jobs.
- Define the expected contract-check job names and failure behavior so branch
  protection can rely on them consistently.

## Capabilities

### New Capabilities
- `protobuf-quality-gates`: Enforce lint, breaking-change detection, and
  generated-artifact drift checks for protobuf contract repositories in CI.

### Modified Capabilities
- None.

## Impact

- Shared contracts CI workflows in `.github`
- GitHub Actions workflow templates in `platform-blueprint-specs`
- `platform-contracts` repository CI entrypoint and validation path
- Branch-protection-ready protobuf contract checks for future release workflows
