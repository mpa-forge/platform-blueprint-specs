## Why

The shared reusable Go CI workflow already runs SonarQube Cloud analysis, but it does not generate or pass a Go coverage report. That gap caused `backend-api` PR `#43` to report `new_coverage = 0.0` until a repo-local workaround proved Sonar reads Go coverage correctly when `coverage.out` is generated and imported.

## What Changes

- Extend the shared reusable Go CI workflow contract so Sonar-enabled Go repositories generate a coverage profile during the existing test path and pass it to Sonar analysis.
- Define how the reusable workflow behaves when a repository has no Go files so placeholder or partially bootstrapped repos do not report misleading Sonar coverage results.
- Preserve the current fast path for repositories that keep Sonar disabled so the fix stays generic without forcing unnecessary coverage work on every Go repository.
- Document that the shared workflow implementation lands in `org-dot-github`, while the planning repo templates and any temporary repo-local workarounds are synchronized afterward.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `ci-lint-unit-test-jobs`: The shared Go reusable workflow requirement expands to cover Sonar-aware Go coverage generation, artifact handoff, and no-Go-source behavior.

## Impact

- `templates/github-actions/org-dot-github/reusable-ci-go.yml`
- `templates/github-actions/repo-entrypoints/ci-go-service.yml`
- The executable reusable workflow copy in `org-dot-github/.github/workflows/reusable-ci-go.yml`
- Downstream Go repositories that consume the shared reusable workflow, including `backend-api`, `platform-ai-workers`, `platform-observability`, and later any other Go repos wired to the same contract
