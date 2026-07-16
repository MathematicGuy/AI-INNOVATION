# CORE_CONTEXT.md — Cross-Milestone Operating Context

> [!IMPORTANT]
> **HACKATHON TEMPLATE & EXAMPLE**
> This file is a template and abstract example. Update all bracketed placeholders `[...]` with your actual hackathon project details.

Read this first when taking over any milestone. It stores durable constraints, authoritative locations, and verified live state. 

## Repository and working rules
- Workspace: `[Path to project directory]`; it is a Git repository.
- Read `AGENTS.md` before starting work.
- Keep changes surgical. Do not modify existing dirty files unless the current request explicitly places them in scope.

## Durable artifact map
- Milestone handoffs: `.agents/handoffs/`
- Product contracts: `docs/product/`
- Durable architecture decisions: `docs/decisions/`
- Story packets and acceptance evidence: `docs/stories/`
- Approved implementation plans: `docs/superpowers/plans/`
- Harness rules and commands: `docs/FEATURE_INTAKE.md`, `docs/CONTEXT_RULES.md`, `docs/TRACE_SPEC.md`, and `scripts/bin/harness-cli.exe`

## Cross-milestone execution protocol
1. Confirm the requested milestone and read its exact handoff before planning.
2. Run standard bootstrap (e.g. `scripts/bootstrap-harness.ps1`), record intake, query the active matrix, then retrieve only the lane-specific context required.
3. The controller creates or updates the milestone's specs, decisions, story packet, and implementation plan before code work.
4. During implementation, complete one planned task at a time. Run its focused test, review the diff, commit only its intended files.
5. Close each completed story with the plan's Harness commands. Run both `harness-cli audit` and `harness-cli propose` at milestone closeout.

## Technical constraints currently in force
- **Main language/runtime:** [e.g. Python >=3.11 / Next.js Node 18]
- **Core libraries:** [e.g. FastAPI, LangGraph, Pydantic, pytest]
- **Security constraint:** Never execute agent-supplied arbitrary code strings or raw shell commands from LLM output. All actions must run through registered tool modules.

## Current Milestone verified state — [Milestone Name]
- Branch: `[active-branch-name]`.
- Approved plan: `[path-to-approved-plan-md]`.
- Latest verified commit: `[commit-hash]`.
- Verification status: `[e.g. All unit and integration tests passed]`.
