# Git and Release Policy

This document keeps the platform-level policy summary for git flow and release handling.

For the operational workflow agents should follow, use:
- `platform-git-release-workflow` at `../../.codex/skills/platform-git-release-workflow/SKILL.md`

## Policy Summary

- `main` is protected and must not receive direct pushes.
- Every change reaches `main` through a PR with human review and required checks.
- Use short-lived branches.
- Use squash merge on `main`.
- Version each repo independently with SemVer and plain tags in the form `vX.Y.Z`.
- Merge to `main` promotes to `rc`; release tags are the promotion boundary for `prod`.
- Breaking `platform-contracts` changes require a new major contract version rather than in-place breaks.

