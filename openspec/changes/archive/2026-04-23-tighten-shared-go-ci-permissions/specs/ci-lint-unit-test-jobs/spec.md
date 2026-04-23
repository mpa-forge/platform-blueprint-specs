## MODIFIED Requirements

### Requirement: Go reusable CI workflows SHALL enforce lint and unit-test gates
The shared Go CI workflow SHALL run deterministic lint and unit-test jobs for Go repositories. The lint job SHALL use the pinned Go toolchain and SHALL run `golangci-lint` and `go vet`. The unit-test job SHALL run `go test` against the repository code using the same pinned toolchain. The workflow SHALL reuse dependencies or caches where supported so repeated PR runs remain stable and efficient. The reusable workflow root SHALL keep read-only `GITHUB_TOKEN` permissions, and only a job with a demonstrated cloud-authentication or publish requirement SHALL declare broader permissions such as `id-token: write`.

#### Scenario: Go PRs fail when lint fails
- **WHEN** a Go repository opens a pull request with lint violations
- **THEN** the Go CI workflow fails the lint job and reports a failing check

#### Scenario: Go PRs fail when tests fail
- **WHEN** a Go repository opens a pull request with a failing unit test
- **THEN** the Go CI workflow fails the unit-test job and reports a failing check

#### Scenario: Read-only jobs do not receive OIDC write access
- **WHEN** the shared Go workflow runs lint, test, Sonar, or pull-request image verification jobs
- **THEN** those jobs run without `id-token: write` unless a documented implementation change proves they require cloud authentication

### Requirement: Repo-local CI entrypoints SHALL delegate to the shared reusable workflows without changing baseline triggers
Each target repository SHALL keep a repo-local `.github/workflows/ci.yml` entrypoint that invokes exactly one shared reusable workflow from `org-dot-github`. The entrypoint SHALL preserve the baseline `pull_request`, `push` to `main`, and `workflow_dispatch` triggers. The caller workflow root SHALL keep read-only permissions by default, and any repository that needs to enable a shared reusable job requiring OIDC SHALL grant `id-token: write` only on the reusable-workflow call job, not at the workflow root.

#### Scenario: Repo entrypoint continues to delegate
- **WHEN** maintainers inspect a target repository's `ci.yml`
- **THEN** they see a single reusable-workflow call instead of duplicated job logic

#### Scenario: Baseline triggers remain unchanged
- **WHEN** a target repository runs CI on a pull request or push to `main`
- **THEN** the same baseline triggers remain unchanged after the permission tightening

#### Scenario: Publish-enabled caller grants OIDC only to the call job
- **WHEN** a repository enables a shared reusable Go workflow path that authenticates to a cloud provider for image publish
- **THEN** the repository grants `id-token: write` on the reusable-workflow call job only
- **AND** the workflow-level permissions remain read-only

#### Scenario: Read-only caller does not add unnecessary OIDC permission
- **WHEN** a repository consumes the shared Go workflow only for lint, test, Sonar, or other read-only jobs
- **THEN** the caller workflow remains read-only and does not add `id-token: write`
