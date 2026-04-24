## ADDED Requirements

### Requirement: Environment-scoped runtime secrets use Google Secret Manager as the canonical source
The platform SHALL provision or reference runtime secrets in Google Secret Manager as environment-scoped resources, and every supported runtime path MUST treat those Google Secret Manager entries as the canonical secret source.

#### Scenario: Cloud Run baseline uses canonical GSM secrets
- **WHEN** a runtime secret is needed by the API or AI worker on the Cloud Run baseline path
- **THEN** the runtime secret is sourced from an environment-scoped Google Secret Manager secret rather than a plaintext Terraform value, repository file, or duplicated secret store

#### Scenario: GKE path reuses the same canonical secret source
- **WHEN** the optional GKE runtime path is enabled for a workload
- **THEN** the workload receives the same logical secret from Google Secret Manager through ESO sync rather than a separately managed Kubernetes-only secret source

### Requirement: Runtime secret access is least-privilege and workload-specific
The platform SHALL grant runtime secret access only to the service accounts and controllers that require each secret, and it MUST avoid project-wide or shared broad secret access grants.

#### Scenario: Cloud Run API secret access is scoped
- **WHEN** Terraform binds runtime secret access for the Cloud Run API service account
- **THEN** the binding grants access only to the API-approved secrets, including `DB_PASSWORD`, and does not grant access to unrelated worker or platform secrets

#### Scenario: GKE ESO path uses explicit controller and workload access
- **WHEN** the GKE path is prepared for secret sync
- **THEN** workload identity and secret-access grants are scoped to the ESO/controller or workload identities that must read the mapped Google Secret Manager secrets

### Requirement: Backend database secret delivery is password-only
The platform SHALL store only the backend API database password as the canonical database secret and MUST require the runtime to compose the full database connection string from secret and non-secret inputs.

#### Scenario: API runtime composes database connectivity from contract inputs
- **WHEN** the backend API starts with Cloud SQL connectivity enabled
- **THEN** it reads `DB_PASSWORD` from the approved secret delivery path and combines it with non-secret inputs such as `DB_HOST`, `DB_NAME`, `DB_USER`, or the Cloud SQL socket path

#### Scenario: Full database URL is not the canonical secret
- **WHEN** database secret resources are defined for the backend API
- **THEN** the canonical Google Secret Manager secret is the password secret rather than a full `DATABASE_URL`, unless a later ADR explicitly changes that requirement

### Requirement: Optional GKE secret delivery is prepared through ESO-compatible mappings
The platform SHALL define stable secret identifiers, IAM prerequisites, and mapping metadata so Phase 6 can deploy ESO and synchronize approved Google Secret Manager secrets into GKE workloads without redefining the secret catalog.

#### Scenario: Phase 6 can deploy ESO against Phase 5 outputs
- **WHEN** the GKE path is enabled in a later deployment phase
- **THEN** the Phase 5 infrastructure exposes the secret identifiers and access prerequisites needed for ESO `SecretStore` and `ExternalSecret` configuration

#### Scenario: Disabled GKE path does not block Cloud Run secret delivery
- **WHEN** the platform remains on the Cloud Run baseline path
- **THEN** Cloud Run secret delivery works without requiring ESO deployment or GKE-only secret resources to be active
