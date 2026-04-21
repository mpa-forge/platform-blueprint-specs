# Terraform Remote State Evidence (`P5-T02`)

Date: `2026-04-21`

## Cloud Resources

- State project: `mpa-forge-bp-tfstate`
- Parent organization: `miquel-piza-airas-org` (`140507280052`)
- Billing linked: `0191F2-169FC2-7A8CFF`
- Region: `us-east4`
- RC bucket: `gs://mpa-forge-bp-tfstate-rc`
- Prod bucket: `gs://mpa-forge-bp-tfstate-prod`

Both buckets were verified with:

- Object Versioning enabled
- Uniform bucket-level access enabled
- Public Access Prevention enforced
- Standard storage class

## IAM

Environment-specific service accounts were created in the state project:

- `tfstate-rc@mpa-forge-bp-tfstate.iam.gserviceaccount.com`
- `tfstate-prod@mpa-forge-bp-tfstate.iam.gserviceaccount.com`

Each service account is bound only to its matching state bucket with object
administration access and bucket-read metadata access.

The maintainer account was granted `roles/storage.admin` on the dedicated state
project so it can administer bucket settings after project creation.

## Platform Infra Changes

Repository: `../platform-infra`

Branch: `codex/p5-t02-remote-state`

Changed files:

- `environments/rc/versions.tf`
- `environments/prod/versions.tf`
- `Makefile`
- `README.md`
- `docs/terraform-file-guide.md`
- `docs/terraform-remote-state.md`

The environment roots now configure fixed `backend "gcs"` blocks:

- RC prefix: `rc/platform-infra`
- Prod prefix: `prod/platform-infra`

The repo Make targets run plan/apply with `-lock-timeout=5m`. Local runs can
use ADC or the active `gcloud` account token; CI should use an environment
service account with access to the matching bucket.

## Validation

Validation commands completed successfully in `../platform-infra`:

- `make terraform-validate`
- `make terraform-plan ENV=rc`
- `make terraform-plan ENV=prod`

The RC plan showed Terraform acquiring the remote state lock before planning.
Both environment plans used the GCS backend and produced output-only plans
against their respective service project boundaries.
