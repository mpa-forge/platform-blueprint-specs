## 1. Secret Catalog And Contracts

- [x] 1.1 Finalize the environment-scoped runtime secret inventory and Terraform module inputs/outputs for Cloud Run and optional GKE delivery
  Sub-agent: Local
  Ownership: Final design synthesis across `platform-infra`, `backend-api`, `backend-worker`, and `platform-ai-workers`
  Expected output: Agreed secret catalog, naming pattern, consumer mapping, and implementation notes for follow-on tasks
  Blocking: Yes

- [x] 1.2 Define the repository-level runtime contract updates required to consume password-only database delivery and direct GSM secret access
  Sub-agent: `openspec_analyst`
  Ownership: Read-only inventory of env vars, docs, and runtime touchpoints in `backend-api`, `backend-worker`, and `platform-ai-workers`
  Expected output: File/path list, contract delta summary, and repo-specific open questions
  Blocking: No - continue Terraform implementation planning while this inventory runs

## 2. Terraform Secret Infrastructure

- [x] 2.1 Implement Google Secret Manager secret resources, environment scoping, and stable outputs in `platform-infra`
  Sub-agent: `openspec_heavy_lift`
  Ownership: `platform-infra` secret modules, environment stacks, and related Terraform outputs
  Expected output: Terraform resources for the runtime secret catalog with reusable environment-scoped interfaces
  Blocking: Yes

- [x] 2.2 Implement Cloud Run service account and IAM bindings for API and AI worker secret access
  Sub-agent: `openspec_implementer`
  Ownership: `platform-infra` Cloud Run runtime IAM bindings and service account wiring
  Expected output: Least-privilege secret accessor grants for the Cloud Run API and AI worker runtimes
  Blocking: Yes

- [x] 2.3 Implement optional GKE workload identity and ESO prerequisite mappings for approved runtime secrets
  Sub-agent: `openspec_implementer`
  Ownership: `platform-infra` GKE identity bindings, secret access policy, and ESO-facing mapping artifacts
  Expected output: Terraform-managed prerequisites that Phase 6 can use to deploy ESO and sync the approved secret set
  Blocking: Partial - local integration review can proceed while implementation lands

## 3. Runtime Consumer Alignment

- [x] 3.1 Update `backend-api` to consume `DB_PASSWORD` plus non-secret database connection inputs instead of expecting a canonical `DATABASE_URL` secret
  Sub-agent: `openspec_refactorer`
  Ownership: `backend-api` runtime config, environment contract docs, and validation for database startup wiring
  Expected output: API runtime contract aligned with password-only secret delivery
  Blocking: Yes

- [x] 3.2 Align worker runtime contracts with the Phase 5 secret catalog
  Sub-agents:
  Agent A: `openspec_implementer`, owns `platform-ai-workers` runtime env docs/config for direct GSM-backed Cloud Run Jobs secret delivery
  Agent B: `openspec_implementer`, owns `backend-worker` env/docs updates needed to preserve the same canonical secret model for later runtime phases
  Integration owner: Main agent
  Blocking: No - can run in parallel after the secret catalog is stable

## 4. Validation

- [x] 4.1 Validate the Cloud Run baseline secret path for API and AI worker runtimes
  Sub-agent: Local
  Ownership: Cross-repo integration validation and evidence capture
  Expected output: Proof that approved Cloud Run runtimes can read expected secrets, including `DB_PASSWORD`, without plaintext secrets in Terraform environment values
  Blocking: Yes

- [x] 4.2 Validate the optional GKE path handoff to Phase 6
  Sub-agent: Local
  Ownership: Cross-check Terraform outputs, identity bindings, and ESO prerequisites against Phase 6 requirements
  Expected output: Confirmed Phase 6 handoff for `SecretStore` and `ExternalSecret` deployment without redefining the secret catalog
  Blocking: No - finish before closing the change
