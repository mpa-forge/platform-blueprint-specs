# Repository Ownership Model (P0-T02)

Last updated: 2026-03-03

## Scope
Define repository ownership, accountability, and AI execution boundaries for all currently created repositories.

## Ownership principles

- Every repo has at least one human maintainer accountable for approvals and releases.
- AI agents can propose changes, but cannot self-approve or bypass required review.
- Credential and automation scope must be least-privilege per target repo.
- Missing repos would be recorded as provisional entries; currently all baseline repos exist.

## Ownership matrix

| Repository | Purpose | Human maintainer (primary) | Human backup | AI agent execution scope | Ownership status |
| --- | --- | --- | --- | --- | --- |
| `platform-blueprint-specs` | Specs, ADRs, phase plans, governance docs | `MiquelPiza` | None (single maintainer model) | Allowed for documentation/task updates through PRs; human approval required | Final |
| `frontend-web` | Frontend application | `MiquelPiza` | None (single maintainer model) | Allowed for implementation/refactor tasks through PRs; human approval required | Final |
| `backend-api` | API service | `MiquelPiza` | None (single maintainer model) | Allowed for implementation/refactor tasks through PRs; human approval required | Final |
| `backend-worker` | Background worker services | `MiquelPiza` | None (single maintainer model) | Allowed for implementation/refactor tasks through PRs; human approval required | Final |
| `platform-ai-workers` | AI automation worker runtime and orchestration logic | `MiquelPiza` | None (single maintainer model) | Allowed for worker development tasks through PRs; human approval required | Final |
| `platform-contracts` | Protobuf contracts and generated clients | `MiquelPiza` | None (single maintainer model) | Allowed for contract/client generation and schema updates through PRs; human approval required | Final |
| `platform-infra` | Terraform and infrastructure deployment modules | `MiquelPiza` | None (single maintainer model) | Allowed for IaC updates through PRs; human approval required | Final |

## Approval and control boundaries

- Merge authority: human maintainer only.
- Protected branch and required-check enforcement: implemented in Phase 1 (`P1-T01`).
- Emergency override: same human maintainer, with post-change audit note required.

## Review cadence

- Revalidate ownership entries on each Phase gate.
- Update this file immediately when repos are added or ownership changes.

