# Hackathon Runbook (48-hour operating plan)

Adapted from TEMPLATE-REVIEWED.md Section 9. Keep `main` deployable at all times.

## Hour 0-2 — Judging and scope lock
- Copy exact criteria/weights into `JUDGING.md`.
- Pick one user, one job, one demo promise (record in `NOW.md`).
- Choose deployment target. Assign the four lanes in `OWNERS.md`.
- Decide what will be mocked.

## Hour 2-6 — Deployment-first foundation
- Make clean bootstrap pass. Deploy frontend + backend "hello world".
- Freeze the API contract in `NOW.md`. Add CI. Add a demo fixture + mock-provider mode.

## Hour 6-20 — One vertical slice
- Build only the core workflow. Integrate UI + backend + AI early. Merge continuously.

## Hour 20-30 — Quality and evidence
- Add error/fallback states. Build 12-20 eval cases. Collect feedback.
- Write `demo-pitch-deck/pilot/PILOT_PATHWAY.md`. Capture screenshots + metrics.

## Hour 30-36 — Feature freeze
- No new major features. Fix regressions. Add demo reset + backup mode. Record demo video.

## Hour 36-44 — Pitch and rehearsal
- Build the deck from real evidence. Rehearse a strict 3-5 minute run. Prepare Q&A.
- Verify every link in a clean/incognito browser.

## Hour 44-48 — Submission freeze
- Final smoke test. Verify repo access, live URL, and video. Preserve last known-good deploy.
- Submit early enough to recover from upload problems.
