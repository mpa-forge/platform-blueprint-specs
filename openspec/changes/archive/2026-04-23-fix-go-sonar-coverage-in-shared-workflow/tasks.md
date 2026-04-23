## 1. Shared Workflow Contract

- [x] 1.1 Update the executable shared reusable workflow in `org-dot-github/.github/workflows/reusable-ci-go.yml` so Sonar-enabled Go test runs generate `coverage.out`, upload it for the Sonar job, and pass `sonar.go.coverage.reportPaths` during analysis.
- [x] 1.2 Mirror the same contract in `templates/github-actions/org-dot-github/reusable-ci-go.yml` and confirm the repo-entrypoint template still requires no new caller-facing inputs.
- [x] 1.3 Document or encode the no-Go-source behavior so the shared workflow skips Sonar analysis when no Go files exist, even if Sonar keys are configured.

## 2. Downstream Rollout

- [x] 2.1 Validate the updated shared workflow against at least one Sonar-enabled Go consumer repository and confirm Sonar imports the generated coverage report.
- [x] 2.2 Remove any temporary repo-local workaround that duplicated the shared workflow fix, starting with `backend-api` once the shared workflow change is available.
- [x] 2.3 Confirm other shared-workflow consumers such as `platform-ai-workers`, `platform-observability`, and `backend-worker` remain compatible with the updated contract.

## 3. Verification

- [x] 3.1 Verify that a Sonar-enabled Go pull request reports non-zero imported coverage when tests exercise covered code.
- [x] 3.2 Verify that a Sonar-disabled repository still uses the prior fast path without a Sonar coverage artifact.
- [x] 3.3 Verify that a no-Go consumer path skips Sonar instead of producing misleading empty coverage results.
