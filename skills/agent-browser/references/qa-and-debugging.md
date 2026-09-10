# agent-browser QA and debugging

Read this reference for exploratory QA, dogfooding, bug reproduction,
console/network evidence, or CLI diagnostics.

## QA and dogfooding

For requests such as “test this page,” “review the app,” “find UI bugs,” or
“reproduce this issue”:

1. Read relevant project instructions and existing development/test scripts
   when the target is a local or repository-owned application.
2. Reuse an already-running target when practical and authorized.
3. A request to QA an application authorizes following its documented local
   development-server workflow when the repository permits it; follow the
   repository's approval policy before starting or reusing the server, and do
   not substitute a remote target. For an external target, use only the origin
   and account context in the user's request.
4. Do not install dependencies or change project configuration merely to start
   the app unless the task explicitly requires that change.
5. Load the installed specialized QA skill when one exists.
6. Test the requested happy path first, then relevant edge cases.
7. Reproduce suspected bugs before reporting them when practical.
8. Distinguish application failures from browser, CLI, and environment
   failures.
9. Collect only the evidence needed to support findings.
10. If a bug is fixed, add or recommend a repository-owned regression test when
    appropriate.

A useful finding includes severity, reproduction, expected behavior, actual
behavior, and the minimum supporting evidence. Do not inflate minor subjective
visual preferences into defects.

## Evidence escalation

Escalate evidence instead of collecting everything up front:

1. accessibility snapshot;
2. targeted state, text, or attribute checks;
3. console errors;
4. relevant network requests or responses;
5. screenshot or annotated screenshot;
6. trace, video, or HAR only when materially useful.

If the CLI behaves unexpectedly, run offline diagnostics when supported:

```bash
agent-browser doctor --offline --quick
```

Use fuller diagnostics only when required. Repair options can mutate local
state or reinstall components; run them only when repairs are authorized.

Use JavaScript evaluation only when it materially improves the requested
read-only inspection or debugging, and keep it narrowly scoped and
non-mutating. Network routing or mocking changes browser behavior and requires
explicit authorization for the specific owned local or test target. Never use
arbitrary page-code execution to bypass authorization, and never intercept or
mutate unrelated third-party or production traffic. If the installed CLI
warns that `--allowed-domains` is incompatible with the selected profile, saved state,
restore, CDP attach, or provider, follow that warning and stop for a safer
configuration instead of forcing the flag.

## QA report

```markdown
## Browser QA

- Target:
- Scope tested:

### Findings

1. [severity] Finding
   - Reproduction:
   - Expected:
   - Actual:
   - Evidence:

### Artifacts

- ...

### Not tested

- ...
```

State limitations only when they materially affect confidence.
