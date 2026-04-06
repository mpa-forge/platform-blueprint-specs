# Telemetry Budget Profile Runbook

## Purpose

Provide one validation checklist for `P3-T05` so Cloud Run direct OTLP and the
future GKE collector path can be checked against the same shared
`OBS_TELEMETRY_PROFILE` contract.

## Shared Expectations

- `OTEL_MODE=direct_otlp` for Cloud Run and `OTEL_MODE=collector_gateway` for
  the GKE path
- `OBS_TELEMETRY_PROFILE` accepts only `balanced`, `cost`, and `debug`
- `GRAFANA_CLOUD_INSTANCE_ID` and `GRAFANA_OTLP_INGEST_TOKEN` remain the only
  Grafana auth ingredients given to workloads
- startup diagnostics must include:
  - service name and version
  - environment
  - runtime mode
  - telemetry profile
  - resolved trace sample ratio
  - high-latency force-sample threshold

## Profile Mapping

- `balanced`
  - base trace sampling: `rc=25%`, `prod=5%`
  - keep error and high-latency force-sample rules
- `cost`
  - base trace sampling: `rc=10%`, `prod=2%`
  - preserve error and health visibility
  - reduce successful request-duration metrics in direct mode
- `debug`
  - full trace export
  - keep force-sample rules active

## Cloud Run Direct OTLP Checklist

1. Confirm service runtime config includes:
   - `OTEL_MODE=direct_otlp`
   - `OBS_TELEMETRY_PROFILE=<expected profile>`
   - `OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp-gateway-prod-us-east-3.grafana.net/otlp`
   - `GRAFANA_CLOUD_INSTANCE_ID=1546554`
2. Confirm the workload receives `GRAFANA_OTLP_INGEST_TOKEN` from GSM instead
   of a prebuilt `OTEL_EXPORTER_OTLP_HEADERS` value.
3. Start the service and capture startup diagnostics showing mode, profile,
   trace sample ratio, and high-latency threshold.
4. Execute one public endpoint flow and one protected API flow.
5. Verify traces and metrics include:
   - `service.name`
   - `service.version`
   - `deployment.environment`
   - `platform.observability.runtime_mode`
   - `platform.observability.telemetry_profile`
6. Verify request completion logs still include trace correlation fields.
7. Switch to `cost` and `debug` through config only and confirm the startup
   diagnostics reflect the new policy without code changes.

## GKE Collector Gateway Checklist

1. Confirm service runtime config includes:
   - `OTEL_MODE=collector_gateway`
   - `OBS_TELEMETRY_PROFILE=<expected profile>`
   - `OTEL_EXPORTER_OTLP_ENDPOINT=<collector receiver URL>`
   - `GRAFANA_CLOUD_INSTANCE_ID=1546554`
2. Confirm the workload receives `GRAFANA_OTLP_INGEST_TOKEN` through ESO-backed
   secret delivery.
3. Confirm the collector config includes:
   - OTLP receivers
   - Grafana OTLP exporter using the same token-ingredient auth contract
   - force-sample rules for errors and spans slower than `1s`
   - profile-derived baseline trace sampling
4. Execute one public endpoint flow and one protected API flow.
5. Verify Grafana Cloud receives traces and metrics with the same resource
   labels used by the direct OTLP path.
6. Change the profile and confirm the service-facing contract stays unchanged
   while the collector-derived sampling inputs change as expected.

## Evidence to Capture

- repo-local validation commands for `platform-observability` and `backend-api`
- updated `platform-infra` placeholder artifacts or deployable manifests,
  depending on phase
- one evidence note that calls out:
  - which repo owns each part of the delivery
  - what was validated locally
  - what still depends on Phase 5/6 deployable roots

## Current Boundary

As of `2026-04-06`, live GKE deployment validation remains deferred because
`platform-infra` still lacks deployable Terraform and Helm roots for the
collector path. The checklist above is still the required acceptance target for
marking the overall Phase 3 task complete later.
