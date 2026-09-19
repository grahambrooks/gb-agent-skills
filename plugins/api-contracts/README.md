# api-contracts

Catch a breaking API change while it is being drafted, not after it is committed, with
[brake](https://github.com/grahambrooks/brake). Covers OpenAPI, protobuf and GraphQL from one ruleset.

## Why a plugin of its own

Only repositories that publish API contracts need it, so a repository opts in through its `myspec.toml`
`[toolchain].plugins` rather than paying the context cost everywhere. It belongs in myspec's `build` mode, and its
checks are the same ones brake's commit-time hook and myspec's API gate run.

## What you get

- **MCP server `brake`** — `bx grahambrooks/brake@<tag> -- mcp`: check a proposed contract change against the
  baseline before writing it. Never makes network requests or runs the service.
- **Skills** — `api-compatibility` (check before editing), `brake-triage` (fix a blocking finding),
  `brake-consumer-impact` (who uses this field), `brake-adopt` (set brake up in a repository).
- **SessionStart hook** — warns if `bx` is missing.

## Install

```
/plugin install api-contracts@gb-agent-skills
```

## Where the skills come from

The skills are synced from brake's repository at a pinned release tag (see `tools.toml`); do not edit them here.
