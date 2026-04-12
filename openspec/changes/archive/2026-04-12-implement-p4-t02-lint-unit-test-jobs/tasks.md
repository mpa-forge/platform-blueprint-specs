## 1. Shared Workflow Jobs

- [x] 1.1 Add lint and unit-test jobs to `templates/github-actions/org-dot-github/reusable-ci-go.yml` with pinned toolchain versions and cache-aware dependency setup.
- [x] 1.2 Add lint, type-check, and unit-test jobs to `templates/github-actions/org-dot-github/reusable-ci-frontend.yml` with pinned Node.js/Bun versions and cache-aware dependency setup.
- [x] 1.3 Update the shared workflow defaults and job names so failed lint or unit-test runs produce stable checks for later branch-protection wiring.

## 2. Repo Workflow Rollout

- [x] 2.1 Update `templates/github-actions/repo-entrypoints/ci-go-service.yml` and `templates/github-actions/repo-entrypoints/ci-frontend.yml` to call the expanded reusable workflows without changing triggers or permissions.
- [x] 2.2 Mirror the reusable workflow updates into the executable `org-dot-github/.github/workflows/` copies.
- [x] 2.3 Mirror the repo-local `ci.yml` entrypoints into `frontend-web`, `backend-api`, `backend-worker`, and `platform-ai-workers` so each repo uses the shared lint and unit-test gates.

## 3. Validation and Evidence

- [x] 3.1 Validate that a failing lint job fails the shared Go and frontend CI paths.
- [x] 3.2 Validate that a failing unit-test job fails the shared Go and frontend CI paths.
- [x] 3.3 Capture the final workflow names and check identities needed for the later branch-protection task.
