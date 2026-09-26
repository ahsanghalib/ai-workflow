# Existing Repository Safety

Use this reference for `existing/reconciliation` targets. It supplements the
minimal bootstrap rules with preservation requirements for user-owned projects.

This is a workflow refactor, not a destructive repository migration. The goal
is to stop depending on obsolete ceremony while keeping the repository's
history and useful user-owned material intact.

## Inspect and preserve

- Inspect the exact target and applicable instructions before proposing writes.
- Detect the current project-control and source-of-truth locations.
- Preserve source code, configuration, user-authored documentation, Git
  metadata, symlinks, and useful current conventions.
- Add only missing controls needed by the new workflow; do not churn files just
  to match a bundled template.
- Do not rename or delete legacy documents automatically, or overwrite useful
  documents with boilerplate.
- Never read secret values or `.env` contents.

## Legacy artifacts

If these artifacts exist, stop requiring them for the new workflow:

```text
MASTER_PLAN.md
DB_SCHEMA.md
USER_FLOW.md
PROJECT_ARCHITECTURE.md
docs/plans/
docs/reviews/
```

Do not automatically delete them. Even a clearly generated obsolete artifact
may be migrated or removed only when all of the following are true:

- ownership by this skill system is unambiguous;
- the migration is demonstrably safe; and
- no useful user-authored information will be lost.

If ownership or safety is uncertain, leave the artifact in place and make the
new workflow independent of it. Do not destroy history to make the repository
look cleaner. Backward compatibility means safe handling, not permanent
enforcement of obsolete ceremony.

## Git and external safety

Preserve Git metadata and existing ignore policy. Do not mutate remote,
deployment, or publishing state without explicit authorization. Project-init
does not perform those operations as part of bootstrap or reconciliation.
