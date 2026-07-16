# Ownership Lanes

Four lanes, one owner each. The owner is accountable for the lane's demo-critical
outcome, not for doing all the work alone.

| Lane | Owner | Demo-critical outcome | Primary files |
|------|-------|-----------------------|---------------|
| Frontend | <name> | The judge-visible UI flow works | `frontend/` |
| Backend | <name> | API + agent respond reliably | `src/` |
| AI / Eval | <name> | Answers are good; eval gate is green | `src/agents/`, `eval/` |
| Pilot / Pitch | <name> | Pilot pathway + deck + submission | `demo-pitch-deck/pilot/`, `demo-pitch-deck/presentation/` |

## Rules
- Cross-lane changes require a heads-up in `NOW.md` "Blockers" before merging.
- The frozen contracts in `NOW.md` change only by agreement of Frontend + Backend owners.
