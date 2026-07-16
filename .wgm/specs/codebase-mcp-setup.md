# Spec: codebase-mcp-setup

Must conform to `.wgm/specs/CONSTITUTION.md`.

## JTBD (job to be done)
When developers clone the repository or work on PRs, the codebase-memory-mcp knowledge graph should be pre-built and synced, so that their local AI agents can immediately leverage code intelligence without full re-indexing, and CI/CD pipelines automatically update the graph.

## User-visible success criteria
- Teammates pull the repository and have immediate access to `.codebase-memory/graph.db.zst`.
- Every PR/push triggers a GitHub Action that installs codebase-memory-mcp, indexes the repository, and pushes the updated `.codebase-memory/graph.db.zst` file to git.
- Test/verification scripts run successfully in CI and locally, asserting that the graph file is tracked in git and not ignored.

## Magic moment
- **The whoa:** Running git clone on a fresh directory, starting an AI agent, and having it immediately answer complex codebase questions in <50ms using the pre-synced database without any local indexing delay.
- **Demo path:**
  1. Initialize a dummy/test git directory.
  2. Run `scripts/verify-codebase-mcp.sh` (or `verify-codebase-mcp.ps1` on Windows).
  3. Verify that the `.codebase-memory/graph.db.zst` exists, git tracks it, and `.gitattributes` has `merge=ours`.
- **Smallest end-to-end slice:** Successful execution of the local verify scripts and GitHub Action workflow run.

## Acceptance criteria → backpressure

| Criterion (EARS) | How it's verified (command/check) |
|---|---|
| When the local verification scripts are run, they shall successfully index the repository and verify that `graph.db.zst` is not ignored and gitattributes is correctly set | `.\scripts\verify-codebase-mcp.ps1` or `./scripts/verify-codebase-mcp.sh` |
| When a push or PR is created, the GitHub Actions workflow shall execute codebase-memory-mcp and commit the updated graph file | Validate the workflow syntax and configuration |

## Holdout scenarios
- **Files:** `.wgm/scenarios/codebase_mcp_verification.yaml`

## Assumptions
- The runner on GitHub Actions has internet access to download the codebase-memory-mcp binary using curl.
- The repository has the necessary permissions to write back to branches (GITHUB_TOKEN permissions with write access to repository contents).
