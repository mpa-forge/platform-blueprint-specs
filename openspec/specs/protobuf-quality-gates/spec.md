# protobuf-quality-gates Specification

## Purpose
TBD - created by archiving change implement-p4-t03-protobuf-quality-gates. Update Purpose after archive.
## Requirements
### Requirement: Protobuf linting SHALL run as a required CI check
The contracts CI workflow SHALL run `buf lint` for protobuf repositories through
the shared reusable contracts workflow and SHALL fail the pull request when lint
validation fails.

#### Scenario: Buf lint passes
- **WHEN** a pull request updates protobuf contracts and the repository remains
  compliant with the configured Buf lint policy
- **THEN** the reusable contracts workflow reports a successful protobuf lint
  check

#### Scenario: Buf lint fails
- **WHEN** a pull request introduces protobuf content that violates the
  configured Buf lint policy
- **THEN** the reusable contracts workflow reports a failed protobuf lint check
  and blocks merge through required status checks

### Requirement: Breaking-change detection SHALL run against the baseline branch
The contracts CI workflow SHALL run protobuf breaking-change detection against
the configured baseline branch using the repository’s supported breaking-check
helper and SHALL fail the pull request when an incompatible change is detected.

#### Scenario: Backward-compatible change
- **WHEN** a pull request changes protobuf contracts without violating the
  repository breaking-change policy against the baseline branch
- **THEN** the reusable contracts workflow reports a successful protobuf
  breaking check

#### Scenario: Breaking change detected
- **WHEN** a pull request changes protobuf contracts in a way that violates the
  repository breaking-change policy against the baseline branch
- **THEN** the reusable contracts workflow reports a failed protobuf breaking
  check and blocks merge through required status checks

### Requirement: Generated artifacts SHALL remain in sync with committed contracts
The contracts CI workflow SHALL verify that committed generated artifacts remain
in sync with the protobuf source and generation scripts, and SHALL fail when
regeneration would produce uncommitted changes.

#### Scenario: Generated artifacts are current
- **WHEN** a pull request updates contracts or generation tooling and the
  committed generated artifacts already match the regeneration output
- **THEN** the reusable contracts workflow reports a successful generated-code
  drift check

#### Scenario: Generated artifacts are stale
- **WHEN** a pull request changes contracts or generation inputs without
  committing the regenerated artifacts
- **THEN** the reusable contracts workflow reports a failed generated-code drift
  check and instructs contributors to regenerate and commit the outputs

