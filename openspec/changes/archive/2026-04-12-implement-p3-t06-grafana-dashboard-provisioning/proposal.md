## Why

`P3-T06` currently says "dashboard JSON/Terraform definitions" but does not define the delivery boundary between what can be completed now and what must wait for `platform-infra` Phase 5 Terraform roots. We need one change that makes the pre-Phase-5 Grafana dashboard work explicit without pretending the final IaC-managed provisioning path already exists.

## What Changes

- Define the Phase 3 baseline dashboard capability for API golden signals, runtime-path status, and DB connectivity symptoms as source-controlled Grafana dashboard JSON plus a stable query and labeling contract.
- Define the maximum pre-Phase-5 provisioning scope for `P3-T06`: dashboard definitions, folder and naming conventions, provider token and stack inputs, and a documented bootstrap import path that does not claim authoritative Terraform ownership yet.
- Define the Phase 5 completion path in `platform-infra` so the same dashboard definitions are provisioned through env-specific Terraform roots and can be recreated after drift, deletion, or environment recovery.
- Clarify that backend-worker dashboards remain deferred to Phase 9 and that alert-rule delivery still begins in `P3-T07`.

## Capabilities

### New Capabilities
- `grafana-dashboard-provisioning`: Defines the source-controlled dashboard contract for `P3-T06`, the pre-Phase-5 bootstrap provisioning boundary, and the later Phase 5 Terraform-owned Grafana apply path.

### Modified Capabilities

None.

## Impact

- Planning artifacts in this repository for `P3-T06` and the Phase 3 observability baseline.
- `platform-infra` Phase 5 task planning for Grafana provider, dashboard module, env-root wiring, and recreate-from-source validation.
- Grafana Cloud dashboard bootstrap and later authoritative provisioning workflow.
- The shared observability query and labeling contract consumed by dashboards across Cloud Run direct OTLP and GKE collector modes.
