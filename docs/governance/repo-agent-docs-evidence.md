# Repo Agent Docs Evidence (`P1-T12B`)

Last updated: 2026-03-08

## Scope

This document records the rollout of baseline agent context and automated-worker skill files to all working repositories, and the later refactor that moved shared agent context into targeted planning-repo documents.

## Canonical templates

Planning repo templates:

- `templates/agent-docs/AGENTS.md`
- `templates/agent-docs/.codex/skills/automated-ai-worker/SKILL.md`

Shared planning-repo agent docs:

- `docs/shared/agent-common-operating-rules.md`
- `docs/shared/agent-platform-workspace-map.md`
- `docs/shared/repo-context/frontend-web.md`
- `docs/shared/repo-context/backend-api.md`
- `docs/shared/repo-context/backend-worker.md`
- `docs/shared/repo-context/platform-ai-workers.md`
- `docs/shared/repo-context/platform-contracts.md`
- `docs/shared/repo-context/platform-infra.md`

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

## Shared-context refactor

The repo-local `AGENTS.md` files were later reduced to thin entrypoints that load:

- local repo docs (`README.md`, `Makefile`, selected `docs/` files)
- shared operating rules from `platform-blueprint-specs`
- one repo-specific shared context file from `platform-blueprint-specs`

This keeps duplicated context out of the working repos while preserving automatic discovery from each repo root.

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
