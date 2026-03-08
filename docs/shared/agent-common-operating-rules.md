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

## Git and PR Flow

- Do not push directly to `main`.
- Create or use a short-lived task branch.
- Commit only after validation passes.
- Push with `git push`.
- Use `gh` to create or update a draft PR.
- Do not merge the PR.

## Clean Tree Rule

- Leave the repository worktree clean when finished.
- Remove temporary files and generated scratch artifacts unless they are intended outputs.
- Do not leave behind abandoned local branches.

## Instruction Priority

- Repo-local instructions override this file.
- Task-specific instructions override generic repo instructions.
- If local repo docs conflict with shared planning docs, prefer the repo-local docs for code execution and the planning docs for platform direction.
