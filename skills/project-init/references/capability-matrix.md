# Harness Capability Matrix and Manual Fallbacks

Project-init must report which capabilities are available before relying on a
helper, companion skill, or validation command. Use `available`,
`unavailable`, or `not exercised`; do not infer capability from a tool name.

## Capability boundaries

### User approval and confirmation

- **Available:** show the exact target, operations, diff, and compatibility
  impact, then record approval per scope.
- **Unavailable:** do not write, initialize Git, revise existing documents, or
  continue past an approval gate. Return the proposal for the user to approve
  through a supported channel.

### Safe filesystem inspection

- **Available:** inspect the canonical target, immediate names, safe metadata,
  applicable instructions, and approved source-of-truth documents.
- **Unavailable:** do not classify the target or write a scaffold. Ask the user
  to provide a safe inventory or use a harness with read access.

### File writing

- **Available:** after approval, use copy-if-missing and preserve existing files
  and symlinks.
- **Unavailable:** produce the exact proposal and a user-run command or patch;
  do not claim that files were created.

### Shell and bundled helpers

- **Available:** run the read-only inspector first, then the approved
  initializer and focused checks.
- **Unavailable:** do not silently emulate a partial shell script. Provide the
  exact command for the user to run locally, or use supported file operations
  only when their preservation and no-secret behavior can be verified. Report
  that helper execution and its validation were not exercised.

### Local Git

- **Available:** preserve existing metadata or propose exact-target `git init`
  as a separate approval.
- **Unavailable:** use the documentation-only no-Git fallback. Do not inspect
  branch/history state, and do not create commits, branches, remotes, pushes,
  or other Git operations.

### Skill discovery and routing

- **Available:** invoke the named `project-init` or companion skill and record
  the routed handoff.
- **Unavailable:** use the corresponding documented manual workflow while
  keeping the same scope, approval, secret, review, and output boundaries. Do
  not silently route planning to a retired skill name or claim the companion
  skill ran.

### Validation tools

- **Available:** run the narrowest relevant Markdown, shell, link, validator,
  or test command and report its result.
- **Unavailable:** perform a bounded manual inspection, list the skipped
  commands, and mark structural or runtime validation as unverified. Do not
  claim validation passed.

### Session state and project memory

- **Available:** update ignored `SESSION_STATE.md` and create one reviewed
  project-memory episode after meaningful work.
- **Unavailable:** include the full handoff, decisions, blockers, validation,
  untested paths, and next action in the response or another approved project
  document. Do not invent a memory store or claim continuity was persisted.

### Current external research or network access

- **Available:** use the appropriate research workflow and cite current
  authoritative evidence before recording version-sensitive choices.
- **Unavailable:** leave the choice open or mark it as a recommendation. Do
  not invent current framework, library, provider, or platform behavior.

## Handoff format

For every unavailable or unexercised capability, report its state, the affected
operation, the safe fallback, and the exact next action needed to resume. A
missing capability blocks only the operation that requires it; it must not
silently authorize a broader operation or partial write.
