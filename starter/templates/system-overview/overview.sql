-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Jonas Maandi Wallin
-- Part of Governed Agentic Engineering (GAE). Code in the GAE repository is MIT-licensed;
-- the full text is in LICENSE at the repository root.
--
-- GAE starter — the data behind the system overview, for PostgreSQL 14 or later
-- (ADOPTION.md step 8, "The system overview"; checkpoint CP4).
--
-- The overview page draws nothing from memory. Everything on it is read, when it is shown,
-- from one view, gov.system_overview, through the read connection. The view reads:
--   - the checkpoints, written from the architecture contract in the same change as each
--     version of it, and the owner's attestations; it computes each checkpoint's status;
--   - the owner's descriptive text per section of the page, each written on an owner
--     decision;
--   - the standards' titles and versions, from the mirror (database/mirror.sql);
--   - the engagement layer as a count and references, from the configuration
--     (database/configuration.sql). No engagement is named.
-- Run this migration after configuration.sql and mirror.sql, in the system store only.
--
-- Shape:
--   gov.checkpoints             append-only: one row per checkpoint definition written.
--   gov.checkpoint_attestations append-only: the owner's attestation of one definition row.
--   gov.overview_entries        append-only: the owner's text for one section of the page.
--   gov.set_checkpoint          writes a definition; a definition equal to the current one
--                               writes nothing, so rewriting all checkpoints at a new contract
--                               version keeps the attestations of those that did not change.
--   gov.attest_checkpoint       attests the current definition of one checkpoint, only when
--                               every checkpoint before it is done.
--   gov.set_overview_section    writes one section's items.
--   gov.system_overview         view: one row, one column `overview`, the JSON document below.
--
-- Status, computed per checkpoint from its current definition (the latest row per code):
--   done         an attestation exists for that definition row. A changed definition is a
--                new row, so the checkpoint is open again until the owner attests it.
--   in_progress  not done, and every checkpoint before it (lower position) is done. Two
--                checkpoints on one position are not before each other, here and in
--                gov.attest_checkpoint; gov.set_checkpoint does not write them.
--   todo         otherwise.
--
-- The JSON document (format 1). The page reads these fields and no others:
--   format                1
--   read_at               the database's now() at the read
--   checkpoints           [{code, position, name, definition, status, contract_version,
--                           attested_at, attestation_decision_id}], by position
--   checkpoints_done      number of checkpoints with status done
--   checkpoints_total     number of checkpoints
--   sections              {<section>: {items: [{title, text, state?}], decision_id,
--                           written_at}} for each section written; state is planned,
--                           in_progress or built
--   standards             [{path, title, version}] from the mirror, by path
--   mirror                {commit, mirrored_at} of the latest mirror run, or null
--   engagements           {count, refs}: the store references in engagement_refs, never names
-- The sections, in the order the page shows them: purpose (its first item's title is the
-- installation's name, its text the lede), deliverables, flows, controls, learning, agents,
-- stores, corpus, standards (one item per standard: title equal to the standard's title,
-- text saying how it acts in this installation).
--
-- Before you run it, bind in the instance appendix (§ Languages and configuration, System
-- overview):
--   - the schema name, if not gov, and the decision log table, if not gov.decisions (the
--     functions only check that the id exists there);
--   - the standards' directory in the mirror, if not governance/standards/ (in the view);
--   - the owner role, as for configuration.sql and mirror.sql: a migration role that no agent
--     and no connector runs as;
--   - who writes checkpoints, attestations and section text, in the boundary contract.
--     An attestation is always an owner decision.

create schema if not exists gov;

create table gov.checkpoints (
  id               bigint generated always as identity primary key,
  code             text        not null,
  position         integer     not null,
  name             text        not null,
  definition       text        not null,
  contract_version text        not null,
  decision_id      bigint      not null,
  written_at       timestamptz not null default now(),
  constraint checkpoints_code_format check (code ~ '^CP[0-9]+$'),
  constraint checkpoints_position_range check (position >= 0),
  constraint checkpoints_name_not_blank check (btrim(name, E' \t\r\n') <> ''),
  constraint checkpoints_definition_not_blank check (btrim(definition, E' \t\r\n') <> ''),
  constraint checkpoints_contract_version_format check (contract_version ~ '^[0-9]+(\.[0-9]+){1,2}$')
);

create index checkpoints_code_id on gov.checkpoints (code, id desc);

create table gov.checkpoint_attestations (
  id            bigint generated always as identity primary key,
  definition_id bigint      not null references gov.checkpoints (id),
  decision_id   bigint      not null,
  attested_at   timestamptz not null default now(),
  constraint checkpoint_attestations_once unique (definition_id)
);

create table gov.overview_entries (
  id          bigint generated always as identity primary key,
  section     text        not null,
  items       jsonb       not null,
  decision_id bigint      not null,
  written_at  timestamptz not null default now(),
  constraint overview_entries_section_set check (section in (
    'purpose', 'deliverables', 'flows', 'controls', 'learning',
    'agents', 'stores', 'corpus', 'standards'))
);

create index overview_entries_section_id on gov.overview_entries (section, id desc);

-- Append-only: the trigger refuses update, delete and truncate for every role except the
-- table's owner, who can disable it, and a superuser, who can skip it. Run this migration as
-- the owner role the appendix binds, which no agent and no connector runs as.
create function gov.overview_append_only()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  raise exception '%.% is append-only: % is not allowed', tg_table_schema, tg_table_name, tg_op
    using errcode = 'insufficient_privilege';
end
$$;

create trigger checkpoints_append_only
  before update or delete or truncate on gov.checkpoints
  for each statement execute function gov.overview_append_only();
create trigger checkpoint_attestations_append_only
  before update or delete or truncate on gov.checkpoint_attestations
  for each statement execute function gov.overview_append_only();
create trigger overview_entries_append_only
  before update or delete or truncate on gov.overview_entries
  for each statement execute function gov.overview_append_only();

create view gov.checkpoint_status as
  with cur as (
    select distinct on (c.code) c.*
    from gov.checkpoints as c
    order by c.code, c.id desc
  ), att as (
    select cur.*, a.attested_at, a.decision_id as attestation_decision_id
    from cur
    left join gov.checkpoint_attestations as a on a.definition_id = cur.id
  )
  select att.code, att.position, att.name, att.definition, att.contract_version,
         att.attested_at, att.attestation_decision_id, att.id as definition_id,
         case
           when att.attested_at is not null then 'done'
           when coalesce(bool_and(att.attested_at is not null) over (
                  order by att.position range between unbounded preceding and 1 preceding),
                true) then 'in_progress'
           else 'todo'
         end as status
  from att;

-- Writes a checkpoint definition from the architecture contract at p_contract_version, on
-- the owner decision that made that version canonical, and returns the current definition
-- row's id. A definition whose position, name and definition equal the current one writes
-- nothing and returns the current id. Raises, writing nothing, for a decision id that names
-- no row of the decision log, a position another checkpoint holds, a value that fails a
-- table check, or a caller in a repeatable read transaction. Calls are serialized by a lock
-- on gov.checkpoints, so two calls at once cannot both take a free position; under
-- repeatable read the check would read the transaction's older snapshot, so it is refused.
-- To swap two checkpoints' positions, move one to a free position first.
create function gov.set_checkpoint(p_code text, p_position integer, p_name text,
                                   p_definition text, p_contract_version text,
                                   p_decision_id bigint)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  cur gov.checkpoints%rowtype;
  new_id bigint;
begin
  if p_decision_id is null
     or not exists (select 1 from gov.decisions as d where d.id = p_decision_id) then
    raise exception 'set_checkpoint: decision id % names no row of the decision log', coalesce(p_decision_id::text, 'null')
      using errcode = 'invalid_parameter_value';
  end if;

  if current_setting('transaction_isolation') = 'repeatable read' then
    raise exception 'set_checkpoint: run under read committed or serializable, not repeatable read'
      using errcode = 'invalid_transaction_state';
  end if;
  lock table gov.checkpoints in share row exclusive mode;

  if exists (select 1 from gov.checkpoint_status as s
             where s.position = p_position and s.code is distinct from p_code) then
    raise exception 'set_checkpoint: position % is held by another checkpoint', p_position
      using errcode = 'invalid_parameter_value';
  end if;

  select * into cur from gov.checkpoints as c where c.code = p_code order by c.id desc limit 1;
  if found and cur.position = p_position and cur.name = p_name and cur.definition = p_definition then
    return cur.id;
  end if;

  insert into gov.checkpoints (code, position, name, definition, contract_version, decision_id)
  values (p_code, p_position, p_name, p_definition, p_contract_version, p_decision_id)
  returning id into new_id;
  return new_id;
end
$$;

-- Attests the current definition of p_code on the owner decision p_decision_id and returns
-- the attestation's id. Raises, writing nothing, for an unknown checkpoint, a decision id
-- that names no row of the decision log, a definition already attested, or a checkpoint
-- before it (lower position) that is not done.
create function gov.attest_checkpoint(p_code text, p_decision_id bigint)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  s record;
  new_id bigint;
begin
  if p_decision_id is null
     or not exists (select 1 from gov.decisions as d where d.id = p_decision_id) then
    raise exception 'attest_checkpoint: decision id % names no row of the decision log', coalesce(p_decision_id::text, 'null')
      using errcode = 'invalid_parameter_value';
  end if;

  select * into s from gov.checkpoint_status as cs where cs.code = p_code;
  if not found then
    raise exception 'attest_checkpoint: no checkpoint %', coalesce(p_code, 'null')
      using errcode = 'invalid_parameter_value';
  end if;
  if s.status = 'done' then
    raise exception 'attest_checkpoint: % is already attested at its current definition', p_code
      using errcode = 'invalid_parameter_value';
  end if;
  if exists (select 1 from gov.checkpoint_status as cs
             where cs.position < s.position and cs.status <> 'done') then
    raise exception 'attest_checkpoint: a checkpoint before % is not done', p_code
      using errcode = 'invalid_parameter_value';
  end if;

  insert into gov.checkpoint_attestations (definition_id, decision_id)
  values (s.definition_id, p_decision_id)
  returning id into new_id;
  return new_id;
end
$$;

-- Writes the items of one section on the owner decision p_decision_id and returns the new
-- row's id. p_items is a JSON array of 1 to 50 objects with the keys title and text
-- (non-blank strings) and, optionally, state (planned, in_progress or built); no other key.
-- Raises, writing nothing, for a section outside the set, a decision id that names no row of
-- the decision log, or items of another shape.
create function gov.set_overview_section(p_section text, p_items jsonb, p_decision_id bigint)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  item jsonb;
  new_id bigint;
begin
  if p_decision_id is null
     or not exists (select 1 from gov.decisions as d where d.id = p_decision_id) then
    raise exception 'set_overview_section: decision id % names no row of the decision log', coalesce(p_decision_id::text, 'null')
      using errcode = 'invalid_parameter_value';
  end if;

  if p_items is null or jsonb_typeof(p_items) <> 'array'
     or jsonb_array_length(p_items) not between 1 and 50 then
    raise exception 'set_overview_section: items must be an array of 1 to 50 objects'
      using errcode = 'invalid_parameter_value';
  end if;

  for item in select value from jsonb_array_elements(p_items) loop
    if jsonb_typeof(item) <> 'object'
       or exists (select 1 from jsonb_object_keys(item) as k where k not in ('title', 'text', 'state'))
       or jsonb_typeof(item -> 'title') is distinct from 'string'
       or jsonb_typeof(item -> 'text') is distinct from 'string'
       or btrim(item ->> 'title', E' \t\r\n') = ''
       or btrim(item ->> 'text', E' \t\r\n') = ''
       or (item ? 'state' and (item ->> 'state') is distinct from 'planned'
           and (item ->> 'state') is distinct from 'in_progress'
           and (item ->> 'state') is distinct from 'built') then
      raise exception 'set_overview_section: item % is not {title, text, state?} with non-blank strings and a known state', item
        using errcode = 'invalid_parameter_value';
    end if;
  end loop;

  insert into gov.overview_entries (section, items, decision_id)
  values (p_section, p_items, p_decision_id)
  returning id into new_id;
  return new_id;
end
$$;

create view gov.system_overview as
  select jsonb_build_object(
    'format', 1,
    'read_at', now(),
    'checkpoints', coalesce((
      select jsonb_agg(jsonb_build_object(
               'code', s.code, 'position', s.position, 'name', s.name,
               'definition', s.definition, 'status', s.status,
               'contract_version', s.contract_version, 'attested_at', s.attested_at,
               'attestation_decision_id', s.attestation_decision_id)
             order by s.position)
      from gov.checkpoint_status as s), '[]'::jsonb),
    'checkpoints_done', (select count(*) from gov.checkpoint_status as s where s.status = 'done'),
    'checkpoints_total', (select count(*) from gov.checkpoint_status),
    'sections', coalesce((
      select jsonb_object_agg(e.section, jsonb_build_object(
               'items', e.items, 'decision_id', e.decision_id, 'written_at', e.written_at))
      from (select distinct on (o.section) o.*
            from gov.overview_entries as o
            order by o.section, o.id desc) as e), '{}'::jsonb),
    'standards', coalesce((
      select jsonb_agg(jsonb_build_object(
               'path', m.path,
               'title', coalesce(
                 substring(m.body from '(?n)^(?:document_)?title:[ \t]*"?([^"\n]*[^" \n])"?[ \t]*$'),
                 m.path),
               'version', substring(m.body from '(?n)^version:[ \t]*"?([^"\n]*[^" \n])"?[ \t]*$'))
             order by m.path)
      from gov.mirror_files as m
      where m.path like 'governance/standards/%.md'), '[]'::jsonb),
    'mirror', (select jsonb_build_object('commit', ms.commit_hash, 'mirrored_at', ms.mirrored_at)
               from gov.mirror_status as ms),
    'engagements', (
      select jsonb_build_object('count', coalesce(array_length(r.refs, 1), 0),
                                'refs', to_jsonb(coalesce(r.refs, array[]::text[])))
      from (select (select regexp_split_to_array(c.value, ', *')
                    from gov.config as c where c.key = 'engagement_refs') as refs) as r)
  ) as overview;

-- No role writes a table directly. The roles the boundary contract names need usage on the
-- schema and execute on their functions; the read connection's role needs usage on the
-- schema and select on gov.system_overview, and nothing else (the view reads the tables with
-- its owner's rights). For example:
--   grant usage on schema gov to <writer role>, <reader role>;
--   grant execute on function gov.set_checkpoint(text, integer, text, text, text, bigint),
--     gov.set_overview_section(text, jsonb, bigint) to <writer role>;
--   grant execute on function gov.attest_checkpoint(text, bigint) to <owner's writer role>;
--   grant select on gov.system_overview to <reader role>;
revoke all on gov.checkpoints, gov.checkpoint_attestations, gov.overview_entries from public;
revoke all on gov.checkpoint_status, gov.system_overview from public;
revoke all on function gov.set_checkpoint(text, integer, text, text, text, bigint),
                       gov.attest_checkpoint(text, bigint),
                       gov.set_overview_section(text, jsonb, bigint) from public;
