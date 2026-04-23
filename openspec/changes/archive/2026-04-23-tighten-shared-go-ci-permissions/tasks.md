## 1. Shared Workflow Contract

- [x] 1.1 Update `org-dot-github/.github/workflows/reusable-ci-go.yml` so workflow-level permissions remain read-only and only the publish or other cloud-authenticated jobs declare `id-token: write`.
- [x] 1.2 Mirror the same least-privilege permission contract in `templates/github-actions/org-dot-github/reusable-ci-go.yml`.
- [x] 1.3 Confirm whether the repo-entrypoint template also needs a caller-job permission example or comment, and update it if the shared implementation proves that guidance is necessary.

## 2. Downstream Follow-Up

- [x] 2.1 Validate `backend-api/.github/workflows/ci.yml` and move `id-token: write` from workflow level to the reusable-workflow call job if image publish remains enabled after the shared fix.
- [x] 2.2 Validate other consumers of `reusable-ci-go.yml` and confirm which repos still need caller job-level OIDC permissions versus read-only defaults.
- [x] 2.3 Identify any SHA-pinned consumers that must be updated to pick up the shared workflow permission fix.

## 3. Verification

- [ ] 3.1 Verify a publish-enabled consumer can still complete OIDC-based authentication and image publishing after the permission tightening. Note: archived pragmatically after backend-api proved the caller-job permission shape and the shared publish job path on `main`, but the available run still took the "publish configuration pending" branch instead of a fully configured OIDC publish.
- [x] 3.2 Verify lint, test, Sonar, and pull-request image verification continue to run with read-only permissions.
- [x] 3.3 Verify repos that do not enable cloud-authenticated publish paths remain read-only with no repo-specific override.
