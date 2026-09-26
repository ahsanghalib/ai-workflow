# `<Project Name>`

## Overview

<!-- What the project does, who it is for, and the problem it solves. -->

## Features

<!-- Keep this high-level. Substantive behavior belongs in a SPEC. -->

## Tech Stack

## Requirements

## Installation

## Configuration

Document required variable names and safe setup instructions only. Never create,
copy, read, print, or commit `.env` files or secret values. A secret-free
example file may be documented only when the project explicitly chooses to
maintain one.

## Development

## Testing

## Build

## Repository Structure

```text
<fill after the real project exists>
```

## Architecture

<!-- Add durable architecture documentation only when complexity justifies it. -->

## Documentation

The default project-init controls are `AGENTS.md`, `SESSION_STATE.md`,
`.ai/memory/`, and `docs/specs/`. Add links here only for documents that the
project actually creates or adopts. Existing legacy roadmaps, user-flow,
schema, architecture, decision, review, and rule files remain user-owned and
optional.

## Project-Control Workflow

1. `project-init` bootstraps or reconciles the minimal project controls.
2. A feature, bug, improvement, refactor, performance, security, migration,
   maintenance, or technical-debt request hands off to `spec-workflow` for a
   SPEC and execution details.
3. `spec-review` reviews the behavioral contract before explicit user approval.
4. `implement-next` executes one bounded approved SPEC task when available.
5. `SESSION_STATE.md` records the current active SPEC/task and handoff.

Existing roadmaps, architecture, flow, schema, decision, review, and rule
documents are preserved when present, including projects that use older
filenames. They are not renamed, created, or required by default. New shared
documents use the lowercase `docs/` convention; consequential ADRs use
`docs/decisions/<adr>.md` when justified. Normal work uses one approved SPEC
with execution tasks below `# Execution`.

Project-init does not scaffold application source, install frameworks, create
migrations, or run remote Git operations. Local `git init` is a separate
approval; the initializer never creates a commit or remote.
