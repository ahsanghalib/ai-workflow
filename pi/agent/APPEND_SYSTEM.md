# Pi workflow routing

Use the existing roles `engineer`, `advisor`, `explore`, `research`, `review`,
`fixer`, and `oracle` when `pi-subagents` is installed. They are defined in
`~/.pi/agent/agents/` and deliberately have no hard-coded model IDs.
Only delegate when the scope warrants another context/skill; default to the
current session for routine changes. For planned work, use the existing
`spec-workflow` and `implement-next` skills if imported, not a parallel spec format.

Agent profiles are loaded by `pi-subagents`, not by core Pi. An unavailable
extension is not an authorization to bypass approval rules.

Treat unattended/scheduled Pi runs as read-only audits by default. No writes,
network mutation, or secrets in scheduled prompts without an explicit reviewed
security model and run-specific authorization. Always distinguish recommendations
from actions executed.
