# refactoring

Mechanical, repo-wide code changes with [colab](https://github.com/grahambrooks/colab): write a
small `.codemod` script, preview the blast radius, and apply it, instead of editing files one at a
time.

## Why a plugin of its own

It edits code, so myspec enables it in `build` mode and leaves it off in `specify`, where no edits
should happen. It is separate from `code-intelligence`, which only reads.

## What you get

- **Skill `colab-codemod`**: when a change is structural and repo-wide (an import path, a
  dependency name, a symbol, a package, a call site), how to write the script, check what it
  touches, and apply it safely.
- The skill drives the `colab` CLI: have it on `PATH`, or run it without installing as
  `bx grahambrooks/colab -- <args>`.

## Not yet included

- **colab's MCP server** (`colab mcp`) frames messages with LSP-style `Content-Length` headers.
  MCP's stdio transport is newline-delimited JSON, so Claude Code cannot talk to it; it joins once
  that is fixed.
- **refactor-dsl** has no skill or MCP server yet.

## Install

```
/plugin install refactoring@gb-agent-skills
```

## Where the skills come from

Synced from colab's repository at a pinned release tag (see `tools.toml`); do not edit them here.
