# Windows Developer Tooling Standard

This document keeps the platform-level Windows workstation baseline.

For the operational workflow agents should follow, use:
- `platform-windows-tooling` at `../../.codex/skills/platform-windows-tooling/SKILL.md`

## Policy Summary

- Supported baseline includes Git for Windows, GNU Make, Python, `gh`, and Docker.
- `gcloud` is required for cloud and deployment workflows.
- `mise` and `rg` are strongly recommended.
- `GnuWin32` `make` and fake Windows Store `python` aliases are unsupported.
- Use `scripts/windows-tooling-doctor.ps1` for repeatable workstation verification.

