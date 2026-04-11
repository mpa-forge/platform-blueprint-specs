# Grafana Alert Routing Bootstrap Runbook

## Purpose

Define the temporary Phase 3 procedure for wiring Grafana Cloud alert rules,
contact points, and routing policy before `platform-infra` Phase 5 owns
authoritative provisioning.

This runbook keeps the shared severity policy in one place while letting each
service own its own alert expressions in repo-local source control.

## Current Boundary

- Service-owned in each implementation repo:
  - alert expressions
  - thresholds
  - service runbooks
  - synthetic trigger notes
- Shared in this planning repo:
  - contact-point expectations
  - severity routing policy
  - acknowledgement and escalation behavior
  - bootstrap validation checklist
- Deferred to Phase 5 and Phase 8:
  - authoritative Terraform provisioning in `platform-infra`
  - incident.io incident creation and service-catalog routing

## Source Artifacts

Current Phase 3 alert sources:

- `../backend-api/docs/grafana-alert-rules.phase3.yaml`
- `../backend-api/docs/api-alerting.md`
- `../platform-infra/docs/grafana-dashboards/api-golden-signals.json`
- `../platform-infra/docs/grafana-dashboards/runtime-path-status.json`
- `../platform-infra/docs/grafana-dashboards/db-connectivity-symptoms.json`
- `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md`
- `../platform-blueprint-specs/common/standards/access-model.md`

## Contact Points

Phase 3 bootstrap should create or confirm these logical destinations:

- `platform-slack-baseline`
  - primary human notification channel
  - receive `P1`, `P2`, `P3`, and `P4`
- `platform-alert-ai-webhook`
  - Grafana webhook destination that targets the internal alert-to-AI service
  - follow `../platform-ai-workers/docs/automation/alert-ai-webhook-spec.md`
- `platform-page-webhook`
  - immediate operator page or equivalent urgent webhook path
  - used only for `P1` immediately and escalated `P2`

Token and secret rule:

- do not store Slack webhook URLs, webhook signing secrets, or provider tokens
  in git or in these docs

Ownership rule:

- `MiquelPiza` is the current `observability-admin` and `oncall-responder`
  baseline owner per `common/standards/access-model.md`

## Label Contract

Every Phase 3 alert rule should carry, at minimum:

- `service`
- `severity`
- `signal`
- `deployment_environment`
- `routing_profile`

Recommended optional labels:

- `dashboard_uid`
- `runbook_ref`
- `team`

Keep label names stable across services so the later Terraform path can route by
labels instead of hard-coded rule IDs.

## Routing Policy

Phase 3 routing uses two shared profiles:

- `phase3-p1-immediate`
  - send immediately to `platform-slack-baseline`
  - send immediately to `platform-alert-ai-webhook`
  - send immediately to `platform-page-webhook`
- `phase3-p2-notify-then-page`
  - send immediately to `platform-slack-baseline`
  - send immediately to `platform-alert-ai-webhook`
  - if still unacknowledged after `15m`, duplicate to
    `platform-page-webhook`

Severity mapping for this phase:

- `P1` uses `phase3-p1-immediate`
- `P2` uses `phase3-p2-notify-then-page`
- `P3` and `P4` are notify-only and should route to Slack plus the AI webhook
  without paging

Phase 3 note:

- the platform specification reserves incident auto-open semantics for later
  phases when incident.io is active. During Phase 3, the practical equivalent of
  a `P2` escalation is an urgent page or webhook duplicate, not an incident.io
  record.

## Bootstrap Procedure

1. Confirm the service-owned alert manifest is current and still matches the
   source-controlled dashboard query contract.
2. Confirm the target environment is `rc` unless a later rollout explicitly
   activates `prod`.
3. Create or verify the three contact points in Grafana Cloud.
4. Create the routing tree that maps `routing_profile` and `severity` labels to
   the destinations defined above.
5. Create the service alert rules in Grafana Cloud from the repo-local manifest.
6. Trigger the documented synthetic test for each alert family.
7. Confirm:
   - the alert fired in Grafana Cloud
   - Slack received the notification
   - the alert-to-AI webhook accepted the payload
   - `P1` paged immediately
   - `P2` stayed notify-only until the `15m` escalation point
8. Record evidence with:
   - the alert rule names and Grafana UIDs
   - contact points used
   - validation date
   - synthetic trigger method
   - any caveats still deferred to Phase 5 or Phase 8

## Refresh Rules

When a service changes alert logic before Phase 5:

- update the service-owned manifest first
- reapply the corresponding Grafana rule
- keep routing labels stable unless the shared policy itself changed
- backport any emergency UI-only edit to source control immediately

## Handoff

This runbook is temporary. Phase 5 should replace the bootstrap-only path with
authoritative provisioning that:

- creates contact points from source control
- provisions notification policies from source control
- provisions alert rules from source control
- rebuilds the alert stack after clean-state apply or drift

Phase 8 should extend the same label and severity model into incident.io
without changing the service-owned rule intent.
