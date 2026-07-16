# Pattern: Spacing and Grouping

Back to [`INDEX.md`](../INDEX.md).

## Use When

Deciding how to separate two adjacent components, sections, or groups of
related content.

## Do Not Use When

Content needs no separation (it is part of the same logical group and should
stay visually contiguous).

## User Need

Users infer structure from spacing before they consciously notice dividers.
Unnecessary borders and dividers add visual noise without adding
information.

## Preferred Behavior

Prefer margin/gap (white space) to separate two adjacent major components
(e.g. a glossary grid and a risk legend) instead of relying on divider
lines. White space separates content at least as clearly as a border,
without adding an extra visual element to the screen. Try the
spacing-before-decoration test (`references/principles.md`) before adding
borders, cards, shadows, background colors, or dividers.

## Dependencies

Visual hierarchy, perceived grouping, page density, responsive stacking
order.

## Trade-offs

Very dense screens with many adjacent sections may still need a subtle
divider when spacing alone cannot create clear-enough separation at a
readable content density — use sparingly, only after spacing has been tried.

## Exceptions

True tabular/comparison data where a divider communicates a structural
boundary (e.g. column separators in a table) is not covered by this pattern
— see `data-grids.md`.

## Accessibility

Spacing changes carry no accessibility signal on their own; ensure grouped
regions still have correct semantic structure (e.g. landmark or heading
elements) independent of visual spacing.

## Responsive Behavior

Preserve the same relative spacing scale when sections stack vertically on
narrow viewports; do not collapse spacing to zero, which reintroduces the
grouping ambiguity this pattern avoids.

## Validation

Visually confirm the two components read as distinct groups without a
divider, at both desktop and narrow viewport widths.

## Related Patterns

`disclosure-controls.md`, `status-indicators.md`
