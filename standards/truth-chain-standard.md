---
document_title: "Truth Chain Standard"
version: "v0.5"
status: "draft"
created: "2026-10-13"
last_updated: "2026-11-01"
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
| [constitution] | The document that states what the [system] is for and the constraints every contract serves |
| [contract] | A document in the contract corpus (Contract Standard) |
| [registry] | The store of governed values (Registry Standard) |
| [evidence registry] | The store of evidence entries, one per source |
| [research record] | The record of a research round: what was searched, read and concluded, before an evidence entry is written |
| [advisory] | Guidance the [system] may show or use for tone and wording, which never changes behaviour |
| [implementation] | The code that executes the contracts (GIP) |
| [evidence tier set] | The ordered closed set of evidence strength levels |
| [decision log] | As in the GEM standard |
| [database] | The store that mirrors the [evidence registry] for queries |
| [evidence sync], [link check], [citation check], [provenance check], [completeness gate] | Tools of the classes in §6 |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. Levels and authority

### 2.1 Order of authority

From highest to lowest:

1. [constitution]
2. [contract], together with the [registry] values it cites by key
3. [implementation]

[advisory] has no authority over behaviour at any level. [evidence registry] and [research record] are not levels of authority: they are the ground that statements at levels 1–2 rest on, and they change a level only through §2.3.

### 2.2 Conflicts

When two statements at different levels conflict:

1. The higher level holds.
2. The conflict is written to the [decision log], with both statements and where they stand.
3. The lower statement is updated or deprecated, in the next change the [instance appendix] names for that level.

A conflict between two statements at the same level is resolved by the rules that own that level: Contract Standard §6 for contracts, Registry Standard §2.1 for keys.

### 2.3 How evidence changes the chain

- A finding from a [research record] or an [evidence registry] entry that would change a [contract] or a [registry] value becomes a proposal to the owner of that statement. It is never applied directly.
- A [contract] that conflicts with the [constitution] is invalid until the [constitution] is changed by its own process.
- An [implementation] never contains logic that no [contract] or task specification with a passed gate specifies (GIP §3, §4).

## 3. Links

### 3.1 The links

| From | Points to | Where the link stands |
|---|---|---|
| [implementation] | The [contract] it implements | A marker in the code, or the task specification of its build (GIP §4) |
| [contract] | The [registry] keys it cites, and the [evidence registry] entries it rests on | Key citations in the body (Contract Standard §7.2); evidence IDs in its metadata and its body |
| [registry] entry | The [evidence registry] entries that bear the value, or an explicit statement that none does | Registry Standard §2.2 |
| [evidence registry] entry | Its source, and the [research record] that admitted it | §4 |

### 3.2 Rules for links

- A link names an entry that exists and is in force. A link to an entry that is missing, retracted or superseded is a defect at the level that holds the link. A [registry] key is superseded from its deprecation: a [contract] that cites a deprecated key holds a defect from that day, however long the [registry] keeps the key before removing it (Registry Standard §4.3). The defect is corrected when the [contract] cites the key that replaces it, or, where nothing replaces it, when the [contract] no longer cites the key and the text that rested on its value is changed or removed with an entry in the [decision log] (GEM §4.3).
- The evidence IDs a [contract] declares in its metadata, and the ones its body cites, are the same set.
- Evidence named in prose does not count as a link unless it stands in the field or citation form the [instance appendix] names.
- A link carries no more strength than its source. A statement that rests on an entry of a low tier says so, or the [instance appendix] names where its confidence stands (as Registry Standard §2.2 does for values).

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

### 4.2 Lifecycle

- An entry is never deleted. A retracted entry stays with its status, so that every link to it can be found and judged.
- A superseded entry names the entry that replaces it. Links to it are moved in the next change of the statements that hold them.
- Two entries for the same source are one too many. The later one is superseded by the earlier, or the reverse, and links follow.

### 4.3 The mirror

- The entry's file is the record. The [database] is derived from it. Where the two differ, the file holds, and the [evidence sync] brings the [database] to the file.
- A row without a file and a file without a row are both differences, and the [evidence sync] reports both. A route that writes the [database] without writing a file is not permitted.

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
