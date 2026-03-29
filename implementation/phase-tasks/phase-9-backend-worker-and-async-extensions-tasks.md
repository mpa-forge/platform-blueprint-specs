# Phase 9 Tasks: Backend Worker and Async Extensions

## Goal
Add the deferred `backend-worker` service and its supporting runtime,
observability, deployment, and hardening work after the frontend + backend API
path is already working end to end.

## Tasks

### P9-T01: Build worker skeleton with pluggable async adapter
Owner: Agent  
Type: Coding  
Dependencies: Phase 2 frontend/API baseline proven end to end  
Action: Add worker startup loop, graceful shutdown, periodic no-op job, health endpoint, structured logs, and startup validation of required environment variables defined in `P1-T05`, with fail-fast errors for missing or malformed config. Follow `common/standards/code-documentation.md` for package docs, exported symbol comments, and non-obvious runtime behavior.  
Output: Runnable worker service baseline.  
Done when: Worker executes periodic task and exposes health with valid config, and exits early with clear messages when required env is missing or invalid.

### P9-T02: Integrate backend-worker with shared backend observability library
Owner: Agent  
Type: Coding  
Dependencies: P9-T01, P2-T13  
Action: Wire the shared observability library into `backend-worker`, including runtime mode config, common resource labels, and `OBS_TELEMETRY_PROFILE` support already proven by the API path.  
Output: Worker observability integration baseline.  
Done when: Worker startup uses the shared observability package and can run in baseline mode with no bespoke telemetry contract.

### P9-T03: Instrument backend-worker with OpenTelemetry
Owner: Agent  
Type: Coding  
Dependencies: P9-T02, Phase 3 observability baseline  
Action: Emit traces/metrics/logs for worker loop activity, retries, and failures; add worker dashboard requirements and runtime-mode compatibility.  
Output: Worker telemetry instrumentation and dashboard notes.  
Done when: Worker loop activity is visible in traces and dashboard metrics.

### P9-T04: Add backend-worker image build and deployment artifacts
Owner: Agent  
Type: CI/CD + deployment coding  
Dependencies: P9-T01, Phase 4 CI baseline, Phase 6 deployment baseline  
Action: Add worker image build/tagging in CI, worker deployment artifact(s) for the selected runtime path, worker secret/config wiring, and worker-specific rollout controls.  
Output: Worker CI image build path and deployment artifact baseline.  
Done when: A worker image can be built reproducibly and deployed through the selected runtime path with no manual drift fixes.

### P9-T05: Add worker smoke, scaling, and hardening checks
Owner: Human + Agent  
Type: Validation + hardening  
Dependencies: P9-T03, P9-T04, Phase 7 release baseline, Phase 8 hardening baseline  
Action: Define worker-specific smoke checks, worker heartbeat/no-op validation, scaling expectations, and worker SLO/SLI additions; run one worker-focused load/reliability pass and document the outcome.  
Output: Worker runbook additions, smoke checks, and reliability evidence.  
Done when: Worker-specific operational expectations are documented and validated against the deployed runtime.

## Artifacts Checklist
- worker runtime skeleton
- worker observability integration evidence
- worker OTel instrumentation evidence
- worker image build workflow/config
- worker deployment artifact baseline
- worker smoke and reliability validation evidence
