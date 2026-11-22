---
document_title: "Truth Chain Standard"
version: "v0.10"
status: "draft"
created: "2026-10-13"
last_updated: "2026-11-22"
author: "Tooling & Architecture"
framework:
  name: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
editor: "Jonas Maandi Wallin"
contact: "https://www.linkedin.com/in/jonasmaandiwallin"
author_llm:
  - model: "Claude Opus 5.5"
    model_id: "claude-opus-5-5"
    roles: [drafting, technical-analysis]
    source: handoff
ai_disclosure:
  - role: drafting
    status: complete
    scope: "All prose, structure and wording."
    evidence: "The document text itself."
  - role: technical-analysis
    status: complete
    scope: "Each rule was written from the behaviour of the reference installation's agents and tools, read in their source, logs and database."
    evidence: "The reference installation's decision log and retro log, not published; its binding of this standard in its instance appendix."
  - role: fact-check
    status: not-applicable
    reason: "The standard cites no external source."
  - role: review
    status: pending
    scope: "Adversarial review of the released package as a whole."
    evidence: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "standards/truth-chain-standard.md"
---

# Truth Chain Standard

## 1. Purpose and scope

A system that governs behaviour by contracts makes claims at several levels: what the system is for, what it must do, which values it uses, what the evidence says, and what the code does. When two levels disagree, someone must be able to say which one holds. When a value is questioned, someone must be able to follow it back to the evidence it rests on. This standard defines the truth chain. It covers the levels and their order of authority, the links that tie each governed statement to the level above it, the evidence registry at the bottom of the chain, and what the tools that check the links must guarantee.

The Contract Standard owns the contract and its metadata. The Registry Standard owns the registry of governed values. The GIP standard owns how a contract reaches the [implementation]. The GEM standard owns the form of the log entry a conflict writes. This standard owns the order between them and the links that connect them.

Four properties follow:

- **One order of authority.** When two levels conflict, the higher one holds. The order is fixed. No instruction, prompt or runtime context reorders it.
- **Every governed statement points upstream.** An implementation points to its contract. A contract points to its registry keys and its evidence. A registry entry points to its evidence, or states that none bears it. An evidence entry points to its source.
- **Evidence proposes, governance decides.** Research and evidence change nothing above them directly. A finding that would change a contract or a value becomes a proposal, and the level that owns the statement decides.
- **No silent resolution.** A conflict between levels is logged, and the lower level is brought into line.

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system the chain governs |
| [operator] | The person who decides what the agents leave open |
| [constitution] | The document that states what the [system] is for and the constraints every [contract] at level 2 serves |
| [architecture contract] | The [contract] that states how the [system] is built: it binds the standards and the [instance appendix] for the [system] (Contract Standard §2, type `architecture`). A [system] may have none |
| [contract] | A document in the contract corpus (Contract Standard) |
| [registry] | The store of governed values (Registry Standard) |
| [evidence registry] | The store of evidence entries, one per source |
| [research record] | The record of a research round: what was searched, read and concluded, before an evidence entry is written |
| [advisory] | Guidance the [system] may show or use for tone and wording, which never changes behaviour |
| [implementation] | The code that executes the contracts (GIP). In a knowledge corpus, where the agents' work is the product, the deliverables the agents produce; work people do outside the [system] on the strength of a deliverable is outside the chain, and what comes back from it is new evidence |
| [evidence tier set] | The ordered closed set of evidence strength levels |
| [decision log] | As in the GEM standard |
| [database] | The store that mirrors the [evidence registry] for queries |
| [evidence sync], [link check], [citation check], [provenance check], [completeness gate] | Tools of the classes in §6 |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. Levels and authority

### 2.1 Order of authority

From highest to lowest:

1. [constitution], and the [architecture contract] where the [instance appendix] places it here
2. [contract], together with the [registry] values it cites by key
3. [implementation]

A level applies within the scope its document declares, and says nothing outside it. Every document at level 1 declares its scope. The [architecture contract] is a [contract] and stands at level 2, below the [constitution], unless the [instance appendix] places it at level 1. Where it does, two documents stand at level 1, the [constitution] for what the [system] is for and how the work is done and the [architecture contract] for how the [system] is built; their scopes do not overlap, and neither stands above the other.

[advisory] has no authority over behaviour at any level. [evidence registry] and [research record] are not levels of authority: they are the ground that statements at levels 1–2 rest on, and they change a level only through §2.3.

### 2.2 Conflicts

When two statements at different levels conflict:

1. The higher level holds.
2. The conflict is written to the [decision log], with both statements and where they stand.
3. The lower statement is updated or deprecated, in the next change the [instance appendix] names for that level.

A conflict between two statements at the same level is resolved by the rules that own that level: Contract Standard §6 for contracts, Registry Standard §2.1 for keys. Two documents at level 1 that conflict have scopes that overlap: the conflict is written to the [decision log], and the [operator] narrows one of the scopes, each document by its own process.

### 2.3 How evidence changes the chain

- A finding from a [research record] or an [evidence registry] entry that would change a [contract] or a [registry] value becomes a proposal to the owner of that statement. It is never applied directly.
- A [contract] at level 2 that conflicts with a document at level 1 is invalid until that document is changed by its own process.
- An [implementation] never contains logic that no [contract] or task specification with a passed gate specifies (GIP §3, §4). The first post's entry, with its record of what replaced the gate (GIP §3), is the one task specification an [implementation] may rest on without a passed gate.
- In a knowledge corpus, a deliverable produced before the [contract] for its surface is merged is marked *before contract* and cites no contract version. The mark keeps the departure from the order visible; the deliverable rests on no [contract] until one is merged for it.
- A statement at level 1 or 2 never rests on the [implementation]. Reading the code can show where a [contract] leaves a gap that the code fills. That is a finding against the [contract], and the text that closes the gap rests on a decision or on evidence, not on what the code does.
- An answer from a model outside the chain, such as a language model put a question, is a hypothesis to test against the [system]. It is never the ground of a statement and never cited as evidence. The model that answers is the one that was asked: a silent switch to another model fails the run.
- A criterion that decides whether a run or a comparison bears a statement is written down before the run. The run is made once, and its result is read against that criterion.

## 3. Links

### 3.1 The links

| From | Points to | Where the link stands |
|---|---|---|
| [implementation] | The [contract] it implements | A marker in the code, the task specification of its build (GIP §4) or the first post's entry (§2.3); for a deliverable, the [contract] version it cites, or its mark *before contract* |
| [contract] | The [registry] keys it cites, and the [evidence registry] entries it rests on | Key citations in the body (Contract Standard §7.2); evidence IDs in its metadata and its body |
| [registry] entry | The [evidence registry] entries that bear the value, or an explicit statement that none does | Registry Standard §2.2 |
| [evidence registry] entry | Its source, and the [research record] that admitted it | §4 |
| A finding drawn from several sources, in a [research record] | The [evidence registry] entry for each source it rests on | In the record, in the form the [instance appendix] names. Until an entry exists, the finding names that source by its citation, and the link is made when the entry is written (§4.1) |

### 3.2 Rules for links

- A link names an entry that exists and is in force. A link to an entry that is missing, retracted or superseded is a defect at the level that holds the link. A [registry] key is superseded from its deprecation: a [contract] that cites a deprecated key holds a defect from that day, however long the [registry] keeps the key before removing it (Registry Standard §4.3). The defect is corrected when the [contract] cites the key that replaces it, or, where nothing replaces it, when the [contract] no longer cites the key and the text that rested on its value is changed or removed with an entry in the [decision log] (GEM §4.3).
- The evidence IDs a [contract] declares in its metadata, and the ones its body cites, are the same set.
- Evidence named in prose does not count as a link unless it stands in the field or citation form the [instance appendix] names.
- A link carries no more strength than its source. A statement that rests on an entry of a low tier says so, or the [instance appendix] names where its confidence stands (as Registry Standard §2.2 does for values). The [instance appendix] states how the Registry Standard's [confidence set] orders against the [evidence tier set], and the two may be one set. A value whose confidence stands above what the highest tier of its evidence gives under that order names its reason: corroboration by entries for distinct sources (below), or an [operator] decision in the [decision log]. A value whose evidence states that none bears it has no tier, so any confidence above the lowest level of the [confidence set] stands above its evidence, and only an [operator] decision can be its reason. The reason stands in the entry's source field (Registry Standard §2.2); corroboration is read from its evidence field.
- A link bears a statement only when the entry has been read for that statement: its key finding concerns the same subject, the same quantity and the same conditions. Where one of the three differs, the statement does not rest on the entry. The writer stops and says so, and narrows neither the statement nor the entry to make them meet.
- An entry that a search, a [registry] field or another entry points to is a candidate until it has been read so. A link that was found is not yet support.
- The entry is read in its record (§4.3) and in its source, never in a copy that may be older.
- Two links to entries for the same source are one link. A statement is corroborated only by entries for distinct sources.
- Where a tool can read what a research statement says about the [system] itself, the tool's reading holds, and the statement is checked against it.

### 3.3 The governed evidence graph

The links of §3.1 and the relations below form the governed evidence graph. This section states what the graph guarantees, not how it is kept: tables, a graph store, embeddings and full-text search are the installation's choice, bound in the [instance appendix]. A link of §3.1 that stands in a document, such as an evidence ID in a [contract]'s metadata, changes with that document under the rules that own it, and the document's earlier versions keep it; it is not a relation under *Nothing is deleted* below. A relation is a record the graph holds of its own. Where an installation holds no such record, its graph is the links of §3.1, and the points below that govern relations apply from when it declares one. The [instance appendix] marks each point below built or `not built`; a point not built is held by instruction and is not measured (GAL §9.2).

- **A closed set of relations.** A relation joins two entries, or an entry and a statement or a finding, and is one of: supports, contradicts, derived from, supersedes. The [instance appendix] may add relations for work that is not evidence, such as part of, depends on or blocks, each named there. A relation outside the set and the appendix's additions is a defect at the level that holds it. A finding drawn from several sources (§4.1) is joined to the entry for each source by derived from; supersedes is the relation of §4.2.
- **Provenance.** Every relation names who made it, when, why, and the record or source it was read in. A relation is a link: §3.2 holds for it, and it bears nothing until the entries at both ends have been read for it.
- **Nothing is deleted.** A relation is never changed or deleted. It is retired, with its reason, wrong or no longer true, and with who retired it and when. A new strength or a new period is a retired relation and a new one. §4.2 holds for entries.
- **Two times.** The graph keeps when each relation and each change of an entry's tier or status was recorded, and, where a relation holds only for a period, when it holds. It can be read as it was known at a moment and as true on a date. A statement carries the time its links were read, where the [instance appendix] names, so that it can be reproduced as it was read.
- **The validity of a claim.** A period of validity is set on a claim in a deliverable only from its source, and governs that claim, not the evidence a [contract] rests on.
- **Changes are proposals.** A relation an agent writes stands on that agent's authority from when it is written. Retiring a relation, retracting an entry or superseding one is a proposal to the owner of the statements that rest on it (§2.3), and the decision is logged.
- **A search of the graph.** A search names what it searched and what it could not: the count of nodes searched, and the count left out because they cannot yet be searched, such as nodes without an index entry. A search that searched nothing fails. An empty answer is not an absence: it says what was read and that nothing was found, as a claim that something does not exist names the search that did not find it (GAL §4.7.1 p. 2). Nothing that matches is dropped without being counted (GEM §1, nothing lost silently).

## 4. The evidence registry

### 4.1 The entry

An evidence entry has one ID from a source that never repeats, and these fields:

| Field | Meaning |
|---|---|
| source | The citation: authors, year, title, venue, and a persistent identifier where one exists |
| tier | A level from the [evidence tier set] |
| domain | The area of the [system] the entry serves, from a closed set the [instance appendix] names |
| key finding | What the source shows that the [system] uses, in the source's own terms |
| status | In force, superseded by a named entry, or retracted |

The [instance appendix] may add fields. An entry is written from a [research record] that read the source. An entry written from a citation alone, without the source read, is marked as such.

An entry reports one source: a finding drawn from several sources is not an entry. It stands in the [research record] that drew it, or in the statement it bears, and it links to an entry for each source it rests on, each read for it (§3.1, §3.2). A [research record] is written before its entries, so its links are made as the entries are written. A statement rests on such a finding only through entries that exist. The finding corroborates nothing beyond those entries, and it is never cited as a source of its own. Every figure in the key finding can be found in the source. A figure that cannot be found there is left out and flagged, never derived.

### 4.2 Lifecycle

- An entry is never deleted. A retracted entry stays with its status, so that every link to it can be found and judged.
- A superseded entry names the entry that replaces it. Links to it are moved in the next change of the statements that hold them.
- Two entries for the same source are one too many. The later one is superseded by the earlier, or the reverse, and links follow.

### 4.3 The mirror

- The entry's file is the record. The [database] is derived from it. Where the two differ, the file holds, and the [evidence sync] brings the [database] to the file.
- A row without a file and a file without a row are both differences, and the [evidence sync] reports both. A route that writes the [database] without writing a file is not permitted.
- Where the [instance appendix] declares a table as the record of the [evidence registry] (GEM §2.3), this section does not apply to it, and GEM §2.3 does.

## 5. Which links are checked when

The [instance appendix] states, for each link in §3.1, which tool checks it and when: at every commit, before a dispatch, after a batch of evidence entries, or by hand. A link that no tool checks is named as such, with the population at the commit that writes the line.

## 6. Tool classes

The [instance appendix] binds each class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [evidence sync] | The [database] brought to the [evidence registry] files | Every entry file, the [database] | Every file read, or named when it cannot be read; every field written as the file states it; both differences of §4.3 reported; two entries with one ID refused | A file skipped without a report; a value written that the file does not hold; a difference left unreported; a sync from zero files |
| [link check] | Whether every link of §3.1 that the tool covers names an entry that exists and is in force | The statements that hold links, the [evidence registry] | Every link to a missing, retracted or superseded entry named, with the statement that holds it | A link passed because its target was not read; a check over zero statements reported as clean |
| [citation check] | Whether a [contract]'s declared evidence and its cited evidence are the same set | The [contract] corpus | Every ID declared but not cited, and every ID cited but not declared, named | A contract passed because it was not read; a check over zero contracts reported as clean |
| [provenance check] | Whether an [evidence registry] entry agrees with its source | The entries, their sources | Every entry whose citation does not resolve, or whose fields disagree with the source, named; two entries for one source named | An entry marked as checked without its source read |
| [completeness gate] | The link from [contract] to [implementation], as in Contract Standard §9 | As in Contract Standard §9 | As in Contract Standard §9 | As in Contract Standard §9 |

**Zero result.** For every tool in the table, a missing input, an empty input, or a count of zero where the input plainly holds entries is a hard failure, never a reported value.

## 7. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A change to the order of authority (§2.1) is made by the [operator], and written to the [decision log].
