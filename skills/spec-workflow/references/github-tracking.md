# Optional GitHub Tracking

GitHub is an optional tracking layer, never the requirements source of truth.
The repository SPEC remains authoritative for behavior, acceptance criteria,
design decisions, and execution evidence.

This guidance remains harness-agnostic. Do not assume GitHub API access,
GitHub MCP/plugin access, an authenticated `gh`, network access, permission to
create Issues or Projects, or permission to mutate remote state.

## Mapping

One SPEC may map to zero, one, or multiple GitHub Issues. Use an Issue when
the work needs shareable or actionable remote coordination. Keep the Issue
small enough to act on and link to the exact repository SPEC; do not copy the
entire SPEC into every Issue. Do not create an Issue solely because a SPEC
exists; no remote mapping is a valid outcome.

Use a GitHub Project only as a dashboard or portfolio view. Do not create or
require one during `project-init`. Use it when the user requests it, the
repository already uses it, or an authorized workflow explicitly chooses it.
It does not own requirements, architecture, data design, SPEC status, approval,
or completion. Keep the default Project model simple unless the project already
has a justified convention:

```text
Backlog → Ready → In Progress → Review → Done
```

Optional fields are limited to those that help the requested dashboard, such
as:

```text
Type
Priority
SPEC
Area
```

Avoid adding estimates, story points, iterations, roadmaps, milestones, or
automations merely because a Project supports them.

## SPEC tracking section

Record verified remote references, when they exist, under the SPEC's
`# Execution` → `## Tracking` section. A reference may include:

```text
Issue(s): <verified issue URLs or IDs>
Project: <verified project URL or ID>
Pull Request: <verified PR URL or ID>
```

Leave a field absent or explicitly unset when no verified reference exists. Do
not invent issue numbers, URLs, project IDs, PR IDs, labels, or remote status.

## Capability and approval boundary

The local SPEC workflow and its core contract tests must remain fully usable
without GitHub, live credentials, network access, authentication, GitHub CLI,
MCP, or another provider integration. Before any remote mutation, both a
verified capability and verified user authorization are required:

1. verify that an authorized capability is available for the target;
2. verify that the user requested or explicitly approved the exact mutation;
3. prepare the exact target, title/body or fields, and intended operation;
4. use the available official or project-approved adapter; and
5. verify the resulting reference without exposing credentials.

If a capability or approval is missing, leave tracking unset and report the
limitation. Do not emulate a remote mutation with an invented shell command or
write fake tracking data into the SPEC. Do not invent fake tool contracts or
shell behavior to make an unavailable integration appear available.

For GitHub CLI-specific inspection or an explicitly approved GitHub action,
hand off to `github-cli-workflow` or the repository's documented adapter. This
reference itself never calls a remote service or changes remote state.
