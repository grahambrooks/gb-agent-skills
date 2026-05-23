# code-intelligence

Semantic code intelligence for Claude Code, powered by [symgraph](https://github.com/grahambrooks/symgraph) and launched on-demand by [bx](https://github.com/grahambrooks/bx).

## What you get

- **MCP server `symgraph`** — registered automatically via `.mcp.json`. Provides 16 code-intelligence tools (search, callers, callees, impact, hierarchy, path, unused, implementations, diff-impact, …).
- **Skill `explore-code`** — teaches Claude when to reach for which symgraph tool, with a tool-selection cheat sheet and a strategy section.
- **SessionStart hook** — verifies `bx` is installed, and kicks off a background first-time index if the project has never been indexed.

No manual install of `symgraph` is required: `bx` fetches and execs the right release for your platform.

## Prerequisites

You must have `bx` on your `PATH`:

```sh
brew install grahambrooks/bx/bx
# or
cargo install --git https://github.com/grahambrooks/bx
```

See the [bx README](https://github.com/grahambrooks/bx) for other install methods. The SessionStart hook will print these instructions if `bx` is missing.

## Install

```
/plugin install code-intelligence@gb-agent-skills
```

That's it. Open a project, start a session, and the hook will index it in the background.

## Usage

Invoke the skill explicitly:

```
/explore-code how does the authentication middleware work?
/explore-code what would break if I changed the User struct?
/explore-code find dead code in src/handlers/
```

Or just ask Claude code-structure questions naturally — the skill description triggers it when relevant.

## How it wires together

```
Claude Code
    │
    ├── .mcp.json ──► bx grahambrooks/symgraph serve  (stdio MCP)
    │                       │
    │                       └── reads .symgraph/index.db
    │
    ├── skill: explore-code  (when to use which symgraph tool)
    │
    └── hook: SessionStart   (bx check + background first-index)
```

`SYMGRAPH_ROOT` is set to `${CLAUDE_PROJECT_DIR}` so symgraph operates on the open project.

## Index lifecycle

- **First session:** background index runs. Symgraph queries may return empty until it finishes — check `.symgraph-index.log` in the project root for progress.
- **Subsequent sessions:** index already present, hook is a no-op.
- **After large edits:** use the `symgraph-reindex` MCP tool (incremental, fast). For structural changes, re-run `bx grahambrooks/symgraph index` manually.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `bx: command not found` | Install `bx` (see Prerequisites). |
| `symgraph-status` reports 0 nodes | First-time index hasn't finished — check `.symgraph-index.log`. |
| Stale results after edits | Run the `symgraph-reindex` MCP tool, or `bx grahambrooks/symgraph index` for a full rebuild. |
| Want a specific symgraph version | Edit `.mcp.json` and pin: `"args": ["grahambrooks/symgraph@v2026.4.13", "serve"]`. |
