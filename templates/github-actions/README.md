# GitHub Actions Starter Templates

Canonical starter templates for the shared CI workflow baseline defined in:

- `common/standards/ci-reusable-workflow-policy.md`

## Layout

- `org-dot-github/`
  - reusable workflow templates intended for `org-dot-github/.github/workflows/`
- `repo-entrypoints/`
  - repo-local `.github/workflows/ci.yml` starter files that call the shared workflows

## Baseline intent

These templates are the `P4-T01` wiring baseline only.

They establish:

- the shared reusable workflow filenames
- the repo-local `ci.yml` entrypoint convention
- the initial toolchain bootstrap step for each repo type

They do not yet introduce the full quality gates. Later Phase 4 tasks extend the same file
family with lint, unit-test, contract, scanning, artifact, and publish jobs.

## Rollout order

1. Copy the matching reusable workflow into `org-dot-github/.github/workflows/`.
2. Copy the matching repo entrypoint into the target repository as `.github/workflows/ci.yml`.
3. Validate the workflow in the target repository and keep the planning copy in sync with the
   executable version.
