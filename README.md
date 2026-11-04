# AI Workflow

Reusable skills, agent profiles, safety guidance, runtime configuration, and
helper scripts for human-led AI coding workflows.

The repository supports Claude Code, OpenCode, Codex, and Pi with native agent
profiles. Its shared `SKILL.md` workflows are written for compatible runtimes
that support this format. Runtime discovery, tool access, and permissions still
depend on the runtime and your local setup.

## Quick start

```bash
git clone https://github.com/ahsanghalib/ai-workflow.git
cd ai-workflow
bash scripts/validate-skills.sh
```

To link shared skills, agent profiles, global instructions, and the worktree
helpers into their default user-level locations, review and run:

```bash
./scripts/script.sh
```

The linker does not copy runtime configuration. Review and install those files
separately; they may include model choices, permissions, local paths, or
optional integrations.

## What the repository provides

### Shared skills

The `skills/` directory contains 56 reusable workflows. Each skill has a
`SKILL.md` entrypoint and may include references, scripts, tests, templates,
or examples.

| Area | Skills |
| --- | --- |
| Planning and research | `brainstorming`, `product-discovery`, `founder-decision`, `repository-research`, `research-brief`, `technical-design`, `source-driven-development` |
| Project and change lifecycle | `project-init`, `spec-workflow`, `spec-review`, `implement-next`, `git-worktree-workflow`, `session-state`, `verification-before-completion` |
| Implementation and quality | `backend-feature`, `frontend-feature`, `test-driven-development`, `systematic-debugging`, `code-simplification`, `performance-optimization`, `deprecation-and-migration`, `schema-design`, `code-review`, `review-diff` |
| Security and integrations | `security-and-hardening`, `ai-security-review`, `supply-chain-security`, `mcp-builder`, `github-cli-workflow`, `git-release` |
| Browser and web apps | `use-playwright`, `playwright-public-web`, `playwright-manual-auth`, `webapp-testing`, `agent-browser`, `browser-use` |
| Design and visuals | `frontend-design`, `ui-design-system`, `frontend-motion-review`, `apple-design`, `brand-guidelines`, `image-to-code`, `diagram-design`, `archify` |
| Writing and skill maintenance | `copywriting`, `humanizer`, `social-content`, `agent-memory`, `find-skills`, `skill-creator` |
| LinkedIn workflows | `linkedin-post`, `linkedin-visual`, `linkedin-comments`, `linkedin-hiring`, `linkedin-lead-followup`, `linkedin-workspace` |

Skills provide workflows and boundaries; they do not grant tool access or
approval. Runtime-specific steps are conditional, with a fallback when a
capability is unavailable.

### Agent profiles

Seven roles are provided in each native format:

- **Engineer** implements and debugs.
- **Advisor** makes read-only technical recommendations.
- **Explore** traces local code and conventions.
- **Research** gathers focused, authoritative external evidence.
- **Review** reports evidence-backed implementation findings.
- **Fixer** resolves a narrowly scoped hard blocker.
- **Oracle** gives an independent read-only opinion on high-risk uncertainty.

Profiles are in [`agents/claude/`](agents/claude),
[`agents/codex/`](agents/codex), [`agents/opencode/`](agents/opencode), and
[`agents/pi/`](agents/pi). The profiles share broad roles while using each
runtime's native format.

### Global instructions and project guidance

[`GLOBAL_AGENTS.md`](GLOBAL_AGENTS.md) sets cross-repository safety and
workflow rules. The optional linker maps it to the conventional user-level
instruction path for Claude Code, Codex, OpenCode, and Pi.

[`AGENTS.md`](AGENTS.md) documents this repository's layout, commands, and
conventions. Project-specific instructions belong in the project being worked
on. `SESSION_STATE.md` is ignored short-term handoff state, not committed
documentation.

### Runtime configuration

Configuration is optional and should be reviewed before copying to a user
configuration directory.

| Runtime | Included files |
| --- | --- |
| Claude Code | [`claude/settings.json`](claude/settings.json), `agents/claude/` |
| Codex | [`codex/config.toml`](codex/config.toml), `agents/codex/` |
| OpenCode | [`opencode/opencode.json`](opencode/opencode.json), [`opencode/cli.json`](opencode/cli.json), `opencode/opencode-quota/`, `opencode/plugins/`, `agents/opencode/` |
| Pi | [`pi/agent/settings.json`](pi/agent/settings.json), [`pi/agent/APPEND_SYSTEM.md`](pi/agent/APPEND_SYSTEM.md), `pi/agent/extensions/`, `pi/agent/mcp.json`, `pi/agent/prompts/`, `pi/agent/skills/`, `agents/pi/` |

OpenCode also includes a TypeScript notification plugin
([`attention-notify.ts`](opencode/plugins/attention-notify.ts)) and its
[`package.json`](opencode/package.json),
[`package-lock.json`](opencode/package-lock.json), and
[`tsconfig.json`](opencode/tsconfig.json). Its settings contain model/provider
examples and a local CodeGraph MCP command; they do not provide credentials or
guarantee access to a provider. Review Codex and OpenCode settings for local
paths, plugins, and commands before using them on another machine.

### Helper scripts and checks

- [`scripts/script.sh`](scripts/script.sh) links shared skills, agent
  profiles, global instructions, and the worktree helpers. It defaults the
  helpers to `~/.local/bin`; set `AI_WORKFLOW_BIN_DIR` to choose another
  location.
- [`scripts/validate-skills.sh`](scripts/validate-skills.sh) checks skill
  entrypoints, references, and repository boundaries.
- [`scripts/package-skills.sh`](scripts/package-skills.sh) builds the curated
  web-compatible skill ZIPs under ignored `zip/`.
- [`bin/worktree-new`](bin/worktree-new) creates a separate branch and
  worktree, copying eligible ignored runtime files from the invoking checkout.
- [`bin/worktree-close`](bin/worktree-close) removes a clean worktree after
  confirming merge evidence and checking for ignored files.

Tests and fixtures live in `tests/` and alongside some skills. The GitHub
Actions workflow is in `.github/workflows/validate.yml`.

### Web skill bundle

The curated ChatGPT web bundle includes:
`brainstorming`, `brand-guidelines`, `copywriting`, `founder-decision`,
`humanizer`, `linkedin-comments`, `linkedin-hiring`,
`linkedin-lead-followup`, `linkedin-post`, `linkedin-visual`,
`linkedin-workspace`, `product-discovery`, `research-brief`, and
`social-content`.

```bash
scripts/package-skills.sh --clean
```

Repository-control, terminal, Codex-runtime, and local-browser workflows are
excluded from this bundle.

### Examples and diagrams

`skills/` includes skill-specific references, templates, tests, and examples.
`assets/` contains workflow diagrams for project initialization and agent
memory. LinkedIn visual examples include source SVGs, rendered slides, and PDFs;
see [the visual examples guide](skills/linkedin-visual/examples/design/README.md).

## Use the repository

For skills only, use the runtime's normal discovery mechanism for shared
`SKILL.md` files. To set up supported user-level profiles and shared
instructions, run the linker after reviewing its targets:

```bash
./scripts/script.sh --help
./scripts/script.sh
```

The linker uses `CODEX_HOME`, `XDG_CONFIG_HOME`,
`CLAUDE_CONFIG_DIR`, `PI_CONFIG_DIR`, and `AI_WORKFLOW_BIN_DIR` when set;
otherwise it uses standard user-level locations. It refuses to replace existing
ordinary files or directories, but replaces symlinks at its targets. Check
existing links before running it. It does not copy Claude, Codex, OpenCode, or
Pi runtime configuration.

Read and adapt runtime configuration before installing it. In particular,
check permission settings, model identifiers, paths, plugins, and MCP commands
against your machine. Never add credentials or machine-local secrets to this
repository.

For larger changes, `git-worktree-workflow` documents how to isolate the work.
The helpers use `AI_WORKFLOW_WORKTREE_ROOT` as the parent directory; review
their help and the skill before running them. `worktree-close` only removes a
clean non-main worktree after verifying that its branch is merged.

## Repository checks

Run checks that match the files you changed:

```bash
bash scripts/validate-skills.sh
bash tests/validate-skills.test.sh
bash -n scripts/*.sh bin/* tests/*.sh
bash tests/script-linker.test.sh
bash tests/worktree-helpers.test.sh
git diff --check
```

The project-init and SPEC workflow have additional contract tests under their
skill directories. The memory helper has Python unit tests under
`skills/agent-memory/tests/`. To type-check the OpenCode notification plugin,
install its local development dependencies and run:

```bash
cd opencode
npm install
npx tsc --noEmit
```

These checks do not prove runtime discovery, provider access, or behavior in
another project. Adapt the commands to the runtime and project under test.

## Safety and scope

This is a local workflow toolkit, not an application, hosted service, or
deployment system. It does not include project source code, provider accounts,
credentials, or production infrastructure.

The instructions emphasize source inspection, user approval for consequential
or external actions, protection of secrets, and evidence-based validation.
Review changes and outcomes yourself; the tools and checks cannot guarantee
that an assistant is correct.

## License

This repository is licensed under the [MIT License](LICENSE).
