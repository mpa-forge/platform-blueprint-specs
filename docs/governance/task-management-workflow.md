# Task Management Workflow (P0-T10)

## Purpose
Define and operationalize the cross-repo task management workflow using GitHub Issues + GitHub Projects.

## Project Baseline
- Owner: `mpa-forge` (organization)
- Project title: `Platform Blueprint`
- Project URL: `https://github.com/orgs/mpa-forge/projects/1`

## Board Workflow States
Custom single-select field `Workflow` with states:
- `Backlog`
- `Ready`
- `In Progress`
- `In Review`
- `Blocked`
- `Done`

## Issue Types
Standard issue types (via templates and labels):
- `feature`
- `bug`
- `chore`
- `spike`

## Label Taxonomy
Applied across all current org repositories:
- `type/*`: `type/feature`, `type/bug`, `type/chore`, `type/spike`
- `priority/*`: `priority/p0`, `priority/p1`, `priority/p2`, `priority/p3`
- `env/*`: `env/local`, `env/rc`, `env/prod`
- `area/*`: `area/frontend`, `area/backend-api`, `area/backend-worker`, `area/contracts`, `area/infra`, `area/ai-workers`, `area/docs`, `area/platform`

## Organization-Wide Templates
Shared issue templates are defined in org repo:
- Repository: `https://github.com/mpa-forge/.github`
- Path: `.github/ISSUE_TEMPLATE/`
- Templates:
  - `feature.md`
  - `bug.md`
  - `chore.md`
  - `spike.md`
  - `config.yml` (blank issues disabled)

## Linked Repositories
Project is linked to:
- `mpa-forge/platform-blueprint-specs`
- `mpa-forge/frontend-web`
- `mpa-forge/backend-api`
- `mpa-forge/backend-worker`
- `mpa-forge/platform-ai-workers`
- `mpa-forge/platform-contracts`
- `mpa-forge/platform-infra`

## Baseline Automation Rules
Workflow baseline to enforce:
- Issues/PRs are added to the org project.
- Status transitions follow the `Workflow` field.
- Issues close when linked implementation PRs merge.

Current implementation status:
- Label and template automation baseline is active (org templates + standard labels).
- End-to-end issue flow was validated manually via CLI.
- Additional project-native auto-add/auto-transition rules can be enabled in project workflow settings as a follow-up hardening step.

## End-to-End Validation Evidence
Smoke test executed:
- Issue created: `https://github.com/mpa-forge/platform-blueprint-specs/issues/1`
- Added to org project.
- Workflow transitions applied: `Backlog` -> `Ready` -> `In Progress` -> `In Review` -> `Done`
- Issue closed after flow validation.

## Operating Rules
- All planned work starts as a GitHub issue in a linked repo.
- Every implementation PR must reference an issue.
- Project `Workflow` state is the source of truth for delivery status.
