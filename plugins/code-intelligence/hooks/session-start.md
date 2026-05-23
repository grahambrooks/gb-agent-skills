---
event: SessionStart
description: Verify bx is installed and kick off a background symgraph index if the project has never been indexed.
---

# SessionStart Hook

Runs once when a Claude Code session begins.

## Behaviour

1. **Check `bx`** — if not on PATH, prints install instructions to stderr (one-time, non-fatal). The symgraph MCP server cannot start without `bx`.
2. **Background index** — if `${CLAUDE_PROJECT_DIR}/.symgraph/` is missing, launches `bx grahambrooks/symgraph index` as a detached background process. Logs to `.symgraph-index.log` in the project root. Subsequent sessions skip this step.

The hook never blocks session startup — both checks return immediately. Once the background index finishes, the symgraph MCP tools start returning meaningful results.

## Why background?

A full `symgraph index` on a large repo can take minutes. Running it inline in `SessionStart` would stall every fresh session. Detaching the process means symgraph queries may return empty results during the first session, but the index will be ready by the next one.
