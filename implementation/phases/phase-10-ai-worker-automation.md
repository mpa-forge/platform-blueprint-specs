# Phase 10: AI Worker Automation

Detailed tasks: `implementation/phase-tasks/phase-10-ai-worker-automation-tasks.md`

- Implement the deferred `platform-ai-workers` execution baseline after the core platform path is stable.
- Bootstrap the task-to-code worker runtime, lane-safety controls, and dry-run validation flow in the dedicated worker repo.
- Add governance controls for AI-generated PRs and event-driven wake-up workflows for rework execution.
- Provision Cloud Run Jobs, optional Scheduler backstop, IAM, and secret delivery for AI worker lanes.
- Add the later alert-driven AI diagnostics extension:
  - MCP-scoped telemetry access model
  - alert-triggered diagnostic runs
  - remediation task generation with evidence links

Exit criteria:
- AI task-to-code automation can process a controlled task end to end through the guarded PR flow.
- The managed Cloud Run Job path for AI workers is provisionable and triggerable with least privilege.
- Alert-driven diagnostics can create bounded remediation tasks with linked evidence.

## Open Questions / Choices To Clarify Later
- None currently.
