## Context

`P3-T06` requires baseline dashboards to be recreated from source-controlled definitions, but the current repository state stops short of deployable Phase 5 Terraform roots in `platform-infra`. Grafana Cloud provider access for the `rc` baseline already exists through `P3-T01`, telemetry labels and profile expectations are being standardized through `P3-T03` to `P3-T05`, and the planning repo already acts as the source of truth for cross-repo delivery boundaries.

That leaves two different kinds of work mixed together in the current task text:

- authoring portable dashboard definitions and the query contract those dashboards depend on
- provisioning those dashboards into Grafana Cloud in a reproducible, environment-owned way

The change needs to separate those concerns so Phase 3 can make real progress now while still reserving the final authoritative apply path for Phase 5 Terraform roots and CI.

## Goals / Non-Goals

**Goals:**

- Define a concrete `P3-T06` output that is valid before Phase 5: source-controlled Grafana dashboard JSON plus provisioning metadata and bootstrap instructions.
- Preserve one portable dashboard contract across Cloud Run direct OTLP and GKE collector modes by relying on stable labels and queries rather than runtime-specific UI dashboards.
- Define the handoff from temporary bootstrap provisioning to authoritative Terraform-owned Grafana provisioning in `platform-infra`.
- Update Phase 5 planning so the missing ownership pieces are explicit instead of hidden inside a vague "Terraform later" assumption.

**Non-Goals:**

- Implementing alert rules or routing behavior from `P3-T07`.
- Adding backend-worker dashboards before Phase 9.
- Claiming that manual or bootstrap Grafana imports are the final authoritative provisioning model.
- Requiring full GCP infrastructure roots before dashboard definitions can exist in source control.

## Decisions

### Decision: Use raw Grafana dashboard JSON as the canonical pre-Phase-5 artifact

Before Phase 5, `P3-T06` will treat source-controlled Grafana dashboard JSON as the canonical dashboard definition format. This keeps the artifacts portable, reviewable, and reusable by a later Terraform module without forcing an early dependency on env-root wiring that does not exist yet.

Alternatives considered:

- Make Terraform the only accepted artifact for `P3-T06`. Rejected because the current repo state does not yet provide deployable Terraform roots in `platform-infra`.
- Keep dashboards as UI-only exports with no canonical repo source. Rejected because it breaks the explicit `P3-T06` recreate-from-source requirement.

### Decision: Treat pre-Phase-5 provisioning as a bootstrap path, not authoritative infrastructure ownership

Phase 3 may define a bootstrap provisioning path using Grafana API or documented import mechanics so operators can load or refresh the dashboard JSON in Grafana Cloud before Phase 5. That bootstrap path must be documented and traceable to source files, but it must not be treated as the final drift-control mechanism.

Alternatives considered:

- Do nothing until Phase 5. Rejected because Phase 3 needs reviewable dashboard definitions and an operator-facing way to validate them against live telemetry.
- Pretend a placeholder Terraform folder equals final provisioning. Rejected because it obscures the missing env-root and CI ownership that Phase 5 still has to deliver.

### Decision: Move authoritative provisioning into `platform-infra` Phase 5 using the same JSON assets

Phase 5 will own the Grafana provider configuration, dashboard folder resources, dashboard resources, env-specific wiring, and CI or runbook-backed apply flow in `platform-infra`. The authoritative provisioning path must consume the same source-controlled dashboard definitions prepared in `P3-T06` instead of re-authoring them in the Grafana UI.

Alternatives considered:

- Keep dashboard provisioning permanently in the planning repo. Rejected because environment-owned infrastructure and apply workflows belong in `platform-infra`.
- Recreate dashboards by hand from design notes in Phase 5. Rejected because it invites drift and loses the value of dashboard-as-code.

### Decision: Define dashboard portability in terms of shared labels and query contract

The baseline dashboards will depend on the stable service labels, runtime-mode diagnostics, and DB symptom signals created by `P3-T03` through `P3-T05`. Dashboard portability is achieved by querying on shared labels such as service, environment, runtime mode, and normalized endpoint metadata rather than by cloning separate dashboards for each runtime path.

Alternatives considered:

- Separate dashboard sets for Cloud Run and GKE. Rejected because the platform already wants a shared observability contract and profile parity across both modes.

## Risks / Trade-offs

- [Bootstrap provisioning is mistaken for final IaC ownership] -> Mark the bootstrap path as non-authoritative and add explicit Phase 5 follow-up tasks for provider, env-root, and CI-managed apply.
- [Dashboard JSON is authored against unstable labels] -> Tie the dashboard contract to the shared observability labeling rules from `P3-T03` through `P3-T05` and require those labels to remain query-safe across modes.
- [Phase 5 reimplements dashboards instead of consuming the prepared assets] -> Require Phase 5 tasks to provision the same source-controlled definitions without manual re-authoring.
- [Operators accumulate Grafana UI drift before Terraform ownership lands] -> Document the bootstrap import path and require final Phase 5 apply evidence to prove recreation from source.

## Migration Plan

1. Update the Phase 3 planning task text so `P3-T06` explicitly distinguishes between source-controlled dashboard definitions and later authoritative provisioning.
2. Define the dashboard capability in OpenSpec, including the bootstrap provisioning boundary and the later Terraform handoff.
3. Update Phase 5 planning tasks so `platform-infra` must add Grafana provider wiring, dashboard module support, env-root integration, and recreate-from-source validation.
4. When Phase 5 implementation starts, migrate the dashboard JSON into the chosen `platform-infra` module path or consume it directly from an agreed source location, then prove the dashboards can be recreated in Grafana Cloud by env-root apply.

Rollback strategy:

- If the Phase 3 bootstrap import path proves confusing or unstable, retain the dashboard JSON and contract docs while deferring live import until the Phase 5 Terraform path is ready.
- If the Phase 5 Terraform path introduces drift or provider issues, operators can temporarily fall back to the documented bootstrap import path while keeping the repo definitions unchanged.

## Open Questions

- Whether the final Phase 5 implementation should reference the dashboard JSON from a shared artifact location or copy it into `platform-infra` as repo-local source remains an implementation choice, but the definitions must remain source-controlled and must not be re-authored in Grafana.
