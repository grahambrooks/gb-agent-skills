---
name: explore-code
description: Use symgraph MCP tools to explore and understand code. Use when the user asks about code structure, symbol relationships, call graphs, impact analysis, dead code, interface implementations, or needs focused context for a coding task.
argument-hint: "<question or task description>"
allowed-tools: mcp__symgraph__symgraph-context, mcp__symgraph__symgraph-search, mcp__symgraph__symgraph-callers, mcp__symgraph__symgraph-callees, mcp__symgraph__symgraph-impact, mcp__symgraph__symgraph-definition, mcp__symgraph__symgraph-file, mcp__symgraph__symgraph-references, mcp__symgraph__symgraph-node, mcp__symgraph__symgraph-hierarchy, mcp__symgraph__symgraph-path, mcp__symgraph__symgraph-unused, mcp__symgraph__symgraph-implementations, mcp__symgraph__symgraph-diff-impact, mcp__symgraph__symgraph-status, mcp__symgraph__symgraph-reindex, Read, Grep, Glob
---

You have access to **symgraph**, a semantic code intelligence MCP server that maintains a knowledge graph of the codebase (symbols, calls, contains, imports, implements, extends). Use it to answer: $ARGUMENTS

## When to reach for which tool

Pick the narrowest tool that fits — symgraph is faster and more precise than scanning the filesystem.

| Question | Tool |
|---|---|
| "Where is `X` defined?" / "Find symbols matching name" | `symgraph-search`, then `symgraph-definition` |
| "Show me the source of `X`" | `symgraph-definition` |
| "Who calls `X`?" | `symgraph-callers` |
| "What does `X` call?" | `symgraph-callees` |
| "All usages of `X`" (calls + non-call references) | `symgraph-references` |
| "How does data flow from `A` to `B`?" | `symgraph-path` |
| "If I change `X`, what breaks?" | `symgraph-impact` |
| "What would changing lines N–M of `file.rs` affect?" | `symgraph-diff-impact` |
| "What symbols live in `file.rs`?" | `symgraph-file` |
| "All implementations of trait/interface `T`" | `symgraph-implementations` |
| "Class/module parent–child relationships" | `symgraph-hierarchy` |
| "Find dead code" | `symgraph-unused` |
| "Build broad context for a task" | `symgraph-context` |
| "Detailed info on one symbol" | `symgraph-node` |

If results look stale after the user mentions recent edits, run `symgraph-reindex` first. Check `symgraph-status` if you suspect the index is missing or empty.

## Strategy

1. **Start narrow.** Prefer `symgraph-search` → `symgraph-definition` over `symgraph-context` for specific questions. Reserve `symgraph-context` for open-ended "help me understand X" tasks.
2. **Disambiguate before diving deeper.** If `symgraph-search` returns multiple matches, ask the user (or use surrounding context) to pick the right one before pulling callers/callees.
3. **Follow call chains step by step** with `callers`/`callees` rather than guessing. For "how is A connected to B" use `symgraph-path` directly.
4. **Always show source.** When explaining behavior, fetch the actual code with `symgraph-definition` and quote the relevant lines — don't paraphrase from symbol names alone.
5. **Combine with file reads.** symgraph returns symbol-scoped excerpts; if you need surrounding file context (constants, imports, comments), follow up with `Read`.
6. **For impact analysis,** prefer `symgraph-diff-impact` when you have a line range, `symgraph-impact` when you have a symbol name.

## Index hygiene

- A project must be indexed before symgraph can answer questions. The plugin's session-start hook attempts a first-time index automatically via `bx grahambrooks/symgraph index`.
- If `symgraph-status` reports 0 nodes or `symgraph-search` returns nothing for symbols you know exist, tell the user to run `bx grahambrooks/symgraph index` in the project root.
- After large edits, run `symgraph-reindex` (incremental, fast) — full re-index only if structure changed dramatically.
