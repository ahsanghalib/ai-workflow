# AI Workflow — OpenCode Configuration

A drop-in setup for the [OpenCode](https://opencode.ai) CLI: a global agent
system with layered agents, reusable skills, slash commands, strict safety
permissions, desktop notifications, model-tier switching, and git worktree
helpers.

This repository contains two folders:

| Folder | Purpose |
| --- | --- |
| [`bin/`](#2-install-the-helper-scripts-bin) | Shell scripts you can symlink or copy into `~/.local/bin` |
| [`opencode/`](#3-install-the-opencode-configuration-opencode) | The full OpenCode configuration, installed to `~/.config/opencode` on macOS/Linux |

Everything is plain text: Bash, JSON, Markdown, and one TypeScript plugin. No
background services, no daemons, no MCP servers.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [What you get](#what-you-get)
  - [Agents](#agents)
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

- **bash**, **git**, and standard coreutils — present on macOS and Linux by default.
- **[OpenCode CLI](https://opencode.ai/docs/)**: `curl -fsSL https://opencode.ai/install | bash`, or install via your package manager.
- **[jq](https://jqlang.github.io/jq/)** — required only by `opencode-model-switch`. (`brew install jq`, `pacman -S jq`, etc.)
- **Node.js** (optional) — only needed to type-check the notification plugin with `npx tsc --noEmit`.
- **`notify-send`** (Linux, part of `libnotify`) — required for desktop notifications from the plugin. On macOS, see [Troubleshooting](#troubleshooting).

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
```

Or link them so updates to this repo take effect automatically:

```bash
ln -s "$(pwd)/bin/opencode-model-switch" ~/.local/bin/
ln -s "$(pwd)/bin/worktree-new"          ~/.local/bin/
ln -s "$(pwd)/bin/worktree-close"        ~/.local/bin/
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
cp -R opencode/. ~/.config/opencode/
```

Do **not** copy `opencode/node_modules/` — it is git-ignored and not shipped with
this repo, so a fresh clone has none. If your local checkout happens to have
one, the `cp -R` above would carry it over; remove it after copying and
install dependencies fresh instead (optional, see next step):

```bash
rm -rf ~/.config/opencode/node_modules
```

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
before handoff. It delegates convention lookups to `explore` and refuses
deployments, publishing, destructive git commands, and secret handling.

### Permissions and safety model

`opencode.json` installs a strict, denial-by-default permission policy:

- **Everything asks first** (`"*": "ask"`), except `todowrite`, which is
  allowed.
- **Reads are broadly allowed** but hard-denied for secrets: `.env*`,
  `*.pem`, `*.key`, `.ssh/`, `.aws/`, `.kube/`, `auth.json`,
  `credentials.json`/`credentials.yml`, `secrets.json`, `*.tfvars`,
  `id_rsa`/`id_ed25519`, `.git-credentials`, and more.
- **Shell commands** default to ask; a long denylist blocks `sudo`/`doas`,
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

Each skill's `description` field defines its precise trigger and non-use cases.

### Slash commands

Commands live in `opencode/commands/` and are invoked in-session:

| Command | Agent | Purpose |
| --- | --- | --- |
| `/project-plan $ARGS` | engineer | Bootstrap empty projects; create/revise feature, bug, improvement plans; prepare branches and GitHub issues — without implementing |
| `/implement-next $ARGS` | engineer | Implement, validate, and review only the next unchecked task of one explicitly approved plan; stops after one task |
| `/review-diff $ARGS` | review | Review the working-tree diff or a Git range; actionable evidence-backed findings only |
| `/research-brief $ARGS` | research | Web-only research returning a dated, source-linked evidence brief |
| `/decision $ARGS` | advisor | Compare consequential options and return a concise decision memo |
| `/content-pack $ARGS` | advisor | Draft truthful, channel-specific unpublished content from supplied material |
| `/session-state` | engineer | Create/update the project's `SESSION_STATE.md` and ensure `AGENTS.md` has the `Session continuity` section |

The planning commands follow the pattern: plan → manual `Approved` status →
branch → implement one task → review. Nothing is committed, pushed, or
deployed without separate explicit approval.

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
by rewriting `opencode.json` and the agents' frontmatter.

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
`main.model`, `main.variant`, `small.model`, and `small.variant`, then run
`opencode-model-switch list`.

---

## Git worktree helpers

`bin/worktree-new` and `bin/worktree-close` create and tear down isolated git
worktrees for agent work, so a long-running AI session never touches your main
checkout.

### `worktree-new SLUG [BASE_REF]`

```bash
worktree-new my-feature
worktree-new my-feature origin/develop
```

Creates:

- a worktree at `<parent-of-repo>/<repo-name>.worktrees/my-feature/`
- a branch `agent/my-feature` based on `BASE_REF` (default `origin/main`)

The slug may contain only letters, numbers, dots, underscores, and dashes. If
the target path or branch already exists, it refuses to run. After creating
the worktree it launches `$HOME/.local/bin/dev-session` inside it.

> Note: `dev-session` is the author's own launcher (a shell alias/session
> wrapper), not part of this repository. If you don't have it, create it or
> replace that line — for example, drop the `exec` and just `cd` into the
> worktree.

### `worktree-close PATH [MERGED_INTO_REF]`

```bash
worktree-close ~/repos/my-project.worktrees/my-feature
worktree-close ~/repos/my-project.worktrees/my-feature main
```

Removes the worktree and deletes its branch, but only when:

- the worktree is not the main checkout,
- the working tree is clean,
- the branch is already merged into `MERGED_INTO_REF` (default `main`).

It refuses to run destructive removal (`worktree remove --force` is denied by
the global permission policy anyway).

---

## Customizing

This is a personal configuration distributed as a template. Edit the installed
copies at `~/.config/opencode/` (not this repository) for day-to-day tweaks:

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
  every session. Per-project `AGENTS.md` files layer on top of it.
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
| `worktree-new` exits after creating the worktree | It execs `$HOME/.local/bin/dev-session`, which is the author's launcher — create your own or remove the `exec` line |
| `worktree-close` refuses to run | The worktree is not clean or the branch is not merged into `main` — check with `git status` / `git log origin/main..agent/<slug>` |
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
