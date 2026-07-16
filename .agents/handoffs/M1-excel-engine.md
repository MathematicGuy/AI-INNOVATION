# Handoff: M1 — Deterministic Excel Engine V0

You are picking up implementation work on the **Accounting Excel Cowork Agent** project.
Working directory: e:\VIN-INTERNSHIP\Best-Work-Agent

---

## Project Context (read these before doing anything)

- Milestone roadmap: [MILESTONE.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/MILESTONE.md) (view the M1 section)
- Full WBS + Gantt: [PROGRESS.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/PROGRESS.md) (section 2, items 2.x)
- Product contracts: [excel_tool_layer.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/product/excel_tool_layer.md)
- Validation policy: [validation_deviation.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/product/validation_deviation.md)
- Agent rules: [AGENTS.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/AGENTS.md) (read fully before touching code)

---

## Your Scope — M1 Only

M1 has three harness stories. Complete them in this order:

### Story 1: US-106 — Excel Tool Layer
File: [US-106-excel-tool-layer.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/stories/US-106-excel-tool-layer.md)
Harness lane: normal

Implement 14 openpyxl tool functions under a strict allowed-list registry:
  - create_workbook
  - build_catalogue_sheet (DM_HangHoa, DM_Kho)
  - build_transaction_sheet (NhapKho, XuatKho)
  - build_inventory_balance_by_lot (TonKho_TheoLo)
  - build_expiry_warning_sheet (CanhBao_HSD)
  - build_summary_report (BaoCao_TongHop)
  - set_column_width, apply_header_style, add_dropdown_validation, add_data_validation,
    freeze_panes, set_print_area, save_workbook, add_named_range

Each function must: accept typed args only, write to a provided Workbook object, never do arbitrary Python execution outside these 14 functions, and be unit-testable in isolation.

### Story 2: US-107 — Inventory Workbook Vertical Slice
File: [US-107-inventory-workbook-slice.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/stories/US-107-inventory-workbook-slice.md)
Harness lane: high_risk

Build a CLI: EXECUTION_MANIFEST.json → inventory.xlsx
The manifest schema is in: [excel_tool_layer.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/product/excel_tool_layer.md)

Required sheets: DM_HangHoa, DM_Kho, NhapKho, XuatKho, TonKho_TheoLo, CanhBao_HSD, BaoCao_TongHop
Formula invariant: Tồn = Tổng nhập − Tổng xuất (must be verified by test)
Conditional formatting: red = expiry ≤ 30 days, yellow = expiry ≤ 90 days
Run 10 manifest test runs — all must open 100%, pass sheet/column checks.

### Story 3: US-108 — Validation & Deviation Policy
File: [US-108-validation-deviation-policy.md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/docs/stories/US-108-validation-deviation-policy.md)
Harness lane: normal

Output: VALIDATION_REPORT.md after each manifest run
Status values: PASS | WARNING | BLOCKED

Blocking checks (BLOCKED):
  - Negative stock (Tồn < 0)
  - Duplicate lot reference
  - Invalid warehouse/product reference

Warning checks (WARNING):
  - Expiry within 90 days
  - Missing unit of measure

---

## Harness Workflow — follow this for each story

```
# Start a story
.\scripts\bin\harness-cli.exe story update --id <NNN> --status in_progress

# After implementation — record a trace (example for US-106)
.\scripts\bin\harness-cli.exe trace add --story 106 --event implementation_complete --proof 'pytest tests/test_excel_tools.py -v passed'

# Complete a story (only after tests pass)
.\scripts\bin\harness-cli.exe story complete 106
```

Run audit after each story close to verify entropy drops:
```
.\scripts\bin\harness-cli.exe audit
.\scripts\bin\harness-cli.exe propose
```

---

## Suggested Skills — invoke these in order
1. **writing-plans** — before writing any code, create an implementation plan for US-106
2. **test-driven-development** — write tests for each tool function before implementing it (14 functions = 14 test targets)
3. **incremental-implementation** — implement one sheet/function at a time, commit after each green test
4. **verification-before-completion** — run the full 10-manifest test suite before calling `story complete` on US-107
5. **systematic-debugging** — if formula reconciliation or conditional formatting fails

---

## Definition of Done for M1

All three must be true before M1 is considered complete:
- 10 manifest runs produce valid XLSX files (100% open rate)
- All 7 required sheets present with correct columns
- VALIDATION_REPORT.md reports PASS for clean manifests and BLOCKED for defective ones
- Formula: Tồn = Tổng nhập − Tổng xuất verified by automated test
- No source file ever overwritten
- All three stories closed in the harness: `story complete 106`, `story complete 107`, `story complete 108`
- `harness-cli audit` entropy drops from 90 to 60 after all three closes

---

## Do NOT build (out of scope for M1)

- LLM integration of any kind
- LangGraph
- FastAPI
- Chat UI
- Supervisor/Intent agent
- Spec/Plan generation
- Memory layer
- Langfuse

---

## Tech constraints

- Python with openpyxl only (no xlwings, xlrd, pandas for Excel output)
- No arbitrary code execution — all Excel writes go through the 14 registered functions
- ADR-0009 (docs/decisions/0009-excel-tool-layer-restriction.md) governs this constraint
