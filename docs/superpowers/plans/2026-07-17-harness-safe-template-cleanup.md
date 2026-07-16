# Harness-Safe Template Cleanup & Hackathon Scaffolding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the safe, self-contained corrections from `TEMPLATE-REVIEWED.md` — remove Excel/`Best-Work-Agent` context poisoning, add the missing hackathon scaffolding (`NOW.md`, `JUDGING.md`, `OWNERS.md`, `pilot/`, `presentation/`), fix README drift and the API response contract — **without touching any path the repository-harness scripts depend on**.

**Architecture:** Pure additive/relocation edits plus two small doc/code fixes. Every relocation uses `git mv` to preserve history and targets only files the harness never reads. A harness-owned allowlist (below) is treated as read-only. After each structural task we verify the harness surface is untouched via `git diff --name-only`.

**Tech Stack:** Markdown docs, `.gitignore`, Python 3.11 + FastAPI + Pydantic (P0.7 only), pytest, git (`git mv`). No new dependencies.

## Global Constraints

- **Harness-owned paths are READ-ONLY in this plan. Do NOT move, rename, or delete any of:** `AGENTS.md` (edit prose only, never the `<!-- HARNESS:BEGIN -->`…`<!-- HARNESS:END -->` block), `scripts/` (esp. `scripts/bootstrap-harness.sh`, `scripts/bootstrap-harness.ps1`, `scripts/bin/`, `scripts/schema/`, `scripts/*harness*.md`), `harness.db*`, `.harness/`, and these harness-referenced docs: `docs/FEATURE_INTAKE.md`, `docs/CONTEXT_RULES.md`, `docs/TEST_MATRIX.md`, `docs/HARNESS_BACKLOG.md`, `docs/HARNESS.md`, `docs/TRACE_SPEC.md`, `docs/TOOL_REGISTRY.md`, `docs/GLOSSARY.md`, `docs/ARCHITECTURE.md`, `docs/decisions/`, `docs/contracts/`, `docs/product/`, `docs/stories/`, `docs/templates/`.
- **Actual API surface (verified in `src/main.py:34`, `src/api/routes.py`):** `GET /health`, `POST /api/v1/chat`, `GET /api/v1/status`. There is **no** `/api/v1/analyze`.
- **Today's date:** 2026-07-17. Use it verbatim in any dated content.
- **No emoji in files.** Match the repo's existing plain-markdown style.
- **Do not run harness mutation commands** (`harness-cli init/intake/story/trace/...`) for these doc/scaffolding edits — they are template-hygiene changes, and the review's Section 6 "Hackathon Mode" explicitly reduces ceremony. Read-only `harness-cli query` is fine if the binary is present.
- **Commit after every task** with a descriptive message. Do not batch tasks into one commit.

## Deferred to separate follow-up plans (OUT OF SCOPE here)

These are large independent subsystems from `TEMPLATE-REVIEWED.md`; each needs its own plan and is **not** attempted here:

- **P0.1** — Dependency/bootstrap locking (`pyproject.toml`, `uv.lock`, `.python-version`, `.env.example`, `.devcontainer/devcontainer.json`, `make bootstrap/dev/check/smoke`).
- **P0.2** — The full-stack vertical slice (frontend↔backend↔agent, mock/live modes, loading/error/result states).
- **P0.3** — Product CI workflow + hardening the codebase-memory workflow (permissions, pinned actions, no auto-commit).
- **P1** — Runnable eval suite (`eval/cases.jsonl`, `eval/run.py`, `eval/release-gate.yaml`).
- **P0.5** — The two-repository identity split (extract upstream harness into its own repo). Architectural; needs a new repo, not an in-place edit.

---

## File Structure

New files/dirs created (all in non-harness space):

```text
examples/accounting-excel-agent/README.md      # isolation notice for relocated sample context
examples/accounting-excel-agent/M1-excel-engine.md              (moved)
examples/accounting-excel-agent/M1-implementation-handoff-prompt.md (moved)
examples/accounting-excel-agent/MILESTONE.md                    (moved)
examples/accounting-excel-agent/FOLDER_ARCHITECTURE.md          (moved)
NOW.md                                          # <=80-line live mission board
JUDGING.md                                      # judging-criteria mapping
OWNERS.md                                       # four ownership lanes
HACKATHON_RUNBOOK.md                            # 48-hour run-of-show
pilot/PILOT_PATHWAY.md
pilot/feedback-form.md
pilot/interview-notes/.gitkeep
pilot/evidence/.gitkeep
presentation/DECK_OUTLINE.md
presentation/DEMO_SCRIPT.md
presentation/Q_AND_A.md
presentation/SUBMISSION_CHECKLIST.md
presentation/assets/.gitkeep
docs/archive/README.md
```

Modified (non-harness, prose/config only):

```text
AGENTS.md                 # Section 11 prose only — remove Best-Work-Agent / Excel lines
.gitignore                # stop ignoring evidence dirs
README.md                 # fix endpoints, deliverables framing, diagram path
src/models/schemas.py     # P0.7 public ChatResponse contract
src/api/routes.py         # P0.7 stop leaking str(e); build public envelope
tests/unit/test_chat_contract.py   # P0.7 new test (create)
```

---

### Task 1: Relocate Excel / `Best-Work-Agent` context artifacts into `examples/`

Removes the P0.4 context-poisoning files from the agent's default context by moving them into an isolated example directory. None of these are read by the harness CLI or referenced by any harness-owned file.

**Files:**
- Create: `examples/accounting-excel-agent/README.md`
- Move: `.agents/handoffs/M1-excel-engine.md` → `examples/accounting-excel-agent/M1-excel-engine.md`
- Move: `.agents/handoffs/M1-implementation-handoff-prompt.md` → `examples/accounting-excel-agent/M1-implementation-handoff-prompt.md`
- Move: `.agents/archives/MILESTONE.md` → `examples/accounting-excel-agent/MILESTONE.md`
- Move: `.agents/archives/FOLDER_ARCHITECTURE.md` → `examples/accounting-excel-agent/FOLDER_ARCHITECTURE.md`

**Interfaces:**
- Consumes: nothing.
- Produces: an `examples/accounting-excel-agent/` directory later referenced by `README.md` (Task 7) and `docs/archive/README.md` (Task 6).

- [ ] **Step 1: Verify the artifacts are not referenced by any harness-owned or config file**

Run (Git Bash):
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
grep -rIl --exclude-dir=.venv --exclude-dir=node_modules --exclude-dir=.git \
  -e "M1-excel-engine" -e "M1-implementation-handoff-prompt" \
  -e "FOLDER_ARCHITECTURE" -e "archives/MILESTONE" \
  scripts docs .github AGENTS.md README.md 2>/dev/null
```
Expected: **no output** (nothing outside the files themselves references them). If a harness-owned file appears, STOP and report — do not move.

- [ ] **Step 2: Create the isolation notice**

Create `examples/accounting-excel-agent/README.md`:
```markdown
# Example: Accounting Excel Cowork Agent (isolated sample context)

These files are **historical example artifacts** from a prior product built on
this template (an accounting/warehouse Excel automation agent under the old
`Best-Work-Agent` workspace name). They are kept for reference only.

**They are NOT active work and NOT part of the generic hackathon starter.**
Coding agents must not treat them as current requirements, active stories, or
valid file paths. When instantiating the template for a new project, delete this
directory.

Contents:
- `M1-excel-engine.md` — milestone-1 handoff for a deterministic Excel engine.
- `M1-implementation-handoff-prompt.md` — implementation handoff prompt.
- `MILESTONE.md` — archived Excel-engine milestone/roadmap.
- `FOLDER_ARCHITECTURE.md` — folder-hygiene guide written for `Best-Work-Agent`.
```

- [ ] **Step 3: Move the four artifacts with history-preserving `git mv`**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
git mv .agents/handoffs/M1-excel-engine.md examples/accounting-excel-agent/M1-excel-engine.md
git mv .agents/handoffs/M1-implementation-handoff-prompt.md examples/accounting-excel-agent/M1-implementation-handoff-prompt.md
git mv .agents/archives/MILESTONE.md examples/accounting-excel-agent/MILESTONE.md
git mv .agents/archives/FOLDER_ARCHITECTURE.md examples/accounting-excel-agent/FOLDER_ARCHITECTURE.md
```

- [ ] **Step 4: Verify no harness-owned path changed**

Run:
```bash
git status --porcelain
```
Expected: only additions under `examples/accounting-excel-agent/` and deletions/renames under `.agents/handoffs/` and `.agents/archives/`. **No** line touches `scripts/`, `docs/`, `harness.db`, `.harness/`, or the `AGENTS.md` harness block.

- [ ] **Step 5: Confirm the harness CLI still resolves its data (only if the binary is present)**

Run:
```bash
[ -x scripts/bin/harness-cli.exe ] && scripts/bin/harness-cli.exe query stats || echo "harness-cli not bootstrapped; skipping (expected in a fresh clone)"
```
Expected: either harness stats print, or the skip message. A non-zero harness error here means something in the durable layer was disturbed — investigate before continuing.

- [ ] **Step 6: Commit**

```bash
git add examples/ .agents/
git commit -m "refactor: isolate Excel/Best-Work-Agent sample context into examples/

Moves the accounting-Excel handoffs and the Best-Work-Agent folder-architecture
and milestone docs out of the agent default-context directories (.agents/handoffs,
.agents/archives) into examples/accounting-excel-agent/ with an isolation notice,
per TEMPLATE-REVIEWED.md P0.4. No harness-owned path is touched."
```

---

### Task 2: Remove project-specific poisoning from `AGENTS.md` Section 11

`AGENTS.md:195` hard-codes an absolute `E:\VIN-INTERNSHIP\Best-Work-Agent\...` path and an Excel-specific learning. Genericize the prose only. The `<!-- HARNESS:BEGIN -->` block (lines 212-229) MUST stay byte-for-byte identical.

**Files:**
- Modify: `AGENTS.md:192-195` (Section 11 "Project Learnings" bullets)

**Interfaces:**
- Consumes: nothing.
- Produces: nothing downstream depends on this text.

- [ ] **Step 1: Replace the Best-Work-Agent handoff bullet with a generic one**

In `AGENTS.md`, replace this line (currently line 195):
```markdown
- Always save handoff file to [.agents/handoffs/[handoff_name].md](file:///e:/VIN-INTERNSHIP/Best-Work-Agent/.agents/handoffs/) for scope, DoD, and tech constraints, (optional: findings and patterns found in the current sessions).
```
with:
```markdown
- Always save handoff files to `.agents/handoffs/<handoff_name>.md` for scope, DoD, and tech constraints (optionally: findings and patterns from the session). `.agents/handoffs/` holds only the current project's live transitions — do not leave stale or example handoffs there.
```

- [ ] **Step 2: Verify the harness block is intact**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
grep -n "HARNESS:BEGIN\|HARNESS:END" AGENTS.md
grep -rI "Best-Work-Agent" AGENTS.md || echo "clean: no Best-Work-Agent reference in AGENTS.md"
```
Expected: both `HARNESS:BEGIN` and `HARNESS:END` still present; the second grep prints the "clean" message.

- [ ] **Step 3: Commit**

```bash
git add AGENTS.md
git commit -m "docs: genericize AGENTS.md project learnings (remove Best-Work-Agent path)

Replaces the hard-coded absolute Best-Work-Agent handoff path with a relative,
project-neutral rule. The HARNESS:BEGIN/END block is unchanged. (P0.4)"
```

---

### Task 3: Add the top-level hackathon operating files

Adds `NOW.md`, `JUDGING.md`, `OWNERS.md`, and `HACKATHON_RUNBOOK.md` from `TEMPLATE-REVIEWED.md` Sections 6, 7, and 9. All additive, root-level, non-harness.

**Files:**
- Create: `NOW.md`, `JUDGING.md`, `OWNERS.md`, `HACKATHON_RUNBOOK.md`

**Interfaces:**
- Consumes: nothing.
- Produces: `NOW.md` and `HACKATHON_RUNBOOK.md` are referenced by `README.md` (Task 7).

- [ ] **Step 1: Create `NOW.md` (keep under ~80 lines)**

```markdown
# Current Mission

> Single source of truth for "what are we doing right now". Keep it under ~80 lines.
> Update at every integration checkpoint. If it is longer than one screen, prune.

## Demo promise
The single workflow judges must see working end-to-end:
- [ ] <one sentence — e.g., "Paste a business problem, get structured analysis back">

## Current milestone
What must be true at the next integration checkpoint:
- <milestone statement>

## Owners
- Frontend: <name>
- Backend: <name>
- AI/Eval: <name>
- Pilot/Pitch: <name>

## Frozen contracts
- API schema: <link or `POST /api/v1/chat` shape>
- Data model: <link>
- Deployment URL: <url or "TBD">

## Active tasks
- <owner> — <task> — <expected proof>

## Blockers
- <blocker or "none">

## Demo risks
- <risk and mitigation>

## Next integration checkpoint
- Time: <when>
- Commands: `make smoke` (or the current smoke command)
```

- [ ] **Step 2: Create `JUDGING.md`**

```markdown
# Judging Criteria (fill in from the event's published rubric)

> Hour 0-2 task: copy the exact criteria and weights from the event page here.
> Align every deliverable to these rows. Do not invent criteria.

| Criterion | Weight | What judges look for | Where we prove it |
|-----------|-------:|----------------------|-------------------|
| Idea / problem quality | %? | Real user, real pain | `pilot/PILOT_PATHWAY.md` |
| Implementation quality | %? | Working, robust demo | Live URL + `make smoke` |
| Design / UX | %? | Clear, usable flow | Demo + screenshots |
| Impact / potential | %? | Pilot pathway, evidence | `pilot/`, `eval/results/` |

## Submission requirements checklist
- [ ] Accessible repo URL
- [ ] Working demo (live URL or recorded video)
- [ ] Source code
- [ ] Required assets (deck, description, team)

## Our demo promise (must map to the top-weighted criteria)
<one sentence — mirror NOW.md "Demo promise">
```

- [ ] **Step 3: Create `OWNERS.md`**

```markdown
# Ownership Lanes

Four lanes, one owner each. The owner is accountable for the lane's demo-critical
outcome, not for doing all the work alone.

| Lane | Owner | Demo-critical outcome | Primary files |
|------|-------|-----------------------|---------------|
| Frontend | <name> | The judge-visible UI flow works | `frontend/` |
| Backend | <name> | API + agent respond reliably | `src/` |
| AI / Eval | <name> | Answers are good; eval gate is green | `src/agents/`, `eval/` |
| Pilot / Pitch | <name> | Pilot pathway + deck + submission | `pilot/`, `presentation/` |

## Rules
- Cross-lane changes require a heads-up in `NOW.md` "Blockers" before merging.
- The frozen contracts in `NOW.md` change only by agreement of Frontend + Backend owners.
```

- [ ] **Step 4: Create `HACKATHON_RUNBOOK.md`** (condensed from `TEMPLATE-REVIEWED.md` Section 9)

```markdown
# Hackathon Runbook (48-hour operating plan)

Adapted from TEMPLATE-REVIEWED.md Section 9. Keep `main` deployable at all times.

## Hour 0-2 — Judging and scope lock
- Copy exact criteria/weights into `JUDGING.md`.
- Pick one user, one job, one demo promise (record in `NOW.md`).
- Choose deployment target. Assign the four lanes in `OWNERS.md`.
- Decide what will be mocked.

## Hour 2-6 — Deployment-first foundation
- Make clean bootstrap pass. Deploy frontend + backend "hello world".
- Freeze the API contract in `NOW.md`. Add CI. Add a demo fixture + mock-provider mode.

## Hour 6-20 — One vertical slice
- Build only the core workflow. Integrate UI + backend + AI early. Merge continuously.

## Hour 20-30 — Quality and evidence
- Add error/fallback states. Build 12-20 eval cases. Collect feedback.
- Write `pilot/PILOT_PATHWAY.md`. Capture screenshots + metrics.

## Hour 30-36 — Feature freeze
- No new major features. Fix regressions. Add demo reset + backup mode. Record demo video.

## Hour 36-44 — Pitch and rehearsal
- Build the deck from real evidence. Rehearse a strict 3-5 minute run. Prepare Q&A.
- Verify every link in a clean/incognito browser.

## Hour 44-48 — Submission freeze
- Final smoke test. Verify repo access, live URL, and video. Preserve last known-good deploy.
- Submit early enough to recover from upload problems.
```

- [ ] **Step 5: Commit**

```bash
git add NOW.md JUDGING.md OWNERS.md HACKATHON_RUNBOOK.md
git commit -m "docs: add hackathon operating files (NOW/JUDGING/OWNERS/RUNBOOK)

Adds the lightweight Hackathon Mode scaffolding from TEMPLATE-REVIEWED.md
Sections 6, 7, and 9: a <=80-line NOW.md mission board, judging-criteria map,
ownership lanes, and the 48-hour runbook."
```

---

### Task 4: Add the `pilot/` package

Adds the Pilot Pathway template (`TEMPLATE-REVIEWED.md` Section 8) plus evidence/notes folders.

**Files:**
- Create: `pilot/PILOT_PATHWAY.md`, `pilot/feedback-form.md`, `pilot/interview-notes/.gitkeep`, `pilot/evidence/.gitkeep`

**Interfaces:**
- Consumes: nothing.
- Produces: `pilot/PILOT_PATHWAY.md` referenced by `JUDGING.md` and `README.md`.

- [ ] **Step 1: Create `pilot/PILOT_PATHWAY.md`** (verbatim template from Section 8)

```markdown
# Pilot Pathway

## Target pilot organization
Who has the problem and who can authorize a pilot?

## Job to be done
When [situation], they want to [motivation], so they can [outcome].

## Current workflow and baseline
Time, cost, error rate, or frustration today.

## Pilot workflow
The one or two jobs the MVP will support.

## Scope exclusions
What the pilot deliberately will not do.

## Data and integration requirements
Required files, APIs, permissions, and privacy constraints.

## Human-control design
When AI acts, asks, refuses, or escalates.

## Success metrics
Task success, time saved, correction rate, user rating, latency, cost.

## Pilot duration
For example: 7-14 days.

## Operational owner
Who supports users and resolves failures?

## Exit criteria
Expand, iterate, pause, or stop.
```

- [ ] **Step 2: Create `pilot/feedback-form.md`**

```markdown
# Pilot Feedback Form

Collect after each pilot user session. One row per session in the table below.

## Per-session questions
1. What task were you trying to accomplish?
2. Did the AI complete it? (yes / partly / no)
3. Did you have to correct or redo anything? What?
4. How long did it take vs. your normal workflow?
5. Would you use this again? Why / why not?
6. Rating (1-5): _____

## Session log
| Date | User role | Task | Success (Y/P/N) | Corrections | Rating (1-5) | Notes |
|------|-----------|------|-----------------|-------------|--------------|-------|
|      |           |      |                 |             |              |       |
```

- [ ] **Step 3: Create the folder keepers**

Create `pilot/interview-notes/.gitkeep` with content:
```text
Raw pilot interview notes go here (one file per interview).
```
Create `pilot/evidence/.gitkeep` with content:
```text
Screenshots, metrics exports, and quotes that back pilot claims go here.
```

- [ ] **Step 4: Commit**

```bash
git add pilot/
git commit -m "docs: add pilot pathway package

Adds pilot/PILOT_PATHWAY.md (TEMPLATE-REVIEWED.md Section 8), a session feedback
form, and interview-notes/ + evidence/ folders for pilot proof."
```

---

### Task 5: Add the `presentation/` run-of-show package

Adds the presentation package (`TEMPLATE-REVIEWED.md` Section 5) at the repository root per the Section 7 target structure. (An unrelated `demo-pitch-deck/presentation/` already exists and is left untouched.)

**Files:**
- Create: `presentation/DECK_OUTLINE.md`, `presentation/DEMO_SCRIPT.md`, `presentation/Q_AND_A.md`, `presentation/SUBMISSION_CHECKLIST.md`, `presentation/assets/.gitkeep`

**Interfaces:**
- Consumes: `JUDGING.md`, `pilot/PILOT_PATHWAY.md`.
- Produces: `presentation/` referenced by `README.md`.

- [ ] **Step 1: Create `presentation/DECK_OUTLINE.md`**

```markdown
# Deck Outline (map every slide to a judging criterion)

| # | Slide | Judging criterion it serves | Evidence source |
|---|-------|-----------------------------|-----------------|
| 1 | Title + one-line promise | Idea | NOW.md demo promise |
| 2 | The problem (with a number) | Idea / Impact | pilot/PILOT_PATHWAY.md |
| 3 | Target user + job-to-be-done | Idea | pilot/PILOT_PATHWAY.md |
| 4 | The solution (what it does) | Implementation | live demo |
| 5 | Live demo | Implementation / Design | DEMO_SCRIPT.md |
| 6 | How it works (architecture) | Implementation | docs/ARCHITECTURE.md |
| 7 | What is real vs. mocked | Trust | this deck |
| 8 | Evidence (eval + feedback) | Impact | eval/results/, pilot/evidence/ |
| 9 | Pilot pathway | Impact | pilot/PILOT_PATHWAY.md |
| 10 | Ask / next steps + team | Impact | OWNERS.md |
```

- [ ] **Step 2: Create `presentation/DEMO_SCRIPT.md`**

```markdown
# Demo Script (strict 3-5 minutes)

## Pre-flight (before you present)
- [ ] Live URL open in a clean/incognito browser
- [ ] Backup video queued and ready
- [ ] Mock mode available if the live provider fails
- [ ] Demo data reset to a known-good state

## Run of show
| Time | Presenter | Action | Fallback if it breaks |
|------|-----------|--------|-----------------------|
| 0:00 | <name> | One-line promise + the problem | — |
| 0:30 | <name> | Enter the example input | Use the seeded example prompt |
| 1:00 | <name> | Show loading -> structured result | Switch to mock mode |
| 2:00 | <name> | Point out trace ID + feedback | Show recorded video |
| 3:00 | <name> | Impact + pilot pathway + ask | — |

## Hard rule
If anything is not working 10 minutes before the slot, present the backup video.
Never debug live in front of judges.
```

- [ ] **Step 3: Create `presentation/Q_AND_A.md`**

```markdown
# Q&A Bank

Prepare honest answers. "What is mocked" questions are common — answer directly.

## Likely questions
- What is real vs. mocked right now?
- How does this handle a wrong or unsafe request?
- What happens when the model/API fails?
- How would a real pilot start? (point to pilot/PILOT_PATHWAY.md)
- What is your evidence it works? (point to eval/results/, pilot/evidence/)
- What would you build next with two more weeks?
- How do you keep a human in control? (act / ask / refuse / escalate)

## Claims vs. evidence ledger
| Claim we make | Evidence we can show |
|---------------|----------------------|
|               |                      |
```

- [ ] **Step 4: Create `presentation/SUBMISSION_CHECKLIST.md`**

```markdown
# Submission Checklist

## Repository
- [ ] Repo is accessible to judges (visibility / access confirmed)
- [ ] README explains what it is and how to run it
- [ ] `main` is at a known-good, deployable commit

## Demo
- [ ] Live URL loads in a clean/incognito browser
- [ ] Backup demo video uploaded and linked
- [ ] Demo data reset script works

## Assets
- [ ] Deck exported (PDF) in presentation/assets/
- [ ] Screenshots in presentation/assets/
- [ ] Team + roles listed
- [ ] Eval evidence in eval/results/, pilot evidence in pilot/evidence/

## Timing
- [ ] Submitted with buffer before the deadline
```

- [ ] **Step 5: Create `presentation/assets/.gitkeep`**

```text
Exported deck (PDF), screenshots, and demo stills go here.
```

- [ ] **Step 6: Commit**

```bash
git add presentation/DECK_OUTLINE.md presentation/DEMO_SCRIPT.md presentation/Q_AND_A.md presentation/SUBMISSION_CHECKLIST.md presentation/assets/.gitkeep
git commit -m "docs: add presentation run-of-show package

Adds root presentation/ with deck outline, demo script, Q&A bank, and submission
checklist (TEMPLATE-REVIEWED.md Section 5). Leaves demo-pitch-deck/ untouched."
```

---

### Task 6: Add `docs/archive/` and fix `.gitignore` evidence-dir ignores

`docs/archive/` is in the Section 7 target structure. The `.gitignore` currently *ignores* the very evidence directories the review says to **preserve** (`docs/images/**`, `presentation/assets/**`, `eval/evidence/**`).

**Files:**
- Create: `docs/archive/README.md`
- Modify: `.gitignore:61-64`

**Interfaces:**
- Consumes: `examples/accounting-excel-agent/` (Task 1).
- Produces: nothing.

- [ ] **Step 1: Create `docs/archive/README.md`**

```markdown
# docs/archive/

Superseded project documents kept for historical reference. Nothing here is
active guidance. Coding agents should not load these into working context.

For relocated product-specific sample context (the accounting Excel agent), see
`examples/accounting-excel-agent/` instead.
```

- [ ] **Step 2: Fix `.gitignore` — stop ignoring the evidence directories**

In `.gitignore`, replace this block (currently lines 61-64):
```text
# ignore specifics image
docs/images/**
presentation/assets/**
eval/evidence/**
```
with:
```text
# Keep product evidence tracked (screenshots, diagrams, deck assets, eval proof).
# Ignore only throwaway screenshot scratch dirs, never the evidence folders below:
#   docs/images/**  presentation/assets/**  eval/evidence/**  are TRACKED on purpose.
tmp-screenshots/
```

- [ ] **Step 3: Verify the evidence dirs are no longer ignored**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
git check-ignore presentation/assets/.gitkeep && echo "STILL IGNORED — fix failed" || echo "OK: presentation/assets tracked"
```
Expected: `OK: presentation/assets tracked` (the `.gitkeep` from Task 5 is now trackable).

- [ ] **Step 4: Commit**

```bash
git add docs/archive/README.md .gitignore
git commit -m "chore: track product evidence dirs; add docs/archive

Stops .gitignore from excluding docs/images, presentation/assets, and
eval/evidence so screenshots, diagrams, and eval proof are committable (P1).
Adds docs/archive/ for superseded docs."
```

---

### Task 7: Fix README drift (endpoints, deliverables, diagram path)

`README.md` lists a non-existent `POST /api/v1/analyze`, marks fictional deliverables as done with `[x]`, and links a missing `docs/architecture_diagram.md`.

**Files:**
- Modify: `README.md:102-119`

**Interfaces:**
- Consumes: `NOW.md`, `HACKATHON_RUNBOOK.md`, `presentation/`, `pilot/` (Tasks 3-5).
- Produces: nothing.

- [ ] **Step 1: Correct the API Endpoints table**

In `README.md`, replace the endpoints table (currently lines 104-108):
```markdown
| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| POST | /api/v1/chat | Chat with agent |
| POST | /api/v1/analyze | Analyze input |
```
with (matches `src/main.py:34` prefix + `src/api/routes.py`):
```markdown
| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| POST | /api/v1/chat | Chat with agent |
| GET | /api/v1/status | Agent readiness status |
```

- [ ] **Step 2: Replace the fictional deliverables checklist with honest template-capability framing**

Replace the "Deliverables Checklist" block (currently lines 110-119):
```markdown
## Deliverables Checklist

- [x] Source Code (GitHub)
- [x] README.md
- [x] Architecture Diagram (`docs/architecture_diagram.md`)
- [x] AI Logs (auto-collected)
- [ ] Live URL / Deploy
- [ ] Video Demo
- [ ] Pitch Deck (`presentation/`)
- [ ] Evaluation Evidence (`eval/results/`)
```
with:
```markdown
## Deliverables Checklist

Template capabilities are shipped scaffolding; project deliverables start unchecked
and are checked only when actually done (not by default).

Template capability available:
- [x] Source code skeleton (`src/`, `frontend/`)
- [x] README
- [x] Architecture doc (`docs/ARCHITECTURE.md`)
- [x] Presentation package (`presentation/`)
- [x] Pilot pathway (`pilot/PILOT_PATHWAY.md`)

Project deliverable completed:
- [ ] Live URL / deploy
- [ ] Video demo
- [ ] Filled pitch deck (`presentation/`)
- [ ] Evaluation evidence (`eval/results/`)
- [ ] AI logs wired to a real tracing sink
```

- [ ] **Step 3: Verify referenced doc paths exist**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
for f in docs/ARCHITECTURE.md presentation/DECK_OUTLINE.md pilot/PILOT_PATHWAY.md; do
  test -f "$f" && echo "OK $f" || echo "MISSING $f"
done
grep -n "architecture_diagram.md" README.md || echo "clean: no dangling architecture_diagram.md link"
```
Expected: three `OK` lines and the `clean:` message.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: fix README drift (endpoints, deliverables, diagram path)

Corrects the API table to the real surface (GET /api/v1/status, not
POST /api/v1/analyze), replaces fictional [x] deliverables with honest
template-capability vs project-deliverable framing, and points the
architecture link at the existing docs/ARCHITECTURE.md. (P0.6)"
```

---

### Task 8: Harden the `/api/v1/chat` response contract (P0.7)

`ChatResponse` exposes an internal `analysis` field and the route returns `str(e)` to clients. Replace with the review's public envelope and a generic error, proven by a test. This touches product code only (no frontend, no harness).

**Files:**
- Create: `tests/unit/test_chat_contract.py`
- Modify: `src/models/schemas.py`, `src/api/routes.py`

**Interfaces:**
- Consumes: FastAPI `TestClient`, the existing `agent` from `src/agents/graph.py`.
- Produces: `ChatResponse` with fields `answer: str`, `explanation: str`, `sources: list[str]`, `trace_id: str`, `status: str`. Route builds it and returns a generic error envelope on failure.

- [ ] **Step 1: Confirm the test directory layout and any existing chat test**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
ls tests 2>/dev/null; ls tests/unit 2>/dev/null
grep -rIn "api/v1/chat\|ChatResponse\|analysis" tests 2>/dev/null || echo "no existing chat-contract test"
```
Expected: note whether `tests/unit/` exists (create it if not) and whether any test asserts the old `analysis` field (update those if present).

- [ ] **Step 2: Write the failing test**

Create `tests/unit/test_chat_contract.py`:
```python
from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


def test_chat_returns_public_envelope_without_internal_fields():
    resp = client.post("/api/v1/chat", json={"message": "hello"})
    assert resp.status_code == 200
    body = resp.json()
    assert set(body.keys()) == {"answer", "explanation", "sources", "trace_id", "status"}
    assert "analysis" not in body
    assert body["status"] == "success"
    assert isinstance(body["sources"], list)
    assert body["trace_id"]


def test_chat_error_returns_generic_envelope(monkeypatch):
    async def boom(_payload):
        raise RuntimeError("secret internal detail")

    monkeypatch.setattr("src.api.routes.agent.ainvoke", boom)
    resp = client.post("/api/v1/chat", json={"message": "hi"})
    assert resp.status_code == 500
    body = resp.json()
    assert "secret internal detail" not in resp.text
    assert body["detail"]["status"] == "error"
    assert body["detail"]["trace_id"]
```

- [ ] **Step 3: Run the test to verify it fails**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
python -m pytest tests/unit/test_chat_contract.py -v
```
Expected: FAIL — the response still has `response`/`analysis` keys, so the key-set assertion fails.

- [ ] **Step 4: Update `ChatResponse` to the public contract**

Replace `src/models/schemas.py` `ChatResponse` (currently lines 8-10) with:
```python
class ChatResponse(BaseModel):
    answer: str = Field(..., description="The user-facing answer")
    explanation: str = Field(default="", description="User-facing rationale (no internal diagnostics)")
    sources: list[str] = Field(default_factory=list, description="Supporting sources, if any")
    trace_id: str = Field(..., description="Correlates this response with server logs/traces")
    status: str = Field(default="success", description="success | error")
```

- [ ] **Step 5: Update the route to build the envelope and hide internals**

Replace `src/api/routes.py` (whole file) with:
```python
import logging
import uuid

from fastapi import APIRouter, HTTPException

from src.agents.graph import agent
from src.models.schemas import ChatRequest, ChatResponse

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    """Chat với AI agent."""
    trace_id = uuid.uuid4().hex
    try:
        result = await agent.ainvoke({"query": request.message})
        return ChatResponse(
            answer=result.get("response", ""),
            explanation=result.get("explanation", ""),
            sources=result.get("sources", []),
            trace_id=trace_id,
            status="success",
        )
    except Exception:
        logger.exception("chat failed", extra={"trace_id": trace_id})
        raise HTTPException(
            status_code=500,
            detail={
                "status": "error",
                "trace_id": trace_id,
                "message": "Internal error. Reference the trace_id when reporting.",
            },
        )


@router.get("/status")
async def agent_status():
    """Kiểm tra trạng thái agent."""
    return {"status": "ready", "agent": "LangGraph Agent v1.0"}
```

- [ ] **Step 6: Run the test to verify it passes**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
python -m pytest tests/unit/test_chat_contract.py -v
```
Expected: PASS (both tests). If import of `src.main` fails on missing deps, note it in the update report and run once the environment is bootstrapped.

- [ ] **Step 7: Run the surrounding suite to check nothing else asserted the old shape**

Run:
```bash
python -m pytest -q
```
Expected: PASS. If a pre-existing test asserted `response`/`analysis`, update it to the new envelope and re-run.

- [ ] **Step 8: Commit**

```bash
git add src/models/schemas.py src/api/routes.py tests/unit/test_chat_contract.py
git commit -m "feat(api): public chat response contract; stop leaking internals

Replaces ChatResponse.analysis with a public envelope (answer, explanation,
sources, trace_id, status) and returns a generic error envelope with a trace_id
instead of str(e). Adds a contract test. (P0.7)"
```

---

### Task 9: Write the update report for the reviewer agent

Produce `update-report.md` at the repo root summarizing what changed, what was verified, harness-safety proof, and what was deliberately deferred, so the reviewer agent has full context.

**Files:**
- Create: `update-report.md`

**Interfaces:**
- Consumes: the commit log from Tasks 1-8.
- Produces: nothing.

- [ ] **Step 1: Gather the commit list for this effort**

Run:
```bash
cd "E:/VIN-INTERNSHIP/AI-HACKATHON-TEMPLATE"
git log --oneline -12
git diff --name-status HEAD~8..HEAD
```
Expected: the eight task commits and their touched files. Confirm no line under `scripts/`, `harness.db`, `.harness/`, or the `AGENTS.md` harness block appears in a way that alters harness behavior.

- [ ] **Step 2: Write `update-report.md`**

Create `update-report.md` with these sections (fill the tables from Step 1 output):
```markdown
# Update Report — Harness-Safe Template Cleanup

Date: 2026-07-17
Source spec: TEMPLATE-REVIEWED.md
Plan: docs/superpowers/plans/2026-07-17-harness-safe-template-cleanup.md

## What this change set does
Applies the safe, self-contained corrections from the review: removes Excel /
Best-Work-Agent context poisoning, adds hackathon scaffolding (NOW.md, JUDGING.md,
OWNERS.md, HACKATHON_RUNBOOK.md, pilot/, presentation/), tracks product evidence
dirs, fixes README drift, and hardens the /api/v1/chat response contract.

## Review items addressed
| Review item | Status | Where |
|-------------|--------|-------|
| P0.4 context poisoning | done | examples/accounting-excel-agent/, AGENTS.md |
| P0.6 README drift | done | README.md |
| P0.7 API contract leak | done | src/models/schemas.py, src/api/routes.py, tests/unit/test_chat_contract.py |
| P1 evidence dirs ignored | done | .gitignore |
| Section 6/7/9 scaffolding | done | NOW.md, JUDGING.md, OWNERS.md, HACKATHON_RUNBOOK.md |
| Section 8 pilot pathway | done | pilot/ |
| Section 5 presentation | done | presentation/ |

## Deliberately deferred (need their own plans)
| Review item | Reason |
|-------------|--------|
| P0.1 dependency/bootstrap locking | separate subsystem (uv/pyproject/devcontainer) |
| P0.2 full-stack vertical slice | largest subsystem; frontend+backend+agent |
| P0.3 product CI + memory-workflow hardening | CI subsystem |
| P1 runnable eval suite | eval subsystem (cases/runner/gate) |
| P0.5 two-repo identity split | architectural; needs a new repo |

## Harness-safety proof
- No file under scripts/, harness.db*, .harness/, or the AGENTS.md HARNESS:BEGIN/END
  block was moved, renamed, or altered in behavior.
- Relocated artifacts (Task 1) were confirmed unreferenced by any harness-owned
  file before moving.
- git diff --name-status for this range: <paste from Step 1>.

## Verification run
- <paste `python -m pytest -q` result>
- <paste harness-cli query result or the "not bootstrapped" skip note>

## Commits
<paste `git log --oneline -12` for the eight task commits + this report>
```

- [ ] **Step 3: Commit**

```bash
git add update-report.md
git commit -m "docs: add update-report.md for reviewer handoff

Summarizes the harness-safe cleanup change set: items addressed, deferred
subsystems, harness-safety proof, and verification output."
```

---

## Self-Review

**1. Spec coverage.** Addressed here: P0.4 (Task 1-2), P0.6 (Task 7), P0.7 (Task 8), P1 evidence dirs (Task 6), P1 Makefile (already correct — noted, no task needed), Sections 5/6/7/8/9 scaffolding (Tasks 3-5). Explicitly deferred with reasons: P0.1, P0.2, P0.3, P0.5, and the runnable eval suite. No in-scope item is left without a task.

**2. Placeholder scan.** All new-file steps contain full content, not "TBD". The only intentional `<...>` fill-ins are inside the *scaffolding documents themselves* (e.g., owner names in `NOW.md`), which are user-facing blanks by design, not plan placeholders. Verification steps have exact commands and expected output.

**3. Type consistency.** `ChatResponse` fields defined in Task 8 Step 4 (`answer`, `explanation`, `sources`, `trace_id`, `status`) match exactly what the Task 8 Step 2 test asserts and what the Task 8 Step 5 route constructs. The error envelope shape (`detail.status`, `detail.trace_id`) in the route matches the test's assertions.

**4. Harness-safety.** Every structural task includes a `git status`/`git diff` verification that the harness-owned allowlist (Global Constraints) is untouched, and Task 1 gates the move on a reference check.
