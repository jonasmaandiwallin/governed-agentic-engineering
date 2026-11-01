-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Jonas Maandi Wallin
-- Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
-- the full text is in LICENSE at the repository root.
--
-- GAE starter — the installation's configuration store, for PostgreSQL 14 or later
-- (ADOPTION.md step 5, "Configuration is data in the system store, never a migration").
--
-- This file is the migration that creates the schema. It writes no installation-specific
-- row: the overview's address, the engagements' store references and the tools each agent
-- expects are written afterwards, as data, in the system store only, through
-- gov.set_config. Run the migration in every store if your stores share one schema; the
-- rows exist only where they are written.
--
-- Shape:
--   gov.config_entries  append-only: one row per value written, with the owner decision
--                       behind it and the time. Nothing is updated or deleted, so every
--                       earlier value stays readable with the time it was set.
--   gov.config          view: the current value per key, with its decision and time.
--                       The core reads it at start and prints the values in its receipt.
--   gov.set_config      the narrow write function: only the keys in its closed list, which
--                       are the keys the appendix binds, a decision id that names a row of
--                       the decision log, a value checked per key.
--
-- Before you run it, bind in the instance appendix (§ Languages and configuration):
--   - the schema name, if not gov, and the decision log table, if not gov.decisions
--     (the function only checks that the id exists there);
--   - the keys and their checks, in the list in gov.set_config below: one tools_<agent> key
--     per agent in the role table, in place of the placeholder. The placeholder cannot be
--     written (the table's key format refuses it), so an unedited list accepts only the two
--     named keys. A key that widens what an agent may reach (engagement_refs here) is always
--     written on an owner decision; the boundary contract says who writes the rows;
--   - the owner role: a migration role that no agent and no connector runs as (below).
-- Adding a key is a change to this function in a new migration, never a row written ad hoc.

create schema if not exists gov;

create table gov.config_entries (
  id          bigint generated always as identity primary key,
  key         text        not null,
  value       text        not null,
  decision_id bigint      not null,
  written_at  timestamptz not null default now(),
  constraint config_entries_key_format check (key ~ '^[a-z][a-z0-9_]*$'),
  constraint config_entries_value_not_blank check (btrim(value, E' \t\r\n') <> '')
);

create index config_entries_key_id on gov.config_entries (key, id desc);

-- Append-only: the trigger refuses update, delete and truncate for every role except the
-- table's owner, who can disable it, and a superuser, who can skip it. So run this migration
-- as an owner role that no agent and no connector runs as, and bind that role in the
-- appendix; then no running part of the system can change an earlier row.
create function gov.config_entries_append_only()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  raise exception 'config_entries is append-only: % is not allowed', tg_op
    using errcode = 'insufficient_privilege';
end
$$;

create trigger config_entries_append_only
  before update or delete or truncate on gov.config_entries
  for each statement execute function gov.config_entries_append_only();

create view gov.config as
  select distinct on (e.key) e.key, e.value, e.decision_id, e.written_at
  from gov.config_entries as e
  order by e.key, e.id desc;

-- Writes one value for p_key, on the owner decision p_decision_id, and returns the new row's
-- id. Raises, writing nothing, for a key not in the list, a decision id that names no row of
-- the decision log, a blank value, or a value that fails its key's check.
-- Security definer, so that the writer needs usage on the schema and execute on the
-- function, and no right on the table; search_path is empty, every table is
-- schema-qualified, and there is no dynamic SQL.
create function gov.set_config(p_key text, p_value text, p_decision_id bigint)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  new_id bigint;
begin
  -- The keys the instance appendix binds, as a closed list: one tools_<agent> per agent in
  -- the role table, in place of the placeholder. Change the list only in a new migration.
  if p_key is null
     or p_key not in ('system_overview_url', 'engagement_refs', 'tools_<agent>') then
    raise exception 'set_config: key % is not written through gov.set_config', coalesce(p_key, 'null')
      using errcode = 'invalid_parameter_value';
  end if;

  if p_decision_id is null
     or not exists (select 1 from gov.decisions as d where d.id = p_decision_id) then
    raise exception 'set_config: decision id % names no row of the decision log', coalesce(p_decision_id::text, 'null')
      using errcode = 'invalid_parameter_value';
  end if;

  if p_value is null or btrim(p_value, E' \t\r\n') = '' then
    raise exception 'set_config: the value for key % is null or blank', p_key
      using errcode = 'invalid_parameter_value';
  end if;

  -- One check per key. Write each as narrow as the value allows.
  if p_key = 'system_overview_url'
     and (left(p_value, 8) <> 'https://' or p_value ~ '\s') then
    raise exception 'set_config: system_overview_url must start with https:// and hold no blank'
      using errcode = 'invalid_parameter_value';
  end if;

  -- Store references separated by a comma and optional spaces. Replace the pattern with
  -- the form your database platform gives a store reference.
  if p_key = 'engagement_refs'
     and p_value !~ '^[a-z0-9_-]+(, *[a-z0-9_-]+)*$' then
    raise exception 'set_config: engagement_refs must be store references separated by a comma'
      using errcode = 'invalid_parameter_value';
  end if;

  -- Tool names separated by a comma and optional spaces.
  if p_key ~ '^tools_' and p_value !~ '^[A-Za-z0-9_.:-]+(, *[A-Za-z0-9_.:-]+)*$' then
    raise exception 'set_config: % must be tool names separated by a comma', p_key
      using errcode = 'invalid_parameter_value';
  end if;

  insert into gov.config_entries (key, value, decision_id)
  values (p_key, p_value, p_decision_id)
  returning id into new_id;

  return new_id;
end
$$;

-- No role writes the table directly. The role that writes configuration rows, as the
-- boundary contract names it, needs usage on the schema and execute on gov.set_config, and
-- nothing else; every role that reads gov.config, the read connection's role included, needs
-- usage on the schema and select on the view. For example:
--   grant usage on schema gov to <writer role>, <reader role>;
--   grant execute on function gov.set_config(text, text, bigint) to <writer role>;
--   grant select on gov.config to <reader role>;
revoke all on gov.config_entries from public;
revoke all on function gov.set_config(text, text, bigint) from public;
