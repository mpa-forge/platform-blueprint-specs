## Context

The Phase 4 shared CI rollout moved Go repositories onto a reusable workflow contract owned by `org-dot-github` and mirrored through the planning templates in this repository. That contract now includes lint, test, optional Sonar analysis, and optional image verification or publishing.

The current reusable Go workflow runs `go test ./...` in the `test` job and runs Sonar in a later `sonar` job when the Sonar organization and project keys are populated. Because the workflow never generates a Go coverage profile or passes `sonar.go.coverage.reportPaths`, Sonar sees no imported coverage data. `backend-api` PR `#43` demonstrated the failure mode and also proved the fix: a repo-local workaround generated `coverage.out` and passed it into the Sonar scan, after which Sonar reported valid new-code coverage.

This change needs to preserve the shared-workflow model, avoid duplicating test execution, and keep non-Sonar repositories behaviorally stable.

## Goals / Non-Goals

**Goals:**
- Make Sonar-enabled Go repositories import Go test coverage by default through the shared reusable workflow.
- Keep the reusable workflow generic for current and future Go repositories without requiring repo-local Sonar forks.
- Reuse the existing `test` job as the single source of truth for Go test execution.
- Define explicit behavior for repositories with no tracked Go files and for repositories that intentionally keep Sonar disabled.
- Make the implementation target and downstream beneficiaries clear so rollout work is coordinated across repos.

**Non-Goals:**
- Redesign the broader SonarQube Cloud rollout or secret model.
- Add coverage import behavior to frontend, contracts, or infra workflows.
- Solve future multi-module Go coverage aggregation beyond the current single-workspace workflow contract.
- Introduce a new caller-facing workflow input unless implementation validation proves one is necessary.

## Decisions

### Generate Go coverage only when Sonar is enabled

The reusable workflow should keep the current plain `go test` fast path for repositories that do not enable Sonar. When Sonar is enabled and Go files exist, the `test` job should run `go test` with a coverage profile output such as `coverage.out`.

This keeps the fix targeted to the actual Sonar integration problem, avoids unnecessary extra work for non-Sonar repositories, and preserves current behavior for repos that intentionally opt out of Sonar.

Alternative considered:
- Always generate coverage for every Go repository.
  Rejected because it adds ongoing cost and extra outputs for repos that do not use Sonar while solving no additional validated requirement today.

### Keep coverage generation coupled to the existing test job

The workflow should not add a separate coverage-only job. Instead, the existing `test` job should remain the only place that runs Go tests, and it should upload `coverage.out` as an artifact only for the Sonar-enabled path.

This avoids running `go test` twice, keeps test semantics centralized in one job, and gives the later `sonar` job a simple artifact-based handoff.

Alternative considered:
- Add a dedicated coverage job or rerun tests inside the `sonar` job.
  Rejected because both options duplicate compute, increase latency, and create drift risk between the required test gate and the Sonar coverage-producing path.

### Skip Sonar when no Go sources exist

When the reusable workflow detects no Go files in the configured working directory, the `lint` and `test` jobs should remain successful no-ops and the `sonar` job should skip even if Sonar keys are populated.

This avoids misleading zero-coverage results or empty-language analysis in repositories that share the Go workflow contract before they contain real Go code.

Alternative considered:
- Continue running Sonar for no-Go repositories when keys are set.
  Rejected because the current problem is specifically false or missing Go coverage, and a no-Go repository cannot produce meaningful Go coverage input.

### Implement first in `org-dot-github`, then sync templates and cleanup consumers

The executable fix belongs in the shared workflow host repository because that is the runtime source of truth. The planning repo should mirror the contract in its templates, and any temporary repo-local workaround such as the current `backend-api` branch-level customization should be removed after the shared fix lands.

Alternative considered:
- Fix each consumer repository independently.
  Rejected because it would fragment the shared CI model and recreate the same Sonar integration bug in future Go repositories.

## Risks / Trade-offs

- [Artifact handoff adds YAML and one more moving part] -> Keep the artifact scoped to the Sonar-enabled path and document it as part of the reusable workflow contract.
- [Skipped Sonar on no-Go repos may complicate required-check expectations] -> Validate branch-protection behavior during rollout and document that placeholder repos should not require Sonar until they contain Go code.
- [Coverage profile defaults may not cover future multi-module repos] -> Keep the initial contract single-profile and capture multi-module aggregation as a later follow-up if a repo actually needs it.
- [Temporary repo-local workarounds may linger after the shared fix lands] -> Include explicit cleanup tasks for downstream repositories that have forked the shared workflow behavior.

## Migration Plan

1. Update `org-dot-github/.github/workflows/reusable-ci-go.yml` so the Sonar-enabled `test` path generates and uploads `coverage.out`, and the `sonar` job downloads and passes it through `sonar.go.coverage.reportPaths`.
2. Mirror the same contract into `templates/github-actions/org-dot-github/reusable-ci-go.yml`.
3. Verify the repo-entrypoint template still needs no new inputs; update `templates/github-actions/repo-entrypoints/ci-go-service.yml` only if comments or call expectations need clarification.
4. Validate the shared workflow against a Sonar-enabled Go repo and a no-Go consumer path.
5. Remove any temporary repo-local workaround, starting with `backend-api`, once the shared workflow version is available.

## Open Questions

- Should the coverage-producing command standardize on plain `-coverprofile=coverage.out` or preserve the already-proven `-covermode=atomic -coverprofile=coverage.out` form?
