# Project-plan templates

Use these templates as adaptable schemas. Merge with existing documents rather
than replacing user-authored structure.

## `PROJECT_ARCHITECTURE.md`

```markdown
# Project Architecture

## Project Overview
## Users and Use Cases
## Goals
## Non-Goals
## Decision Status and Evidence
### Confirmed Requirements
### Research Suggestions
### Assumptions
### Recommended Decisions
### Unresolved Questions and Approval Gates
## Functional Requirements
## Quality Attributes
## Technology Stack
## Provider and Stack Decision
## Repository Structure
## Components and Boundaries
## Data Model
## Data Flow
## External Integrations
## Authentication and Authorization
## Environments
## Local Development and Emulation
## Branch and Promotion Model
## Migration and Release Flow
## Build and Tooling
## Testing Strategy
## CI/CD
## Deployment
## Observability
## Security and Privacy
## Accessibility and Browser Support
## Performance and Availability
## Documentation
## Open Questions
## Architecture Decisions
```

Keep current architecture here, not task-level implementation detail. The root
`AGENTS.md` should link to it, `PLANS.md`, and `SESSION_STATE.md` without
duplicating their contents.

## `PLANS.md`

```markdown
# Project Plans

## Active
| ID | Title | Type | Status | Dependencies | Branch | GitHub | Updated |
| --- | --- | --- | --- | --- | --- | --- | --- |

## Completed
## Cancelled
```

Allowed types: `Feature`, `Bug`, `Improvement`. Allowed statuses: `Proposed`,
`Approved`, `In Progress`, `Blocked`, `Completed`, `Cancelled`. New plans start
as `Proposed`.

## `plans/PLAN-NNNN.md`

```markdown
# PLAN-NNNN: Title
**Type:** Feature | Bug | Improvement
**Status:** Proposed
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Branch:** Not created
**GitHub:** Not created

## Goal
## Context
## Decision Status and Evidence
### Confirmed Requirements
### Research Suggestions
### Assumptions
### Recommended Decisions
### Unresolved Questions and Approval Gates
## Scope
## Non-Goals
## Architecture Impact
## Environments and Local Development
## Migration and Release Flow
## Decisions
## Acceptance Criteria
## Task Groups
## Dependencies
## Risks
## Validation
## Rollback
## Open Questions
## Activity
```

Use stable task IDs within groups, for example:

```markdown
### Group 1: Domain model
- [ ] TASK-0001: Define the domain entities.
- [ ] TASK-0002: Add repository behavior and tests.
```

Update `Updated` only when content changes. Approval requires the user to
change `**Status:** Proposed` to `**Status:** Approved` manually.
