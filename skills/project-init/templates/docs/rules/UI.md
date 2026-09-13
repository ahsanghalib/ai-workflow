# Shared UI and Design-System Rules

Applies to the repository's designated shared UI package, shared visual
primitives, and cross-application design-system code, when present.

## 1. Purpose

The designated shared UI package contains reusable presentation primitives and
shared composed components.

Good candidates:

- Button
- Input
- Select
- Dialog
- Table primitives
- Form primitives
- Typography
- Layout primitives
- design tokens
- shared icons

Usually not appropriate:

- domain-specific business forms,
- domain workflows,
- API data-fetching logic,
- route-specific pages,
- domain authorization logic.

## 2. Component API Design

- Keep component APIs small and predictable.
- Prefer composition over dozens of boolean props.
- Preserve native HTML behavior when wrapping native elements.
- Forward relevant refs/attributes where framework patterns require it.
- Do not hide important accessibility behavior behind undocumented conventions.
- Avoid exposing internal implementation details through props.

## 3. Accessibility

Shared UI components must establish good defaults:

- keyboard support,
- focus management,
- correct roles,
- accessible labels,
- disabled semantics,
- aria attributes only when native semantics are insufficient,
- visible focus styles,
- reduced-motion support where relevant.

Accessibility defects in shared primitives multiply across the entire product and must be treated as high priority.

## 4. Styling

- Use project design tokens.
- Avoid application-specific colors/sizing inside generic primitives.
- Prefer variants with semantic names.
- Do not introduce arbitrary hard-coded styles when tokens exist.
- Keep class composition readable.
- Avoid specificity wars and global CSS leakage.
- Theme behavior must work across supported themes.

## 5. shadcn / Headless Primitives

If using shadcn or another headless system:

- treat copied components as owned source code,
- adapt them to project tokens/conventions,
- do not modify behavior casually without checking accessibility,
- keep local changes understandable,
- avoid adding multiple competing primitive libraries without justification.

## 6. Form Components

- Inputs must support labels, descriptions, errors, required/disabled states.
- Error rendering should be accessible.
- Do not make form components depend on one form library unless that is an intentional package design.
- Keep domain validation outside generic UI primitives.

## 7. Tables and Lists

- Shared table primitives provide presentation and interaction primitives, not domain data access.
- Pagination/filter state belongs in feature/application code unless intentionally abstracted.
- Large lists should support virtualization only when needed.
- Loading/empty/error states should have reusable patterns without forcing one domain-specific message.

## 8. Icons

- Use the selected icon system consistently.
- Decorative icons should be hidden from assistive technology.
- Meaningful icon-only controls need accessible names.
- Do not embed large custom SVG copies when an existing project icon exists.

## 9. Responsive Behavior

- Components should behave predictably across supported viewport sizes.
- Avoid fixed dimensions that break localization or dynamic content without reason.
- Test overflow behavior.
- Generic components must not assume one application layout width.

## 10. Domain Boundaries

The designated shared UI package must not depend on:

- backend code,
- database packages,
- auth implementation,
- domain API clients,
- application route modules.

If a shared component becomes domain-aware, move it to the owning feature or a domain-specific package.

## 11. Dependencies

- Keep UI package runtime dependencies small.
- Do not add a second component system to solve one missing component without review.
- Peer-dependency relationships must be intentional for the selected
  framework packages.
- Browser bundle impact matters.

## 12. Testing

Test shared components for:

- keyboard behavior,
- accessible naming/roles,
- critical variants,
- controlled/uncontrolled behavior where supported,
- event forwarding,
- disabled state,
- focus behavior for overlays/dialogs.

Avoid snapshot-only tests for interactive components.
