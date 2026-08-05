---
description: Review a working-tree diff or specified Git range and report only actionable, evidence-backed findings.
agent: review
---

Review this diff scope or Git range:

```text
$ARGUMENTS
```

## Review contract

- If no scope is supplied, review the current working-tree diff. If a scope is
  supplied, verify it is a valid local Git diff range before reviewing it.
- Inspect only the requested diff and the minimum adjacent code needed to assess
  it. Do not edit files, run tests, fetch, access external resources, or change
  Git state.
- Report actionable correctness, security, performance, regression, compatibility,
  concurrency, error-handling, and maintainability findings only. Do not restate
  the diff or invent findings.
- Order findings by severity. Every finding must include a concise title, exact
  file and line evidence, impact, and a concrete remediation direction.
- If there are no actionable findings, say so in one sentence. Then list only
  concise residual risks and testing gaps.
- Do not approve, merge, commit, push, publish, deploy, or modify the reviewed
  work. The user retains every follow-up decision.
