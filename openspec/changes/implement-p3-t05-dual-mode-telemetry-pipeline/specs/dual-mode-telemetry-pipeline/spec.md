## ADDED Requirements

### Requirement: Shared backend runtime SHALL provide one dual-mode telemetry contract
The platform SHALL implement `P3-T05` through a shared backend observability runtime that supports `direct_otlp` for Cloud Run and `collector_gateway` for GKE without requiring service instrumentation call sites to diverge by runtime path. The shared runtime SHALL expose one configuration contract for runtime mode, OTLP destination inputs, startup diagnostics, and `OBS_TELEMETRY_PROFILE`.

#### Scenario: Service starts in direct OTLP mode
- **WHEN** a backend service is configured with the Cloud Run baseline runtime mode
- **THEN** the shared runtime initializes telemetry export directly to Grafana Cloud using the shared config contract and emits startup diagnostics that identify the active mode and profile

#### Scenario: Service starts in collector gateway mode
- **WHEN** a backend service is configured with the GKE collector runtime mode
- **THEN** the shared runtime initializes export toward the collector/alloy endpoint using the same service-facing contract and emits startup diagnostics that identify the active mode and profile

### Requirement: Telemetry profiles SHALL preserve equivalent operational behavior across both runtime modes
The platform SHALL support `balanced`, `cost`, and `debug` as the only valid `OBS_TELEMETRY_PROFILE` values for `P3-T05`. The system SHALL preserve the locked baseline sampling policy of `rc` 25 percent and `prod` 5 percent in `balanced`, SHALL preserve force-sampling for errors, high-latency traces, and explicit debug or incident traffic, and SHALL make profile changes possible without changing instrumentation code.

#### Scenario: Balanced profile applies baseline sampling
- **WHEN** the active profile is `balanced`
- **THEN** both runtime modes apply the same baseline sampling intent and preserve force-sample exceptions for errors, high-latency traces, and explicit debug or incident traffic

#### Scenario: Cost profile reduces ingestion without code changes
- **WHEN** an operator switches the profile from `balanced` to `cost`
- **THEN** telemetry volume is reduced through runtime and or collector controls while critical visibility for errors and health signals remains available and no instrumentation call sites require modification

#### Scenario: Debug profile increases detail temporarily
- **WHEN** an operator enables `debug` for an incident window
- **THEN** the active runtime mode increases telemetry detail according to the shared contract and can later return to `balanced` without code changes

### Requirement: Backend API SHALL adopt and validate the finalized P3-T05 contract
`backend-api` SHALL consume the finalized shared runtime contract for `P3-T05`, use the standardized resource and service labels required by the observability profile spec, and expose enough diagnostics to confirm that the API is operating in the selected runtime mode and telemetry profile.

#### Scenario: API validates direct-mode runtime wiring
- **WHEN** `backend-api` runs with the Cloud Run baseline configuration
- **THEN** traces, metrics, and logs are exported through the shared runtime to Grafana Cloud with the expected labels and startup diagnostics confirm the selected mode and profile

#### Scenario: API preserves service behavior across runtime modes
- **WHEN** the API runtime mode changes from `direct_otlp` to `collector_gateway`
- **THEN** the service continues to use the same instrumentation integration points and only configuration and deployment artifacts change

### Requirement: Infrastructure SHALL provide the collector-path delivery surfaces for P3-T05
`platform-infra` SHALL define the infrastructure-owned artifacts needed for the GKE collector path, including collector or alloy configuration, GSM-backed token delivery surfaces, and deployment-time configuration inputs that allow the shared backend runtime and collector path to operate under the same Grafana Cloud auth contract.

#### Scenario: GKE path receives token ingredients without prebuilt headers
- **WHEN** a GKE deployment is prepared for `collector_gateway`
- **THEN** infrastructure artifacts deliver `GRAFANA_OTLP_INGEST_TOKEN` and related endpoint inputs without storing raw OTLP headers in git-managed configuration

#### Scenario: Collector path applies downstream profile controls
- **WHEN** the runtime mode is `collector_gateway`
- **THEN** the collector or alloy configuration can apply the required downstream sampling, filtering, and export behavior while keeping the service-facing runtime contract unchanged

### Requirement: P3-T05 completion SHALL require evidence for both runtime paths
The platform SHALL treat `P3-T05` as complete only when Cloud Run direct OTLP and GKE collector gateway validations both demonstrate Grafana Cloud ingestion with expected labels and profile-controlled behavior, and the evidence SHALL identify which repo delivered each part of the implementation.

#### Scenario: Cross-repo evidence proves completion
- **WHEN** maintainers review `P3-T05` completion
- **THEN** they can trace runtime behavior, infra artifacts, and validation results back to the shared runtime repo, `backend-api`, and `platform-infra`
