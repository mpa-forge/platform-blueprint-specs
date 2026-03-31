# Common Agent Context

This file is shared by all working repositories in the platform blueprint workspace.

## Repository Roles

- `frontend-web`: React SPA for the authenticated product frontend.
- `backend-api`: Go API service for browser-facing and contract-defined endpoints.
- `backend-worker`: Go background worker for future async product work.
- `platform-ai-workers`: Go automation runtime that turns GitHub tasks into code changes.
- `platform-contracts`: protobuf contracts, generated clients, and package publishing metadata.
- `platform-infra`: Terraform and centralized local development stack orchestration.
- `platform-blueprint-specs`: planning, platform decisions, phases, tasks, and shared agent context.

## Scope

- Use the checked-out repository as the source of truth for code, commands, and validation.
- Keep changes scoped to the assigned task.
- Prefer repo-local entrypoints over ad hoc commands.
- Before major changes in a managed sibling repository, run `make sync-agent-skills` there so the repo-local common skill copies are current.
- If the task changes shared templates, tool or version pins, repo bootstrap behavior, or any behavior that affects multiple repositories, also load `../platform-blueprint-specs/implementation/governance/shared-change-checklist.md`.

## When To Consult Planning Docs

- Consult shared planning docs when the task depends on platform direction, phase gates, or cross-repo conventions.
- Do not load broad planning files by default if a repo-specific shared context file is enough.
- Prefer the smallest targeted planning file that answers the current task.

## Conditional Standards

- Load `common/standards/access-model.md` when the task touches auth or access scope, GitHub permissions, branch protection, CI deploy identity, runtime service accounts, secret access, incident-response ownership, or break-glass flow.
- Load `common/standards/environment-and-region.md` when the task touches environment topology, `local` vs `rc` vs `prod` behavior, region selection, project or secret separation, public hostnames, or Cloud Run vs GKE runtime-path defaults.
- Load `common/standards/go-lint-baseline.md` when the task touches a Go repo `Makefile`, `.golangci.yml`, lint target behavior, `golangci-lint` version pins, or Go bootstrap template drift.
- Load `common/standards/naming-and-labeling.md` when the task creates or renames repositories, packages, images, Terraform resources, Cloud Run services or jobs, namespaces, tags, or required infra/workload labels.

## Shared Decisions To Assume By Default

- Cloud provider baseline: GCP.
- API contract model: protobuf + Connect-compatible endpoints.
- Go API HTTP stack baseline: `chi` with `connect-go` handlers.
- Local delivery model: hybrid local stack orchestrated from `platform-infra`.
- GitHub flow: branch + normal PR + human review unless the task explicitly requires draft mode.
- Clean worktree is required at the end of autonomous work.

## Git and PR Flow

- Never create commits on local `main`.
- Before the first commit in this repository, create or switch to a short-lived working branch.
- Merge changes into `main` only through a PR so protected-branch rules are preserved locally and on GitHub.

## Instruction Priority

- Repo-local instructions override this file.
- Task-specific instructions override generic repo instructions.
- If local repo docs conflict with shared planning docs, prefer the repo-local docs for code execution and the planning docs for platform direction.
