#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Jonas Maandi Wallin
# Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
# the full text is in LICENSE at the repository root.
#
# GAE starter — the cases write-only-under.sh is held to. Run: bash write-only-under.test.sh
# Needs bash, git and jq; works in a temporary folder and leaves the repository alone.
# Exit 0 when every case holds. On a case-sensitive filesystem the last cases simulate a
# case-insensitive one with a link from .GIT to .git; on a case-insensitive one they run as they are.
H=${H:-"$(cd "$(dirname "$0")" && pwd)/write-only-under.sh"}
T=$(mktemp -d); T=$(cd "$T" && pwd -P); cd "$T"
git init -q repo && cd repo && git config user.email t@t && git config user.name t && mkdir -p contracts sub && echo a > contracts/a && git add -A && git commit -qm i && git worktree add -q ../wt 2>/dev/null; cd "$T"
R="$T/repo"; W="$T/wt"
NOCASE_FS=0; [ "$R/.git" -ef "$R/.GIT" ] && NOCASE_FS=1
pass=0; fail=0
run() { # id expected cwd file prefixes...
  id=$1; exp=$2; cwd=$3; file=$4; shift 4
  out=$(jq -nc --arg f "$file" --arg c "$cwd" '{cwd:$c, tool_input:{file_path:$f}}' | (cd "$cwd" 2>/dev/null || cd /; bash "$H" "$@") 2>&1); rc=$?
  if [ "$rc" = "$exp" ]; then pass=$((pass+1)); echo "ok   $id ($rc)"; else fail=$((fail+1)); echo "FAIL $id: got $rc want $exp — $out"; fi
}
run allowed-slash        0 "$R" "$R/contracts/x.md" contracts/
run allowed-noslash      0 "$R" "$R/contracts/x.md" contracts
run allowed-dotslash     0 "$R" "$R/contracts/x.md" ./contracts//
run sibling-noslash      2 "$R" "$R/contracts-old/x.md" contracts
run sibling-slash        2 "$R" "$R/contracts-old/x.md" contracts/
run second-prefix        0 "$R" "$R/reports/audits/a.md" contracts/ reports/audits
run outside              2 "$R" "/etc/passwd" contracts/
run dotdot               2 "$R" "$R/contracts/../x.md" contracts/
run no-prefix            2 "$R" "$R/contracts/x.md"
run empty-prefix         2 "$R" "$R/contracts/x.md" /
run glob-prefix          2 "$R" "$R/contracts/x.md" 'contr*'
run cwd-not-repo         2 "/tmp" "$R/contracts/x.md" contracts/
run worktree-own         0 "$W" "$W/contracts/x.md" contracts/
run worktree-to-main     2 "$W" "$R/contracts/x.md" contracts/
run main-to-worktree     2 "$R" "$W/contracts/x.md" contracts/
run relative-from-sub    0 "$R/contracts" "x.md" contracts/
run relative-from-root   2 "$R" "x.md" contracts/
if [ "$NOCASE_FS" -eq 0 ]; then
  run case-sensitive-fs  2 "$R" "$R/Contracts/x.md" contracts/
fi
# no file_path / not JSON / no jq
o=$(echo '{"tool_input":{}}' | (cd "$R"; bash "$H" contracts/) 2>&1); [ $? = 2 ] && { pass=$((pass+1)); echo "ok   no-file-path"; } || { fail=$((fail+1)); echo "FAIL no-file-path $o"; }
o=$(echo 'not json' | (cd "$R"; bash "$H" contracts/) 2>&1); [ $? = 2 ] && { pass=$((pass+1)); echo "ok   not-json"; } || { fail=$((fail+1)); echo "FAIL not-json $o"; }
mkdir -p "$T/nojq"; for c in git cat tr; do ln -sf "$(command -v $c)" "$T/nojq/$c"; done
o=$(echo '{}' | (cd "$R"; PATH="$T/nojq" "$(command -v bash)" "$H" contracts/) 2>&1); [ $? = 2 ] && { pass=$((pass+1)); echo "ok   no-jq"; } || { fail=$((fail+1)); echo "FAIL no-jq $o"; }
# unexpected error becomes a block (test copy with an unbound variable after the trap)
awk '/^block\(\) \{/ { print ": \"$UNBOUND_FOR_TEST\"" } { print }' "$H" > "$T/broken.sh"
o=$(echo '{}' | bash "$T/broken.sh" contracts/ 2>&1); rc=$?; [ $rc = 2 ] && { pass=$((pass+1)); echo "ok   unexpected-error ($rc)"; } || { fail=$((fail+1)); echo "FAIL unexpected-error $rc $o"; }
# the command form: a hook that cannot start blocks; one that allows still allows
sh -c 'bash /nonexistent/write-only-under.sh contracts/ || exit 2' </dev/null 2>/dev/null; rc=$?; [ $rc = 2 ] && { pass=$((pass+1)); echo "ok   form-missing-file ($rc)"; } || { fail=$((fail+1)); echo "FAIL form-missing-file $rc"; }
jq -nc --arg f "$R/contracts/x.md" --arg c "$R" '{cwd:$c, tool_input:{file_path:$f}}' | sh -c "bash '$H' contracts/ || exit 2"; rc=$?; [ $rc = 0 ] && { pass=$((pass+1)); echo "ok   form-allows ($rc)"; } || { fail=$((fail+1)); echo "FAIL form-allows $rc"; }
jq -nc --arg f "$R/x.md" --arg c "$R" '{cwd:$c, tool_input:{file_path:$f}}' | sh -c "bash '$H' contracts/ || exit 2" 2>/dev/null; rc=$?; [ $rc = 2 ] && { pass=$((pass+1)); echo "ok   form-blocks ($rc)"; } || { fail=$((fail+1)); echo "FAIL form-blocks $rc"; }
# simulated case-insensitive filesystem: .GIT is the same file as .git
[ "$NOCASE_FS" -eq 0 ] && ln -s .git "$R/.GIT"
run nocase-upper-folder  0 "$R" "$R/Contracts/x.md" contracts/
run nocase-upper-root    0 "$R" "$(echo "$R" | tr a-z A-Z)/contracts/x.md" contracts/
run nocase-sibling       2 "$R" "$R/CONTRACTS-old/x.md" contracts
run nocase-non-ascii     2 "$R" "$R/kontrakt-Å/x.md" kontrakt-å/
run nocase-outside       2 "$R" "/ETC/passwd" contracts/
[ "$NOCASE_FS" -eq 0 ] && rm "$R/.GIT"
echo "pass=$pass fail=$fail"
rm -rf "$T"
[ "$fail" -eq 0 ]
