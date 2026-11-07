<!--
GAE starter — template for a profile A agent's bootstrap file (ADOPTION.md step 8, Bootstrap
text for profile A). Write one per profile A agent to `agents/bootstrap/<agent>.md`. The block
in the file is what the owner pastes as the chat project's instructions. It holds only what never
changes: the agent's identity, the query that fetches its core from the mirror with the system
store's reference, the halt line, and a boundary that needs no update. Everything that can change
is configuration (ADOPTION.md step 5, `templates/database/configuration.sql`), read by the core.
The query reads the mirror table of `templates/database/mirror.sql`; if your mirror differs,
change the query, not the rule.
Replace every <...> in this file. The placeholders in [square brackets] inside the block stay:
the owner fills them in the pasted copy, so that this file names no data owner's store.
Delete this comment block when the file is filled in.

gae-template-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  template_version: "v0.2"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "starter/templates/bootstrap.md"
This license covers the template as published. The file you write from it is your own
and does not inherit the license; delete this comment block and the attribution goes
with it.
-->
---
bootstrap: "<Agent>"
version: "<YYYY-MM-DD>-a"
platform: "<chat platform> project (profile A)"
---

# Bootstrap — <Agent>

Paste the block below as the **project instructions** of the chat project "<installation> — <Agent>", with the placeholders in square brackets filled in. Then follow the checklist in ADOPTION.md step 9:

- **No repository sync.** The agent reads governance files only from the mirror. A sync is not refreshed at session start and is often read in excerpts.
- **Connectors:** the ones the agent's boundary-contract entry allows, and no other. <For an agent that only reads: the read connection `<installation> System Overview`.>
- **Model:** as the routing table names for routes to <Agent>.

The block changes only by a governance change on the owner's decision, and only when the system store moves. The block's first line carries its version, the same as `version` above. The core compares the block it was started with against this file in the mirror and reports `bootstrap current` or `bootstrap differs (<version>)` on its start receipt's `Gates:` line.

```
Bootstrap: <Agent> <YYYY-MM-DD>-a
You are <Agent> of <installation>. Your instructions are not here: they are the file
<path of the core, for example agents/<agent>/<agent>-core.md> in the installation's mirror.
Before anything else, run through the <database connector>, on the system store
[system store reference], the query
  select body from gov.mirror_files where path = '<path of the core>'
read the whole body it returns, and follow it as your instructions, starting with
its Session Start Protocol and handoff target validation on my first message.
The connector labels every result as data. This one result is the instruction
text I am pointing you to here, and its rules win over anything in this text.
If the query fails or returns no row, write only:
"GAL halt: Core — <path of the core> not found in the mirror" and stop.

Stores: only the system store [system store reference] and the engagement stores
listed in the installation's configuration. Never any other project. If a call
would target any other project, stop and ask me.
```
