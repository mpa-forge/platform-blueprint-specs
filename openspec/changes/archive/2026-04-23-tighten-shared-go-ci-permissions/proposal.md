## Why

The shared reusable Go CI workflow currently relies on caller workflows such as `backend-api` to grant `id-token: write` broadly at the workflow level, which violates least-privilege guidance and triggered a Sonar security finding. We need the shared workflow contract to narrow elevated permissions to only the jobs that actually perform cloud-authenticated publish work while making any remaining caller-side permission requirements explicit.

## What Changes

- Tighten the shared reusable Go CI workflow so workflow-level permissions stay read-only and only publish or cloud-authenticated jobs receive `id-token: write`.
- Define the permission contract for downstream caller workflows so repo-local entrypoints grant only the maximum permissions required by the reusable workflow call job, instead of setting broad workflow-wide permissions.
- Keep lint, test, Sonar, and image verification paths on read-only permissions unless implementation validation demonstrates a concrete need for more.
- Make repository ownership explicit: planning and specification updates live in `platform-blueprint-specs`, while executable workflow changes land in the shared workflow host repository `org-dot-github`.
- Capture downstream validation and cleanup for consumers such as `backend-api`, including any repo-local permission overrides still needed after the shared fix.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `ci-lint-unit-test-jobs`: The shared CI contract changes so reusable Go workflow jobs use least-privilege `GITHUB_TOKEN` and OIDC permissions, and caller workflows only retain explicit job-level overrides when the reusable workflow cannot elevate permissions on its own.

## Impact

- `openspec/changes/tighten-shared-go-ci-permissions/*`
- `templates/github-actions/org-dot-github/reusable-ci-go.yml`
- `org-dot-github/.github/workflows/reusable-ci-go.yml`
- Repo-local Go CI entrypoints that call the shared workflow, including `backend-api/.github/workflows/ci.yml`, `backend-worker/.github/workflows/ci.yml`, `platform-ai-workers/.github/workflows/ci.yml`, and `platform-observability/.github/workflows/ci.yml`
