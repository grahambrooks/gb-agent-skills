#!/usr/bin/env bash
# code-intelligence plugin — SessionStart hook
#
# 1. Verify `bx` is on PATH (required to launch the symgraph MCP server).
# 2. If the project has never been indexed, kick off a background index so
#    the first symgraph query returns useful results without blocking
#    session startup.

set -u

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"

if ! command -v bx >/dev/null 2>&1; then
  cat <<'EOF' >&2
[code-intelligence] `bx` not found on PATH.

bx is required to launch the symgraph MCP server without a manual install.
Install one of:

  brew install grahambrooks/bx/bx
  cargo install --git https://github.com/grahambrooks/bx

See https://github.com/grahambrooks/bx for details.
EOF
  exit 0
fi

if [ ! -d "${project_dir}/.symgraph" ]; then
  log_file="${project_dir}/.symgraph-index.log"
  echo "[code-intelligence] no .symgraph/ found — indexing in background (log: ${log_file})" >&2
  (
    cd "${project_dir}" || exit 0
    bx grahambrooks/symgraph index >"${log_file}" 2>&1
  ) &
  disown "$!" 2>/dev/null || true
fi

exit 0
