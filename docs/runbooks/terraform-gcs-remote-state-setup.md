# Terraform GCS Remote State Setup Runbook

Use this runbook to recreate the Phase 5 `P5-T02` Terraform remote-state setup
for a project created from this blueprint.

## Purpose

Terraform state must live outside developer laptops and ephemeral CI workspaces.
The blueprint uses a dedicated Google Cloud project, one GCS bucket per
environment, and Terraform's GCS backend so humans and CI share the same state
and use backend locking during plan/apply.

## Inputs

Choose these values before starting:

- Organization ID, if the project should live under a Google Cloud organization
- Billing account ID
- State project ID, for example `<project-prefix>-tfstate`
- Region, for example `us-east4`
- RC state bucket, for example `<project-prefix>-tfstate-rc`
- Prod state bucket, for example `<project-prefix>-tfstate-prod`
- Terraform root module name, for example `platform-infra`

The platform blueprint instance used:

- Organization: `miquel-piza-airas-org` (`140507280052`)
- State project: `mpa-forge-bp-tfstate`
- Region: `us-east4`
- RC bucket: `mpa-forge-bp-tfstate-rc`
- Prod bucket: `mpa-forge-bp-tfstate-prod`
- Backend prefixes: `rc/platform-infra`, `prod/platform-infra`

## Create The State Project

```sh
gcloud projects create <state-project-id> --name="<state-project-id>"
gcloud billing projects link <state-project-id> --billing-account=<billing-account-id>
gcloud services enable storage.googleapis.com --project=<state-project-id>
```

If the project was created under `No organization`, move it under the target
organization:

```powershell
$token = gcloud auth print-access-token
$body = @{ destinationParent = 'organizations/<organization-id>' } | ConvertTo-Json
Invoke-RestMethod `
  -Method Post `
  -Uri 'https://cloudresourcemanager.googleapis.com/v3/projects/<state-project-id>:move' `
  -Headers @{ Authorization = "Bearer $token"; 'Content-Type' = 'application/json' } `
  -Body $body
```

Verify the parent:

```sh
gcloud projects describe <state-project-id> --format="yaml(projectId,parent,lifecycleState)"
```

## Create Protected State Buckets

```sh
gcloud storage buckets create gs://<rc-state-bucket> \
  --project=<state-project-id> \
  --location=<region> \
  --uniform-bucket-level-access \
  --public-access-prevention

gcloud storage buckets create gs://<prod-state-bucket> \
  --project=<state-project-id> \
  --location=<region> \
  --uniform-bucket-level-access \
  --public-access-prevention

gcloud storage buckets update gs://<rc-state-bucket> --versioning
gcloud storage buckets update gs://<prod-state-bucket> --versioning
```

If the creating account can create buckets but cannot update bucket settings,
grant it storage administration on the new state project:

```sh
gcloud projects add-iam-policy-binding <state-project-id> \
  --member=user:<maintainer-email> \
  --role=roles/storage.admin
```

## Create Environment State Identities

Create one state service account per environment:

```sh
gcloud iam service-accounts create tfstate-rc \
  --project=<state-project-id> \
  --display-name="Terraform state RC"

gcloud iam service-accounts create tfstate-prod \
  --project=<state-project-id> \
  --display-name="Terraform state prod"
```

Bind each service account only to its matching bucket:

```sh
gcloud storage buckets add-iam-policy-binding gs://<rc-state-bucket> \
  --member=serviceAccount:tfstate-rc@<state-project-id>.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

gcloud storage buckets add-iam-policy-binding gs://<rc-state-bucket> \
  --member=serviceAccount:tfstate-rc@<state-project-id>.iam.gserviceaccount.com \
  --role=roles/storage.legacyBucketReader

gcloud storage buckets add-iam-policy-binding gs://<prod-state-bucket> \
  --member=serviceAccount:tfstate-prod@<state-project-id>.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

gcloud storage buckets add-iam-policy-binding gs://<prod-state-bucket> \
  --member=serviceAccount:tfstate-prod@<state-project-id>.iam.gserviceaccount.com \
  --role=roles/storage.legacyBucketReader
```

Human maintainers can use Application Default Credentials when their user
account has state-bucket access. CI should use the environment-specific service
account for the environment it plans or applies.

## Wire Terraform Backends

Add a fixed backend block to each environment root. Terraform backend blocks do
not accept variables, so bucket and prefix values are intentionally explicit.

`environments/rc/versions.tf`:

```hcl
terraform {
  backend "gcs" {
    bucket = "<rc-state-bucket>"
    prefix = "rc/<root-module>"
  }
}
```

`environments/prod/versions.tf`:

```hcl
terraform {
  backend "gcs" {
    bucket = "<prod-state-bucket>"
    prefix = "prod/<root-module>"
  }
}
```

Plan and apply commands must include a lock timeout:

```sh
terraform -chdir=environments/rc plan -input=false -lock-timeout=5m
terraform -chdir=environments/prod plan -input=false -lock-timeout=5m
terraform -chdir=environments/rc apply -lock-timeout=5m
terraform -chdir=environments/prod apply -lock-timeout=5m
```

For local Windows bash workflows, `gcloud.cmd auth print-access-token` may work
when the `gcloud` shim cannot find Python. Strip CRLF before exporting it:

```sh
export GOOGLE_OAUTH_ACCESS_TOKEN="$(gcloud.cmd auth print-access-token | tr -d '\r\n')"
```

## Validate

Run validation and plans from the infra repo:

```sh
make terraform-validate
make terraform-plan ENV=rc
make terraform-plan ENV=prod
```

Expected signs of success:

- `terraform init` reports the `gcs` backend is configured.
- `terraform plan` can read/write backend metadata in the state bucket.
- Plan/apply commands include `-lock-timeout=5m`.
- At least one plan prints `Acquiring state lock. This may take a few moments...`.

True lock contention requires two simultaneous Terraform operations against the
same environment state and is usually tested later when there is a harmless
applyable change.

## Console Verification

In Google Cloud Console:

- `IAM & Admin > Manage resources`: state project is under the target
  organization.
- State project `Billing`: billing account is linked.
- State project `Cloud Storage > Buckets`: RC and prod buckets exist.
- Each bucket `Configuration`: location, storage class, public access
  prevention, and object versioning match the chosen baseline.
- Each bucket `Permissions`: access control is `Uniform`.
- RC bucket permissions include the RC state service account.
- Prod bucket permissions include the prod state service account.
- The RC state service account is not granted on the prod bucket, and the prod
  state service account is not granted on the RC bucket.

## Evidence To Capture

Record:

- state project ID and organization parent
- billing account linkage
- bucket names, location, and safeguards
- state service accounts and bucket IAM separation
- Terraform backend prefixes
- successful validation and plan commands
- PR or commit that added backend config and lock-timeout wiring
