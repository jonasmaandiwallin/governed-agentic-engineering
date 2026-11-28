#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Jonas Maandi Wallin
# Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
# the full text is in LICENSE at the repository root.
#
# GAE starter — PreToolUse hook for Write and Edit.
# Allows a write only under the path prefixes given as arguments, relative to the repository root.
# Requires bash and jq. Exit 2 blocks the tool call and shows stderr to the agent.
#
# Usage in an agent's frontmatter. Both guards keep a hook that cannot run from letting the write
# through: the platform blocks only on exit 2, and a missing file, a missing bash, a crash or a
# timeout otherwise counts as a non-blocking error. "onFailure: block" makes any failure block
# (Claude Code v2.1.295 or later); "|| exit 2" turns a failure to start into a block on older ones.
#   - type: command
#     command: "bash \"${CLAUDE_PROJECT_DIR}\"/<path>/write-only-under.sh contracts/ reports/audits/ || exit 2"
#     onFailure: block
#
# Holds every write only for an agent without Bash: a shell can write around it.
# Fails closed: no prefix, no path, no jq, no repository at the session's directory, a path with a
# ".." segment, or any unexpected error blocks the write.
# A prefix is a folder: "contracts" and "contracts/" both allow contracts/x and never contracts-old/x.
# The repository root is the one holding the session's working directory, so a session in a
# git worktree is held to that worktree, and a path into another working copy is blocked.
# On a case-insensitive filesystem (the default on macOS) a path and a prefix that differ only in
# ASCII letter case name the same folder and are compared without case; on any other filesystem
# they are compared exactly. A symbolic link inside an allowed folder that points out of it is not
# detected: the hook reads the path it is given, not where the path leads.
# The cases it is tested against stand in write-only-under.test.sh beside it.
# Portable: bash and jq only, no realpath (macOS has no realpath -m).

set -u

# Any exit other than 0 (allowed) and 2 (blocked) becomes a block.
trap 'rc=$?; if [ "$rc" -ne 0 ] && [ "$rc" -ne 2 ]; then echo "write-only-under: unexpected error ($rc) — write blocked" >&2; exit 2; fi' EXIT

block() { echo "write-only-under: $1 — write blocked" >&2; exit 2; }

[ "$#" -eq 0 ] && block "no allowed prefix given"
command -v jq >/dev/null 2>&1 || block "jq not found"

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || block "tool input is not JSON"
[ -z "$FILE" ] && block "no file_path in the tool call"
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty' 2>/dev/null) || block "tool input is not JSON"
[ -z "$CWD" ] && CWD=$(pwd)

ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null) || block "no repository at $CWD"
[ -z "$ROOT" ] && block "no repository at $CWD"

# A relative path is relative to the session's working directory.
case "$FILE" in
  /*) ;;
  *) FILE="$CWD/${FILE#./}" ;;
esac

# Refuse any ".." segment instead of resolving it.
case "/$FILE/" in
  */../*) block "$FILE contains a .. segment" ;;
esac

# A case-insensitive filesystem finds the repository's .git under another letter case.
fold() { printf '%s' "$1" | LC_ALL=C tr 'A-Z' 'a-z'; }
NOCASE=0
UPPER_GIT="$ROOT/$(printf '.git' | LC_ALL=C tr 'a-z' 'A-Z')"
[ -e "$ROOT/.git" ] && [ "$ROOT/.git" -ef "$UPPER_GIT" ] && NOCASE=1
same() { if [ "$NOCASE" -eq 1 ]; then fold "$1"; else printf '%s' "$1"; fi; }

F=$(same "$FILE")
R=$(same "$ROOT")
case "$F" in
  "$R"/*) REL="${FILE:$((${#ROOT} + 1))}" ;;
  /*) block "$FILE is outside the repository at $ROOT" ;;
  *) block "$FILE is not an absolute path" ;;
esac

RELC=$(same "$REL")
for PREFIX in "$@"; do
  P="${PREFIX#./}"
  while [ "${P%/}" != "$P" ]; do P="${P%/}"; done
  [ -z "$P" ] && block "an empty prefix allows nothing"
  PC=$(same "$P")
  case "$RELC" in
    "$PC"/*) exit 0 ;;
  esac
done

block "$REL is outside the allowed paths ($*)"
