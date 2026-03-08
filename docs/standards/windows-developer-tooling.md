# Windows Developer Tooling Standard

This standard defines the supported Windows workstation tooling baseline for this platform.

## Goal

Avoid shell and tool drift that causes repo bootstrap, validation, and automation behavior to differ across machines.

## Supported Baseline

Required:

- Git for Windows with `bash.exe` available on `PATH`
- GNU Make with POSIX shell compatibility
- Python with `python` resolving to the real interpreter
- `gh`
- Docker Desktop or equivalent Docker engine

Required for cloud/deployment workflows:

- `gcloud`

Strongly recommended:

- `mise`
- `rg`

## Explicitly Unsupported

- `GnuWin32` `make`
- Windows Store `python` aliases that do not resolve to a real Python install

## Supported Make Implementations

Use one of:

- `ezwinports.make`
- MSYS2 `make`
- other GNU Make builds that work with Git Bash

Do not use `GnuWin32` `make` for this workspace.

## PATH Expectations

The shell should resolve:

- `bash`
- `make`
- `python`
- `gh`
- `docker`

and, when installed:

- `gcloud`
- `rg`
- `go`
- `node`
- `npm`
- `terraform`
- `buf`

## Verification

Use `scripts/windows-tooling-doctor.ps1` from `platform-blueprint-specs` to check the workstation baseline.
