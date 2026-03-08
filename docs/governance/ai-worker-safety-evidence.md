# AI Worker Safety Evidence (`P1-T12`)

Last updated: 2026-03-08

## Scope

This document records the safety and recovery layer added on top of the `P1-T11` worker baseline.

## Merged repository

- `platform-ai-workers`
  - PR: `https://github.com/mpa-forge/platform-ai-workers/pull/14`
  - merged at: `2026-03-08T12:50:54Z`

## Delivered artifacts

- Resume and safety orchestration:
  - `platform-ai-workers/internal/app/app.go`
- Runtime config additions:
  - `platform-ai-workers/internal/config/config.go`
  - `platform-ai-workers/.env.example`
- GitHub issue metadata additions:
  - `platform-ai-workers/internal/model/model.go`
  - `platform-ai-workers/internal/githubcli/client.go`
- Remote lane lock implementation:
  - `platform-ai-workers/internal/workspace/workspace.go`
- Runtime docs and local tool cleanup:
  - `platform-ai-workers/README.md`
  - `platform-ai-workers/Makefile`

## Safety controls implemented

- Single active worker lane enforced per `WORKER_ID` through remote branch lock:
  - `ai-lock/<worker-id>`
- Existing `ai:in-progress` issue is resumed before any new `ai:rework-requested` or `ai:ready` selection.
- Event-triggered runs are deduplicated using machine-readable issue comments keyed by `EVENT_ID`.
- Lock branches are considered stale after `LOCK_STALE_AFTER` and can be reclaimed.
- Local/cloud lifecycle remains shared:
  - cloud exits with `worker_already_active`
  - local sleeps and polls again

## Validation performed

Validated successfully on this workstation:

- `platform-ai-workers`
  - `make test`
  - `make lint`

Live GitHub validation used:

- synthetic issue: `https://github.com/mpa-forge/backend-api/issues/14`
- existing draft PR: `https://github.com/mpa-forge/backend-api/pull/15`

### Resume behavior

Issue `#14` was manually moved to `ai:in-progress` and the worker was run again with:

- `TARGET_ISSUE=14`
- `EVENT_ID=resume-1`

Observed evidence:

- issue `#14` received start marker comment:
  - `automation-marker status=started run-id=... automation-event-id:resume-1`
- draft PR `#15` received an additional commit during that resumed run

The long-running Codex step exceeded the shell timeout on this workstation, so final post-run label cleanup was handled manually after evidence capture. The resume path itself was exercised and produced a real branch/PR update.

### Lane guard behavior

While the remote lock branch still existed, a second cloud-mode worker invocation for the same lane returned:

- `worker finished with result=worker_already_active`

This confirmed that the same `WORKER_ID` could not enter a concurrent run while the first lane lease was active.

### `EVENT_ID` dedupe behavior

After restoring issue `#14` to `ai:rework-requested`, the worker was invoked again with the same:

- `EVENT_ID=resume-1`

Observed result:

- `worker finished with result=duplicate_event`

No second rework execution was started for the same event marker.

## Final sandbox state

After validation cleanup:

- issue `backend-api#14` returned to `ai:ready-for-review`
- draft PR `backend-api#15` remained open
- remote lane lock branch was deleted

## Known limits carried forward

- The lock implementation uses a branch-based lease in the target repository. It is good enough for the current phase but still operationally lighter-weight than a dedicated remote lease store.
- The resumed run that updated PR `#15` exceeded the command timeout, which means the happy-path end-to-end rework completion still belongs in `P1-T13`.
- `P1-T13` still needs the explicit human-observed rework loop and equivalent Cloud Run execution proof.
