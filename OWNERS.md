# Ownership Lanes

Four lanes, one owner each. The owner is accountable for the lane's demo-critical
outcome, not for doing all the work alone. Each lane owns specific rubric rows in
`JUDGING.md` — that is how all 100 points stay accounted for, with no orphan row.

| Lane | Owner | Demo-critical outcome | Rubric rows owned | Primary files |
|------|-------|-----------------------|-------------------|---------------|
| Frontend | <name> | The judge-visible UI flow works and surfaces AI thinking | 04 UX (15) · shares 01 | `frontend/` |
| Backend | <name> | API + agent respond reliably; repo + deploy stay green | 01 Engineering (20) | `src/`, CI, `Dockerfile` |
| AI / Eval | <name> | Answers are AI-native, grounded, and the eval gate is green | 02 Architecture (20) · 05 Safety (15) | `src/agents/`, `eval/` |
| Pilot / Pitch | <name> | Pilot pathway + deck + submission land on time | 03 Viability (20) · 06 Presentation (10) | `demo-pitch-deck/pilot/`, `demo-pitch-deck/presentation/` |

## Final Submission ownership (5 mandatory items — 11:00 AM, July 19th)

Every item has one accountable lane. The checklist itself lives in `JUDGING.md`.

| Submission item | Accountable lane |
|-----------------|------------------|
| Presentation Slides | Pilot / Pitch |
| Demo Video (≤ 5 min) | Pilot / Pitch (Frontend drives the on-screen flow) |
| GitHub Repository (public) | Backend |
| Live Deployed URL | Backend |
| AI Collaboration Log | Pilot / Pitch (every lane contributes entries) |

## Rules
- Cross-lane changes require a heads-up in `NOW.md` "Blockers" before merging.
- The frozen contracts in `NOW.md` change only by agreement of Frontend + Backend owners.
- Keep the AI Collaboration Log as you go — prompts, agent handoffs, what AI wrote vs.
  what you wrote. It is a mandatory submission item, not something to reconstruct at 10:45.
