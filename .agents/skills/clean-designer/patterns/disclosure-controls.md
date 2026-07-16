# Pattern: Disclosure Controls

Back to [`INDEX.md`](../INDEX.md).

## Use When

A button or control expands/collapses content the user does not need
permanently visible (accordions, "show more," definition panels, detail
drawers).

## Do Not Use When

Content must always be visible for the user to complete the primary task
(see Hard Rules in `SKILL.md` — do not hide essential information behind a
disclosure control).

## User Need

The user must always know what action the control will perform next, and
what state the content is currently in.

## Preferred Behavior

A disclosure control must communicate either the action that will occur or
the current expanded state. Update the label dynamically to reflect the
current state rather than using a static label.

```text
Collapsed → Show category definitions
Expanded  → Hide category definitions
```

A static label that stays the same after the state changes is a cognitive
mismatch and violates the Feedback and System Status principle
(`references/principles.md`).

## Dependencies

Feedback/system-status visibility, accessible naming (`aria-expanded`),
keyboard operability.

## Trade-offs

None significant — dynamic labeling is strictly an improvement over a static
label for this control type.

## Exceptions

Icon-only toggle controls (e.g. a chevron) with a persistent programmatic
state (`aria-expanded`) and no visible text label are exempt from the
dynamic-text requirement, provided the icon itself changes (e.g. rotates) to
signal state.

## Accessibility

Set `aria-expanded` on the trigger and ensure the label or icon change is
also exposed to assistive technology, not only conveyed visually.

## Responsive Behavior

Disclosure controls behave the same across viewports; no special
responsive handling is required unless the collapsed/expanded content itself
needs to reflow.

## Validation

Toggle the control and verify the visible label (or accessible name, for
icon-only controls) changes to reflect the new state.

## Related Patterns

`spacing-and-grouping.md`
