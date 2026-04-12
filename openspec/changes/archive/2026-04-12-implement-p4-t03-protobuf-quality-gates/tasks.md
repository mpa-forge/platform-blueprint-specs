## 1. Shared Workflow Updates

- [x] 1.1 Extend the shared contracts reusable workflow in `.github` with
      dedicated jobs for `buf lint`, `buf breaking`, and generated-code drift
      validation.
- [x] 1.2 Mirror the protobuf quality-gate jobs and inputs in the matching
      workflow templates under `platform-blueprint-specs/templates/github-actions/org-dot-github`.

## 2. Repo Wiring

- [x] 2.1 Update `platform-contracts` to consume the enhanced reusable
      contracts workflow and expose stable protobuf quality-gate check names.
- [x] 2.2 Update the contracts repo-entrypoint template so future repos inherit
      the same protobuf quality-gate wiring.

## 3. Validation And Evidence

- [x] 3.1 Verify the contracts workflow still parses and that the protobuf jobs
      use the existing repo validation commands without duplicating logic.
- [x] 3.2 Record the final required protobuf check names and CI evidence needed
      for Phase 4 branch-protection follow-up.
