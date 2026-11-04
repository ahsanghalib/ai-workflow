# Implementation and quality reference

Load for design-system extraction, implementation fidelity, content fit, or final quality review.

## 25. COLOR EXTRACTION RULE

Actively analyze and extract colors from the generated image(s).

Inspect:

- background color
- panel colors
- accent colors
- button fills
- text color hierarchy
- border color logic
- shadow color mood
- image tint / grade
- gradient restraint or intensity

The implemented website should preserve the original color logic as closely as reasonably possible.

Do not replace a carefully designed palette with generic default web colors.

---

## 26. DESIGN-TO-CODE COPY DISCIPLINE

After generating and analyzing the reference image(s), implement the website in a copy-oriented way.

This means:

- follow the references closely
- preserve layout logic
- preserve spacing rhythm
- preserve section ordering
- preserve text/image balance
- preserve typography mood
- preserve component style
- preserve overall visual cleanliness

Do not drift into a different design direction during implementation.
Do not “improve” the design by replacing it with a generic coded layout.

The goal is not:

- inspired by the image

The goal is:

- visually faithful to the image, translated into real frontend

---

## 27. ANTI-DRIFT IMPLEMENTATION RULE

A common failure mode is design drift:
the generated images look strong, but the coded result becomes generic.

Strictly avoid that.

During implementation:

- do not simplify into default templates
- do not replace distinctive sections with generic rows
- do not compress generous spacing into dense layout
- do not replace strong typography with plain hierarchy
- do not remove the page’s visual identity for convenience
- do not merge section logic into repetitive patterns that were not present in the source images
- do not reintroduce nested-box complexity that was intentionally removed during analysis

The final coded result should still feel like the same website as the generated references.

## 27A. COMPONENT-SYSTEM INTEGRATION GUARD

Image fidelity does not justify creating parallel CSS for repeated roles.
Before translating a reference, compare its headings, body text, labels, cards,
section shells, controls, illustrations, and theme surfaces with the existing
implementation. Prefer reuse over variation when anatomy and behavior match:
one shared component/class with shared typography, spacing, breakpoint, and
light/dark semantic tokens. Use a named variant or optional slot only for a
real semantic difference. Remove superseded declarations instead of appending
section-ID or last-item overrides. Use logical properties for RTL, and test long
copy and odd item counts before accepting a visual match.

For a bounded fix with supplied references and an existing design system, inspect
the supplied reference and current implementation first; do not generate a new
image merely to justify a small correction. For the detailed reuse and
validation examples, read [`ui-design-system`'s component consistency
reference](../../ui-design-system/references/component-consistency.md) when
available.
For the first-pass visual and responsive scorecard, also read
[`ui-review-principles.md`](../../ui-design-system/references/ui-review-principles.md).

---

## 28. MISSING DETAIL RESOLUTION

When implementing from images, some details may still be unclear.

Resolve ambiguity by following this order:

1. preserve the visible design language
2. preserve layout and spacing logic
3. preserve component family
4. preserve mood and polish level
5. generate an extra detail image if needed
6. regenerate the section as a fresh standalone image if needed
7. only then choose the most implementation-friendly faithful version

Do not fill ambiguity with generic defaults too quickly.

---

## 29. ANTI-AI-SLOP RULES

Strictly avoid these patterns unless explicitly requested.

### Layout slop

- one giant unreadable collage
- endless centered sections
- identical card rows repeated section after section
- cloned left-text/right-image blocks
- fake complexity without hierarchy
- decorative empty space with no purpose
- cards-inside-cards-inside-cards
- giant rounded wrapper sections around everything
- overcompartmentalized dashboard framing

### Visual slop

- default purple/blue AI gradients
- too many glowing edges
- floating blobs everywhere
- glassmorphism stacked without reason
- random futuristic details with no structure
- over-rendered noise that hides the layout

### Typography slop

- giant heading + weak tiny subcopy
- too many font moods
- awkward line breaks
- lazy all-caps everywhere
- generic gradient headline tricks

### Content slop

Avoid generic filler vibes like:

- unleash
- elevate
- revolutionize
- next-gen
- seamless
- transformative platform

Avoid fake brand slop:

- Acme
- Nexus
- Flowbit
- Quantumly
- NovaCore

Avoid fake complexity slop:

- pseudo-enterprise control labels
- decorative system markers
- filler status microcopy
- fake operator / runtime / orchestration jargon unless truly central to the brand

### Density slop

- over-packed sections
- card overload
- tiny spacing between major sections
- visually exhausting walls of content

---

## 30. TYPOGRAPHY-FIRST DISCIPLINE

Typography is a primary design material.

Always ensure:

- clear size contrast
- obvious reading order
- strong display moments
- readable body text
- concise copy
- section headings that reinforce structure

For editorial directions:

- let typography shape composition

For tech/product directions:

- let typography communicate trust and precision

---

## 31. SECTION RHYTHM RULE

A high-end site does not feel like the same block repeated forever.

Vary section rhythm across the page by changing:

- density
- image-to-text ratio
- alignment
- scale
- whitespace
- card grouping
- background intensity
- visual tempo

But:

- keep the page coherent
- keep spacing controlled
- avoid random jumps
- keep each section clean enough to analyze well

---

## 32. DENSITY & SPACING DISCIPLINE

Do not make the website too dense.

The page should breathe.

Rules:

- use even section spacing
- keep major section gaps controlled and intentional
- allow negative space to create calmness
- avoid one section feeling cramped while the next feels empty
- smaller sections should still have enough surrounding space
- prefer analyzable generous spacing over compressed compositions
- do not fill every available area with extra UI
- let simplicity do part of the design work

A premium website should feel:

- open
- composed
- balanced
- confident
- breathable

Not:

- cramped
- noisy
- uneven
- overfilled
- visually exhausting

---

## 33. DEFAULT SECTION PACKS

### 4-section pack

1. Hero
2. Features
3. Social proof / testimonial
4. CTA

### 8-section pack

1. Hero
2. Trust bar
3. Features
4. Product showcase
5. Benefits / use cases
6. Testimonials
7. Pricing
8. CTA

### 12-section pack

1. Hero
2. Trust bar
3. Feature grid
4. Product preview
5. Problem / solution
6. Benefits
7. Workflow
8. Metrics / proof / integration
9. Testimonials
10. Pricing
11. FAQ
12. CTA + footer

In an image-capable harness, these should usually become section-by-section images, not one compressed sheet.

---

## 34. MULTI-IMAGE CONSISTENCY RULE

For multi-image websites, enforce:

- same brand world
- same type scale logic
- same spacing discipline
- same CTA styling
- same icon mood
- same image treatment
- same tonal language
- same component family

Image 2, 3, or 8 must not drift into a different website.

---
