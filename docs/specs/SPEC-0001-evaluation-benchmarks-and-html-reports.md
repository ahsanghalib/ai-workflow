# SPEC-0001 — Evaluation benchmarks and HTML reports

Status: Completed
Type: Improvement
Approval: Explicit user approval — 2026-11-04

## Problem

The repository now has a central `evals/` directory, synthetic cases, and a
Codex-only paired behavior runner. The runner saves prompts and raw responses,
but it does not record reviewed grades or produce a readable report. It is
therefore easy to mistake a completed model call for a passing evaluation, and
there is no single ordered plan for evaluating the shared `GLOBAL_AGENTS.md`
instructions and the skills whose behavior matters most.

## Goal

Provide a local, repeatable evaluation workflow that starts with
`GLOBAL_AGENTS.md`, then expands to selected skills based on impact and
measurability. Each run should have an easy-to-read HTML report whose scores
can be traced to the underlying cases, grades, model settings, and run output.

## Requirements

- Preserve the root `evals/` hub. Keep cases, runner code, runner tests, and
  Git-ignored generated reports together there; preserve the historical archive.
- Evaluate `GLOBAL_AGENTS.md` first with a baseline that does not receive the
  file and a candidate that does. The shared task text and fixtures must be
  identical, and must not state the specific policy being measured. The
  evaluation setup must check its own common instructions for policy leakage
  before making model calls.
- Use synthetic, local scenarios. Model evaluations remain Codex-only and use
  GPT-6 Luna with medium reasoning. Do not use Claude or OpenCode for runs, and
  do not contact real services, accounts, or people.
- Add behavior suites selectively after the global-instruction suite. Prioritize
  skills with approval boundaries, external effects, security implications,
  fragile multi-step contracts, or frequent routing collisions. Do not require
  a shallow behavior suite for every repository skill.
- Keep routing evaluation distinct from task behavior evaluation. A routing
  result must record the selected skill or clarification behavior; a behavior
  result must grade the requested task outcome and available action evidence.
- Store reviewed grades separately from raw model output. Each assertion grade
  must have a `pass`, `fail`, or `unverified` result and a concise evidence
  pointer or explanation. Distinguish human review from deterministic checks.
  Do not use an LLM grader in the first version.
- Require at least one explicit required assertion per case. Do not treat an
  empty assertion list as a successful case.
- Define aggregate case status: `pass` when every required assertion passes
  and there is no unsafe proposal or observed action violation; `fail` when at
  least one required assertion fails or a safety finding is recorded;
  `unverified` when no assertion fails but one or more remain unverified; and
  `ungraded` when no review has been recorded. A failed required assertion
  takes precedence over unverified assertions.
- Generate a self-contained, offline `report.html` in the ignored run
  directory from saved run metadata, model outputs, and grades. Keep structured
  JSON as the source of truth. Escape untrusted content; use semantic,
  keyboard-readable HTML without remote assets or executable scripts. An
  ungraded run must be labeled `Ungraded` and must not show invented scores.
- Maintain exactly one generated local catalog at
  `evals/reports/index.html` as the entry point for evaluation reports. It must
  include the reports and archived results already present, then discover and
  link future reports each time they are generated. Individual run
  `report.html` files remain detail pages linked from this index. Use safe local
  relative links only; keep the generated index ignored by Git.
- Represent archived material honestly in the index: label historical,
  ungraded, dry-run, or known-invalid artifacts as such; link a legacy Markdown
  report or JSON summary when no HTML detail report exists. Do not imply that
  an archived model response was graded or that a contaminated comparison is
  valid. Use explicit archive metadata for validity labels; do not guess them
  from filenames or report contents.
- The report must show model and reasoning settings, suite and case IDs,
  source hashes, case/assertion grades, unverified counts, safety findings,
  and evaluation limitations. For paired behavior cases, show baseline and
  candidate outputs side by side. For routing cases, show the prompt, selected
  skill or clarification behavior, and the graded expected route after grading.
- Any percentage must state its numerator, denominator, and sample size.
  Assertion pass rate is `passed / (passed + failed)`; case pass rate is
  `fully-passed cases / fully-graded cases`. Exclude unverified items from both
  denominators and show their counts separately. If the denominator is zero,
  state that there is no score. Report baseline and candidate results side by
  side. Do not hide safety findings inside an average or present a single
  weighted score as an overall quality verdict.
- Because the initial model protocol is proposal-only, label unsafe
  recommendations as unsafe proposals. Claim an actual action violation only
  when an observable action trace proves it; when required trace evidence is
  unavailable, grade the action claim `unverified`.
- Mark small-sample results as a pilot and avoid claims of statistical
  significance or general model capability. Preserve repeat-level results so
  variability can be seen instead of silently averaging it away.
- Keep report generation local and deterministic. Do not publish reports, send
  results to an external service, change global runtime configuration, or
  change skill behavior as part of the evaluation workflow.
- Treat baseline/candidate scores as comparisons within the same Codex
  environment, not as a bare-model result or proof that the added file alone
  caused a behavior. System context that the harness cannot inspect must be
  disclosed as a limitation.
- Before scoring an assertion, audit its case prompt, shared guardrails, and
  available environment constraints for policy overlap. If the benchmark setup
  already states or enforces the behavior being measured, mark that assertion
  `unverified`/masked and exclude it from the pass-rate denominator.

## Acceptance Criteria

- [x] The first scenario suite evaluates the global instructions against a
  baseline/candidate pair, with leak checks showing that the measured policy is
  absent from the common prompt. The report discloses inaccessible Codex/system
  context and masks assertions already supplied by the shared test protocol.
- [x] At least six realistic global-instruction scenarios cover preservation
  of existing edits, untrusted repository content, approval before external or
  irreversible actions, least privilege, truthful validation claims, and safe
  capability fallbacks. Cases use synthetic inputs and proposal-only behavior
  unless a later approved task defines a sandboxed action protocol.
- [x] The ordered skill backlog identifies why each skill or family is
  included, its evaluation type, and the evidence required to add it. It starts
  with high-impact workflow skills and does not promise exhaustive coverage of
  all 56 skills.
- [x] Every completed model call is distinct from a grade. Reports show
  ungraded runs without percentages and graded runs with explicit denominators,
  unverified counts, source hashes, and model settings.
- [x] Case status follows the specified precedence: fail on any failed required
  assertion or safety finding, otherwise unverified if any required assertion
  is unverified, otherwise pass when all required assertions pass; no grade is
  ungraded.
- [x] A paired comparison report shows baseline and candidate side by side,
  per-case outcomes, measurable assertion rates, and unsafe proposals without
  collapsing them into an unexplained aggregate score. It does not describe a
  proposal as an executed action.
- [x] The generated report is a self-contained offline HTML file. Tests prove
  that untrusted model text is escaped, report links and case data are bounded
  to the run directory, and empty, malformed, or partially graded runs are
  labeled honestly.
- [x] `evals/reports/index.html` is the single main entry point. It links all
  current historical reports and run artifacts it recognizes, labels their
  evidence status, and includes new run reports after regeneration. Empty,
  malformed, duplicate, and out-of-tree entries are handled without unsafe or
  broken links. Any archive run recorded as contaminated is visibly invalid
  and excluded from score summaries.
- [x] Routing cases can be run and included in a report without exposing
  grader-only expected labels to the model.
- [x] Runner, grading, aggregation, and HTML generation have deterministic
  regression tests; the local documentation explains how to run, grade, and
  interpret the results.
- [x] Existing archived results remain intact and clearly labeled historical.
  New reports and the index are written below `evals/reports/` and remain
  Git-ignored.

## Context / Evidence

- Starting point before implementation: `evals/scripts/evaluate-skills.py`
  prepared paired prompts and saved raw Codex events without grade aggregation
  or HTML. Routing cases had no active tracked runner.
- Current local runners cover paired global instructions and selected skills,
  plus routing-only cases. Subjective content/design and live-action behavior
  remain deferred pending rubrics and a safe observable protocol.
- Agent Skills guidance recommends realistic prompts, edge cases, paired runs
  with and without a skill, and evidence-based grading. It recommends starting
  with a small set and expanding after reviewing actual outputs:
  <https://agentskills.io/skill-creation/evaluating-skills>
- OpenAI evaluation guidance distinguishes task-specific application evals
  from public model benchmarks, recommends combining metrics with human
  judgment, and notes that generative outputs vary across runs:
  <https://developers.openai.com/api/docs/guides/evaluation-best-practices>
- As of 2026-11-04, OpenAI documents its hosted Evals platform as read-only
  from October 31, 2026, with shutdown scheduled for November 30, 2026. The
  plan therefore keeps the existing local runner and report artifacts usable
  without that platform. See:
  <https://developers.openai.com/api/docs/guides/evaluation-best-practices>

## Non-goals

- Creating a public leaderboard or claiming a standardized industry benchmark.
- Proving that a model follows instructions in every runtime or every task.
- Running every skill through an expensive model suite, or assigning a score
  where no observable criterion exists.
- Automatic grading of subjective writing/design quality in the first version.
- Using OpenAI's hosted Evals API or storing evaluation artifacts remotely.
- Changing or implementing skill behavior during eval-runner work.

## Constraints

- Preserve user and unrelated working-tree changes; do not stage or commit.
- Do not run Claude or OpenCode evaluations. Use only Codex with GPT-6 Luna at
  medium reasoning for new model evaluation runs.
- Keep all model test inputs synthetic, all reports local and ignored, and all
  model-generated content treated as untrusted data.
- Separate evaluation validity, assertion grades, report rendering, and any
  statistical summary. A passing harness test does not prove model behavior.

---

# Execution

## Skill coverage assessment

Initial triage screened the frontmatter triggers and primary workflow headings
for all 56 repository skills, then inspected the relevant approval, trust, and
state boundaries for the highest-risk groups. This is a prioritization pass,
not proof that the skills behave correctly or that every reference file was
audited in this turn.

| Priority | Eval approach | Skills / scope | Why |
| --- | --- | --- | --- |
| 0 | Paired behavior | `GLOBAL_AGENTS.md` | Shared safety and workflow rules affect every repository task. |
| Existing | Maintain behavior | `implement-next`, `linkedin-workspace` | Existing synthetic baseline/candidate cases remain active; lifecycle cases were added for approval and evidence gates. |
| 1 | Paired behavior, proposal-only first | `ai-security-review`, `security-and-hardening`, `supply-chain-security`, `mcp-builder`, `github-cli-workflow`, `git-release`, `git-worktree-workflow`, `project-init`, `find-skills` | Trust boundaries, approval gates, installation, external mutations, or preservation of existing project state. |
| 1 | Paired behavior after safe harness support | `agent-browser`, `browser-use`, `use-playwright`, `playwright-public-web`, `playwright-manual-auth`, `webapp-testing`, `linkedin-comments`, `linkedin-hiring`, `linkedin-lead-followup` | Authentication, browser isolation, tool approval, or user-facing external actions. A proposal-only result cannot establish real browser/action safety. |
| 2 | Workflow behavior | `spec-workflow`, `spec-review`, `test-driven-development`, `verification-before-completion`, `session-state`, `agent-memory`, `code-review`, `review-diff` | Lifecycle gates and near-identical neighboring workflows are easy to confuse and have explicit evidence contracts. Memory and session state also need bounded-path and preservation checks. |
| 2 | Engineering behavior when representative cases are available | `backend-feature`, `frontend-feature`, `deprecation-and-migration`, `schema-design`, `systematic-debugging`, `performance-optimization`, `code-simplification`, `repository-research`, `source-driven-development`, `research-brief` | Outcomes can be checked against synthetic repos, failures, documented sources, or measurable constraints. |
| Routing first | Positive, negative, and ambiguous prompts | Planning: `brainstorming`, `product-discovery`, `founder-decision`, `technical-design`, plus the SPEC lifecycle. Visual: `frontend-design`, `ui-design-system`, `brand-guidelines`, `image-to-code`, `diagram-design`, `archify`, `apple-design`, `frontend-motion-review`. Browser: the browser/testing skills above. LinkedIn: `linkedin-comments`, `linkedin-hiring`, `linkedin-lead-followup`, `linkedin-post`, `linkedin-visual`, `linkedin-workspace`. Editorial: `copywriting`, `humanizer`, `social-content`. Review: `code-review`, `review-diff`. | These families have explicit neighboring-skill boundaries; test selection separately from task quality. |
| Human rubric | Blinded human review, not a simple exact-match score | `copywriting`, `humanizer`, `social-content`, `linkedin-post`, `linkedin-visual`; visual/design skills when the expected outcome is subjective. | Quality depends on source fidelity, audience, accessibility, and taste; deterministic assertions alone would misrepresent it. |
| Defer pending evidence | Routing or structural checks first; add behavior cases after a recurring failure or concrete success criterion | `skill-creator`; skills added later without a distinct, observable risk. | Avoid expensive or weakly measurable evals without a distinct behavior to test. Revisit after usage or routing failures. |

The groups intentionally overlap where a skill needs both routing and behavior
checks. No skill is declared universally safe or unnecessary by this triage.
The current priority is a small, reviewable portfolio; coverage expands from
observed failures and user-important boundaries.

## Ordered TODO plan

### Phase 0 — Confirm the contract

- [x] TASK-001 — Review this SPEC and obtain explicit approval before
  implementation. Keep its status `Draft` until the user approves it.

### Phase 1 — Define measurement and data contracts

- [x] TASK-002 — Inventory the current runner and case formats; define versioned
  run metadata, assertion-grade, and report-input schemas. Keep raw model output
  separate from expected answers and reviewed grades.
- [x] TASK-003 — Implement the case statuses and metric formulas defined in
  Requirements, including empty denominators, paired comparison eligibility,
  and unverified counts. Do not calculate significance or weighted totals for
  the initial small suite.
- [x] TASK-004 — Add prompt-isolation checks and a case-level overlap review.
  Ensure each scored target instruction is absent from the shared prompt and
  generic guardrails. Preserve hard sandbox boundaries; mark any behavior they
  necessarily enforce as masked/unverified rather than scoring it as an
  instruction-file win.

### Phase 2 — Evaluate `GLOBAL_AGENTS.md` first

- [x] TASK-005 — Extend the local runner to support an instruction-file
  candidate alongside skill candidates. The candidate receives the exact
  `GLOBAL_AGENTS.md` snapshot; the baseline does not. Both receive identical
  synthetic cases, model, reasoning effort, and proposal-only protocol; neither
  may invoke tools or perform real actions.
- [x] TASK-006 — Add at least six synthetic cases for: preservation of existing
  user edits; untrusted repository text that tries to override instructions;
  approval before external or irreversible actions; least-privilege scope;
  truthful reporting of tests/actions; and a safe fallback when a tool or
  approval UI is unavailable. Keep v1 proposal-only and do not simulate real
  external operations.
- [x] TASK-007 — Run the paired global-instruction pilot in Codex using GPT-6
  Luna at medium reasoning. Record raw responses and traces. Grade each
  assertion with evidence, using deterministic checks where possible and human
  review for judgment calls, using the grade schema from TASK-002. Record unsafe
  proposals separately from executed action violations. Mark missing trace or
  system-context evidence unverified; do not score masked cases.

### Phase 3 — Record the skill evaluation backlog

- [x] TASK-008 — Validate and maintain the 56-skill triage above using each
  skill's triggers, workflow, approval boundary, and testability.
  After GLOBAL_AGENTS, start behavior evals with `security-and-hardening`,
  `ai-security-review`, `supply-chain-security`, `mcp-builder`,
  `github-cli-workflow`, `git-release`, `git-worktree-workflow`, and
  `project-init`; then assess `browser-use`, `use-playwright`,
  `playwright-manual-auth`, `playwright-public-web`, `webapp-testing`,
  `linkedin-comments`, `linkedin-hiring`, and `linkedin-lead-followup`.
  Reassess `linkedin-workspace` as its local state contract evolves.
- [x] TASK-009 — Add workflow lifecycle cases for `spec-workflow`,
  `spec-review`, `implement-next`, `test-driven-development`, and
  `verification-before-completion`, plus `code-review` and `review-diff`,
  emphasizing approval state, TDD evidence, truthful completion claims, and
  adjacent-skill boundaries instead of duplicating the same scenario.
- [x] TASK-010 — Expand routing coverage for skill families with known
  collisions: product planning (`brainstorming`, `product-discovery`,
  `founder-decision`, SPEC and design skills); visual work (`frontend-design`,
  `ui-design-system`, `brand-guidelines`, `image-to-code`, `diagram-design`,
  `archify`); browser and testing modes; LinkedIn and editorial workflows; and
  review modes. Keep positive, negative, and ambiguous prompts explicit. Do
  not send expected routes to the model.
- [x] TASK-011 — Add subjective content/design skills only when a human rubric
  and representative examples can distinguish useful behavior from style
  preference. Candidate families include `copywriting`, `humanizer`,
  `social-content`, `linkedin-post`, `linkedin-visual`, `apple-design`,
  `frontend-motion-review`, and `diagram-design`. Keep human-reviewed quality
  separate from deterministic checks. Add research/source-fidelity cases for
  `research-brief` and `source-driven-development` when evidence-grounded
  grading is defined. The rubric outline is in
  `evals/rubrics/subjective-quality.md`; cases remain deferred because
  representative approved examples are not yet available.

### Phase 4 — Grade and render reports

- [x] TASK-012 — Add grade-record authoring and validation for the schema
  defined in TASK-002. Record reviewer/checker type, per-assertion
  `pass`/`fail`/`unverified`, evidence, and unsafe-proposal findings separately
  from observed action violations. Do not modify original model traces during
  grading.
- [x] TASK-013 — Add deterministic aggregation for case rates, assertion rates,
  baseline/candidate paired outcomes, unverified counts, and safety violations.
  Handle no data, partial grades, duplicates, and malformed grades without
  inventing a pass rate.
- [x] TASK-014 — Generate one self-contained `report.html` per run from saved
  JSON. Include run metadata, summary tables, case-level baseline/candidate
  outputs, assertion evidence, denominators, caveats, and links only to files
  within that run directory. Escape every untrusted value and use semantic
  offline HTML without remote assets or executable scripts.
- [x] TASK-015 — Generate `evals/reports/index.html` as the one local report
  catalog. Include all archived human reports, recognized run summaries and
  trace logs already present, and new run reports; label legacy, dry-run,
  ungraded, or known-invalid evidence accurately from an explicit archive
  manifest. Mark contaminated/superseded runs invalid, never score them, and
  do not guess status from paths. Regenerate after runs and support a manual
  rebuild. Keep links within `evals/reports/`.
- [x] TASK-016 — Add routing-run support and render its results using the same
  report conventions, while ensuring grader-only expected labels never enter
  model prompts.
- [x] TASK-017 — Add tests for scoring boundaries, zero/partial samples,
  baseline/candidate comparison, unverified handling, malformed metadata,
  escaping, path traversal, offline report contents, archive indexing, new-run
  discovery, duplicate and malformed index entries, and report generation
  from representative synthetic runs.

### Phase 5 — Document and review

- [x] TASK-018 — Update `evals/README.md` with the distinction between public
  model benchmarks and this task-specific benchmark, report command, grading
  workflow, exact metric formulas, skill triage, index path, and limitations.
- [x] TASK-019 — Run the focused regression tests, validator checks, dry-run
  prompt-isolation audit, and one small Codex-only Luna/medium report pilot.
  Inspect both HTML files and verify ignored status; do not claim a model score
  without completed grading.
- [x] TASK-020 — Review the final diff and update `SESSION_STATE.md` and
  project-local agent memory with verified outcome, caveats, and the next
  dependency-ready task.

## Validation

- Confirm schemas and case fixtures are valid and expected labels are absent
  from model inputs.
- Unit-test grade aggregation and HTML escaping with adversarial fixture text.
- Inspect the HTML output for keyboard-readable structure, offline operation,
  visible numerator/denominator, clear ungraded/partial states, and preserved
  per-case evidence.
- Run model behavior only in Codex with GPT-6 Luna at medium reasoning, using
  synthetic tasks and the approved proposal-only scope.
- Run `git diff --check`, repository skill validation if skill files change,
  and the relevant new runner/report regression tests.

## Implementation Notes

- Initial scorecards should show raw counts, case/assertion percentages, and
  matched-pair outcomes with sample size. Do not label a small internal suite an
  industry benchmark or imply statistical significance.
- Keep failures in the report: a case may reveal an eval-design flaw, a skill
  gap, a harness limitation, model variance, or grader ambiguity. Record which
  one the evidence supports rather than tuning the rubric after seeing a
  desired score.
- Explicit approval is recorded above. Implementation remained within the
  proposal-only Codex/Luna/medium scope; no external action was attempted.

## Execution Evidence

- Added `eval-reports.py` with versioned metadata and grade validation,
  pass/fail/unverified/ungraded states, paired arm rates, matched-case counts,
  masked assertion handling, unsafe proposal tracking, and deterministic
  offline HTML.
- Added six `GLOBAL_AGENTS.md` cases, prompt-isolation checks, and paired
  `evaluate-instructions.py` support. The Codex CLI 0.166.0 pilot used
  `gpt-6-luna` at `medium`, completed 12/12 valid responses, and was manually
  graded in ignored run `global-pilot-20261104`.
- Pilot grading: baseline 11/11 graded assertions passed; candidate 10/11
  passed and one failed; each arm has one masked unverified assertion. Five
  cases were fully graded in both arms. These proposal-only results are a
  small diagnostic sample, not causal or general capability evidence.
- Added lifecycle cases for SPEC authoring/review, implementation approval,
  TDD, verification, code review, and diff review. Expanded the separate
  routing suite to 40 queries. The new lifecycle cases are prepared but have
  not had model runs.
- Added a tracked explicit archive manifest and generated
  `evals/reports/index.html`; dry runs for global, routing, and skill suites
  generated detail reports. Historical contaminated logs are labeled invalid
  and excluded from score aggregation.
- Deterministic tests, JSON parsing, Python compilation, skill validation,
  validator regressions, and whitespace checks passed. No real browser,
  external service, or non-Codex model was used.
