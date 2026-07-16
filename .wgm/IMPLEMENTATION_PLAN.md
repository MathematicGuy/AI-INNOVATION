# Implementation plan

> The shared state of the loop. Prioritized; the agent always takes the most important `pending`
> task. Update every iteration so a fresh agent could resume from this file alone.
> Status values: `pending | in_progress | done | blocked`.

## Convergence
- **Satisfaction threshold:** 95
- **Stratified order:** converge tier 1
- **Scenarios:** `.wgm/scenarios/codebase_mcp_verification.yaml`

## Now (next up)

### T1 — Create local verification scripts and configure Git files
- **files/areas:** `scripts/verify-codebase-mcp.sh`, `scripts/verify-codebase-mcp.ps1`, `.gitignore`, `.gitattributes`
- **validation:** `powershell -ExecutionPolicy Bypass -File .\scripts\verify-codebase-mcp.ps1`
- **acceptance:** Local scripts run successfully, codebase-memory-mcp is installed, indexing is executed, `.codebase-memory/graph.db.zst` is generated and tracked by Git, and `.gitattributes` is correctly set.
- **scenarios/tier:** codebase-mcp-integration (tier 1)
- **status:** done
- **notes:** Local script verified successfully. .codebase-memory/graph.db.zst generated, tracked, and .gitattributes configured.

### T2 — Create GitHub Actions CI workflow
- **files/areas:** `.github/workflows/codebase-mcp.yml`
- **validation:** `powershell -ExecutionPolicy Bypass -File .\scripts\verify-codebase-mcp.ps1`
- **acceptance:** The workflow file `.github/workflows/codebase-mcp.yml` is created and correctly configured to install codebase-memory-mcp, index the repository, run the verification, and commit the graph back to Git.
- **scenarios/tier:** codebase-mcp-integration (tier 1)
- **status:** pending
- **notes:**

## Later (backlog)

### TZ — Demo validation (required before Ship/Handoff)
- **files/areas:** `scripts/verify-codebase-mcp.sh`, `scripts/verify-codebase-mcp.ps1`
- **validation:** `powershell -ExecutionPolicy Bypass -File .\scripts\verify-codebase-mcp.ps1`
- **acceptance:** The local validation script runs successfully and verifies all aspects of codebase-memory-mcp integration.
- **status:** pending
- **notes:**

## Done
- T1 — Create local verification scripts and configure Git files

