# Skill Improvements Backlog

## Purpose

This file collects skill additions and refinements that were identified while
executing blueprint work across the planning repo and sibling implementation
repos.

The goal is to turn repeated friction points into explicit skill guidance so
future runs are faster, safer, and less dependent on ad hoc recovery steps.

## Suggested Improvements

### `platform-blueprint-repo-workflow`

#### 1. Detect placeholder-only infra repos early

When a task asks for infrastructure wiring but `platform-infra` still lacks
real Terraform roots/modules, the skill should explicitly detect that state and
switch the execution plan to:

- implement the code/runtime contract in the consuming repos
- document the delivery model in `platform-infra`
- add placeholders without pretending deployable Terraform already exists
- link the remaining work forward to the Phase 5 Terraform-root task

This would have reduced ambiguity during `P3-T02`.

#### 2. Add post-merge verification for transient GitHub failures

The skill should require a post-merge verification step whenever `gh pr merge`
returns a transient error such as `502 Bad Gateway` or `merge already in
progress`.

Recommended follow-up sequence:

- inspect PR state with `gh pr view --json state,mergedAt,mergeStateStatus`
- fetch `origin/main`
- confirm the merge commit is actually present before deleting local context or
  reporting success

We hit this more than once in `platform-blueprint-specs`.

#### 3. Document stale Git lock recovery

The skill should include a short recovery path for stale `.git/index.lock`
issues after interrupted or concurrent Git operations.

Suggested guidance:

- verify no active Git process is still running
- remove the stale lock file only after that check
- re-run `git switch main` / `git pull --ff-only`
- re-check repo cleanliness before continuing

#### 4. Add cross-repo Go module validation guidance

When one repo consumes a sibling Go module that is being changed in the same
session, the skill should recommend a temporary local `go.work` for validation
instead of committing `replace` directives.

Suggested pattern:

- create temporary `go.work` in the consumer repo
- run validation against the local sibling module
- remove `go.work` before staging/committing
- update the dependency to the pushed module commit before final validation

This made the `platform-observability` -> `backend-api` change safe to verify.

### `platform-validation-workflow`

#### 5. Add planning-repo validation fallback guidance

The planning repo does not use the same validation entrypoints as the code
repos. The skill should explicitly say that for `platform-blueprint-specs`, the
fallback validation path is often:

- `git diff --check`
- targeted markdown validation on touched files only

rather than assuming `make lint` or repo-wide pre-commit hooks exist.

#### 6. Avoid overlapping repo lint and pre-commit runs

The skill should warn against running repo-wide lint and pre-commit in parallel
when both invoke the same underlying tooling, such as `golangci-lint`.

This caused the `parallel golangci-lint is running` failure during `P3-T02`.

#### 7. Handle repo-wide formatter drift without scope creep

The skill should include guidance for narrow tasks in repos that have broader
pre-existing formatting drift.

Suggested rule:

- identify whether formatter failures are inside touched files or outside task
  scope
- if outside scope, validate the changed files directly with the underlying
  formatter/linter
- document the scoped validation honestly instead of turning a focused task
  into repo-wide cleanup

#### 8. Handle generator-versus-formatter conflicts

The skill should explicitly cover repos where generated files are the source of
truth and a repo-wide formatter can fight the generator output.

Suggested rule:

- prefer generation drift checks as the truth source for generated outputs
- exclude generated artifacts from style formatters when appropriate
- document that exclusion in repo tooling rather than formatting generated code
  by hand

### `platform-git-release-workflow`

#### 9. Add PowerShell-safe command guidance

The skill should warn that `&&` is not portable in PowerShell environments used
in this workspace.

Suggested guidance:

- use separate commands or PowerShell-safe sequencing with `;`
- prefer one command per tool invocation when possible
- mention this explicitly in examples for Windows repos

This continues to be an easy footgun when moving quickly.

### `openspec-propose` / `openspec-apply-change`

#### 10. Add first-run repo bootstrap guidance

When OpenSpec is used in a brand-new sibling repo, the skill should explicitly
cover the bootstrap steps that are easy to forget, including:

- `openspec init . --tools codex`
- initial baseline repo files where relevant
- `.gitattributes` / line-ending expectations
- when to commit the first canonical `openspec/specs/...` content

This would help when spinning up new shared repos like
`platform-observability`.

### Potential New Skill: multi-repo mechanical rollout

#### 11. Add a rollout helper for repetitive cross-repo edits

Several tasks required the same small edit pattern across many repos, such as:

- Makefile target rollout
- `AGENTS.md` wording updates
- hook installation updates
- shared skill sync wiring

A dedicated skill or helper script could define:

- repo selection
- expected file targets per repo type
- validation sequence after the rollout
- how to detect and report partial rollout failures

This would make cross-repo mechanical updates less error-prone.

#### 12. Add Windows `gcloud` authentication guidance for Terraform backends

During `P5-T02`, Terraform could use `GOOGLE_OAUTH_ACCESS_TOKEN`, but the
Makefile's bash shell found the Unix-style `gcloud` shim first. That shim failed
because Python was not available in the same shell path, while `gcloud.cmd`
worked correctly.

A Windows tooling or validation skill improvement should document:

- prefer `gcloud.cmd` from bash on Windows when the Cloud SDK Python shim fails
- strip CRLF from `gcloud auth print-access-token` before exporting it
- use ADC for the durable workflow and token fallback only for local convenience

## Suggested Priority

### High

- detect placeholder-only infra repos early
- add post-merge verification for transient GitHub failures
- add cross-repo Go module validation guidance
- add planning-repo validation fallback guidance
- add PowerShell-safe command guidance
- add Windows `gcloud` Terraform backend auth guidance

### Medium

- document stale Git lock recovery
- avoid overlapping repo lint and pre-commit runs
- handle repo-wide formatter drift without scope creep
- handle generator-versus-formatter conflicts
- add first-run repo bootstrap guidance

### Later

- add a dedicated multi-repo mechanical rollout skill/helper
