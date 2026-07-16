# Current Mission

> Single source of truth for "what are we doing right now". Keep it under ~80 lines.
> Update at every integration checkpoint. If it is longer than one screen, prune.

## Demo promise
The single workflow judges must see working end-to-end:
- [ ] <one sentence — e.g., "Paste a business problem, get structured analysis back">

## Current milestone
What must be true at the next integration checkpoint:
- <milestone statement>

## Owners
- Frontend: <name>
- Backend: <name>
- AI/Eval: <name>
- Pilot/Pitch: <name>

## Frozen contracts
- API schema: `POST /api/v1/chat` -> `{answer, explanation, sources, trace_id, status}`
- Data model: <link>
- Deployment URL: <url or "TBD">

## Active tasks
- <owner> — <task> — <expected proof>

## Blockers
- <blocker or "none">

## Demo risks
- <risk and mitigation>

## Next integration checkpoint
- Time: <when>
- Commands: `make check` (or the current smoke command)
