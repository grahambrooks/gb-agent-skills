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

# Is the project already indexed? symgraph's default storage is the git dir
# (<git-common-dir>/symgraph/index.db), not the working tree, so probing only
# `.symgraph/` would miss it and re-index on every session. Check both real
# locations. (A non-git project may use an OS cache dir we don't probe here; it
# falls through to a re-index, which is harmless.)
is_indexed() {
  [ -f "${project_dir}/.symgraph/index.db" ] && return 0
  local git_common
  git_common=$(cd "${project_dir}" 2>/dev/null && git rev-parse --git-common-dir 2>/dev/null) || return 1
  [ -n "${git_common}" ] || return 1
  case "${git_common}" in
    /*) : ;;                                          # already absolute
    *) git_common="${project_dir}/${git_common}" ;;   # relative to project_dir
  esac
  [ -f "${git_common}/symgraph/index.db" ]
}

if ! is_indexed; then
  # `symgraph index` writes its own progress log (index.log) beside the index —
  # in the git dir / cache, never the working tree. Capture the launcher's
  # stdout/stderr to a temp file (for crash diagnostics) so nothing lands in the
  # project root. Run `symgraph where` to locate the index and its index.log.
  log_file="${TMPDIR:-/tmp}/symgraph-index.log"
  echo "[code-intelligence] no index found — indexing in background (launcher log: ${log_file}; progress: <index-dir>/index.log)" >&2
  (
    cd "${project_dir}" || exit 0
    bx grahambrooks/symgraph index >"${log_file}" 2>&1
  ) &
  disown "$!" 2>/dev/null || true
fi

exit 0
