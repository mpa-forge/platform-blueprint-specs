# P1-T09 Local Data Bootstrap Evidence

## Scope

Implemented deterministic local Postgres bootstrap for the Phase 1 compose stack.

## Merged repository

- `platform-infra`
  - PR: `mpa-forge/platform-infra#12`
  - merge commit: `68146cf`

## Delivered artifacts

- Postgres init wiring:
  - `platform-infra/local/compose.yml`
- Postgres baseline schema:
  - `platform-infra/local/postgres-init/001_schema.sql`
- Postgres seed data:
  - `platform-infra/local/postgres-init/002_seed.sql`
- Reset command:
  - `platform-infra/Makefile` -> `make local-db-reset`
- Documentation updates:
  - `platform-infra/README.md`
  - `platform-infra/docs/local-development-stack.md`

## Baseline database content

Schema:

- table: `bootstrap_records`

Seed rows:

- `seed_source=platform-infra/local/postgres-init`
- `stack_version=phase-1`

## Validation performed

Validated successfully on this workstation:

- `docker compose -f local/compose.yml --profile frontend-support --profile api-support down --remove-orphans --volumes`
- `docker compose -f local/compose.yml --profile frontend-support --profile api-support up -d --wait --build --remove-orphans postgres`
- `docker exec platform-blueprint-local-postgres psql -U postgres -d platform_blueprint -c "SELECT record_key, record_value FROM bootstrap_records ORDER BY record_key;"`

Observed query result:

```text
record_key   | record_value
-------------+------------------------------------
seed_source  | platform-infra/local/postgres-init
stack_version| phase-1
```

## Notes

- The init SQL runs only when the Postgres volume is created from scratch.
- `make local-db-reset` exists specifically to remove the local named volume and recreate the seeded baseline deterministically.
