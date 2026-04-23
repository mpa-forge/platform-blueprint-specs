## Context

The reusable Go CI workflow is owned by `org-dot-github` and mirrored in this planning repo under `templates/github-actions/org-dot-github/reusable-ci-go.yml`. Today that workflow keeps workflow-level permissions at `contents: read` and `pull-requests: read`, then grants `id-token: write` only inside the `api-image-publish` job, which is the correct least-privilege shape inside the shared workflow itself.

The current Sonar finding is surfacing in `backend-api` because its caller workflow sets `id-token: write` at the workflow level before invoking the reusable workflow. GitHub reusable workflow semantics mean the caller job controls the maximum `GITHUB_TOKEN` permissions available to the called workflow, and the called workflow can only keep or reduce that scope. That means the shared fix has two parts: preserve strict job-level permissions inside `org-dot-github`, and require any caller that needs OIDC-backed publish jobs to move `id-token: write` onto the reusable-workflow call job instead of the workflow root.

This change is planning-led in `platform-blueprint-specs`, but implementation belongs in `org-dot-github`, with downstream validation in consuming repos such as `backend-api`.

## Goals / Non-Goals

**Goals:**
- Make the shared Go reusable workflow explicitly least-privilege at the workflow and job levels.
- Ensure only jobs that perform OIDC-backed cloud authentication or image publishing receive `id-token: write`.
- Keep lint, test, Sonar, and pull-request image verification on read-only permissions.
- Define the downstream caller contract clearly enough that Sonar/security findings can be resolved without repo-specific guesswork.
- Identify which consuming repos need follow-up caller-side permission changes after the shared workflow fix.

**Non-Goals:**
- Redesign the overall Go CI job graph beyond permission scoping.
- Introduce repo-specific workflow forks unless validation proves a consumer has unique permission needs.
- Change non-Go reusable workflows in the same proposal.
- Replace the current image publish architecture or cloud provider authentication mechanism.

## Decisions

### Keep shared workflow root permissions read-only

The reusable workflow root should remain limited to read-only permissions such as `contents: read` and `pull-requests: read`. Jobs that do not authenticate to cloud providers must inherit only this read-only baseline.

This preserves least privilege for `toolchain`, `lint`, `test`, `sonar`, and `api-image-verify`, and it matches the actual permissions currently required by those jobs.

Alternative considered:
- Grant `id-token: write` at the reusable workflow root.
  Rejected because it would widen permissions for every job in the shared workflow and recreate the same least-privilege issue at a different layer.

### Keep OIDC permission at the exact publish job that uses cloud authentication

The `api-image-publish` job should remain the only known job in the shared Go workflow with `id-token: write`, because it alone performs `google-github-actions/auth` and GAR publish operations. If future jobs need OIDC, they must declare it at that job only.

Alternative considered:
- Move `id-token: write` to an earlier shared job such as `test` or `sonar`.
  Rejected because those jobs do not currently perform cloud authentication and there is no demonstrated need for OIDC there.

### Require caller workflows to use job-level permission overrides when OIDC is needed

Because reusable workflows cannot elevate permissions beyond what the caller grants, consuming repos that enable OIDC-backed publish paths must set `permissions` on the reusable-workflow call job, not at the workflow root. Repos that do not use publish or cloud-authenticated jobs can stay fully read-only at the caller level.

This makes the repo-local follow-up explicit for `backend-api` and any other consumer that enables `image-build-enabled` with publish-on-push behavior. It also keeps the shared fix aligned with GitHub's reusable workflow permission model instead of assuming the shared workflow alone can resolve every finding.

Alternative considered:
- Treat the shared workflow change as sufficient and leave caller permissions undocumented.
  Rejected because the caller permission ceiling is a real platform constraint and would leave downstream repos with unresolved findings.

### Validate consumers individually after the shared fix

The planning change should explicitly call for validation in downstream repositories to determine whether each caller still needs a job-level `id-token: write` override. `backend-api` is expected to need one because it enables image publishing. `backend-worker` currently appears read-only and may not need any override. `platform-ai-workers` and `platform-observability` currently enable Sonar but not image publish and should remain read-only unless later jobs add cloud auth.

Alternative considered:
- Apply a blanket caller-side permission rule to every consumer.
  Rejected because some consumers do not need OIDC and should not receive broader permissions just for consistency.

## Risks / Trade-offs

- [Caller-side follow-up is easy to miss after the shared workflow fix] -> Include explicit downstream validation tasks and identify the known likely affected repos in the change artifacts.
- [Future shared jobs may quietly add cloud auth and accidentally inherit insufficient permissions] -> Require each new cloud-authenticated job to declare its own job-level permissions and document any matching caller requirement.
- [Pinned reusable workflow refs may delay adoption in some repos] -> Validate both `@main` consumers and SHA-pinned consumers so follow-up rollout is planned, not assumed.
- [Security scanners may still flag callers if the call job keeps broad permissions] -> Make the caller contract explicit: move OIDC permission from workflow level to the reusable-workflow call job.

## Migration Plan

1. Update the shared proposal/specs in `platform-blueprint-specs` to encode the least-privilege contract and repo ownership.
2. Implement the executable workflow change in `org-dot-github/.github/workflows/reusable-ci-go.yml`, preserving read-only workflow root permissions and job-scoped `id-token: write` only where OIDC is actually used.
3. Sync the mirrored planning template at `templates/github-actions/org-dot-github/reusable-ci-go.yml`.
4. Validate downstream callers:
   - `backend-api`: move `id-token: write` from workflow level to the reusable-workflow call job if publish remains enabled.
   - `backend-worker`: confirm no OIDC override is needed while it remains read-only.
   - `platform-ai-workers` and `platform-observability`: confirm Sonar-only callers remain read-only and only need ref bumps if they pin the shared workflow SHA.
5. Re-run CI/security validation in at least one publish-enabled consumer and one read-only consumer.

## Open Questions

- Should the caller-side permission contract also be mirrored into repo-entrypoint templates now, or should that be a follow-up once the shared workflow implementation PR confirms the final syntax and examples?
