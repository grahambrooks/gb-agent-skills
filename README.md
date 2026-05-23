# agent-skills

Claude Code Plugins by Graham Brooks

## Installation

Add the marketplace to Claude Code:

```
/plugin marketplace add grahambrooks/agent-skills
```

Install a specific plugin:

```
/plugin install code-intelligence@agent-skills
```

## Plugins

- **code-intelligence**: Semantic code intelligence via the [symgraph](https://github.com/grahambrooks/symgraph) MCP server, launched on-demand by [bx](https://github.com/grahambrooks/bx). Ships the `explore-code` skill and a SessionStart hook that auto-indexes new projects.

## Development

Run the linter to validate plugin structure:

```bash
make lint
```

Update plugin documentation and website:

```bash
make update
```

## Documentation

Visit the [documentation site](https://grahambrooks.github.io/agent-skills) for more information.

## License

MIT
