# architecture

Design an architecture and keep the code inside it, with [forge](https://github.com/grahambrooks/forge) and
[tropism](https://github.com/grahambrooks/tropism).

## Why these two together

Both work on the same artefact, the intended architecture. forge describes it as a model (C4, processes,
deployment); tropism enforces its dependency rules (module boundaries, layering, cycles). myspec gates on both
(forge lint, MOD-001/002), so an agent fixing a refused gate needs both at once. Enable this plugin in myspec's
`specify` and `build` modes.

## What you get

- **MCP server `forge`** — `bx grahambrooks/forge@<tag> -- mcp`: analyze a repository into a model, query and
  search it, render SVG, and lint it (`forge_check`).
- **forge skills** — `model-repository`, `forge-dsl`, `architecture-review`.
- **tropism skills** — `tropism-in-the-loop`, `authoring-architecture-rules`, `reporting-tropism-issues`. These
  drive the `tropism` CLI, which must be on `PATH` (see tropism's README for install options). tropism's MCP
  server ships in its release but is not implemented yet; it joins when it is.
- **SessionStart hook** — warns if `bx` is missing.

## Install

```
/plugin install architecture@gb-agent-skills
```

## Where the skills come from

The skills are synced from each tool's repository at a pinned release tag (see `tools.toml`); do not edit them
here. Change them upstream, bump the tag, and run `make sync-tools`.
