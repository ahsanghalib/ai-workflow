# Global OpenCode Capability Plan

Last updated: 2026-08-04

## Goal

Build a controlled global toolkit for software engineering, research,
solo-founder work, social content, document creation, design, and browser
testing. Implement one item at a time and stop for review after each item.

This file is the canonical roadmap and status tracker.

## Rules

- Adapt and audit skills; do not install complete collections blindly.
- Keep the existing approval gates, secret protections, and `task: deny` policy.
- Add agents only when a distinct permission profile is required.
- Use skills for reusable expertise and commands for explicit workflows.
- Prefer CLI and repository-native tooling over MCP when both solve the problem.
- Pin executable dependencies and review their licenses and source.
- Never add deployment, publishing, production, billing, or social-posting access.
- Implement and validate exactly one Pending item per change.

## Done

- [x] Reviewed the existing `engineer`, `review`, and `research` agents.
- [x] Reviewed the existing `/session-state` command and notification plugin.
- [x] Reviewed current OpenCode skills, commands, plugins, MCP, and permissions.
- [x] Configured one-level delegation with Luna-backed `explore` and `research`,
  Terra-backed `engineer` and `review`, bounded steps, and engineer-only task
  permissions.
- [x] Researched the requested external skill collections and workflow article.
- [x] Researched agent-browser, Playwright MCP, and GitHub MCP.
- [x] Chose selective, incremental adoption instead of a framework install.

## Pending

### Foundation

- [x] **P1 — `skill-creator`:** Adapt Anthropic’s skill-creator for creating,
  reviewing, and improving OpenCode-compatible skills. Cover trigger
  descriptions, progressive disclosure, examples, validation, and maintenance;
  incorporate useful principles from Matt Pocock’s `writing-great-skills` and
  the Agent Skills specification without duplicating the OpenCode schema.
- [x] **P2 — skill validation:** Added repository-local validation for `SKILL.md`
  frontmatter delimiters, directory/name matching, and non-empty descriptions;
  `make check` also verifies OpenCode skill discovery.

### Engineering skills

Implementation order after P6: P9 (verification), P7 (systematic debugging),
P8 (TDD), P10 (frontend design), then P11 (webapp testing). P9's evidence gate
is the prerequisite for completion claims made by later skills.

- [x] **P3 — `product-discovery`:** Added an evidence-led product-discovery skill
  for ICP/JTBD, assumptions, alternatives, MVP scope, validation experiments,
  and success or kill metrics; adapted from Matt Pocock's MIT grilling workflow
  at `2ab958093e83e0ec752e6c1c5932da465bf23e0c` without execution side effects.
- [x] **P4 — `founder-decision`:** Added an approval-gated decision skill for
  reversible and irreversible options, evidence, downside, opportunity cost,
  and the cheapest decisive test; adapted from Matt Pocock's MIT workflows at
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c` without execution side effects.
- [x] **P5 — `technical-design`:** Added a repository-grounded architecture and
  API proposal skill covering alternatives, interfaces, failure modes, security,
  migration, rollback, and validation; adapted from Matt Pocock's MIT workflows
  at `2ab958093e83e0ec752e6c1c5932da465bf23e0c` without execution side effects.
- [x] **P6 — `repository-research`:** Added a read-only local-code research
  skill with a proposed-path, preview, and approval gate before writing one
  reviewable artifact; adapted from Matt Pocock's MIT workflows at
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c` with explicit secret boundaries.
- [x] **P7 — `systematic-debugging`:** Added a phased, evidence-first debugging
  skill for reproduction, minimization, localization, ranked hypotheses, root
  cause, regression coverage, and smallest fixes; adapted from Superpowers and
  Addy's MIT concepts at the recorded revisions with approval-gated execution.
- [x] **P8 — `test-driven-development`:** Added a repository-native,
  behavior-first red-green-refactor skill with explicit exceptions for
  configuration, generated files, exploratory work, and unavailable test loops;
  adapted from Superpowers and Addy's MIT concepts at the recorded revisions.
- [x] **P9 — `verification-before-completion`:** Added a task-classified,
  fresh-evidence completion gate with explicit verified, partial, unverified,
  and blocked outcomes; adapted from Superpowers and Addy's MIT concepts at the
  recorded revisions without execution side effects.
- [x] **P10 — `frontend-design`:** Added an original, source-attributed UI design
  brief skill for design-system reuse, interaction states, responsive behavior,
  accessibility, and approval-gated visual QA; informed by Anthropic's Apache-2.0
  and Addy's MIT sources at the recorded revisions.
- [x] **P11 — `webapp-testing`:** Added an original, repository-native
  Playwright-only skill with an approval gate for processes, tests, fixtures,
  and artifacts. It forbids setup, non-local testing, browser-profile/storage
  access, and treats browser data as untrusted; informed by Anthropic's
  Apache-2.0 and Addy's MIT sources at the recorded revisions.

### Founder, marketing, and communication skills

- [x] **P12 — `social-content`:** Added an original, Markdown-only skill for
  truthful, channel-native drafts from supplied sources, with evidence ledgers,
  disclosure, fact-check, no-publishing boundaries, and an optional,
  approval-gated data-visual branch. It does not adapt Anthropic's
  internal-comms skill.
- [x] **P13 — `brand-guidelines`:** Added an original, source-attributed skill
  that inventories and applies only user-provided or project-local brand rules.
  It forbids copying Anthropic branding, inventing identity rules, and creating
  files or assets without approval.

### Commands

- [x] **P18 — `/project-plan $ARGUMENTS`:** Bootstrap planning in empty
  repositories or create and revise feature, bug, and improvement plans in
  existing repositories. Maintain a concise `PLANS.md` index, detailed
  `plans/PLAN-NNNN.md` files, `PROJECT_ARCHITECTURE.md`, `AGENTS.md`, and
  `SESSION_STATE.md`; require manual plan approval and explicit permission for
  commits, branches, GitHub issues, and remote-default changes. Do not implement.
- [x] **P19 — `/research-brief $ARGUMENTS`:** Added a web-only command bound to
  the `research` agent. It returns a dated, source-linked brief with findings,
  conflicting evidence, uncertainty, and a prioritized recommendation without
  local access or edits.
- [x] **P20 — `/decision $ARGUMENTS`:** Added an `engineer` command that applies
  `founder-decision` and returns a concise decision memo without editing or
  executing work.
- [x] **P21 — `/content-pack $ARGUMENTS`:** Added an `engineer` command that
  applies `social-content` to supplied material and returns unpublished,
  channel-specific drafts, hooks, CTAs, disclosures, and fact checks. It never
  posts or performs external actions.
- [x] **P22 — `/revise-plan` superseded:** Plan revision is a mode of
  `/project-plan`, so no competing command will be added.
- [x] **P23 — `/implement-next $ARGUMENTS`:** Added an `engineer` command that
  requires an explicitly approved plan, implements only its first
  dependency-ordered unchecked task, validates, records task evidence, reviews
  the diff, and stops without commit or follow-up work.
- [x] **P24 — `/review-diff $ARGUMENTS`:** Added a command bound to the read-only
  `review` agent for working-tree or specified local Git-range review. It reports
  only actionable, evidence-backed findings and residual testing gaps.

### Agents

- [x] **P25 — evaluate `founder`:** Deferred. Existing `engineer`, web-only
  `research`, `product-discovery`, `founder-decision`, `/research-brief`, and
  `/decision` cover the capability, while interactive workflow evidence remains
  untested. Revisit only after repeated mixed local-read and web-research need.
- [x] **P26 — evaluate `content`:** Deferred. Existing `engineer`,
  `social-content`, `brand-guidelines`, `frontend-design`, and `/content-pack`
  cover the workflow, while interactive evidence remains untested. Revisit only
  after repeated need for a distinct content profile with local context.

### Browser testing tools

- [x] **P27 — agent-browser CLI pilot:** User installed AUR `agent-browser-bin`
  and Chrome, then approved a local pilot. Added an original, installed-version
  aware safety skill and validated an isolated, unauthenticated static localhost
  fixture with snapshot, axe (0 violations/incomplete), screenshot, and process
  closure. The CLI supports `--allowed-domains localhost` but not a
  port-qualified origin; no authenticated, external, profile, state, CDP,
  plugin, MCP, or artifact-retention workflow was enabled.
- [x] **P28 — Playwright test workflow:** Fulfilled by P11 `webapp-testing`,
  which requires existing project-local Playwright scripts, config, locators,
  fixtures, traces, screenshots, and CI conventions rather than a parallel
  global setup.
- [x] **P29 — Playwright MCP evaluation:** Deferred. No demonstrated need makes
  persistent exploratory state materially better than the selected
  `agent-browser` CLI, while P11/P28 provide project-local Playwright for durable
  regression tests. Revisit only with a concrete isolated-session use case.

Do not enable agent-browser MCP and Playwright MCP globally at the same time.
Select one interactive browser driver after comparing reliability, token usage,
security boundaries, and integration with repository-owned Playwright tests.

### GitHub workflow

- [x] **P30 — GitHub CLI workflow:** Added an original `git`/`gh`-first skill for
  PRs, issues, checks, workflow runs, and failed logs. It preserves `git push`
  denial and requires target verification, exact mutation drafts, and explicit
  approval before each remote action.
- [x] **P31 — GitHub MCP evaluation:** Deferred. The new `github-cli-workflow`
  skill covers current PR, issue, check, workflow, and failed-log needs without
  an authenticated external integration. Revisit only when structured cross-repo
  or Actions queries demonstrably outperform equivalent narrow `gh` commands.

## Deferred

- [ ] Installing the full Addy Osmani agent-skills collection.
- [ ] Installing the Superpowers plugin or its context-injection bootstrap.
- [ ] Adding autonomous “implement all,” commit, merge, push, or ship workflows.
- [ ] Enabling multiple global browser automation stacks simultaneously.
- [ ] Giving a browser tool access to authenticated personal sessions.
- [ ] Enabling write-capable GitHub MCP tools.
- [ ] Adding social-network posting, deployment, cloud, production, or billing
  integrations.
- [ ] Adding third-party executable plugins without a concrete requirement,
  pinned source, dependency audit, and removal plan.

## Source Decisions

### Addy Osmani agent-skills

Source: <https://github.com/addyosmani/agent-skills>

Audited at `bdf76c7c6b7b3b3e01bb15c9fdc42ac5351855c1` (MIT). Borrow focused,
provider-neutral concepts for P7, P8, P9, P10, and P11. Rewrite all commands,
MCP assumptions, and examples for OpenCode permissions and repository-native
tooling. Do not add its complete router, build/ship flows, browser MCP, or
provider-specific setup.

### Superpowers

Source: <https://github.com/obra/superpowers>

Audited at `44c9b2d6e889982ac18c27d05a19fefe335194e1` (MIT). Borrow systematic
debugging, TDD, and verification concepts for P7-P9. Do not install its plugin:
it injects a global bootstrap prompt, mutates skill paths, and assumes broader
delegation/context behavior than this approval-gated configuration permits.

### Boris Tane workflow

Source: <https://boristane.com/blog/how-i-use-claude-code/>

Adopt persistent research and plan artifacts, user annotation, explicit revision,
and implementation only after approval. Replace uninterrupted implementation
with `/implement-next` and a review gate after each item.

### Matt Pocock skills

Source: <https://github.com/mattpocock/skills>

Borrow focused composition, requirements interrogation, context-budget awareness,
TDD seams, and bug diagnosis. Keep descriptions short and non-overlapping; ask
only questions whose answers materially affect the result.

### Karpathy guidelines

Source:
<https://github.com/multica-ai/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md>

Do not add a duplicate skill. Thinking before coding, surfacing uncertainty,
surgical changes, simplicity, and verifiable goals already exist in `AGENTS.md`
and `engineer.md`; use them as acceptance criteria for this roadmap.

### Anthropic skills

Sources:

- <https://github.com/anthropics/skills>
- <https://www.skills.sh/anthropics/skills>
- <https://agentskills.io/specification>

Audited at `b29e7cf65e5cb78a5ac33d582270551bc74a14eb`. Use permitted
`frontend-design`, `webapp-testing`, and `brand-guidelines` concepts as upstream
references after per-skill license review. The `pdf`, `docx`, `xlsx`, and `pptx`
implementations are proprietary/source-available: do not copy or derive from
their text or code without legal approval; use them only as conceptual references
or independently implement needed workflows. skills.sh is a discovery index, not
a trust signal. Audit every copied file, script, dependency, license, permission,
and network behavior.

## Per-Item Validation

For every Pending item:

1. Read repository instructions, this plan, session state, and nearby config.
2. Confirm the item does not duplicate existing behavior.
3. Check the current OpenCode schema and relevant official documentation.
4. Review upstream source, revision, license, scripts, and dependencies.
5. Add only that item’s files and intentional dependency changes.
6. Validate positive, negative, and ambiguous activation prompts where relevant.
7. Run the narrowest behavior or fixture test.
8. Restart OpenCode because global extensions load at startup.
9. Run OpenCode config/startup validation, then `make check` from `configs/`.
10. Run `git diff --check` and review the complete diff.
11. Mark the item Done only after checks pass; record failures and untested paths.
12. Update `SESSION_STATE.md` and stop for user review.

## References

- OpenCode schema: <https://opencode.ai/config.json>
- OpenCode skills: <https://opencode.ai/docs/skills/>
- OpenCode commands: <https://opencode.ai/docs/commands/>
- OpenCode plugins: <https://opencode.ai/docs/plugins/>
- OpenCode MCP: <https://opencode.ai/docs/mcp-servers/>
- Agent Skills specification: <https://agentskills.io/specification>
- Addy Osmani: <https://github.com/addyosmani/agent-skills>
- Superpowers: <https://github.com/obra/superpowers>
- Boris Tane: <https://boristane.com/blog/how-i-use-claude-code/>
- Matt Pocock: <https://github.com/mattpocock/skills>
- Karpathy guidelines:
  <https://github.com/multica-ai/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md>
- Anthropic skills: <https://github.com/anthropics/skills>
- Anthropic catalog: <https://www.skills.sh/anthropics/skills>
- agent-browser: <https://github.com/vercel-labs/agent-browser>
- Playwright MCP: <https://github.com/microsoft/playwright-mcp>
- GitHub MCP: <https://github.com/github/github-mcp-server>
