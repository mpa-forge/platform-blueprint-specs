# Shared Change Checklist

Use this checklist for changes that touch shared templates, version pins, or multiple repositories.

## Source-of-Truth Rule

Before editing, identify the canonical source for the change:

- repo-local executable truth: files that the repo actually runs (`Makefile`, `Dockerfile`, `.tool-versions`, workflows, code)
- future bootstrap truth: canonical templates under `templates/`
- planning truth: `platform-specification.md`, standards, ADRs, phase/task files
- historical evidence: governance/evidence docs that record what was actually delivered

Do not update only one layer if the change affects several.

## Version Bump Checklist

For version bumps such as Go, Node, Terraform, Buf, or image base tags:

- update live repo pins
- update relevant bootstrap templates
- update planning/spec docs that declare the baseline
- update evidence docs that record the pin
- check whether Dockerfiles or CI workflows also pin the same tool
- note whether local workstation tooling also needs an upgrade

## Shared Template Rollout Checklist

For shared template changes:

- update the canonical template first
- identify all repos that already copied the template
- propagate the change to those repos
- update evidence or rollout docs if the change affects repo bootstrap expectations
- keep local repos clean after merges

## Cross-Repo Behavior Checklist

If a change alters how another repo must build, validate, integrate, or deploy:

- update the affected code repo(s)
- update `platform-blueprint-specs`
- update any shared agent guidance or PR checklist if it changes ongoing workflow

## Merge Cleanup Checklist

After squash-merged rollout work:

- switch to `main`
- pull latest `origin/main`
- remove the local feature branch if it still exists
- verify clean worktree
