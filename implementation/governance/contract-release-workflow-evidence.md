# Contract Release Workflow Evidence (`P2-T11`)

## Summary

`platform-contracts` now documents the release boundary, versioning policy,
TypeScript package publish contract, and consumer pinning model required for
released contract artifacts.

Merged PR:

- `https://github.com/mpa-forge/platform-contracts/pull/24`

Representative merged commit:

- `f3933b7` `docs: define contract release workflow`

## Implemented

Repository: `platform-contracts`

Added or updated:

- `README.md`
- `docs/contract-release-workflow.md`
- `docs/contract-release-checklist.md`
- `docs/typescript-client-usage.md`
- `docs/go-server-usage.md`
- `packages/typescript-client/README.md`

## Release Contract

The documented release baseline now defines:

- `contracts-vX.Y.Z` as the canonical contract release tag format
- semantic version rules for patch, minor, and major contract releases
- `@mpa-forge/platform-contracts-client` as the TypeScript package name
- `npm.pkg.github.com` as the TypeScript package publish target
- a strict rule that package version `X.Y.Z` matches tag version
  `contracts-vX.Y.Z`
- released-version pinning expectations for both TypeScript and Go consumers

## Publish And Consumption Guidance

The release docs now give maintainers and consumers a repeatable baseline for:

- pre-release validation and generation-drift checks
- documentation and package metadata review before release
- GitHub Packages auth bootstrap without committing registry credentials
- installing explicit released package versions instead of following floating
  mainline artifacts
- treating Go contract upgrades as deliberate released-version changes

This closes the Phase 2 documentation/setup gap even though the first tagged
contract release and later automation remain separate follow-on work.

## Outcome

- `P2-T11`: Completed (`2026-03-31`)
- `platform-contracts` now has the documented versioning policy and release
  checklist required before `P2-T12` and later release automation work
