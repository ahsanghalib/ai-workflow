<!-- markdownlint-disable MD033 MD025 -->

<!-- Canonical SPEC starting point; substantive work is owned by
     `spec-workflow`. -->

# SPEC-0001 — <short title>

Use `spec-workflow` for substantive work. This is a reusable starting point,
not a project-init bootstrap output.

Status: Draft
Type: <one supported work type>

## Problem

<What problem exists, for whom, and what evidence supports it?>

## Goal

<Observable outcome this SPEC must achieve.>

## Requirements

- <The behavior that must exist.>

## Acceptance Criteria

- [ ] <Observable success or failure condition.>

---

# Execution

## Tasks

- [ ] TASK-001 — <first dependency-ready action>

## Validation

- <Focused command or inspection and the evidence it must produce.>

## Implementation Notes

<Short-lived decisions, blockers, and task evidence.>

Optional contract section examples (insert above `# Execution` only when
applicable):

```markdown
## Context / Evidence
<!-- Relevant repository, user, or research evidence. -->

## Non-goals
<!-- Explicit exclusions when scope could be confused. -->

## Constraints
<!-- User, product, compatibility, security, or operational constraints. -->

## Impact
<!-- API, persistence, frontend, security, or compatibility impact. -->

## Open Questions
<!-- Material user-owned decisions that must be resolved before approval. -->
```

Optional execution sections (add only when justified):

```markdown
## Technical Design
<!-- Approved or behavior-preserving design conclusions. -->

## Data Design
<!-- Persistence design when justified; prefer executable schema as structural
truth. -->

## Tracking
<!-- Verified, user-approved tracking references only. -->
```

## Task rules

- Keep tasks under this SPEC's `# Execution` → `## Tasks` section.
- Use local identifiers such as `TASK-001`, `TASK-002`, and `TASK-003`.
- The combined identity is `SPEC-####/TASK-###`; task numbers do not need to be
  globally unique across SPECs.
- Keep each task small, independently understandable, dependency ordered,
  verifiable, and scoped to one meaningful implementation action.
- Do not create a separate planning or execution document.
