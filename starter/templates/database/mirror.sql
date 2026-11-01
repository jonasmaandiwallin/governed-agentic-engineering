-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Jonas Maandi Wallin
-- Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
-- the full text is in LICENSE at the repository root.
--
-- GAE starter — the mirror of the repository's governance directories in the system store,
-- for PostgreSQL 14 or later (ADOPTION.md step 4, "Profile A reads from a mirror, never from a
-- repository sync").
--
-- At every merge, a job runs mirror.sh on the merged commit and passes its statement to the
-- system store. The statement replaces the mirrored file set with the files under the given
-- directories at that commit, whole, in one transaction. Profile A agents read governance
-- files only from here; a file missing here stops the agent.
--
-- Shape:
--   gov.mirror_files     the current file set: one row per path, with its bytes as text, its
--                        sha256 and the commit it was read at.
--   gov.mirror_runs      append-only: one row per mirror run, with the commit, the
--                        directories, the number of files and the time.
--   gov.mirror_status    view: the latest run. The core compares its commit with the latest
--                        merge in the version registry and writes `Mirror: current` or
--                        `Mirror: behind (<commit>)` in its start receipt.
--   gov.mirror_replace   the one write path. It checks every file's sha256 against its bytes,
--                        and refuses the run, writing nothing, on any mismatch.
--
-- Mirror by directory, never by a list of files, so that a new governance file comes with it.
-- The directories are bound in the instance appendix (§ Languages and configuration, Mirror).

create schema if not exists gov;

create table gov.mirror_files (
  path        text        primary key,
  body        text        not null,
  sha256      text        not null,
  commit_hash text        not null,
  mirrored_at timestamptz not null default now(),
  constraint mirror_files_path_format
    check (path ~ '^[A-Za-z0-9_.][A-Za-z0-9_./-]*$' and path !~ '(^|/)\.\.(/|$)' and path !~ '/$'),
  constraint mirror_files_sha256_format check (sha256 ~ '^[0-9a-f]{64}$'),
  constraint mirror_files_commit_format check (commit_hash ~ '^[0-9a-f]{40}$')
);

create table gov.mirror_runs (
  id          bigint generated always as identity primary key,
  commit_hash text        not null,
  directories text[]      not null,
  file_count  integer     not null,
  mirrored_at timestamptz not null default now(),
  constraint mirror_runs_commit_format check (commit_hash ~ '^[0-9a-f]{40}$'),
  constraint mirror_runs_file_count check (file_count > 0)
);

-- The run log is append-only: the trigger refuses update, delete and truncate for every role
-- except the table's owner, who can disable it, and a superuser, who can skip it. Run this
-- migration as the owner role the appendix binds, which no agent and no connector runs as.
create function gov.mirror_runs_append_only()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  raise exception 'mirror_runs is append-only: % is not allowed', tg_op
    using errcode = 'insufficient_privilege';
end
$$;

create trigger mirror_runs_append_only
  before update or delete or truncate on gov.mirror_runs
  for each statement execute function gov.mirror_runs_append_only();

create view gov.mirror_status as
  select r.commit_hash, r.directories, r.file_count, r.mirrored_at
  from gov.mirror_runs as r
  order by r.id desc
  limit 1;

-- Replaces the mirrored file set with p_files, read at p_commit under p_directories, and
-- returns the number of files. p_files is a JSON array of objects
--   {"path": ..., "sha256": ..., "body_b64": ...}
-- as mirror.sh writes it. Raises, writing nothing, for a commit that is not 40 hex
-- characters, no directory, an empty array, a path outside the directories (each given
-- with a trailing /), a path that ends in /, a duplicate or missing path, a missing body, a
-- body that is not UTF-8 or holds a NUL byte, or a sha256 that does not match the body's
-- bytes. Every file is checked before anything is written.
-- Security definer, so that the mirror job's role needs usage on the schema and execute on
-- this function, and no right on the tables; search_path is empty, every table is
-- schema-qualified, and there is no dynamic SQL.
create function gov.mirror_replace(p_commit text, p_directories text[], p_files jsonb)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  f       jsonb;
  f_path  text;
  f_sha   text;
  f_bytes bytea;
  n       integer;
begin
  if p_commit is null or p_commit !~ '^[0-9a-f]{40}$' then
    raise exception 'mirror_replace: commit % is not 40 hex characters', coalesce(p_commit, 'null')
      using errcode = 'invalid_parameter_value';
  end if;
  if p_directories is null or cardinality(p_directories) = 0 then
    raise exception 'mirror_replace: no directory given'
      using errcode = 'invalid_parameter_value';
  end if;
  if p_files is null or jsonb_typeof(p_files) <> 'array' or jsonb_array_length(p_files) = 0 then
    raise exception 'mirror_replace: no file given; the mirror is left as it was'
      using errcode = 'invalid_parameter_value';
  end if;
  n := jsonb_array_length(p_files);

  if (select count(distinct e.value->>'path') from pg_catalog.jsonb_array_elements(p_files) as e) <> n then
    raise exception 'mirror_replace: a path is given twice, or a file has no path'
      using errcode = 'invalid_parameter_value';
  end if;

  -- Every file is checked before anything is written.
  for f in select e.value from pg_catalog.jsonb_array_elements(p_files) as e loop
    f_path := f->>'path';
    f_sha  := f->>'sha256';
    if f_path is not null and pg_catalog.right(f_path, 1) = '/' then
      raise exception 'mirror_replace: path % ends in / and names no file', f_path
        using errcode = 'invalid_parameter_value';
    end if;
    if f_path is null or not exists (
         select 1 from pg_catalog.unnest(p_directories) as d(dir)
         where pg_catalog.right(d.dir, 1) = '/' and pg_catalog.left(f_path, pg_catalog.length(d.dir)) = d.dir) then
      raise exception 'mirror_replace: path % is outside the directories given', coalesce(f_path, 'null')
        using errcode = 'invalid_parameter_value';
    end if;
    if f->>'body_b64' is null then
      raise exception 'mirror_replace: % has no body', f_path
        using errcode = 'invalid_parameter_value';
    end if;
    f_bytes := pg_catalog.decode(f->>'body_b64', 'base64');
    if f_sha is null or pg_catalog.encode(pg_catalog.sha256(f_bytes), 'hex') <> f_sha then
      raise exception 'mirror_replace: the sha256 of % does not match its bytes', f_path
        using errcode = 'data_exception';
    end if;
    perform pg_catalog.convert_from(f_bytes, 'UTF8');
  end loop;

  delete from gov.mirror_files as m
  where not exists (
    select 1 from pg_catalog.jsonb_array_elements(p_files) as e
    where e.value->>'path' = m.path);

  insert into gov.mirror_files (path, body, sha256, commit_hash, mirrored_at)
  select e.value->>'path',
         pg_catalog.convert_from(pg_catalog.decode(e.value->>'body_b64', 'base64'), 'UTF8'),
         e.value->>'sha256', p_commit, pg_catalog.now()
  from pg_catalog.jsonb_array_elements(p_files) as e
  on conflict (path) do update
    set body = excluded.body, sha256 = excluded.sha256,
        commit_hash = excluded.commit_hash, mirrored_at = excluded.mirrored_at;

  insert into gov.mirror_runs (commit_hash, directories, file_count)
  values (p_commit, p_directories, n);

  return n;
end
$$;

-- The mirror job's role needs usage on the schema and execute on gov.mirror_replace, and
-- nothing else; the roles that read the mirror, the read connection's role included, need
-- usage on the schema and select on gov.mirror_files and gov.mirror_status. For example:
--   grant usage on schema gov to <mirror job role>, <reader role>;
--   grant execute on function gov.mirror_replace(text, text[], jsonb) to <mirror job role>;
--   grant select on gov.mirror_files, gov.mirror_status to <reader role>;
revoke all on gov.mirror_files, gov.mirror_runs from public;
revoke all on function gov.mirror_replace(text, text[], jsonb) from public;
