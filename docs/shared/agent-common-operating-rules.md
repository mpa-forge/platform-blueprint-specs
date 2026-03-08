# Agent Common Operating Rules

This file is shared by all working repositories in the platform blueprint workspace.

## Scope

- Use the checked-out repository as the source of truth for code, commands, and validation.
- Keep changes scoped to the assigned task.
- Prefer repo-local entrypoints over ad hoc commands.

## Validation

- Run the strongest repo-local validation entrypoints that exist for the change.
- Default order when available:
  - `make lint`
  - `make test`
  - `make format-check`
- If formatting is required and the repo exposes a formatter, run it and rerun validation.
- If the repo does not expose one of the commands above, fall back to the documented equivalent in `README.md`.
- If the repo has `.pre-commit-config.yaml` and the change is being made by scripted or autonomous workflow, run pre-commit before committing:
  - prefer `make precommit-run` when available
  - otherwise use `python -m pre_commit run --all-files`

## Documentation Update Rule

- When working in a code repository, update documentation in the same change when behavior, contracts, runtime flow, public interfaces, or operational usage change.
- Do not leave stale comments, README steps, or runtime notes behind after changing the code.
- If the change is too small to justify documentation, that should be because the behavior is already obvious and unchanged, not because documentation was skipped.
- If the change affects other repositories or the platform contract between repositories, also update `platform-blueprint-specs` in the same task.

Cross-repo examples:

- API contract, protobuf, auth, or runtime changes that affect frontend, workers, infra, or AI automation
- generated client/package usage changes
- deployment, observability, or environment model changes that affect more than one repo
- workflow or operational changes that alter how another repo must be built, validated, deployed, or integrated

When cross-repo impact exists, update the smallest durable planning artifact that matches the change:

- standards in `docs/standards/`
- architecture or automation docs in `docs/` or `ops/`
- phase/task files when scope, sequencing, or acceptance criteria change
- `platform-specification.md` when a locked stack or architecture decision changes
- ADRs when the change is a platform-level decision or tradeoff

Do not keep cross-repo behavioral knowledge only in a code repo if other repos depend on it.

## Documentation Summary

Use the lightest documentation layer that matches the scope:

- inline comment: explain non-obvious logic, invariants, locking, retries, side effects, or protocol assumptions
- doc comment: explain exported symbols or reusable internal contracts
- package/module doc: explain responsibility and boundaries when they are not obvious
- repo docs (`README.md`, `docs/`): explain setup, runtime behavior, architecture, and operational workflow
- planning docs/ADRs: explain cross-repo policy and platform decisions

Document:

- why something exists
- important constraints or invariants
- side effects and failure behavior
- concurrency, retry, or lifecycle expectations
- public contract behavior

Do not document:

- obvious mechanics already clear from the code
- line-by-line restatements of implementation
- temporary details that will immediately rot

Language-specific baseline:

- Go: use normal Go doc comments for exported identifiers and meaningful package comments where needed
- TypeScript: use JSDoc/TSDoc selectively for exported or non-obvious public contracts
- Protobuf: document services, RPCs, messages, enums, and fields directly in `.proto` comments

## Git and PR Flow

- Do not push directly to `main`.
- Create or use a short-lived task branch.
- Commit only after validation passes.
- Push with `git push`.
- Use `gh` to create or update a normal PR unless a draft PR is explicitly required by the task.
- Do not merge the PR.

## Post-Merge Cleanup

After squash-merged work:

- switch to `main`
- pull latest `origin/main`
- delete the local feature branch if it still exists
- verify the worktree is clean

## Clean Tree Rule

- Leave the repository worktree clean when finished.
- Remove temporary files and generated scratch artifacts unless they are intended outputs.
- Do not leave behind abandoned local branches.

## Instruction Priority

- Repo-local instructions override this file.
- Task-specific instructions override generic repo instructions.
- If local repo docs conflict with shared planning docs, prefer the repo-local docs for code execution and the planning docs for platform direction.
