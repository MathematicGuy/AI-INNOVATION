# Constitution: codebase-memory-mcp-integration

Project-wide principles every spec, plan, and task must honor.

## Principles
1. **Automation** — All codebase-memory-mcp indexing and syncing must be fully automated via GitHub Actions on every PR and main branch push.
2. **Team sync** — The codebase knowledge graph must be committed as a zstd-compressed database (`.codebase-memory/graph.db.zst`) in Git so that team members can immediately load the pre-built graph without full re-indexing.
3. **No merge conflicts** — The `.gitattributes` file must declare `merge=ours` for `.codebase-memory/graph.db.zst` to ensure team members do not experience Git merge conflicts.
4. **Cross-platform validation** — We must provide both Bash and PowerShell scripts to support developers on Windows, macOS, and Linux.

## Non-negotiables
- The compressed database `graph.db.zst` must be successfully committed and tracked in git.
- The `.gitignore` must explicitly allow tracking `graph.db.zst` while ignoring other temporary codebase-memory cache files.

## Tech constraints
- **Must use:** GitHub Actions, codebase-memory-mcp CLI, Bash, and PowerShell.
- **Deployment target:** GitHub Actions workflow runner (Ubuntu) and local developer environments.

## Recording deviations
No deviations.

**Version**: 1.0.0 | **Ratified**: 2026-07-16 | **Last Amended**: 2026-07-16
