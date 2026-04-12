## Context

`P3-T05` sits at the boundary between a shared runtime package and two deployment paths. The project already has a Phase 2 backend observability package in `platform-observability`, API startup integration in `backend-api`, and placeholder secret-delivery notes for `platform-infra`, but the remaining Phase 3 work is still split across planning artifacts instead of a single cross-repo delivery contract.

The change must preserve the locked observability model in `ops/observability-telemetry-budget-profile.md`:

- Cloud Run uses `direct_otlp` and sends telemetry straight to Grafana Cloud.
- GKE uses `collector_gateway` and sends telemetry to collector/alloy before upstream export.
- Both modes use the same `OBS_TELEMETRY_PROFILE` values and the same GSM-backed Grafana token ingredient model.

The primary stakeholders are the maintainers of `platform-observability`, `backend-api`, and `platform-infra`, because each repo owns a different part of the `P3-T05` done-when statement.

## Goals / Non-Goals

**Goals:**

- Define one delivery design for implementing `P3-T05` across the shared backend package, `backend-api`, and `platform-infra`.
- Keep service instrumentation call sites stable while moving mode-specific export and profile behavior into the correct ownership layer.
- Ensure `balanced`, `cost`, and `debug` produce equivalent operational behavior across Cloud Run direct export and GKE collector export.
- Make validation and evidence expectations explicit so the task can be completed repo by repo without losing parity.

**Non-Goals:**

- Expanding worker runtime adoption; `backend-worker` remains deferred to Phase 9.
- Adding new observability providers such as Sentry or incident.io.
- Replacing the locked Grafana Cloud ingestion contract or changing the Phase 3 sampling baseline.
- Delivering full Terraform roots for all deployment targets inside this planning change.

## Decisions

### Decision: Keep one shared runtime contract in `platform-observability`

The shared package remains the source of truth for runtime mode selection, startup diagnostics, OTLP auth-header composition, and source-side profile behavior that applies before export. `backend-api` consumes this contract rather than implementing its own mode-specific telemetry bootstrap.

Alternatives considered:

- Put all mode logic in each service. Rejected because it duplicates runtime behavior and makes profile parity hard to preserve.
- Move all profile behavior to infrastructure. Rejected because direct Cloud Run export has no collector layer, so some controls must remain in the shared runtime.

### Decision: Split `P3-T05` implementation by ownership boundary, not by signal type

Work will be divided by repo responsibility:

- `platform-observability`: shared runtime config, profile mapping hooks, exporter behavior, startup metadata.
- `backend-api`: service adoption, config validation, expected labels and diagnostics, direct-mode verification.
- `platform-infra`: collector/alloy config, GSM-to-runtime delivery surfaces, and GKE-path deployment artifacts.

Alternatives considered:

- Split the work into traces, metrics, and logs subprojects. Rejected because each signal crosses the same repo boundaries and would multiply coordination cost.

### Decision: Define profile parity by behavior, not identical implementation mechanics

`balanced`, `cost`, and `debug` must mean the same operational outcome in both modes even though enforcement points differ. In `direct_otlp`, controls are applied in the shared runtime before export. In `collector_gateway`, source-side cardinality rules stay in the shared runtime, while additional sampling and filtering can be enforced in collector/alloy.

Alternatives considered:

- Require byte-for-byte identical pipelines between Cloud Run and GKE. Rejected because the collector path inherently adds processors that do not exist in direct export mode.

### Decision: Sequence delivery as runtime first, service adoption second, infra validation third

Implementation should proceed in this order:

1. finalize shared runtime/profile behavior in `platform-observability`
2. consume and validate the contract in `backend-api`
3. add collector/alloy and secret-delivery artifacts in `platform-infra`
4. record evidence for both modes against the same validation checklist

This keeps the service and infra repos aligned on one shared contract instead of developing parallel interpretations.

## Risks / Trade-offs

- [Cloud Run and GKE profiles drift over time] -> Keep one normative profile contract in the shared runtime and require evidence that compares the resulting behavior for both modes.
- [Collector config becomes the de facto source of truth] -> Limit collector-specific behavior to downstream processors and preserve source-side cardinality and baseline runtime defaults in `platform-observability`.
- [Infra work blocks service completion because Terraform roots are still partial] -> Allow placeholder or staged infra artifacts where Phase 5/6 deployment roots are still deferred, but require the repo boundary and delivery contract to be explicit now.
- [Ownership confusion leads to duplicate implementation] -> Attach every requirement and task to a target repo so the work can be dispatched cleanly.

## Migration Plan

1. Update `platform-observability` to finalize the dual-mode runtime contract and profile mapping behavior.
2. Update `backend-api` to consume the finalized contract, surface mode/profile diagnostics, and validate direct OTLP ingest.
3. Update `platform-infra` with collector/alloy and secret-delivery artifacts needed for the GKE path.
4. Execute or document mode-specific validation, capture evidence, and mark `P3-T05` complete when both paths satisfy the shared acceptance criteria.

Rollback strategy:

- Service-side regressions can roll back by reverting `backend-api` and `platform-observability` to the previous runtime contract.
- GKE-path regressions can roll back collector/alloy configuration independently in `platform-infra`.
- Profile changes remain config-driven so emergency fallback to `balanced` or prior collector settings does not require instrumentation rewrites.

## Open Questions

- Whether `platform-infra` should carry only placeholder collector artifacts in this phase or a fully runnable GKE-path baseline before Phase 6 remains a sequencing decision for implementation.
