# AI Workflow — Shared Codex and OpenCode Configuration

A safety-first [OpenCode](https://opencode.ai) and [Codex](https://openai.com/codex/) workflow for software
engineers: bounded agents, approval-gated changes, TDD and verification skills,
model tiers, and isolated Git worktrees.

This public repository contains reusable, machine-independent workflow pieces:

| Path                                       | Purpose                                              |
| ------------------------------------------ | ---------------------------------------------------- |
| [`agents/codex/`](agents/codex)            | Codex agent profiles in TOML                         |
| [`agents/opencode/`](agents/opencode)      | OpenCode agent profiles in Markdown                  |
| [`bin/`](bin)                              | Git worktree helper scripts                          |
| [`script.sh`](script.sh)                   | Symlink installer for agents, skills, and instructions |
| [`codex/`](codex)                          | Codex configuration                                  |
| [`opencode/`](opencode)                    | OpenCode configuration, plugin, quota, and TUI files |
| [`skills/`](skills)                        | Shared Agent Skills and supporting references        |
| [`validate-skills.sh`](validate-skills.sh) | Skill entrypoint and reference validator              |
| [`GLOBAL_AGENTS.md`](GLOBAL_AGENTS.md)     | General global agent instructions                    |
| [`AGENTS.md`](AGENTS.md)                   | Contributor guidance for this repository             |

Everything is plain text: Bash, JSON, Markdown, TOML, and one TypeScript
plugin. No background services or daemons are included; optional local MCP
integrations are declared in the runtime configuration. The opt-in
[`use-playwright`](skills/use-playwright/SKILL.md) skill adds a project-local
Playwright MCP profile when needed.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Repository layout](#repository-layout)
- [Installation](#installation)
- [What you get](#what-you-get)
  - [Agents](#agents)
  - [Codex configuration](#codex-configuration)
  - [Agent behavior and conventions](#agent-behavior-and-conventions)
  - [Permissions and safety model](#permissions-and-safety-model)
  - [Skills](#skills)
  - [Desktop notifications](#desktop-notifications)
  - [TUI settings](#tui-settings)
- [Model configuration](#model-configuration)
- [Git worktree helpers](#git-worktree-helpers)
- [Customizing](#customizing)
- [Troubleshooting](#troubleshooting)
- [Notes and sources](#notes-and-sources)
- [License](#license)

---

## Prerequisites

- **bash**, **git**, **rsync**, and standard coreutils — present on most macOS
  and Linux installations.
- **[OpenCode CLI](https://opencode.ai/docs/)**: `curl -fsSL https://opencode.ai/install | bash`, or install via your package manager.
- **Codex CLI or app** (optional) — required only when using the Codex
  configuration and agent profiles.
- **Node.js** (optional) — only needed to type-check the notification plugin with `npx tsc --noEmit`.
- **`notify-send`** (Linux, part of `libnotify`) — required for desktop notifications from the plugin. On macOS, see [Troubleshooting](#troubleshooting).
- **`tmux`**, **`nvim`**, **`lazygit`** — optional; required only for the
  optional local worktree session launcher.
- **`gh`** (GitHub CLI) — optional; enables squash/rebase merge detection in `worktree-close` and the approval-gated `git-release` workflow.

---

## Repository layout

Agent profiles are kept separate by runtime: Codex reads the TOML profiles in
`agents/codex/`, while OpenCode uses the Markdown profiles in
`agents/opencode/`. Codex, OpenCode, and other compatible harnesses can share
the reusable Agent Skills in `skills/`; the active harness supplies discovery,
loading, and capability-specific adapters.

Runtime-specific files stay under `codex/` and `opencode/`. The latter contains
the OpenCode JSON configuration, model metadata, plugin source, package
manifest, quota configuration, TUI settings, and empty `modes/`, `themes/`, and
`tools/` extension directories. `bin/` contains only the checked-in worktree
helpers, while `validate-skills.sh` checks skill entrypoints and references.
`GLOBAL_AGENTS.md` is the generic global policy file; the root `AGENTS.md`
documents contribution rules for this repository.

---

## Compatibility and validation

This configuration is tested against OpenCode `1.18.x` and declares the current
OpenCode JSON schema URL. The Codex configuration is TOML-based and keeps a
parallel set of agent profiles under `agents/codex/`. Validate the affected
files locally:

```bash
bash validate-skills.sh
bash -n bin/*
(cd opencode && npm install && npx tsc --noEmit)
git diff --check
```

When upgrading OpenCode, run `opencode debug config` and
`opencode debug agent engineer` locally before widening the supported range.

---

## Installation

### 1. Install the OpenCode CLI

```bash
curl -fsSL https://opencode.ai/install | bash
# or
brew install opencode
```

Verify it works:

```bash
opencode --version
```

### 2. Install the helper scripts (`bin/`)

Copy the scripts from this repository into `~/.local/bin` (or anywhere on your
`PATH`). They are already executable.

```bash
install -m 755 bin/worktree-new         ~/.local/bin/
install -m 755 bin/worktree-close       ~/.local/bin/
```

Or link them so updates to this repo take effect automatically:

```bash
ln -s "$(pwd)/bin/worktree-new"          ~/.local/bin/
ln -s "$(pwd)/bin/worktree-close"        ~/.local/bin/
```

### 3. Link shared agents, instructions, and skills (optional)

Use the repository installer to link runtime-specific agents and global
instructions, and all shared skills into the canonical `~/.agents/skills`
directory:

```bash
./script.sh
```

The installer creates these links:

| Source | Destination |
| --- | --- |
| `agents/codex/` | `${CODEX_HOME:-~/.codex}/agents` |
| `agents/opencode/` | `${XDG_CONFIG_HOME:-~/.config}/opencode/agents` |
| `GLOBAL_AGENTS.md` | `${CODEX_HOME:-~/.codex}/AGENTS.md` and `${XDG_CONFIG_HOME:-~/.config}/opencode/AGENTS.md` |
| Each directory under `skills/` | `~/.agents/skills/<skill-name>` |

Pass a repository path when running the script from elsewhere, or set
`AI_WORKFLOW_REPO`. It honors `CODEX_HOME` and `XDG_CONFIG_HOME` for runtime
links, creates `~/.agents/skills` when needed, and refuses to replace existing
non-symlink targets. The installer does not copy runtime configuration files;
review and install those separately below. Each installed skill is discovered
from its `SKILL.md` entrypoint and may include bundled scripts, templates, or
references; no package-level README is required.

### 4. Install the OpenCode configuration

OpenCode reads its global configuration from `~/.config/opencode/` (it also
honors `$XDG_CONFIG_HOME/opencode`). Install the runtime files, agent profiles,
and global instructions. Shared skills are already linked by step 3 into
`~/.agents/skills`:

This step configures OpenCode only; do not install another copy of `skills/`
here.

> **Warning:** Back up an existing configuration before replacing it.

```bash
# Preserve your existing setup if any
if [ -d ~/.config/opencode ]; then
  mv ~/.config/opencode ~/.config/opencode.backup-$(date +%Y%m%d-%H%M%S)
fi

mkdir -p ~/.config/opencode
rsync -a --exclude node_modules opencode/. ~/.config/opencode/
mkdir -p ~/.config/opencode/agents
rsync -a agents/opencode/. ~/.config/opencode/agents/
cp GLOBAL_AGENTS.md ~/.config/opencode/AGENTS.md
```

This intentionally excludes `node_modules/`; install plugin type dependencies
fresh only when you need them (optional, see next step).

### 5. Configure Codex (optional)

Review `codex/config.toml` for local paths and provider choices before copying
it to `~/.codex/config.toml`. Install the matching agent profiles under
`~/.codex/agents/`; shared skills are already linked by step 3 into
`~/.agents/skills`:

This step configures Codex only; do not install another copy of `skills/` here.

```bash
mkdir -p ~/.codex/agents
cp codex/config.toml ~/.codex/config.toml
cp agents/codex/*.toml ~/.codex/agents/
```

The Codex configuration includes runtime, provider, memory, plugin, and MCP
settings. Replace marketplace, plugin, and executable paths that do not exist
on your machine before loading it. The `agents.*.config_file` entries are
relative to the Codex configuration directory and should resolve to the copied
profiles. The shared skills are linked separately by step 3 into
`~/.agents/skills` because agent profiles do not register skills themselves.

### 6. Install plugin type dependencies (optional)

The notification plugin (`opencode/plugins/attention-notify.ts`) imports the
`@opencode-ai/plugin` package for its types. This is a development-time
dependency only — OpenCode loads the `.ts` file directly.

```bash
cd ~/.config/opencode
npm install
```

If you skip this, the plugin still runs; you just cannot type-check it with
`npx tsc --noEmit`.

### 7. Authenticate your providers

The configuration references models from several providers (see
[Model configuration](#model-configuration)). Log in to the
ones you want to use:

```bash
opencode auth login
```

Select your providers, then verify which agents resolve to real models:

```bash
opencode debug agent engineer
opencode debug agent explore
```

### 8. Verify the installation

From any project directory:

```bash
opencode debug config          # show resolved configuration (includes active model)
opencode debug agent engineer  # verify the primary agent resolves correctly
```

If the models in `opencode/opencode-models.json` do not match your provider access, see
[Customizing](#customizing) before running your first session.

---

## What you get

### Agents

Seven agents are defined in both `agents/opencode/` and `agents/codex/`. The
`engineer` agent is the primary execution owner; the other profiles provide
focused delegation for discovery, research, review, advice, hard blockers, and
high-risk read-only escalation. OpenCode delegation is capped at depth 1 via
`subagent_depth` in `opencode/opencode.json`.

| Agent      | Role     | Purpose                                                      |
| ---------- | -------- | ------------------------------------------------------------ |
| `engineer` | primary  | Implements and debugs repository changes with approval gates |
| `advisor`  | subagent | Read-only advisory work: decisions, drafts, and memos        |
| `review`   | subagent | Read-only code review with exact file/line evidence          |
| `explore`  | subagent | Repository exploration and convention lookup                 |
| `research` | subagent | Web-only research from primary or official sources           |
| `fixer`    | subagent | Focused help with difficult implementation blockers          |
| `oracle`   | subagent | Independent, read-only escalation for high-risk uncertainty  |

The exact model and reasoning settings are defined in each runtime's agent
profiles and top-level configuration.

### Codex configuration

Codex loads its defaults and feature settings from `codex/config.toml`. The
`[agents.*]` entries select the matching TOML profiles in `agents/codex/`,
including `engineer`, `advisor`, `explore`, `fixer`, `oracle`, `research`, and
`review`. The configuration also enables on-request approvals, workspace
writing, live web search, memories, multi-agent support, and optional local
MCP/plugin integrations. Keep those integrations portable and review their
paths before sharing or installing the file.

The `engineer` agent carries a working style derived from
`GLOBAL_AGENTS.md`: inspect instructions before proposing changes, state a plan and
validation criteria, make the smallest coherent change, and review the diff
before handoff. It proactively delegates convention lookups to `explore`,
external documentation to `research`, and applies relevant skills like
`test-driven-development`, `systematic-debugging`, or
`verification-before-completion` without waiting to be prompted. It refuses
deployments, publishing, destructive git commands, and secret handling.

### Agent behavior and conventions

The `engineer` agent follows the installed global instructions in addition to
any project-level instructions. It leads with results and tradeoffs, avoids broad
unrelated changes, and asks when a product or architecture choice materially
affects the result.

- **Capabilities and delegation.** Before substantive work, the agent selects
  the smallest relevant combination of skills and subagents. It uses
  `test-driven-development` for behavioral code changes,
  `systematic-debugging` for unexplained failures, and
  `verification-before-completion` before a completion claim. It delegates
  repository conventions to `explore` and external SDK or API documentation to
  `research`. Explicit workflows run only when you invoke them.
- **Session continuity.** At the start of substantive work, the agent reads a
  project-root `SESSION_STATE.md` when one exists.
- **Worktrees.** For substantial implementation work that needs isolation, the
  agent uses `worktree-new` before implementation and `worktree-close` after a
  merged, clean worktree. It does not create a worktree for research, planning,
  review, documentation-only, or trivial work unless you request one. When the
  choice is unclear, it asks first. See [Git worktree helpers](#git-worktree-helpers)
  for the helper contracts.
- **Validation and handoff.** For a bug, the agent establishes a baseline
  before a fix. It starts with the narrowest relevant check, then runs lint,
  type checks, and broader tests when practical. Before handoff it reviews the
  complete diff, runs `git diff --check`, and reports commands run, untested
  paths, assumptions, and residual risks.
- **Tooling.** Repository-local tools and dependencies take precedence. The
  agent uses `rg` or `fd` for discovery and does not install global npm
  packages. It delegates only when a specialized agent or skill materially
  improves the result.
- **Code and writing standards.** This configuration favors Clean Code and
  SOLID, tabs for indentation, TDD with a red-green-refactor loop for testable
  behavioral changes, and the relevant language linter. For substantial prose,
  it applies `humanizer` after the content is technically correct, without
  changing exact code, commands, configuration, paths, identifiers, citations,
  or stated certainty.

### Permissions and safety model

`opencode/opencode.json` installs a strict, denial-by-default permission policy:

- **Everything asks first** (`"*": "ask"`), except `todowrite`, which is
  allowed.
- **Reads are broadly allowed** but hard-denied for secrets: `.env*`,
  `*.pem`, `*.key`, `.ssh/`, `.aws/`, `.kube/`, `auth.json`,
  `credentials.json`/`credentials.yml`, `secrets.json`, `*.tfvars`,
  `id_rsa`/`id_ed25519`, `.git-credentials`, and more.
- **Shell commands** default to ask; `git status`, `git diff`, `git log`,
  `git show`, and `git branch --show-current` are pre-approved. A long denylist
  blocks `sudo`/`doas`,
  `rm -rf`, `shred`, `find -delete`, `git reset --hard`, `git clean`,
  `git push`, destructive branch/worktree operations, `terraform apply`,
  `aws`, `kubectl`, `docker`, `npm publish`, system package installs
  (`pacman`/`yay`), and `systemctl`.
- **`task` (subagent delegation) is denied for the user** and allowed only
  from inside the `engineer` agent, and only to `explore`, `research`,
  `review`, `advisor`, `fixer`, and `oracle`.
- `external_directory` access is denied; `websearch` is allowed, `webfetch`
  asks.
- `snapshot` is on, `share` is disabled, `autoupdate` is off, and the default
  `plan`/`build` agents are disabled — the checked-in agent profiles provide
  the intended workflow.
- `compaction` auto-prunes with a 12k-token reserve; the watcher ignores
  `.git`, `node_modules`, build/dist output, and virtualenvs.

The agent also applies safety rules that sit above the permission policy. It
works only inside the active repository or worktree, regenerates generated
files instead of editing them directly, leaves lock files unchanged unless a
dependency change requires them, preserves repository-mandated sections, and
reviews every edit diff before handoff.

### Skills

Skills are reusable Agent Skills under `skills/`, loaded only when the active
harness matches a skill's description and exposes the required capabilities.
They are not OpenCode-only: Codex and other compatible harnesses may load the
same files through their documented skill-discovery mechanism. Keep core
workflow guidance harness-neutral; keep runtime-specific mechanics conditional
and adapter-specific inside the relevant skill references.

The repository includes:

| Skill                            | When to use                                                                                                                |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `brainstorming`                 | Refining an incomplete idea into a user-approved direction before specialist design or implementation                      |
| `repository-research`            | Tracing local code, seams, and conventions before a change                                                                 |
| `technical-design`               | Proposing/comparing architecture, APIs, and migrations                                                                     |
| `mcp-builder`                    | Designing and validating capability-conditional MCP servers and tools                                                      |
| `diagram-design`                 | Creating evidence-grounded, accessible static HTML/SVG diagrams                                                          |
| `archify`                        | Optional typed-source and renderer-backed architecture/workflow diagram delivery                                         |
| `source-driven-development`      | Grounding framework and library decisions in current authoritative sources                                                 |
| `security-and-hardening`         | Threat modeling and hardening input, auth, data, integrations, and dependencies                                           |
| `ai-security-review`             | Defensive review of AI prompts, retrieval, memory, model output, and agent-tool boundaries                              |
| `supply-chain-security`          | Reviewing dependencies, CI inputs, SBOMs, provenance, signatures, and release-chain risk                              |
| `performance-optimization`       | Measure-first investigation and verification of performance changes                                                       |
| `deprecation-and-migration`      | Planning safe replacement, compatibility, rollout, and removal of old behavior                                             |
| `code-simplification`            | Reducing code complexity while preserving observable behavior                                                             |
| `systematic-debugging`           | Diagnosing bugs, flakes, regressions, and recovery paths                                                                   |
| `test-driven-development`        | Changing behavior with a red-green-refactor test loop                                                                      |
| `verification-before-completion` | Claiming completion with fresh, task-appropriate evidence                                                                  |
| `git-release`                    | Preparing approval-gated release validation and handoff                                                                    |
| `implement-next`                 | Implementing and validating one approved plan task                                                                         |
| `project-init`                   | Bootstrapping project control and planning scoped work                                                                      |
| `plan-consistency-review`        | Checking requirements, designs, plans, tasks, and validation for internal consistency                                      |
| `plan-convergence`               | Comparing an approved plan and tasks with current implementation evidence                                                |
| `research-brief`                 | Producing dated, source-linked research briefs                                                                             |
| `review-diff`                    | Reviewing a diff for actionable correctness and regression findings                                                        |
| `session-state`                  | Recording concise session continuity state                                                                                 |
| `use-playwright`                 | Configuring an approved project-local Playwright MCP profile                                                               |
| `frontend-design`                | Planning UI hierarchy, states, responsive behavior, accessibility                                                          |
| `ui-design-system`              | Defining reusable visual direction, semantic tokens, component rules, and resilient UI guidance                           |
| `image-to-code`                  | Generating or inspecting visual references and translating them into accessible frontend implementation                   |
| `frontend-motion-review`         | Building, reviewing, and auditing purposeful, accessible frontend motion                                                   |
| `apple-design`                   | Applying optional Apple-inspired direct manipulation, materials, typography, and inclusive interaction principles       |
| `humanizer`                      | Removing AI-generated writing patterns from prose                                                                          |
| `webapp-testing`                 | Repository-native Playwright test planning/execution                                                                       |
| `agent-browser`                  | Approved exploratory browser QA on unauthenticated localhost                                                               |
| `product-discovery`              | Evaluating problems, ICP, MVP scope, and validation experiments                                                            |
| `founder-decision`               | Comparing consequential business options and decisive tests                                                                |
| `social-content`                 | Drafting truthful, channel-specific social/editorial content and blog posts from source material                           |
| `brand-guidelines`               | Applying user-provided brand rules to artifacts                                                                            |
| `github-cli-workflow`            | Inspecting/preparing PRs, issues, checks, and workflow logs with `git`/`gh`                                                |
| `skill-creator`                  | Creating and auditing shared, harness-neutral Agent Skills                                                                  |
| `playwright-public-web`          | Read-only inspection of explicitly approved unauthenticated public websites through Playwright MCP                         |
| `playwright-manual-auth`         | Read-only inspection of approved login-required sites after the user authenticates in a headed isolated Playwright browser |

Each skill's `description` field defines its precise trigger and non-use cases.

The public repository does not include a separate command catalog. Use the
active harness's agent profiles and load skills from `skills/` according to the
task.

### Desktop notifications

`opencode/plugins/attention-notify.ts` is a small TypeScript plugin that
sends a desktop notification when OpenCode waits for a permission approval or
a question. It uses `notify-send` on Linux. The TUI attention config is in
`opencode/tui.json` (sound + notifications on).

### TUI settings

`opencode/tui.json` enables attention notifications with sound. You can drop
your own theme files into `opencode/themes/` and custom tool/plugin files into
`opencode/tools/` and `opencode/plugins/`.

---

## Model configuration

OpenCode defaults and provider declarations live in
`opencode/opencode.json`; model metadata is in
`opencode/opencode-models.json`. Review the model IDs and provider access before
using the configuration. Codex model, reasoning, approval, memory, and runtime
defaults are in `codex/config.toml`; its agent selection is defined by the
`[agents.*]` entries. These files contain configuration only—authenticate
providers through the relevant runtime and never commit credentials.

---

## Git worktree helpers

`bin/worktree-new` and `bin/worktree-close` create and tear down isolated git
worktrees for agent work, so a long-running AI session never touches your main
checkout.

If an executable `dev-session` is available on `PATH`, `worktree-new` invokes it
after creating the worktree. Otherwise it prints the new worktree path.

### `worktree-new BRANCH [BASE_REF] [START_WINDOW]`

```bash
worktree-new feature/auth-login
worktree-new my-experiment origin/develop
worktree-new bugfix/hotfix origin/main test
```

Creates:

- a worktree at `<parent-of-repo>/<repo-name>.worktrees/<branch>/` (branch
  namespaces like `feature/auth-login` are mirrored as subdirectories)
- a branch with the exact name given, based on `BASE_REF` (default `origin/main`)

Runs the main-checkout commands so the branch and worktree belong to the real
repository, not a nested checkout. Uses `--no-track` so the created branch does
not set upstream tracking. If the target path or branch already exists, it
refuses to run.

After creating the worktree, it passes the worktree path and `START_WINDOW`
(`edit`, `agent`, `test`, or `git`) to that optional helper.

### `worktree-close PATH [MERGED_INTO_REF]`

```bash
worktree-close ~/repos/my-project.worktrees/feature/auth-login
worktree-close ~/repos/my-project.worktrees/bugfix/hotfix origin/main
```

Removes the worktree and deletes its branch, but only when:

- the worktree is not the main checkout,
- the working tree is clean,
- the branch is merged, verified by one of:
  - **Git ancestry** — the branch is a fast-forward ancestor of `MERGED_INTO_REF`
    (default `origin/main`), or
  - **GitHub merged PR** — if `gh` is authenticated, it falls back to checking
    for a merged PR with the branch as its head (handles squash/rebase merges).

Before verifying, it fetches the remote to ensure the merge target is current.
It refuses to run from inside the target worktree, and uses `git branch -D`
deliberately — merge safety is already explicitly verified above.

It refuses to run destructive removal (`worktree remove --force` is denied by
the global permission policy anyway).

---

## Customizing

This is an opinionated public template. For day-to-day tweaks, edit installed
copies rather than this repository:

- **Models** — edit `opencode/opencode-models.json` and
  `opencode/opencode.json`, or update the model settings in `codex/config.toml`
  for Codex.
- **Agents** — edit the matching profile in `agents/opencode/` or
  `agents/codex/`. OpenCode profiles use Markdown frontmatter; Codex profiles
  use TOML.
- **Codex runtime** — update `codex/config.toml` for approvals, sandboxing,
  memories, feature flags, plugins, and MCP servers. Replace local paths before
  copying it to `~/.codex/`.
- **Permissions** — `opencode/opencode.json` → `permission`. Prefer tightening over
  loosening; the deny rules exist to keep AI sessions from touching secrets or
  doing irreversible things.
- **Skills** — add harness-neutral `SKILL.md` folders under `skills/` and route
  supporting material through each skill's `references/` directory. Put
  harness-specific setup behind explicit compatibility or adapter guidance.
- **Global instructions** — `GLOBAL_AGENTS.md` is installed as
  `~/.config/opencode/AGENTS.md` and shapes every OpenCode session. Per-project
  `AGENTS.md` files layer on top of it. See
  [Agent behavior and conventions](#agent-behavior-and-conventions) for the
  included workflow rules.
- **Plugin** — edit `opencode/plugins/attention-notify.ts`; type-check with
  `npx tsc --noEmit` inside `~/.config/opencode`. Restart OpenCode after
  plugin/skill changes — global extensions load at startup.

---

## Troubleshooting

| Symptom                                          | Fix                                                                                                                          |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `opencode: command not found`                    | Install the CLI with `curl -fsSL https://opencode.ai/install \| bash`.                                                       |
| `model: null` / agent shows `?`                  | Run `opencode auth login` and fix the model IDs in `opencode/opencode.json` or `opencode/opencode-models.json`.              |
| Codex cannot load a profile                      | Confirm `~/.codex/config.toml` points to `~/.codex/agents/<name>.toml` and replace invalid local plugin or executable paths. |
| Codex uses the wrong model or approval mode      | Check `codex/config.toml` and the selected `[agents.<name>]` profile.                                                        |
| Plugin type-check fails                          | Run `npm install` inside `~/.config/opencode`; the `@opencode-ai/plugin` types are required.                                 |
| No desktop notifications on macOS                | The plugin uses Linux `notify-send`; replace it with an equivalent macOS notification command in `attention-notify.ts`.      |
| `worktree-new` exits after creating the worktree | It may have handed off to optional `dev-session`; otherwise use the printed worktree path.                                   |
| `worktree-close` refuses to run                  | Ensure the worktree is clean, run the command outside it, and verify that the branch is merged.                              |
| I broke `opencode/opencode.json` or an agent     | Re-copy the affected file from `opencode/` or `agents/opencode/`.                                                            |
| Changes to skills do not appear                  | Restart OpenCode; global extensions load at startup.                                                                         |

---

## Notes and sources

- The skills and workflow patterns are adapted/audited from public sources
  with licenses reviewed per skill. Check each skill's own metadata and
  `LICENSE.txt` files for provenance and licensing notes.
- This configuration deliberately does **not** include: autonomous
  commit/push/ship flows, GitHub MCP with write access, social posting,
  deployment/cloud/billing integrations, or global browser automation
  stacks.
- The model IDs shown are examples from the author's environment. Substitute
  your own provider/model IDs.

## License

[MIT](./LICENSE)
