# Motion recipes

Adapt these to the project's tokens and component primitives. They are patterns,
not a reason to add animation where the frequency gate rejects it.

## Button press

```css
.button {
  transition: transform 160ms var(--ease-out);
}

.button:active {
  transform: scale(0.97);
}
```

Gate additional hover styling for fine pointers.

## Popover or tooltip

```css
.popover {
  transform-origin: var(--transform-origin);
  transition: opacity 180ms var(--ease-out),
              transform 180ms var(--ease-out);
}

.popover[data-starting-style],
.popover[data-ending-style] {
  opacity: 0;
  transform: scale(0.95);
}
```

Use a centered origin for a modal, not an anchored popover.

## Modal

```css
.modal {
  transform-origin: center;
  transition: opacity 250ms var(--ease-out),
              transform 250ms var(--ease-out);
}

.modal[data-starting-style],
.modal[data-ending-style] {
  opacity: 0;
  transform: scale(0.96);
}

.backdrop {
  transition: opacity 250ms var(--ease-out);
}
```

## Drawer

```css
.drawer {
  transform: translateY(0);
  transition: transform 250ms var(--ease-drawer);
}

.drawer[data-closed] {
  transform: translateY(100%);
}
```

Add a spring and gesture-specific handling only when dragging is part of the
interaction.

## Toast

```css
.toast {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 200ms ease-out, transform 200ms ease-out;
  @starting-style {
    opacity: 0;
    transform: translateY(100%);
  }
}
```

If `@starting-style` is unsupported, use the framework's mount-state pattern.
Use transitions rather than restarting keyframes as toasts are added rapidly.

## Accordion

```css
.content {
  overflow: hidden;
  transition: height 200ms var(--ease-out),
              opacity 200ms var(--ease-out);
}
```

This is an intentional layout exception. Measure content height or use the
existing accessible primitive instead of animating to `auto`.

## Staggered entrance

Use for an occasional list or grid, never to delay access to high-frequency UI.

```css
.item {
  opacity: 0;
  transform: translateY(8px);
  animation: fade-in 240ms var(--ease-out) forwards;
}

.item:nth-child(2) { animation-delay: 40ms; }
.item:nth-child(3) { animation-delay: 80ms; }

@keyframes fade-in {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

Stagger must never block interaction.

## Hold to confirm

For a destructive action where a plain click is too easy to trigger:

```css
.overlay {
  clip-path: inset(0 100% 0 0);
  transition: clip-path 200ms var(--ease-out);
}

.button:active .overlay {
  clip-path: inset(0 0 0 0);
  transition: clip-path 2s linear;
}
```

The deliberate phase is slow and linear; release is fast.

## Drag to dismiss

Use pointer capture, reject extra touches after the drag begins, damp movement
past boundaries, and settle with a spring when the project already provides
one. A flick may dismiss based on velocity as well as distance. Keep the
gesture's reduced-motion path and keyboard alternative usable.
