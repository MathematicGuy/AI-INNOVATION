# Spec: ci-cd-pipeline

Must conform to `.wgm/specs/CONSTITUTION.md`.

## JTBD (job to be done)
When a developer pushes code or opens a pull request, the CI/CD pipeline must automatically verify the health of the entire template (both backend and frontend), so that no regressions are merged into `main`.

## User-visible success criteria
- A GitHub Actions workflow runs on every push and pull request.
- The workflow runs backend quality checks: Python tests (pytest), code style/linting (ruff), and type checks (mypy).
- The workflow runs frontend quality checks: Node.js dependency installation (npm ci), linting (oxlint), and production build (npm run build).
- The workflow completes successfully if all checks pass, and fails if any check fails, blocking the pull request.

## Magic moment
- **The whoa:** Push a commit with a type error or syntax error, see the GitHub Action fail immediately, and fix it before anyone reviews.
- **Demo path:**
  1. Create a GitHub Actions workflow file `.github/workflows/ci.yml`.
  2. Simulate the actions steps locally (running ruff, mypy, pytest, and frontend build) to guarantee they pass.
  3. Push to a branch or verify workflow syntax with action-lint/validation.
- **Smallest end-to-end slice:** Creating the `.github/workflows/ci.yml` and verifying that all actions match the project scripts.

## Acceptance criteria → backpressure

| Criterion (EARS) | How it's verified (command/check) |
|---|---|
| When the CI workflow runs, it shall execute python formatting and lint checking, mypy typechecking, and pytest test suite. | `make check-backend` (or equivalent python scripts run in sequence) |
| When the CI workflow runs, it shall execute frontend dependency installation, lint checking, and build verification. | `make check-frontend` (or equivalent npm scripts run in sequence) |
| The CI workflow file must be valid YAML and use official setup actions. | Visual inspection and YAML parsing check |

## Holdout scenarios
- Skip holdout scenarios for Quick track.

## Assumptions
- The CI pipeline runs on Ubuntu-latest virtual environment.
- Python 3.11+ is installed.
- Node.js 22+ is installed.
- The pipeline does not require external services or secrets for standard checks (since tests are fully mocked/isolated).
