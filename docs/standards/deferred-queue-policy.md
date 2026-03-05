# Deferred Queue Policy

## Purpose
Define objective criteria for when queue/broker adoption must be re-evaluated, while keeping the initial platform baseline queue-free.

## Baseline Decision
- Queue/broker technology remains deferred during baseline implementation.
- Current baseline execution model:
  - synchronous request path in API
  - bounded background processing via worker/Cloud Run Jobs

## Re-Evaluation Triggers
Queue adoption must be re-evaluated when any trigger criteria are met.

### Trigger Criteria (objective)
1. Latency pressure from synchronous work:
   - p95 API latency for affected endpoints exceeds SLO target for 2 consecutive weeks, and root cause is async-worthy background work in request path.
2. Retry/delivery complexity exceeds simple worker semantics:
   - repeated need for durable retries, dead-letter handling, or guaranteed delivery across service boundaries.
3. Async workflow growth:
   - 3+ distinct cross-service asynchronous workflows are active or planned in the next release.
4. Backlog/throughput pressure:
   - background work queue depth grows continuously for 7 days, or processing lag breaches agreed operating window.
5. Burst buffering requirement:
   - traffic/event spikes cause reliability degradation that requires decoupled buffering.

## Decision Threshold
- Standard trigger: start queue ADR when **any 2 trigger criteria** are true for **2 consecutive weeks**.
- Emergency fast-track: start queue ADR immediately if user-facing reliability is materially impacted.

## Non-Triggers
These alone do not justify queue adoption:
- occasional long-running maintenance tasks
- low-volume periodic jobs
- isolated one-off retries that current worker model can handle safely

## Review Cadence
- Formal review points:
  - after baseline end-to-end implementation is complete
  - after first production-like traffic observation window
  - whenever trigger threshold is reached

## Ownership and Approval
- Decision owner: human maintainer.
- Required artifact before adoption:
  - ADR documenting options, delivery semantics, operational cost, migration plan, and rollback approach.

## Output of Re-Evaluation
If queue adoption is approved:
- select technology/provider
- define delivery semantics (at-most-once/at-least-once/exactly-once target)
- define retry/DLQ/idempotency standards
- add implementation tasks in the relevant phase/task packs
