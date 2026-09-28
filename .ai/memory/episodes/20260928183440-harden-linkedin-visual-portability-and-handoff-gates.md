# Harden linkedin visual portability and handoff gates

Date: 2026-09-28
Feature: linkedin-visual

## Context

The `linkedin-visual` skill was migrated to local editable PPTX/PDF authoring
with canonical Ahsan PNG references. A review found a model-specific execution
reference, an underspecified Drive mutation boundary, and no explicit fallback
when image inspection was unavailable.

## Goal

Make the skill harness-neutral and safe for the local-first workflow without
changing the approved visual system or publication boundaries.


## Why

The repository requires shared skills to remain portable across harnesses, and
Drive/Sheet writes require an exact authorized target. Visual fidelity must not
be claimed when the canonical references cannot be inspected.

## Outcome

Replaced the `luna-xhigh-execution.md` route with the generic
`presentation-execution.md` contract, added explicit Drive/Sheet target and
authorization checks, and documented blocked/unverified outcomes for missing
PNG inspection or rendering capabilities. The restored RAG sample remains in
the packaged skill.


## Current State

The skill is structurally validated and packaged. Changes remain uncommitted;
no remote Drive/Sheet mutation or external publication was performed.

## Important Findings

- Canonical PNGs control composition; written references control tokens,
  dimensions, editability, and QA.
- The RAG sample is a historical fixture and is not a current brand rule.
- The skill package now contains 35 files, including the design references,
  restored RAG fixture, and generic execution contract.

## Decisions

- Keep local PPTX as the editable source and PDF as the matching export.
- Require explicit exact-target authorization before Drive/Sheet mutation.
- Mark fidelity/rendering checks blocked or unverified when required inspection
  capabilities are unavailable rather than treating the output as verified.

## Failed Approaches

- The original execution reference was named and written for GPT-5.6 Luna xhigh;
  that route was not portable under the repository's shared-skill contract and
  was replaced with a generic reference.

## Validation

- `quick_validate.py skills/linkedin-visual` — passed.
- `bash scripts/validate-skills.sh` — passed.
- `bash -n scripts/*.sh bin/*` and `git diff --check` — passed.
- `scripts/package-skills.sh --clean` and `unzip -t zip/linkedin-visual.zip` —
  passed.
- Native presentation-editor rendering and live Drive/Sheet handoff remain
  untested.

## Open Questions

- Whether the supplied canonical renders should be committed with the skill
  update remains for user review.

## Next Steps

- User reviews the corrected skill and reference set; generate or restore the
  editable PPTX/PDF only after that review.

## Relevant Files

- `skills/linkedin-visual/SKILL.md`
- `skills/linkedin-visual/references/presentation-execution.md`
- `skills/linkedin-visual/references/pptx-workflow.md`
- `skills/linkedin-visual/examples/post-rag-context-contract-2026-09-25.md`
