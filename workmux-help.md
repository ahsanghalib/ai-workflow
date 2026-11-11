An opinionated workflow tool that orchestrates git worktrees and tmux

Usage: workmux <COMMAND>

Worktree lifecycle:
  add          Create a new worktree and tmux window
  remove       Remove a worktree, tmux window, and branch without merging [rm]
  rename       Rename a worktree, tmux window/session, and optionally branch
  merge        Merge a branch, then clean up the worktree and tmux window
  rebase       Rebase a worktree branch onto its base branch
  open         Open a tmux window for an existing worktree
  close        Close a worktree's tmux window (keeps the worktree and branch)
  resurrect    Restore worktree windows after a tmux or computer crash

Monitoring:
  dashboard    Show a TUI dashboard of all active workmux agents
  sidebar      Toggle a live agent status sidebar in tmux
  list         List all worktrees [ls]
  path         Get the filesystem path of a worktree
  status       Query agent status for worktrees

Setup and configuration:
  init         Generate example .workmux.yaml configuration file
  setup        Set up agent status tracking hooks and install skills
  config       Manage global configuration
  sandbox      Manage sandbox settings
  sync-files   Re-apply file operations (copy/symlink) to worktrees
  claude       Claude Code integration commands

Agent interaction:
  send         Send a prompt or instruction to a running agent
  capture      Capture terminal output from a running agent
  wait         Wait for agents to reach a target status
  run          Run a command in a worktree's window
  reap-agents  Exit tracked agent processes older than a configured age

Help and updates:
  docs         Show detailed documentation (renders README.md)
  changelog    Show the changelog (what's new in each version)
  update       Update workmux to the latest version
  completions  Generate shell completions
  help         Print help for a command

Options:
  -h, --help     Print help
  -V, --version  Print version

Run 'workmux docs' for detailed documentation.
