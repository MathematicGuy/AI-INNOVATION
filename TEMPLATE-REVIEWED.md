## First-principles verdict

This repository is currently **a sophisticated repository-harness project combined with an incomplete hackathon application starter**.

The harness has strong ideas: bounded context retrieval, risk-based work lanes, durable state, verification evidence, trace recording, and explicit source-of-truth rules. However, the application template around it is not yet dependable enough to clone at Hour 0 and trust for a two-day hackathon.

**Current assessment: promising, but not competition-ready.**

I reviewed the repository statically at commit `0c1892b...` through GitHub. I did not execute the build or deployment locally.

## 1. What a good 48-hour hackathon template must accomplish

A hackathon template should eliminate four types of uncertainty:

1. **Environment uncertainty:** Can every teammate start developing in minutes?
2. **Integration uncertainty:** Can frontend, backend, AI, and data changes be combined safely?
3. **Demo uncertainty:** Can the core workflow be demonstrated even when APIs, networks, or live data fail?
4. **Evidence uncertainty:** Can the team prove technical quality, user value, impact, and a realistic pilot pathway?

This matches how hackathons are commonly judged: idea quality, implementation quality, design, and potential impact. Submission readiness also includes accessible URLs, working demos, source code, and required assets. Devpost explicitly recommends aligning work with the published judging criteria, while MLH emphasizes “show, not tell,” short demo slots, dry runs, and having the project ready before presentation time. ([Devpost Help Center][1])

For the repository itself, a strong template should also provide a reproducible development environment and working starter files. GitHub recommends configuring template repositories with a default `devcontainer.json` so users can start with required tools installed and the application already running. Vercel’s starter model similarly centers on starting from a working, immediately deployable application rather than an empty architecture. ([GitHub Docs][2])

Your course materials reinforce the same principle: an MVP is the cheapest credible way to test the important hypothesis, and prototypes are decision-making tools rather than miniature enterprise systems. 

## 2. Current scorecard

| Area                      | Assessment | Main reason                                               |
| ------------------------- | ---------: | --------------------------------------------------------- |
| Context-management design |   **7/10** | Strong bounded retrieval and risk lanes                   |
| Template cleanliness      |   **2/10** | Contains project-specific Excel-agent artifacts           |
| Reproducible bootstrap    |   **2/10** | Required files and lockfiles are missing                  |
| Working vertical slice    |   **3/10** | Frontend is an unconnected Vite starter                   |
| CI and release gates      |   **3/10** | Memory-index workflow exists, product CI does not         |
| Deployment readiness      |   **3/10** | Backend container exists, but no complete deployment path |
| AI evaluation readiness   |   **5/10** | Good methodology and folders, but no runnable eval suite  |
| Pitch and pilot readiness |   **4/10** | Basic deck outline, no pilot pathway or run-of-show       |
| Two-day suitability       |   **3/10** | Existing plans are measured in multiple weeks             |

The overall problem is not lack of sophistication. It is that the sophistication is concentrated in the harness rather than the **working product path**.

---

# 3. What is already strong

### Bounded context retrieval

`CONTEXT_RULES.md` correctly states that the goal is not to maximize context, but to retrieve the right information for the current phase and risk lane. It separates intake, planning, implementation, validation, and trace context, with approximate budgets for tiny, normal, and high-risk work. That is excellent context engineering.

### Risk-aware feature intake

The tiny/normal/high-risk classification is useful. In particular, treating auth, authorization, data migration, external providers, and validation weakening as hard gates is appropriate.

### Durable state instead of unlimited Markdown growth

Using SQLite for intake, stories, decisions, backlog, and traces is structurally better than continually appending large Markdown logs. The harness also supports verification commands and explicit story completion rather than trusting an agent’s claim that work is finished.

### Basic backend engineering practices

The Dockerfile uses a multi-stage build, a non-root user, and a health check. Those are useful defaults for a deployable starter.

### Evaluation mindset

The repository already includes tests and an evaluation-report location. Your supplied AI evaluation guide is also exactly the right conceptual foundation: deterministic assertions for verifiable behavior, human judgment for defining quality, calibrated LLM evaluation for semantic scale, reference cases, and release gates. 

---

# 4. P0 findings: fix before using this as a hackathon template

## P0.1 — The documented bootstrap path is broken

The README instructs users to:

```bash
cp .env.example .env
pip install -r requirements.txt
```

and the Dockerfile also copies and installs `requirements.txt`.

Direct repository fetches returned 404 for:

* `requirements.txt`
* `.env.example`
* `pyproject.toml`
* `.devcontainer/devcontainer.json`

Therefore, both the documented local setup and Docker build are currently blocked.

The frontend has a package manifest, but I found no frontend lockfile. Its versions use ranges such as `^19.2.7` and `^8.1.1`, which makes fresh installs less reproducible.

### Required correction

Adopt one canonical dependency path:

```text
Python:
pyproject.toml
uv.lock
.python-version

Frontend:
package.json
package-lock.json

Environment:
.env.example

Development:
.devcontainer/devcontainer.json
```

Then make these commands pass on a clean environment:

```bash
make bootstrap
make dev
make check
make smoke
```

The most important template test should be:

> Create a new repository from the template, clone it on a clean machine, and reach a working browser screen without undocumented manual steps.

---

## P0.2 — There is no working full-stack golden path

The current frontend is essentially the default Vite counter page. It neither calls the backend nor demonstrates an AI workflow.

There is also a development integration mismatch:

* Backend CORS defaults to `http://localhost:3000`.
* Vite has no custom port or proxy, so its normal development port is not aligned with that configuration.
* Docker Compose starts only the backend.

A template should begin with one complete workflow:

```text
User enters a request
→ frontend validates it
→ backend endpoint receives it
→ agent runs
→ structured result appears
→ trace/evaluation data is recorded
```

It can be simple, but it must work end to end before teams add features.

### Recommended starter workflow

Use a generic but demonstrable AI job:

> “Paste a business problem → receive structured analysis, proposed solution, assumptions, and next action.”

Include:

* Loading state
* Error state
* Structured result
* One example prompt
* Mock mode
* Live-provider mode
* Feedback buttons
* Trace ID
* Reset-demo button

---

## P0.3 — The application lacks product CI

The visible workflow updates the codebase-memory graph. It does not test the backend, build the frontend, validate Docker, or run an end-to-end smoke check. It also has repository write permission and automatically commits generated graph data.

The indexing script additionally:

* Downloads and executes a remote installer through `curl | bash`.
* Does not pin that installer to a commit.
* suppresses indexing failure with `|| true`.
* contains a hard-coded project name.
* mutates `.gitignore` and `.gitattributes`.
* generates and commits a binary graph artifact.

This is too much mutation for the primary pull-request workflow. GitHub recommends granting the workflow token only the minimum permissions required and pinning third-party actions to immutable full commit SHAs. ([GitHub Docs][3])

### Required correction

Create a product CI workflow with three fast jobs:

```text
backend:
  install
  ruff check
  ruff format --check
  mypy
  pytest

frontend:
  npm ci
  npm run lint
  npm run build

smoke:
  docker build
  start container
  GET /health
  optional one golden API request
```

The memory-index workflow should be changed to one of:

* Manual `workflow_dispatch`
* Scheduled nightly
* Local developer command
* Read-only validation without auto-commit

It should not compete with product work during a 48-hour event.

---

## P0.4 — The template contains context-poisoning artifacts

The repository includes an active handoff for an **Accounting Excel Cowork Agent**, absolute Windows paths, inventory workbook requirements, and Excel-specific story IDs.

The archived milestone plan is also specifically about a deterministic Excel engine and accounting/warehouse users.

`FOLDER_ARCHITECTURE.md` describes the workspace as `Best-Work-Agent` and references files and product areas that are not part of this generic hackathon starter.

These are not harmless examples. Coding agents can retrieve them and incorrectly infer:

* The target product is Excel automation.
* `Best-Work-Agent` is the repository name.
* Absolute `E:\...` paths are valid.
* Excel-specific milestone stories are active work.
* LangGraph and FastAPI may be forbidden because an old handoff says not to build them.

### Required correction

Move all project-specific artifacts to a separate example repository or a clearly isolated directory excluded from normal context:

```text
examples/accounting-excel-agent/
```

Do not leave old handoffs under `.agents/handoffs/`. That directory should contain only the current project’s live transitions.

A template-instantiation script should delete or archive all sample context automatically.

---

## P0.5 — The repository has conflicting identities

`HARNESS.md` says the reusable harness deliberately excludes:

* A locked application stack
* Consumer application scaffolding
* Consumer package scripts
* Consumer CI workflows

But this repository simultaneously contains:

* FastAPI
* LangGraph
* React/Vite
* Docker
* application tests
* a Makefile
* application README instructions

This means the repository is trying to be two products:

1. An upstream repository-harness distribution.
2. A ready-to-use AI hackathon application starter.

### Recommended architectural decision

Split the concerns:

```text
repository-harness
  Rust CLI
  installer
  schema
  maturity model
  harness benchmarks
  harness release process

ai-hackathon-starter
  application source
  minimal installed harness
  CI/CD
  demo workflow
  evaluation suite
  pilot and presentation assets
```

The hackathon starter should **consume the harness as a released component**, not contain the harness’s own product-development internals.

Use the harness as infrastructure, not as the main product inside the template.

---

## P0.6 — Documentation and implementation have already drifted

The README lists:

```text
POST /api/v1/chat
POST /api/v1/analyze
```

but the actual router exposes `/chat` and `/status`.

The README also marks the architecture diagram as completed, but the documented `docs/architecture_diagram.md` path was not present when fetched. It similarly marks AI logs as auto-collected without a clear application-level tracing implementation.

For a template, checked boxes should not represent fictional completion. Use:

```text
Template capability available: yes/no
Project deliverable completed: unchecked by default
```

Add a documentation contract test that verifies referenced files and commands exist.

---

## P0.7 — API defaults could leak internal information

`ChatResponse` includes an `analysis` field, and the endpoint returns it directly. Once a real model is connected, this could expose internal diagnostics, reasoning-like content, provider prompts, or unreviewed implementation detail.

The route also sends `str(e)` directly to clients for all exceptions.

Use this public contract instead:

```json
{
  "answer": "...",
  "explanation": "...",
  "sources": [],
  "trace_id": "...",
  "status": "success"
}
```

Internal errors should be logged with a request ID; clients should receive a stable generic error envelope.

---

# 5. Important P1 improvements

## Fix the Makefile verification contract

Current `make check` runs `ruff format`, which changes files instead of checking them. It also omits type checking and frontend validation.

Use:

```make
format:
	ruff format src tests

format-check:
	ruff format --check src tests

check-backend:
	ruff check src tests
	ruff format --check src tests
	mypy src
	pytest -q

check-frontend:
	cd frontend && npm ci && npm run lint && npm run build

check: check-backend check-frontend
```

## Stop ignoring every PNG file

The `.gitignore` globally ignores `*.png`. That makes it easy to accidentally omit product screenshots, architecture diagrams, and presentation evidence.

Ignore only temporary screenshot directories and preserve:

```text
docs/images/**
presentation/assets/**
eval/evidence/**
```

## Replace the placeholder eval report with a runnable suite

The current evaluation report contains targets and “paste output here” placeholders, but no case dataset, runner, or release gate.

For a hackathon, start with 12–20 cases:

* 5 normal workflows
* 3 ambiguous inputs
* 2 malformed or missing-context inputs
* 2 provider/tool failures
* 2 high-risk or unsafe requests
* 2 fixed demo-regression cases

Suggested release gate:

```yaml
block_if:
  demo_regression_failures: "> 0"
  p0_failures: "> 0"
  schema_pass_rate: "< 1.0"
  core_task_pass_rate: "< 0.80"

warn_if:
  p95_latency_seconds: "> 5"
  average_cost_per_run: "> budget"
```

This follows the supplied evaluation material’s recommendation to combine deterministic checks, human-reviewed reference cases, and calibrated semantic evaluation rather than relying on a single overall score. 

## Add a true hackathon presentation package

The current presentation README provides a useful ten-slide outline, but lacks:

* Judging-criteria mapping
* Presenter assignments
* Exact demo script
* Backup-video procedure
* Q&A bank
* Pilot pathway
* Claims/evidence ledger
* “What is real versus mocked” disclosure

---

# 6. Recommended lightweight context harness for a two-day event

Do not discard your current harness. Introduce a **Hackathon Mode** over it.

## Default context pack

Every agent reads only:

```text
AGENTS.md
NOW.md
the exact task file
the directly adjacent implementation and tests
```

Read architecture, decisions, or full product documents only when a trigger fires.

This is already consistent with the philosophy of your current context rules.

## `NOW.md` should remain under roughly 80 lines

Suggested structure:

```markdown
# Current Mission

## Demo promise
The single workflow judges must see working.

## Current milestone
What must be true at the next integration checkpoint.

## Owners
Frontend:
Backend:
AI/Eval:
Pilot/Pitch:

## Frozen contracts
API schema:
Data model:
Deployment URL:

## Active tasks
- Owner — task — expected proof

## Blockers
- ...

## Demo risks
- ...

## Next integration checkpoint
Time:
Commands:
```

## Reduce mandatory ceremony

For Hackathon Mode:

* Tiny change: patch + targeted verification.
* Normal change: one short task packet and proof command.
* High-risk change: human confirmation and explicit fallback.
* Record one consolidated trace at integration checkpoints rather than after every cosmetic edit.
* Run full harness audit at milestone boundaries, not after every commit.
* Keep handoffs only when ownership or agent session changes.

The harness must never become a critical dependency for running the product. If its CLI bootstrap fails, the team should still be able to develop, test, deploy, and demo.

---

# 7. Target repository structure

```text
AI-INNOVATION-HACKATHON-TEMPLATE/
├── README.md
├── AGENTS.md
├── NOW.md
├── HACKATHON_RUNBOOK.md
├── JUDGING.md
├── OWNERS.md
├── Makefile
├── pyproject.toml
├── uv.lock
├── .python-version
├── .env.example
├── .devcontainer/
│   └── devcontainer.json
├── frontend/
│   ├── package.json
│   ├── package-lock.json
│   └── src/
├── src/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── smoke/
├── eval/
│   ├── cases.jsonl
│   ├── run.py
│   ├── release-gate.yaml
│   └── results/
├── pilot/
│   ├── PILOT_PATHWAY.md
│   ├── interview-notes/
│   ├── feedback-form.md
│   └── evidence/
├── presentation/
│   ├── DECK_OUTLINE.md
│   ├── DEMO_SCRIPT.md
│   ├── Q_AND_A.md
│   ├── SUBMISSION_CHECKLIST.md
│   └── assets/
├── docs/
│   ├── product/
│   ├── decisions/
│   ├── stories/
│   └── archive/
├── scripts/
│   ├── bootstrap.sh
│   ├── bootstrap.ps1
│   ├── dev.sh
│   ├── smoke.sh
│   └── reset-demo-data.sh
└── .github/workflows/
    ├── ci.yml
    ├── preview-deploy.yml
    └── production-deploy.yml
```

---

# 8. Pilot Pathway template

Create `pilot/PILOT_PATHWAY.md` with:

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
For example: 7–14 days.

## Operational owner
Who supports users and resolves failures?

## Exit criteria
Expand, iterate, pause, or stop.
```

The human-centered AI material supports explicitly choosing between act, ask, and inaction according to uncertainty and cost of error, while providing review, fallback, correction, and undo when the AI can fail. 

---

# 9. Recommended 48-hour operating plan

### Hour 0–2: judging and scope lock

* Copy exact criteria and weights into `JUDGING.md`.
* Select one user and one job.
* Write one demo promise.
* Select deployment target.
* Assign four ownership lanes.
* Define what will be mocked.

### Hour 2–6: deployment-first foundation

* Make clean bootstrap pass.
* Deploy frontend and backend “hello world.”
* Establish API contract.
* Add CI.
* Add demo fixture and mock-provider mode.

### Hour 6–20: one vertical slice

* Build only the core workflow.
* Integrate UI, backend, and AI early.
* Merge continuously.
* Keep `main` deployable.

### Hour 20–30: quality and evidence

* Add error/fallback states.
* Build 12–20 eval cases.
* Collect initial user or mentor feedback.
* Write the pilot pathway.
* Capture screenshots and metrics.

### Hour 30–36: feature freeze

* No new major features.
* Fix regression and integration issues.
* Add demo reset and backup mode.
* Record a full demo video.

### Hour 36–44: pitch and rehearsal

* Build deck from actual evidence.
* Rehearse a strict 3–5 minute run.
* Prepare Q&A.
* Verify every link in a clean/incognito browser.

### Hour 44–48: submission freeze

* Final smoke test.
* Verify repository access.
* Verify live URL and video.
* Preserve the last known-good deployment.
* Submit early enough to recover from form or upload problems.

## Final recommendation

Keep your context-engineering concepts, but **extract the upstream harness-development machinery and all Excel-agent history from the hackathon starter**.

The recommended product is:

> A deployable full-stack AI vertical slice with a lightweight, bounded harness—not a harness repository that happens to contain a partial app.

The immediate implementation order should be:

1. Repair bootstrap and lock dependencies.
2. Remove project-specific context contamination.
3. Build one working frontend-to-backend vertical slice.
4. Add fast CI and a deployment workflow.
5. Add runnable eval cases and a demo fallback.
6. Add `NOW.md`, `JUDGING.md`, `PILOT_PATHWAY.md`, and the presentation run-of-show.

Reply `apply P0` to have these corrections prepared on a dedicated branch and submitted as a reviewable pull request.

[1]: https://help.devpost.com/article/64-judging-public-voting?utm_source=chatgpt.com "Judging & public voting - Devpost.com Help Center"
[2]: https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/setting-up-a-template-repository-for-github-codespaces?apiVersion=2022-11-28&utm_source=chatgpt.com "Setting up a template repository for GitHub Codespaces - GitHub Docs"
[3]: https://docs.github.com/en/actions/tutorials/authenticate-with-github_token?utm_source=chatgpt.com "Use GITHUB_TOKEN for authentication in workflows - GitHub Docs"
