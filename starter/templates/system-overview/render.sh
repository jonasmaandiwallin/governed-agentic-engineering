#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Jonas Maandi Wallin
# Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
# the full text is in LICENSE at the repository root.
#
# GAE starter — renders the system overview for the repository (ADOPTION.md step 8).
#
#   bash render.sh <template.html> <output.html> [--deny <file>]
#
# Reads gov.system_overview through psql, as the read connection's role (set PGHOST, PGUSER,
# PGDATABASE and the rest in the environment), and writes <output.html>: the template with
# the JSON document in its data element. The page draws itself from that document; nothing
# else is filled in, and no layout is written here.
#
# --deny <file>  a file with one name per line that the repository copy must not carry: the
#                engagements', clients' and stores' names (ADOPTION.md step 5, One store per
#                data owner). Keep the file outside the repository. Each line is a name as a
#                person writes it; whitespace around it is ignored, and so are blank lines.
#                The render stops, writing nothing, when any text value of the document
#                contains a name in any letter case. The comparison is made by the database,
#                on the document's decoded text values (not its JSON encoding, and not its
#                keys), after Unicode normalization (NFC) and case folding with the ICU root
#                collation, so it does not depend on this shell's locale. It needs a UTF-8
#                database with ICU collations; without them the render stops, writing nothing.
#                Folding follows the ICU root rules, not a language's: an ASCII i is not the
#                dotted İ, a ligature folds to its letters, and every string value counts,
#                status words and codes included, so a very short line can stop the render.
#
# Exits non-zero, writing nothing, when the view cannot be read, gives no row, more than one or a document
# whose top-level format is not the number 1, the template has no data element, the deny file
# cannot be read, or a denied name is found.
set -euo pipefail

usage() { echo "usage: bash render.sh <template.html> <output.html> [--deny <file>]" >&2; exit 2; }
[ $# -eq 2 ] || [ $# -eq 4 ] || usage
template=$1; output=$2; deny=
if [ $# -eq 4 ]; then [ "$3" = "--deny" ] || usage; deny=$4; fi
[ -f "$template" ] || { echo "render.sh: no template $template" >&2; exit 1; }
[ -z "$deny" ] || [ -f "$deny" ] || { echo "render.sh: no deny file $deny" >&2; exit 1; }

marker='<script id="overview-data" type="application/json">null</script>'
[ "$(grep -oF "$marker" "$template" | wc -l | tr -d ' ')" = 1 ] \
  || { echo "render.sh: the template must hold the data element exactly once" >&2; exit 1; }

names=
if [ -n "$deny" ]; then
  names=$(cat -- "$deny") || { echo "render.sh: cannot read the deny file $deny" >&2; exit 1; }
fi

# One read of the view gives the document, whether it is format 1, and the deny lines it
# carries, so all three come from the same document. The separator, the record separator
# character, never occurs in jsonb's text form: JSON writes control characters in strings
# as escapes. A view of other than one row gives the unit separator alone. With no deny file,
# the query does not touch the ICU collation.
if [ -n "$deny" ]; then
  hits_sql=$(cat <<'SQL'
(select string_agg(n.name, E'\n' order by n.ord)
   from (select l.ord, regexp_replace(l.line, '^[[:space:]]+|[[:space:]]+$', '', 'g') as name
         from regexp_split_to_table(:'names', E'\n') with ordinality as l(line, ord)) as n
  where n.name <> ''
    and exists (select 1 from jsonb_path_query(o.overview, 'strict $.**') as v
                where jsonb_typeof(v) = 'string'
                  and strpos(lower(upper(normalize(v #>> '{}', NFC) collate "und-x-icu")),
                             lower(upper(normalize(n.name, NFC) collate "und-x-icu"))) > 0))
SQL
)
else
  hits_sql="null::text"
fi

out=$(PGCLIENTENCODING=UTF8 psql -X -v ON_ERROR_STOP=1 -At -v names="$names" -f - <<SQL
with r as (
  select o.overview::text || E'\x1e'
         || case when (o.overview -> 'format') = '1'::jsonb then '1' else '0' end
         || E'\x1e' || coalesce($hits_sql, '') as line
  from gov.system_overview as o
)
select case when (select count(*) from r) = 1 then (select line from r) else E'\x1f' end;
SQL
) || { echo "render.sh: the database refused the read or the deny comparison (psql's error is above)" >&2; exit 1; }

[ "$out" != $'\x1f' ] || { echo "render.sh: gov.system_overview gave no row or more than one" >&2; exit 1; }
json=${out%%$'\x1e'*}
rest=${out#*$'\x1e'}
format_ok=${rest%%$'\x1e'*}
hits=${rest#*$'\x1e'}
[ "$format_ok" = 1 ] || { echo "render.sh: the document is not format 1" >&2; exit 1; }
if [ -n "$hits" ]; then
  while IFS= read -r name; do
    echo "render.sh: a denied name is in the document (from $deny: $name)" >&2
  done <<< "$hits"
  exit 1
fi

# In JSON, < appears only inside strings, where its escape (a backslash, u003c) means the
# same character; so the document can never close the script element it sits in.
esc=$(printf '\134u003c')
safe=${json//</"$esc"}

tmp=$(mktemp "${output}.XXXXXX")
trap 'rm -f "$tmp"' EXIT
OVERVIEW_JSON=$safe MARKER=$marker awk '
  index($0, ENVIRON["MARKER"]) {
    i = index($0, ENVIRON["MARKER"])
    printf "%s<script id=\"overview-data\" type=\"application/json\">%s</script>%s\n",
      substr($0, 1, i - 1), ENVIRON["OVERVIEW_JSON"], substr($0, i + length(ENVIRON["MARKER"]))
    next
  }
  { print }' "$template" > "$tmp"
mv "$tmp" "$output"
trap - EXIT
echo "render.sh: wrote $output"
