---
event: SessionStart
description: Verify bx is installed and kick off a background symgraph index if the project has never been indexed.
---

# SessionStart Hook

Runs once when a Claude Code session begins.

## Behaviour

1. **Check `bx`** — if not on PATH, prints install instructions to stderr (one-time, non-fatal). The symgraph MCP server cannot start without `bx`.
2. **Background index** — if the project has no index in either real storage location (`<git-common-dir>/symgraph/index.db`, symgraph's default, or the legacy `${CLAUDE_PROJECT_DIR}/.symgraph/index.db`), launches `bx grahambrooks/symgraph index` as a detached background process. `symgraph index` writes its progress log to `index.log` beside the index, never the working tree; the launcher's output is captured to `${TMPDIR}/symgraph-index.log` for crash diagnostics. Subsequent sessions detect the existing index and skip this step.

The hook never blocks session startup — both checks return immediately. Once the background index finishes, the symgraph MCP tools start returning meaningful results.

## Why background?

A full `symgraph index` on a large repo can take minutes. Running it inline in `SessionStart` would stall every fresh session. Detaching the process means symgraph queries may return empty results during the first session, but the index will be ready by the next one.
