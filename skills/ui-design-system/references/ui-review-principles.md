# UI review principles

Use this reference when a page, section, or component needs a first-pass design
read, a responsive review, or a visual handoff. It turns established UI
principles into checks an agent can perform before asking a user to find basic
problems. It complements `component-consistency.md`; it does not replace a
project's tokens, brand rules, accessibility requirements, or user brief.

## Evidence and precedence

Resolve decisions in this order: explicit user requirements, approved project
tokens and components, supplied brand and content constraints, platform and
accessibility requirements, then these heuristics. Record which rules are
confirmed, inferred, or still unknown. Do not claim conversion improvement or
formal accessibility compliance from a heuristic review alone.
Planning skills define this contract; implementation and verification workflows
execute the applicable checks within their existing authorization and tool
boundaries. Missing tooling leaves a check unverified, not passed. If a requested
treatment conflicts with an accessibility requirement, explain the conflict
without silently changing the requested behavior or claiming conformance.

## First-pass design read

Before building or materially restyling a page, write a short design read that
names:

- the audience, user job, primary action, and the content hierarchy;
- the page sections and the repeated component anatomy;
- the typography roles, spacing scale, semantic color roles, and breakpoint
  matrix to reuse;
- the states that must remain usable: empty, error, disabled, focus, loading,
  expanded, translated, RTL, and reduced motion;
- the baseline views that are explicitly out of scope for change.

Test one representative instance of each repeated role before propagating the
rule. For a whole-page request, view the whole page at normal scale and as a
small full-page thumbnail. For a bounded component change, inspect the
component and its affected section seams, then regression-check the baseline;
do not create a new full-page artifact just to review one small correction.
Computed values can confirm reuse, but they cannot establish balance, visual
weight, readable measure, or awkward empty space.

## Figma-derived visual principles

The Figma UI design principles resource supports seven practical checks:

- **Hierarchy:** size, weight, contrast, and space should make the next useful
  action obvious.
- **Progressive disclosure:** show the decision-making information first and
  reveal detail through an understandable control.
- **Consistency:** matching anatomy and behavior should share the same visual
  and interaction rules.
- **Contrast:** use emphasis to distinguish priority and state without making
  decorative borders compete with content; check legibility in both themes.
- **Accessibility:** check semantic structure, keyboard use, assistive-tech
  names, text resizing, and status cues that do not rely on color alone.
- **Proximity:** keep labels, controls, and explanations close to the thing
  they describe.
- **Alignment:** use a deliberate grid and shared edges; repair odd items in
  the layout model instead of adding per-item offsets.

Treat these as review questions, not a mandate to copy Figma's examples or to
make every screen look alike.

## Usability checks from Nielsen's heuristics

Use the interface's own language and show system status when an action takes
time. Keep controls predictable and reversible, and follow platform
conventions. Prevent avoidable errors with constraints and useful defaults;
help people recognize choices instead of making them remember hidden rules.
Support efficient paths for experienced users while keeping the first path
clear. Remove content and chrome that do not help the current decision. When
something fails, explain what happened and give a specific recovery action.
Provide contextual help only where the task still needs it. These checks guide
inspection; they are not a substitute for task research or usability testing.

## Responsive and accessibility floor

Use the applicable project and platform requirements, then check the following
W3C guidance:

- **Reflow:** at 320 CSS px, content should reflow without two-dimensional
  scrolling except content that inherently requires two dimensions. Ordinary
  vertical scrolling is expected and remains allowed.
- **Contrast:** normal text should meet 4.5:1 and large text 3:1 under WCAG's
  definitions (24 CSS px regular or approximately 18.67 CSS px bold). Required
  non-text control/state cues and meaningful graphics generally need 3:1
  against adjacent colors, subject to the criterion's exceptions. Decorative
  separators do not automatically need that ratio. Check both themes.
- **Targets:** interactive targets should be at least 24 by 24 CSS px or use
  one of the permitted exceptions: spacing, equivalent target, inline target,
  user-agent control, or essential target. 44 by 44 is a useful comfortable
  target, not the WCAG AA minimum.
- **Motion:** automatic motion that runs for more than five seconds alongside
  other content needs a pause, stop, or hide mechanism unless an exception
  applies. A reduced-motion media query is valuable but does not by itself
  prove this requirement.
- **Tabs:** a tablist needs correctly associated tabs and panels, one clear
  active state, and orientation-appropriate arrow-key behavior. Preserve
  expected Home/End behavior where the pattern supports it.

Check these independently at mobile, tablet, and desktop widths, in every
supported language and direction. Use logical properties for RTL and test the
longest realistic labels before declaring the layout stable.

## Agent-owned visual scorecard

Before handoff, mark each applicable check **pass**, **fail**, or
**unverified**; mark irrelevant checks **N/A** instead of inventing states or
fixtures. For every failure, record the smallest repair and capture the same
state again. Do not hand basic visual defects to the user as discovery work.

| Check | Pass condition | Evidence |
| --- | --- | --- |
| Section rhythm | Shared section shells have the intended block padding and gutters | Screenshot at 320/768/1024/1440 |
| Type roles | Equivalent headings, body, labels, and captions use the same shared roles | Computed styles plus readable screenshot |
| Repeated anatomy | Matching cards/rows/controls share one base and justified variants only | Source inspection and representative render |
| Alignment | Shared grid edges line up, including odd item counts and the last row | Component screenshot |
| Hierarchy | The primary action and next step are obvious at normal scale | Full-page view and thumbnail |
| Density | No section is cramped, accidentally empty, or overloaded with chrome | Full-page view |
| States | Focus, hover, active, expanded, disabled, empty, and error states remain legible | State matrix |
| Responsive | No unintended overflow or clipped content at supported widths and breakpoint edges | Viewport screenshots and overflow check |
| Localization | Long labels, Arabic/RTL, and mixed-direction content preserve order and alignment | Language screenshots |
| Theme | Light/dark semantic pairs keep contrast and state distinction | Both-theme screenshots |
| Motion | Animation is purposeful, interruptible where required, and reduced-motion safe | Motion and reduced-motion captures |
| Content | Real copy, URLs, and control labels fit without hiding meaning | Long-copy fixture |

Structural inspection, screenshots, and computed metrics are complementary;
none is sufficient alone. Preserve approved copy, assets, destinations, and
unchanged baseline views. Report unverified checks and the exact reason rather
than implying cross-browser, conversion, or compliance evidence.

## Sources

Reviewed 2026-10-08. The material below is paraphrased and used as reference;
the links are not runtime dependencies.

- Figma, [UI design principles](https://www.figma.com/resource-library/ui-design-principles/).
- Nielsen Norman Group, [10 usability heuristics for user interface design](https://www.nngroup.com/articles/ten-usability-heuristics/).
- W3C, [Understanding Reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html), [Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html), [Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html), and [Pause, Stop, Hide](https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html).
- W3C WAI-ARIA Authoring Practices, [Tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/).
- W3C, [Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html).
