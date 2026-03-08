# AI Worker Baseline Evidence (`P1-T11`)

Last updated: 2026-03-08

## Scope

This document records the initial runnable implementation of `platform-ai-workers`.

## Merged repository

- `platform-ai-workers`
  - PR: `https://github.com/mpa-forge/platform-ai-workers/pull/12`
  - merged at: `2026-03-08T01:01:15Z`

## Delivered artifacts

- Go worker entrypoint:
  - `platform-ai-workers/cmd/worker/main.go`
- Runtime packages:
  - `platform-ai-workers/internal/config/config.go`
  - `platform-ai-workers/internal/app/app.go`
  - `platform-ai-workers/internal/githubcli/client.go`
  - `platform-ai-workers/internal/workspace/workspace.go`
  - `platform-ai-workers/internal/agent/codex.go`
  - `platform-ai-workers/internal/prompt/prompt.go`
- Prompt template:
  - `platform-ai-workers/prompts/task.md.tmpl`
- Worker container:
  - `platform-ai-workers/Dockerfile`
- Repo entrypoints and env contract updates:
  - `platform-ai-workers/Makefile`
  - `platform-ai-workers/.env.example`
  - `platform-ai-workers/README.md`

## Runtime decisions implemented

- One Go runtime entrypoint for both local and Cloud Run execution.
- Codex CLI is invoked from Go as a subprocess.
- Task selection is lane-bound through `worker:<id>` labels.
- Eligible work is prioritized in this order:
  1. `ai:rework-requested`
  2. `ai:ready`
- Worker-owned reusable clone under `WORKSPACE_ROOT`.
- Workspace is returned to a clean `main` checkout before each task.
- Agent prompt instructs Codex to:
  - run repo validation commands (`make lint`, then format if needed, then lint again)
  - commit and push branch changes
  - create or update a draft PR with `gh`

## Validation performed

Validated successfully on this workstation:

- `platform-ai-workers`
  - `make lint`
  - `make test`
  - `go build ./cmd/worker`
  - `docker build -t platform-ai-workers:p1-t11 .`
- Codex CLI availability:
  - `codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "Reply with OK only."`
- GitHub auth availability:
  - `gh auth status`

## Synthetic end-to-end proof

Controlled synthetic task executed against `backend-api`:

- issue: `https://github.com/mpa-forge/backend-api/issues/14`
- resulting draft PR: `https://github.com/mpa-forge/backend-api/pull/15`

Observed result:

- issue `#14` was processed by worker lane `worker:backend-api-01`
- issue labels moved to `ai:ready-for-review`
- draft PR `#15` was created on branch `ai/backend-api-01/issue-14`
- PR changed one file:
  - `backend-api/docs/ai-worker-smoke.md`

## Known limits carried forward

- The baseline intentionally leaves single-lane execution guards, resume behavior, and event-id idempotency to `P1-T12`.
- Full local/cloud parity validation, including explicit Cloud Run execution and rework-loop proof, remains in `P1-T13`.
- The current prompt delegates commit/push/PR operations to Codex via `gh`; a later optimization may move some of that work back into Go runtime logic to reduce model token usage.
