# Pattern: Status, Risk, and Severity Indicators

Back to [`INDEX.md`](../INDEX.md).

## Use When

Communicating a categorical state (risk level, severity, confidence,
pass/fail) attached to a labeled item, e.g. a paper-quality appraisal
category.

## Do Not Use When

The value is a continuous metric better shown as a number, sparkline, or
progress indicator (no discrete state to communicate).

## User Need

Users must identify the label-to-state association at a glance and
understand the state even without relying on color.

## Preferred Behavior

Pair a colored indicator (dot, chip, badge) with a mixed-case, readable text
label placed inline with it, rather than a stacked layout with an uppercase
label above/below the indicator.

```text
○ Reproducibility          ← preferred: inline, Title Case
REPRODUCIBILITY
       ○                   ← avoid: stacked, uppercase, taller footprint
```

Inline placement inside a fixed grid column reduces card height, improves
mixed-case readability, and strengthens the label-to-state association
versus a stacked matrix layout (which trades that off for stronger raw
column alignment).

## Dependencies

Card height, column width, label wrapping, responsive behavior, comparison
across cards, accessible naming.

## Trade-offs

Inline layout requires enough horizontal width per item; long labels may
wrap and disrupt row alignment across cards. Mitigate by testing the longest
label in the set at the target column width.

## Exceptions

When comparison must happen strictly by column (e.g. scanning one category
down many rows) rather than by item, a stacked matrix column may better
serve that specific comparison task — evaluate against the user's actual
task before choosing.

## Accessibility

Never use color alone. Pair the colored indicator with an accessible label,
e.g. `Medium risk: Reproducibility`, exposed to assistive technology.

## Responsive Behavior

Desktop: fixed multi-column grid (e.g. six columns). Narrower widths: reflow
to fewer columns (e.g. three columns by two rows), then one or two columns
on mobile. Preserve full labels at every width — do not truncate the
category name.

## Validation

Confirm risk/status is understandable with color removed (grayscale check),
and that the longest label in the set does not break row alignment.

## Related Patterns

`spacing-and-grouping.md`, `data-grids.md`
