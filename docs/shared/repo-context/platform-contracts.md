# Repo Context: platform-contracts

Load this file when working in `platform-contracts`.

## Repo Role

- Own protobuf contracts as the single source of truth for backend and frontend clients.
- Generate Go and TypeScript artifacts.
- Publish the generated TypeScript client package to GitHub Packages.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/implementation-phases/phase-2-contracts-service-skeletons-and-data-baseline.md`
- `../platform-blueprint-specs/implementation-phase-tasks/phase-2-contracts-service-skeletons-and-data-baseline-tasks.md`

## Relevant Shared Constraints

- Buf usage is CLI-only in local and CI for baseline; no paid BSR dependency.
- Generated TypeScript client is intended for GitHub Packages publishing.
- Generated artifacts are committed to git as part of normal development flow.

## Consult Conditionally

- `../platform-blueprint-specs/platform-specification.md` only when the task needs broader stack or release-policy context.

## Typical Validation

- repo-local generation command once introduced
- `make lint`
- `make format-check`
