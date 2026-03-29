---
name: platform-adr-authoring
description: Create or update Architecture Decision Records for the platform blueprint. Use when a task needs a platform-level decision record, when changing or superseding an ADR, when documenting decision drivers and trade-offs, or when work explicitly references ADR authoring or the ADR template.
---

# Platform ADR Authoring

Use this skill when work requires a new ADR, a meaningful ADR update, or a supersession of an existing ADR.

## Goal

Capture platform-level decisions with enough context, trade-offs, and validation guidance that future work can understand and revisit them.

## Default Workflow

1. Decide whether the change is truly ADR-worthy.
2. Create a new numbered ADR from the bundled template when the decision is new.
3. Update the existing ADR when the decision is evolving but still the same decision topic.
4. Supersede an older ADR when a newer ADR replaces it.
5. Link related tasks, specs, and implementation notes.

## When To Use An ADR

Use an ADR for:

- platform-level architecture decisions
- workflow or governance decisions that affect multiple repos
- infrastructure or runtime-path decisions with meaningful trade-offs
- decisions likely to be revisited later

Do not use an ADR for:

- ordinary implementation details local to one change
- temporary workarounds with no lasting policy impact
- task tracking that belongs in implementation tasks instead

## Location And Naming

- Store ADR files in `docs/adr/`.
- Use sequential IDs with a short slug:
  - `0001-runtime-cloud-run-first.md`
  - `0002-auth-managed-clerk.md`

## Lifecycle States

- `proposed`
- `accepted`
- `superseded`
- `deprecated`

## Authoring Rules

- One ADR per decision topic.
- Keep the decision statement explicit and testable.
- Document trade-offs, not only benefits.
- Include clear revisit triggers.
- When superseding, link both ADRs to each other.

## Template

Use the bundled template:

- `assets/adr-template.md`

Populate at minimum:

- status
- date
- owners and reviewers
- related tasks and docs
- context
- decision drivers
- considered options
- selected decision
- consequences
- rollout or implementation notes
- validation
- revisit triggers

## Review Prompt

Before finalizing an ADR, ask:

- is this decision platform-level enough to justify an ADR?
- are the decision drivers and trade-offs explicit?
- would a future maintainer understand why this option was chosen?
- are the linked tasks and follow-up impacts clear?

