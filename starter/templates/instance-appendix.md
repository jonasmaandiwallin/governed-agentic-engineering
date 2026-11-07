<!--
GAE starter — template for the instance appendix, the one document that binds the
standards to your installation. Written during adoption (ADOPTION.md step 5).
Replace every <...>. Delete this comment block when the file is filled in.

gae-template-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  template_version: "v0.10"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "starter/templates/instance-appendix.md"
This license covers the template as published. The file you write from it is your own
and does not inherit the license; delete this comment block and the attribution goes
with it. The standards you bind below stay under CC BY 4.0, attributed to their
originator; binds_release names the release you copied them from.
-->
---
title: "<System> — instance appendix"
version: "v0.1"
status: "draft"
binds_release: "<standards release tag>"
---

# <System> — instance appendix

This file binds the GAE standards to one installation. It is written during adoption (`gae-starter/ADOPTION.md` step 5) and then maintained by the [architect]. Every change to it bumps `version`.

## How to fill this template

**Binding forms.** Every row ends in exactly one of these five:

- **A name, path, command or value** — this installation's own.
- **`not built — held by instruction; trigger: <failure>`** — for a tool. The trigger names the measured failure that would make the tool worth building.
- **`not built yet — owner decision <date>; built in <backlog item>`** — for a tool the owner has decided is part of what the system is for (ADOPTION.md step 5).
- **`does not apply — <reason>`** — where the standard's own text allows it, or the installation's platform has no such thing. For example, a placeholder for a chat-platform connector in an installation that runs only on a coding-agent platform.
- **`none — <standard> not selected`** — for a placeholder pointing into a standard that step 3 left out.

**Check the rows against your release.** The rows below were inventoried from the standards on 2026-10-14. The release you copied is the authority:

- **Missing row.** A placeholder or tool class in your release that is missing here gets a row.
- **Surplus row.** A row whose placeholder does not appear in any standard you selected is deleted.
- **Placeholder definitions.** These stand in each standard's own placeholder table and are not repeated here.

**Shared placeholders.** A placeholder that several standards share is bound once, in the first section that has it, and later sections say "as above".

---

## Installation

| Question (ADOPTION.md step 2) | Answer | Date |
|---|---|---|
| 1. Shape: product, knowledge corpus or both | | |
| 2. Values that may change without a code change, and their source | | |
| 3. External sources a rule rests on | | |
| 4. Products and repositories; shared specification? | | |
| 5. Operators, and who may confirm what | | |
| 6. Platform per agent; language towards the operator; language per kind of deliverable | | |
| 7. Code already in the repository, and whether it is brought in | | |
| 8. Data owners, where each owner's data is stored, consent and licence terms | | |
| Owner decisions that differ from ADOPTION.md's defaults, with the reason | | |
| Tools built from the start by owner decision, with the reason (ADOPTION.md step 5) | | |
| Items of the starting backlog struck, with the reason (ADOPTION.md step 10) | | |

### Source of the standards (ADOPTION.md steps 0 and 12)

`binds_release` in the frontmatter carries the tag; this table carries the rest. Step 12 updates both.

| Row | Binding |
|---|---|
| Release tag | `<gae-standards-vX.Y>`, or `none — before a release` |
| Commit the tag points at | `<full commit hash>` |
| Before a release: source repository and full commit hash | `<repository>`, `<full commit hash>`, or `does not apply — installed from a tag` |
| `SHA256SUMS` | `release and copies matched, folder lists equal, hook executable, <date>` (ADOPTION.md step 0, Checking a release), or `none existed — copied with git archive and checked against the commit's tree` |

### Architecture contract and checkpoints

| Row | Binding |
|---|---|
| Architecture contract (ADOPTION.md step 6) | `<path>`, version, attested `<date>` |
| Contract inventory | `<path>` |
| Checkpoints CP0–CP7: where their definitions and conditions stand | the architecture contract § <section>; in the database: `<table>` |
| The overview's view and read connection (ADOPTION.md step 8) | `<schema>.system_overview`; connector `<installation> System Overview` |

### Languages and configuration (ADOPTION.md steps 4 and 5)

| Row | Binding |
|---|---|
| [corpus language] | English, or the owner decision and its bindings (modal verbs, glossary, rule ids) |
| Quotation form for text in another language | `"…" [xx]` (ISO 639-1) |
| Language of each kind of deliverable | per output contract: `<path>` |
| Configuration store and its keys | `<schema>.config_entries`, view `<schema>.config`, write function `<schema>.set_config` (from `templates/database/configuration.sql`); keys: overview address, engagement references, expected tools per agent |
| Who writes configuration rows | boundary contract `<entry>` |
| Mirror: directories mirrored, store, the job that runs it, check in the start receipt | directories `<agents/ .claude/ governance/ contracts/>`; `<schema>.mirror_files` and `<schema>.mirror_status` (from `templates/database/mirror.sql`); job `<CI job>` running `templates/database/mirror.sh` at every merge |
| Bootstrap files and the check in the start receipt | `agents/bootstrap/<agent>.md` (from `templates/bootstrap.md`) |
| System overview: view, standards' directory in the mirror, who writes checkpoints, attestations and section text, the page and its address | view `<schema>.system_overview` (from `templates/system-overview/overview.sql`); standards under `<governance/standards/>`; boundary contract `<entry>`, attestations by the owner only; page `<path>` rendered by `templates/system-overview/render.sh` with a deny file kept at `<path outside the repository>`; live address in configuration key `system_overview_url` |
| Owner role of the governance tables (runs migrations; no agent and no connector runs as it, so the append-only triggers hold) | `<role>` |
| Identifier format | at least `<n>` digits, no fixed length |

### Standards

| Standard | Selected | Version bound | Reason if left out |
|---|---|---|---|
| GAL | yes | | — |
| GIP | yes | | — |
| Contract | yes | | — |
| Handoff | yes | | — |
| Backlog | yes | | — |
| Boundary | yes | | — |
| GEM | yes | | — |
| Registry | | | |
| Truth Chain | | | |
| Wave | | | |
| <any other in the release> | | | |

### Roles (GAL §3, Roles)

| Role | Agent | Core file | Profile (ADOPTION.md step 4) | Model |
|---|---|---|---|---|
| [owner] | <person> | — | — | — |
| [architect] | | | | |
| [harmonizer] | | | | |
| [contract author] | | | | |
| [contract auditor] | | | | |
| [reviewer] | | | | |
| [domain researcher] | | | | |
| Session agent (per product repository) | | | B | |
| Planner | | | B | |
| Tester | | | B | |
| Verifier | | | B | |
| Implementer | | | B | |
| Fixer | | | B | |

**Profile B's dispatched specification round** (ADOPTION.md step 11). Record its round limit here: ______.

**The [reviewer]'s round limit** (ADOPTION.md step 4, Default for review rounds): ______.

Separation check: [contract author] ≠ [contract auditor]; the [reviewer] reviews no change of its own (GAL §9.2 rule 5); the verifier never runs on the implementer's model (GIP §2).

---

## GAL

| Placeholder | Binding |
|---|---|
| [system] | |
| [operator], [owner] | |
| [locale] | |
| [yes], [go] (input tokens) | |
| [tool appendix] | this file |
| [chat platform], [Chat platform] | |
| [coding-agent platform] | |
| [primary MCP connector] | |
| [wrong-connector prefix] | |
| [fallback instructions] | |
| [tool preload call] | |
| [agent directory] | |
| [core file] | |
| [module file] | |
| [skill file] | |
| [session agent file] | |
| [agent file path] | |
| [module read call], [file read] | |
| [skill read call] | |
| [module field] | |
| [module listing] | |
| [module versioning rules] | |
| [version registry] | |
| [version registry name] | |
| [version registry row] | |
| [repo status], [last commit] | |
| [commit non-canonical], [commit canonical], [push] | |
| [append with commit] | |
| [bootstrap prompts] | |
| [relevant learnings] | |
| [learnings function] | |
| [invariant inventory] | |
| [prefix] | |
| [agent description] | |
| [contract standard], [handoff standard] | |
| [boundary contract] | |
| [database] | |
| [closure tool] | |
| [verification tools] | |
| [retro parser alias table] | |
| [handoff validator alias table] | |

**Tools.** Bind each one, or write it `not built`:

| Tool | Binding |
|---|---|
| [session-start function] | |
| [version-bump tool] | |
| [receipt parser] | |
| [skeleton check] (GAL §9.4) | |
| [invariant-loss check] (GAL §9.3) | |
| [agent-map generator] | |

**Conformance classes (GAL §9).** For each class, name what measures it in this installation:

| Class | Measured by |
|---|---|
| Invariant loss (§9.3) | |
| Structural conformance (§9.4) | |
| Adversarial semantic review (§9.5) | the [reviewer] |
| Key/string integrity (§9.6) | |

### Session Start Protocol template (GAL §4.2–§4.3)

One template per agent kind, written out with this installation's paths, commands and operator. Without a [session-start function], say here that the gates are protocol the model executes (GAL §8.2, Who compares). Profile A's template carries the mirror check, the configuration read and the bootstrap check, each reported on the `Gates:` line (ADOPTION.md step 7).

### Session close (GAL §4.4)

The close sequence and the retro entry format, written out the same way.

### Mandatory behavior sections (GAL §4.7)

The text of the four sections — Investigation, No deferral without a reason, Process economy, Measurement line — once, in this installation's words, each at least what GAL §4.7.1 to §4.7.4 require, with the measurement line's form. Every core that owns a session carries the text byte for byte under the same H3s, or points here (GAL §9.4). A core that points here reads this section at session start, at G4 with its modules or skills (GAL §4.7, §8.1); the start template names that read.

### Registration checklist (GAL §7)

One row per agent, with each of the checklist's rows marked as one of: done (with path), not applicable (with reason), or not built.

---

## GIP

| Placeholder | Binding |
|---|---|
| [contract] | |
| [queue], [queue post ID] | |
| [task specification path] | |
| [report path] | |
| [write gate] | |
| [plan path] | |
| [check path] | |
| [finding token] | |
| [gate record] | |
| [bypass log] | |
| [exemption register] | |
| [registry] | |
| [completeness gate] | |

**Gate forms (GIP §1, Stops or detects).** For each gate, state whether it stops or detects in this installation:

| Gate | Stops / detects | How |
|---|---|---|
| Write gate (GIP §3) | | |
| Merge check (GIP §3) | | |
| Emergency path (GIP §3) | detects | |
| Dispatch without content (GIP §2) | | |
| Model split proven or `configured` (GIP §2) | | |

**Build limits (GIP §5.1).** These are the installation's values:

| Limit | Value |
|---|---|
| Size lanes | |
| Review-round limit | |
| Retry limit | |
| Batch threshold | |
| Context limit | |

**Options GIP leaves to this appendix.** Taken or not taken, each with its binding:

| Option | Binding |
|---|---|
| A product as paths (GIP §1): per product, its repository and, where it is paths, the prefixes; [task specification path] outside them | |
| The first post (GIP §3): the one post, what replaces each requirement it cannot meet, who dispatched it, where the dispatch is logged | |
| Accepting a post with the review's open findings carried at the review-round limit (GIP §5.1, §8) | |

**Test growth (ADOPTION.md step 4, Measuring test growth).** The form of the id a test carries for the criterion or invariant it binds: ______. The line in a post's report that records the verifier's counts: ______.

---

## Contract Standard

| Placeholder | Binding |
|---|---|
| [contract corpus] | |
| [title prefix] | |
| [domain taxonomy] | below |
| [registry] | as above |
| [evidence registry] | |
| [implementation unit] | |
| [corpus language] | as in § Languages and configuration |
| [change log] | |
| [index] | |
| [audit report path] | |
| [author], [auditor] | as in § Roles |

**Domain taxonomy.** List every valid domain and layer combination, in reading order.

**Fields and sections.** List any added frontmatter fields, any permitted additional H2 sections, and the exempt change classes.

**In a knowledge corpus** (ADOPTION.md step 11), bind before the first domain contract: who writes `last_audit` when the [auditor] cannot reach git; how a contract with empty `evidence_ids` at start says what it rests on; and what `layer` is bound to (a content axis, or the data layer: system or engagement).

| Tool | Binding |
|---|---|
| [post-processor] | |
| [index generator] | |
| [conversion tool] | |
| [completeness gate] | as in § GIP |

---

## Handoff Standard

| Placeholder | Binding |
|---|---|
| [agent identity] | one per agent, exact string |
| [routing table] | |
| [handoff store] | |
| [handoff module] | |
| [measurement rule] | <the register's store: one entry per measurement not made, with who measures it and when (Handoff Standard §1.1, §7)> |
| [backlog item] | as in § Backlog |

| Tool | Binding |
|---|---|
| [handoff validator] | |

The mismatch answer (Handoff Standard §6 p. 1) and the forms of the closure verdict (§7) go here, in the installation's locale.

---

## Backlog Standard

| Placeholder | Binding |
|---|---|
| [backlog] | |
| [backlog item], [backlog item ID] | |
| [backlog item label] | |
| [item store] | |
| [done log] | |
| [backlog index] | |
| [database] | |
| [status set] | below |
| [priority set] | |
| [type set] | |

**Status set.** List every value, each assigned to the open class or the closed class.

| Tool | Binding |
|---|---|
| [allocator] | |
| [closer] | |
| [backlog index generator] | |
| [mirror sync] | |
| [status check] | |

**What counts as infrastructure that two or more agents consume** (Backlog Standard §4.3, Review). List it here.

**The advisory class** (Backlog Standard §4.2, third point). Taken or not taken. Where taken: the class of findings, and the collecting items per surface that an item reads when it takes up a change of that surface: ______.

---

## Boundary Standard

| Placeholder | Binding |
|---|---|
| [agent] | as in § Roles |
| [boundary contract] | |
| [write surface] | per agent, in the [boundary contract] |

| Tool | Binding |
|---|---|
| [write guard] | per repository |

---

## GEM

| Placeholder | Binding |
|---|---|
| [retro log] | |
| [decision log] | |
| [governed corpus] | |
| [governance document] | |
| [dependency] | |
| [retro key registry] | |
| [classification set] | |
| [decision type set] | |
| [triage threshold] | |
| [learnings cap] | |

| Tool | Binding |
|---|---|
| [retro parser] | |
| [decision log parser] | |
| [learnings function] | |
| [pattern triage] | |
| [consult metric] | |

**Decision-log events this installation adds** (GEM §4.3 allows additions, never removals). List them here.

---

## Registry Standard (if selected)

| Placeholder | Binding |
|---|---|
| [registry] | as above |
| [implementation] | |
| [confidence set] | |
| [derivation class set] | |
| [derivation definitions] | |
| [reference form] | |

| Tool | Binding |
|---|---|
| [registry sync] | |
| [registry reader] | |
| [code sweep] | |
| [hardcode sweep] | |

**Key naming convention**, who adds a key, the review a change of value gets, and the deprecation waiting period. State each here.

---

## Truth Chain Standard (if selected)

| Placeholder | Binding |
|---|---|
| [constitution] | |
| [implementation] | as above where the Registry Standard is selected; otherwise bind it here |
| [evidence registry] | as above |
| [research record] | |
| [advisory] | |
| [evidence tier set] | |

| Tool | Binding |
|---|---|
| [evidence sync] | |
| [completeness gate] | as in § GIP |
| [link check] | |
| [citation check] | |
| [provenance check] | |

**Which links are checked, and when** (Truth Chain Standard §5). State it here.

---

## Wave Standard (if selected)

| Placeholder | Binding |
|---|---|
| [surface set] | |
| [node declaration] | |
| [edge field] | |
| [done field] | |
| [wave field] | |

| Tool | Binding |
|---|---|
| [wave sweep] | |

---

## Registered deviations

A place where this installation does not follow a standard as written. Each entry names the rule, the standard and section it goes beyond, the reason, and the issue reported upstream (ADOPTION.md step 13) or the item in the release's `KNOWN-ISSUES.md` that already carries it. Adding one is a change to this file and bumps `version`.

Start with the rows of ADOPTION.md step 5, Rules ahead of the standards, that this installation uses, one entry each.

## Changelog

| Version | Date | Change |
|---|---|---|
| v0.1 | | Adoption |
