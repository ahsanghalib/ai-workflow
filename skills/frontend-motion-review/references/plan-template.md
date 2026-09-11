# Motion improvement plan template

Copy this structure once for each selected finding. Replace every placeholder;
the executor must not need the audit conversation for context.

```markdown
# NNN — short title

Status: TODO
Baseline commit: <short commit>
Severity: HIGH | MEDIUM | LOW
Location: <exact file:line or symbol>

## Problem

<Observed behavior, user impact, and why it is not an intentional exception.>

## Current evidence

```text
<short exact excerpt with enough surrounding context>
```

## Target behavior

<Precise result. Include exact properties, curve, duration, spring, origin,
reduced-motion behavior, and pointer/keyboard behavior where applicable.>

## Implementation steps

1. <Exact file and change.>
2. <Exact file and change.>
3. <Preserve or update the existing token/primitive.>

## Scope boundaries

- Do not change: <unrelated files or behavior>.
- Dependencies: <existing dependency or none>.
- Approval required for: <new dependency, network, or external mutation>.

## Verification

- [ ] Run: <targeted test or parser check>.
- [ ] Confirm: <reduced-motion, keyboard, focus, and hover behavior>.
- [ ] Feel-check: <slow motion, frame-by-frame, or device check>.
- [ ] Review the final diff and record any unrun checks.
```
