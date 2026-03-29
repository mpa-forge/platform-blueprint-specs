# Contracts Code Generation Evidence (`P2-T03`)

## Summary

`platform-contracts` now has a reproducible Go and TypeScript generation pipeline
 driven from the committed protobuf contracts.

Merged PR:

- `https://github.com/mpa-forge/platform-contracts/pull/17`

## Implemented

Repository: `platform-contracts`

Added or updated:

- `buf.gen.yaml`
- `Makefile`
- `package.json`
- `package-lock.json`
- `go.mod`
- `go.sum`
- `.github/workflows/contracts-buf-check.yml`
- `scripts/install-codegen-tools.sh`
- `scripts/buf-generate.sh`
- `scripts/go-run.sh`
- `README.md`

Generated Go artifacts:

- `gen/go/blueprint/user/v1/user.pb.go`
- `gen/go/blueprint/user/v1/userv1connect/user.connect.go`

TypeScript client package baseline:

- `packages/typescript-client/package.json`
- `packages/typescript-client/README.md`
- `packages/typescript-client/tsconfig.build.json`
- `packages/typescript-client/src/index.ts`
- `packages/typescript-client/src/gen/blueprint/user/v1/user_pb.ts`
- `packages/typescript-client/src/gen/blueprint/user/v1/user_connect.ts`

## Generation Model

The repository now uses:

- Go plugin binaries installed locally into `.bin/`
- Node plugin binaries from `node_modules/.bin`
- Buf generation driven through wrapper scripts instead of relying on globally
  installed plugin versions

Pinned generator/tool versions:

- `protoc-gen-go` `v1.36.11`
- `protoc-gen-connect-go` `v1.19.1`
- `@bufbuild/protoc-gen-es` `1.10.1`
- `@connectrpc/protoc-gen-connect-es` `1.7.0`

## TypeScript Package Baseline

Package:

- `@mpa-forge/platform-contracts-client`

Prepared metadata includes:

- package name and version
- export entrypoint
- TypeScript build script
- GitHub Packages publish registry
- committed generated source under `src/gen/`

Publishing is still deferred to the later release workflow task.

## Validation

Validated locally on `2026-03-22`:

- `make contracts-check`
  - `buf lint`
  - `buf breaking` helper
  - regenerate code
  - `go mod tidy`
  - zero-drift diff check for generated artifacts
  - `go test ./gen/go/...`
  - `npm run build --workspace @mpa-forge/platform-contracts-client`

## Outcome

- `P2-T03`: Completed (`2026-03-22`)
- Regeneration is reproducible from a clean checkout and generated artifacts are
  committed for both Go and TypeScript consumers.

