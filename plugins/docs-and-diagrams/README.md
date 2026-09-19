# docs-and-diagrams

Write documentation and diagrams as text that Graham's renderers turn into finished documents.

## Why these tools together

They do one job: turn text sources into documents and diagrams. Each tool is small, and none is worth switching on
or off by itself, so they share a plugin that myspec enables for documentation work.

## What you get today

- **Skill `asciidoc-author`** from [adoc](https://github.com/grahambrooks/adoc) — the AsciiDoc subset `adoc`
  supports, its pitfalls, and how to check a document with its JSON diagnostics. Needs `adoc` on `PATH`, or
  run it without installing: `bx grahambrooks/adoc -- <args>`.

## Coming as their releases publish binaries

- **puml** (PlantUML without Java) — its release workflow currently fails, so there is no binary to launch.

**draws** (draw.io, MCP server), **mmd** (Mermaid to SVG) and **md2pdf** (Markdown to PDF) are private, so they
belong in the private marketplace's counterpart plugin, not here, once they publish releases.

## Install

```
/plugin install docs-and-diagrams@gb-agent-skills
```

## Where the skills come from

The skills are synced from each tool's repository at a pinned release tag (see `tools.toml`); do not edit them here.
