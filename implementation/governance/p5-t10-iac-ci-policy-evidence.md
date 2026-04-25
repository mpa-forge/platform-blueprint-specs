# P5-T10 IaC CI Policy Evidence

## Scope

This evidence file records the Phase 5 CI baseline for Terraform formatting,
validation, static analysis, and policy checks across `platform-infra` and the
shared `org-dot-github` reusable workflow.

## Implemented Checks

The PR pipeline now runs the following baseline jobs:

- formatting checks via `make repo-format-check`
- Terraform lint checks via `make repo-lint`
- Terraform validation via `make terraform-validate`
- repository policy checks via `make repo-policy-check`

## Policy Coverage

The repository policy check verifies:

- every dashboard JSON listed in `docs/grafana-dashboards/manifest.json`
  exists in source control
- the manifest matches the tracked dashboard JSON assets
- both environment roots wire the Grafana dashboard module and outputs
- the shared Grafana dashboard module loads dashboard JSON from the manifest
  and source-controlled file paths
- Terraform workspace usage remains absent from the repository

## Validation

Validated locally with:

- `make repo-format-check`
- `make repo-lint`
- `make terraform-validate`
- `make repo-policy-check`
