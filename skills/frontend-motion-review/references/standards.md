# Motion standards

Use these values as defaults only when the project has no established tokens.
Project tokens and component primitives take precedence when they express the
same intent.

## Purpose and frequency

Valid purposes are spatial consistency, state indication, feedback,
explanation, and preventing a jarring change. Frequent actions should be
instant or nearly imperceptible; keyboard-initiated actions should not animate.

## Curves

| Situation | Default |
| --- | --- |
| Entering or exiting | `ease-out` |
| Moving or morphing on screen | `ease-in-out` |
| Hover or color change | `ease` |
| Constant motion or progress | `linear` |
| Default | `ease-out` |

Preferred reference curves:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
```

Do not use `ease-in` for ordinary UI. Do not add a new token if the codebase
already has an equivalent.

## Duration

| Element | Range |
| --- | --- |
| Button press feedback | 100–160ms |
| Tooltip or small popover | 125–200ms |
| Dropdown or select | 150–250ms |
| Modal or drawer | 200–500ms |
| General UI | under 300ms unless justified |

Longer marketing or explanatory motion requires a surface-specific reason.

## Physicality and interruption

- Never use `scale(0)` for an entrance. Start near `scale(0.9–0.97)` with
  opacity when scaling is appropriate.
- Trigger-anchored popovers, dropdowns, menus, and tooltips should use the
  trigger-aware transform origin. Centered modals are the exception.
- Use transitions for rapidly-triggered state changes because they retarget
  from the current value. Use springs for interruptible, gesture-driven motion.
- Enter and exit through coherent paths. Deliberate input may be slower while
  the system response should be fast.

## Performance

Prefer `transform` and `opacity`. Treat layout properties as deliberate
exceptions. Prefer CSS for predetermined motion and WAAPI or the existing
library for dynamic control. Do not drive every child's transform from a CSS
variable on a parent when direct updates are possible.

## Accessibility

```css
@media (prefers-reduced-motion: reduce) {
  .element {
    animation: fade 200ms ease;
  }
}

@media (hover: hover) and (pointer: fine) {
  .element:hover {
    transform: scale(1.02);
  }
}
```

The reduced-motion variant should remove movement and preserve useful state
feedback where possible. Verify focus visibility, keyboard operation, semantic
controls, and the absence of hover-only functionality.

## Automatic findings

Flag these unless the code contains a specific, evidence-backed exception:

- `transition: all`;
- `scale(0)` entrances;
- `ease-in` on UI;
- UI animation over 300ms without a reason;
- trigger-anchored overlays scaling from center;
- keyframes for rapidly retriggered UI;
- avoidable animation of layout properties;
- missing reduced-motion handling;
- ungated hover motion; and
- all-at-once group entrances where a short stagger improves comprehension.

When proposing a fix, prefer this order: delete, reduce, fix easing, fix
origin, make interruptible, move work to compositor-friendly properties, tune
asymmetric timing, then add polish.

## Feel checks

If source inspection cannot settle the result, inspect it at 2–5× speed,
frame-by-frame, and on a real touch device for gestures when available. Record
the check as unrun when the approved browser/device capability is unavailable.
