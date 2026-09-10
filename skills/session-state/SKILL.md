---
name: session-state
description: Use when creating or updating the active project's SESSION_STATE.md summary and its required AGENTS.md continuity section.
---

# Session State

Immediately create or update the active project's root `SESSION_STATE.md` and
its root `AGENTS.md` using the harness's file capabilities. Do not only
describe the requested changes, ask for clarification, or return a plan;
complete the file updates first, then briefly report what changed. If the
harness cannot identify the project root or edit files, report that blocker
without writing elsewhere.

- Resolve the active project root first: prefer the Git worktree root;
  otherwise use the current working directory.
- Read an existing state file before planning or updating it.
- Preserve useful user-authored content and existing headings.
- Record concise completed work, pending tasks, blockers, validation commands
  and results, untested paths, assumptions or risks, and next steps.
- Do not include credentials, tokens, private keys, or other secrets.
- Do not add the file to Git, change `.gitignore`, or commit it unless asked.
- Ensure the project-root `AGENTS.md` has this `## Session continuity` section:

  The following snippet is copied into the project-root `AGENTS.md`; its
  relative link therefore resolves from the project root, not this skill's
  directory.

  ```markdown
  ## Session continuity

  - At the start of substantive work, read [SESSION_STATE.md](./SESSION_STATE.md).
  - Update it with the `session-state` skill after meaningful work or before
    handoff.
  ```

  Create `AGENTS.md` with this section when absent. When it exists, preserve
  its content, add only the missing section or bullets, and never duplicate the
  section.

When creating the file, use this structure:

```markdown
# Session State

Last updated: YYYY-MM-DD

## Objective

## Completed

## Pending

## Known Issues and Constraints

## Validation

## Assumptions and Risks

## Next Session
```
