# ci-lint-unit-test-jobs Specification

## Purpose
TBD - created by archiving change implement-p4-t02-lint-unit-test-jobs. Update Purpose after archive.
## Requirements
### Requirement: Go reusable CI workflows SHALL enforce lint and unit-test gates
The shared Go CI workflow SHALL run deterministic lint and unit-test jobs for Go repositories. The lint job SHALL use the pinned Go toolchain and SHALL run `golangci-lint` and `go vet`. The unit-test job SHALL run `go test` against the repository code using the same pinned toolchain. When Sonar is enabled for a repository and Go files exist, the unit-test job SHALL generate a Go coverage profile and make it available to the Sonar analysis path without requiring repo-local workflow forks. The workflow SHALL reuse dependencies or caches where supported so repeated PR runs remain stable and efficient. The reusable workflow root SHALL keep read-only `GITHUB_TOKEN` permissions, and only a job with a demonstrated cloud-authentication or publish requirement SHALL declare broader permissions such as `id-token: write`.

#### Scenario: Go PRs fail when lint fails
- **WHEN** a Go repository opens a pull request with lint violations
- **THEN** the Go CI workflow fails the lint job and reports a failing check

#### Scenario: Go PRs fail when tests fail
- **WHEN** a Go repository opens a pull request with a failing unit test
- **THEN** the Go CI workflow fails the unit-test job and reports a failing check

#### Scenario: Sonar-enabled Go repos publish coverage for analysis
- **WHEN** a Go repository enables Sonar in the shared reusable workflow and the repository contains Go files
- **THEN** the unit-test path generates a Go coverage profile and the Sonar job imports that profile during analysis

#### Scenario: Read-only jobs do not receive OIDC write access
- **WHEN** the shared Go workflow runs lint, test, Sonar, or pull-request image verification jobs
- **THEN** those jobs run without `id-token: write` unless a documented implementation change proves they require cloud authentication

### Requirement: Frontend reusable CI workflows SHALL enforce lint, type-check, and unit-test gates
The shared frontend CI workflow SHALL run deterministic lint, type-check, and unit-test jobs for frontend repositories. The lint job SHALL run `eslint`; the type-check job SHALL run `tsc --noEmit`; the unit-test job SHALL run the repository's configured test command. The workflow SHALL use pinned Node.js and Bun versions and SHALL reuse dependencies through caching where supported.

#### Scenario: Frontend PRs fail when lint or type-check fails
- **WHEN** a frontend repository opens a pull request with ESLint or type-check errors
- **THEN** the shared frontend CI workflow fails the corresponding job and reports a failing check

#### Scenario: Frontend PRs fail when unit tests fail
- **WHEN** a frontend repository opens a pull request with a failing unit-test command
- **THEN** the shared frontend CI workflow fails the unit-test job and reports a failing check

### Requirement: Repo-local CI entrypoints SHALL delegate to the shared reusable workflows without changing baseline triggers
Each target repository SHALL keep a repo-local `.github/workflows/ci.yml` entrypoint that invokes exactly one shared reusable workflow from `org-dot-github`. The entrypoint SHALL preserve the baseline `pull_request`, `push` to `main`, and `workflow_dispatch` triggers. The caller workflow root SHALL keep read-only permissions by default, and any repository that needs to enable a shared reusable job requiring OIDC SHALL grant `id-token: write` only on the reusable-workflow call job, not at the workflow root.

#### Scenario: Repo entrypoint continues to delegate
- **WHEN** maintainers inspect a target repository's `ci.yml`
- **THEN** they see a single reusable-workflow call instead of duplicated job logic

#### Scenario: Baseline triggers remain unchanged
- **WHEN** a target repository runs CI on a pull request or push to `main`
- **THEN** the same baseline triggers remain unchanged after the CI contract updates

#### Scenario: Publish-enabled caller grants OIDC only to the call job
- **WHEN** a repository enables a shared reusable Go workflow path that authenticates to a cloud provider for image publish
- **THEN** the repository grants `id-token: write` on the reusable-workflow call job only
- **AND** the workflow-level permissions remain read-only

#### Scenario: Read-only caller does not add unnecessary OIDC permission
- **WHEN** a repository consumes the shared Go workflow only for lint, test, Sonar, or other read-only jobs
- **THEN** the caller workflow remains read-only and does not add `id-token: write`

### Requirement: Go reusable CI workflows SHALL avoid misleading Sonar behavior for non-Go or Sonar-disabled repos
The shared Go CI workflow SHALL preserve the existing non-Sonar fast path for repositories that do not provide Sonar configuration. The workflow SHALL treat repositories with no Go files as successful no-op lint and test runs, and it SHALL skip Sonar coverage import behavior for those repositories even when Sonar keys are present.

#### Scenario: Sonar-disabled repos keep the existing test path
- **WHEN** a repository uses the shared Go reusable workflow without Sonar organization and project keys
- **THEN** the workflow runs the normal lint and test jobs without generating or handing off a coverage artifact for Sonar

#### Scenario: Placeholder Go repos do not report empty Sonar coverage
- **WHEN** a repository wired to the shared Go reusable workflow contains no Go files in the configured working directory
- **THEN** the lint and test jobs succeed as explicit no-ops and the Sonar job skips instead of importing an empty Go coverage report
