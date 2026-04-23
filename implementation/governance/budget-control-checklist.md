# Budget Control Checklist

Use this checklist when a change may affect recurring cloud cost, storage
growth, provider quotas, or always-on runtime spend.

## Artifact And Image Storage

- [ ] Confirm Google Artifact Registry repositories are regional and colocated
  with the runtime region (`us-east4` by default) to avoid avoidable cross-region
  pulls.
- [ ] Deploy images with immutable `sha-<git_sha_12>` tags rather than mutable
  `latest` tags.
- [ ] Keep only the baseline GAR repositories currently needed: `apps`,
  `workers`, and `tools`.
- [ ] Prune untagged GAR artifacts after 7 days in both `rc` and `prod`.
- [ ] Prune old `sha-` tagged GAR images in `rc` after 30 days while keeping
  the 20 most recent SHA-tagged versions.
- [ ] Prune old `sha-` tagged GAR images in `prod` after 90 days while keeping
  the 30 most recent SHA-tagged versions.
- [ ] Avoid copying every `rc` image into `prod`; promote or copy only
  release-approved images when production policy requires it.

## Runtime And Infrastructure

- [ ] Prefer scale-to-zero or min-instance `0` where latency requirements allow.
- [ ] Keep optional GKE resources disabled unless the runtime path explicitly
  needs them.
- [ ] Review Cloud SQL sizing, backup retention, and suspend/resume behavior
  before enabling long-lived environments.
- [ ] Add cleanup or retention policy when creating storage buckets, artifact
  repositories, logs, traces, metrics, exports, or backups.

## Review Prompt

- [ ] If a task creates always-on or accumulating resources, document the
  expected monthly cost driver and the cleanup/retention control in the task,
  PR, or runbook.
