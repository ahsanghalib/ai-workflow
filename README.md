# AI Workflow — OpenCode Configuration

A safety-first [OpenCode](https://opencode.ai) workflow for software
engineers: bounded agents, approval-gated changes, TDD and verification skills,
model tiers, and isolated Git worktrees.

This repository contains two folders:

| Folder | Purpose |
| --- | --- |
| [`bin/`](#2-install-the-helper-scripts-bin) | Shell scripts you can symlink or copy into `~/.local/bin` |
| [`opencode/`](#3-install-the-opencode-configuration-opencode) | The full OpenCode configuration, installed to `~/.config/opencode` on macOS/Linux |

Everything is plain text: Bash, JSON, Markdown, and one TypeScript plugin. No
background services, daemons, or global MCP servers. The opt-in
[`/use-playwright`](#slash-commands) command adds a project-local Playwright
MCP profile when needed.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [What you get](#what-you-get)
  - [Agents](#agents)
  - [Agent behavior and conventions](#agent-behavior-and-conventions)
  - [Permissions and safety model](#permissions-and-safety-model)
  - [Skills](#skills)
  - [Slash commands](#slash-commands)
  - [Desktop notifications](#desktop-notifications)
  - [TUI settings](#tui-settings)
- [`opencode-model-switch`: switching model tiers](#opencode-model-switch-switching-model-tiers)
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
- **[jq](https://jqlang.github.io/jq/)** — required only by `opencode-model-switch`. (`brew install jq`, `pacman -S jq`, etc.)
- **Node.js** (optional) — only needed to type-check the notification plugin with `npx tsc --noEmit`.
- **`notify-send`** (Linux, part of `libnotify`) — required for desktop notifications from the plugin. On macOS, see [Troubleshooting](#troubleshooting).
- **`tmux`**, **`nvim`**, **`lazygit`** — optional; required only for the
  `dev-session` worktree launcher.
- **`gh`** (GitHub CLI) — optional; enables squash/rebase merge detection in `worktree-close` and the approval-gated `/git-release` command.

---

## Compatibility and validation

This configuration is tested against OpenCode `1.18.x` and declares the current
OpenCode JSON schema URL. CI validates JSON, agent/command/skill frontmatter,
model-tier mappings, shell scripts, TypeScript, and the helper-script integration
tests. When upgrading OpenCode, run `opencode debug config` and
`opencode debug agent engineer` locally before widening the supported range.

Repository checks run with:

```bash
make check
```

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
install -m 755 bin/opencode-model-switch ~/.local/bin/
install -m 755 bin/worktree-new         ~/.local/bin/
install -m 755 bin/worktree-close       ~/.local/bin/
install -m 755 bin/dev-session          ~/.local/bin/
```

Or link them so updates to this repo take effect automatically:

```bash
ln -s "$(pwd)/bin/opencode-model-switch" ~/.local/bin/
ln -s "$(pwd)/bin/worktree-new"          ~/.local/bin/
ln -s "$(pwd)/bin/worktree-close"        ~/.local/bin/
ln -s "$(pwd)/bin/dev-session"           ~/.local/bin/
```

Verify:

```bash
opencode-model-switch list
```

### 3. Install the OpenCode configuration (`opencode/`)

OpenCode reads its global configuration from `~/.config/opencode/` (it also
honors `$XDG_CONFIG_HOME/opencode`). Replace that directory with the contents
of `opencode/`:

> **Warning:** `opencode/opencode.json` and `opencode/agents/*.md` are
> overwritten by `opencode-model-switch`. Back them up before replacing if you
> already customized them.

```bash
# Preserve your existing setup if any
if [ -d ~/.config/opencode ]; then
  mv ~/.config/opencode ~/.config/opencode.backup-$(date +%Y%m%d-%H%M%S)
fi

mkdir -p ~/.config/opencode
rsync -a --exclude node_modules opencode/. ~/.config/opencode/
```

This intentionally excludes `node_modules/`; install plugin type dependencies
fresh only when you need them (optional, see next step).

### 4. Install plugin type dependencies (optional)

The notification plugin (`opencode/plugins/attention-notify.ts`) imports the
`@opencode-ai/plugin` package for its types. This is a development-time
dependency only — OpenCode loads the `.ts` file directly.

```bash
cd ~/.config/opencode
npm install
```

If you skip this, the plugin still runs; you just cannot type-check it with
`npx tsc --noEmit`.

### 5. Authenticate your providers

The configuration references models from several providers (see
[Model tiers](#opencode-model-switch-switching-model-tiers)). Log in to the
ones you want to use:

```bash
opencode auth login
```

Select your providers, then verify which agents resolve to real models:

```bash
opencode debug agent engineer
opencode debug agent explore
```

### 6. Verify the installation

From any project directory:

```bash
opencode debug config          # show resolved configuration (includes active model)
opencode-model-switch status   # shows models/variants per agent
```

If the models in `opencode-models.json` do not match your provider access, see
[Customizing](#customizing) before running your first session.

---

## What you get

### Agents

Five agents are defined in `opencode/agents/`. The `engineer` agent is the
primary agent; the rest are one-level-deep subagents that the engineer can
delegate to. Delegation is capped at depth 1 via `subagent_depth` in
`opencode.json`.

| Agent | Mode | Model tier | Steps | Purpose |
| --- | --- | --- | --- | --- |
| `engineer` | primary | main | 40 | Implements and debugs in the repository with approval gates |
| `advisor` | subagent | main | 5 | Read-only advisory work: decisions, drafts, memos |
| `review` | subagent | main | 6 | Read-only code review with exact file/line evidence |
| `explore` | subagent | small | 6 | Read-only repository exploration and convention lookups |
| `research` | subagent | small | 8 | Web-only research from primary/official sources |

The main tier is used by `engineer`, `advisor`, and `review`; the small tier by
`explore` and `research` — see
[`opencode-model-switch`](#opencode-model-switch-switching-model-tiers) for how
these are set and switched.

The `engineer` agent carries a working style derived from the repository's
`AGENTS.md`: inspect instructions before proposing changes, state a plan and
validation criteria, make the smallest coherent change, and review the diff
before handoff. It proactively delegates convention lookups to `explore`,
external documentation to `research`, and applies relevant skills like
`test-driven-development`, `systematic-debugging`, or
`verification-before-completion` without waiting to be prompted. It refuses
deployments, publishing, destructive git commands, and secret handling.

### Agent behavior and conventions

The `engineer` agent follows the installed `AGENTS.md` in addition to any
project-level instructions. It leads with results and tradeoffs, avoids broad
unrelated changes, and asks when a product or architecture choice materially
affects the result.

- **Capabilities and delegation.** Before substantive work, the agent selects
  the smallest relevant combination of skills and subagents. It uses
  `test-driven-development` for behavioral code changes,
  `systematic-debugging` for unexplained failures, and
  `verification-before-completion` before a completion claim. It delegates
  repository conventions to `explore` and external SDK or API documentation to
  `research`. Slash commands run only when you invoke them.
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

`opencode.json` installs a strict, denial-by-default permission policy:

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
  `review`, and `advisor`.
- `external_directory` access is denied; `websearch` is allowed, `webfetch`
  asks.
- `snapshot` is on, `share` is disabled, `autoupdate` is off, and the default
  `plan`/`build` agents are disabled — the `engineer` agent and the slash
  commands below replace them.
- `compaction` auto-prunes with a 12k-token reserve; the watcher ignores
  `.git`, `node_modules`, build/dist output, and virtualenvs.

The agent also applies safety rules that sit above the permission policy. It
works only inside the active repository or worktree, regenerates generated
files instead of editing them directly, leaves lock files unchanged unless a
dependency change requires them, preserves repository-mandated sections, and
reviews every edit diff before handoff.

### Skills

Skills are reusable expertise documents under `opencode/skills/`, loaded only
when the task matches their description. Skills are installed:

| Skill | When to use |
| --- | --- |
| `repository-research` | Tracing local code, seams, and conventions before a change |
| `technical-design` | Proposing/comparing architecture, APIs, and migrations |
| `systematic-debugging` | Diagnosing bugs, flakes, regressions, and recovery paths |
| `test-driven-development` | Changing behavior with a red-green-refactor test loop |
| `verification-before-completion` | Claiming completion with fresh, task-appropriate evidence |
| `frontend-design` | Planning UI hierarchy, states, responsive behavior, accessibility |
| `humanizer` | Removing AI-generated writing patterns from prose |
| `webapp-testing` | Repository-native Playwright test planning/execution |
| `agent-browser` | Approved exploratory browser QA on unauthenticated localhost |
| `product-discovery` | Evaluating problems, ICP, MVP scope, and validation experiments |
| `founder-decision` | Comparing consequential business options and decisive tests |
| `social-content` | Drafting truthful, channel-specific social/editorial content and blog posts from source material |
| `brand-guidelines` | Applying user-provided brand rules to artifacts |
| `github-cli-workflow` | Inspecting/preparing PRs, issues, checks, and workflow logs with `git`/`gh` |
| `skill-creator` | Creating/auditing OpenCode skills |
| `playwright-public-web` | Read-only inspection of explicitly approved unauthenticated public websites through Playwright MCP |
| `playwright-manual-auth` | Read-only inspection of approved login-required sites after the user authenticates in a headed isolated Playwright browser |

Each skill's `description` field defines its precise trigger and non-use cases.

### Slash commands

Commands live in `opencode/commands/` and are invoked in-session:

| Command | Agent | Purpose |
| --- | --- | --- |
| `/project-plan $ARGS` | engineer | Choose light, standard, or strict planning; bootstrap empty projects; create/revise plans; prepare branches and GitHub issues — without implementing |
| `/implement-next $ARGS` | engineer | Implement, validate, and review only the next unchecked task of one explicitly approved plan; stops after one task |
| `/review-diff $ARGS` | review | Review the working-tree diff or a Git range; actionable evidence-backed findings only |
| `/research-brief $ARGS` | research | Web-only research returning a dated, source-linked evidence brief |
| `/decision $ARGS` | advisor | Compare consequential options and return a concise decision memo |
| `/content-pack $ARGS` | advisor | Draft truthful, channel-specific unpublished content from supplied material |
| `/session-state` | engineer | Create/update the project's `SESSION_STATE.md` and ensure `AGENTS.md` has the `Session continuity` section |
| `/use-playwright $ARGS` | engineer | Configure an approved project-local Playwright MCP profile and ignored screenshot directory; restart OpenCode before use |
| `/git-release [version]` | engineer | Validate and preview one annotated tag and matching GitHub Release; writes an approved user-run release script |

For substantial work, the planning commands follow: plan → manual `Approved`
status → branch → implement one task → review. Light plans stop at an
in-session implementation brief. Nothing is committed, pushed, or deployed
without separate explicit approval.

Release examples:

```text
/git-release
/git-release patch
/git-release minor
/git-release major
/git-release v1.3.0
```

After explicit preview approval, `/git-release` writes an executable release
script inside Git metadata for the user to run manually. OpenCode never runs
the script; the global policy continues to deny `git push`.

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

## `opencode-model-switch`: switching model tiers

`bin/opencode-model-switch` swaps the main/small model tiers across providers
by rewriting `opencode.json` and the mapped agents' frontmatter. Each tier's
`agents.main` and `agents.small` lists in `opencode-models.json` are the single
source of truth for that mapping.

Tiers are defined in `opencode/opencode-models.json` (installed to
`~/.config/opencode/opencode-models.json`). The included tiers are:

| # | Name | Main model | Small model |
| --- | --- | --- | --- |
| 1 | openai | `openai/gpt-5.6-terra` | `openai/gpt-5.6-luna` |
| 2 | opencode-go | `opencode-go/deepseek-v4-pro` | `opencode-go/deepseek-v4-flash` |
| 3 | anthropic | `anthropic/claude-opus-4-8` | `anthropic/claude-sonnet-5` |
| 4 | openrouter | `openrouter/deepseek/deepseek-v4-pro` | `openrouter/deepseek/deepseek-v4-flash` |
| 5 | zen-free | `opencode/deepseek-v4-flash-free` | `opencode/north-mini-code-free` |

> These are the author's provider/model references — edit the file to match
> what *you* have authenticated with `opencode auth login`.

Usage:

```bash
opencode-model-switch list             # show all tiers
opencode-model-switch status           # show current models per agent
opencode-model-switch switch 2         # apply tier 2 (opencode-go)
opencode-model-switch delete-backups   # remove .bak files it created
```

What a switch does:

1. Sets `model` and `small_model` in `opencode.json`.
2. Rewrites `model`, `variant`, and `reasoningEffort` frontmatter in
   `engineer.md`, `advisor.md`, `review.md` (main tier) and `explore.md`,
   `research.md` (small tier) under `~/.config/opencode/agents/`.
3. Writes a timestamped `.bak` copy of every file before changing it, so you
   can roll back: `cp opencode.json.20260805-213000.bak opencode.json`.

Environment overrides:

- `OPENCODE_CONFIG_ROOT` — operate on a non-default config directory
  (default: `$XDG_CONFIG_HOME/opencode` or `~/.config/opencode`).
- `OPENCODE_MODELS_FILE` — use a tier definition file elsewhere.

Adding your own tier: add an entry to `opencode-models.json` with `name`,
`agents.main`, `agents.small`, `main.model`, `main.variant`, `small.model`, and
`small.variant`, then run `opencode-model-switch list`.

---

## Git worktree helpers

`bin/worktree-new` and `bin/worktree-close` create and tear down isolated git
worktrees for agent work, so a long-running AI session never touches your main
checkout.

`bin/dev-session` is an optional tmux session launcher. When available,
`worktree-new` invokes it to set up a 4-window layout: `edit` (nvim), `agent`
(`opencode --agent engineer), `test` (shell), and `git` (lazygit).

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

After creating the worktree, it runs `dev-session` with the worktree path and
`START_WINDOW` (default `agent`; one of `edit`, `agent`, `test`, `git`) when
the helper is installed. Otherwise it prints `dev-session is unavailable` and
the worktree path, then exits successfully. Direct `dev-session` invocation
defaults to `edit`.

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

### `dev-session PATH [START_WINDOW]`

```bash
dev-session ~/repos/my-project.worktrees/feature/auth-login edit
```

Creates (or attaches to) a named tmux session at the given path with four
windows and selects the `START_WINDOW`. If already inside tmux, it switches
client; if attached to a terminal, it attaches; otherwise it prints the session
name. The session name is derived from the repo name and branch (special
characters are sanitized for tmux).

---

## Customizing

This is an opinionated public template. Edit the installed copies at
`~/.config/opencode/` (not this repository) for day-to-day tweaks:

- **Models** — edit `opencode-models.json` (and your provider auth), or just
  set `model`/`small_model` in `opencode.json` directly.
- **Agents** — edit `agents/*.md` frontmatter (`model`, `steps`, `permission`)
  and body (system prompt). Agent bodies only replace the default prompt when
  the file has valid `---` frontmatter.
- **Permissions** — `opencode.json` → `permission`. Prefer tightening over
  loosening; the deny rules exist to keep AI sessions from touching secrets or
  doing irreversible things.
- **Skills / commands** — add `SKILL.md` folders under `skills/` and `.md`
  command files under `commands/`. OpenCode discovers them at startup.
- **Global instructions** — `opencode/AGENTS.md` (installed to
  `~/.config/opencode/AGENTS.md`) is the global instructions file that shapes
  every session. Per-project `AGENTS.md` files layer on top of it. See
  [Agent behavior and conventions](#agent-behavior-and-conventions) for the
  included workflow rules.
- **Plugin** — edit `plugins/attention-notify.ts`; type-check with
  `npx tsc --noEmit` inside `~/.config/opencode`. Restart OpenCode after
  plugin/skill changes — global extensions load at startup.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `opencode: command not found` | Install the CLI: `curl -fsSL https://opencode.ai/install | bash` |
| `opencode-model-switch: jq: command not found` | Install jq (`brew install jq`, `pacman -S jq`, `apt install jq`) |
| `Unknown or incomplete tier` | Run `opencode-model-switch list`; add/repair the tier in `opencode-models.json` |
| `model: null` / agent shows `?` | `opencode auth login` and fix the model IDs in `opencode-models.json` to match your access |
| Plugin type-check fails | Run `npm install` inside `~/.config/opencode` (the `@opencode-ai/plugin` types are a dev dependency) |
| No desktop notifications on macOS | The plugin uses `notify-send` (Linux). Replace it with `osascript -e 'display notification ...'` in `attention-notify.ts`, or leave the plugin file empty of handlers |
| `worktree-new` exits after creating the worktree | It execs `dev-session`. Make sure `dev-session` is installed to `~/.local/bin` and tmux/nvim/lazygit are available |
| `worktree-close` refuses to run | The worktree is not clean, you're inside it (`cd` out first), or the branch is not merged — check with `git status` / `git log origin/main..<branch>` / `gh pr list --head <branch> --state merged` |
| `dev-session` prints "required command not found" | Install the missing prerequisite: `tmux`, `nvim`, `opencode`, or `lazygit` |
| I broke `opencode.json` or an agent | Restore a `.bak` file written by `opencode-model-switch`, or re-copy from this repo |
| Changes to skills/commands don't appear | Restart OpenCode — global extensions load at startup |

---

## Notes and sources

- The skills and workflow patterns are adapted/audited from public sources
  (Addy Osmani's agent-skills, Superpowers, Anthropic's skills, Matt Pocock's
  skills, and Boris Tane's workflow) with licenses reviewed per skill. See
  `opencode/PLAN.md` (installed as `~/.config/opencode/PLAN.md`) for the
  canonical roadmap, per-item provenance, and licensing notes.
- This configuration deliberately does **not** include: autonomous
  commit/push/ship flows, GitHub MCP with write access, social posting,
  deployment/cloud/billing integrations, or global browser automation
  stacks — see the `Deferred` section of `PLAN.md`.
- The model IDs shown are examples from the author's environment. Substitute
  your own provider/model IDs.

## License

[MIT](./LICENSE)
