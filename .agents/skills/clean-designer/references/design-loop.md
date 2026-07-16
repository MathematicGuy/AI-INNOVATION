# Clean Design Loop — Full Detail

Back to [`INDEX.md`](../INDEX.md). Compact version lives in `SKILL.md` §6–7.

The agent must follow this loop in order. It may return to an earlier stage
when new evidence appears.

```text
Establish scope → Observe → Reconstruct the user task → Diagnose
→ Map dependencies → Explore alternatives → Evaluate trade-offs
→ Subtract strategically → Specify the design → Prototype with mock data
→ Validate → Stop and wait for user command
```

## Stage 0 — Establish Scope

Determine screen/flow/component, target users, user goal, platform and
viewport, technical constraints, required features, available design system,
and whether the request is an audit, redesign, or implementation task. Ask a
question only when missing information blocks a responsible decision.

## Stage 1 — Observe

Record only what is visible or verifiable, from a live browser, screenshots,
prototypes, requirements, or code. Separate evidence into **Observed**,
**Inferred**, and **Unknown**. Observe layout/grid, hierarchy, typography,
spacing, color/contrast, controls/states, density, repetition, alignment,
grouping, feedback, terminology, responsive clues, and accessibility issues.
Do not invent interactions that cannot be observed.

## Stage 2 — Reconstruct the User Task

Describe user type, entry point, intended outcome, decisions the user must
make, information required, likely failure points, and completion criteria.
State the primary task in one sentence:

```text
The user needs to [action] so they can [outcome] without [major friction or risk].
```

## Stage 3 — Diagnose

Audit against `principles.md`. For every issue give evidence, violated
principle, user impact, severity, confidence, and affected users/states.

Severity: **Critical** (prevents task completion / serious error risk /
blocks accessibility), **High** (major confusion, repeated failure,
substantial inefficiency), **Medium** (noticeable friction or
inconsistency), **Low** (minor refinement). Do not convert personal taste
into a high-severity issue.

## Stage 4 — Map Dependencies

Check feature visibility, user workflow, information hierarchy, navigation,
component states, responsive layout, accessibility, analytics, permissions,
localization, data length/variability, technical architecture, and
design-system consistency.

```text
If we change [element],
then [direct effect] occurs,
which may affect [dependent feature or state],
creating [risk or trade-off].
We can mitigate it by [design or implementation response].
```

## Stage 5 — Explore Alternatives

Generate at least two materially different alternatives when trade-offs are
meaningful. For each: structure, primary benefit, primary cost, best-fit
context, dependency risk, responsive behavior, accessibility implications.
Do not present superficial alternatives that only change color, radius, or
decoration.

## Stage 6 — Evaluate Trade-offs

Evaluate on task clarity, scanning speed, information density, learnability,
accessibility, error prevention, responsive stability, implementation
complexity, consistency, future scalability. Use a recommendation, not a
neutral list:

```text
Recommend: [option]

Because:
- [user-centered reason]
- [system reason]
- [evidence or principle]

Trade-off:
- [what becomes worse or less optimal]

Mitigation:
- [how to reduce the cost]
```

## Stage 7 — Strategic Subtraction

Inventory every visible element and assign one action: Preserve, Remove,
Merge, Demote, Defer, Replace, Standardize. For every removed/hidden
element, state how its underlying user need is preserved.

**Subtraction test** — an element may be removed or deferred only when all
are true: it does not support the primary task at that moment; removal does
not hide an important state or consequence; users can still discover it when
needed; accessibility is not weakened; no dependent feature becomes unclear;
the design remains understandable with realistic data.

## Stage 8 — Specify the Design

Specify layout structure, component hierarchy, spacing, alignment,
typography, color roles, interaction states, content rules, responsive
behavior, accessibility behavior, and edge cases. Prefer design tokens over
isolated values, and use existing project tokens when available:

```css
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-6: 24px;
--radius-sm: 6px;
--radius-md: 10px;
--text-primary: ...;
--text-secondary: ...;
--border-subtle: ...;
```

## Stage 9 — Prototype with Mock Data

Cover normal, long-content, empty, loading, error, disabled, selected/active,
and responsive states, with realistic (not uniformly short) mock data.
Preserve core feature parity, use semantic HTML, keep components modular,
separate data from presentation, use accessible names/states. Do not connect
to production services or overwrite production code without explicit
approval. Mark assumptions and temporary mock behavior.

## Stage 10 — Validate

See `validation.md` for the full checklist (task, visual, accessibility,
feature-preservation).

## Stage 11 — Stop and Wait

Summarize what changed, state unresolved assumptions, identify the most
important user decision, ask one focused question or offer clear approval
choices, then stop. Do not continue redesigning, connect production data, or
modify additional screens until the user gives a command.

## Change-Impact Matrix

Mandatory when: removing a feature/component, hiding information, changing
navigation, changing a repeated system pattern, changing a data-dense
layout, or replacing text with icons.

| Proposed change | User benefit | Cost or loss | Dependencies | Risk | Mitigation | Recommendation |
|---|---|---|---|---|---|---|
| Change being considered | Improvement for the user | What becomes weaker | Features, states, layouts, or systems affected | Low / Medium / High | How to preserve value | Adopt / Test / Reject |

## Feature-Preservation Matrix

Required before implementation:

| Existing feature or information | User need served | New location or representation | State coverage | Preserved? |
|---|---|---|---|---|
| Existing item | Why it matters | Where it appears after redesign | Normal, loading, error, etc. | Yes / Partial / No |

A redesign is incomplete when a required feature has no clear representation.

## Output Contract (full)

Unless the user requests another format:

A. Design Summary — B. Observed Evidence — C. User Task — D. Issues (table:
issue, evidence, principle, user impact, severity, confidence) — E.
Alternatives — F. Dependency and Trade-off Analysis (Change-Impact Matrix) —
G. Recommended Design — H. Strategic Subtractions (table: element, action,
reason, how value is preserved) — I. Implementation Specification — J.
Prototype — K. Validation and Next Decision.
