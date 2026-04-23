---
name: platform-sonarqube-rollout
description: Wire SonarQube Cloud analysis and quality-gate checks into platform repositories that were created from the blueprint templates. Use when a repo or repo set already exists in SonarQube Cloud and the remaining work is code/config changes in shared workflows, repo entrypoints, and repo-local scan configuration.
---

# Platform SonarQube Rollout

Use this skill when SonarQube Cloud provider setup already exists and the task
is to add or update the code/config needed for CI-based Sonar analysis.

This skill assumes a human has already supplied:

- SonarQube Cloud organization key
- target repositories
- Sonar project key for each target repository
- GitHub Actions secret name for the Sonar token

If those inputs are missing, stop and ask for them or point to the human
runbook:

- [sonarqube-cloud-human-setup.md](C:/Users/Miquel/dev/platform-blueprint-specs/docs/runbooks/sonarqube-cloud-human-setup.md)

## Default Goal

Add SonarQube Cloud analysis to template-derived repositories in a way that:

- reuses shared GitHub Actions workflows where possible
- keeps repo entrypoints thin
- works with GitHub Actions reusable workflows
- produces stable PR quality-gate checks that can be used by branch protection

## Required Inputs

Before changing code, collect and record:

- Sonar organization key
- Sonar token secret name, usually `SONAR_TOKEN`
- per-repo Sonar project key
- target repos in scope
- whether coverage should be wired now or deferred

Do not infer or invent project keys.

## Workflow

### 1. Confirm the current CI topology

Identify:

- the shared reusable workflow repo
- the matching template copies
- the repo-local workflow entrypoints
- whether `secrets: inherit` is already present in repo entrypoints

In this platform, start with:

- `.github` repo workflow files
- `platform-blueprint-specs/templates/github-actions/org-dot-github`
- `platform-blueprint-specs/templates/github-actions/repo-entrypoints`

### 2. Choose the integration pattern

Prefer this order:

1. add Sonar analysis to shared reusable workflows
2. keep repo entrypoint workflows as thin callers
3. add repo-local config files only when a repo needs custom scan settings

Avoid duplicating a full Sonar job in every repo unless the repo genuinely
needs a special-case workflow.

### 3. Pass secrets correctly through reusable workflows

For repo-local caller workflows, pass only the specific secrets the reusable
workflow needs:

```yaml
jobs:
  ci:
    uses: owner/.github/.github/workflows/reusable-ci-<kind>.yml@main
    secrets:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

For the reusable workflow, read the secret directly:

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

Declare reusable-workflow secrets explicitly under `workflow_call.secrets`, and
do not use `secrets: inherit` unless there is a deliberate reviewed reason.

### 4. Wire Sonar identifiers explicitly

For each target repository, the workflow or config must receive:

- Sonar organization key
- Sonar project key

Prefer explicit configuration over hidden defaults.

Recommended reusable-workflow contract:

- `workflow_call` inputs:
  - `sonar-organization-key`
  - `sonar-project-key`
- caller workflows pass those values explicitly
- reusable workflow runs Sonar only when both inputs are non-empty
- reusable workflow grants at least:
  - `contents: read`
  - `pull-requests: read`
- when packages from GitHub Packages are required, preserve the existing auth
  setup before the Sonar install step and pass `GH_PACKAGES_TOKEN` explicitly

### 5. Decide where repo-specific config lives

Use workflow-only config when the repo is simple.

Add a committed `sonar-project.properties` file when the repo needs stable,
reviewable settings such as:

- source/test path declarations
- exclusions
- coverage report paths
- generated-file exclusions

### 6. Preserve template alignment

Whenever a shared Sonar workflow change is made:

1. update the executable workflow in the shared workflow repo
2. update the matching template in `platform-blueprint-specs`
3. update repo entrypoint templates if the contract changes
4. update any already-instantiated repo workflow entrypoints if needed

### 7. Validate after wiring

Run the strongest available repo-local checks, then verify in GitHub:

- the workflow still parses
- Sonar analysis runs
- PR status checks appear
- the quality-gate check has a stable name

Document the final check names for branch protection.

## Output Expectations

A complete rollout should leave behind:

- shared reusable workflow updates
- matching template updates
- repo entrypoint updates when needed
- repo-local Sonar config files where needed
- documentation or evidence showing the final PR check names

## Guardrails

- Do not create or rotate provider tokens from code.
- Do not hardcode token values anywhere in the repo.
- Do not guess project keys.
- Do not bypass reusable-workflow structure without a repo-specific reason.
- Keep the shared workflow contract stable across template and executable copies.

## Validation Prompt

Before finishing, ask:

- did I wire Sonar through the shared workflow path first?
- did I preserve `secrets: inherit` where reusable workflows need it?
- did I document the final quality-gate check name for branch protection?
- did I update both executable workflow files and template copies?
