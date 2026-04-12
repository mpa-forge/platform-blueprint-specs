# ci-lint-unit-test-jobs Specification

## Purpose
TBD - created by archiving change implement-p4-t02-lint-unit-test-jobs. Update Purpose after archive.
## Requirements
### Requirement: Go reusable CI workflows SHALL enforce lint and unit-test gates
The shared Go CI workflow SHALL run deterministic lint and unit-test jobs for Go repositories. The lint job SHALL use the pinned Go toolchain and SHALL run `golangci-lint` and `go vet`. The unit-test job SHALL run `go test` against the repository code using the same pinned toolchain. The workflow SHALL reuse dependencies or caches where supported so repeated PR runs remain stable and efficient.

#### Scenario: Go PRs fail when lint fails
- **WHEN** a Go repository opens a pull request with lint violations
- **THEN** the Go CI workflow fails the lint job and reports a failing check

#### Scenario: Go PRs fail when tests fail
- **WHEN** a Go repository opens a pull request with a failing unit test
- **THEN** the Go CI workflow fails the unit-test job and reports a failing check

### Requirement: Frontend reusable CI workflows SHALL enforce lint, type-check, and unit-test gates
The shared frontend CI workflow SHALL run deterministic lint, type-check, and unit-test jobs for frontend repositories. The lint job SHALL run `eslint`; the type-check job SHALL run `tsc --noEmit`; the unit-test job SHALL run the repository's configured test command. The workflow SHALL use pinned Node.js and Bun versions and SHALL reuse dependencies through caching where supported.

#### Scenario: Frontend PRs fail when lint or type-check fails
- **WHEN** a frontend repository opens a pull request with ESLint or type-check errors
- **THEN** the shared frontend CI workflow fails the corresponding job and reports a failing check

#### Scenario: Frontend PRs fail when unit tests fail
- **WHEN** a frontend repository opens a pull request with a failing unit-test command
- **THEN** the shared frontend CI workflow fails the unit-test job and reports a failing check

### Requirement: Repo-local CI entrypoints SHALL delegate to the shared reusable workflows without changing baseline triggers
Each target repository SHALL keep a repo-local `.github/workflows/ci.yml` entrypoint that invokes exactly one shared reusable workflow from `org-dot-github`. The entrypoint SHALL preserve the baseline `pull_request`, `push` to `main`, and `workflow_dispatch` triggers and SHALL keep `contents: read` permissions unless a later task explicitly widens them.

#### Scenario: Repo entrypoint continues to delegate
- **WHEN** maintainers inspect a target repository's `ci.yml`
- **THEN** they see a single reusable-workflow call instead of duplicated job logic

#### Scenario: Baseline triggers remain unchanged
- **WHEN** a target repository runs CI on a pull request or push to `main`
- **THEN** the same baseline triggers and read-only permissions still apply after the lint and unit-test jobs are added

