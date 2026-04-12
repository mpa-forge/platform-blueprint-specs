## 1. Shared Runtime Contract

- [x] 1.1 Update `platform-observability` to finalize the dual-mode runtime contract for `direct_otlp` and `collector_gateway`.
- [x] 1.2 Implement the locked `OBS_TELEMETRY_PROFILE` behavior in `platform-observability` for `balanced`, `cost`, and `debug`, including baseline sampling and force-sample rules.
- [x] 1.3 Ensure the shared runtime composes Grafana OTLP auth from token ingredients, exposes startup diagnostics for active mode and profile, and keeps service instrumentation call sites unchanged.

## 2. Backend API Adoption

- [x] 2.1 Update `backend-api` to consume the finalized shared runtime contract and validate allowed observability mode and profile inputs.
- [x] 2.2 Verify `backend-api` emits traces, metrics, and logs with the expected resource labels and startup diagnostics in the Cloud Run direct OTLP path.
- [x] 2.3 Update `backend-api` docs and runtime evidence to reflect the final `P3-T05` contract and direct-mode validation results.

## 3. Infrastructure Collector Path

- [x] 3.1 Add or update `platform-infra` collector or alloy artifacts for the GKE `collector_gateway` path, including receivers, processors, and exporters required by `P3-T05`.
- [x] 3.2 Define the `platform-infra` secret-delivery and configuration surfaces needed to provide Grafana token ingredients without storing prebuilt OTLP headers in git-managed config.
- [x] 3.3 Document the rollout boundary between current placeholder infra artifacts and the later Phase 5 or Phase 6 deployable GKE implementation.

## 4. Cross-Repo Validation

- [x] 4.1 Define a shared validation checklist that proves profile parity and expected Grafana Cloud ingestion behavior across direct OTLP and collector gateway modes.
- [x] 4.2 Capture repo-specific evidence for `platform-observability`, `backend-api`, and `platform-infra` showing how each repo satisfies its part of `P3-T05`.
- [x] 4.3 Update the planning evidence in this repository so `P3-T05` can be marked complete only when both runtime paths satisfy the shared acceptance criteria.
