## 1. Phase 3 Dashboard Contract

- [x] 1.1 Update the Phase 3 planning artifacts so `P3-T06` explicitly requires source-controlled Grafana dashboard definitions for API golden signals, runtime-path status, and DB connectivity symptoms.
- [x] 1.2 Document the pre-Phase-5 bootstrap provisioning boundary for Grafana dashboards, including required stack inputs, folder or naming conventions, and the fact that bootstrap import is not the final authoritative provisioning path.
- [x] 1.3 Align the Phase 3 checklist and done-when wording so reviewers can distinguish between dashboard-definition readiness and later Terraform-owned recreation from source.
- [x] 1.4 Add the baseline dashboard JSON asset set for API golden signals, runtime-path status, and DB connectivity symptoms in `platform-infra`.
- [x] 1.5 Add a source manifest that maps the dashboard asset files to intended Grafana folder, titles, datasource inputs, and query assumptions.
- [x] 1.6 Wire the bootstrap runbook and artifact checklist to the exact dashboard asset paths so `P3-T06` points to concrete files instead of implied future assets.

## 2. Phase 5 Completion Path

- [x] 2.1 Add explicit Phase 5 planning work in `platform-infra` for Grafana provider configuration, dashboard folder resources, and env-root wiring that consume the prepared source-controlled dashboard definitions.
- [x] 2.2 Update Phase 5 validation and CI planning so the final provisioning path proves dashboards can be recreated from source after drift, deletion, or clean-state apply.
- [x] 2.3 Link the Phase 5 work back to `P3-T06` so the temporary bootstrap path cannot be mistaken for final completion.
