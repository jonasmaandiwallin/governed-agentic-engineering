---
document_title: "Backlog Standard"
version: "v0.9"
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
path: "standards/backlog-standard.md"
---

# Backlog Standard

## 1. Purpose and scope

An agent system that cannot say what is open, what is done and where a finding went reopens settled questions and loses open ones. This standard defines the backlog: the items a [system] keeps its work in, the form of an item, the statuses an item moves through, the rules for opening, carrying and closing an item, and what the tools that write and read the backlog must guarantee.

The GAL standard owns who maintains the backlog (the [architect], GAL §3) and where an agent reads its item (GAL §4.2, G5). The GEM standard owns what the memory says about an item (GEM §2.2, §5, §6). The GIP standard owns how an item reaches code (GIP §3, entry A). This standard owns the item itself and its lifecycle.

Four properties follow:

- **One source.** The item's own file is the record of the item. The index, the done log and the [database] are derived from the files, or written in the same operation as them, and never stand in for them.
- **One partition.** Every status belongs to exactly one of two classes, open or closed (§3). Every reader that asks "is this item open?" answers from that partition and from nothing else.
- **Nothing filed twice.** A finding goes to the open item that already carries its problem before a new item is opened (§4.1). Two items that do not know about each other leave one open after the other has solved it.
- **Nothing dropped.** A finding routed elsewhere is disposed of only when the receiving item holds it (§4.2).

Order and blocking between items are not in scope (§7).

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system whose work the backlog holds |
| [operator] | The person who decides what the agents leave open |
| [architect] | The agent that maintains the backlog (GAL §3) |
| [backlog] | The set of all items, open and closed |
| [backlog item], [backlog item ID] | A unit of work and its identifier |
| [backlog item label] | The prefix every [backlog item ID] carries |
| [item store] | The place the item files are kept, one file per item |
| [done log] | The append-only log of closures and reopenings (§5.2) |
| [backlog index] | The generated list of open items (§5.1) |
| [database] | The store that mirrors the items' fields for queries (§6) |
| [status set] | The closed set of status values, each assigned to the open or the closed class (§3) |
| [priority set] | The ordered set of priority values (§2.2) |
| [type set] | The set of type values (§2.2) |
| [reviewer] | The agent that reviews a change before an item that made it closes (GAL §1.2, row 4) |
| [allocator], [closer], [backlog index generator], [mirror sync], [status check] | Tools of the classes in §8 |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. The item

### 2.1 Identity

- An item has one [backlog item ID]: the [backlog item label], a separator and a number. The number is taken from a source that never hands out the same number twice, also when two agents ask at the same moment.
- An ID is never reused. A number that was handed out and not used — the call failed, the item was never written — stays spent, and no item file and no [database] row stand for it. An ID whose item was removed or superseded stays the ID of that item.
- The [instance appendix] may name IDs written in another form before it bound this standard. They are read as items under the rules of this standard and never written new.
- One item is one file in the [item store], named after its ID. A file in the [item store] that is not an item (the index, the done log, an attachment) is named so that no tool reads it as an item.

### 2.2 Fields

An item opens with a frontmatter block. These fields are required, with these meanings:

| Field | Meaning |
|---|---|
| `id` | The [backlog item ID], exactly as the file is named |
| `title` | One line saying what is wrong or what is wanted |
| `type` | A value from the [type set] |
| `status` | A value from the [status set] (§3) |
| `priority` | A value from the [priority set] |
| owner | The agents the item is for. The [instance appendix] names the field |
| `created` | The date the ID was handed out |
| `done_date` | The date the item entered the closed class, or empty while it is open |

An item closed as superseded also names the item or items that carry its work (§4.4). Every other field is optional. A field that no tool reads is free text, and the [instance appendix] says which fields a tool reads.

### 2.3 Body

The body is free, with three exceptions:

- An item opened from a finding names where the finding stands (a review file, a log entry, a report) and the duplicate search that was run before the item was opened (§4.1).
- An item that takes over a finding from elsewhere holds it by its text or a pointer to it (§4.2). The [instance appendix] may require more of an item with several parts — a closure criterion per part, and a section saying what happened to each before the item closes (§4.3).
- A section added later is added below the existing ones and dated, so that the history of the item reads from top to bottom.

## 3. Status

The [status set] is closed. Every value in it belongs to exactly one class:

- **Open.** The item is not finished: not started, in progress, blocked, or waiting for a decision by the [operator]. The [status set] has at least one value for each of these four states. An open item appears in the [backlog index] (§5.1).
- **Closed.** The item is finished. There are two closed states, and the [status set] has one value for each:
  - *done* — the work is finished, or what remains of it is carried by another item or declared not to be done (§4.3);
  - *superseded* — the item's work is carried by other items that it names (§4.4).

Rules:

- The open/closed partition is the only test of whether an item is open. The [backlog index], the [database]'s view of open items, the duplicate search (§4.1) and every tool that reads the backlog for another standard (GEM §5, §6.2) all take it from the [status set]. Two readers that partition differently report different backlogs, and the one that counts a closed item as open keeps it alive.
- A value outside the [status set] is a defect in the item. The [instance appendix] may name values written before the set was closed and say which class each is read as. A value it names this way is never written again.
- An item enters the closed class only through the [closer] (§4.3), and leaves it only through the [closer]'s reopening (§4.5). Any other change of status stays within the open class.

## 4. Lifecycle

### 4.1 Opening — search first

Before an ID is asked for, the backlog is searched for the finding's own names: the tool, file, section, table or rule it concerns. The search covers open and closed items, by title and by body.

- **An open item carries the problem or its class.** The finding is added to that item as a new dated section. No ID is asked for.
- **A closed item names the same defect.** It is read before anything is opened. Either it solved the problem, and nothing is opened, or it dropped it, and it is reopened (§4.5) rather than a new ID handed out.
- **Nothing carries it.** An ID is asked for from the [allocator]. The new item's body names the search that was run (§2.3), its reason — why the work is not done where it was found (GAL §4.7.2) — and its trigger: the event that brings it to work. A list of candidates is an item too, with a trigger. A finding of the advisory class may instead go to the next change of its surface (§4.2, third point).

### 4.2 Carrying

- A finding that a review, a session or a tool routes to "a follow-up item" is disposed of only when the receiving item holds it, by ID and with its text or a pointer to it. A finding routed to an item that does not exist was not disposed of.
- The [instance appendix] may require a part moved from one item to another to stay in the giver with the ID of the item that took it, so that the giver's closure (§4.3) accounts for it.
- **The advisory class.** The [instance appendix] may name a class of findings that a review marks as needing no change before the reviewed item closes. Such a finding may be routed to the next change of the surface it concerns — the file or files it names — instead of an item of its own, but only when the search of §4.1 has run in full, open and closed items alike, and found neither an open item that carries it nor a closed item that names the same defect. A closed item that names it is read and handled under §4.1's second point — it solved the problem, or it is reopened (§4.5) — never by this route. It is held, by its text or a pointer, in an open item that collects that class for that surface, or in the open item that next changes the surface; the first point applies to it unchanged. The [instance appendix] names the collecting items. An item that changes a surface reads, when it takes up the change, the collecting items for that surface, and takes every finding held for it; its closure (§4.3) says for each whether it was done, moved to a named item or declared not to be done. A finding outside the class is never routed this way.

### 4.3 Closing

An item closes when its work is finished, or when what remains of it is carried by a named item (§4.2) or declared not to be done. The [instance appendix] may require the item to state, before it closes, one of three outcomes for each part: done, moved to a named carrier, or declared not to be done, with the reason. Before it closes:

- **Review.** An item whose change touched infrastructure that two or more agents consume closes only after the [reviewer] has reviewed its final state (GAL §1.2, row 4). The [instance appendix] says what counts as such infrastructure and what satisfies the review.
- **One operation.** Closing writes, together: the item's `status` and `done_date`, a line in the [done log], the regenerated [backlog index], and the item's row in the [database]. A closure that reaches some of these and not others is reported as such by the [closer] and is not a closure.

An open item whose problem another item solved as a side effect, with no one closing it, is found by the duplicate search of §4.1, which reads closed and open items alike, the next time its names come up. This standard does not require a sweep of the open items at every closure. An [instance appendix] that measures such misses may add one.

### 4.4 Superseding

An item is superseded when its work is carried by other items. It names them in a field the [instance appendix] binds. A superseded item is closed: it leaves the [backlog index] and the [database]'s view of open items. Superseding by an item that does not carry the work — absorbed and then dropped — is the failure §1 names, and can be undone by reopening (§4.5).

### 4.5 Reopening

A closed item is reopened when its work turns out not to be done, or not carried. Reopening moves `status` back to a value in the open class and clears `done_date`, writes a reopening line in the [done log], regenerates the [backlog index] and updates the [database], in one operation, like a closure. The [done log] keeps the earlier closure line; a second closure after a reopening gets a line of its own.

## 5. Index and done log

### 5.1 The backlog index

- The [backlog index] is generated from the item files by the [backlog index generator] and is never edited by hand.
- It lists every item in the open class (§3), and only those, grouped by priority in the order of the [priority set] and by ID within a priority. An open item whose priority is not in the [priority set] is listed in its own group and named in the generator's report, never left out.
- It states the next ID the [allocator] is expected to hand out, or that it cannot say.
- It is regenerated by every operation that changes an item's class (§4.3, §4.5) and before every commit that changes an item file.

### 5.2 The done log

- One line per closure and one per reopening, appended, never edited or removed: the ID, the date, and a short description of what was done or why it was reopened.
- Every item in the closed class has a closure line, and every reopening has a line, in the order they happened.

## 6. The database mirror

- The [database] holds, per item, the fields of §2.2. It is written by the [allocator], the [closer] and the [mirror sync], and by nothing that does not also write the file.
- The file is the record. Where the file and the [database] differ, the file holds, and the [mirror sync] brings the [database] to the file.
- A row without a file and a file without a row are both differences, and the [mirror sync] reports both.
- The [database]'s view of open items uses the partition of §3.

## 7. Order and blocking

This standard does not govern which item waits for which. The [backlog index] orders by priority and ID. It does not say what waits for what. The Wave Standard governs it: the edge a waiting item writes, the done condition of an item or of a part of one, the wave, and the sweep that derives an order from them. Fields that name other items and that the Wave Standard does not bind — parent, related and the like, and the fields an [instance appendix] keeps as free text — are free text under §2.2. An order that matters is written in the items it concerns, never only in a session's handoff.

## 8. Tool classes

The [instance appendix] binds each class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [allocator] | A new ID and the item file with the fields of §2.2; the item's row in the [database] | Title, type, priority, owner | One ID per call from a source that never repeats; the file written; the row written, or its absence reported in the answer | An ID handed out twice; an existing file overwritten; a missing row reported as written |
| [closer] | The closure (§4.3) or reopening (§4.5): `status`, `done_date`, the [done log] line, the [backlog index], the [database] row | The ID, a description, the date | All four written, or the answer names which were not; a reopening that does not reach the [database] reported as a failure | A closure reported as complete when a part of it was not written; a reopening to a closed-class value; a closure while an implementation post dispatched for the item (GIP §3) is not finished |
| [backlog index generator] | The [backlog index] | Every item file in the [item store] | Every file read or named in the report; every open-class item listed; a priority outside the [priority set] listed and named | A file skipped without a report; an item of the closed class listed as open, or one of the open class left out; an index written from zero item files |
| [mirror sync] | The [database] rows brought to the files | Every item file, the [database] | Every file's fields written as they stand; every row without a file and every file without a row reported | A value written that the file does not hold (a default in place of a missing field); a difference left unreported |
| [status check] | Whether named items stand in the statuses a session expects | ID–status pairs | Each pair compared and every difference reported; a fix applied only within the open class | A move into or out of the closed class, which is the [closer]'s (§3) |

**Zero result.** For every tool in the table, a missing input, an empty input, or a count of zero where the [item store] plainly holds items is a hard failure, never a reported value. A zero that a broken reader produced looks the same as an empty backlog, and only the failure tells them apart.

## 9. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A change to the [status set] or to its partition (§3) is made together with every tool bound to §8 and every reader named in §3, in the same pass. A partition one reader has not learned makes two backlogs.
