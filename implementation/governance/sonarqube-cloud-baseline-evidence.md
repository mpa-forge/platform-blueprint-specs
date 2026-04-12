# SonarQube Cloud Baseline Evidence (`P4-T02A`)

## Summary

`mpa-forge` now has a SonarQube Cloud organization on the Free plan with an
initial set of imported platform repositories. Those projects have already been
analyzed, which closes the provider-side baseline setup portion of `P4-T02A`
before CI quality-gate wiring is added.

## Organization Baseline

- SonarQube Cloud organization key: `mpa-forge`
- Plan: `Free`
- GitHub organization bound: `mpa-forge`

## Imported Projects

Imported and analyzed projects currently confirmed:

- `backend-api` -> `mpa-forge_backend-api`
- `frontend-web` -> `mpa-forge_frontend-web`
- `platform-ai-workers` -> `mpa-forge_platform-ai-workers`
- `platform-contracts` -> `mpa-forge_platform-contracts`
- `platform-frontend-observability` -> `mpa-forge_platform-frontend-observability`
- `platform-observability` -> `mpa-forge_platform-observability`

## Project Key Convention

The current SonarQube Cloud project-key convention is:

- `<org-key>_<repo-name>`

Examples:

- `mpa-forge_backend-api`
- `mpa-forge_frontend-web`

## Remaining Work For `P4-T02A`

The provider baseline is in place, and the CI integration rollout is underway.
Current status:

- GitHub Actions secret baseline documented with shared secret name
  `SONAR_TOKEN`
- shared reusable CI workflows updated to accept Sonar organization and project
  keys and to run `SonarSource/sonarqube-scan-action`
- repo entrypoint templates updated to expose Sonar organization and project
  key inputs
- current repo entrypoints wired for:
  - `backend-api`
  - `frontend-web`
  - `platform-ai-workers`
  - `platform-contracts`

Remaining implementation work:

- push and merge the shared workflow updates in the `.github` repo
- verify PR analysis produces stable quality-gate checks in GitHub
- record the final required-check names for branch protection
- extend the rollout to any additional repositories once they gain CI
  entrypoints

## Outcome

- SonarQube Cloud organization baseline: complete
- Project import baseline: complete for the repositories listed above
- CI quality-gate integration: pending
