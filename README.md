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

- [code-intelligence](plugins/code-intelligence/README.md): Semantic code intelligence via the [symgraph](https://github.com/grahambrooks/symgraph) MCP server, launched on-demand by [bx](https://github.com/grahambrooks/bx). Ships the `explore-code` skill and a SessionStart hook that auto-indexes new projects.

## Development

Run the linter to validate plugin structure:

```bash
make lint
```

Update plugin documentation and website:

```bash
make update
```
