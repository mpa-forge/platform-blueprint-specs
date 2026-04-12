## Why

`P4-T01` established only the shared CI wiring baseline, so PRs still do not fail fast on lint or unit-test regressions. Phase 4 needs the reusable workflows to enforce code-quality gates before later scanning and release jobs are layered on top.

## What Changes

- Add lint and unit-test jobs to the shared reusable workflows for Go and frontend repositories.
- Pin tool versions and add workflow caching so CI runs are deterministic and repeatable.
- Update the repo-local `ci.yml` entrypoints to call the expanded reusable workflows without changing the baseline triggers or permissions.
- Make lint and unit-test failures block PR validation early, before later Phase 4 jobs are introduced.

## Capabilities

### New Capabilities
- `ci-lint-unit-test-jobs`: Shared CI lint and unit-test workflow behavior for Go and frontend repositories, plus the repo entrypoint wiring that consumes it.

### Modified Capabilities

None.

## Impact

- `templates/github-actions/org-dot-github/` reusable workflow templates.
- `templates/github-actions/repo-entrypoints/` repo-local CI entrypoints.
- The executable workflow copies in `org-dot-github/.github/workflows/` and the target repository `ci.yml` files for `frontend-web`, `backend-api`, `backend-worker`, and `platform-ai-workers`.
- PR merge gates once branch protection starts relying on the new check names.
