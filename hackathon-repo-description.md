# Hackathon Repository Template Description

This repository is a pre-configured template specifically designed to maximize velocity and reliability during **AI Hackathons**. It combines **spec-driven development**, **human-in-the-loop validation**, and **codebase indexing** to help developers and AI agents build working software concurrently without running into integration hell.

---

## 1. High-Level Concept

In a hackathon, teams often fail because of two things:
1. **Scope Creep**: Implementing complex features that aren't critical for the demo.
2. **AI Drift**: AI coding assistants generating broken code, hallucinating APIs, or refactoring unrelated files.

This harness template solves both by enforcing a clear **spec-to-code pipeline** and giving your AI assistant a **semantic map** of the repository.

---

## 2. Core Boilerplate Files

The repository contains three primary template files that serve as independent starting points for your hackathon project:

### 📄 [README.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/README.md)
* **Purpose**: The main project description page.
* **Contents**: Includes sections for the one-line pitch, problem description, target user, tech stack, quick start guide, API endpoints, and a deliverables checklist to track hackathon progress.

### 📄 [JTBD.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/JTBD.md)
* **Purpose**: Defines the product specification using the *Job-to-be-Done* framework.
* **Contents**: Outlines target users, job stories, pain points, core assumptions, and the step-by-step user experience. This keeps the team focused strictly on MVP value.

### 📄 [Workflow-MVP.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/Workflow-MVP.md)
* **Purpose**: Outlines the technical flow, agent architecture, and state machines of your AI system.
* **Contents**: Architectures, state transitions, allowlist tool boundaries, validation rules, retry policies, and persistent memory protocols.

### 📄 [PROJECT_MANAGEMENT.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/PROJECT_MANAGEMENT.md)
* **Purpose**: Tracks milestones (M0 to M5) and features.
* **Contents**: Work Breakdown Structure (WBS), Gantt chart timeline, and a story registry mapping user requirements to technical tasks.

---

## 3. Automation & Developer Tools

The template comes equipped with scripts and configs to make local and CI/CD development seamless:

### ⚙️ Codebase MCP (Model Context Protocol)
* **What it does**: Builds a compressed knowledge graph of the repository (`.codebase-memory/graph.db.zst`). When you connect an AI agent (e.g. Cursor or Claude Code) to the workspace, it reads this index first to find files and understand dependencies instantly, drastically reducing token usage and context window bloat.
* **Local Setup**:
  * Windows (PowerShell): `.\scripts\verify-codebase-mcp.ps1`
  - macOS/Linux (Bash): `./scripts/verify-codebase-mcp.sh`
* **Automated Sync**: The GitHub Action `.github/workflows/codebase-mcp.yml` automatically updates and commits the graph database back to your branch on every PR or push, keeping the team's indexing files in sync.

### ⚙️ Git Conflict Resolution
* The [.gitattributes](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/.gitattributes) file contains a `merge=ours` policy for `.codebase-memory/graph.db.zst`. This ensures that binary database changes on parallel branches are merged automatically without ever raising a git merge conflict.

### ⚙️ Workspace Bootstrapping
* **What it does**: Initializes the local database and harness context for tracking tasks and operations.
* **Local Setup**:
  * Windows: `.\scripts\bootstrap-harness.ps1`
  * macOS/Linux: `./scripts/bootstrap-harness.sh`

### ⚙️ Coding Agent Manual ([AGENTS.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/AGENTS.md))
* **What it does**: Sets the project-wide operating rules (non-negotiables, surgical changes, test-driven validation, communication style) that any AI agent joining the repository MUST follow.
