# Code Documentation Standard

This standard defines how code should be documented across the platform blueprint repositories.

## Goals

- Keep code understandable without forcing readers to reverse-engineer intent.
- Document contracts, constraints, and non-obvious behavior.
- Avoid noisy comments that restate what the code already says.
- Keep documentation close to the code when it affects usage, behavior, or maintenance.

## Default Rule

Document why, constraints, and behavior. Do not document obvious mechanics.

Good documentation explains:

- why a component exists
- what contract it exposes
- important side effects
- invariants and assumptions
- concurrency or lifecycle expectations
- failure modes and error behavior
- integration boundaries with other parts of the system

Bad documentation only restates the code line-by-line.

## Repository-Level Documentation

Every code repository should keep:

- `README.md` for setup, bootstrap, run, validation, and local workflow
- targeted docs under `docs/` for runtime, architecture, or operational topics that are too large for inline comments
- `AGENTS.md` for agent-specific loading guidance, not for human runtime documentation

Use repo docs for:

- local development workflow
- deployment/runtime behavior
- architecture overviews
- cross-package/module interactions
- operational procedures and troubleshooting

Do not hide critical runtime expectations only in code comments if they affect how a developer runs or changes the service.

## Package and Module Documentation

Document packages, modules, or directories when their purpose is not obvious from the name alone.

Examples:

- Go package comment when the package owns a specific boundary such as config loading, auth middleware, persistence, or observability initialization
- directory-level README when a folder contains generators, templates, migrations, or deployment assets with specific usage rules

Package/module docs should explain:

- responsibility and boundary
- what should and should not live there
- important dependencies
- lifecycle or initialization expectations if relevant

## Type and Function Documentation

### Required

Document:

- exported Go types, interfaces, functions, methods, constants, and variables when they form part of a public package contract
- non-obvious internal functions that encode business rules, lifecycle sequencing, locking, retries, or protocol handling
- any function or method whose caller must understand side effects, mutation, ordering, timeouts, retries, or error semantics

### Not Required

Do not document:

- trivial getters/setters
- obvious data mapping code
- simple wrappers unless they hide important behavior
- short helper functions whose behavior is fully clear from name and body

## Comment Content Rules

Inline comments should be short and specific.

Use comments for:

- non-obvious control flow
- invariants
- race/concurrency constraints
- protocol or wire-format assumptions
- security-sensitive behavior
- temporary workarounds with a clear reason

Avoid comments like:

- `// increment i`
- `// call the function`
- `// assign value`

Prefer comments like:

- `// Reuse the worker clone and hard-reset it between tasks to keep branch state deterministic.`
- `// Push success is the effective lock-acquisition decision; the remote read is advisory only.`

## API and Contract Documentation

For API, protobuf, and config contracts, comments are part of the interface.

Document:

- protobuf services and RPC intent
- protobuf field behavior when semantics are not obvious
- deprecation or compatibility expectations
- environment variables that are required, optional, or mutually dependent
- error responses and auth expectations when they are part of a handler contract

For protobuf specifically:

- document field behavior, not just label names
- explain defaults or omitted-field behavior when it matters
- document identifiers, timestamps, enums, and lifecycle fields consistently

## Error, Retry, and Concurrency Behavior

Code that deals with retries, distributed coordination, background execution, or state machines must document:

- what is retried and what is not
- what makes an operation idempotent
- ownership or lock-acquisition rules
- resume/recovery assumptions
- timeout behavior

This is required for worker runtimes, deployment automation, and background processing code.

## Generated Code

Do not hand-document generated files unless the generator requires it.

Instead:

- document the source files or generation templates
- document generation commands and ownership in repo docs
- add clear markers when a file is generated and should not be edited manually

## TODO and FIXME Usage

Use `TODO` or `FIXME` only when the note is actionable.

Every such note should include:

- what is missing or wrong
- why it is deferred
- ideally a task, phase, or issue reference

Bad:

- `TODO: improve this`

Good:

- `TODO(P2-T13): switch direct exporter wiring to the shared observability package once Phase 2 baseline is merged.`

## Documentation Placement Rules

Choose the smallest durable location that matches the scope:

- inline comment: one local non-obvious behavior
- doc comment: exported symbol or reusable internal contract
- package/module doc: boundary or subsystem purpose
- repo `docs/`: architecture, runtime, or operational guidance
- planning repo standard/ADR: cross-repo policy or platform-level decision

Do not duplicate the same explanation in all layers unless each copy is needed for a different audience.

## Maintenance Rule

Code documentation is part of the implementation and must be updated in the same change that alters behavior.

A change is incomplete if it:

- changes a public contract but leaves stale docs/comments
- changes runtime behavior but leaves runbook/README instructions stale
- changes worker or deployment logic but leaves architecture notes inaccurate

## Language-Specific Baselines

### Go

- exported identifiers should use proper doc comments when they are part of a package contract
- package comments are expected for packages with non-trivial responsibility
- comments should explain behavior, lifecycle, and error semantics, not syntax

### TypeScript / Frontend

- document exported utilities, hooks, or modules when usage or constraints are not obvious
- prefer module-level comments for state, caching, auth, or API-consumption rules
- do not add JSDoc to every component by default; use it when public usage or non-obvious props/contracts need explanation

### Terraform / Infrastructure

- prefer descriptive variable/output names first
- document variables and outputs when behavior, ownership, or environment coupling is not obvious
- keep operational behavior in repo docs and runbooks, not buried only in HCL comments

## Documentation Tooling

Use the language-native documentation style first. Generate browsable documentation only when the repo has enough public surface to justify it.

### Go

- use native Go doc comments for packages and exported identifiers
- keep source comments as the primary documentation source
- optional later exposure:
  - `pkgsite` / `godoc` style generated API docs when a Go module has enough reusable public API to browse
- do not introduce a separate generated Go docs site in baseline phases unless there is a clear consumer need

### TypeScript

- use JSDoc/TSDoc selectively for exported modules, hooks, utilities, and non-obvious public contracts
- keep source comments as the primary documentation source
- optional later exposure:
  - TypeDoc for packages that become large enough or public enough to justify generated API docs
- do not require JSDoc on every function or component

### Protobuf

- document services, RPCs, messages, enums, and fields directly in `.proto` comments
- treat schema comments as part of the contract
- optional later exposure:
  - generated protobuf reference docs if the contract surface grows enough to justify a browsable schema reference

### Human-Facing Docs

- use `README.md` and repo-local `docs/` for setup, runtime, architecture, and operational guidance
- use `platform-blueprint-specs` for cross-repo standards, ADRs, and shared platform documentation
- add a separate docs site generator only when the amount of human-facing documentation becomes hard to navigate in-repo

## Review Rule

During review, documentation should be evaluated as part of code quality.

Reviewers should ask:

- does this change introduce non-obvious behavior without explanation?
- are public contracts documented enough for the next maintainer?
- are repo/runtime docs still accurate?
- are comments concise and durable, or are they noisy and likely to rot?
