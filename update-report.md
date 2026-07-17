# Update Report — Harness-Safe Template Cleanup

Date: 2026-07-17
Source spec: `TEMPLATE-REVIEWED.md`
Plan: `docs/superpowers/plans/2026-07-17-harness-safe-template-cleanup.md`
Branch: `main` (committed directly, consistent with this repo's workflow)

## What this change set does

Applies the safe, self-contained corrections from the review: removes Excel /
Best-Work-Agent context poisoning, adds hackathon scaffolding (NOW.md, JUDGING.md,
OWNERS.md, HACKATHON_RUNBOOK.md, and the pilot + presentation packages under
`demo-pitch-deck/`), tracks product-evidence directories, fixes README drift, and
hardens the `/api/v1/chat` response contract. It also folds in review-aligned
changes that were already sitting uncommitted in the working tree.

## Follow-up (2026-07-17) — rubric alignment + workflow rewrite

A second, doc-only pass aligned the operating files to the event's published rubric
and rewrote the MVP workflow. No code or harness-owned paths were touched.

| File | Change |
|------|--------|
| `JUDGING.md` | Replaced placeholder with the 6-criterion / 100-pt rubric table (`# | Criterion | Weight | What judges look for | Where we prove it`), each row mapped to real repo proof paths; added the 5 mandatory submission items checklist (11:00 AM, July 19th). Source: `Rubric.png`, `submission_checklist.png`. |
| `OWNERS.md` | Added a "Rubric rows owned" column so all 100 pts map across the four lanes (Frontend→04+shares 01; Backend→01; AI/Eval→02+05; Pilot/Pitch→03+06); added a Final Submission ownership table + rule to keep the AI Collaboration Log as you go. |
| `WORKFLOW-MVP.md` | Rewrote into an 18-section (0–18) generic Vietnamese template mirroring `workflow-mvp-example.md`'s representation (numbered sections, mermaid architecture diagram, ascii turn state machine, YAML/python contract blocks), folding in harness patterns from `.agents/archives/HARNESS-ENGINEERING-WORKFLOW.md` (four pillars, provider abstraction, ContextPack, loop guardrails, gated memory, shown-AND-recorded event stream, determinism seams, eval/release gates). Stays a template with `[...]` placeholders, grounded to this repo's FastAPI/LangGraph stack and the `POST /api/v1/chat -> {answer, explanation, sources, trace_id, status}` contract. |

Notes for the reviewer:
- Rubric rows are cross-referenced from both `JUDGING.md` and `OWNERS.md`; submission
  ownership in `OWNERS.md` mirrors the checklist in `JUDGING.md`.
- `WORKFLOW-MVP.md` was written with the Write tool (a Bash heredoc attempt failed on
  apostrophes in the body); the file is complete and current.

## Layout decision (important for the reviewer)

The review's Section 7 suggested root-level `pilot/` and `presentation/`. The
working tree already nested these under `demo-pitch-deck/`, so per the maintainer's
direction the scaffolding was written **into `demo-pitch-deck/pilot/` and
`demo-pitch-deck/presentation/`** (no root duplicates). All doc cross-references
point at the `demo-pitch-deck/` paths.

## Review items addressed

| Review item | Status | Where |
|-------------|--------|-------|
| P0.4 context poisoning | done | `examples/accounting-excel-agent/`, `AGENTS.md` |
| P0.6 README drift | done | `README.md` |
| P0.7 API contract leak | done | `src/models/schemas.py`, `src/api/routes.py`, `tests/unit/test_chat_contract.py` |
| P1 evidence dirs ignored | done | `.gitignore` |
| P1 Makefile check contract | done (folded in) | `Makefile` |
| Section 6/7/9 scaffolding | done | `NOW.md`, `JUDGING.md`, `OWNERS.md`, `HACKATHON_RUNBOOK.md` |
| Section 8 pilot pathway | done | `demo-pitch-deck/pilot/` |
| Section 5 presentation | done | `demo-pitch-deck/presentation/` |
| P0.1 declared deps (partial) | partial | `requirements.txt` folded in; full locking deferred |

## Deliberately deferred (need their own plans)

| Review item | Reason |
|-------------|--------|
| P0.1 full dependency/bootstrap locking | needs `pyproject.toml`, `uv.lock`, `.python-version`, `.env.example`, `.devcontainer/` — separate subsystem |
| P0.2 full-stack vertical slice | largest subsystem; frontend + backend + agent, mock/live modes |
| P0.3 product CI + memory-workflow hardening | CI subsystem (permissions, pinned actions, no auto-commit) |
| P1 runnable eval suite | eval subsystem (`eval/cases.jsonl`, `eval/run.py`, `release-gate.yaml`) |
| P0.5 two-repo identity split | architectural; needs a new repo, not an in-place edit |

## Harness-safety proof

- No file under `scripts/`, `harness.db*`, `.harness/`, `docs/decisions/`,
  `docs/product/`, `docs/stories/`, `docs/contracts/`, `docs/FEATURE_INTAKE.md`,
  `docs/CONTEXT_RULES.md`, `docs/TEST_MATRIX.md`, or `docs/HARNESS*.md` was moved,
  renamed, or altered.
- `AGENTS.md` change is prose-only in Section 11; the `HARNESS:BEGIN`/`HARNESS:END`
  block is byte-for-byte unchanged.
- Relocated Excel/Best-Work-Agent artifacts (Task 1) were confirmed unreferenced by
  any harness-owned or config file before moving (grep matched only the files
  themselves, the plan, and the review spec).
- `git diff --name-status f9480d0^..HEAD` (full list below) touches only
  non-harness paths; git recorded the moves as pure renames (R100).

## Verification run

- `python -m pytest -q` -> 7 passed (includes the 2 new contract tests).
- `python -m mypy src` -> no issues found.
- `python -m ruff check` / `ruff format --check` -> could NOT run: `ruff` is not
  installed in the active Anaconda interpreter. This is a P0.1 dependency gap, not
  a code defect; run once the environment is bootstrapped from `requirements.txt`.

## API contract change (P0.7) — before/after

- Before: `ChatResponse{response, analysis}`; errors returned `str(e)` to the client.
- After: `ChatResponse{answer, explanation, sources, trace_id, status}`; the internal
  `analysis` field is no longer surfaced; errors return a generic envelope
  `{status: "error", trace_id, message}` and the exception is logged server-side
  with the same `trace_id`.

## Files changed (git diff --name-status f9480d0^..HEAD)

```
M  .gitignore
M  AGENTS.md
A  HACKATHON_RUNBOOK.md
A  JUDGING.md
M  Makefile
A  NOW.md
A  OWNERS.md
M  README.md
A  demo-pitch-deck/pilot/PILOT_PATHWAY.md
A  demo-pitch-deck/pilot/evidence/.gitkeep
A  demo-pitch-deck/pilot/feedback-form.md
A  demo-pitch-deck/pilot/interview-notes/.gitkeep
A  demo-pitch-deck/presentation/DECK_OUTLINE.md
A  demo-pitch-deck/presentation/DEMO_SCRIPT.md
A  demo-pitch-deck/presentation/Q_AND_A.md
A  demo-pitch-deck/presentation/SUBMISSION_CHECKLIST.md
A  demo-pitch-deck/presentation/assets/.gitkeep
R100 presentation/README.md -> demo-pitch-deck/presentation/README.md
A  docs/archive/README.md
R100 .agents/archives/FOLDER_ARCHITECTURE.md -> examples/accounting-excel-agent/FOLDER_ARCHITECTURE.md
R100 .agents/handoffs/M1-excel-engine.md -> examples/accounting-excel-agent/M1-excel-engine.md
R100 .agents/handoffs/M1-implementation-handoff-prompt.md -> examples/accounting-excel-agent/M1-implementation-handoff-prompt.md
R100 .agents/archives/MILESTONE.md -> examples/accounting-excel-agent/MILESTONE.md
A  examples/accounting-excel-agent/README.md
A  frontend/src/assets/hero.png
A  requirements.txt
M  src/api/routes.py
M  src/models/schemas.py
A  tests/unit/test_chat_contract.py
```

## Commits (oldest first)

```
f9480d0 refactor: isolate Excel/Best-Work-Agent sample context into examples/
6c36bc8 docs: genericize AGENTS.md project learnings (remove Best-Work-Agent path)
02b3cb5 docs: add hackathon operating files (NOW/JUDGING/OWNERS/RUNBOOK)
d5c986e docs: add pilot pathway package under demo-pitch-deck/pilot
79b3d05 docs: add presentation run-of-show package under demo-pitch-deck/presentation
f521023 chore: track product evidence dirs; add docs/archive
a25efe9 chore: adopt declared deps, check-contract Makefile, and frontend asset
094f3bb docs: fix README drift (endpoints, deliverables, presentation path)
0cd2cc8 feat(api): public chat response contract; stop leaking internals
```

## Notes for the reviewer

- `.agents/handoffs/setup_env.md` was left untracked and untouched (pre-existing,
  not part of this effort).
- `TEMPLATE-REVIEWED.md` and the plan under `docs/superpowers/plans/` remain in the
  tree for reference; the plan documents the full task breakdown and deferrals.
