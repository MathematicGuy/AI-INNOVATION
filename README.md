## The Problem

Most repos are built for humans reading code in a familiar codebase. Coding
agents usually enter with only a chat prompt and a shallow snapshot of files.
That leads to common failure modes:

- The agent edits code before understanding product intent.
- Important constraints live only in chat history or in someone's head.
- Validation expectations are vague or discovered too late.
- Architecture tradeoffs are repeated instead of inherited.
- Large requests do not get broken into reviewable story-sized work.

## The Harness Approach

A repository starts to have a harness when it helps an agent answer practical
engineering questions without relying only on chat history:

- What should I read first?
- What type of work is this?
- Which product contract does it affect?
- How risky is the change?
- What proof will show the work is done?
- What decision or lesson should future agents inherit?

In this repo, those answers live in:

- `AGENTS.md` — the stable agent shim with local project notes and Harness
  doc links.
- `docs/HARNESS.md` — the human-agent collaboration model.
- `docs/FEATURE_INTAKE.md` — tiny, normal, and high-risk work classification.
- `docs/ARCHITECTURE.md` — architecture discovery and boundary rules.
- `docs/TEST_MATRIX.md` — behavior-to-proof validation expectations.
- `docs/stories/` — story packets and backlog items.
- `docs/decisions/` — durable decisions and tradeoffs.
- `docs/templates/` — reusable spec, story, decision, and validation templates.

OpenAI describes this shift as an agent-first world where humans steer and
agents execute:

https://openai.com/index/harness-engineering/

## Try The Flow

The fastest way to understand the harness is to inspect the tiny demo:

- `docs/demo/README.md`: shows how a simple product idea becomes product docs,
  stories, validation expectations, and decisions before implementation starts.

A typical flow looks like this:

```text
human intent or product spec
  -> product contract
  -> feature intake
  -> story packet
  -> validation expectations
  -> implementation work
  -> decision or lesson captured for future agents
```

Implementation prompts do not go straight to code. They first pass through
feature intake, become story-sized work when needed, and then carry both product
validation and harness maintenance expectations.

Harness exposes a versioned orchestration contract for external runners. One
independent consumer is [Symphony](https://github.com/hoangnb24/symphony); it
is not part of this repository or the Harness installer.

## Tool Registry

The harness can use optional external tools (linters, code-graph servers,
deploy checks) without depending on any of them. You register a tool as a
provider of a *capability*, the harness scans whether it is actually present,
and a workflow step uses whatever is equipped — an absent tool is a clean skip,
never a failure.

Kinds (`cli`, `binary`, `mcp`, `skill`, `http`) make it agent-generic: each
agent runtime uses what it can orchestrate. See `docs/TOOL_REGISTRY.md` for the
full model, the degrade ladder, and how to wire a tool into a flow step.

## Current State

This repository implements the Harness v0 product: a Rust CLI, SQLite durable
layer, installers, operating documents, contract tests, and release automation.
Those upstream components are executable product behavior, not placeholders.

Installing Harness into another repository does not create or choose that
consumer's application, stack, or product specification. It adds the reusable
engineering layer that helps humans and agents turn the consumer's intent into
validated work.

## Product Sources

The upstream Harness contract lives in this README, the operating documents,
the versioned orchestration contract, story packets, and executable tests. The
generic `docs/product/` directory is reserved for a consumer project's product
contract; Harness intentionally does not populate it with a fake domain model.

When a user provides a project specification, add or reference it as the input
spec for the first buildout, then derive smaller living artifacts from it:

- `docs/product/`: current product contract files, created from the spec.
- `docs/stories/`: story packets and backlog created from selected work.
- `docs/TEST_MATRIX.md`: behavior-to-proof control panel.
- `docs/decisions/`: durable decisions and tradeoffs.

Do not keep a project-specific spec or product breakdown in this harness until
a real project supplies one.

## Repository Structure

```text
project/
  AGENTS.md
  README.md
  docs/
    HARNESS.md
    FEATURE_INTAKE.md
    ARCHITECTURE.md
    TEST_MATRIX.md
    HARNESS_BACKLOG.md
    product/
    stories/
    decisions/
    demo/
    templates/
  scripts/
    README.md
```

## Contributing

This project is early and benefits most from real-world agent failure cases,
example harness installs, docs improvements, and reusable workflow patterns.
See `CONTRIBUTING.md` for contribution ideas.

Useful contributions include:

- Show how the harness works in a real project.
- Add missing templates or improve existing ones.
- Propose validation patterns for different stacks.
- Share failures where an agent made the wrong change because the repo lacked
  context.
- Compare harness behavior across Claude Code, Codex, Cursor, and other tools.

## Share

If this idea resonates, please star the repo and share it with someone building
with coding agents.

Short description:

> An agent-ready repo harness for Claude Code, Codex, Cursor, and other coding
> agents: AGENTS.md, product contracts, story packets, validation matrix, and
> decision records.
