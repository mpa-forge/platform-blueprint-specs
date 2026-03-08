# Repo Agent Docs Evidence (`P1-T12B`)

Last updated: 2026-03-08

## Scope

This document records the rollout of baseline agent context and automated-worker skill files to all working repositories.

## Canonical templates

Planning repo templates:

- `templates/agent-docs/AGENTS.md`
- `templates/agent-docs/.codex/skills/automated-ai-worker/SKILL.md`

## Repositories updated

- `frontend-web`
- `backend-api`
- `backend-worker`
- `platform-ai-workers`
- `platform-contracts`
- `platform-infra`

## Delivered files in each working repo

- `AGENTS.md`
- `.codex/skills/automated-ai-worker/SKILL.md`

## Baseline content delivered

Fixed context in `AGENTS.md`:

- read `README.md` and `Makefile` first
- prefer repo-local entrypoints
- run repo validation commands
- use short-lived branches
- use `gh` for draft PR creation/update
- keep the worktree clean

Automated worker skill:

- task execution workflow
- validation order
- GitHub CLI usage expectations
- explicit prohibition on merging or bypassing failed validation

## Merge evidence

- `frontend-web`
  - PR: `https://github.com/mpa-forge/frontend-web/pull/12`
- `backend-api`
  - PR: `https://github.com/mpa-forge/backend-api/pull/16`
- `backend-worker`
  - PR: `https://github.com/mpa-forge/backend-worker/pull/12`
- `platform-ai-workers`
  - PR: `https://github.com/mpa-forge/platform-ai-workers/pull/17`
- `platform-contracts`
  - PR: `https://github.com/mpa-forge/platform-contracts/pull/9`
- `platform-infra`
  - PR: `https://github.com/mpa-forge/platform-infra/pull/13`
