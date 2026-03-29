# Environment Variable Strategy

This document keeps the platform-level policy summary for environment-variable contracts.

For the operational workflow agents should follow, use:
- `platform-env-contracts` at `../../.codex/skills/platform-env-contracts/SKILL.md`

## Policy Summary

- Repo-local `.env.example` files are the source of truth for concrete variable lists.
- Commit `.env.example`; do not commit `.env` or `.env.local`.
- Shared service variables use all-caps snake case.
- Frontend browser-exposed variables use the `VITE_*` prefix.
- Secrets must stay as placeholders in committed examples.
- Required runtime variables should become typed startup validation once the service is runnable.

