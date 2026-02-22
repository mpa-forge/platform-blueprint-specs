# Phase 0 Tasks: Foundation & Decisions

## Goal
Lock all foundational platform decisions, accounts, access, and governance needed to start implementation with low rework risk.

## Tasks

### P0-T01: Create decision register and ADR template
Owner: Agent  
Type: Documentation  
Dependencies: None  
Action: Create `docs/adr/README.md` and `docs/adr/adr-template.md` in the dedicated docs repository.  
Output: ADR structure committed.  
Done when: Team can add dated decision records with context/options/consequences.

### P0-T02: Define and document repository ownership model
Owner: Human  
Type: Governance  
Dependencies: P0-T01  
Action: Assign maintainers for each repo (`frontend-web`, `backend-api`, `backend-worker`, `platform-contracts`, `platform-infra`, dedicated docs repo) and fallback reviewers.  
Output: `docs/governance/repo-ownership.md`.  
Done when: Every repo has at least 2 responsible maintainers.

### P0-T03: Create or confirm cloud/account tenants
Owner: Human  
Type: Account setup  
Dependencies: None  
Action: Ensure availability of GCP project(s), Auth0 tenant, Grafana Cloud stack, Sentry org/project, incident.io workspace, and GitHub org under a single ownership model.  
Output: Account inventory with owner and billing account mappings.  
Done when: All required providers are accessible by the core team.

### P0-T04: Define environment naming and region baseline
Owner: Human  
Type: Decision  
Dependencies: P0-T03  
Action: Confirm environment model (`local`, `rc`, `prod`), lock primary region to `us-east4` for `rc` and `prod`, and document prod full separation plus RC isolation boundaries (namespace, DB boundary, secret scope, domain).  
Output: `docs/standards/environment-and-region.md`.  
Done when: Names/regions are fixed and reused consistently in infra and CI.

### P0-T05: Define naming/tagging conventions
Owner: Agent  
Type: Documentation  
Dependencies: P0-T04  
Action: Document naming conventions for repos, GAR images, Terraform resources, k8s namespaces, labels, and tags.  
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
Dependencies: P0-T03  
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
Action: Document the baseline automation architecture: dedicated `platform-ai-workers` repo, scheduled Cloud Run Jobs, one worker-job deployment per target repo, environment-driven worker configuration (`WORKER_ID`, `TARGET_REPO`, credential refs, limits), and mandatory human review controls (draft PR + required checks/review).  
Output: `docs/automation/ai-task-to-code-architecture.md`.  
Done when: Architecture and control boundaries are approved and referenced by Phase 1/4/5 tasks.

### P0-T12: Define AI task state machine and claim/resume policy
Owner: Human + Agent  
Type: Workflow design  
Dependencies: P0-T11  
Action: Define GitHub issue labels/states for AI execution (`ai:ready`, `ai:in-progress`, `ai:ready-for-review`, `ai:failed`, `worker:<id>`), claim rules, retry/resume behavior, and pending-review cap policy.  
Output: `docs/automation/ai-task-state-machine.md`.  
Done when: State transitions are deterministic and testable with one worker lane.

### P0-T13: Define AI worker credential and secret model
Owner: Human + Agent  
Type: Security design  
Dependencies: P0-T11  
Action: Define GitHub credential strategy (GitHub App preferred), least-privilege scopes, GSM secret layout, and runtime injection model for Cloud Run Jobs.  
Output: `docs/security/ai-worker-credentials.md`.  
Done when: Credential model supports per-target-repo worker deployments without static keys in git.

### P0-T14: Sign-off phase gate
Owner: Human  
Type: Approval  
Dependencies: P0-T01..P0-T13  
Action: Review phase artifacts and approve transition to Phase 1.  
Output: Phase 0 sign-off note in `docs/phase-gates/phase-0-signoff.md`.  
Done when: Sign-off completed with approver names and date.

## Artifacts Checklist
- `docs/adr/README.md`
- `docs/adr/adr-template.md`
- `docs/adr/decision-matrix.md`
- `docs/governance/repo-ownership.md`
- `docs/standards/environment-and-region.md`
- `docs/standards/naming-and-labeling.md`
- `docs/standards/git-and-release-policy.md`
- `docs/security/access-model.md`
- `docs/standards/deferred-queue-policy.md`
- `docs/governance/task-management-workflow.md`
- `docs/automation/ai-task-to-code-architecture.md`
- `docs/automation/ai-task-state-machine.md`
- `docs/security/ai-worker-credentials.md`
- `docs/phase-gates/phase-0-signoff.md`
