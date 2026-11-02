---
title: "Context, Coherence and Memory: How an Agent System Remembers What Its Agents Forget"
type: white-paper
status: draft
version: "v0.2"
date: "2026-11-02"
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
  - model: "Claude Opus 5.5"
    model_id: "claude-opus-5-5"
    roles: [drafting, technical-analysis, editing]
    source: platform
  - model: "Claude Opus 5.5"
    model_id: "claude-opus-5-5"
    roles: [fact-check]
    source: handoff
  - model: "Claude Fable 5.1"
    model_id: "claude-fable-5-1"
    roles: [review]
    source: handoff
ai_disclosure:
  - role: drafting
    status: complete
    scope: "Text and structure of v0.1 (2026-10-16), written in a session whose handoff named the model, and in v0.2 § 3.8 and § 4 rewritten for the session start and the register of inherited measurements."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, each with the rule that reproduces it; dated events read in its logs; statements about its tools read in its instance appendix."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 2 and § 3 rewritten as explanation with pointers, where v0.1 restated the GEM, Backlog and Wave Standards closely; the database's two records that cannot be rebuilt from the logs corrected; where the reference installation departs from the standard on naming and regressions stated; the session start's sensors and the register of inherited measurements added; § 4 recounted; Limitations brought up to date with the release's known issues; the map pointed at the release."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 (Spotify, Osmani, Uber, Warp) checked against their primary sources by Research Pipeline on 2026-10-19; the Spotify article page read again on 2026-11-02."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings; two advisory findings stay open for the next revision: sentences sharing a run of ten or more words with the standards' wording, and a release-tool form that none of the twelve papers contains."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/context-coherence-memory.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gem-standard.md
    version: "v0.10"
  - path: standards/backlog-standard.md
    version: "v0.8"
  - path: standards/wave-standard.md
    version: "v0.3"
  - path: standards/gal-standard.md
    version: "v1.76"
---

# Context, Coherence and Memory: How an Agent System Remembers What Its Agents Forget

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*Every agent session starts with an empty head. This paper is about what the system keeps so that the next session does not have to learn everything again — and about why keeping it is not enough unless the keeping itself is governed.*

---

## 1 — The Problem: Agents Forget, the System Must Not

A language-model agent remembers nothing between sessions. Whatever it learned in the last session — that a tool fails on a certain kind of path, that a check passed for the wrong reason, that a piece of work is already done — is gone when the session ends. The next agent, or the same agent tomorrow, starts from what it can read.

In a single conversation this is a nuisance. In a system where many agents work on the same codebase and the same documents over months, it becomes the main source of waste. The same friction recurs because no one remembers it. Settled questions are reopened because the decision is somewhere in a transcript. Finished work stands as open because the session that finished it did not say so where the next session looks. An open question disappears because it was routed to "a follow-up" that was never written.

Software teams know a milder form of this problem. People forget too, and teams answer with issue trackers, decision records and retrospectives. Those tools assume a reader who remembers some of the context and fills the gaps. An agent fills the gaps with plausible guesses. A tracker that says an item is open is read as "this item is open", whether or not the work was quietly finished last week.

So the question this paper answers is not "how do we give agents a memory?" — every agent system with a log has one. It is: **what does a memory have to guarantee before an agent can trust it?**

---

## 2 — What It Is: Three Records and the Order Between Them

Governed agentic engineering (GAE) keeps the system's memory in three records, each with a different job, and one structure that orders the work across them.

- **The retro log** records friction: what each substantive session did, what was unnecessarily hard, and which systemic pattern it showed. It is the record of *what went wrong and how*.
- **The decision log** records governed events: a decision, a change to a governing document, a gate passed, a tool deployed. It is the record of *what was decided and when*.
- **The backlog** records work, one item per unit, each either open or closed. It is the record of *what is still to do*.
- **Waves** order the backlog. An item that waits for another names it and says what would make it done, and a sweep derives what is ready. It is the record of *what comes next*.

The two logs are mirrored into a database, which tools read to answer what a log cannot: which learnings concern this item, which pattern has recurred often enough to need a fix, which entries have ever been read. The logs are the record, and the database is rebuilt from them — except for two things that exist only in the database and must survive every rebuild: which entries have been read, and which patterns have been disposed of (GEM Standard §2.1).

Each record has a standard, and this paper does not restate their rules. The Governed Engineering Memory (GEM) Standard covers the two logs, the learnings an agent is given and the triage of recurring patterns; the Backlog Standard the item and its lifecycle; the Wave Standard order and the sweep. The Governed Agent Lifecycle (GAL) Standard says *when* an agent writes and reads them: at session close, at session start (§4.2) and at the decision points in between (§4.5).

---

## 3 — The Load-Bearing Ideas

### 3.1 Append-only, one form per record

A log entry is never edited or removed, and a wrong entry is followed by one that corrects it (GEM Standard §2.2). This is not archival tidiness: it is what makes the log readable by a machine. If entries can change after they are written, a parser that read the log yesterday and one that reads it today disagree, and neither knows which is right.

Each record also has one fixed form (GEM Standard §3.1, §4.1). A free-form log is easy to write and impossible to count. With a fixed form, a parser can read every entry — or name the one it could not read.

### 3.2 A pattern has a name

The most useful field in a retro entry is the pattern behind the friction. A pattern described in prose cannot be counted: two sessions that hit the same problem describe it in different words, and a reader sees two unrelated anecdotes. So the standard has the pattern opened with a name, and the name is what triage counts and what learnings are grouped by (GEM Standard §3.2). A reading that a taxonomy makes of the text is kept, but it is never counted as a name, because a guess about what an entry means must not be able to trigger work.

The reference installation shows what happens when the rule is not bound in the agents' own instructions. Its retro block carries no naming rule, and about a third of its entries open with a name (§ 4). The rest are memory that triage cannot see.

### 3.3 Nothing lost silently

Between the log and the agent that reads it stand several tools: a parser, a database, a function that selects the learnings for a task. Each can drop something, and a memory that drops an entry without saying so is worse than none, because the reader trusts it. Every tool in the chain therefore reports what it did not carry (GEM Standard §5.2, §8):

- a parser checks its count against a looser count of the log, so that an entry it failed to recognise still shows up;
- a learnings function that cuts its answer says how many rows it cut and how to read them all;
- a zero where the logs plainly hold entries is a failure, never a result.

### 3.4 Recurrence becomes work

Remembering friction is pointless if nothing changes. A named pattern is either undisposed, or disposed with a countermeasure carried by a backlog item or with an acceptance and a date to look at it again. When an undisposed pattern reaches a threshold, triage gives it an item (GEM Standard §6).

The interesting case is what happens after the fix. Once the countermeasure's item is closed, a later occurrence is a *regression*: evidence that the fix did not hold. The standard reopens the countermeasure's own item rather than opening a new one, because that item claimed to have solved the problem (§6.2). The reference installation's triage tool opens a new item instead, and its architect reopens the old one by hand in the same session; the installation records the departure.

What the design forbids is the countermeasure that exists only as an intention. A countermeasure whose item does not exist leaves the pattern undisposed, and it keeps counting.

### 3.5 Reading is measured

A learning that no agent reads has no effect, so the system records each time an entry is returned to a reader (GEM Standard §7.1). The session's start receipt says how many learnings it was given per item, and a handoff names the learnings it consulted and their relevance, or says that none was relevant (GAL Standard §4.5). The reference installation adds that each cited learning gives a step for the receiver — a file to read, a run, a measurement — rather than only what went wrong.

This makes two failures visible that are otherwise invisible: a learnings function that returns nothing for a certain agent, and a learning that is read again and again while its pattern keeps recurring.

### 3.6 The backlog as long-term memory

A backlog is a memory of intent, and it fails in two ways: it forgets something that is still open, or it remembers something as open that is already done. The Backlog Standard's answer has four parts:

- **one source** — the item's own file is the record, and everything else is derived from it or written in the same operation;
- **one partition** — every status is either open or closed, and every tool that asks whether an item is open answers from that partition (§3);
- **nothing filed twice** — a finding is searched for by its own names across open and closed items before a new item is opened, so that an item that already carries it takes it and a closed item that dropped it is reopened (§4.1);
- **nothing dropped** — a finding routed to "a follow-up" is disposed of only when the receiving item holds it (§4.2).

The standard allows one controlled exception to the last part: a finding a review marks as needing no change before the item closes may wait for the next change of the file it concerns, held meanwhile in an item that collects such findings for that file, and taken by whoever next changes it (§4.2). The reference installation collects them per file in one item, or in the item of the planned pass that next changes that file.

### 3.7 Order, never status

The backlog says what is open, not what waits for what. That knowledge tends to live in session handoffs ("do this after that"), and it is superseded with them. A hand-kept plan does better until it starts recording status, and the status goes stale.

The Wave Standard keeps order in the items themselves. The waiting item writes the edge, so nothing has to be edited when a blocker finishes. Each node carries a done condition evaluated on a live surface at every reading, never a written outcome. The plan of a wave is a projection the sweep produces when asked. And a condition the sweep cannot evaluate is *not measured*, never done and never not done (§1, §3, §4).

The failure this design exists for has a precise shape: an item whose done condition holds while it stands open. The sweep reports exactly that (§4.3).

### 3.8 Where memory enters a session

The records help only if they reach the agent when it decides something, and the lifecycle standard puts that moment at session start (GAL Standard §4.2). The start compares the repository's head with the commit the handoff says it left, reads each item the handoff names and the learnings for it, and emits a receipt before any work begins.

In the reference installation the architect's start also reads six sensors: patterns at the triage threshold without an item, regressions, untriaged intake, an architecture review older than ten days, the wave sweep, and inherited measurements that have fallen due. A sensor never stops the start; what it finds becomes an action in the same turn or an item on the session's checklist. Triage runs there, when the sensor finds a pattern without an item, and not between sessions.

**Inherited measurements.** A claim that cannot be measured in the session that makes it is carried forward with the condition under which someone will measure it. For a while these were carried in handoffs, one session to the next, and a handoff is superseded by the next one. When the installation counted them, most of the open ones stood nowhere but in handoffs, reports and review files, and some had fallen out of the chain altogether. They now stand once in a register; a handoff carries only those for its receiver and its items; a result removes the entry in the same commit; and the handoff check fails a handoff whose base held an entry that has since disappeared without a result. It is the "nothing dropped" property applied to what has not yet been measured.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The logs.** *(Retro headings by the parser's looser rule; decision-log headings that open with a date; the database for names and reads.)*
- The retro log holds 1,550 entries in the file, from 2026-04-19, and the database 1,589: the file's entries and 39 retros from implementation sessions' reports.
- 567 of the 1,589 open with at least one pattern name, using 224 distinct names. Of the 1,022 without a name, 135 predate the first named entry (2026-06-23), 16 later ones declare no pattern, and 871 carry text in the pattern field without opening it with a name, so triage cannot count them.
- 517 entries have been returned to a reader at least once.
- The decision log holds 1,703 entries, from 2026-03-09.

**Triage.** *(Dispositions in the database; triage and regression items in the backlog.)*
- 48 patterns carry a disposition: 23 with a countermeasure, and 25 without one, 20 accepted and 5 dormant. Every acceptance carries a date for re-review.
- 22 triage items and 5 regression items have been opened. At the measuring commit 12 patterns stood at the threshold without a disposition, every one with an open triage item, and no regression stood without an item.
- The first time the session-start sensor read the query, on 2026-10-20, it found 9 patterns at the threshold with no item carrying them. Between 2026-10-06 and 2026-10-20 nothing had run triage at start.

**A pattern that regressed.** *(The disposition record and the retro entries after it.)* The most frequent pattern, a count inherited without being measured again, has 152 entries from 2026-09-24. Its countermeasure closed on 2026-10-03; the pattern regressed, and on 2026-10-13 it got a regression item with 44 entries after the fix and was disposed as accepted, with a re-review date of 2026-11-12. 18 entries have followed since 2026-10-13. The memory shows the fix did not hold; it does not by itself make the next fix hold.

**Inherited measurements.** *(The register's entries and the result lines in the repository.)* Before the register, on 2026-10-21, 49 of 73 carried entries stood nowhere but in handoffs, reports and review files, and 9 open entries had fallen out of their chains. At the measuring commit the register holds 92 open entries, and 221 result lines record 145 measured ones.

**A dropped finding (retro log, measured 2026-10-14).** An item was closed with part of its acceptance criterion unmet: the part that said another session's files must block a commit rather than be swept into it. The defect then appeared in at least 12 retro entries between 2026-08-23 and 2026-10-14, with no open item carrying it, until a review finding about the same defect was traced back to the closed item and its criterion was read against what had been built. This is the failure the "nothing dropped" property and the duplicate search exist for.

**Finished work standing as open (retro log, the 30 days to 2026-10-14).** Three occurrences: on 2026-09-23 two of three items listed as open had already been solved by other items; on 2026-10-05 a review step was done again because a brief inherited it as undone; on 2026-10-12 a parked item was found whose waiting condition had held for eight days. These three cases motivated the Wave Standard.

**The sweep.** *(Work-item files and their part-node declarations; the sweep's output.)* The first run, on 2026-10-14, read 1,213 items with no edges and no wave. At the measuring commit, 1,267 items are read as 1,284 nodes, with 33 edges, all in the one wave so far, which is done. A sweep on 2026-11-02 found no ready node, no condition that holds while its item is open, no stale edge and nothing it could not measure.

What these figures show is that the records exist, are read and are acted on, and that the parts that were moved into a tool — triage at start, the register — now hold what the earlier, hand-run form lost. They do not show that the memory has reduced recurring friction; § 4's own most frequent pattern says it has not yet done so for that pattern, and § 6 says why the effect is hard to measure.

---

## 5 — Where This Sits in the Field

The problem is widely recognised. Spotify described its experience scaling AI coding agents on 2026-08-10, and its product Xirp, as its own page puts it, captures the knowledge every coding session generates, turns it into documentation that stays current and feeds it back into future sessions. Addy Osmani (2026-08-21) observes that code often keeps a decision but not why it was taken, and suggests letting the agent store information about its trajectory. Both converge on the starting point of this paper: what an agent learns in a session has to be written somewhere the next session can find it.

Two older patterns help explain what GAE adds to capture.

- **Immune memory.** The adaptive immune system keeps a specific memory of past threats without replaying its whole history at each encounter. In GAE the named pattern plays the part of the memory cell: small, specific and recognisable when it recurs. Triage plays the part of the secondary response, which is stronger on recurrence. The analogy also shows the weakness: an immune response triggers itself on recognition, while triage in the reference installation runs only when the architect's session starts.
- **Common law.** A precedent that is never overruled but quietly stops being applied is still on the books and no longer governs anything. A decision log that no one queries fails the same way. Read tracking and the regression rule are aimed at that failure: one makes unread records visible, the other makes a fix that stopped working visible.

What we want to point to is not capture but **governance of the memory**:

- forms fixed enough for a parser to count;
- tools that must report what they did not carry;
- recurrence turned into backlog items, with a fix that can be shown not to have held;
- order written by the waiting side and evaluated live rather than recorded;
- open measurements carried in one register rather than from handoff to handoff.

A prior-art search for this package looked for these parts and found partial analogues, none with all of them. Uber's session dashboard flags more than a dozen categories of waste automatically; Warp's improvement skill turns accumulated human feedback into a proposed change to the agents' own skill, merged by a person. Neither source describes the other parts. The search covered a small set of sources, and the wave standard's ideas were searched only in part, so this paper does not claim the combination is new, or say where its ideas come from.

**Sources.** Singer, T. (2026-08-10). What we've learned scaling AI coding agents at Spotify. https://portal.spotify.com/blog/introducing-xirp · Spotify, Xirp product page, https://xirp.spotify.com · Osmani, A. (2026-08-21). Human judgment doesn't leave the software factory. It relocates. https://addyosmani.com/blog/human-judgment-doesnt-leave-the-software/ · Medisetty, U. K. (2026-08-27). Running a Software Factory Efficiently at Uber Scale. https://www.uber.com/us/en/blog/efficient-software-factory/ · Segner, M. (2026-08-26), Claude blog post on Warp's agents, https://claude.com/blog/how-warp-builds-self-improving-agents-on-claude

---

## 6 — Limitations

- **Triage runs at session start, not between sessions.** Since 2026-10-20 the architect's start reads the patterns at the threshold and runs triage when one stands without an item. Between architect sessions a pattern can reach the threshold, or regress, with nothing carrying it.
- **Reading is measured; effect is weaker.** The system records that a learning was returned to a reader. Whether the reading changed what the agent did is measured only indirectly, by whether the pattern recurred, was disposed of or regressed. The installation has a view for that measure, and no tool or agent reads it yet.
- **Outcomes are compared without their circumstances.** Nothing in the memory records what else was true when an outcome arose, so an improvement the circumstances produced can be credited to a fix. The release's known issues (GEM) state the gap and a direction.
- **The memory holds only what agents notice, and only what they name.** An entry records the friction a session saw. About a third of the retro entries name a pattern, and an unnamed pattern cannot be counted. The installation has not bound the naming rule in its agents' retro block.
- **A truncated answer counts only one kind of row.** When the learnings function cuts its answer, its last row says how many direct rows were cut, not how many found through related decisions; the standard asks for both.
- **Derived copies lag.** The database mirror of the backlog is brought up to the files by a sync that runs when it is started. Between runs a reader of the database can see an item's old status. The file is the record, and the standards say so, but a reader has to know to look there.
- **The record is assumed to be a file.** The standards make a file or a log the record. An agent that can write only a database has no form for it. The second installation, set up in a domain where the agents' knowledge work is the product, keeps its records in a database, which the starter kit allows as a registered deviation and the standards do not; the release's known issues give the direction.
- **Order has been shown on one wave.** One wave has run, and it is done. The standard's claims about long lines of work across many items rest on the failures it was built against, not yet on a long record of waves.
- **The figures are the reference installation's.** They describe one system, built by one operator with a set of agents. A second installation by the same operator uses the same standards; whether the records pay off for someone else has not been measured.

---

## 7 — What Comes Next

- Triage between sessions, so that a pattern at the threshold gets its item without an architect session starting.
- A report of the consult metric that someone reads, showing whether reading a learning was followed by fewer occurrences of its pattern — with the conditions each outcome arose under.
- The naming rule bound in the agents' retro block.
- More waves. The first ordered the work that produced this documentation package; the next will show whether order without status holds over a longer line of work.
- In the standards, as directions in the release's known issues: outcomes stored with their conditions, and a database table as a possible record.

---

## 8 — Map

- **The GAE overview** places memory among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - Governed Engineering Memory Standard: the two logs, the learnings function, triage and consultation
  - Backlog Standard: the item, its statuses and lifecycle, and the advisory class
  - Wave Standard: edges, done conditions, waves and the sweep
  - Governed Agent Lifecycle Standard: the start gates and receipt, and when an agent writes and reads the records
- **Related white papers:**
  - *Agent Roles and Orchestration*, on handoffs between agents
  - *Loop Engineering*, on retro and triage as a designed loop
  - *Graph Architecture*, on the order graph among the system's graphs
  - *Verification Architecture*, on the measurement line that inherited measurements come from
  - *Case Study*, on the reference installation
- **NDA:** *Governance Log Analysis* is the structured extraction of patterns from the decision and retro logs that this paper describes in principle.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
