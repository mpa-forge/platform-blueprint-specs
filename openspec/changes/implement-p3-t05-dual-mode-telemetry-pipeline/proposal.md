## Why

`P3-T05` is currently defined in the phase plan, but the repo-by-repo delivery boundary is still implicit. We need a single change that makes the Cloud Run direct OTLP path and the GKE collector path implementable across the shared backend observability package, `backend-api`, and `platform-infra` without leaving the profile contract or deployment ownership ambiguous.

## What Changes

- Define one cross-repo delivery plan for `P3-T05` covering `platform-observability`, `backend-api`, and `platform-infra`.
- Specify the required runtime behavior for the shared backend observability package so `direct_otlp` and `collector_gateway` use one configuration contract and one `OBS_TELEMETRY_PROFILE` control.
- Specify the `backend-api` service requirements for adopting the finalized telemetry pipeline configuration, resource labels, sampling defaults, and startup diagnostics.
- Specify the `platform-infra` requirements for the GKE collector/alloy path, shared secret delivery model, and deploy-time configuration surfaces needed to operate both runtime modes.
- Define validation expectations for Grafana Cloud ingestion, profile parity, and evidence capture across both runtime modes.

## Capabilities

### New Capabilities
- `dual-mode-telemetry-pipeline`: Defines the cross-repo runtime, deployment, and validation requirements for operating Grafana Cloud telemetry through both Cloud Run direct OTLP and GKE collector gateway paths with one shared budget-profile contract.

### Modified Capabilities

None.

## Impact

- Planning artifacts in this repository for the Phase 3 observability baseline.
- `platform-observability` shared backend telemetry runtime and profile mapping behavior.
- `backend-api` runtime configuration, startup observability wiring, and validation evidence.
- `platform-infra` collector/alloy manifests, secret-delivery surfaces, and later Phase 5/6 deployment wiring.
- Grafana Cloud telemetry ingestion behavior, validation procedures, and repo ownership boundaries for `P3-T05`.
