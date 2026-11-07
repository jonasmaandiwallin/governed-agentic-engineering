---
document_title: "Registry Standard"
version: "v0.5"
status: "draft"
created: "2026-10-13"
last_updated: "2026-11-07"
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
path: "standards/registry-standard.md"
---

# Registry Standard

## 1. Purpose and scope

A number written into a contract, or into the code that implements it, goes stale where it stands. When the value changes, every copy has to be found, and the copy nobody found keeps the old value. This standard defines the registry: the one store of the values that a [system]'s contracts govern. It covers the form of an entry, how a contract and an implementation reference an entry, how an entry is added, changed, deprecated and removed, and what the tools that write and read the registry must guarantee.

The Contract Standard owns the rule that a contract cites a governed value by key and never inline (Contract Standard §7.2), and it owns the [completeness gate] (Contract Standard §9). The GIP standard owns how an implementation reads the registry before and during a build (GIP §4.2, point 2). The GEM standard owns the form of the log entry that a change writes (GEM §4.1). This standard owns the registry itself.

Four properties follow:

- **One value, one place.** A governed value stands in the registry under one key. Contracts and implementations carry the key, never the value.
- **Every value says where it came from.** An entry names its source, the evidence that bears the value, how sure the value is, and how it was derived from its source. A value that cannot say this is incomplete, and is reported as incomplete.
- **Contract first.** A key exists because a contract specifies the value. A value that an implementation needs, and that no contract specifies, is a finding against the contract. It is never a reason to add a key.
- **Nothing silently lost.** A key is removed only when nothing references it. Until then a deprecated key keeps its value and names what replaced it.

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system whose contracts the registry serves |
| [operator] | The person who decides what the agents leave open |
| [architect] | The agent that maintains the registry's tools (GAL §3) |
| [registry] | The file, or files, that hold the governed values, one entry per key |
| [contract] | A document in the [system]'s contract corpus (Contract Standard) |
| [implementation] | The code that executes the contracts (GIP); in a knowledge corpus, the deliverables the agents produce (Truth Chain Standard §1.1) |
| [evidence registry] | The store of evidence entries, referenced by ID |
| [confidence set] | The ordered closed set of confidence levels |
| [derivation class set] | The closed set of classes that say how a value relates to its source |
| [derivation definitions] | The one document that defines each class in the [derivation class set], with the fields each class requires |
| [database] | The store that mirrors the registry for reading by key |
| [decision log] | As in the GEM standard |
| [reference form] | How a contract cites a key |
| [registry sync], [registry reader], [code sweep], [hardcode sweep], [completeness gate] | Tools of the classes in §6 |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. The entry

### 2.1 Key

- A key is unique in the [registry] and names what the value governs. The [instance appendix] states the naming convention.
- A key never carries a version number or a backlog item ID. A value changes under its key. A different meaning gets a new key.
- Two keys never govern the same condition, unless one of them is deprecated in favour of the other (§4.3).

### 2.2 Fields

Every entry carries these fields. The [instance appendix] states how each is written.

| Field | Meaning |
|---|---|
| value | The governed value |
| governs | One sentence: what the value controls |
| source | Where the value came from: the decision, the backlog item or the document that set it |
| evidence | The list of [evidence registry] IDs that bear the value, or an explicit statement that none does. An empty field is never allowed. Evidence named in other fields is not a link (Truth Chain Standard §3.2). |
| confidence | A level from the [confidence set] |
| derivation | A class from the [derivation class set]. The class's fields in the [derivation definitions] are required with it |

An entry that lacks a required field is incomplete. An incomplete entry stays readable, and the [registry sync] names it as incomplete (§6). A [registry reader] returns it with the fields it has. A field an entry does not need for its class stays absent; it is never filled with a default.

The [instance appendix] may add fields, such as a record of a search for evidence that was made and found nothing. An added field never changes the meaning of the six above.

### 2.3 Derivation classes

The [derivation class set] is closed, and its classes are defined in one place, the [derivation definitions]. A class is added only together with every tool and every store that validates the set, in the same change. A set that one validator has not learned rejects valid entries or accepts invalid ones.

## 3. References

- A [contract] cites a governed value by its key, in the [reference form]. The value itself never stands in the contract (Contract Standard §7.2).
- An [implementation] reads a governed value by key from the [registry] or the [database]. A literal in code that equals a registry value is a hardcode, whether or not the key exists.
- A key that a [contract] cites exists in the [registry]. A citation of a key that does not exist is a defect in the contract.
- Keys that share one formula, one source or one concept, such as the coefficients of one curve or the tiers of one threshold, form a family. A [contract] names every key of a family in the [reference form], even where it explains the family or cites its evidence once. A description of the family is not a citation of its keys.

## 4. Lifecycle

### 4.1 Adding

A key is added when a [contract] specifies a value that the [registry] does not yet hold. The entry is complete when it is added (§2.2). The [instance appendix] says who adds a key and what review an addition gets.

An [implementation] that needs a value no [contract] specifies reports it as a finding against the contract. The key is added after the contract specifies the value, with the evidence the contract cites. A key already read by an implementation, whose value no contract specifies, is examined against its evidence. It is not confirmed because the implementation already uses it.

### 4.2 Changing a value

A value changes in the [registry] only. Every change writes a [decision log] entry with the reason and the source of the new value, and the [instance appendix] adds the change as an event under GEM §4.3. The [instance appendix] says what review a change of value gets. A [contract] that cites the key is correct after the change without being edited.

### 4.3 Deprecating and removing

- A key is deprecated by a marker in its entry: the date, the backlog item, and the key or keys that replace it, or that nothing does. The key keeps its value.
- A deprecated key is removed only when all three hold: the replacing key is in force and reviewed, no [contract] cites the deprecated key, and the waiting period the [instance appendix] sets has passed since the deprecation. A [contract] that still cites a deprecated key holds a defect (Truth Chain Standard §3.2); the second condition is met when those defects are corrected.
- A key is never removed in any other way.

### 4.4 Version

Every change to the [registry] raises its version.

## 5. The database mirror

- The [registry] file is the record. The [database] is derived from it. Where the two differ, the file holds, and the [registry sync] brings the [database] to the file.
- The [database] holds, per key, every field of §2.2 as the file states it, and whether the key is deprecated.
- A key removed from the file is removed from the [database]. A row without a key in the file and a key without a row are both differences, and the [registry sync] reports both.
- The [registry reader] reads by key. An unknown key is an error, never an empty answer. A deprecated key is returned marked as deprecated.
- A value reaches the [database] only through the [registry sync], from the file. A value in the [database] that the file does not hold is a difference to report, never a source: no [contract] takes it, and no key is added from it.

## 6. Tool classes

The [instance appendix] binds each class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [registry sync] | The [database] brought to the [registry] | The whole [registry], the [database] | Every entry read, or named in the report when it cannot be read; every field written as the file states it; every incomplete entry named; removed keys removed; both differences of §5 reported; a failed write reported as a failure | An entry skipped without a report; a value written that the file does not hold, or a field the file holds left unwritten; a write reported as done when it was not; a sync from zero entries |
| [registry reader] | One governed value, by key | A key | The value and its fields; a deprecated key marked | An unknown key answered with an empty or default value |
| [code sweep] | Literals in the [implementation] that equal a registry value or carry a key's name without reading it (§3) | The [implementation]'s code, the [registry] | Every such literal named, with its file and the key it matches; every key the code reads that is not in the [registry] named | A literal passed because its file was not read; a sweep over zero files or zero keys reported as clean |
| [hardcode sweep] | Values in a [contract] that should cite a key | A [contract], the [registry] | Every governed value written inline named, with the key it matches if one exists; every cited key checked to exist | A document passed because it was not read; a cited key that does not exist passed; a sweep over zero documents reported as clean |
| [completeness gate] | As in Contract Standard §9 | | | |

**Zero result.** For every tool in the table, a missing input, an empty input, or a count of zero where the [registry] plainly holds entries is a hard failure, never a reported value.

## 7. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A change to the [derivation class set] or the [confidence set] is made together with every tool bound to §6 that validates it, in the same pass (§2.3).
