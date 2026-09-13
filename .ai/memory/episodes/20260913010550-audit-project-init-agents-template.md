# Audit project init AGENTS template

Date: 2026-09-13
Feature: project-init-templates

## Context

Read-only audit of `skills/new-skills-to-add/project-init/templates/AGENTS.md`
and every document, rule, and template it references.

## Goal

Check whether the generated repository guide is safe, portable, and consistent
with the finalized session-state skill and project-init scaffold.


## Why

This AGENTS template will govern future work in projects initialized from the
scaffold, so omissions would affect every downstream skill.

## Outcome

All referenced paths exist. The AGENTS template was hardened with
MASTER_PLAN/legacy-layout discovery, explicit approval and generated-file
boundaries, conditional memory behavior, and a structural-index fallback.
The referenced SESSION_STATE template was then aligned with the finalized
session-state fields.


## Current State

The AGENTS and SESSION_STATE templates are ready for their own promotion
review. Other referenced templates remain unchanged for separate review.

## Important Findings

- Repository documents and tool output are correctly treated as untrusted data.
- Memory guidance is now conditional on capability and project selection.
- Startup guidance now includes MASTER_PLAN and prevents a second planning
  tree in a legacy-layout repository.
- CodeGraph guidance now has an availability fallback and permits critical
  direct reads.
- The SESSION_STATE template now includes Objective, Pending, Assumptions and
  Risks, Last updated, and Untested paths fields from the finalized contract.

## Decisions

- Keep each template review focused; this pass changed AGENTS.md and its
  directly referenced SESSION_STATE template only.
- Preserve the existing AGENTS continuity section and rule-routing structure.
- Make memory and structural indexing conditional rather than required
  capabilities.

## Failed Approaches

- None. The reference inventory and cross-template check completed without
  missing paths.

## Validation

- Every referenced document, rule, and template path exists.
- Headings and ownership labels were compared across README, MASTER_PLAN,
  SESSION_STATE, architecture, plan index, SPEC/PLAN/REVIEW, and all rules.
- Runtime harness discovery and generated-project behavior were not exercised.

## Open Questions

- Which referenced project-init template should be reviewed next?

## Next Steps

- Review the next selected project-init template, then rerun the relevant
  isolated scaffold checks.

## Relevant Files

- `skills/new-skills-to-add/project-init/templates/AGENTS.md`: reviewed guide.
- `skills/new-skills-to-add/project-init/templates/SESSION_STATE.md`: field
  alignment follow-up.
- `skills/new-skills-to-add/project-init/templates/docs/`: referenced rules,
  architecture, plan index, and artifact templates.
