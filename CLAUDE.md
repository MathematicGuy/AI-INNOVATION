# AI Innovation Hackathon: Local Agent Workspace Guidelines

Welcome, Coding Agent! You are working in a hackathon template repository pre-configured with a **repo-harness** and **codebase-memory-mcp** index.

---

## 1. Project Context & Purpose
- This is a template/scaffold repository designed for rapid, trustworthy MVP development during hackathons.
- It contains abstract examples of product requirements, project roadmap trackers, system designs, and context specifications.
- Your primary goal is to help the team build features quickly while maintaining strict code validation and architecture boundaries.

---

## 2. Core Tech Stack & Tooling
- **Orchestration**: LangGraph, FastAPI, Python 3.11+
- **Database / State**: SQLite (`harness.db`) / PostgreSQL (production target)
- **Observability**: Langfuse
- **Testing / Validation**: pytest
- **MCP Services**: `codebase-memory-mcp` (primary codebase index)

---

## 3. High-Leverage Developer Commands
- **Initialize Harness**: 
  - Windows: `.\scripts\bootstrap-harness.ps1`
  - macOS/Linux: `./scripts/bootstrap-harness.sh`
- **Verify / Update Codebase MCP Graph**:
  - Windows: `.\scripts\verify-codebase-mcp.ps1`
  - macOS/Linux: `./scripts/verify-codebase-mcp.sh`
- **Run Local Test Suite**:
  - `pytest tests/` (or single file: `pytest tests/test_feature.py`)
- **Git Conventions**:
  - Always commit using **Conventional Commits** (e.g., `feat: add database schema`, `fix: resolve auth boundary`).

---

## 4. Operating Protocol & Boundaries
1. **MCP Knowledge Graph First**:
   - Always query the `codebase-memory-mcp` tool (e.g., `search_graph`, `get_code_snippet`) for file discovery and semantic layout. 
   - Fall back to standard `grep_search` or filesystem list tools ONLY when searching for non-code assets, raw strings, or configuration parameters.
2. **Strict Spec-First Flow**:
   - Never implement code changes before reviewing the user's intent in `docs/product/` and story details in `docs/stories/`.
   - Ensure the implementation aligns with the rules in `specs/CONSTITUTION.md` (if present) and matches [AGENTS.md](file:///E:/VIN-INTERNSHIP/AI-INNOVATION/AGENTS.md).
3. **Surgical Modularity**:
   - Limit your file modifications strictly to the files needed for the active task.
   - Do not perform random cleanups, formatting of adjacent code, or drive-by refactorings.
4. **Deterministic Validation**:
   - Every feature must have a validation mechanism (tests, checks, or assertions). 
   - A task is NOT complete until its backpressure command exits with code `0`.
