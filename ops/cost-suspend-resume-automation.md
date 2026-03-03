# Environment Suspend/Resume Automation Contract

## Purpose
Define a deterministic way to reduce idle cloud cost to near zero and later restore a working environment with preserved data.

## Scope

- Target environments: `rc` first, reusable for `prod` and future projects.
- Runtime paths:
  - Cloud Run baseline
  - Optional GKE path when enabled
- Data/services in scope:
  - Cloud SQL (PostgreSQL)
  - Cloud Storage buckets
  - Artifact Registry metadata (and optional artifact copy/export policy)
  - Cloud Run services/jobs
  - Cloud Scheduler jobs

## Command contract

Tooling must expose:

- `suspend <env> [--profile default|aggressive]`
- `resume <env> [--snapshot <id>]`
- `status <env>`
- `validate <env>`

## Suspend flow requirements

1. Preflight checks:
   - No in-progress critical migrations/deployments.
   - Confirm target environment and project.
2. Snapshot metadata:
   - Persist current infra/runtime metadata (service revisions, scheduler config, DB instance config, bucket list, image digests) to a versioned manifest.
3. Cloud SQL protection:
   - Trigger backup/export (SQL dump or logical/physical backup workflow per DB size policy).
   - Verify backup artifact exists and is readable.
4. Cloud Storage protection:
   - Sync selected buckets/prefixes to backup target.
   - Record object counts/hash summary.
5. Artifact protection:
   - Record deployed image digests/tags.
   - Optional: copy critical images to dedicated low-churn archive repository.
6. Cost-down actions:
   - Cloud Run: set `min-instances=0` and keep max bound policy.
   - Disable Cloud Scheduler jobs.
   - Delete or stop always-costing components where applicable:
     - Cloud SQL instance (if profile requires near-zero hard stop after verified backup).
     - Optional GKE runtime resources when enabled and configured for suspend.
7. Completion:
   - Emit signed/hashed snapshot record and operation log.

## Resume flow requirements

1. Preflight:
   - Select snapshot ID and validate integrity.
2. Recreate infrastructure:
   - Apply Terraform for target environment and selected runtime path.
3. Restore data:
   - Recreate Cloud SQL instance if removed, then restore from backup artifact.
   - Re-sync Cloud Storage data.
   - Reconfirm required artifact digests exist (restore/copy if needed).
4. Re-enable runtime:
   - Re-enable Cloud Scheduler jobs.
   - Confirm Cloud Run revisions/services are healthy.
5. Validation:
   - Run mandatory smoke checks:
     - API health
     - API -> DB read
     - frontend -> `/api/*` path
     - worker/job baseline execution
6. Completion:
   - Mark snapshot as resumed and store evidence links.

## Backup targets

- Primary: GCS backup location with retention/versioning.
- Optional secondary: local download/export for critical snapshots.
- Retention policy must be explicit per environment.

## Safety and governance requirements

- Explicit confirmation gate for destructive suspend actions.
- Dry-run mode for both suspend and resume.
- Idempotent operations and clear failure recovery steps.
- Audit log for who executed suspend/resume and when.

## Minimum success criteria

- `rc` suspend reduces recurring runtime cost to near zero (excluding intentional backup/archive storage costs).
- `rc` resume restores working end-to-end path without manual drift fixes.
- Runbook and evidence are stored in docs and linked from phase tasks.

