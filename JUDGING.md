# Judging Criteria (from the event's published rubric — total 100 pts)

> These rows are copied from the event Rubric. Do not invent, drop, or reweight
> criteria. Align every deliverable to a row; the three 20-pt rows are where most
> of the score is won or lost, so protect them first.

| # | Criterion | Weight | What judges look for | Where we prove it |
|---|-----------|-------:|----------------------|-------------------|
| 01 | Technical Implementation & Engineering Depth | 20 | Working, robust build with real engineering — tests, CI, clean seams | Live URL + `make check`, `tests/`, green CI run |
| 02 | AI-Native Architecture & Innovation | 20 | Genuinely AI-native (agent loop + tools), not a thin LLM wrapper | `src/agents/graph.py`, `WORKFLOW-MVP.md`, `docs/ARCHITECTURE.md` |
| 03 | Business Viability & Pilot Pathway | 20 | Real user, real pain, a credible path to a pilot | `demo-pitch-deck/pilot/PILOT_PATHWAY.md`, `demo-pitch-deck/pilot/evidence/` |
| 04 | AI-Native UX & Design Thinking | 15 | Clear, usable flow that surfaces the AI's thinking (activity/trace, streaming) | Live demo + `frontend/`, activity timeline |
| 05 | AI Safety, Grounding & Trust | 15 | Grounded answers, no leaked internals, honest failure, eval gate | `src/api/routes.py` (public contract + `trace_id`), `eval/results/`, `tests/unit/test_chat_contract.py` |
| 06 | Presentation, Demo & Defensibility | 10 | Tight story, clean demo, answers the hard questions | `demo-pitch-deck/presentation/` (deck, demo script, Q&A) |
| | **Total** | **100** | | |

## Final Submission — 5 mandatory items (11:00 AM, July 19th)

All five must be submitted. A missing item can zero the run regardless of rubric
score, so treat this as a gate, not a bonus. Owners are in `OWNERS.md`.

- [ ] **Presentation Slides** — `demo-pitch-deck/presentation/DECK_OUTLINE.md` → exported deck
- [ ] **Demo Video (≤ 5 min)** — recorded from `demo-pitch-deck/presentation/DEMO_SCRIPT.md`
- [ ] **GitHub Repository (public)** — repo visibility flipped to public before submission
- [ ] **Live Deployed URL** — reachable deploy; pinned in `NOW.md` "Frozen contracts"
- [ ] **AI Collaboration Log** — record of how the team used AI to build (kept as you go)

## Our demo promise (must map to the top-weighted criteria)
<one sentence — mirror NOW.md "Demo promise"; it should visibly hit rows 01, 02, and 04>
