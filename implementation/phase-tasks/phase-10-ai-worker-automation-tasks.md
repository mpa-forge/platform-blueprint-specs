# Phase 10 Tasks: AI Worker Automation

## Goal
Deliver the deferred AI-worker implementation track after the core platform baseline is proven, keeping automation work isolated from the critical path.

## Tasks

### P10-T01: Bootstrap `platform-ai-workers` repository baseline
Owner: Agent
Type: Coding
Dependencies: Phase 0 AI automation decisions, `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`, `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`
Source: Deferred from `P1-T11`
Action: Scaffold worker job codebase and container with configurable env vars (`WORKER_RUNTIME_MODE`, `WORKER_ID`, `TARGET_REPO`, `MAX_PENDING_REVIEW`, `POLL_INTERVAL`, credential secret refs), support for trigger context (`TRIGGER_SOURCE`, optional `TARGET_ISSUE`/`TARGET_PR`/`EVENT_ID`), shared GitHub poll-loop task selection logic (ready + rework candidates), task state transitions (`ai:ready` -> `ai:in-progress` -> `ai:ready-for-review`), and PR creation/update path aligned to `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`. Implement the worker runtime as a Go application that invokes the coding agent as a subprocess CLI against the checked-out workspace. Implement one runtime entrypoint used by both local and Cloud Run executions, with environment-specific behavior only through lifecycle/config/adapters as defined in `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`.
Output: Runnable automation worker baseline in dedicated repo.
Done when: Worker can process one synthetic issue and produce a PR in a target sandbox repo, the agent is invoked through the documented subprocess CLI contract, and the same image/entrypoint can be invoked locally and in Cloud Run mode.

### P10-T02: Add worker lane safety and resume behavior
Owner: Agent
Type: Coding
Dependencies: P10-T01
Source: Deferred from `P1-T12`
Action: Implement single-lane processing guard per worker id, deterministic claim-before-work behavior, retry/resume handling for `ai:in-progress` tasks, idempotent rework handling keyed by review/comment event id, and pending-review cap control with mode-specific lifecycle (`local`: wait and continue polling; `cloud`: exit and wait for next wake-up).
Output: Safe worker execution loop with deterministic state transitions.
Done when: Repeated runs do not duplicate claims and can resume interrupted tasks for the same worker lane.

### P10-T03: Run AI worker dry-run validation
Owner: Human + Agent
Type: Validation
Dependencies: P10-T01, P10-T02, Phase 1 `P1-T12B`
Source: Deferred from `P1-T13`
Action: Execute controlled dry-run against a sandbox repository and verify end-to-end path (issue selection, branch changes, PR creation, state updates, reviewer handoff, and comment/review-triggered rework updating the same PR) according to `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`; include local/cloud parity checks per `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md` by running equivalent inputs locally and via Cloud Run execution, including idle and outstanding-review-cap behavior.
Output: `implementation/governance/ai-worker-dry-run.md` with findings and fixes.
Done when: One end-to-end task-to-PR flow succeeds under manual observation and the worker is proven to create a PR from a real task in both local and managed runtime paths.

### P10-T04: Enforce AI-generated PR governance controls
Owner: Human + Agent
Type: CI governance
Dependencies: Phase 4 `P4-T09`, P10-T01
Source: Deferred from `P4-T11`
Action: Configure required checks and review policy for AI-generated PRs (normal PRs, mandatory human reviewer, CODEOWNERS enforcement, required metadata labels such as `ai-generated` and `ai-run-id`, and explicit rework trigger controls for `changes requested` or `/ai rework` command usage) aligned to `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`.
Output: Enforced governance policy for automation-created PRs.
Done when: AI-created PRs cannot merge without the same required review/check gates as human-authored PRs.

### P10-T05: Implement event-driven AI worker trigger workflows
Owner: Agent
Type: CI automation
Dependencies: Phase 4 `P4-T06`, P10-T04
Source: Deferred from `P4-T13`
Action: Add GitHub Actions workflows that trigger on task-ready and review-feedback events (issue label `ai:ready`, PR review `changes_requested`, maintainer `/ai rework` comment command), authenticate to GCP via WIF, and execute the mapped Cloud Run Job on-demand as a wake-up signal for the target worker lane following `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`.
Output: Event-driven trigger workflows and runbook referencing `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`.
Done when: A review comment can trigger one deterministic rework run without waiting for the scheduler cadence.

### P10-T06: Implement Cloud Run Jobs + Scheduler module for AI workers
Owner: Agent
Type: IaC coding
Dependencies: Phase 5 `P5-T05`, Phase 5 `P5-T07`
Source: Deferred from `P5-T08`
Action: Provision Cloud Run Job definitions (and optional low-frequency Scheduler backstop), service accounts/IAM, and Secret Manager bindings for `platform-ai-workers` execution. Support multiple worker-job deployments, each targeting a repository with environment-specific configuration (`WORKER_RUNTIME_MODE=cloud`, `WORKER_ID`, `TARGET_REPO`, `MAX_PENDING_REVIEW`, `POLL_INTERVAL`, credential refs), and grant least-privilege on-demand execution permissions for GitHub Actions event-trigger wake-up workflows as defined in `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md`. Ensure Cloud Run Job command/args invoke the same runtime entrypoint used for local execution, per `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md`.
Output: AI worker runtime infrastructure module.
Done when: At least one worker-job deployment can be created per environment and triggered on-demand with least privilege (with optional scheduler backstop enabled when configured).

### P10-T07: Define MCP-based diagnostic tool access model
Owner: Human + Agent
Type: Architecture + security
Dependencies: Phase 3 observability baseline, Phase 8 `P8-T06`
Source: Deferred from `P8-T11`
Action: Define MCP integration boundaries for telemetry access (metrics/logs/traces), allowed tools/endpoints, credential isolation, and data redaction policy for AI diagnostics.
Output: `docs/automation/ai-ops-mcp-model.md`.
Done when: MCP/tool permissions and safe-data handling rules are approved for alert-driven diagnostics.

### P10-T08: Implement alert-driven AI diagnostic worker pipeline
Owner: Agent
Type: Automation coding
Dependencies: P10-T07, Phase 3 alert routing, P10-T01
Source: Deferred from `P8-T12`
Action: Add worker pipeline triggered by Grafana Cloud / Prometheus-style alert events, retrieve telemetry context (metrics/logs/traces), run diagnostic analysis, and emit structured remediation proposals with evidence links.
Output: Alert -> diagnostics worker implementation and deployment manifests/config.
Done when: Synthetic alerts trigger deterministic diagnostics with linked telemetry evidence.

### P10-T09: Automate remediation task generation from diagnostics
Owner: Agent
Type: Automation integration
Dependencies: P10-T08, Phase 0 task workflow baseline
Source: Deferred from `P8-T13`
Action: Convert validated diagnostic outputs into GitHub Issues/Project tasks with standard labels/priority suggestions, links to evidence, and optional worker-lane assignment for follow-up automation.
Output: Diagnostics -> task generation integration.
Done when: At least one synthetic alert produces a correctly formatted remediation issue in the project board.

## Artifacts Checklist
- `platform-ai-workers` bootstrap code and container
- `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md` conformance notes
- `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md` conformance notes
- AI worker dry-run report
- AI-generated PR governance policy evidence
- event-driven AI worker trigger workflow definitions
- Cloud Run Job/Scheduler module for AI workers
- `../platform-ai-workers/docs/automation/ai-comment-trigger-cloud-run-jobs.md` IAM mapping reference
- `../platform-ai-workers/docs/automation/ai-worker-local-cloud-parity.md` runtime parity mapping reference
- MCP/tool access model for AI diagnostics
- `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md` implementation reference
- alert-driven diagnostic worker implementation evidence
- diagnostics-to-task generation validation evidence
