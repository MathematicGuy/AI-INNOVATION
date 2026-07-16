# Stable Design Principles

Back to [`INDEX.md`](../INDEX.md).

Durable, cross-project design theory. For conditional UI-specific guidance,
use `../patterns/`. For repository-specific facts, use
`docs/design/PROJECT_CONSTRAINTS.md`.

## Definition of Clean Design

Clean design is the deliberate removal, grouping, demotion, or simplification
of non-essential interface elements so the user's primary task becomes
obvious and efficient.

Clean design is **not**: removing information without understanding its
purpose, hiding essential actions behind unclear icons or menus, shrinking
typography to force content into one row, replacing clarity with empty
space, using low-contrast colors to appear elegant, or making every screen
visually identical.

```text
Clean Design
= Clear task priority
+ Necessary information
+ Predictable interaction
+ Strong visual hierarchy
+ Strategic subtraction
- Avoidable cognitive load
```

## First-Principles Questions

Before proposing a visual change, answer: Who is the user? What outcome are
they trying to achieve? What information must they understand? What action
must be easiest to find? What errors are costly or hard to reverse? What can
be removed, merged, delayed, or demoted? What must remain visible? What
dependency could break? How will the design behave with realistic data? How
will success be validated?

## Product and Interaction Principles

### User-Centered Design

Base decisions on user goals, observed behavior, research evidence, or
clearly labeled assumptions. Identify primary/secondary tasks, separate
novice from expert needs, test concepts early, use language users
understand, use progressive disclosure for advanced detail. Avoid designing
only for the requesting stakeholder or assuming specialized-terminology
familiarity.

### Navigation and Information Architecture

Group content by user mental model, keep labels concrete and distinct, show
location/progress/next-steps, keep recurring navigation stable. A new user
should be able to answer: Where am I? What can I do here? Where can I go
next? How do I return?

### Usability and Efficiency

Provide sensible defaults, keep frequent actions visible, place controls
near affected content, preserve user input on error, prefer recognition over
recall. Avoid repeated navigation for one task, hidden primary actions,
modal chains, or forcing users to remember prior-screen information.

### Feedback and System Status

Confirm successful actions; show loading, empty, error, success, disabled,
and partial states; explain unavailable actions; make destructive actions
reversible when possible; match feedback intensity to consequence. Avoid
silent state changes, generic error messages, and animation that delays task
completion.

### Consistency

Use design tokens for color, spacing, radius, type, elevation, motion. Reuse
component behavior across screens; align to a shared grid. Consistency
reduces learning cost, but do not preserve a poor pattern merely because it
already exists.

### Flexibility and Efficiency

Keep the default path simple; add shortcuts, saved views, bulk actions, and
customization as progressive enhancements without forcing advanced controls
into the primary hierarchy.

### Strategic Subtraction

Subtraction is broader than deletion: Remove, Merge, Demote, Defer, Replace,
Standardize. Before changing a component, identify the user need it serves,
dependencies, accessibility meaning, and edge cases. Never delete a
component only because it makes the screen look crowded. Full safeguard in
`SKILL.md` §8.

### Emotional Design

A clean interface should feel trustworthy, calm, and intentional — polished
spacing, rhythm, typography, and feedback matched to product domain. Empty
and error states should be helpful, not sterile. Aesthetic appeal supports
trust but cannot compensate for poor information architecture.

## Visual Composition Principles

- **Balance** — distribute visual weight (mass, density, color weight,
  alignment, negative space) so layout feels stable; symmetry is not
  mandatory when content importance is unequal.
- **Contrast** — use size, weight, color, spacing, shape, position, or
  motion differences for meaning, not decoration.
- **Hierarchy** — build through placement, size, weight, contrast, grouping,
  spacing, then decoration, in that order. When everything is emphasized,
  nothing is.
- **Unity and Harmony** — share spacing, typography, radius, icon style, and
  interaction behavior across components; meaningful differences should
  still remain visible.
- **Repetition** — repeat components when purpose and behavior are
  equivalent; do not create visual variants without a functional reason.
- **Movement/Visual Flow** — guide the eye via reading direction, alignment,
  grouping, and progressive disclosure; avoid decorative motion competing
  with task flow.
- **Variety** — variation must communicate hierarchy, category, state, or
  interaction — never introduced purely for visual interest.
- **Emphasis** — give strongest emphasis to the element most important to
  the current task; limit competing primary actions per region.
- **Proximity** — related elements together, unrelated elements apart;
  spacing is semantic and should be tried before dividers, borders, or
  background containers (see `patterns/spacing-and-grouping.md`).
- **White Space** — an active structural element for grouping, hierarchy,
  and readability, not leftover space; avoid spacing so generous it
  separates related content or reduces information efficiency.
- **Proportion** — size should reflect importance and content/interaction
  needs; avoid oversized headings, forced-tiny labels, oversized low
  priority controls, or unstable narrow-region wrapping.

## Design Review Heuristics (fast checks, not laws)

- **Five-second hierarchy test** — a new user should identify page purpose,
  most important information, primary action, and next likely step within
  five seconds.
- **One-primary-action test** — each region has one dominant action;
  secondary actions may remain visible but visually quieter.
- **Spacing-before-decoration test** — try proximity and white space before
  adding borders, cards, shadows, background colors, or dividers.
- **Recognition-before-recall test** — keep options, state, and context
  visible when users need them.
- **Real-data stress test** — long titles, multilingual labels, missing
  values, large counts, many tags, validation errors, narrow screens, high
  zoom.
- **Color-independence test** — every color-coded state also has a
  textual, structural, iconographic, or programmatic signal.
- **Novice-language test** — a first-time user understands labels without
  abbreviations, unexplained icons, or specialist vocabulary.

## Common Failure Modes

Reject or revise proposals that: equate minimalism with hiding, remove
labels from unfamiliar icons, use 10px-or-smaller text to fit a layout, use
low contrast as a visual style, add cards around every group, use excessive
borders or shadows, create multiple competing primary actions, rely on hover
for essential information, ignore long content and localization, optimize
one screenshot while breaking responsive behavior, change a shared component
without checking other screens, or implement before understanding the user
task.
