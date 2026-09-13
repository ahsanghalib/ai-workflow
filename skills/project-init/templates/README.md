# `<Project Name>`

## Overview

<!-- What the project does, who it is for, and the problem it solves. Keep
     product direction in MASTER_PLAN.md. -->

## Features

<!-- Keep this high-level. MASTER_PLAN.md owns the roadmap; detailed behavior
     belongs in docs/USER_FLOW.md and feature SPECs. -->

## Tech Stack

## Requirements

## Installation

## Configuration

Document required variable names and safe setup instructions only. Never create,
copy, read, print, or commit `.env` files or secret values. A secret-free
example file may be documented only when the project explicitly chooses to
maintain one.

## Development

## What the bootstrap creates

The project-init bootstrap creates the base project-control Markdown,
`.gitignore` when it is missing, the general engineering rule, reusable
templates, and empty documentation directories. After the project profile is
reviewed, select optional outputs such as `docs/USER_FLOW.md`, specialized
rules, or `.ai/prompts/`. `docs/DB_SCHEMA.md` is a separate step after
persistence and user-flow review. It does not create application source,
package manifests, framework files, migrations, models, services, routes, UI,
Docker, deployment files, or secret values. Those belong to a reviewed SPEC,
an approved PLAN, and the later implementation workflow. For an existing
project, select approved missing outputs individually; do not run the full
new-project bundle beside an established planning or instruction layout.

## Testing

## Build

## Repository Structure

```text
<fill after bootstrapping the real project>
```

## Architecture

<!-- High-level only. Use docs/PROJECT_ARCHITECTURE.md when detailed
     architecture is justified. -->

## Documentation

- [Master Plan](./MASTER_PLAN.md)
- [Project Architecture](./docs/PROJECT_ARCHITECTURE.md)
- User Flow: add `docs/USER_FLOW.md` when actor or system journeys apply.
- Database Schema: add `docs/DB_SCHEMA.md` only after persistence is approved
  and the user-flow contract has been reviewed.
- Engineering Rules: `docs/rules/GENERAL.md` is always applicable; add
  specialized rules only when the project profile requires them.
- [Specifications](./docs/specs/)
- [Implementation Plans](./docs/plans/INDEX.md)

## AI Helper Prompts

If the project selects the optional helper library, prompts are available under
`.ai/prompts/`. Read only the prompt needed for the current request; it routes
to the existing skills and does not replace them or authorize work by itself.
`.ai/` is intentionally tracked and is not a secret store.

## Project-Control Workflow

1. `MASTER_PLAN.md` records product direction, scope, outcomes, and decisions.
2. `docs/USER_FLOW.md` describes how actors use the product.
3. When persistence is needed, `docs/DB_SCHEMA.md` is the first technical
   contract for data that APIs and frontend features follow.
4. Feature SPECs define required behavior and must be reviewed.
5. PLANs define implementation tasks and must be explicitly approved.
6. Implement only the next approved task, then validate and update
   `SESSION_STATE.md`.

Project-init preserves existing documents and asks before revising them. It
does not scaffold application code, install frameworks, create migrations, or
run remote Git operations. Local `git init` is a separate approval; the
initializer never creates a commit or remote.
