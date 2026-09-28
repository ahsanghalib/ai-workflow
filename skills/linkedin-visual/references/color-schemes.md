# LinkedIn visual color schemes

These are the five user-requested campaign schemes for the Ahsan LinkedIn
visual system. They are controlled variants of the same layout identity, not
five unrelated brands. Use one scheme for the complete carousel.

## Selection contract

- If the approved brief names a scheme, use that scheme.
- Otherwise use `Lime Signal` as the deterministic default. Choose another scheme only deliberately from the approved brief or documented topic mapping.
- Record the selected scheme name and token values in the post file's visual-
  generation section and in the QA receipt.
- Keep the selected scheme unchanged across every page in one carousel.
- On a rerender, reuse the recorded scheme unless the user explicitly asks for
  a new selection.
- Do not communicate page order, status, or evidence through color alone.
  Pair accents with labels, numbers, rules, or layout changes.
- Run contrast and grayscale checks after selection. If a token fails, use the
  scheme's dark text and surface pairing rather than inventing a sixth scheme.

## Scheme catalog

<!-- markdownlint-disable MD013 MD060 -->

### 1. Lime Signal

The current default: warm paper, near-black ink, signal blue, and the bright
lime highlight used in the Figma base frame.

| Role | Token | Hex |
|---|---|---|
| Background | `paper` | `#F4F4EE` |
| Surface | `white` | `#FEFEFA` |
| Text | `ink` | `#161A1D` |
| Muted text | `ink-soft` | `#4B555C` |
| Grid | `grid` | `#D6DAD5` |
| Primary | `primary` (`signal-blue`) | `#2A60D4` |
| Accent | `lime` | `#F1F36D` |
| Dark surface | `ink` | `#161A1D` |

### 2. Blue Blueprint

A cooler engineering-note variant for systems, architecture, and tooling
topics.

| Role | Token | Hex |
|---|---|---|
| Background | `paper` | `#EEF3F7` |
| Surface | `white` | `#FFFFFF` |
| Text | `ink` | `#0E1B2A` |
| Muted text | `ink-soft` | `#526274` |
| Grid | `grid` | `#CFD8E2` |
| Primary | `primary` | `#2056A6` |
| Accent | `blue-highlight` | `#BFD5FF` |
| Dark surface | `ink` | `#0E1B2A` |

### 3. Amber Paper

A warmer editorial variant for lessons, tradeoffs, and practical engineering
stories.

| Role | Token | Hex |
|---|---|---|
| Background | `paper` | `#FBF3E8` |
| Surface | `white` | `#FFFDF8` |
| Text | `ink` | `#211A17` |
| Muted text | `ink-soft` | `#6A5B51` |
| Grid | `grid` | `#DED0C2` |
| Primary | `primary` | `#B6532A` |
| Accent | `amber-highlight` | `#F3C47A` |
| Dark surface | `ink` | `#211A17` |

### 4. Violet Signal

A reflective variant for model behavior, evaluation, and abstract systems
topics.

| Role | Token | Hex |
|---|---|---|
| Background | `paper` | `#F4F1FA` |
| Surface | `white` | `#FEFCFF` |
| Text | `ink` | `#211A35` |
| Muted text | `ink-soft` | `#635D78` |
| Grid | `grid` | `#D8D1E8` |
| Primary | `primary` | `#6E57C7` |
| Accent | `violet-highlight` | `#D4CBFF` |
| Dark surface | `ink` | `#211A35` |

### 5. Mint Relay

A calm systems variant for reliability, infrastructure, and responsible
practice topics.

| Role | Token | Hex |
|---|---|---|
| Background | `paper` | `#EDF7F1` |
| Surface | `white` | `#FBFFFC` |
| Text | `ink` | `#13251B` |
| Muted text | `ink-soft` | `#547064` |
| Grid | `grid` | `#CFDFD3` |
| Primary | `primary` | `#147A5B` |
| Accent | `mint-highlight` | `#AEE6C7` |
| Dark surface | `ink` | `#13251B` |

<!-- markdownlint-enable MD013 MD060 -->

## Application rules

Within one carousel, keep the selected scheme and identity anchors stable. Other
typography, spacing, tab treatment, and geometry choices remain brief-driven.
Swap semantic tokens only. Use the accent for one focal statement or one selected module per page; use the primary for
links, labels, markers, and rare action cues. Keep body copy on the text/surface
pairing, not on the accent, unless the contrast check passes.
