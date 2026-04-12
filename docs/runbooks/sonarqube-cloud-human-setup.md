# SonarQube Cloud Human Setup Runbook

This runbook is for future projects created from the platform blueprint
templates. It documents the provider-side and GitHub-admin steps a human needs
to complete before an agent wires SonarQube Cloud into repository CI.

Use this when:

- a new GitHub organization or repo set needs SonarQube Cloud
- a new platform project is bootstrapped from the blueprint templates
- Sonar tokens, project imports, or branch-protection settings need rotation or
  repair

## Goal

Create a repeatable SonarQube Cloud baseline so template-derived repositories
can publish PR quality-gate checks through GitHub Actions.

## Defaults

- Provider: `SonarQube Cloud`
- Baseline plan: `Free`
- GitHub secret name: `SONAR_TOKEN`
- Default project-key convention: `<org-key>_<repo-name>`

## Human-Owned Setup

### 1. Create or confirm the SonarQube Cloud organization

1. Sign in to SonarQube Cloud with the GitHub account that can install or
   manage the target GitHub organization.
2. Import or bind the target GitHub organization inside SonarQube Cloud.
3. Confirm the SonarQube Cloud organization key.
4. Confirm the billing plan and record whether the rollout is still on the
   `Free` plan.

Record:

- SonarQube Cloud organization name
- SonarQube Cloud organization key
- GitHub organization name
- plan tier

### 2. Import repositories as SonarQube Cloud projects

For each repository that should get Sonar analysis:

1. Open the SonarQube Cloud organization.
2. Import the GitHub repository as a project.
3. Let SonarQube Cloud run or complete the initial analysis.
4. Open the project and confirm analysis results are visible.

At this stage, the project only needs to exist and analyze successfully at
least once. CI quality-gate wiring can come later.

### 3. Retrieve the Sonar project key for each imported project

For each imported project:

1. Open the project in SonarQube Cloud.
2. In the left sidebar, open `Information`.
3. Copy the project key.
4. Record the key in the project inventory.

Recommended inventory fields:

- repository name
- Sonar project name
- Sonar project key
- analysis confirmed: `yes/no`

### 4. Generate the GitHub Actions token in SonarQube Cloud

On the `Free` plan, use a personal access token.

1. In SonarQube Cloud, open the account menu.
2. Open `My Account`.
3. Open `Security`.
4. Create a new token with a clear purpose-specific name such as:
   `github-actions-<org-name>`
5. Choose an expiration aligned with the rotation policy.
6. Generate the token.
7. Copy the token immediately and store it securely.

Notes:

- SonarQube Cloud only shows the raw token value once.
- If the token is lost, create a new one and rotate the GitHub secret.

### 5. Store the token as a GitHub Actions secret

Recommended location:

- GitHub organization -> `Settings` -> `Secrets and variables` -> `Actions`

Recommended secret name:

- `SONAR_TOKEN`

Steps:

1. Create an org Actions secret named `SONAR_TOKEN`.
2. Paste the SonarQube Cloud token value.
3. Scope the secret to the repositories that will run Sonar analysis.
4. Confirm the secret appears in the org Actions secret list.

Use a repo-level secret only when the rollout intentionally avoids an org-level
shared secret.

### 6. Verify secret access policy

For each repository in scope:

1. Confirm the repo is included in the org-secret access policy.
2. If the policy is selective instead of `ALL`, add the repo explicitly.
3. Re-check the policy whenever a new repository is added to the Sonar rollout.

### 7. Validate quality-gate checks after CI wiring

Once the agent has added Sonar jobs:

1. Open a PR in each target repository.
2. Confirm Sonar analysis runs in GitHub Actions.
3. Confirm SonarQube Cloud reports a stable PR check or quality-gate status in
   GitHub.
4. Record the exact check name for branch-protection use.

Expected implementation pattern:

- repo-local `ci.yml` stays a thin caller
- caller workflow passes only the specific reusable-workflow secrets it needs
- shared reusable workflow receives:
  - `sonar-organization-key`
  - `sonar-project-key`
- reusable workflow reads `SONAR_TOKEN` from GitHub Actions secrets and runs
  the Sonar scan after the main validation jobs succeed
- frontend callers also pass `GH_PACKAGES_TOKEN` only when private package
  installation requires it

### 8. Enforce branch protection

Once the quality-gate check names are stable:

1. Open branch-protection settings for each repository.
2. Add the Sonar quality-gate check as a required status check.
3. Confirm merges are blocked when the Sonar quality gate fails.

## Human Checklist

- [ ] SonarQube Cloud organization created or confirmed
- [ ] GitHub organization binding created or confirmed
- [ ] plan tier confirmed and recorded
- [ ] target repositories imported as SonarQube Cloud projects
- [ ] initial analyses confirmed
- [ ] project keys recorded
- [ ] `SONAR_TOKEN` generated in SonarQube Cloud
- [ ] `SONAR_TOKEN` stored as a GitHub Actions Actions secret
- [ ] secret access verified for rollout repositories
- [ ] PR quality-gate checks observed in GitHub
- [ ] branch protection updated to require Sonar checks

## Handoff To The Agent

Before asking an agent to wire Sonar into CI, provide:

- GitHub organization name
- SonarQube Cloud organization key
- list of target repositories
- Sonar project key for each repository
- the GitHub secret name used for the token

## Maintenance Notes

Update this runbook if any of these defaults change:

- provider
- plan assumptions
- token naming
- project-key convention
- GitHub secret location
