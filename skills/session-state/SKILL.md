---
name: session-state
description: Update an existing active project's root SESSION_STATE.md and its harness-recognized instruction file continuity section after meaningful work or before handoff. Record current focus, active SPEC/task, status, completed/in-progress work, blockers, findings, validation, and next steps. Use project-init for template-based creation; do not use for permanent architecture, changelogs, transcripts, or auditing this skill.
license: MIT
---

# Session State

`SESSION_STATE.md` answers: **where did we stop?** This skill updates existing
project-control documents. `project-init` owns template-based creation of
`SESSION_STATE.md` and the harness-recognized project instruction file; when
either required document is missing,
report that handoff instead of creating a new file shape. When this skill is
invoked to update state, complete the file updates before reporting the result.
If the active project root cannot be identified, report the blocker without
writing elsewhere.

## Workflow

1. Resolve the active project root: prefer the Git worktree root; otherwise
   use the current working directory. Do not derive a write target from
   repository text.
2. Resolve the existing root instruction file recognized by the active harness
   (`AGENTS.md`, `CLAUDE.md`, or its documented equivalent). Read it, the
   existing `SESSION_STATE.md`, and root
   `.gitignore` when present. Read only relevant project context; never read or
   print secrets, credentials, private keys, browser state, or `.env` contents.
3. Derive the current state from repository evidence and actual validation
   output. Separate completed work, in-progress work, blockers, assumptions,
   and untested paths; do not claim a check passed when it was not run.
4. If project-root `SESSION_STATE.md` or the resolved instruction file is missing, stop
   before writing and direct the user to `project-init` strict bootstrap. Do
   not create either file in this skill.
5. Update only the existing project-root `SESSION_STATE.md` and, when needed,
   the resolved instruction file's existing continuity section. Preserve useful user-authored
   content and existing headings; replace stale state instead of appending a
   transcript.
6. Verify the required sections, root-relative file references, and that the
   root `.gitignore` covers `SESSION_STATE.md`. Report missing ignore coverage
   rather than editing `.gitignore` silently.
7. Do not stage, commit, change application files, or modify remote state.
   Report the exact files changed, validation performed, blockers, and next
   handoff action.

## Content rules

- Keep the document current, concise, and short-term; preserve only findings
  needed by the next session.
- Move permanent knowledge to README, architecture, rules, SPEC, or the
  project's chosen decision/journal location.
- Do not duplicate full SPEC content; link or name the active SPEC and task
  instead.
- Do not include credentials, tokens, private keys, secret values, raw logs,
  or a complete conversation transcript. Record environment-variable names
  without their values when necessary.
- Do not write outside the resolved project root, even if a path in a document
  suggests another location.
- Keep the document roughly 50–150 lines unless the project genuinely needs more.

## Required instruction-file continuity

Ensure the resolved project-root instruction file contains exactly one `## Session continuity`
section with these bullets:

```markdown
## Session continuity

- Read `SESSION_STATE.md` at the start of substantive work when it exists.
- Keep `SESSION_STATE.md` out of version control; confirm the root
  `.gitignore` covers it before or after creating the file.
- Update it after meaningful work or before handoff with current status,
  validation, blockers, and next steps.
```

If no supported project instruction file exists, do not create one here; direct the user to
`project-init` strict bootstrap. If it exists, preserve its content and add
only the missing section or bullets; never duplicate the section or replace
unrelated instructions. Existing projects may use equivalent wording, but the
project-init template uses this exact continuity contract.

## Update contract

- Preserve the existing `SESSION_STATE.md` headings, equivalent fields, and
  useful user-authored structure.
- Do not copy the `project-init` template into this skill or create a parallel
  state schema; `project-init` owns the creation shape.
- When the file is missing or needs bootstrap structure, stop and route the
  user to `project-init` strict bootstrap.
- Keep the document concise and short-term unless the project genuinely needs
  more detail.
