---
name: verification-before-completion
description: Use before claiming a task is complete, fixed, correct, ready, or safe to merge. Select fresh, task-appropriate evidence and report verified, partial, unverified, and blocked work precisely.
license: MIT; adapted from Superpowers verification and Addy Osmani definition-of-done concepts; see upstream metadata
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  upstream-superpowers: https://github.com/obra/superpowers/tree/44c9b2d6e889982ac18c27d05a19fefe335194e1/skills/verification-before-completion
  upstream-addy: https://github.com/addyosmani/agent-skills/tree/bdf76c7c6b7b3b3e01bb15c9fdc42ac5351855c1
  upstream-license: MIT
  modified-for: OpenCode
---

# Verification Before Completion

Match every completion claim to fresh evidence. A passing command proves only
what that command checks; it does not prove unrelated requirements.

## Hard rules

- Do not claim completion, correctness, a fix, readiness, or safety without
  evidence gathered after the final relevant change.
- Do not treat a prior run, partial output, skipped check, unavailable tool, or
  denied permission as a passing result.
- Do not invent commands, services, credentials, fixtures, or browser tooling.
- Do not run destructive, privileged, production, publishing, or networked
  checks without explicit approval.
- Inspect the final diff and report untested paths, assumptions, and residual
  risk even when all selected checks pass.

## 1. Define claims and acceptance evidence

List the requested outcomes and map each to the narrowest proving evidence:

| Claim | Evidence | Status |
| --- | --- | --- |
| <requested behavior> | <fresh command, inspection, or source evidence> | pending |

Classify the task before selecting checks: code, UI, configuration, documentation,
research/design, or release. A task may have more than one class.

## 2. Select proportionate checks

Use repository instructions, existing scripts, CI configuration, and nearby
tests as the source of truth. Run targeted checks first; broaden only when the
change, failure mode, or repository policy justifies it.

- **Code:** reproduce the behavior where possible; run targeted tests, then
  relevant type, lint, build, or integration checks.
- **UI:** verify the affected state, responsive behavior, keyboard/focus and
  accessibility expectations, errors, and visual evidence using the existing
  project browser/test setup.
- **Configuration:** parse or schema-check the changed format, run its documented
  checker, and use a safe preview rather than applying side effects.
- **Documentation:** verify factual claims against primary sources, changed links,
  commands, filenames, and examples without executing unsafe instructions.
- **Research/design:** verify citations, path/line evidence, fact-versus-inference
  labels, assumptions, and open questions; do not present a proposal as tested.
- **Release:** require explicit approval and repository-specific release evidence;
  never imply deployment, publishing, monitoring, or rollback verification ran
  when it did not.

If a needed check is unavailable, blocked, too expensive, or requires approval,
record it as such and state the safest next action. Do not silently substitute a
weaker check.

## 3. Gather fresh evidence

Run or inspect the selected evidence after the last relevant edit. Read failures
and material warnings; do not summarize a failure as a pass. When a command is
too broad for the task, explain why it was not run instead of guessing.

Inspect the complete final diff for unintended changes, generated files, secrets,
compatibility concerns, and missing tests. Never print credential-bearing data;
redact sensitive output and state the resulting verification limitation.

## 4. Report the actual outcome

Use this completion report:

```markdown
## Verification

| Claim | Evidence | Result |
| --- | --- | --- |

## Checks Run

- `<command or inspection>` — passed / failed / partial

## Not Run or Blocked

- `<check>` — why it was not run and the required next action

## Diff Review

## Untested Paths and Residual Risk
```

Use **verified** only when the mapped evidence supports the claim. Use
**partial**, **unverified**, or **blocked** otherwise. Never turn a verification
report into a commit, merge, deployment, or publish action without separate
approval.
