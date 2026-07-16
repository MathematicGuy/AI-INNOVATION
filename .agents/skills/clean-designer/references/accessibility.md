# Accessibility

Back to [`INDEX.md`](../INDEX.md). Load for any change affecting interaction,
not only dedicated accessibility audits.

Accessibility is a design requirement, not a final compliance pass.

The agent must: maintain readable text sizes, preserve sufficient contrast,
provide visible keyboard focus, avoid color-only communication, use semantic
structure, support zoom and reflow, provide meaningful labels, ensure touch
targets are usable, and expose status changes to assistive technology.

Do not rely on tooltips for information required to understand or complete
the task. For unfamiliar concepts, prefer clear text labels over icon-only
controls.

## Accessibility Validation Checklist

- Can it be understood without color?
- Can it be operated by keyboard?
- Is focus visible?
- Does it survive zoom and narrow widths?
- Are labels understandable to novice users?

## Color-Independence Test

Every color-coded state must also have a textual, structural, iconographic,
or programmatic signal (e.g. a colored risk dot paired with an accessible
label such as `Medium risk: Reproducibility`).
