# Grafana Dashboard Bootstrap Runbook

## Purpose

Define the temporary Phase 3 procedure for loading or refreshing the baseline
Grafana dashboards from source-controlled dashboard JSON before `platform-infra`
Phase 5 Terraform roots can own the authoritative provisioning flow.

This runbook exists to make `P3-T06` operational now without pretending that
bootstrap imports are the final drift-control mechanism.

## Current Boundary

- Phase 3 source of truth:
  - source-controlled Grafana dashboard JSON definitions
  - query and labeling contract tied to `P3-T03` through `P3-T05`
  - bootstrap import or refresh procedure documented here
- Not yet owned in Phase 3:
  - Grafana provider wiring in `platform-infra`
  - env-root Terraform resources for folders and dashboards
  - CI-backed authoritative apply and drift recovery

Authoritative Grafana provisioning remains a Phase 5 responsibility under
`P5-T09A`, `P5-T10`, and `P5-T11`.

## Dashboard Scope

`P3-T06` covers only the baseline dashboard set:

- API golden signals
- edge or runtime-path status
- DB connectivity symptoms

Deferred:

- backend-worker dashboards, which remain part of Phase 9
- alert-rule provisioning, which begins in `P3-T07`

Related alert bootstrap routing guidance now lives in
`docs/operations/grafana-alert-routing-bootstrap-runbook.md`.

## Source Artifact Contract

Canonical Phase 3 artifact format:

- raw Grafana dashboard JSON stored in source control

Current source asset set:

- `../platform-infra/docs/grafana-dashboards/manifest.json`
- `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`
- `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`
- `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json`

Required metadata per dashboard set:

- dashboard file path
- dashboard title
- intended Grafana folder
- environment scope (`rc`, later `prod`)
- notes about required labels or query assumptions

The dashboard definitions must query against the shared observability contract
instead of runtime-specific one-off labels. At minimum, the dashboards should
assume stable use of:

- `service.name`
- `deployment.environment`
- runtime-mode diagnostics emitted by the shared observability runtime
- normalized endpoint or route labels for request-level metrics

## Required Grafana Inputs

Use the Grafana baseline recorded in
`implementation/governance/provider-account-inventory.md`:

- stack URL: `https://miquelpizaairas.grafana.net`
- stack name: `miquelpizaairas`
- instance ID: `1546554`
- phase baseline scope: `rc`

Required operator access:

- Grafana Cloud stack access for the baseline org or stack
- read access to the dashboard source files in git
- a scoped Grafana API token or equivalent import-capable operator access

Token handling rule:

- do not store raw Grafana tokens in git, dashboard JSON, or planning docs

## Folder and Naming Conventions

Until Phase 5 env roots manage folders directly, bootstrap imports should use a
stable folder and title convention so the later Terraform path can adopt the
same layout with minimal churn.

Recommended folder naming:

- `Platform / RC`
- later `Platform / PROD`

Recommended dashboard titles:

- `API Golden Signals`
- `Runtime Path Status`
- `DB Connectivity Symptoms`

If temporary UI-created folder IDs are needed during bootstrap import, record
the folder name in evidence rather than treating the numeric ID as a durable
contract.

## Bootstrap Import Procedure

1. Confirm the dashboard JSON files are the intended source-controlled versions.
   Use the files listed in `../platform-infra/docs/grafana-dashboards/manifest.json`.
2. Confirm the target environment is the current `rc` Grafana stack unless a
   later environment rollout explicitly says otherwise.
3. Confirm the dashboards point at the expected labels and query contract from
   `P3-T03` through `P3-T05`.
4. Create or reuse the target folder using the naming convention in this
   runbook.
5. Import or refresh each dashboard from the source-controlled JSON.
6. Validate that the imported dashboards render against current Grafana Cloud
   data sources without manual UI-only query rewrites that are not reflected
   back into source control.
7. Record evidence showing:
   - source file paths used
   - target stack and folder name
   - import or refresh date
   - any temporary caveats that still depend on Phase 5

The expected initial file paths for evidence are:

- `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`
- `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`
- `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json`

## Refresh Rules

When dashboard JSON changes in git before Phase 5:

- re-import or refresh from the updated source file
- do not hand-edit the Grafana UI and leave the JSON stale
- if an emergency UI edit is unavoidable, backport the change to source control
  immediately and note it in evidence

## Evidence Expectations

Phase 3 evidence should capture:

- which dashboard JSON definitions were used
- which Grafana folder or stack received the import
- confirmation that the bootstrap path was used intentionally
- what still remains for the Phase 5 authoritative provisioning path

## Phase 5 Handoff

This runbook is temporary. Phase 5 must replace the bootstrap-only mechanism
with authoritative `platform-infra` provisioning that:

- configures the Grafana provider
- provisions folders and dashboards from source-controlled definitions
- wires the resources through env roots
- validates recreate-from-source behavior after clean-state apply, drift, or
  deletion

Until that happens, this runbook supports dashboard validation but does not by
itself satisfy the final "recreate from source through IaC" outcome.
