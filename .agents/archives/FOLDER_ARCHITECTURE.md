# Project Folder Architecture & Hygiene

This document defines the canonical directory layout, hygiene rules, and file-placement policies for this repository. Adhering to these conventions prevents root pollution, separates documentation from runtime code, and ensures that both human developers and AI agents can seamlessly navigate and maintain the project.

---

## 1. Directory Tree Overview

Below is the verified layout of the `Best-Work-Agent` workspace:

```text
Best-Work-Agent/
├── .agents/                    # Agent configuration, tools, and execution artifacts
│   ├── archives/               # Roadmaps, milestone trackers, and structure guides
│   │   ├── FOLDER_ARCHITECTURE.md  # [This File] Project folder structure hygiene
│   │   ├── MILESTONE.md        # Proposed milestones and roadmap definition
│   │   └── README.md           # Archives warning (Human read/edit only by default)
│   ├── handoffs/               # Session handoff documents for agent handovers
│   └── skills/                 # Reusable agent skill modules (e.g., caveman, clean-designer)
├── .harness/                   # Durable Harness state, execution logs, and locks
│   └── epoch-transition/       # Epoch-based transition state lock files
├── docs/                       # Comprehensive documentation & Harness metadata
│   ├── contracts/              # Specification schemas & orchestration protocols
│   ├── decisions/              # Architecture Decision Records (ADRs)
│   ├── images/                 # Visual assets and diagrams
│   ├── product/                # Product specs, workflows, and logic requirements
│   ├── stories/                # User stories, story packets, and sub-fixtures
│   │   └── US-107-inventory.../ # Specific multi-file story slice artifacts
│   ├── superpowers/            # Milestones and approved plans
│   │   └── plans/              # Executed and approved milestone plans
│   ├── templates/              # Templates for ADRs, specs, stories, and validations
│   └── [docs_root_files].md    # Global test matrices, glossaries, tool registries, etc.
├── scripts/                    # Scripts and operational helper utilities
│   ├── bin/                    # Prebuilt architecture-specific binaries (e.g., harness-cli)
│   └── schema/                 # SQL database schemas and schema migration files
├── harness.db                  # Local SQLite database (Harness audit metrics & trace history)
├── AGENTS.md                   # Stable agent shim containing environment guidelines
├── GEMINI.md                   # Agent directives specifically for Gemini models
├── JTBD.md                     # Jobs-To-Be-Done, user scenarios, and target jobs
├── PROGRESS.md                 # Excel Agent MVP roadmap and Work Breakdown Structure (WBS)
├── README.md                   # General project README, installation, and harness usage
└── Workflow-MVP.md             # Execution flow diagram and product rules
```

---

## 2. Hygiene & File Placement Matrix

To maintain project hygiene, respect the following rules for each directory:

| Directory Path | Allowed Contents | Forbidden Contents | Owner / Maintenance Policy |
| :--- | :--- | :--- | :--- |
| `.` (Root) | Critical global files (`AGENTS.md`, `README.md`, `PROGRESS.md`, `.env.example`, `.gitignore`). | Source code files, raw data, logs, temporary backups, test scripts. | Strict. No new root files without an ADR. |
| `.agents/archives/` | Milestones, roadmaps, static architectural guidelines. | Dynamic run logs, scratch files, prompt files. | Human-curated. |
| `.agents/handoffs/` | Agent session handoff markdown files (`[handoff_name].md`). | Skills, general documentation, or code. | Generated at the end of agent sessions. |
| `.agents/skills/` | Skill folders containing `SKILL.md` and related support code/resources. | General documentation, project source code. | Standard skill plugins. |
| `docs/` | System-level markdown docs (architecture, matrices, glossaries). | Local code, Python dependencies, database backups. | Shared. Follow templates in `docs/templates/`. |
| `docs/decisions/` | Architecture Decision Records (ADRs, format: `NNNN-*.md`). | Loose notes, scratch designs. | Must be registered via `harness-cli decision add`. |
| `docs/stories/` | Story specifications (`US-XXX-*.md`) and directories for multi-file story contexts. | Active source code, runtime databases. | Created during spec intake phase. |
| `docs/superpowers/plans/` | Approved implementation plans. | Draft plan files, scratch scripts. | Created in planning mode before execution. |
| `scripts/` | Shell (`.sh`) and PowerShell (`.ps1`) automation scripts. | Prebuilt binaries (must go into `scripts/bin/`). | Shared utility space. |
| `scripts/bin/` | Compiled executable binaries (e.g. `harness-cli`). | Raw source files, config files. | Populated by bootstrap or installer. |
| `.harness/` | Lock files (`writer.lock`), trace files, session state. | Versioned source code, user documentation. | Ignored in git (except template folders if any). |

---

## 3. Core Folder Hygiene Policies

### A. Root Pollution Prevention
The root directory MUST remain minimal. New top-level directories or files are disallowed unless:
1. They are configuration standards recognized by toolchains (e.g. `pyproject.toml`, `.gitignore`, `.env`).
2. They are explicit workspace metadata documents approved in an ADR.

### B. Story Packet Conventions
- **Single-File Stories**: Story specifications must be placed directly under `docs/stories/` following the naming standard `US-XXX-[kebab-case-description].md`.
- **Multi-File Stories**: If a story requires additional design files, sub-validation plans, or specialized mock data, create a subfolder with the matching story ID (e.g., `docs/stories/US-107-inventory-workbook-slice/`). Keep all story-specific context inside that subfolder.

### C. Architecture Decision Records (ADRs)
- Every ADR must start with a 4-digit sequential index (e.g., `0011-observability-langfuse-integration.md`).
- ADRs must be structured using `docs/templates/decision.md`.
- After creating an ADR, it must be registered with the Harness database using:
  ```bash
  scripts/bin/harness-cli decision add --id <id> --title "<title>" --doc docs/decisions/<filename>.md
  ```

### D. Handoff & Session State
- When finishing an agent session or handing off work to another agent, write the handoff document under `.agents/handoffs/[handoff_name].md`. This file should contain:
  1. Current Scope & progress.
  2. Definition of Done (DoD) status.
  3. Technical constraints.
  4. Findings & patterns discovered.

### E. Git & Ignore Policies
- **Never commit**:
  - `harness.db` (local SQLite database).
  - `.env` (local secrets and environment overrides).
  - `.harness/` runtime locks and traces.
  - `.venv/` or any python virtual environment folders.
  - Temporary files, visual artifacts, or screenshots that are not part of `docs/images/`.
