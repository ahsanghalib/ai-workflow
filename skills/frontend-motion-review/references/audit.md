# Motion audit playbook

Use this reference in audit mode. It is read-only guidance for producing
evidence-backed findings and plans.

## Categories

1. **Purpose and frequency** — why does it animate, and how often is the action
   used?
2. **Easing and duration** — does timing match the interaction and project
   tokens?
3. **Physicality and origin** — does the movement have a believable source,
   destination, scale, and transform origin?
4. **Interruptibility** — can the user reverse or retrigger it without a jump?
5. **Performance** — does it avoid avoidable layout work, broad transitions,
   and per-frame style recalculation?
6. **Accessibility** — are reduced motion, focus, pointer, keyboard, and
   semantic interaction handled?
7. **Cohesion and tokens** — does it fit the product personality and existing
   design system?
8. **Missed opportunities** — is there a rare or meaningful state change where
   a small amount of motion would improve comprehension?

## Recon questions

Record the answers before judging code:

- Which framework and motion libraries are actually present?
- Where are easing, duration, spring, and reduced-motion tokens defined?
- Which components contain keyframes, transitions, animation props, or gesture
  handlers?
- Which interactions occur constantly, occasionally, or rarely?
- Is the product playful, editorial, operational, or otherwise constrained?
- Which design decisions or exceptions are already documented?

## Findings

Use one table ordered by leverage, impact divided by effort:

| # | Severity | Category | Location | Evidence and finding | Fix summary |
| --- | --- | --- | --- | --- | --- |
| 1 | HIGH/MEDIUM/LOW | category | `file:line` | exact current behavior | precise change |

Severity guidance:

- **HIGH** — feel-breaking easing, high-frequency motion, dropped-frame risk,
  or `scale(0)`;
- **MEDIUM** — wrong origin, non-interruptible dynamic UI, or missing reduced
  motion; and
- **LOW** — token consolidation or polish such as a justified stagger.

After the findings, list 2–4 missed opportunities separately. They are
additive suggestions, not defects.

## Plan rules

Re-read every cited location before writing a plan. Reject by-design behavior,
duplicates, stale line numbers, and values without current evidence. A plan
must include exact target values from `standards.md`, the repository's existing
conventions, hard scope boundaries, and a verification section covering code,
rendered feel, and accessibility.
