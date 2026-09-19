# gb-agent-skills

Claude Code Plugins by Graham Brooks

## Prerequisites

These skills use [bx](https://github.com/grahambrooks/bx) to launch MCP servers on-demand. Please install `bx` to use these skills. bx manages the download and execution of MCP tools referenced in the mcp.json files in the plugins.

## Installation

Add the marketplace to Claude Code:

```
/plugin marketplace add grahambrooks/gb-agent-skills
```

Install a specific plugin:

```
/plugin install code-intelligence@gb-agent-skills
```

## Plugins

| Plugin | Tools | Use it for |
|---|---|---|
| [code-intelligence](plugins/code-intelligence/README.md) | [symgraph](https://github.com/grahambrooks/symgraph) (MCP) | Navigating code: symbols, callers, impact, coupling. Ships `explore-code` and a SessionStart hook that indexes new projects. |
| [architecture](plugins/architecture/README.md) | [forge](https://github.com/grahambrooks/forge) (MCP), [tropism](https://github.com/grahambrooks/tropism) | Modelling the intended architecture and keeping dependencies inside it. |
| [api-contracts](plugins/api-contracts/README.md) | [brake](https://github.com/grahambrooks/brake) (MCP) | Catching breaking OpenAPI, protobuf and GraphQL changes while drafting them. |
| [refactoring](plugins/refactoring/README.md) | [colab](https://github.com/grahambrooks/colab) | Mechanical, repo-wide code changes with AST-aware codemods (build mode). |
| [docs-and-diagrams](plugins/docs-and-diagrams/README.md) | [adoc](https://github.com/grahambrooks/adoc) | Writing documentation that renders with Graham's text-to-document tools. |
| [myspec](plugins/myspec/README.md) | [myspec](https://github.com/grahambrooks/myspec) (MCP, channel) | Repository events pushed into the running session. |

## How tools are grouped

The main consumer is [myspec](https://github.com/grahambrooks/myspec), which enables plugins per repository
(`[toolchain].plugins`) and switches them on and off per lifecycle mode (`[modes.<mode>.plugins]`). A plugin is the
unit it can switch, so the groups follow from that:

1. **One plugin per switchable job.** Tools that are always wanted together share a plugin; tools wanted in
   different modes are split, so `specify` can leave editing tools off.
2. **Relevance is per repository.** A tool that only matters in some repositories, such as API contracts, gets its
   own plugin, so a repository opts in exactly.
3. **Context costs.** Every MCP server's tool list is loaded into the session, so a heavy server is not bundled with
   tools the mode does not need.
4. **Same artefact, same plugin.** Tools that read or write one artefact belong together, such as the forge model
   and the tropism rules that enforce it.
5. **Names are an interface.** MCP tools are named `mcp__plugin_<plugin>_<server>__*`, and those names end up in
   skills' `allowed-tools` and in myspec allowlists. Renaming a plugin breaks them.

Private tools are published from a separate, private marketplace rather than listed here.

## Development

Run the linter to validate plugin structure:

```bash
make lint
```

Sync skills from the tool repositories at the tags pinned in `tools.toml`, then update plugin documentation and
website:

```bash
make update        # runs make sync-tools first
```

Skills under a synced plugin are copies. Each tool's repository owns its skills; change them there, bump the tag in
`tools.toml`, and run `make sync-tools`. `make lint` fails if a synced file was edited here or the tags changed
without a resync.
