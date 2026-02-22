# Phase 4 Tasks: CI Pipeline

## Goal
Enforce quality, contract integrity, and reproducible artifacts from every change before deployment.

## Tasks

### P4-T01: Define reusable workflow standards across repos
Owner: Agent  
Type: CI design  
Dependencies: Phase 1 repos created  
Action: Establish centralized reusable workflow templates for Go, frontend, contracts, and infra repos, consumed by each repository pipeline.  
Output: Shared workflow policy doc and starter YAMLs.  
Done when: Each repo has a consistent CI entrypoint and naming convention.

### P4-T02: Implement lint + unit test jobs
Owner: Agent  
Type: CI coding  
Dependencies: P4-T01  
Action: Add jobs for Go/TS linting and unit tests with caching and deterministic tooling versions.  
Output: CI quality gates on every PR.  
Done when: PRs fail on lint/test errors.

### P4-T03: Add protobuf quality gates
Owner: Agent  
Type: CI coding  
Dependencies: Phase 2 contracts baseline  
Action: Add `buf lint`, `buf breaking`, and generated-code drift checks.  
Output: Contract integrity checks in CI.  
Done when: Breaking changes are blocked unless versioning policy is followed.

### P4-T04: Implement container build and image tagging strategy
Owner: Agent  
Type: CI coding  
Dependencies: P4-T02  
Action: Build API/worker images with immutable tags (commit SHA + semver tag support).  
Output: Reproducible container artifacts.  
Done when: CI publishes deterministic image tags for every merge.

### P4-T05: Configure GAR repositories and CI push permissions
Owner: Human + Agent  
Type: Provider config + CI  
Dependencies: Phase 5 GAR/IAM availability or temporary manual bootstrap  
Action: Ensure CI principal can push to GAR with least privilege.  
Output: Working auth path to GAR from GitHub Actions.  
Done when: Merge pipeline pushes images without static keys.

### P4-T06: Configure Workload Identity Federation for GitHub Actions
Owner: Human + Agent  
Type: Security configuration  
Dependencies: P4-T05  
Action: Create identity pool/provider, map GitHub claims, grant minimal IAM roles.  
Output: Keyless CI-to-GCP authentication.  
Done when: CI can authenticate to GCP via OIDC and no service account key files are used.

### P4-T07: Add dependency and image vulnerability scanning
Owner: Agent  
Type: CI coding  
Dependencies: P4-T02, P4-T04  
Action: Integrate scanners (language dependencies + container images), and enforce baseline gate policy (block `Critical` in runtime deps/images; block `High` in runtime deps/images when fix is available; notify-only for `High` without fix, `Medium`/`Low`, and dev/test-only findings; support time-boxed waiver tickets).  
Output: Vulnerability reports and gate policy.  
Done when: CI enforces the defined gate policy and accepted exceptions are traceable via time-boxed waiver records.

### P4-T08: Publish test reports and build artifacts
Owner: Agent  
Type: CI coding  
Dependencies: P4-T02  
Action: Upload test results, logs, and relevant build artifacts with retention policy.  
Output: Traceable CI outputs for debugging.  
Done when: Failed jobs include downloadable diagnostics.

### P4-T09: Enforce branch protection required checks
Owner: Human  
Type: Governance  
Dependencies: P4-T02..P4-T08  
Action: Configure protected branch required statuses and review rules in GitHub.  
Output: Enforcement settings active.  
Done when: Merge is blocked unless required CI checks pass.

### P4-T10: CI performance tuning
Owner: Agent  
Type: Optimization  
Dependencies: P4-T02..P4-T08  
Action: Add caching, parallel job splitting, and timeout budgets for fast feedback loops.  
Output: CI runtime optimization report.  
Done when: PR pipeline runtime meets SLO baseline (`p50 <= 10 min`, `p95 <= 15 min`) and required checks enforce a hard cap of `20 min`.

## Artifacts Checklist
- Workflow templates and repo CI YAMLs
- Contract check jobs
- image build/tag policy docs
- WIF/OIDC integration docs
- vulnerability scan configuration
- CI artifact retention policy
- GitHub branch protection settings evidence
