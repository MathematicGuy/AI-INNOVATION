# Pattern: Data Grids and Editable Cells

Back to [`INDEX.md`](../INDEX.md).

## Use When

Displaying a dense table, comparison matrix, or grid where a user scans
across rows/columns to compare values, and where cells may be clicked to
edit.

## Do Not Use When

Content is a single free-form document or a card list with no row/column
comparison need.

## User Need

Users comparing values across rows or columns rely on stable spatial
position. Editing one cell must not shift the position of neighboring
content the user is tracking.

## Preferred Behavior

When inline editing occurs inside a fixed comparison grid, preserve the cell
footprint so neighboring content does not reflow. Give every cell a fixed
height (e.g. `height: 120px; overflow: hidden`); the editing control (e.g. a
textarea) fills the same fixed area (`flex: 1; resize: none;
overflow-y: auto`). Switching a cell into edit mode should change only the
cursor and a left-border accent or similar state signal — not the cell's
size or position.

## Dependencies

Row alignment, column width, overflow behavior, keyboard focus, responsive
layout.

## Trade-offs

Fixed cells may require internal scrolling for long content, which hides
some content until the user scrolls within the cell.

## Exceptions

- Content-authoring views where editor expansion is the primary task (not a
  comparison grid).
- Mobile layouts where cells already stack vertically (no row/column
  comparison to preserve).
- Cases where a fixed height would make required content permanently
  inaccessible even with internal scrolling — use an explicit expanded
  editor (e.g. a modal) instead.

## Accessibility

Do not auto-resize the textarea or span the editing cell across additional
grid columns (`grid-column: span 2`) — both cause neighboring cells to
reflow, which also disrupts assistive-technology users tracking position by
structure.

## Responsive Behavior

On narrow viewports where the grid reflows to stacked cards, the fixed-cell
constraint no longer applies — apply the exception above.

## Validation

Verify no layout shift occurs when toggling a cell between read and edit
states, at the grid's normal width and with realistic (not short) mock
content in the cell.

## Related Patterns

`spacing-and-grouping.md`, `disclosure-controls.md`
