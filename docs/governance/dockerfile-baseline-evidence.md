# Dockerfile Baseline Evidence (`P1-T06`)

Last updated: 2026-03-07

## Scope

This document records the container baseline delivered for `P1-T06`.

## Result

Dockerfiles were added for:

- `frontend-web`
- `backend-api`

Each repo now includes:

- `Dockerfile`
- `.dockerignore`
- README container notes

Additional placeholder runtime assets were added to support image builds:

- `frontend-web/public/index.html`
- `backend-api/cmd/api-placeholder/main.go`

## Design notes

- `frontend-web` uses a multi-stage image that copies placeholder static assets into an `nginx` runtime image.
- `backend-api` uses a multi-stage Go build and packages a minimal placeholder HTTP server binary.
- `backend-worker` is intentionally deferred from `P1-T06` because it is not part of the default hybrid frontend/API local stack.

## Validation performed

Validated successfully on this workstation:

- `docker build -t frontend-web:p1-t06 .` in `frontend-web`
- `docker build -t backend-api:p1-t06 .` in `backend-api`

## Merge evidence

| Repo | PR | Merged at | Merge commit |
| --- | --- | --- | --- |
| `frontend-web` | `https://github.com/mpa-forge/frontend-web/pull/9` | `2026-03-07T15:02:47Z` | `332dce1bee939480dde39770be503a9724a8d4da` |
| `backend-api` | `https://github.com/mpa-forge/backend-api/pull/11` | `2026-03-07T15:02:54Z` | `06ff83a62f68ae87f17aad0190e6c6537869b8cc` |
