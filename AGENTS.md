# Repository Guidelines

## Project Structure

This public repository contains reusable AI workflow configuration. `skills/`
holds Markdown skill entrypoints and their `references/`; `agents/` contains
Codex agent definitions; `opencode/` contains OpenCode agents, commands,
skills, JSON/TOML configuration, and the TypeScript notification plugin.
`codex/` stores Codex configuration. The executable helper scripts live in
`bin/`. Keep personal paths, credentials, provider accounts, and machine-local
overrides out of the repository.

## Build, Test, and Development Commands

There is no application build. Use the repository-local checks that match the
change:

```bash
bash skills/validate-skills.sh       # Validate skill references and entrypoints
bash -n bin/*                         # Check helper-script syntax
cd opencode && npm install           # Install plugin type dependencies
cd opencode && npx tsc --noEmit      # Type-check the notification plugin
```

When OpenCode is installed, verify configuration changes with
`opencode debug config` and inspect affected agents with
`opencode debug agent <name>`.

## Coding Style & Naming

Use two spaces in JSON, YAML-like frontmatter, and Markdown examples; follow
the surrounding style in existing files. Use Bash strict mode and quoted
paths in shell scripts. Use descriptive kebab-case names for skills,
commands, and helper scripts. Keep each `SKILL.md` focused, route supporting
material through `references/`, and preserve valid frontmatter and JSON/TOML
syntax.

## Testing Guidelines

There is no application test suite. Every change should run the narrowest
relevant validation above; changes to skills should run
`skills/validate-skills.sh`, and TypeScript changes should run its type check.
Review generated or installed configuration with the relevant OpenCode debug
command when possible.

## Commits and Pull Requests

Use short, imperative commit subjects that describe one coherent change, such
as `Add ...`, `Harden ...`, or `Fix ...`. Pull requests should explain the
workflow impact, identify affected skills/configuration, include validation
commands and results, and call out compatibility or migration concerns.
Avoid unrelated personal configuration or drive-by formatting changes.

## Safety and Configuration

Do not commit secrets, tokens, provider credentials, personal paths, or
machine-specific state. Preserve approval gates and safety rules in agent
instructions. Review the complete diff and run `git diff --check` before
opening a pull request.
