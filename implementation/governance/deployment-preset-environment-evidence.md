# Deployment Preset Environment Evidence

## Scope

This evidence file records the `platform-infra` change that introduced
preset-driven Terraform environment assembly and the first shipped preset
defaults for `rc` and `prod`.

Repository evidence:

- `platform-infra` PR #31: `Add deployment presets for Terraform environments`

## Delivered Topology Model

`platform-infra` now keeps `rc` and `prod` as the only Terraform roots and
selects runtime topology with deployment presets.

The shipped preset catalog is:

- `single-vps`
- `cloudrun-cloudsql`
- `cloudrun-cdn-cloudsql`
- `gke-cloudsql`

Current committed defaults are:

- `rc`: `single-vps`
- `prod`: `cloudrun-cloudsql`

This preserves environment separation while avoiding additional long-lived roots
such as `rc-single-vps` or `prod-cloudrun-cdn`.

## Infrastructure Changes

The implementation introduced:

- `modules/stack` as the shared environment assembly layer
- `modules/vps_stack` as the first single-host runtime path
- root inputs `deployment_preset` and `deployment_enabled`
- normalized root outputs:
  - `deployment_contract`
  - `frontend_contract`
  - `backend_contract`
  - `database_contract`
  - `operational_contract`

Existing runtime modules were extended so they remain composable under the new
stack layer:

- `cloudrun_api`: explicit least-privilege secret IAM selection and runtime
  secret access contract outputs
- `gke`: workload identity and ESO mapping outputs for the optional GKE path
- `secrets`: reusable runtime secret catalog outputs shared across runtime paths

## Validation

The following validation passed in `platform-infra`:

- `make terraform-validate`

## Planning Impact

The planning baseline should now assume:

- one Terraform root per environment still holds
- runtime topology is chosen through presets, not extra roots
- Cloud Run remains the managed baseline path
- GKE remains the optional alternative path
- the single-VPS runtime is now a real optional preset, not only a future idea
