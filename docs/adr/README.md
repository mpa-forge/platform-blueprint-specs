# Architecture Decision Records (ADRs)

## Purpose
ADRs store important technical and operational decisions with enough context to understand why they were made and how to revisit them later.

## Location and naming

- Store ADR files in `docs/adr/`.
- Use sequential IDs with a short slug:
  - `0001-runtime-cloud-run-first.md`
  - `0002-auth-managed-auth0.md`

## Lifecycle states

- `proposed`: under discussion, not yet enforced.
- `accepted`: approved and active.
- `superseded`: replaced by a newer ADR.
- `deprecated`: no longer recommended for new work.

## Process

1. Copy `docs/adr/adr-template.md` into a new numbered file.
2. Fill context, options, decision, consequences, and rollout notes.
3. Link related specs/tasks/phase files.
4. Review and approve.
5. Update status and keep a changelog section if the ADR evolves.

## Rules

- One ADR per decision topic.
- Keep decision statements explicit and testable.
- Document trade-offs, not only advantages.
- When superseding, link both ADRs in each file.

