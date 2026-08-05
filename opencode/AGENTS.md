# Global OpenCode instructions

## Working style

- Lead with the result, failure or blocking fact.
- Assume a senior engineer. Be concise and make tradeoffs explicit.
- Inspect repository instructions and nearby code before proposing changes.
- For a non-trivial change, state a short plan and validation criteria first.
- Make the smallest coherent change; do not mix unrelated cleanup.
- Prefer existing patterns and dependencies over new abstractions.

## Session continuity

- At the start of substantive work, read the project-root `SESSION_STATE.md`
  when it exists.

## Tooling & Operational Efficiency

- Search with `rg` and list files with `rg --files` or `fd`. Access known
  paths directly; avoid exploratory `ls` or `Read` of whole directories.
- Read only necessary file subsets — grep/filter before reading full files.
- Use repository-local commands and lock files.
- System packages: pacman, then yay only when no official Arch package exists.
- Never install a global npm package; project-local deps only when required.
- Ollama is for manual experiments only — never start its service or wire
  it into agent/editor config.
- Use Skills only when they demonstrably reduce tokens or improve accuracy
  for a defined workflow — avoid loading broad skills for narrow tasks.
- Rely on built-in, lightweight tools; avoid chaining tool calls when one
  command suffices.
- Do not add plugins or MCP integrations without explicit approval.
- **Delegation cost**: each `task` call to a subagent is a separate request
  against daily rate limits — delegate only when it clearly beats inline work.

## Safety

- Never read or print secrets, `.env` files, provider credentials, SSH keys or
  AWS credential files.
- Never use sudo/doas, force pushes, hard reset, Git clean, recursive force
  deletion, production cloud commands, deploys, publishes or infrastructure
  applies.
- Do not change files outside the current repository/worktree.
- Do not modify generated files directly; run the documented generator.
- Do not change a lock file unless dependencies intentionally changed.
- Never replace large blocks of existing content with incomplete or truncated versions. Always include sufficient surrounding context in `oldString` to ensure the edit is surgical and that unmentioned content is preserved.
- Always verify the diff after an edit. If an accidental deletion occurs, rollback or immediately restore the missing information.
- Maintain all repository-mandated sections (like `Session continuity`) precisely as documented.

## Validation and handoff

- Reproduce or establish a baseline before fixing a bug.
- Run the narrowest relevant test first.
- Run lint, typecheck and broader tests before handoff when practical.
- Inspect `git diff --check` and the final diff.
- Report commands run, results, untested paths, assumptions and risks.
- Do not claim success when validation failed or was not run.

## User Profile & Preferences

- **Role**: Senior Software Engineer (8+ years exp), Node.js ecosystem expert.
- **Languages**:
  - Primary: TypeScript, JavaScript, Python
  - Secondary: Go, Elixir, C#
- **Coding Standards**:
  - Strictly adhere to Clean Code guidelines and SOLID principles.
  - Formatting: Always use tabs.
  - Linting: Enforce industry-standard linter rules for the target language (e.g., ESLint/Prettier for JS/TS, Ruff for Python).
- **Agent Behavior**: Treat me as a senior peer. Avoid over-explaining basic concepts. Focus on architecture, performance, and maintainability.
