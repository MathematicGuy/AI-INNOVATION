# Hackathon Harness Usage Guide

Welcome to the AI Innovation Hackathon template! This repository is pre-configured with a **repo-harness** and **codebase knowledge graph** to allow technical and non-technical team members (such as Business Analysts, Product Managers, and Data Scientists) to co-develop robust AI products alongside AI Coding Assistants (e.g., Claude Code, Cursor, Windsurf).

---

## Part 1: How the Harness Template Works (Concepts & Workflow)

During a hackathon, speed is everything, but writing broken code or running into scope creep can ruin a demo. The **Harness** acts as a safety rails framework that keeps you and your AI agent aligned.

### 1. Spec-First Alignment (JTBD)
Before you ask an AI assistant to write a single line of code, you must define the user's need.
- **[JTBD.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/JTBD.md)**: Defines the *Job-to-be-Done* (When..., I want..., so that...). It maps out the user stories, pain points, and success signals.
- **Why this matters**: It acts as the business contract. If the AI agent proposes a feature not covered by the JTBD, it is flagged as scope creep.

### 2. The Controlled Loop (Workflow MVP)
Instead of letting the AI guess and edit random files, the template establishes a structured state machine:
1. **Intake**: You provide a natural language prompt.
2. **Clarification**: The AI asks a maximum of 2–3 questions to resolve ambiguities.
3. **Spec/Plan**: The AI writes a business specification (`SPEC.md`) and a step-by-step build plan (`PLAN.md`).
4. **Human Review**: The AI pauses. You inspect the proposed plan and type **Approve** or **Request Changes**.
5. **Safe Execution**: The AI calls tools from a pre-defined allowlist (no running dangerous arbitrary terminal scripts).
6. **Auto-Validation**: Deterministic validation scripts test the output to ensure the code works exactly as intended.

### 3. Repository Map
Here is where the core harness components live:
```text
├── docs/
│   ├── product/         # Draft business specs and product contracts here
│   ├── stories/         # Detailed user story packets and acceptance criteria
│   ├── decisions/       # Architectural Decision Records (ADRs) explaining design choices
│   └── TEST_MATRIX.md   # Link between business requirements and runnable tests
├── scripts/
│   ├── bootstrap-harness.ps1 / .sh  # Initial workspace setup scripts
│   └── verify-codebase-mcp.ps1 / .sh # Local MCP server verification scripts
├── AGENTS.md            # The instruction manual that any AI agent reads upon entry
└── HACKATHON_BOILERPLATE.md # A reusable plan template for your new hackathon ideas
```

---

## Part 2: Tools & Workspace Setup

Here is how to set up the local development harness on your computer.

### 1. Codebase MCP Setup
#### What it does:
MCP (Model Context Protocol) indexes the entire repository—functions, file paths, database schemas, and dependencies—into a compressed sqlite knowledge graph (`.codebase-memory/graph.db.zst`). 
When an AI agent enters your workspace, it reads this graph first. Instead of reading hundreds of source files and wasting your token usage budget, it instantly knows where everything is.

#### How to set it up locally:
1. Make sure you have the `codebase-memory-mcp` CLI tool installed globally or via npm.
2. Open your terminal in the root of this repository.
3. Run the verification script matching your operating system:
   - **Windows (PowerShell)**:
     ```powershell
     .\scripts\verify-codebase-mcp.ps1
     ```
   - **macOS / Linux (Bash)**:
     ```bash
     chmod +x scripts/verify-codebase-mcp.sh
     ./scripts/verify-codebase-mcp.sh
     ```
   *Note: If the script detects the local graph is out of sync, it will automatically rebuild and compress it.*

#### Automated CI/CD Sync:
Every time you open a Pull Request (PR) or push code to GitHub, an automated GitHub Action workflow (`.github/workflows/codebase-mcp.yml`) runs the indexing tool, compresses the sqlite database, and commits `graph.db.zst` back to the branch. This ensures your team members always pull the most up-to-date codebase map.

---

### 2. Repo-Harness Workspace Initialization
To bootstrap the local SQLite database and environment variables:
1. Open your terminal in the root of this repository.
2. Execute the bootstrap command:
   - **Windows**:
     ```powershell
     .\scripts\bootstrap-harness.ps1
     ```
   - **macOS / Linux**:
     ```bash
     chmod +x scripts/bootstrap-harness.sh
     ./scripts/bootstrap-harness.sh
     ```
This creates the local configuration files and hooks necessary for tracking tasks and recording traces.

---

### 3. WGM & Telemetry Integration (`.wgm`)
This template supports the WGM Hive Growth loop (`agent-frontier/wgm`), which allows AI agents to learn from execution failures and build up persistent memories.

#### Enabling Telemetry:
Check the file [.github/wgm-hive.yml](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/.github/wgm-hive.yml):
- Set `consent: true` to contribute anonymized execution metadata to the growth loop database.
- Set `consent: false` if your hackathon project contains sensitive proprietary data.

#### Running WGM Commands:
When pair-programming with Claude Code or Cursor, you can trigger the WGM automation loop by running:
```text
/wgm Create a new component for X
```
The AI will systematically grill you for requirements, write the specs/plan, stop for review, run code, and execute verification tests automatically.
