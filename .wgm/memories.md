# wgm memories — lessons that outlive one iteration

## Gotchas (things that bit us)
- 2026-07-16 `codebase-memory-mcp cli index_repository` with raw JSON arguments (e.g. `'{"repo_path": "...", "persistence": true}'`) triggers a deprecation warning and causes indexing worker crashes on Windows. Workaround: Use command line flags instead: `--repo-path <path> --persistence true`.
- 2026-07-17 FastAPI/LangGraph template type check (mypy) mismatch between StateGraph and CompiledStateGraph return type signatures, causing 'no attribute ainvoke' errors. Fix: Update return signature to CompiledStateGraph.
- 2026-07-17 ChatOpenAI api_key argument type mismatch in mypy (expects SecretStr or Callable, got str). Fix: Add type ignore comment.

## Stall lessons (cause -> fix)
None.

## Patterns that work here
- 2026-07-16 Using `--repo-path` and `--persistence` flags works natively on Windows and generates `.codebase-memory/graph.db.zst` without errors.

## Dead ends (do not retry)
- 2026-07-16 Passing raw JSON to `cli index_repository` on Windows.
