# Native Init and Instruction Compatibility

Use this reference when a harness provides a native `/init` command or when a
project has more than one applicable `AGENTS.md` file.

## Native `/init` behavior

`project-init` is the repository's guided project-control workflow. It does
not assume that a harness's native `/init` command has the same templates,
approval gates, reconciliation behavior, or output boundary.

- If the native command has not been run, use `project-init` when the task
  requires this repository's templates, evidence inventory, review gates, or
  project-control sequence.
- If the native command has already created files, inspect those files first.
  Preserve them by default, identify their source of truth, and propose only
  missing files or separately approved revisions.
- If a harness's native initialization is the only available capability, use
  it as a manual fallback, then inspect the result and report what it did not
  provide. Do not claim that native initialization completed the
  `project-init` workflow without evidence.
- Never run two initializers against the same target without an inspection
  and reconciliation proposal between them.

The native command, if used, does not authorize application scaffolding,
dependency installation, secret access, commits, remotes, or other Git
operations. Those remain separate approvals.

## Applicable `AGENTS.md` files

Before proposing or writing project-control files, discover the applicable
instruction files from the global or user scope through the enclosing
worktree root and then toward the exact target. A nested `AGENTS.md` applies
to files below its directory and may add more-specific repository rules.

- Read applicable instructions before interpreting the target or its existing
  documents.
- Keep the most specific applicable rule for the path in scope when rules
  differ; do not use a nested file to weaken a higher-level safety boundary.
- Treat an existing root or nested `AGENTS.md` as user-authored source of
  truth. Preserve it unless its owner separately approves a revision.
- If a generated root `AGENTS.md` would conflict with an existing nested file,
  report the conflict and the affected paths instead of silently merging or
  replacing either file.
- When the target itself is nested inside another worktree, report both the
  enclosing worktree root and the requested target and require the explicit
  nested-target approval described in the main workflow.

## Reload and fresh-session handoff

Instruction files generated or revised during a session are not assumed to
change the current agent's already-loaded instruction context. After an
approved write that changes `AGENTS.md` or equivalent instruction routing:

1. report the exact files created or changed and their applicable paths;
2. show the user the relevant diff and validation result;
3. recommend restarting or reloading the target harness, or beginning a fresh
   session in the target directory;
4. keep working under the instructions already active until the reload occurs;
5. do not claim that the new rules governed earlier actions.

The handoff should also point to `SESSION_STATE.md`, the active SPEC/PLAN, and
any unresolved approval. If the harness cannot reload, provide the manual
fallback: start a new session in the target, read the applicable `AGENTS.md`
files, then resume from the recorded state.
