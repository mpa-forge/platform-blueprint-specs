# Repo Hygiene Guardrails Evidence

Last updated: 2026-03-08

## Scope

This document records the rollout of repo guardrails added to reduce Windows tooling drift, line-ending churn, PR workflow ambiguity, and missed cross-repo documentation updates.

## Planning Repo Deliverables

- `.gitattributes`
- `docs/standards/windows-developer-tooling.md`
- `scripts/windows-tooling-doctor.ps1`
- `docs/governance/shared-change-checklist.md`
- `templates/repo-files/.gitattributes`
- updated shared agent rules and automated worker template guidance

## Working Repo Rollout

Applied to:

- `frontend-web`
- `backend-api`
- `backend-worker`
- `platform-ai-workers`
- `platform-contracts`
- `platform-infra`

Changes in each repo:

- added `.gitattributes`
- updated `.codex/skills/automated-ai-worker/SKILL.md`

Behavioral changes:

- line endings are normalized by repo policy instead of relying on hook fixes alone
- automated workflows are instructed to run pre-commit before commit when configured
- normal PRs are now the default, not draft PRs

## Org-Level GitHub Template Rollout

Repo:

- `mpa-forge/.github`

Change:

- added `.github/pull_request_template.md`

Checklist coverage:

- validation performed or explicitly skipped
- explicit cross-repo impact check
- explicit `platform-blueprint-specs` update check when cross-repo impact exists

## Merge Evidence

- `frontend-web`
  - PR: `https://github.com/mpa-forge/frontend-web/pull/14`
- `backend-api`
  - PR: `https://github.com/mpa-forge/backend-api/pull/20`
- `backend-worker`
  - PR: `https://github.com/mpa-forge/backend-worker/pull/15`
- `platform-ai-workers`
  - PR: `https://github.com/mpa-forge/platform-ai-workers/pull/20`
- `platform-contracts`
  - PR: `https://github.com/mpa-forge/platform-contracts/pull/11`
- `platform-infra`
  - PR: `https://github.com/mpa-forge/platform-infra/pull/15`
- `mpa-forge/.github`
  - PR: `https://github.com/mpa-forge/.github/pull/1`
