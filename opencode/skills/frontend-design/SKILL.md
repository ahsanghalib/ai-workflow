---
name: frontend-design
description: Use when planning a frontend page, component, layout, responsive behavior, UI state, accessibility contract, or visual QA. Do not use for brand identity creation, dependency selection, browser automation, implementation, or code review.
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  anthropic-source: https://github.com/anthropics/skills/tree/decdff43d05908b4c1fc2cfd2d80fc5743440934/skills/frontend-design
  anthropic-license: Apache-2.0
  addy-source: https://github.com/addyosmani/agent-skills/tree/ad64ed29cdfeed9b7ecdd535db34cf98379041ae/skills/frontend-ui-engineering
  addy-license: MIT
  modified-for: OpenCode
---

# Frontend Design

Produce a project-grounded UI design brief before implementation. Prioritize
clear hierarchy, accessible interaction, responsive behavior, and existing
design-system conventions over novelty.

## Precedence and boundaries

Apply guidance in this order:

1. Existing project brand assets, design tokens, components, accessibility
   conventions, and content guidelines.
2. Existing framework, dependencies, and repository constraints.
3. The user's explicit brief and acceptance criteria.
4. This skill's design and accessibility guidance.

- Do not invent or replace a brand identity. Ask for brand guidance or provide
  neutral, clearly labelled options when the project has none.
- Do not implement, refactor, install dependencies, start processes, open a
  browser, take screenshots, or run audits without explicit approval.
- Do not perform code review; use `review` for completed-change review.
- Do not claim visual, responsive, or accessibility verification without fresh
  evidence from the approved project tooling.

## Design workflow

### 1. Frame the page or component

State the audience, user job, page or component purpose, primary action,
information hierarchy, content assumptions, and success condition. Identify the
existing design-system components and tokens to reuse before proposing anything
new.

For requests such as “polished” or “distinctive,” identify the specific product
or audience quality to express. Avoid generic gradients, cards, rounded corners,
placeholder copy, or decorative effects unless the project system supports them
and they serve the hierarchy.

### 2. Define the visual and structural plan

Describe:

- Content hierarchy, key sections, and a compact wireframe or component tree.
- Existing or proposed token usage for color, typography, spacing, elevation,
  borders, and motion.
- Component composition, responsibilities, and state ownership at a level that
  respects the current framework rather than assuming React or a specific store.
- Realistic user-facing copy, labels, actions, and outcomes.

If the project has no visual system, offer restrained alternatives and wait for
approval before creating a new direction or signature visual treatment.

### 3. Specify interaction and state contracts

For every important interaction, define loading, success, empty, error,
disabled, permission-denied, and retry behavior where applicable. Error states
must explain what happened and provide a useful next action. Avoid optimistic
updates unless the data model, rollback behavior, and user impact justify them.

Specify responsive behavior at 320, 768, 1024, and 1440 px: reflow, visibility,
navigation, touch targets, density, and overflow behavior. Mobile is a first
class layout, not a scaled desktop view.

### 4. Define the accessibility contract

Include semantic HTML, heading order, labels and accessible names, keyboard
operation, visible focus, focus management, contrast, non-color state cues,
screen-reader announcements, reduced motion, text resizing, and form-error
handling as relevant. Use buttons for actions and links for navigation.

State any accessibility uncertainty instead of assuming a component is
accessible because of its visual appearance.

### 5. Plan approval-gated visual QA

Return the manual and automated checks appropriate to the existing project:

- Required states and viewport matrix.
- Keyboard and focus traversal.
- Screen-reader and semantic checks.
- Console, network, and visual/screenshot evidence.
- Existing accessibility or browser-test commands, if any.

Request approval before starting a server or browser, attaching to a profile,
installing audit tooling, or running tests. Use
`verification-before-completion` after implementation for fresh evidence.

## Design brief

```markdown
## User Goal and Hierarchy

## Existing System and Constraints

## Layout, Components, and Tokens

## Interaction and State Matrix

## Responsive Behavior

## Accessibility Contract

## Visual QA Plan

## Open Questions and Required Approval
```

Stop at the approved brief. Hand implementation to an approved engineering
workflow and completed-change review to `review`.
