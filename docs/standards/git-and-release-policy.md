# Git and Release Policy

## Purpose
Define the baseline git workflow, merge controls, and release/versioning policy for all repositories.

## Branch Model
- Trunk-based development.
- Protected branch: `main` only.
- Working branches are short-lived:
  - `feat/<short-description>`
  - `fix/<short-description>`
  - `chore/<short-description>`
  - `hotfix/<short-description>`

## Pull Request Policy
- Direct pushes to `main` are not allowed.
- Every change reaches `main` through a PR.
- PR must be reviewed and approved by a human.
- Self-approval is allowed in the current single-maintainer operating model.

## Required PR Checks
Baseline required checks before merge:
- lint
- tests
- code quality gates
- security/secret scans
- contract checks where applicable (for example `buf lint`, `buf breaking`, generated-code drift)

## Merge Strategy
- `Squash merge` only on `main`.

Rationale:
- Keeps `main` history clean and auditable (one commit per PR).
- Works well with AI-generated iterative commit sequences.
- Simplifies rollback by PR unit.

## Versioning Policy
- Versioning scope: independent per repository.
- Versioning scheme: Semantic Versioning (`MAJOR.MINOR.PATCH`).
- Git tags: plain format `vX.Y.Z` (no repo prefix).

SemVer interpretation:
- `PATCH`: fixes/internal changes with no contract break.
- `MINOR`: backward-compatible additive behavior.
- `MAJOR`: breaking behavior or contract changes.

## Release Promotion Model
- Merge to `main` auto-deploys to `rc`.
- Promotion to `prod` is tag-driven:
  - create release tag `vX.Y.Z`
  - run prod promotion workflow with required approvals and smoke gates

## Hotfix Policy
- Use `hotfix/*` branch for urgent production fixes.
- Hotfix still requires PR + required checks + human approval.
- On merge, release a new patch tag and promote through standard prod gates.

## Changelog Policy
- Changelog is auto-generated from merged PR metadata (labels/titles/commits) during release.
- Manual edits are allowed only for critical clarifications.

## Contract Compatibility Policy (`platform-contracts`)
- CI gates are mandatory:
  - `buf lint`
  - `buf breaking`
- Breaking changes are not allowed in place:
  - create a new major contract namespace/package version (for example `v1` -> `v2`)
- Additive backward-compatible changes are allowed in current major.
- Generated TypeScript package version must match contract release tag (`vX.Y.Z`).
- Consumer repositories pin explicit package versions and upgrade through PR.

## Governance Note
Any change to this policy requires an ADR update before enforcement changes are applied in GitHub settings and CI.
