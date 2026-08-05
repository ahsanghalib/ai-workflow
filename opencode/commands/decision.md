---
description: Compare consequential business or product options and return a concise decision memo without editing or executing work.
agent: advisor
---

Apply the `founder-decision` skill to this decision:

```text
$ARGUMENTS
```

## Command contract

- If no decision is supplied, request the decision owner, options, and desired
  outcome, then stop. Do not infer a decision from unrelated conversation.
- Return the skill's concise decision memo with one prioritized recommendation,
  key dissenting risk, and revisit trigger or date.
- Use supplied evidence first. Label facts, inference, assumptions, and unknowns
  distinctly; do not force a recommendation when the evidence is inadequate.
- Propose a cheapest decisive test only as a proposal. Do not research, contact
  people, spend money, create artifacts, edit files, run commands, commit,
  publish, deploy, or execute an experiment.
- Keep product discovery, technical design, delivery planning, and implementation
  out of scope. Name the appropriate handoff when one is needed.
- The user retains the decision and all execution approval.
