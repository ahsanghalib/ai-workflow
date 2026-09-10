# agent-browser core workflow

Read this reference for sessions, navigation, snapshots, interactions,
artifacts, or simple browser actions.

## Session isolation

Always use a task-owned named session rather than the shared default session.
Use one session per logical task and separate sessions for parallel work. The
session must remain stable across the whole workflow, including when commands
are issued by separate harness calls. With a POSIX shell whose environment
persists, the installed core workflow is equivalent to:

```bash
export AGENT_BROWSER_SESSION="$(
  agent-browser session id --scope worktree --prefix task
)"
```

If the harness has no worktree concept, use the installed command's supported
`cwd` or `git-root` scope, or an explicit unique session name.

If shell state does not persist, save the generated id in the harness's task
context and pass `--session <id>` to every CLI command. In a typed integration,
use its session argument or equivalent. Never fall back to the shared default
just because an environment variable was lost between calls.

Start fresh by default. Use restore, state, profile, CDP, or another persistent
browser context only when the task needs it and that scope is authorized.
Close the session when finished unless persistence is intentional:

```bash
agent-browser close
```

## Core interaction loop

Use the installed core workflow. The essential pattern is:

```bash
agent-browser open <url>
agent-browser snapshot -i
# inspect refs
agent-browser click @e3
agent-browser wait --url "**/expected"
agent-browser snapshot -i
```

Rules:

1. Snapshot before interacting with unknown UI.
2. Treat snapshot refs as scoped to the current snapshot. Re-snapshot after
   navigation, submission, dialogs, or meaningful rerenders.
3. Prefer observable waits—URL, text, selector, hidden state, or load
   state—over arbitrary sleeps.
4. Prefer targeted extraction and scoped, compact snapshots over dumping a
   whole page.
5. Use structured output such as `--json` when it improves reliability.
6. Inspect screenshots before making visual claims.
7. Never reuse stale refs after a page-changing action.

## Artifacts and simple actions

Create screenshots, PDFs, traces, videos, HARs, or reports only when useful.
Use temporary paths for disposable evidence. For retained project evidence,
prefer:

```text
<project-root>/.agent-browser/<task>/
```

Before retaining project-local artifacts:

- ensure `.agent-browser/` is ignored or intentionally tracked;
- review sensitive artifacts before keeping them;
- never commit auth state, cookies, credentials, or sensitive HAR content.

When an artifact is disposable, prefer the harness's temporary-artifact
facility or an OS-appropriate temporary directory. If the harness cannot
write files, report the limitation and use observable command output or an
in-memory result where supported.

Use explicit output paths for artifacts that must survive the browser session.

For a simple browser action, report the target, action, result, and any
material limitation. Do not force a QA report onto a one-step action.

## Specialized workflows

Use `agent-browser skills list` as the authoritative catalog, then load the
matching installed skill before using a specialized mode. Use the interface's
documented load/get operation; for the CLI this is typically
`agent-browser skills get <name>`. Do not copy a specialized skill name or
command from another installation. Specialized instructions override generic
examples here.
