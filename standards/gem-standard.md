---
document_title: "Governed Engineering Memory Standard"
version: "v0.12"
status: "draft"
created: "2026-10-13"
last_updated: "2026-11-12"
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
path: "standards/gem-standard.md"
---

# Governed Engineering Memory Standard

## 1. Purpose and scope

An agent system that does not remember its own friction repeats it. This standard defines the Governed Engineering Memory (GEM): the records a [system] keeps of its own work, the form of each record, how the records reach a [database], and how an agent gets back what applies to its task. It is requirement 5 of the GAL standard ("the system learns without human memory").

The GAL standard owns when an agent writes and reads the memory: the retro entry at session close, the `Learnings:` line of the start receipt, and the recall obligation at decision points (GAL §4.2, §4.4, §4.5). This standard owns what is written, what a reader is given, and what the tools between them must guarantee.

Four properties follow:

- **Append-only.** A log entry is never edited or removed after it is written. A correction is a new entry. The state the [database] keeps beside the logs — read tracking and dispositions — is not a log entry; §2.1 says what holds for it.
- **One form per record.** Every entry in a log has the form this standard gives it, so that a parser reads every entry or reports the one it could not read.
- **Nothing lost silently.** Every tool between the log and the reader reports what it did not carry. A memory that drops an entry without saying so is worse than none, because the reader trusts it.
- **Read is measured.** Whether a learning was given to an agent, and whether it changed what the agent did, is recorded, not assumed.

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system whose agents keep the memory |
| [operator] | The person who decides what the agents leave open |
| [architect] | The agent that maintains the logs, the tools and the dispositions |
| [retro log] | The append-only log of session retro entries (§3) |
| [decision log] | The append-only log of decisions and events (§4) |
| [database] | The store the parsers write and the learnings function reads |
| [backlog item], [backlog item ID] | A unit of work and its identifier. Whether an item is open or closed — "an open item" and "closes" in §6.2 — is the partition of the Backlog Standard §3, which [pattern triage] reads as an input (§8) |
| [governed corpus] | The documents the [system] governs, whose changes the [decision log] records. A *contract* in this standard is a document in the [governed corpus]; an installation that calls its documents otherwise still names them in the field `Affected contracts` (§4.1) |
| [governance document] | A document that states how the [system]'s agents work — an agent's instructions, a process rule, a standard, a tool's binding — as distinct from a document in the [governed corpus]. The [instance appendix] says where they stand |
| [dependency] | A reference by which one document in the [governed corpus] relies on another, so that a change to the one can change what the other means. The [instance appendix] says which references count |
| [report path] | The path by which an implementation agent's session reports to the [architect] (GIP) |
| taxonomy | An optional set of tags a [retro parser] assigns to an entry by matching its text. A taxonomy tag is never a pattern name (§3.2) |
| [retro parser], [decision log parser], [learnings function], [pattern triage], [consult metric] | Tools of the classes in §8 |
| [retro key registry] | The table that maps each agent's retro key to its canonical name (GAL §7 row 11) |
| [classification set], [decision type set] | The closed set a decision entry takes its classification from, with the alias table that maps written values to it; and the closed set of types a tool acts on, each with its exact form (§4.2) |
| [triage threshold] | The count of undisposed occurrences of a named pattern at which [pattern triage] opens a backlog item (§6.2) |
| [learnings cap] | The number of rows the [learnings function] returns before it truncates (§5.2) |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. The logs

### 2.1 What is kept

A [system] keeps two logs and a mirror of them:

- **[retro log]** — one entry per substantive agent session, written at close. It carries the session's friction (§3).
- **[decision log]** — one entry per governed event: a decision, a change of a governed document, a gate passed, a tool deployed (§4).
- **[database]** — the parsed form of both logs, which the [learnings function] and the views of §6 read. The logs are the record. The [database] is derived from them and can be rebuilt from them, with two exceptions that exist only in the [database]: read tracking (§7.1) and dispositions (§6.1). Both survive every rebuild of the [database] from the logs; a rebuild that loses either is a failed rebuild. Neither is a log entry, so neither is append-only: a read updates read tracking, and a new disposition replaces the one before it (§6.1).

### 2.2 Rules for both logs

- An entry is appended, never inserted between existing entries, edited or removed. A wrong entry is followed by a correcting entry that names it.
- An entry is written in the same session as the work it records, and committed with the [system]'s ordinary commit path. An entry that exists only in an agent's context is not in the log.
- An entry names the [backlog item ID]s it concerns. An entry that names none can be read by date and agent, but not by task.
- The [instance appendix] names each log's path and the commit operation used to append to it.

## 3. Retro entry

### 3.1 Form (invariant)

A header line, then three fields in this order, each on one line:

```
RETRO [RETRO_KEY] [YYYY-MM-DD]:
- Scope: [what was done]
- Friction: [what was unnecessarily difficult or required extra rounds]
- Pattern: [systemic pattern identified, or "none"]
```

- `[RETRO_KEY]` is the writing agent's key in the [retro key registry]. A key the registry does not map leaves the entry stored but unattributed, which is a registration defect, not a format choice.
- No field is empty. A session without friction writes that in `Friction:`, and a session without a pattern writes `none` in `Pattern:`.
- The [backlog item ID]s the entry concerns (§2.2) are named in `Scope:`.
- A trivial session — a single question, no file written, no commit — writes no entry.

### 3.2 Naming a pattern

- A pattern is named by opening the `Pattern:` field with its name, in kebab-case, before any explanation: `Pattern: write-before-read — …`. Several names are separated by commas before the explanation.
- A name, once used, means the same thing in every later entry. A new name is used only when no existing name fits. The names in use are those the [retro log] carries; the [database] derives them from it, so they are rebuilt with it.
- A pattern field that opens with `none` (or its equivalent in the [instance appendix]'s language) declares no pattern, whatever follows.
- A name is what [pattern triage] counts (§6) and what the [learnings function] groups by (§5). An entry whose pattern is described but not named is read by the [retro parser]'s taxonomy, if it has one, and that reading is never counted as a name.

### 3.3 Implementation sessions

An implementation agent's session (GIP) writes its retro entry in the same form and carries it in its final report through the [report path]. The [architect] enters it in the [retro log], which stays the single record. A retro held only in a report is not in the memory.

## 4. Decision entry

### 4.1 Form (invariant)

```
### [YYYY-MM-DD] — [TYPE] — [Title] ([backlog item ID])

- **File:** [affected file path]
- **Classification:** [one value from the classification set]
- **Affected contracts:** [list, or none]
- **Decision:** [one sentence]
- **Logged by:** [agent]
```

- The heading is a level-3 heading with three parts separated by ` — `. A tool that reads a decision entry identifies it by this heading alone. The brackets in the form mark placeholders: the date is written without them. The backlog item part names one ID, or several separated by commas, and is left out with its parentheses when the entry concerns none.
- `[TYPE]` is free text, except a type in the [decision type set] (§4.2). A type that a tool acts on — such as a gate record (GIP §4.2) — has its exact form in the [instance appendix], heading and fields, and the tool reads only that form. Where that form gives its own fields, they take the place of the five above; the heading keeps the form above.
- `Decision:` is one sentence. Reasons and measurements follow below the fields, not inside them.

### 4.2 Closed sets

The [classification set] is closed in the [instance appendix]. A value outside it is written only after the appendix has been changed to admit it.

The [decision type set] is the set of types a tool acts on, each with its exact form (§4.1). It is closed in the [instance appendix]. A tool acts on no type outside it, and a writer that means a type in it writes that type's form exactly.

The [decision log parser] maps the written classification to the set through the appendix's alias table, by the match rule the appendix states. A written value that is exactly a value of the set, or exactly one key of the table, is stored under that class. Any other written value — one the table does not cover, one that names several values, or one that qualifies a value — is stored without a class, or under the class the rule gives it with the written value named beside it in the parser's report. A mapping by any other rule, to a value outside the set, or of such a value without the report naming it, is a guess (§8).

### 4.3 When an entry is due

An entry is written in the same session as each of these events:

1. A document enters the [governed corpus], or leaves it.
2. A [governance document] changes.
3. The [operator] confirms a design decision that no entry under another event of this list records.
4. A [backlog item] closes whose own work made a structural change to the [governed corpus]: documents added, removed, split, merged or moved, or a [dependency] between them added or removed. A change to the text of a document that stays one document, in its place, with its [dependency] references is not structural. What one document is, and what its place is, the [instance appendix] says with the [governed corpus].
5. A tool, gate or server that agents use is deployed or changed.
6. A gate that the GIP standard routes through the [decision log] is passed or re-passed.

The [instance appendix] may add events. It may not remove one.

## 5. The learnings function

### 5.1 What a reader is given

The [learnings function] takes a [backlog item ID] and returns the retro entries that concern it, as rows. A row carries at least: the source of the match, the pattern name or tag, an excerpt of the friction, an excerpt of the pattern, the entry date, the writing agent and the backlog item.

- **Direct before indirect.** Entries that name the item come first. Entries reached through a relation the [instance appendix] defines — the same contract, a parent item — come after them.
- **One row per named pattern.** Several entries with the same pattern name are one row: the latest entry is shown, and the row states how many other entries it stands for. An entry without a named pattern is its own row.
- **No learning without a pattern.** An entry whose pattern field declares none (§3.2) is not returned as a learning.

### 5.2 Truncation is visible

The function returns at most [learnings cap] rows. When it cuts rows — direct or indirect — it returns a last row that states how many rows of each kind were shown out of how many, and how to read them all. The truncation row is not counted against the cap. A cut without that row is a silent loss (§1).

### 5.3 Reading is not mutation

A call of the [learnings function] changes nothing in the logs. It may record that rows were returned (§7.1), and only that.

## 6. Pattern triage

### 6.1 Disposition

A named pattern is either undisposed or disposed. A disposition is a record in the [database] that names the pattern and the date, and is one of two kinds:

- **A countermeasure.** It names the [backlog item] that carries the countermeasure. Only the [architect] writes it, and only after that item exists. A countermeasure whose item does not exist leaves the pattern undisposed.
- **No countermeasure.** The pattern is accepted or set aside without one, and the record carries a re-review date. From that date the pattern is undisposed again, and every occurrence counts, those before the disposition included. A record of this kind without a re-review date is a defect in the record, not a disposition for good. It may name a [backlog item] for reference; that does not make it a countermeasure.

Only the [architect] writes a disposition, of either kind. A pattern has at most one disposition at a time: a new one for the same pattern replaces the one before it, and that is the only way a disposition changes. Whether a replaced disposition is kept is stated in the [instance appendix].

The [instance appendix] names the kinds it uses and which of the two each is.

### 6.2 Triage

- When a named pattern reaches [triage threshold] undisposed occurrences, [pattern triage] gives it a [backlog item] as Backlog Standard §4.1 says: an open item that carries it takes it, a closed item that names it is reopened (Backlog Standard §4.5), and a new item is opened only when nothing carries it. An order already in progress (Handoff Standard §5 p. 7) never takes a countermeasure: the countermeasure gets an item of its own, or waits in the item that carries it until that order closes. A blocking finding in the work itself is still fixed in its round (GAL §4.7.2). This protects against triage feeding the order whose own reviews produced the pattern.
- A countermeasure takes effect when its [backlog item] closes. An occurrence of the pattern dated after the later of the disposition and that closure is a regression. [pattern triage] reports every regression, with the entries that make it. An occurrence while the countermeasure's item is still open is not a regression, and a disposition without a countermeasure has none: its re-review date brings the pattern back.
- [pattern triage] counts names (§3.2) only. A taxonomy reading is never an occurrence.
- The [instance appendix] states when [pattern triage] runs and who starts it, or that nothing runs it on a schedule. Between runs a pattern at threshold or a regression can stand without an item, and the appendix says how that is seen.
- A disposition does not close because its [backlog item] closed. The pattern stays disposed until a regression is reported. A regression shows that the countermeasure did not hold: the countermeasure's closed [backlog item] is reopened (Backlog Standard §4.1, §4.5), and no new item is opened for it.

## 7. Consultation

### 7.1 Read tracking

Each time the [learnings function] returns an entry, the [database] records that it was read and when. Read tracking survives every rebuild of the [database] from the logs: a rebuild that loses it is a failed rebuild, not a fresh start.

### 7.2 Whether a learning changed anything

The GAL standard makes the reading visible (`Learnings:` in the start receipt; `Learnings consulted:` in a handoff, GAL §4.5). An [instance appendix] may ask more of that line. The [consult metric] measures whether entries that were read are followed by a change in the pattern they name — fewer occurrences, a disposition, a regression. An entry that is never read is reported by agent and pattern, so that a learnings function that returns nothing for an agent is seen.

## 8. Tool classes

The [instance appendix] binds each class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [retro parser] | The [database] form of every retro entry: key, canonical agent, date, the three fields, the backlog item IDs, the pattern names in order | The whole [retro log], the [retro key registry] | Every entry in the log either stored or named in the report (§1); the stored count checked against a count of the log's entries made by a rule looser than the parser's own heading rule, so that an entry the parser does not recognise is counted; read tracking (§7.1) carried over from the previous rebuild | Zero entries parsed; an entry in the log neither stored nor named in the report; a stored entry that carries another entry's fields; a stored count checked only against the parser's own parsed count; an entry whose key the registry does not map reported as attributed; read tracking lost in a rebuild; a taxonomy reading stored as a pattern name |
| [decision log parser] | The [database] form of every decision entry: date, type, title, backlog item IDs, the five fields, the classification mapped to the [classification set] through the alias table (§4.2) | The whole [decision log], the alias table | Every entry in the log either stored or named in the report (§1); the stored count checked against a count of the log's entries made by a rule looser than the parser's own heading rule; each written classification handled as §4.2 says | Zero entries parsed; an entry in the log neither stored nor named in the report; a stored entry that carries another entry's body or fields; a stored count checked only against the parser's own parsed count; a classification mapped by a rule the [instance appendix] does not state, or to a value outside the set; a written value that is not exactly a value or a key (§4.2) stored under a class without the report naming it |
| [learnings function] | The rows of §5 for one [backlog item ID] | The [database] | The rows of §5.1, at most [learnings cap], with the truncation row when it cuts; read tracking recorded | A cut without the truncation row; an entry that declares no pattern returned as a learning; a change to any entry beyond read tracking |
| [pattern triage] | Backlog items for patterns at [triage threshold]; the list of regressions | The [database], its dispositions, and the status of each carrier item (open or closed, Backlog Standard §3) | Every named pattern at threshold given an item as §6.2 says, or shown as carried by an open item; every regression listed, and its countermeasure's item reopened | A taxonomy reading counted as an occurrence; a pattern at threshold neither opened nor carried; a regression left out; a new item opened where a closed item carries the pattern or the regression |
| [consult metric] | For each read entry, whether its pattern recurred, was disposed or regressed after the read; unread entries by agent and pattern | The [database] with read tracking | A report over every entry with read tracking | An entry without read tracking counted as read; an empty report presented as "all learnings applied" |

**Zero result.** For every tool in the table, a missing input, an empty input, or a count of zero where the logs plainly hold entries is a hard failure, never a reported value. A zero that a broken reader produced looks the same as a zero the logs hold, and only the failure tells them apart.

## 9. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- The retro entry form (§3.1) and the decision entry form (§4.1) change only together with every tool bound to §8, in the same pass. A form change that a parser has not learned turns every new entry into a silent loss.
