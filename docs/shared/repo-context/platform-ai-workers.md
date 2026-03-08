# Repo Context: platform-ai-workers

Load this file when working in `platform-ai-workers`.

## Repo Role

- Own the AI task-to-code automation runtime.
- The Go worker is the control plane; the coding agent runs as a subprocess CLI.
- Local and cloud runs must use the same codepath with environment-specific behavior limited to config and adapters.

## Load By Default

- `../platform-blueprint-specs/docs/shared/agent-common-operating-rules.md`
- `../platform-blueprint-specs/docs/shared/agent-platform-workspace-map.md`
- `../platform-blueprint-specs/docs/automation/ai-task-to-code-architecture.md`
- `../platform-blueprint-specs/docs/automation/ai-task-automation-workflow.md`
- `../platform-blueprint-specs/ops/ai-worker-local-cloud-parity.md`
- `../platform-blueprint-specs/docs/security/ai-worker-credentials.md`

## Relevant Shared Constraints

- Worker state machine is label-driven: `ai:ready`, `ai:in-progress`, `ai:ready-for-review`, `ai:rework-requested`, `ai:failed`.
- One active worker is allowed per `worker:<id>` lane.
- Branch + draft PR is the mandatory output path.
- Review and rework happen on the same PR branch.

## Typical Validation

- `make lint`
- `make test`
- `make format-check`
