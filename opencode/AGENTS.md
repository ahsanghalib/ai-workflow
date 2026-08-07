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

## Capability Routing

- Before starting substantive work, inspect the available agents and Skills and
  determine whether any are specifically designed for the task.
- Select and use relevant specialized capabilities before beginning the work;
  do not wait for the user to explicitly request an agent or Skill.
- Prefer the most specific applicable Skill or agent over reproducing its
  workflow manually.
- Load only capabilities relevant to the current task. Do not invoke agents or
  Skills merely because they are available.
- Newly added agents and Skills should be considered automatically based on
  their names, descriptions and declared purpose; this file should not require
  updating every time a capability is added.
- Multiple Skills may be used when the task genuinely spans their concerns, but
  use the smallest sufficient set and apply them in a logical order.
- Delegate to a specialized subagent when its expertise, independent context or
  workflow materially improves the result.
- When a task clearly matches a specialized subagent, delegate that part of the
  work before attempting it generically.
- Do not duplicate work already delegated to a subagent unless verification or
  review is required.
- For implementation or behavioral code changes, use the
  `test-driven-development` Skill before writing production code.
- For bugs or unexplained failures, use the `systematic-debugging` Skill before
  proposing a fix.
- Before using or implementing against an external library, framework, SDK or
  API, delegate documentation verification to the Research agent before
  implementation.
- Treat Commands as explicit user-invoked workflows. Do not auto-run Commands
  unless the user invokes them or the command is explicitly required by the
  active workflow.

## Worktree Workflow

- For substantial implementation work that should be isolated from the main
  checkout, use the installed `worktree-new` helper instead of constructing
  `git worktree` commands manually.
- Choose an appropriate full branch name for the task and pass it directly to
  `worktree-new` or ask before creating one.
- Create the worktree before implementation begins.
- Do not create a worktree for read-only research, planning, review,
  documentation-only changes, or trivial edits unless explicitly requested.
- After the work has been merged and the worktree is clean, use
  `worktree-close` for cleanup instead of manually removing the worktree or
  deleting the branch.
- Never force-remove a worktree.
- If it is materially unclear whether a task warrants an isolated worktree,
  ask before creating one.

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
- Before claiming implementation work is complete, use the
  `verification-before-completion` Skill when applicable.

## Writing & Humanization

- Use the `humanizer` skill for substantial user-facing prose, including documentation, reports, proposals, explanations, emails, social content and long-form answers.
- Apply humanization only after the content is technically correct and complete. Preserve the original meaning, constraints, factual claims and level of certainty.
- Write naturally and specifically. Prefer direct language, varied sentence structure and context-appropriate tone over canned phrasing, filler, hype or repetitive summaries.
- Avoid robotic introductions, excessive headings, artificial enthusiasm, fake quotations, unnecessary rhetorical questions and generic AI-sounding transitions.
- Do not humanize code, commands, configuration, logs, file paths, API names, identifiers, citations or text that must remain exact.
- For code-only, command-only or very short factual responses, do not load the skill unless it provides a clear quality benefit.
- Match the target format and audience. Humanized does not mean casual; keep technical and professional writing precise.

## User Profile & Preferences

- **Role**: Senior Software Engineer (8+ years exp), Node.js ecosystem expert.
- **Languages**:
  - Primary: TypeScript, JavaScript, Python
  - Secondary: Go, Elixir, C#
- **Coding Standards**:
  - Strictly adhere to Clean Code guidelines and SOLID principles.
  - Formatting: Always use tabs.
  - Enforce test-driven development (TDD) for code changes: write or update the failing test first, implement the minimum code required to pass it, then refactor while keeping tests green. Do not skip the test-first step unless the change cannot reasonably be tested; state the reason when this exception applies.
  - Linting: Enforce industry-standard linter rules for the target language (e.g., ESLint/Prettier for JS/TS, Ruff for Python).
- **Agent Behavior**: Treat me as a senior peer. Avoid over-explaining basic concepts. Focus on architecture, performance, and maintainability.
