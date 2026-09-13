<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Bootstrap a New Project

Use the `project-init` skill for a new or empty target.

1. Resolve and show the exact canonical target path.
2. Classify it as empty, `.git`-only, or existing using safe metadata.
3. Propose the documentation files, optional schema, tracked prompts, and
   separate local `git init` operation.
4. Ask the user to review each approval scope before writing.
5. Do not scaffold application code, frameworks, packages, or `.env` files.

If Git is unavailable or initialization is not approved, continue with the
documentation-only bootstrap when safe and report that branch, history, and
Git-state validation are unavailable. Never bundle a commit, branch, remote,
push, or other Git operation with local initialization.

Keep unknown product and technical decisions explicitly open. Stop after the
proposal and handoff unless the user separately approves the next action. At
handoff, report the target, created/changed/preserved/skipped/blocked files,
assumptions, unresolved decisions, validation commands and results, and the
next exact review action. State that no application source, dependencies,
migrations, secrets, commit, or remote operation was created or performed.
