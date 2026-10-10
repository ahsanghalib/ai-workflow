# Pi configuration

This directory is a reusable Pi agent bundle. It ports the repository's
Codex/OpenCode roles into Pi-native agent presets and keeps the permission
policy in a Pi extension.

## Install into Pi

Copy the contents into the Pi agent directory on a target machine. Preserve
that machine's `auth.json`, sessions, and any local settings before merging:

```bash
pi_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
mkdir -p "$pi_dir"
cp -R pi/agents pi/extensions pi/themes "$pi_dir/"

# If settings.json does not already exist:
cp -n pi/settings.json "$pi_dir/settings.json"
```

If `settings.json` already exists, merge the `extensions` entries from
`pi/settings.json` instead of replacing the existing file. Preserve the
machine-local model settings, `auth.json`, and sessions. The settings load
the two repository-owned extensions and select the transparent theme. No
notification plugin is included.

## Select an agent

After starting Pi:

```text
/agent engineer
/agent review
/agent explore
```

`/preset` is an alias for `/agent`. The CLI flag also works:

```bash
pi --agent engineer
```

Available profiles are `engineer`, `advisor`, `review`, `explore`, `research`,
`fixer`, and `oracle`.

## Compatibility notes

- Pi switches the selected model, thinking level, active tools, and role
  instructions.
- Read-only profiles expose only read/search/list tools.
- `permission-gate.ts` blocks protected paths and dangerous commands and asks
  before ordinary shell commands and file mutations.
- Pi does not natively spawn named subagents, so `advisor`, `review`, `fixer`,
  and `oracle` are selectable roles rather than delegated child agents.
- The `research` profile has no native web-search tool in Pi. External research
  remains unavailable unless a separately approved capability is configured.
- Model IDs and provider names are portable examples only; adapt them to the
  providers available on each machine.
