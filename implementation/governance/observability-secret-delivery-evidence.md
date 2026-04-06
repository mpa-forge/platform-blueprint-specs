# Observability Secret Delivery Evidence

## Scope

This evidence file records the Phase 3 baseline delivery model for Grafana OTLP
credentials after the shared backend observability runtime and `backend-api`
were changed to accept token ingredients instead of prebuilt OTLP header
strings.

## Locked Delivery Model

### Cloud Run baseline path

Runtime configuration uses:

- `OTEL_MODE=direct_otlp`
- `OBS_TELEMETRY_PROFILE=<balanced|cost|debug>`
- `OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp-gateway-prod-us-east-3.grafana.net/otlp`
- `GRAFANA_CLOUD_INSTANCE_ID=1546554`
- `GRAFANA_OTLP_INGEST_TOKEN` injected from GSM

The shared `backendobs` package composes the OTLP Basic auth header at startup.
Cloud Run should not inject a prebuilt `OTEL_EXPORTER_OTLP_HEADERS` value.

### GKE alternative path

The GKE path will use the same token-ingredient contract, with
`GRAFANA_OTLP_INGEST_TOKEN` synchronized from GSM through External Secrets
Operator (ESO). Placeholder manifests now live in `platform-infra`.

## Repo Outputs

- `platform-observability`
  - shared runtime now accepts `GRAFANA_CLOUD_INSTANCE_ID` and
    `GRAFANA_OTLP_INGEST_TOKEN`
  - OTLP Basic auth header composition moved inside the shared package
- `backend-api`
  - startup contract now requires OTLP endpoint plus Grafana token ingredients
  - `.env.example`, docs, and OpenSpec spec now match the new contract
- `platform-infra`
  - documents the Cloud Run secret-delivery model
  - contains placeholder Cloud Run Terraform, GKE ESO, workload env, and
    collector pipeline artifacts for later Phase 5/6 implementation

## Deferred Items

- `platform-infra` still has no deployable Terraform roots, so actual Cloud Run
  resource wiring remains deferred to Phase 5.
- Prod GSM secret delivery remains deferred until prod activation.
- Worker secret delivery remains deferred to Phase 9.
