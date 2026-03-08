# Agent Platform Workspace Map

This file gives agents the minimum shared workspace map needed across repositories.

## Repository Roles

- `frontend-web`: React SPA for the authenticated product frontend.
- `backend-api`: Go API service for browser-facing and contract-defined endpoints.
- `backend-worker`: Go background worker for future async product work.
- `platform-ai-workers`: Go automation runtime that turns GitHub tasks into code changes.
- `platform-contracts`: protobuf contracts, generated clients, and package publishing metadata.
- `platform-infra`: Terraform and centralized local development stack orchestration.
- `platform-blueprint-specs`: planning, platform decisions, phases, tasks, and shared agent context.

## When To Consult Planning Docs

- Consult shared planning docs when the task depends on platform direction, phase gates, or cross-repo conventions.
- Do not load broad planning files by default if a repo-specific shared context file is enough.
- Prefer the smallest targeted planning file that answers the current task.

## Shared Decisions To Assume By Default

- Cloud provider baseline: GCP.
- API contract model: protobuf + Connect-compatible endpoints.
- Go API HTTP stack baseline: `chi` with `connect-go` handlers.
- Local delivery model: hybrid local stack orchestrated from `platform-infra`.
- GitHub flow: branch + draft PR + human review.
- Clean worktree is required at the end of autonomous work.
