---
name: founder-decision
description: Use when comparing consequential business or product options, reversibility, downside, opportunity cost, and a cheapest decisive test. Do not use for product discovery, technical design, delivery planning, or open-ended research.
license: MIT; adapted from Matt Pocock's grilling and wayfinder workflows; see upstream metadata
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  upstream: https://github.com/mattpocock/skills/tree/2ab958093e83e0ec752e6c1c5932da465bf23e0c/skills
  upstream-license: MIT
  modified-for: OpenCode
---

# Founder Decision

Compare consequential options and recommend a decision while keeping the choice
with the user. Use available evidence; label assumptions and inference clearly.
This skill is stateless and produces no durable artifact unless separately
requested and approved.

## Boundaries

- Do not discover a customer problem or validate demand; use `product-discovery`
  when those inputs are unknown.
- Do not choose architecture, APIs, schemas, technologies, or implementation
  trade-offs; use `technical-design` for those choices.
- Do not create tickets, milestones, estimates, assignments, or delivery plans;
  use `/project-plan` after a decision.
- Do not become an open-ended research workflow. Consume cited evidence or
  propose a focused research question when a fact is unknown.
- Do not commit, publish, purchase, deploy, contact users, modify files, or run
  a test, prototype, or experiment without explicit approval.

## Decision workflow

### 1. Frame the decision

State the decision, decision owner, desired outcome, deadline, and options in
scope. Define what is explicitly out of scope. Resolve parent decisions before
dependent ones.

Classify each viable option as reversible, costly to reverse, or irreversible.
Ask one focused question at a time only when its answer can change the decision
or the next question. Offer a working hypothesis, not a disguised decision.

### 2. Build the decision ledger

For each option, capture:

- Constraints and non-negotiables.
- Evidence, source, recency, and confidence.
- Assumptions, unknowns, and evidence that would change the view.
- Upside, downside, failure modes, and mitigation.
- Opportunity cost: what is delayed, forgone, or made harder.
- Switching cost and consequences of being wrong.

Separate observed facts from inference. Do not pretend precision where evidence
is weak.

### 3. Propose the cheapest decisive test

When uncertainty blocks a decision, propose the smallest reversible test that
could resolve it. State the uncertainty, method, cost, duration, expected
signal, continue threshold, and kill or pivot threshold.

A test is a proposal only. Request explicit approval before researching,
building, contacting anyone, spending money, or otherwise executing it.

### 4. Recommend and pause

Return a concise decision memo:

```markdown
## Decision

## Options and Reversibility

## Constraints

## Evidence and Confidence

## Assumptions and Unknowns

## Downside and Opportunity Cost

## Recommendation

## Cheapest Decisive Test

## What Would Change This Decision

## Required Approval and Revisit Date
```

Give one prioritized recommendation, its key dissenting risk, and a revisit
date or trigger. If evidence is insufficient, recommend the cheapest decisive
next question or test instead of forcing a decision. Stop before execution.
