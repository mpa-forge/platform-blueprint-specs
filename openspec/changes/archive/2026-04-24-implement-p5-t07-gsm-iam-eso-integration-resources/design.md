## Context

Phase 5 introduces deployable Terraform infrastructure for the platform runtime path. The platform decision baseline already locks Google Secret Manager as the runtime secret source of truth, Cloud Run as the first delivery path, and Google Secret Manager plus External Secrets Operator as the optional GKE delivery path. P5-T06 established that backend database connectivity must use non-secret connection inputs plus a secret-backed `DB_PASSWORD`, so P5-T07 needs to turn that contract into concrete secret resources, service-account grants, and GKE prerequisites without leaking secrets into Terraform values or creating broad project-level access.

This change spans multiple repositories. `platform-infra` owns the Terraform resources and optional GKE identity prerequisites, while `backend-api`, `backend-worker`, and `platform-ai-workers` own the runtime contracts that consume those secrets. Phase 5 should provide the canonical secret inventory and access model. Phase 6 remains responsible for deploying ESO and workload manifests on the GKE path.

## Goals / Non-Goals

**Goals:**
- Define a single runtime secret-delivery model with Google Secret Manager as the canonical source of truth.
- Standardize environment-scoped secret placeholders and access bindings for Cloud Run API and AI worker runtimes.
- Prepare the optional GKE path with workload identity and ESO-compatible mappings so secrets can sync from GSM when enabled.
- Preserve the backend database credential contract by storing only `DB_PASSWORD` as the canonical secret and requiring applications to assemble connection strings from secret and non-secret parts.
- Make apply-time work explicit across `platform-infra` and the dependent runtime repositories.

**Non-Goals:**
- Deploy ESO itself, Helm charts, or final GKE workload manifests beyond the prerequisites needed for later phases.
- Implement secret rotation automation or hardening-phase secret lifecycle policy.
- Replace the password-only database contract with a full `DATABASE_URL` secret.
- Add backend-worker runtime secret delivery beyond the baseline inventory and access patterns needed for its future phases.

## Decisions

### Decision: Google Secret Manager remains the only canonical runtime secret store

Terraform will provision or reference environment-scoped secret placeholders in GSM for runtime credentials. Cloud Run workloads will consume those secrets directly, and GKE workloads will receive the same secrets through ESO sync when the GKE path is enabled.

Alternatives considered:
- Store separate canonical copies for Cloud Run and Kubernetes delivery. Rejected because it creates drift and inconsistent rotation behavior.
- Delay secret resource creation until Phase 6 deployment work. Rejected because Phase 6 depends on stable secret identifiers and IAM grants from Phase 5.

### Decision: Secret access stays workload-specific and least-privilege

Each runtime workload class will have explicit secret accessor grants for only the secrets it needs. Cloud Run API and AI worker service accounts receive direct GSM access for their approved secrets. The GKE path receives workload identity bindings and ESO reader permissions scoped to the controller and workload service accounts needed to sync or consume those same secrets.

Alternatives considered:
- Grant project-wide secret access to a shared runtime service account. Rejected because it violates the platform access model and expands blast radius.
- Model all runtime workloads behind one shared secret bundle. Rejected because it obscures ownership and makes future rotation harder.

### Decision: Database delivery remains password-only

The backend API database credential contract will store only the password secret, such as an environment-scoped `api-db-password`, in GSM. Runtime configuration must build the full connection string from non-secret inputs such as `DB_HOST`, `DB_NAME`, `DB_USER`, or the Cloud SQL socket path plus the secret-backed `DB_PASSWORD`.

Alternatives considered:
- Store a full `DATABASE_URL` in GSM. Rejected because it duplicates non-secret configuration and weakens the contract already established in P5-T06.
- Put placeholder passwords directly in Terraform environment values. Rejected because it normalizes secret leakage into state and config surfaces.

### Decision: Phase 5 owns GKE secret prerequisites, not ESO deployment

This change will define the IAM, workload identity, and secret-mapping prerequisites that allow ESO to function later, but it will not install ESO or complete workload wiring. That deployment work remains in P6-T04 so infrastructure provisioning and runtime deployment stay separately testable.

Alternatives considered:
- Fully deploy ESO in Phase 5. Rejected because it crosses the Terraform infrastructure boundary into runtime deployment.
- Ignore the GKE path until Phase 6. Rejected because Phase 6 would then need to invent identity and access assumptions that should be controlled by the infrastructure baseline.

## Risks / Trade-offs

- [Secret inventory drift across repos] -> Mitigate by defining a single Terraform-managed secret catalog and reflecting only the consumption contract in application repos.
- [GKE prerequisite scope becomes too implementation-specific before runtime path is chosen] -> Mitigate by limiting Phase 5 to workload identity, IAM, and stable secret mapping contracts, while leaving Helm and ESO deployment details to Phase 6.
- [Future services need different secret naming patterns] -> Mitigate by standardizing environment and workload scoping now but keeping the Terraform module inputs extensible for new secret entries.
- [AI worker secret requirements expand after Phase 9 design settles] -> Mitigate by treating worker coverage here as a baseline for execution credentials and allowing later changes to add worker-specific secrets without changing the canonical delivery model.

## Migration Plan

1. Add Terraform secret-management modules or root-level resources in `platform-infra` that create or reference environment-scoped GSM secrets and expose stable outputs for runtime consumers.
2. Bind Cloud Run service accounts to the minimal secret set required for API and AI worker execution, including the database password secret for the API.
3. Add optional GKE workload identity and secret-access prerequisites so ESO and selected workloads can read approved GSM secrets when the cluster path is enabled.
4. Update runtime repositories to consume the agreed secret names and environment contract without expecting a full `DATABASE_URL` secret.
5. Validate the Cloud Run baseline first, then confirm the GKE path can map the same secrets through ESO when enabled.

Rollback relies on Terraform reverting IAM/resource changes while preserving existing secret values and versions in GSM. Because Cloud Run and GKE both read from GSM as the canonical source, reverting access or mapping changes does not require reissuing duplicate secrets.

## Open Questions

- Which AI worker secrets should be in the Phase 5 baseline versus deferred to Phase 8 or Phase 9 once more worker-specific runtime contracts are finalized?
- Should Terraform own placeholder secret versions for bootstrap-only environments, or should all initial secret values be injected through an out-of-band operator workflow after the resources exist?
- How much of the GKE secret mapping contract should live as Terraform outputs versus checked-in manifest templates for Phase 6 consumption?
