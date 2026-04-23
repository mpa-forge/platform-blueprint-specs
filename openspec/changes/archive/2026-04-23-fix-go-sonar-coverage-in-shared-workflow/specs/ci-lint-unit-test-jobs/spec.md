## MODIFIED Requirements

### Requirement: Go reusable CI workflows SHALL enforce lint and unit-test gates
The shared Go CI workflow SHALL run deterministic lint and unit-test jobs for Go repositories. The lint job SHALL use the pinned Go toolchain and SHALL run `golangci-lint` and `go vet`. The unit-test job SHALL run `go test` against the repository code using the same pinned toolchain. When Sonar is enabled for a repository and Go files exist, the unit-test job SHALL generate a Go coverage profile and make it available to the Sonar analysis path without requiring repo-local workflow forks. The workflow SHALL reuse dependencies or caches where supported so repeated PR runs remain stable and efficient.

#### Scenario: Go PRs fail when lint fails
- **WHEN** a Go repository opens a pull request with lint violations
- **THEN** the Go CI workflow fails the lint job and reports a failing check

#### Scenario: Go PRs fail when tests fail
- **WHEN** a Go repository opens a pull request with a failing unit test
- **THEN** the Go CI workflow fails the unit-test job and reports a failing check

#### Scenario: Sonar-enabled Go repos publish coverage for analysis
- **WHEN** a Go repository enables Sonar in the shared reusable workflow and the repository contains Go files
- **THEN** the unit-test path generates a Go coverage profile and the Sonar job imports that profile during analysis

## ADDED Requirements

### Requirement: Go reusable CI workflows SHALL avoid misleading Sonar behavior for non-Go or Sonar-disabled repos
The shared Go CI workflow SHALL preserve the existing non-Sonar fast path for repositories that do not provide Sonar configuration. The workflow SHALL treat repositories with no Go files as successful no-op lint and test runs, and it SHALL skip Sonar coverage import behavior for those repositories even when Sonar keys are present.

#### Scenario: Sonar-disabled repos keep the existing test path
- **WHEN** a repository uses the shared Go reusable workflow without Sonar organization and project keys
- **THEN** the workflow runs the normal lint and test jobs without generating or handing off a coverage artifact for Sonar

#### Scenario: Placeholder Go repos do not report empty Sonar coverage
- **WHEN** a repository wired to the shared Go reusable workflow contains no Go files in the configured working directory
- **THEN** the lint and test jobs succeed as explicit no-ops and the Sonar job skips instead of importing an empty Go coverage report
