## Context

`P4-T01` created the shared GitHub Actions wiring baseline, but those workflows only prove the toolchain bootstrap path. The Phase 4 follow-up needs real lint and unit-test enforcement for Go and frontend repositories, while keeping the same reusable-workflow and repo-entrypoint structure that the baseline introduced.

The main constraint is repo diversity:

- Go repositories share the same `golangci-lint` and `go test` shape.
- Frontend repositories share the same `eslint` and TypeScript type-check shape, but their unit-test command may be repo-local.
- The planning repo owns the templates; the execution repos are the org workflow host and each working repository.

## Goals / Non-Goals

**Goals:**
- Add deterministic lint and unit-test CI gates to the shared workflow family.
- Keep `ci.yml` as the single repo-local entrypoint in each target repository.
- Preserve the Phase 4 baseline triggers and read-only permissions.
- Keep the Go and frontend workflow families aligned on naming, job shape, and cache use.

**Non-Goals:**
- Contract, image-build, scanning, or deploy jobs.
- Branch-protection updates.
- Reworking the Phase 4 repository map or changing which repos participate.
- Standardizing every frontend repo on a single unit-test command if one is not already shared.

## Decisions

1. **Put the real gates in the reusable workflows, not the repo-local entrypoints.**
   The repo-local `ci.yml` files should remain thin wrappers so the job logic lives once in `org-dot-github`. This reduces drift and keeps the same contract for every consumer.
   Alternatives considered:
   - Duplicate lint/test steps in each repo workflow. Rejected because it creates inconsistent versions and job names.
   - Add a separate workflow file per repo type. Rejected because it fragments the shared baseline and makes later Phase 4 extensions harder to roll out.

2. **Keep lint, type-check, and unit-test as separate jobs.**
   Separate jobs make failures easier to read and let caching or parallel execution improve feedback time. It also aligns with the later branch-protection and performance work in Phase 4.
   Alternatives considered:
   - One combined `quality` job. Rejected because it hides which gate failed and makes reruns less targeted.
   - Fold type-check into lint for frontend repos. Rejected because type-check failures deserve their own check identity.

3. **Pin workflow toolchain versions and rely on the repo's existing dependency cache mechanisms.**
   Version pins keep CI reproducible, and native setup-action caching is enough for this phase. The design avoids introducing a new cache layer or custom bootstrap logic.
   Alternatives considered:
   - Floating tool versions. Rejected because they undermine deterministic CI behavior.
   - Custom cache scripting. Rejected because it adds maintenance cost without clear benefit over setup-action caching.

4. **Keep frontend unit-test execution repo-local.**
   Frontend repos do not yet share one universal test command, so the reusable workflow should invoke the configured test command rather than hard-code a single package manager invocation.
   Alternatives considered:
   - Force a single `bun test` convention now. Rejected because it would overreach the current repo baseline.
   - Omit frontend unit tests entirely. Rejected because the task explicitly requires lint and unit-test coverage.

## Risks / Trade-offs

- [Repo-specific frontend test commands] -> Keep the reusable workflow contract narrow and invoke the repository's configured test command.
- [Longer PR runtime from extra jobs] -> Use caching, separate jobs, and deterministic installs to keep reruns fast.
- [Check-name churn] -> Preserve `ci.yml` as the stable entrypoint and keep job names explicit so later branch-protection work can reference them consistently.
- [Template drift between planning repo and execution repos] -> Roll out the same filenames and job structure to `org-dot-github` and each consumer repo together.

## Migration Plan

1. Update the planning templates under `templates/github-actions/` with the lint and unit-test job shape.
2. Mirror the template changes into `org-dot-github/.github/workflows/` and each target repository's `.github/workflows/ci.yml`.
3. Validate that Go repos fail on lint or unit-test regressions and frontend repos fail on ESLint, type-check, or unit-test regressions.
4. Keep the old baseline behavior available only until the new reusable workflow copies are in place, then retire the temporary bootstrap-only path.

Rollback:
- Revert the reusable workflow template change first if a gate is too strict or a tool version breaks CI.
- Because the repo-local workflows remain thin wrappers, rolling back the shared template restores the prior baseline with minimal file churn.

## Open Questions

- Should frontend unit tests standardize on a single command name in a later task, or remain repo-local indefinitely?
- Do we want job names that exactly match the future branch-protection check list, or should that naming be deferred to the branch-protection task?
