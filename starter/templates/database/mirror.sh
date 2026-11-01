#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Jonas Maandi Wallin
# Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
# the full text is in LICENSE at the repository root.
#
# GAE starter — builds the statement that mirrors the repository's governance directories to
# the system store (ADOPTION.md step 4; the tables and the function are in mirror.sql).
#
# Usage, from anywhere inside the repository:
#   bash mirror.sh <commit> <directory/>...
# for example
#   bash mirror.sh HEAD agents/ .claude/ governance/ contracts/ | psql "$SYSTEM_STORE_URL" -v ON_ERROR_STOP=1
#
# Reads every file under the directories at <commit> from git (git ls-tree, git show), never
# from the working tree, and writes one statement to standard output:
#   select gov.mirror_replace('<hash>', array[...]::text[], '<json>'::jsonb);
# where <hash> is <commit> resolved to its full 40-character hash, and the JSON holds each
# file's path, sha256 and bytes in base64. The function checks every sha256 against the bytes
# and writes nothing if one fails.
#
# Mirror by directory, never by a list of files. Give each directory relative to the
# repository root, without "./", and with a trailing "/". A directory that does not exist at
# <commit> contributes no file and is not an error, so one list serves every repository of
# the installation.
# Not mirrored, and named on standard error: a file whose bytes are not UTF-8 (an image, a
# PDF), a file that holds a NUL byte (the database cannot store it as text), a symbolic link
# and a submodule. Agents read text only, and one such file never stops the run.
#
# Exits non-zero, naming the cause and writing no statement, for a commit that does not
# resolve, a directory without a trailing "/", with a leading "./" or with a character
# outside [A-Za-z0-9_./-], a path outside that set (rename the file), or zero files.
#
# Run it at every merge to the default branch, for example as a CI job:
#   on: push to the default branch
#   steps: check out with full history; bash <path>/mirror.sh "$GITHUB_SHA" <directories> \
#          | psql "$SYSTEM_STORE_URL" -v ON_ERROR_STOP=1
# The job's database role has usage on the schema and execute on gov.mirror_replace, and
# nothing else.
#
# Tools: bash, git, base64, iconv, tr, cmp, and shasum or sha256sum.

set -euo pipefail
export LC_ALL=C

die() {
  printf 'mirror.sh: %s\n' "$*" >&2
  exit 1
}

[ "$#" -ge 2 ] || { printf 'usage: bash mirror.sh <commit> <directory/>...\n' >&2; exit 2; }
commit_arg=$1
shift

path_re='^[A-Za-z0-9_.][A-Za-z0-9_./-]*$'
for dir in "$@"; do
  [[ $dir == */ ]] || die "directory '$dir' has no trailing /"
  [[ $dir == ./* ]] && die "directory '$dir' starts with ./; give it relative to the repository root"
  [[ $dir =~ $path_re ]] || die "directory '$dir' holds a character outside [A-Za-z0-9_./-]"
  [[ $dir =~ (^|/)\.\.(/|$) ]] && die "directory '$dir' holds a .. segment"
done

top=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository"
cd "$top"

hash=$(git rev-parse --verify --quiet "${commit_arg}^{commit}") || die "no commit named '$commit_arg'"
[[ $hash =~ ^[0-9a-f]{40}$ ]] || die "commit '$commit_arg' does not resolve to a 40-character hash"

if command -v shasum >/dev/null 2>&1; then
  sha256_stdin() { shasum -a 256 | awk '{ print $1 }'; }
elif command -v sha256sum >/dev/null 2>&1; then
  sha256_stdin() { sha256sum | awk '{ print $1 }'; }
else
  die "neither shasum nor sha256sum is available"
fi
command -v iconv >/dev/null 2>&1 || die "iconv is not available"
command -v cmp >/dev/null 2>&1 || die "cmp is not available"

work=$(mktemp -d "${TMPDIR:-/tmp}/mirror.XXXXXX")
trap 'rm -rf "$work"' EXIT

git ls-tree -r -z "$hash" -- "$@" > "$work/entries" || die "git ls-tree failed at $hash"

json="$work/json"
printf '[' > "$json"
count=0
while IFS= read -r -d '' entry; do
  # Each entry is "<mode> <type> <object>" and a tab, then the path.
  meta=${entry%%$'\t'*}
  path=${entry#*$'\t'}
  mode=${meta%% *}
  case "$mode" in
    120000) printf 'mirror.sh: %s: symbolic link, not mirrored\n' "$path" >&2; continue ;;
    160000) printf 'mirror.sh: %s: submodule, not mirrored\n' "$path" >&2; continue ;;
  esac
  [[ $path =~ $path_re ]] || die "$path: the path holds a character outside [A-Za-z0-9_./-]; rename the file"
  git show "$hash:$path" > "$work/blob" || die "$path: could not read the file at $hash"
  if ! iconv -f UTF-8 -t UTF-8 < "$work/blob" > /dev/null 2>&1; then
    printf 'mirror.sh: %s: not UTF-8, not mirrored\n' "$path" >&2
    continue
  fi
  if ! tr -d '\000' < "$work/blob" | cmp -s - "$work/blob"; then
    printf 'mirror.sh: %s: holds a NUL byte, not mirrored\n' "$path" >&2
    continue
  fi
  sha=$(sha256_stdin < "$work/blob")
  [[ $sha =~ ^[0-9a-f]{64}$ ]] || die "$path: could not hash the file"
  [ "$count" -eq 0 ] || printf ',' >> "$json"
  {
    printf '{"path":"%s","sha256":"%s","body_b64":"' "$path" "$sha"
    base64 < "$work/blob" | tr -d '\n\r'
    printf '"}'
  } >> "$json"
  count=$((count + 1))
done < "$work/entries"
printf ']' >> "$json"

[ "$count" -gt 0 ] || die "no file under $* at $hash; no statement written"

dirs=""
for dir in "$@"; do
  [ -z "$dirs" ] || dirs="$dirs,"
  dirs="$dirs'$dir'"
done

printf "select gov.mirror_replace('%s', array[%s]::text[], '" "$hash" "$dirs"
cat "$json"
printf "'::jsonb);\n"
