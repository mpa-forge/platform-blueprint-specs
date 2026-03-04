# Phase 0 Tasks: Foundation & Decisions

## Goal
Lock all foundational platform decisions, accounts, access, and governance needed to start implementation with low rework risk.

## Tasks

### P0-T03A: Create or confirm GitHub organization baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Action: Create or confirm the primary GitHub organization as the control plane for all project repositories and workflows. Set single-owner baseline, enforce 2FA, confirm billing profile, confirm GitHub Actions and GitHub Packages availability, and confirm project-level planning features (Issues + Projects).  
Output: `docs/governance/provider-account-inventory.md` updated with GitHub org URL, owner, billing status, and baseline feature flags.  
Done when: GitHub org is writable by the maintainer, repositories can be created under it, and org-level Projects/Actions/Packages are enabled.
Execution checklist:
- Confirm org name and owner account.
- Enable 2FA requirement for members.
- Confirm org billing/contact profile.
- Confirm Actions and Packages are enabled for repos in the org.
- Record org URL, owner, and baseline settings in provider account inventory.

### P0-T00: Bootstrap repositories required for Phase 0 artifacts
Owner: Human  
Type: Repo setup  
Dependencies: P0-T03A  
Action: Perform a minimal repository bootstrap to establish stable repository identities for Phase 0 governance artifacts. Create the dedicated docs repository first (required), and optionally create lightweight placeholder repos (`frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`, `platform-infra`) so ownership/decision documents can reference real repos/URLs. This task is identity/bootstrap only and is not the authoritative repo provisioning step.  
Output: Repository bootstrap evidence (URLs/IDs).  
Done when: Dedicated docs repo exists and is writable; optional placeholder repos exist if chosen; Phase 1 remains the authoritative step for full repo provisioning and protection policy enforcement.
Execution checklist:
- Create the dedicated docs repo and confirm write access.
- Optionally create placeholder repos with final intended names.
- Record bootstrap evidence: repo name, URL, repo ID, owner/maintainer.
- Mark each repo as `placeholder` or `finalized`.
- Ensure Phase 0 governance artifacts can reference these repositories.
Out of scope for P0-T00 (handled in P1-T01):
- Full branch protection policy rollout.
- Required CI checks and enforcement settings.
- Full repository scaffolding and implementation initialization.

### P0-T01: Create decision register and ADR template
Owner: Agent  
Type: Documentation  
Dependencies: P0-T00  
Action: Create `docs/adr/README.md` and `docs/adr/adr-template.md` in the dedicated docs repository.  
Output: ADR structure committed.  
Done when: Team can add dated decision records with context/options/consequences.

### P0-T02: Define and document repository ownership model
Owner: Human  
Type: Governance  
Dependencies: P0-T00, P0-T01  
Action: Assign one human maintainer for each existing repo (`frontend-web`, `backend-api`, `backend-worker`, `platform-ai-workers`, `platform-contracts`, `platform-infra`, dedicated docs repo), and document optional AI-agent ownership/execution responsibilities. If some repositories are not created yet, record provisional ownership and finalize immediately after repo creation in Phase 1.  
Output: `docs/governance/repo-ownership.md`.  
Done when: Every existing repo has at least one human maintainer and documented AI-agent responsibilities where applicable; missing repos are marked as provisional ownership entries.

### P0-T03B: Create or confirm GCP project baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Status: Completed (`2026-03-03`)  
Evidence: `docs/governance/provider-account-inventory.md` (`P0-T03B` section)  
Action: Create or confirm the GCP project model for `rc` and `prod` with separate projects, billing linkage, and baseline region `us-east4`. Confirm Cloud Run, Cloud SQL, Artifact Registry, Secret Manager, IAM, Logging, and Monitoring APIs are enabled in the active implementation project(s).  
Output: `docs/governance/provider-account-inventory.md` updated with GCP project IDs, billing account mapping, and enabled services baseline.  
Done when: Required GCP projects are accessible to maintainer, billing is active, and baseline services are enabled for platform rollout.
Execution checklist:
- Confirm project IDs for `rc` and `prod`.
- Confirm billing account linkage.
- Set primary region standard to `us-east4` in documentation.
- Enable required APIs in `rc` (and `prod` if pre-created).
- Record projects, billing, and service status in provider account inventory.

### P0-T03C: Create or confirm Clerk auth baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Status: Deferred (`2026-03-04`) after baseline account/app selection; finalize once domain and secret-management baseline are available.  
Action: Create or confirm Clerk setup for B2C external authentication using Free plan constraints, including application/instance placeholders and allowed redirect/logout/web origin placeholders for `rc` and `prod`.  
Output: `docs/governance/provider-account-inventory.md` updated with Clerk account/application details and plan tier.  
Done when: Clerk dashboard is accessible, Free tier is confirmed, and baseline app/instance placeholders exist for later integration.
Execution checklist:
- Confirm Clerk account/team and primary application naming.
- Confirm Free plan status.
- Create baseline application/instance placeholder entries for environment mapping.
- Record expected redirect/logout/origin domain placeholders.
- Record Clerk metadata in provider account inventory.

### P0-T03D: Create or confirm Grafana Cloud baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Status: Completed (`2026-03-04`) for `rc` scope; `prod` token/secret provisioning deferred until prod activation.  
Evidence: `docs/governance/provider-account-inventory.md` (`P0-T03D` section)  
Action: Create or confirm Grafana Cloud stack on Free tier for managed metrics, logs, and traces; confirm access model and token management path for ingestion/query operations required by later phases.  
Output: `docs/governance/provider-account-inventory.md` updated with Grafana Cloud org/stack and plan tier.  
Done when: Stack is accessible, Free tier is confirmed, and `rc` credentials/tokens are provisioned and documented for telemetry ingestion.
Execution checklist:
- Confirm Grafana Cloud org and stack name.
- Confirm Free tier status.
- Confirm who can create/manage access tokens.
- Record stack URL, access policies, and `rc` token-to-GSM mapping in provider account inventory.
- Defer runtime export validation to later phases once at least one API/worker service is deployed and running.

### P0-T03E: Create or confirm Sentry baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Action: Create or confirm Sentry organization and baseline projects for backend/frontend error tracking on Developer (Free) tier, including token and DSN management ownership.  
Output: `docs/governance/provider-account-inventory.md` updated with Sentry org/projects and plan tier.  
Done when: Sentry org is accessible, required projects exist or are planned, and Developer (Free) tier is confirmed.
Execution checklist:
- Confirm Sentry org name and owner.
- Confirm Developer (Free) tier.
- Create baseline project placeholders (API and frontend).
- Confirm token/DSN management owner.
- Record organization/project metadata in provider account inventory.

### P0-T03F: Create or confirm incident.io baseline
Owner: Human  
Type: Account setup  
Dependencies: None  
Action: Create or confirm incident.io workspace on Basic (Free) tier and define baseline access owner for incident response workflows used in later phases.  
Output: `docs/governance/provider-account-inventory.md` updated with incident.io workspace details and tier.  
Done when: Workspace is accessible, tier is confirmed, and baseline operator ownership is documented.
Execution checklist:
- Confirm workspace URL/name.
- Confirm Basic (Free) tier.
- Confirm owner/admin account.
- Record workspace details in provider account inventory.

### P0-T03G: Create or confirm SonarQube Cloud baseline
Owner: Human  
Type: Account setup  
Dependencies: P0-T03A  
Action: Create or confirm SonarQube Cloud organization bound to GitHub and lock Free tier usage for baseline code quality checks.  
Output: `docs/governance/provider-account-inventory.md` updated with SonarQube Cloud org and tier.  
Done when: SonarQube Cloud org is linked to GitHub and Free tier is confirmed for initial repositories.
Execution checklist:
- Confirm SonarQube Cloud org.
- Confirm VCS binding to GitHub org.
- Confirm Free tier and repository eligibility assumptions.
- Record org and integration status in provider account inventory.

### P0-T04: Define environment naming and region baseline
Owner: Human  
Type: Decision  
Dependencies: P0-T03B  
Action: Confirm environment model (`local`, `rc`, `prod`), lock primary region to `us-east4` for `rc` and `prod`, document prod full separation plus RC isolation boundaries (DB boundary, secret scope, domain; namespace boundary when GKE path is enabled), lock API runtime baseline to Cloud Run for first iteration, and defer initial GKE cluster provisioning until explicitly needed; capture runtime selection contract in `ops/api-runtime-paths-cloud-run-gke.md`.  
Output: `docs/standards/environment-and-region.md`.  
Done when: Names/regions are fixed and reused consistently in infra and CI.

### P0-T05: Define naming/tagging conventions
Owner: Agent  
Type: Documentation  
Dependencies: P0-T04  
Action: Document naming conventions for repos, GAR images, Terraform resources, Cloud Run services/revisions, optional k8s namespaces, labels, and tags.  
Output: `docs/standards/naming-and-labeling.md`.  
Done when: Convention includes examples and required tags per environment.

### P0-T06: Define git workflow and release versioning policy
Owner: Human  
Type: Governance  
Dependencies: P0-T02  
Action: Finalize trunk-based branch policy, protected branches, semantic versioning scope per repo.  
Output: `docs/standards/git-and-release-policy.md`.  
Done when: Policy is approved and ready to enforce in GitHub settings.

### P0-T07: Define security ownership and access model baseline
Owner: Human  
Type: Security governance  
Dependencies: P0-T03A, P0-T03B, P0-T03C, P0-T03D, P0-T03E, P0-T03F, P0-T03G  
Action: Set least-privilege groups for cloud/admin/developer access and on-call escalation ownership.  
Output: `docs/security/access-model.md`.  
Done when: IAM group model and emergency access flow are documented.

### P0-T08: Capture locked technology decisions in one matrix
Owner: Agent  
Type: Documentation  
Dependencies: P0-T01  
Action: Build a decision matrix cross-linking `platform-specification.md` and phase files to current locked choices and deferred items.  
Output: `docs/adr/decision-matrix.md`.  
Done when: Every major domain (auth, observability, infra, CI/CD, data, runtime) has explicit status.

### P0-T09: Confirm deferred queue policy and trigger criteria
Owner: Human  
Type: Decision  
Dependencies: P0-T08  
Action: Define exactly what conditions trigger queue re-evaluation (throughput, retry semantics, async workflow count).  
Output: `docs/standards/deferred-queue-policy.md`.  
Done when: Trigger criteria are objective and measurable.

### P0-T10: Define task management platform and workflow baseline
Owner: Human + Agent  
Type: Governance  
Dependencies: P0-T02, P0-T06  
Action: Standardize task management on GitHub Issues + GitHub Projects with one cross-repo project board, issue templates (`feature`, `bug`, `chore`, `spike`), label taxonomy (`area/*`, `priority/*`, `type/*`, `env/*`), status flow (`Backlog` -> `Ready` -> `In Progress` -> `In Review` -> `Blocked` -> `Done`), and automation rules (auto-add issues/PRs, auto-status transitions, close-on-merge link rules).  
Output: `docs/governance/task-management-workflow.md` and project board configuration checklist.  
Done when: Board is live, templates/labels are applied across repos, and at least one end-to-end issue flow is demonstrated.

### P0-T11: Define AI task-to-code architecture and control model
Owner: Human + Agent  
Type: Governance + architecture  
Dependencies: P0-T10  
Action: Document the baseline automation architecture: dedicated `platform-ai-workers` repo with one shared GitHub poll-loop logic for local and cloud runtimes, Cloud Run Jobs used as bounded wake-up executions, one worker-job deployment per target repo, environment-driven worker configuration (`WORKER_RUNTIME_MODE`, `WORKER_ID`, `TARGET_REPO`, credential refs, limits), local/cloud runtime parity requirement (same worker image and runtime entrypoint in both contexts), and mandatory human review controls (draft PR + required checks/review). Reference `ops/ai-worker-local-cloud-parity.md` for runtime parity contract.  
Output: `docs/automation/ai-task-to-code-architecture.md`.  
Done when: Architecture and control boundaries are approved and referenced by Phase 1/4/5 tasks.

### P0-T12: Define AI task state machine and claim/resume policy
Owner: Human + Agent  
Type: Workflow design  
Dependencies: P0-T11  
Action: Define GitHub issue/PR labels and states for AI execution (`ai:ready`, `ai:in-progress`, `ai:ready-for-review`, `ai:rework-requested`, `ai:failed`, `worker:<id>`), claim rules, retry/resume behavior, review-comment-driven rework transitions, and pending-review cap policy.  
Output: `docs/automation/ai-task-state-machine.md`.  
Done when: State transitions are deterministic and testable with one worker lane.

### P0-T13: Define AI worker credential and secret model
Owner: Human + Agent  
Type: Security design  
Dependencies: P0-T11  
Action: Define GitHub credential strategy (GitHub App preferred), least-privilege scopes, GSM secret layout, runtime injection model for Cloud Run Jobs, and authorization model for on-demand job execution from GitHub Actions (WIF principal + minimal run permissions).  
Output: `docs/security/ai-worker-credentials.md`.  
Done when: Credential model supports per-target-repo worker deployments without static keys in git.

### P0-T14: Define AI rework trigger protocol
Owner: Human + Agent  
Type: Workflow design  
Dependencies: P0-T11, P0-T12  
Action: Define the event trigger contract for rework (for example PR review `changes requested`, or maintainer command comment like `/ai rework`), dedup/idempotency key strategy (review/comment id), and rules for updating the same draft PR branch instead of opening a new PR. Use `ops/ai-comment-trigger-cloud-run-jobs.md` as the baseline implementation reference in this planning repo.  
Output: `docs/automation/ai-rework-trigger-protocol.md` and `ops/ai-comment-trigger-cloud-run-jobs.md`.  
Done when: Rework trigger and PR update behavior are explicit, automatable, and auditable.

### P0-T15: Sign-off phase gate
Owner: Human  
Type: Approval  
Dependencies: P0-T00, P0-T01, P0-T02, P0-T03A, P0-T03B, P0-T03C, P0-T03D, P0-T03E, P0-T03F, P0-T03G, P0-T04, P0-T05, P0-T06, P0-T07, P0-T08, P0-T09, P0-T10, P0-T11, P0-T12, P0-T13, P0-T14  
Action: Review phase artifacts and approve transition to Phase 1.  
Output: Phase 0 sign-off note in `docs/phase-gates/phase-0-signoff.md`.  
Done when: Sign-off completed with approver names and date.

## Artifacts Checklist
- `docs/adr/README.md`
- `docs/adr/adr-template.md`
- `docs/adr/decision-matrix.md`
- `docs/governance/repository-bootstrap-evidence.md`
- `docs/governance/provider-account-inventory.md`
- `docs/governance/repo-ownership.md`
- `docs/standards/environment-and-region.md`
- `docs/standards/naming-and-labeling.md`
- `docs/standards/git-and-release-policy.md`
- `docs/security/access-model.md`
- `docs/standards/deferred-queue-policy.md`
- `docs/governance/task-management-workflow.md`
- `docs/automation/ai-task-to-code-architecture.md`
- `docs/automation/ai-task-state-machine.md`
- `docs/automation/ai-rework-trigger-protocol.md`
- `ops/ai-comment-trigger-cloud-run-jobs.md`
- `ops/ai-worker-local-cloud-parity.md`
- `ops/api-runtime-paths-cloud-run-gke.md`
- `docs/security/ai-worker-credentials.md`
- `docs/phase-gates/phase-0-signoff.md`
