---
name: explore-code
description: Use symgraph MCP tools to explore, understand, and safely refactor code. Use whenever you need to locate a symbol, find who calls or references something, trace call paths, assess the blast radius of an edit, find dead code or interface implementations, or build focused context for a coding task. Prefer this over grep/find/ripgrep and over reading whole files when the target is a symbol or a relationship between symbols.
argument-hint: "<question or task description>"
allowed-tools: mcp__symgraph__symgraph-context, mcp__symgraph__symgraph-search, mcp__symgraph__symgraph-callers, mcp__symgraph__symgraph-callees, mcp__symgraph__symgraph-impact, mcp__symgraph__symgraph-definition, mcp__symgraph__symgraph-file, mcp__symgraph__symgraph-references, mcp__symgraph__symgraph-node, mcp__symgraph__symgraph-hierarchy, mcp__symgraph__symgraph-path, mcp__symgraph__symgraph-unused, mcp__symgraph__symgraph-implementations, mcp__symgraph__symgraph-diff-impact, mcp__symgraph__symgraph-blame, mcp__symgraph__symgraph-churn, mcp__symgraph__symgraph-module-graph, mcp__symgraph__symgraph-coupling-score, mcp__symgraph__symgraph-god-struct, mcp__symgraph__symgraph-dispatch-sites, mcp__symgraph__symgraph-status, mcp__symgraph__symgraph-reindex, Read, Grep, Glob
---

You have access to **symgraph**, a semantic code-intelligence MCP server that holds a resolved knowledge graph of the codebase (symbols, calls, references, contains, imports, implements, extends). Use it to answer: $ARGUMENTS

## Reach for symgraph first — not grep

When the thing you're after is a **symbol** (function, method, class, struct, trait, enum, field) or a **relationship between symbols** (who calls it, what it references, what breaks if it changes), symgraph is the right tool and grep is the wrong one. Make symgraph your default first move and only fall back to text search when the rules below say to.

Why this is faster and cheaper, not just tidier:

- **Fewer tokens.** `symgraph-references` returns the exact resolved usage sites. Grep returns every textual hit — comments, strings, unrelated same-named symbols, vendored copies — and you pay tokens to read and filter the noise, then often pay again to open files for context.
- **Precision, not string-matching.** symgraph distinguishes a *definition* from a *call* from an *import*, resolves overloads/shadowing, and won't match `user` inside `username` or inside a docstring. Grep can't tell a real caller from a coincidental substring.
- **Relationships grep can't express.** "Who calls this?", "what's the call path from A to B?", "what breaks if I change this?", "which structs implement this trait?" are single symgraph calls and multi-round grep archaeology.

If you catch yourself about to grep for a function/type/method name, or about to read a whole file to find one definition, stop and use the mapping below instead.

### grep/find habit → symgraph tool

| If you'd reach for… | Use instead |
|---|---|
| `grep -r "fn foo"` / "where is `foo` defined?" | `symgraph-search` → `symgraph-definition` |
| `grep -rn "foo("` to find callers | `symgraph-callers` |
| `grep -rn "foo"` to find every usage | `symgraph-references` (resolved: calls + imports + type uses) |
| reading a file top-to-bottom to see one symbol's body | `symgraph-definition` |
| reading a file to list what's in it | `symgraph-file` |
| grepping for a method to see what it touches | `symgraph-callees` |
| grepping a class name to find subclasses/impls | `symgraph-implementations` |
| grepping an interface/enum to find match/dispatch sites | `symgraph-dispatch-sites` |
| `git log -S` / `git blame` on a symbol | `symgraph-blame` |
| "which files change most / are riskiest?" | `symgraph-churn` |

### When grep/find/Read is still the right tool

symgraph indexes code symbols, so use **Grep/Glob/Read** for things that aren't symbols or relationships:

- Free-text inside strings, log messages, error text, TODO/FIXME comments.
- Config and data files (JSON/YAML/TOML/`.env`), docs, build files, generated output.
- Locating files by path/name pattern (`Glob`).
- Reading the surrounding lines (constants, imports, comment blocks) **after** symgraph has pointed you at the right symbol — see Strategy step 5.

## Tool cheat sheet

| Question | Tool |
|---|---|
| "Where is `X` defined?" / "find symbols matching name" | `symgraph-search` → `symgraph-definition` |
| "Show me the source of `X`" | `symgraph-definition` |
| "Who calls `X`?" | `symgraph-callers` |
| "What does `X` call?" | `symgraph-callees` |
| "All usages of `X`" (calls + non-call references) | `symgraph-references` |
| "How does control/data flow from `A` to `B`?" | `symgraph-path` |
| "If I change `X`, what breaks?" | `symgraph-impact` |
| "What would changing lines N–M of `file.rs` affect?" | `symgraph-diff-impact` |
| "What symbols live in `file.rs`?" | `symgraph-file` |
| "All implementations of trait/interface `T`" | `symgraph-implementations` |
| "Where is enum `E` matched/dispatched on?" | `symgraph-dispatch-sites` |
| "Class/module parent–child relationships" | `symgraph-hierarchy` |
| "Find dead code" | `symgraph-unused` |
| "Who last changed `X` and when?" | `symgraph-blame` |
| "Which files/areas are high-churn (bug-prone)?" | `symgraph-churn` |
| "Module dependencies, fan-in/out, cycles" | `symgraph-module-graph` |
| "Where are the worst coupling hotspots?" | `symgraph-coupling-score` |
| "Which structs are overgrown hubs / arch debt?" | `symgraph-god-struct` |
| "Build broad context for a task" | `symgraph-context` |
| "Detailed info on one symbol" | `symgraph-node` |

## Refactoring playbooks

Before editing a symbol, map its blast radius with symgraph rather than grepping for occurrences — you'll get the complete, resolved set and miss nothing.

- **Rename / change a signature:** `symgraph-references` (and `symgraph-callers`) to enumerate every site that must change → `symgraph-impact` to gauge blast radius → edit. Re-run `symgraph-reindex` after, then `symgraph-references` again to confirm nothing dangling.
- **Delete code safely:** `symgraph-unused` to confirm zero references, or `symgraph-references` on the specific symbol. Empty result ⇒ safe to remove.
- **Replace an enum match with polymorphism (or vice versa):** `symgraph-dispatch-sites` to find every match site so the refactor is exhaustive.
- **Swap or extract a module:** `symgraph-module-graph` for the dependency edges and cycles, `symgraph-coupling-score` / `symgraph-god-struct` to spot what's tangled, `symgraph-impact` on the boundary symbols before cutting.
- **Decide where to harden:** cross-reference `symgraph-churn` (volatility) with `symgraph-impact` (coupling) — high-churn × high-impact symbols are the riskiest to touch.

Coupling/module tools rely on field, import, and dispatch edges, so **run `symgraph-reindex` after edits** before trusting them again.

## Strategy

1. **Start narrow.** For a specific question, `symgraph-search` → `symgraph-definition`. Reserve `symgraph-context` for open-ended "help me understand this area" tasks.
2. **Disambiguate first.** If `symgraph-search` returns several matches, pick the right one (from context or by asking) before pulling callers/callees/impact.
3. **Follow chains step by step** with `callers`/`callees`; for "how is A connected to B" use `symgraph-path` directly instead of guessing.
4. **Always show source.** When explaining behavior, fetch the real code with `symgraph-definition` and quote the relevant lines — don't paraphrase from names.
5. **Combine with Read for surrounding context only.** symgraph returns symbol-scoped excerpts; if you need nearby constants, imports, or comments, follow up with `Read` on the file/line symgraph gave you — don't re-discover the location by grepping.
6. **For impact analysis,** use `symgraph-diff-impact` when you have a line range, `symgraph-impact` when you have a symbol name.

## Index hygiene

- A project must be indexed before symgraph can answer. The plugin's SessionStart hook kicks off a first-time index via `bx grahambrooks/symgraph index`.
- If `symgraph-status` reports 0 nodes, or `symgraph-search` returns nothing for symbols you know exist, the index is missing/unfinished — tell the user to run `bx grahambrooks/symgraph index` in the project root (or check `.symgraph-index.log` for progress).
- After edits, run `symgraph-reindex` (incremental, fast). This is required before re-trusting `references`, `impact`, and the coupling/module tools. Full re-index only when structure changed dramatically.
