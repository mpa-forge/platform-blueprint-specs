## Context

`platform-contracts` already has a Buf module baseline, reproducible code
generation wrappers, and local validation commands documented in the Phase 2
contracts evidence. Phase 4 now needs those checks promoted into the shared CI
path so pull requests fail deterministically when protobuf contracts are
invalid, introduce breaking changes, or leave generated code stale.

The current contracts reusable workflow only proves the toolchain baseline and
optionally runs Sonar analysis. That means protobuf validation is not yet
represented as first-class required checks in the same reusable workflow pattern
used for other repos.

## Goals / Non-Goals

**Goals:**
- Add explicit reusable-workflow jobs for `buf lint`, `buf breaking`, and
  generated-code drift validation.
- Keep `platform-contracts` on the shared workflow model instead of introducing
  a one-off standalone CI pipeline.
- Reuse the repo’s existing scripts and make/package entrypoints where possible
  so local and CI behavior stay aligned.
- Produce stable, branch-protection-ready check names for protobuf quality
  gates.

**Non-Goals:**
- Redesign the Buf module layout or generation model established in Phase 2.
- Implement release-tag publishing for the TypeScript client package.
- Add paid Buf services or remote policy dependencies.

## Decisions

### Add dedicated protobuf jobs to the shared contracts reusable workflow

The contracts reusable workflow will gain jobs for lint, breaking detection, and
generated-code drift instead of keeping only the generic toolchain proof. This
keeps the checks reusable across template-derived contract repos and makes the
required check names stable.

Alternative considered:
- Keep a repo-local `platform-contracts`-only workflow.
  Rejected because it would diverge from the shared Phase 4 workflow model and
  make future contract repos harder to bootstrap consistently.

### Reuse repository-native validation commands instead of duplicating shell logic

The workflow should call the existing repository scripts or make/npm entrypoints
that already encode Buf and code-generation behavior. That preserves one source
of truth for developer and CI validation.

Alternative considered:
- Inline Buf and generation commands directly in workflow YAML.
  Rejected because drift between CI and local commands would become more likely.

### Treat generated-code drift as a separate required check

Generation drift will be validated independently from `buf lint` and `buf
breaking` so failures clearly identify whether the problem is schema quality,
backward compatibility, or stale generated artifacts.

Alternative considered:
- Collapse all protobuf validation into one catch-all job.
  Rejected because branch protection and debugging benefit from smaller,
  purpose-specific checks.

## Risks / Trade-offs

- [Workflow complexity grows in the contracts reusable workflow] → Keep the
  contract jobs narrow, use existing repo entrypoints, and preserve consistent
  naming between template and live workflow copies.
- [Breaking checks can fail on bootstrap or unusual target refs] → Continue to
  rely on the existing helper behavior that already handles the bootstrap case
  against `main`.
- [Generated-code drift checks may be slower than simple linting] → Keep them
  as a dedicated job so they can run in parallel with other checks and surface a
  precise failure mode.

## Migration Plan

1. Extend the shared contracts reusable workflow in `.github` with protobuf
   quality-gate jobs.
2. Mirror the same contract in the blueprint templates.
3. Update `platform-contracts` to consume the new reusable workflow jobs and
   expose stable required check names.
4. Verify CI passes on a no-op branch and fails when Buf or generated artifacts
   drift.
5. Record the final check names for branch-protection use.

## Open Questions

- None currently.
