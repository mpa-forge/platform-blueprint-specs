# Code Documentation Standard

This document keeps the platform-level policy summary for code documentation.

For the operational workflow agents should follow, use:
- `platform-code-documentation` at `../../.codex/skills/platform-code-documentation/SKILL.md`

## Policy Summary

- Document why, contracts, constraints, and non-obvious behavior.
- Do not document obvious mechanics or restate code line-by-line.
- Update docs and comments in the same change that alters behavior.
- Use the smallest durable layer that matches the scope:
  - inline comments
  - doc comments
  - package or module docs
  - repo docs
  - planning docs or ADRs for cross-repo policy
- Treat API, protobuf, config, retry, concurrency, and lifecycle behavior as contract documentation.

