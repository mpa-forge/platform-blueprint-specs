# Repo Agent Docs Evidence (`P1-T12B`)

Last updated: 2026-03-08

## Scope

This document records the rollout of baseline agent context and automated-worker skill files to all working repositories, and the later refactor that moved shared agent context into targeted planning-repo documents.

## Canonical templates

Planning repo templates:

- `templates/agent-docs/AGENTS.md`
- `.codex/skills/automated-ai-worker/SKILL.md`

Shared planning-repo agent docs:

- `common/AGENTS.md`

## Repositories updated

- `frontend-web`
- `backend-api`
- `backend-worker`
- `platform-ai-workers`
- `platform-contracts`
- `platform-infra`

## Delivered files in each working repo

- `AGENTS.md`
- shared reference to `../platform-blueprint-specs/.codex/skills/automated-ai-worker/SKILL.md`

## Baseline content delivered

Fixed context in `AGENTS.md`:

- read `README.md` and `Makefile` first
- prefer repo-local entrypoints
- run repo validation commands
- use short-lived branches
- use `gh` for PR creation/update
- keep the worktree clean

Automated worker skill:

- task execution workflow
- validation order
- GitHub CLI usage expectations
- explicit prohibition on merging or bypassing failed validation

## Shared-context refactor

The repo-local `AGENTS.md` files were later reduced to thin entrypoints that load:

- local repo docs (`README.md`, `Makefile`, selected `docs/` files)
- shared workspace guidance from `platform-blueprint-specs/common/AGENTS.md`
- repo-specific planning or sibling-repo docs only where needed

This keeps shared guidance centralized while letting each working repo own its own role- and task-specific agent context.

## Refactor merge evidence

- `frontend-web`
  - PR: `https://github.com/mpa-forge/frontend-web/pull/13`
- `backend-api`
  - PR: `https://github.com/mpa-forge/backend-api/pull/17`
- `backend-worker`
  - PR: `https://github.com/mpa-forge/backend-worker/pull/13`
- `platform-ai-workers`
  - PR: `https://github.com/mpa-forge/platform-ai-workers/pull/18`
- `platform-contracts`
  - PR: `https://github.com/mpa-forge/platform-contracts/pull/10`
- `platform-infra`
  - PR: `https://github.com/mpa-forge/platform-infra/pull/14`

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
