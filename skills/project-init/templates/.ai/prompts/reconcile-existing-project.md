<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Reconcile an Existing Project

Use the `project-init` skill for an existing or non-empty target.

1. Resolve the exact target and inspect safe project evidence only.
2. Preserve the existing planning and architecture source of truth.
3. Classify each document as keep, create, revise, preserve, or conflict.
4. Propose missing documents and per-file revisions separately.
5. Never read `.env` or secret contents, overwrite existing files, or run Git
   mutations before the relevant approval.

Enumerate all instruction, planning, architecture, user-flow, schema, and
repository candidates first. Preserve established names and locations; if
there are multiple plausible sources or generated files, report the conflict
and generator ownership instead of creating a second source of truth.

For missing Markdown, populate only confirmed safe evidence, label inferred,
recommended, assumed, and unknown details separately, and show the
evidence-to-field mapping before creation. Do not infer business rules,
authorization, schema constraints, API contracts, deployment, or secrets from
filenames or framework conventions.

Produce a per-file proposal with `keep unchanged`, `create missing`, `revise
after approval`, `preserve`, or `conflict` actions. Include evidence, source of
truth, compatibility impact, approval scope, validation, unresolved decisions,
and the next review action before writing.

Request separate approval for every existing-file revision, including
`AGENTS.md`, README, master plan, architecture, user flow, schema, rules,
plans, indexes, `.gitignore`, and equivalent source-of-truth files. Show each
exact diff and compatibility impact; a missing-file approval does not cover a
revision.

If Git is absent, propose local `git init` separately for the exact target; if
`.git` exists, preserve it. If `.gitignore` is absent, propose a missing-file
copy; if it exists, preserve it and report recommended additions without
editing. Never bundle a commit, remote, branch, push, or other Git operation.

Use the project-init references for safe inventory, source-of-truth detection,
reconciliation population, and the per-file proposal report. Keep the helper
prompt as a routing aid; it is tracked project documentation, not an automatic
skill or authorization.

Show inferred, recommended, assumed, confirmed, and unknown details separately.
Stop for review before applying the reconciliation. At handoff, report the
target, source-of-truth decision, created/changed/preserved/skipped/blocked
files, assumptions, unresolved decisions, validation commands and results, and
the next exact review action. State that no secret, application code,
dependency, migration, commit, or remote operation was created or changed.
