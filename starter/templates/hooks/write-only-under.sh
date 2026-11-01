#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Jonas Maandi Wallin
# Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
# the full text is in LICENSE at the repository root.
#
# GAE starter — PreToolUse hook for Write and Edit.
# Allows a write only under the path prefixes given as arguments, relative to the repository root.
# Usage in an agent's frontmatter:  command: "<path>/write-only-under.sh contracts/ reports/audits/"
# Requires jq. Exit 2 blocks the tool call and shows stderr to the agent.
#
# Holds every write only for an agent without Bash: a shell can write around it.
# Give each prefix with a trailing "/" (contracts/, not contracts): the match is on the string.
# Fails closed: no prefix, no path, no jq, or a path with a ".." segment blocks the write.
# Portable: bash and jq only, no realpath (macOS has no realpath -m).

set -u

block() { echo "write-only-under: $1 — write blocked" >&2; exit 2; }

[ "$#" -eq 0 ] && block "no allowed prefix given"
command -v jq >/dev/null 2>&1 || block "jq not found"

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || block "tool input is not JSON"
[ -z "$FILE" ] && block "no file_path in the tool call"

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Refuse any ".." segment instead of resolving it.
case "/$FILE/" in
  */../*) block "$FILE contains a .. segment" ;;
esac

case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  /*) block "$FILE is outside the repository" ;;
  *) REL="${FILE#./}" ;;
esac

for PREFIX in "$@"; do
  case "$REL" in
    "$PREFIX"*) exit 0 ;;
  esac
done

block "$REL is outside the allowed paths ($*)"
