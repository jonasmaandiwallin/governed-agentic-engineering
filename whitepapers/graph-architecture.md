---
title: "Graph Architecture: Explicit Structure Over Implicit Convention"
type: white-paper
status: draft
version: "v0.2.2"
date: "2026-11-07"
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
  - model: "Claude Fable 5.1"
    model_id: "claude-fable-5-1"
    roles: [review]
    source: handoff
ai_disclosure:
  - role: drafting
    status: complete
    scope: "Text and structure of v0.1 (2026-10-16), written in a session whose handoff named the model, and in v0.2 § 4 rewritten with a rule per figure."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, with the architecture review of 2026-11-01 and a sweep of the order graph on 2026-11-02, each with the rule that reproduces it; statements about which edge checks block a commit read in the reference installation's tool source."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 2 and § 3 rewritten as explanation with pointers, where v0.1 restated the Wave Standard closely; the dependency rules attributed to the Contract Standard, which owns them; which edge checks block a commit in the reference installation stated; § 4 recounted, with the contract edges of the implementation graph split by whether the task came before or after the dispatch gate; an unattributed contrast removed from § 5; Limitations and What Comes Next brought up to date with the release's known issues; the map pointed at the release. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept. v0.2.2: brought up to gae-standards-v0.5. Corroboration across distinct sources is now a rule of the Truth Chain Standard, so the evidence graph's gap in § 6 and the direction in § 7 keep only the relations between entries; § 3.3 points to the Contract Standard's rule that a reference never targets a deprecated document. Every sentence about a standard was read against the v0.5 text before the change."
    evidence: "The diff against v0.2.1."
    reason: null
  - role: fact-check
    status: not-applicable
    scope: null
    evidence: null
    reason: "§ 5 names no specific external source; it cites only general practices (build tools that derive order from declared dependencies, legal citators). The attribution v0.1 made to current writing about agents was checked against its sources by Research Pipeline, found not borne by the source first proposed for it, and removed."
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/graph-architecture.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/contract-standard.md
    version: "v0.7"
  - path: standards/truth-chain-standard.md
    version: "v0.6"
  - path: standards/registry-standard.md
    version: "v0.5"
  - path: standards/wave-standard.md
    version: "v0.3"
---

# Graph Architecture: Explicit Structure Over Implicit Convention

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*An agent that has to rediscover how things relate every time it reads them will rediscover them differently each time. This paper is about the graphs that make those relations explicit — what each one connects, who writes its edges, and what a tool must refuse when an edge points nowhere.*

---

## 1 — The Problem: Relations That Live in Someone's Head

Every system has relations between its parts. A specification builds on another. A value rests on a study. A piece of code implements a rule. A task cannot start until another has finished. In a small team these relations live in people's heads, in naming conventions and in the occasional comment, and they hold well enough because the people are there to ask.

Agents are not there to ask. An agent that needs to know what a change touches will search, and the search will find what the words happen to match. Two agents searching for the same thing at different times find different things. And the questions that matter most — *if this study is retracted, what changes? what must be finished before this can start? which rule does this code implement?* — are exactly the ones that a text search answers worst, because the answer depends on relations nobody wrote down.

A second failure is subtler. Relations that are written down, but by hand on both sides, drift. A document lists what depends on it; the list was right once; three edits later it is not, and nothing says so. A stale relation is worse than a missing one, because it looks complete.

The question this paper answers is: **how does a system keep the relations between its parts as explicit structure that tools can read and check — and what does that structure have to guarantee before anyone may rely on it?**

---

## 2 — What It Is: Five Graphs, One Discipline

Governed agentic engineering (GAE) keeps the relations that matter as graphs: nodes with identifiers, and edges written in fields a tool reads. The reference installation has five.

- **The contract graph.** Contracts are nodes; an edge says that one contract builds on another. It answers what a change to one contract may touch.
- **The evidence graph.** Evidence entries are nodes, and contracts, registry values and knowledge articles point into them. It answers what rests on a study and what a value rests on.
- **The implementation graph.** Code points to the contract it implements, and implementation tasks point to the contract they are driven from and to the tasks they wait for.
- **The knowledge graph.** Explanatory articles for readers point to the evidence they draw on and to the things they explain.
- **The order graph.** Work items name the items they wait for, and a sweep derives what is ready.

The graphs differ in what they connect. They share one discipline, which is what this paper is about. Each graph's rules belong to a standard, and this paper points to them rather than restating them:

- the Contract Standard owns the dependency fields between contracts and the tool that derives their reverse lists (§3.2, §9);
- the Truth Chain Standard owns the links from code to contract and from a contract to the values and evidence it rests on (§3);
- the Registry Standard owns the link from a governed value to its evidence;
- the Wave Standard owns nodes, edges, done conditions and the sweep of the order graph;
- the GIP Standard owns the dependencies between implementation tasks.

---

## 3 — The Load-Bearing Ideas

### 3.1 Explicit structure over implicit convention

A relation that matters is written as an edge, in a field, naming a node by its identifier. Not as a sentence, not as a naming convention, not as a folder layout.

The reason is not tidiness. A relation that lives in prose has to be inferred each time it is used, and inference by an agent is neither stable nor checkable. A relation that lives in a field is read the same way by every reader and can be checked by a tool. The cost is that someone has to write the edge. The benefit is that nobody has to rediscover it. The Truth Chain Standard makes the same point about evidence: named in prose, it is not a link unless it stands in the form the installation names (§3.2).

### 3.2 One side writes; the other is derived

Every graph has a direction in which edges are written, and a reverse that is never written by hand. A contract declares what it builds on, and its reverse list is generated (Contract Standard §3.2). A value names its evidence, and the list of what rests on an entry is derived. A work item names what it waits for, and what it blocks is derived (Wave Standard §3).

The writing side is chosen as the side that knows: the author of a contract knows what it rests on, and the waiting item knows what it is waiting for. Writing one side halves the edits and removes the drift between two hand-kept lists, because there is only one. When a blocker finishes, nothing has to be edited, so nothing can be forgotten then.

A generated list is only as narrow as the rule that generates it. In the reference installation the reverse list on a contract counts every document whose text mentions it, which is a wider set than the documents that declare a dependency on it. The *Contracts as the Source of Truth* paper gives the numbers.

### 3.3 An edge must point at something that exists and holds

A node that holds an edge to something that does not exist is defective. So is an edge to a node that has been retired — a deprecated contract, a retracted study — unless the edge has been moved to whatever replaced it. The Truth Chain Standard states this for its links (§3.2) and the Wave Standard for the order graph (§3).

A dangling edge looks exactly like a valid one until something tries to follow it, so the rule sits with the tool, not with the author. Where the tool sits decides what the rule is worth. In the reference installation:

- a contract that declares a dependency on a deprecated contract cannot be committed, and has not been since 2026-10-19 (the Contract Standard's rule, §4.10, is that a reference names the document that replaced a deprecated one);
- a contract whose evidence field names an entry that does not exist cannot be committed;
- an edge in the order graph to a node that does not exist fails the sweep;
- a contract dependency on a document outside the contract corpus, or a dependency the tool detected and no author confirmed, is reported by the architecture review and blocks nothing.

The last line is where § 4 still finds dangling edges.

### 3.4 The graph answers impact questions

The most frequent use of a graph is not to draw it but to ask it something. *If this evidence entry is retracted, which contracts and values rest on it? If this contract changes, which contracts build on it, and which code implements it? What can start now that this task has finished?*

Each of these is a traversal. Without the graph, each is a search followed by a judgement call. With it, each has an answer that two readers will agree on — and an answer that a tool can produce at the moment the question is asked, rather than one somebody wrote down earlier.

### 3.5 An order graph must be acyclic; a dependency graph says what it is

Not every graph has to be free of cycles, and the difference matters. A cycle in an order graph means that nothing in it can ever be ready, so the Wave Standard makes it a hard failure of the sweep (§3, §7).

A dependency graph between contracts can have cycles without being wrong: two contracts may genuinely constrain each other. But a graph that is mostly one large cycle cannot give a reading order, because no node in it comes first. The Contract Standard therefore takes the reading order from the domain taxonomy and from priority within a domain, written into the index by a tool (§5), and the dependency graph is used for impact, not for order.

### 3.6 The graph is read, not kept

Views of a graph — the reverse lists, the corpus index, the path of a line of work — are produced by a tool when they are needed, from the edges as they stand. The Wave Standard says it of the projection of a wave: a saved copy only shows the state at the commit it was taken from (§1, §6).

This is the idea of § 3.2 applied to whole views rather than single lists. A plan that someone maintains by hand starts carrying status, and the status goes stale. A projection derived from the edges is as current as the edges. In the reference installation the sweep runs at the start of every session of the architect, where the order of work is decided.

### 3.7 Unread is not empty

A tool that reads a graph and finds nothing has either found an empty graph or failed to read it, and the two look the same in the output. The tools that read GAE's graphs therefore fail when they read zero nodes where the store plainly holds some, and report a node whose state they could not read as *not measured* — never as done and never as not done (Wave Standard §1, §7).

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The contract graph.** *(The automated architecture review of 2026-11-01.)* The review scanned 152 documents — every typed document in the contract corpus except its index — and found:
- one strongly connected component of 106 documents, every one reachable from every other along dependency edges;
- 9 dependency edges to a document not in the active contract corpus: 8 to governance documents kept outside it, and 1 that the tool detected and no author has confirmed. None points at a deprecated contract; v0.1 counted 13, some of them at deprecated contracts;
- one document with no edges in or out, and 10 flagged as overloaded: nine with more than twelve declared dependencies and one with more than ten top-level sections.

**The evidence graph.** *(Entries with an active status in the database mirror; a contract's citation read from the entry's reverse list, a value's from the evidence field of each live registry value, an article's from its evidence list.)* Of 871 evidence entries in force:
- 611 are cited by at least one contract, 382 by at least one live registry value and 300 by at least one knowledge article;
- 195 are cited by none of the three.

Of 863 live registry values, 645 name at least one evidence entry, in 1,040 links, and none of those links points at a retired entry. The other 218 state that no evidence bears them.

**The implementation graph.** *(Header lines naming a contract in the engine's source at commit `acba054`, against the contracts in force; the task queue's contract and waiting fields.)*
- 341 header lines in 123 source files name the contract each file implements. Four name something that is not a contract in force.
- The task queue holds 575 implementation tasks. The 544 from before the dispatch gate all name the contract they were driven from, and 179 of them name the tasks they wait for, in 289 edges. The 31 tasks since the gate were task work, not driven from a contract, and name none; 1 names a task it waits for.
- The table meant to index code against contracts holds no rows.

**The knowledge graph.** *(Knowledge articles and their evidence lists.)* 222 of 255 knowledge articles cite evidence, in 800 links to 335 distinct entries.

**The order graph.** *(Work-item files and their part-node declarations; edges in the waiting fields.)* 1,267 work items are read as 1,284 nodes, 17 of them parts of one item. All 33 edges stand in that item's parts, in the line of work that led from the installation's tooling to this documentation package; that line was run as the one wave so far, and the wave is done. A sweep on 2026-11-02, at a later commit with one more item, found no cycle, no edge to a missing node, no stale edge and nothing it could not measure.

What these figures show is that the edges exist, are counted, and can be checked. Where a check blocks the commit, the class it covers is empty: no contract depends on a deprecated contract. Where a check only reports, defects remain: dependency edges into documents outside the contract corpus, code headers that name no contract, evidence entries nothing uses. The figures also show that the contract graph is too tangled to give an order on its own, which is why it is not asked to, and that the implementation graph's edges to contracts come from work done before the current gate.

---

## 5 — Where This Sits in the Field

Graphs as a control structure are old. Build tools have derived the order of work from declared dependencies for decades. Legal research has long relied on citators — indexes that list, for every decision, the later decisions that cite it — so that a lawyer can see whether a precedent still stands before relying on it. The generated reverse list of a contract plays the same role: it shows what a change touches before the change is made.

GAE does not choose between loops and graphs. The order graph and the implementation graph here are explicit graphs of typed steps, and the designed loops of the companion paper on loop engineering run inside them as bounded back edges.

What we want to point to is not graphs as such, but the discipline applied to all of them at once: one side writes and the other is derived, every edge names a node that exists and holds, views are read and never kept, and an unread node is never counted as anything. We have not checked whether this combination is formulated elsewhere, and this paper does not claim it is new.

---

## 6 — Limitations

- **The contract graph is one large component.** 106 contracts lie on cycles with each other. The graph still answers impact questions, but it cannot order the corpus, and a change to almost any contract in the component is, by the graph's own account, a change that may touch all the others. Whether every one of those edges is a real dependency has not been reviewed.
- **Some dangling edges only get reported.** An edge to a deprecated contract blocks the commit; an edge to a document outside the contract corpus, and a detected edge no author has confirmed, are reported by the architecture review and block nothing. The review runs at the architect's session start when the latest report is older than ten days.
- **The evidence graph is read from a mirror.** The counts above are taken from the database, whose reverse lists are derived when the evidence is synced, not when a contract changes. Between syncs the mirror can lag the files.
- **Unused evidence is not a defect by itself.** The 195 entries that nothing cites may be waiting for a contract, may support research that has not been written up, or may be candidates for retirement. The graph shows that they are unconnected; it does not say which.
- **Evidence entries have no relations to each other.** Links run from code to contract, from contract to values and evidence, and from evidence to source. The Truth Chain Standard now counts two links to entries for one source as a single link, so one study cannot corroborate itself through two entries (§3.2, §4.2). What the standards still give no way to record is that one entry supports another, contradicts it or is derived from it. The release's known issues give the direction.
- **The graphs are not joined.** No single traversal runs from a line of code through its contract to the evidence behind it: the index meant to join code to contracts is empty, code headers are not checked, and the tasks since the dispatch gate carry no contract. Each graph is sound enough on its own; the joins between them are where the gaps are.
- **The order graph covers one line of work.** All its edges lie in the part-nodes of one item. Most of the backlog has no edges, so the sweep's statement that nothing is waiting says little outside that line.

---

## 7 — What Comes Next

- A review of the large contract component: which edges are real dependencies and which are references that belong among the explicit exclusions.
- Dependencies on documents outside the contract corpus, unconfirmed detected edges and code headers that name no contract in force, checked at commit like dependencies on deprecated contracts.
- The index from code to contract filled, so that a traversal from code to evidence is a query.
- In the standards, as directions in the release's known issues: a closed set of relations between evidence entries — the structure the release calls a *governed evidence graph* once that change enters — and, for several operators, the contracts a change touches, worked out from the dependency graph before the work is assigned.
- Order edges written for the next lines of work as they start.

---

## 8 — Map

- **The GAE overview** places the graphs among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - Contract Standard: the dependency fields, the reading order and the tool that derives the reverse lists
  - Truth Chain Standard: the links between levels and the evidence registry
  - Registry Standard: the link from a governed value to its evidence
  - Wave Standard: nodes, edges, done conditions and the sweep of the order graph
  - GIP Standard: the dependencies between implementation tasks
- **Related white papers:**
  - *Contracts as the Source of Truth*, on the chain the contract and evidence graphs carry
  - *Numberless Code*, on the registry values in the evidence graph
  - *Context, Coherence and Memory*, on the order graph as the backlog's long-term memory
  - *Spec-Governed Dispatch*, on how the implementation graph is scheduled
  - *Loop Engineering*, on the designed loops that run inside the graphs
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
