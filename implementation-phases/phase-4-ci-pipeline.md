# Phase 4: CI Pipeline

Detailed tasks: `implementation-phase-tasks/phase-4-ci-pipeline-tasks.md`

- Configure CI workflow:
  - lint + unit tests
  - `buf lint` and `buf breaking`
  - contract/proto generation checks (fail if generated code is stale)
  - container image builds
  - push signed/immutable-tagged images to Google Artifact Registry
  - authenticate CI to GCP via Workload Identity Federation (no static keys)
  - vulnerability scan (dependencies + images)
- Code quality/security tooling baseline (recommended defaults):
  - Go quality: `golangci-lint`, `go test`, `go vet`
  - Frontend quality: `eslint`, `tsc --noEmit`, optional `prettier --check`
  - Repository quality gate: `sonar` (`sonarcloud` free tier where eligible)
  - Protobuf contracts: `buf lint`, `buf breaking`
  - Secrets scanning: `gitleaks`
  - Dependency + container vulnerability scanning: `trivy` (filesystem + image)
  - SAST: `semgrep` (or `codeql` as alternative)
  - IaC checks: `terraform fmt -check`, `terraform validate`, `tflint` (plus `tfsec`/`checkov` optional)
  - Supply chain (later hardening): `syft` (SBOM), `cosign` (signing), provenance attestation
- Vulnerability merge gate policy baseline:
  - Block merges on `Critical` findings in runtime dependencies or container images.
  - Block merges on `High` findings in runtime dependencies or container images when a fix is available.
  - Notify-only for `High` findings without fix, `Medium`/`Low`, and dev/test-only findings.
  - Require a time-boxed waiver ticket for accepted exceptions.
- Add test reports and build artifacts.
- Enforce branch protection and required checks.
- Standardize reusable workflow templates consumed across repos.
- Add governance checks for AI-generated PRs (required status checks/reviewers and standardized metadata labels).
- Add event-driven AI worker trigger workflows so review feedback can invoke immediate rework without waiting for scheduler cadence.
- CI runtime target baseline for PR pipelines:
  - `p50 <= 10 minutes`
  - `p95 <= 15 minutes`
  - hard cap `20 minutes` for required PR checks

Exit criteria:
- PRs blocked unless CI passes.
- Image artifacts generated with immutable tags and published to Google Artifact Registry.

## Open Questions / Choices To Clarify Later
- None currently.
