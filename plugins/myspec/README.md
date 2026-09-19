# myspec

Brings [myspec](https://github.com/grahambrooks/myspec) into Claude Code: the
spec-driven workflow's tools, and a **channel** that pushes what happens in
the repository into the session you already have open.

Without it, a commit made in another terminal, a gate that refused a mode
switch, or a change you just approved reach Claude only when you type them.
With it, they arrive as they happen:

```
<channel source="plugin:myspec:myspec" kinds="gate-failed" count="1">
build entry gates failed (gate-failed)
APR-001: approval missing for add-login
</channel>
```

## What you need

- **`myspec` on PATH.** The server is `myspec mcp`; install myspec first
  (`make install` from a checkout until there is a release).
- **A myspec repository.** Outside one the server still starts, exposes its
  status tool, and delivers nothing.
- **Claude Code channels**, which are a research preview: they need
  Anthropic authentication (not Bedrock, Vertex or Foundry), and Team or
  Enterprise organisations must enable them.

## Install

```sh
/plugin marketplace add grahambrooks/gb-agent-skills
/plugin install myspec@gb-agent-skills
```

The MCP server's tools (`myspec_status`, `myspec_report`, and the exit-gate
tool of the active lifecycle mode) work from that point on.

## Turn the channel on

A channel is opted into per session, never by installing the plugin:

```sh
claude --channels plugin:myspec@gb-agent-skills
```

During the research preview, `--channels` accepts only plugins on an
Anthropic-curated list, **or** on your organisation's list. Two ways round
that, in order of preference:

1. **Allowlist it for your organisation** (Team, Enterprise, or a Console
   org with managed settings), which makes the command above work as
   written:

   ```json
   {
     "channelsEnabled": true,
     "allowedChannelPlugins": [
       { "marketplace": "gb-agent-skills", "plugin": "myspec" }
     ]
   }
   ```

2. **Load it as a channel you are developing**, which asks you to confirm at
   startup:

   ```sh
   claude --dangerously-load-development-channels plugin:myspec@gb-agent-skills
   ```

`myspec claude` passes whichever of these the repository's `myspec.toml`
asks for, and says at startup whether events will arrive.

Look for the notice under the startup banner naming the channel. If it says
the plugin is not on the approved list, or that an admin must enable
channels, the channel is not registered and events stay queued.

## What arrives

The repository decides, under `[supervisor]` in its `myspec.toml`: which of
`commit`, `branch`, `merge`, `file-changed`, `gate-failed`, `mode`,
`change-approved` and `change-archived` are delivered, how long a burst is
gathered into one message, and how many messages a minute a session may
receive. Events queued while Claude is busy arrive together on its next
turn.

Events are produced by git hooks (`myspec event emit`, installed by the
profile's prek hooks), by myspec's own commands, and by the launcher's
working-tree watcher. They are read as news about the repository, not as
instructions from you.

## What it touches

The server reads and writes only inside the repository it is started in:
its queue and logs live in `.git/myspec/`. Every message it pushes is
recorded in `.git/myspec/mcp.log` and in the repository's decision log, so
what the agent was told, and when, can be audited — Claude Code does not
acknowledge channel messages, so this is the only record.
