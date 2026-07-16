# Clean Designer — Context Index

Load only what the current task needs. Do not load the full reference or
pattern set for a small, scoped change.

## Task Routing

| Current task | Load | Do not load when |
|---|---|---|
| Full design audit or redesign | `references/principles.md`, `references/design-loop.md` | Task is a single scoped pattern fix |
| Dense table, matrix, or editable/inline-edit grid | `patterns/data-grids.md` | No grid or tabular editing is involved |
| Expand/collapse, accordions, detail panels, "show more" | `patterns/disclosure-controls.md` | Content is permanently visible |
| Risk, status, severity, or confidence indicators | `patterns/status-indicators.md` | No state/severity signal is shown |
| Spacing, grouping, dividers, card boundaries | `patterns/spacing-and-grouping.md` | Layout is unchanged |
| Accessibility review or any change affecting interaction | `references/accessibility.md` | Never skip when interaction changes — always load |
| Responsive/breakpoint redesign | `references/responsive-design.md` | Layout is fixed-width and out of scope |
| Scoring or validating a finished design | `references/validation.md` | Task is still in the exploration stage |
| Repository-specific facts (existing components, prior decisions) | `docs/design/PROJECT_CONSTRAINTS.md` | Constraints file does not yet exist |
| Recent scoped corrections for this component/page | `docs/design/learnings/active/` (search by term) | Doing a full learning-archive audit only |

## Project Learning Storage

New corrections and decisions never go directly into `SKILL.md`. Route them:

| Content type | Destination |
|---|---|
| Unvalidated session correction | `docs/design/learnings/inbox/` |
| Validated, reusable, scoped learning | `docs/design/learnings/active/` |
| Replaced learning | `docs/design/learnings/superseded/` |
| Significant design trade-off decision | `docs/design/decisions/` |
| Machine-checkable rule | `tests/design/` |

See `docs/design/LEARNINGS_INDEX.md` for the lifecycle, promotion criteria,
and naming convention.

## Answering These Questions

1. **What should I load for an editable data grid?** → `patterns/data-grids.md`
2. **What should I load for an accessibility review?** → `references/accessibility.md` (always, when interaction changes)
3. **Where do new project corrections go?** → `docs/design/learnings/inbox/`
4. **When may a learning move from inbox to active?** → See promotion criteria in `docs/design/LEARNINGS_INDEX.md`
5. **Where are significant trade-off decisions recorded?** → `docs/design/decisions/`
