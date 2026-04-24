# P5-T07 Runtime Secret Delivery Evidence

## Scope

This evidence file records the implementation baseline for `P5-T07: Implement
GSM + IAM + ESO integration resources` across `platform-infra`, `backend-api`,
`platform-ai-workers`, and `backend-worker`.

## Canonical Secret Catalog

The Phase 5 baseline now treats Google Secret Manager as the canonical secret
source for runtime delivery.

Environment-scoped secret names are:

- `grafana-otlp-ingest-token-<env>` for `GRAFANA_OTLP_INGEST_TOKEN`
- `api-db-password-<env>` for `DB_PASSWORD`
- `ai-worker-github-pat-<worker-id>-<env>` for `GITHUB_TOKEN`
- `ai-worker-agent-key-<worker-id>-<env>` for optional `OPENAI_API_KEY`

`platform-infra/modules/secrets` now exports stable versionless catalogs for:

- `secret_catalog`
- `cloud_run_secret_catalog`
- `eso_secret_catalog`

Environment roots (`rc`, `prod`) now publish:

- `service_contracts.runtime_secret_catalog`
- `service_contracts.ai_worker_runtime_contracts`
- `service_contracts.gke_secret_sync_contract`

These outputs keep secret names versionless. Runtime consumers add `latest`
only at the Cloud Run env wiring point.

## Cloud Run Baseline Validation

The Cloud Run API baseline now exposes an explicit least-privilege secret access
contract through `modules/cloudrun_api.runtime_secret_access_contract`.

Validated baseline behavior:

- Cloud Run API IAM access remains limited to `DB_PASSWORD` and
  `GRAFANA_OTLP_INGEST_TOKEN`
- `backend-api` prefers split `DB_HOST` / `DB_NAME` / `DB_USER` /
  `DB_PASSWORD` inputs whenever cloud-style DB config is present
- `DATABASE_URL` remains a local fallback only
- `platform-ai-workers` documents and validates GSM-backed `GITHUB_TOKEN`
  delivery, with GSM-backed `OPENAI_API_KEY` only when
  `AGENT_AUTH_MODE=api`
- `backend-worker` docs now preserve the same GSM-first, password-only
  contract for its later runtime phase

## GKE / ESO Handoff

The optional GKE path now has Phase 5 prerequisites for Workload Identity and
ESO mapping without deploying ESO itself.

`platform-infra/modules/gke` now exports:

- `workload_identity_principals`
- `eso_secret_mappings`

The environment roots wire these outputs so Phase 6 can consume:

- ClusterSecretStore name: `gcp-secret-manager`
- Workload Identity principals for:
  - `external-secrets`
  - `backend-api`
- ESO target secret name:
  - `backend-api-runtime-secrets`
- Kubernetes secret keys:
  - `DB_PASSWORD`
  - `GRAFANA_OTLP_INGEST_TOKEN`

This keeps the Cloud Run and GKE paths aligned to the same GSM catalog.

## Validation

The following validations passed during implementation:

- `platform-infra`: `make terraform-validate`
- `backend-api`: `make test`
- `backend-api`: `make lint`
- `backend-api`: `make format-check`
- `platform-ai-workers`: `go test ./...`
- `platform-ai-workers`: `make lint`
- `platform-ai-workers`: `make format-check`
- `backend-worker`: `python -m pre_commit run --files README.md .env.example docs/runtime-secret-contract.md`

## Repo Outputs

- `platform-infra`
  - reusable secret catalog metadata, Cloud Run IAM contract, GKE Workload
    Identity outputs, and ESO placeholder prerequisites
- `backend-api`
  - split DB runtime/migration contract aligned to secret-backed `DB_PASSWORD`
    with local `DATABASE_URL` fallback only
- `platform-ai-workers`
  - Cloud Run Job credential contract aligned to GSM-backed `GITHUB_TOKEN`
    and optional GSM-backed `OPENAI_API_KEY`
- `backend-worker`
  - future runtime docs aligned to GSM-first secret delivery and password-only
    DB credential handling
