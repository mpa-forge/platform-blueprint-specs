# Reusable CI Workflow Policy

Last updated: 2026-04-14

## Scope

Define the baseline GitHub Actions workflow structure for the platform repositories before
Phase 4 quality, scanning, artifact, and deployment jobs are layered on top.

This policy covers:

- centralized reusable workflow ownership
- repo-local CI entrypoint naming
- repository-to-template mapping
- starter workflow responsibilities for `P4-T01`

## Source of truth

The baseline is intentionally split across three layers:

- policy summary: this file
- planning templates:
  - `templates/github-actions/org-dot-github/`
  - `templates/github-actions/repo-entrypoints/`
- executable rollout targets:
  - `org-dot-github/.github/workflows/` for shared reusable workflows
  - `<repo>/.github/workflows/ci.yml` for each working repository

The planning-repo copies are the canonical editing surface. Rollout to the organization
repository and the six working repositories should preserve the same file names and workflow
names.

## Repository mapping

| Repository | Repo type | Reusable workflow |
| --- | --- | --- |
| `frontend-web` | `frontend` | `reusable-ci-frontend.yml` |
| `backend-api` | `go-service` | `reusable-ci-go.yml` |
| `backend-worker` | `go-service` | `reusable-ci-go.yml` |
| `platform-ai-workers` | `go-service` | `reusable-ci-go.yml` |
| `platform-contracts` | `contracts` | `reusable-ci-contracts.yml` |
| `platform-infra` | `infra` | `reusable-ci-infra.yml` |

## Naming contract

| Concern | Standard |
| --- | --- |
| Repo-local CI entrypoint file | `.github/workflows/ci.yml` |
| Repo-local CI workflow name | `ci` |
| Shared workflow host repo | `mpa-forge/org-dot-github` |
| Shared workflow file prefix | `reusable-ci-` |
| Shared workflow names | `reusable-ci-go`, `reusable-ci-frontend`, `reusable-ci-contracts`, `reusable-ci-infra` |
| Baseline triggers | `pull_request`, `push` to `main`, `workflow_dispatch`, and semver tag pushes when image publishing is enabled |
| Baseline permissions | `contents: read` unless a later phase explicitly needs more |

## `P4-T01` starter contract

The `P4-T01` starter workflows must only establish the shared wiring baseline.

They should:

- check out the repository
- install the minimum toolchain for the repo type
- execute a deterministic baseline command such as `make print-toolchain`
- leave lint, tests, Buf gates, scanning, artifacts, and deploy auth for later tasks

They should not yet:

- publish artifacts
- request cloud credentials
- write packages or images
- enforce vulnerability gates
- introduce required-check names that later tasks would immediately replace

## Repo-local entrypoint contract

Every working repository should call exactly one shared reusable workflow from
`.github/workflows/ci.yml`.

The baseline call pattern is:

1. trigger from `pull_request`, `push` to `main`, and `workflow_dispatch`
2. keep `permissions` at `contents: read`
3. call the repo-type workflow in `mpa-forge/org-dot-github`
4. pass only repo-local inputs such as working directory or tool versions

During the bootstrap baseline the reusable workflow reference may point at `@main` because
`org-dot-github` already uses protected-branch flow and does not yet expose a release-tag
contract. Once reusable workflow release governance exists, callers should move to immutable
tag or SHA pinning without changing the local entrypoint filename.

For Go-service repositories that publish OCI images, the reusable workflow now also supports:

- pull-request-only Docker build verification without registry pushes
- merge and semver-tag image publication using immutable `sha-<git_sha_12>` tags
- optional `v<semver>` aliases that must resolve to the same pushed digest
- repository-variable-driven GAR and WIF wiring so auth can be layered in without forking the workflow

## Future-task guardrails

- `P4-T02` and `P4-T02A` extend the reusable workflows with lint, test, type-check, and
  repository-quality jobs without renaming `ci.yml`.
- `P4-T03` extends the contracts workflow with Buf lint, breaking-change, and generated-code
  drift jobs.
- `P4-T04` through `P4-T08` add build, security, and artifact jobs as new workflow steps or
  jobs under the same reusable workflow family.
- `P4-T09` should bind branch protection to the stable check names produced after the later
  tasks land.

## Rollout checklist

When these templates are propagated:

- copy the reusable workflow templates into `org-dot-github/.github/workflows/`
- copy the matching entrypoint template into each target repository as
  `.github/workflows/ci.yml`
- keep existing repo-local workflows only if they provide checks that are not yet represented
  in the shared baseline
- update this policy and the planning templates together when workflow naming or ownership
  changes
