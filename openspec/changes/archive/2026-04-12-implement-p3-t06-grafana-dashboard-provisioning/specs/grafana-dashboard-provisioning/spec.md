## ADDED Requirements

### Requirement: P3-T06 SHALL define baseline dashboards as source-controlled Grafana assets before Phase 5
The platform SHALL implement the baseline dashboard scope of `P3-T06` through source-controlled Grafana dashboard definitions that cover API golden signals, runtime-path status, and DB connectivity symptoms. These definitions SHALL be reviewable outside the Grafana UI and SHALL use the shared observability labels and query contract produced by `P3-T03` through `P3-T05`. Backend-worker dashboard coverage SHALL remain deferred to Phase 9.

#### Scenario: Reviewers inspect baseline dashboard coverage from source
- **WHEN** maintainers review `P3-T06` before Phase 5 Terraform roots exist
- **THEN** they can identify source-controlled definitions for API golden signals, runtime-path status, and DB connectivity symptoms without relying on UI-only Grafana state

#### Scenario: Dashboard queries remain portable across runtime modes
- **WHEN** the API runtime path changes between Cloud Run direct OTLP and GKE collector gateway
- **THEN** the baseline dashboards continue to query against the shared labels and signal contract instead of requiring separate UI-authored dashboard sets per runtime path

### Requirement: Pre-Phase-5 dashboard provisioning SHALL provide a documented bootstrap path without claiming final IaC ownership
Before `platform-infra` Phase 5 env roots can own Grafana provisioning, the platform SHALL document the bootstrap provisioning inputs and procedure needed to load or refresh the source-controlled dashboard definitions in Grafana Cloud. This bootstrap path SHALL identify the required stack or folder naming, token scope, environment labeling, and source file mapping, and SHALL explicitly be treated as a temporary provisioning path rather than the final authoritative drift-control mechanism.

#### Scenario: Operator can bootstrap dashboards before Terraform ownership exists
- **WHEN** an operator needs to validate the source-controlled dashboards against the live `rc` Grafana Cloud stack before Phase 5 is implemented
- **THEN** the operator can follow the documented bootstrap path to import or refresh the dashboards using the defined provisioning inputs and source files

#### Scenario: Bootstrap provisioning boundary is explicit
- **WHEN** maintainers assess whether `P3-T06` is fully complete before Phase 5
- **THEN** the documentation makes clear that bootstrap imports do not replace the later Terraform-owned Grafana apply path

### Requirement: Phase 5 SHALL adopt authoritative Grafana dashboard provisioning from the prepared source definitions
`platform-infra` SHALL implement the final provisioning path for `P3-T06` during Phase 5 by adding Grafana provider configuration, dashboard folder and dashboard resources, env-root wiring, and recreate-from-source validation that provision the prepared dashboard definitions into Grafana Cloud without manual UI re-authoring.

#### Scenario: Environment apply recreates dashboards from source
- **WHEN** an environment owner runs the authoritative Phase 5 Grafana provisioning flow for `rc` or `prod`
- **THEN** Grafana folders and baseline dashboards are created or updated from the source-controlled definitions through the env-owned provisioning path

#### Scenario: Drift recovery does not require manual dashboard rebuilds
- **WHEN** baseline dashboards are deleted, drifted, or need to be recreated during environment recovery
- **THEN** the Phase 5 provisioning path can restore the expected dashboards from source-controlled definitions without rebuilding them manually in the Grafana UI
