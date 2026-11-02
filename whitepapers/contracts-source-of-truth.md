---
title: "Contracts as the Source of Truth: The Truth Chain"
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
    roles: [drafting, technical-analysis, fact-check]
    source: handoff
  - model: "Claude Opus 5.5"
    model_id: "claude-opus-5-5"
    roles: [editing, technical-analysis]
    source: platform
  - model: "Claude Fable 5.1"
    model_id: "claude-fable-5-1"
    roles: [review]
    source: handoff
ai_disclosure:
  - role: drafting
    status: complete
    scope: "Text and structure of v0.1 (2026-10-16), written in a session whose handoff named the model."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817, engine commit acba054 and its database as loaded on 2026-11-02, each with the rule that reproduces it."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 2 and § 3 rewritten as explanation with pointers, where v0.1 restated the Truth Chain Standard closely; the rules on declared and generated dependencies attributed to the Contract Standard, which owns them; the knowledge-corpus shape and the release's known issues added; § 4 recounted; § 5 brought in line with the checked Design by Contract reference; Limitations and the map brought up to date."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline: Böckeler and Martinelli on 2026-10-19, Böckeler's own definition again on 2026-11-02; Meyer's 1992 article on 2026-11-02, read by the agent in the paginated original."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings; two advisory findings stay open for the next revision: sentences sharing a run of ten or more words with the standards' wording, and a release-tool form that none of the twelve papers contains."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/contracts-source-of-truth.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/truth-chain-standard.md
    version: "v0.5"
  - path: standards/contract-standard.md
    version: "v0.6"
---

# Contracts as the Source of Truth: The Truth Chain

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*When the specification says one thing and the code does another, someone has to be able to say which one is right — and the answer cannot depend on which of the two an agent happened to read last. This paper is about the order that answers that question, and the links that let anyone follow a decision back to the evidence it rests on.*

---

## 1 — The Problem: Two Sources, No Tiebreaker

A system built by agents is described in several places at once. There is a statement of what the system is for. There are specifications of what it must do. There are values it uses, research it rests on, and code that runs. Every one of these is written down, and every one of them can be wrong.

When two of them disagree, a human team usually knows which to trust: the person who wrote the specification is in the room, or the code is "obviously" right because it is in production. An agent has neither. It reads what is in its context, and it treats what it reads as true. If the specification says a threshold applies after three sessions and the code applies it after two, an implementing agent that reads the code will preserve two, and a reviewing agent that reads the specification will flag two as a bug. Both are behaving correctly. The system has no answer.

The usual outcome is that the code wins by default. Code runs; specifications do not. Over time, the specification becomes a description of what someone once intended, and the real decisions live in whatever the last agent wrote.

The question this paper answers is: **how does a system decide, mechanically and in advance, which statement holds when two disagree — and how does every decision stay traceable to the evidence it rests on?**

---

## 2 — What It Is: The Truth Chain

Governed agentic engineering (GAE) answers with a truth chain: an order of authority between the levels at which the system makes claims, and a link from every governed statement to the level above it.

The chain has three levels — the constitution, which says what the system is for; the contracts, with the registry values they cite; and the implementation — and higher holds over lower. Advice shown to a user carries no authority at all. Evidence and the research behind it are not a level: they are the ground the upper levels stand on, and they change nothing by themselves. Every governed statement names what it rests on, so that the chain can be walked from a line of code down to a source.

The Truth Chain Standard is the reference for the levels (§2), the links (§3), the evidence registry (§4) and the tools that check them (§6). The Contract Standard owns the contract and the dependencies between contracts. This paper explains why the chain is built the way it is.

**In a knowledge corpus.** Where the agents' work is itself the product, the implementation level holds their deliverables rather than code. The standards still define the implementation as code. The starter kit binds the level to the deliverables, and lets a deliverable produced before its contract stand if it is marked *before contract*, which the standard would forbid; the release's known issues list both.

---

## 3 — The Load-Bearing Ideas

### 3.1 One order, fixed in advance

The order of authority is decided once and not reopened by any instruction, prompt or runtime context (Truth Chain Standard §1). That is what makes it usable by an agent: a tiebreaker that has to be argued each time is not a tiebreaker.

The fixed order also removes a quiet failure. Without it, the effective authority is whatever is closest at hand — the file the agent opened, the message it was given, the most recent commit. With it, an agent that finds two statements in conflict does not need judgement to decide which to follow. It needs to know their levels.

### 3.2 Truth by contract, not truth by implementation

When the code and the contract disagree, the code is the defect. This holds even when the code is better.

That sounds rigid, and it is meant to be. Code that is better than its contract has found something the contract should say. The right move is to change the contract first — through the process that reviews contracts — and then bring the code into line. Code that silently improves on its contract leaves the system with two answers again, and the next agent to read the contract will "fix" the improvement away. So the direction of change is always the same: contract first, then code.

### 3.3 Every governed statement points upstream

A link is what turns an order of authority into something a tool can follow (§3). Each level names what it rests on, in a form the installation fixes, so a reader can start from any line of code and walk to the source behind it.

Followed in reverse, the same links answer the question asked more often: if this evidence is retracted, or this value changes, what does it touch? Without links that question is answered by searching and hoping. With them it is a query. That is also why evidence named in prose — "as studies have shown" — counts for nothing: no tool can follow it.

### 3.4 Evidence proposes, governance decides

A new finding never edits a contract or a value directly; it becomes a proposal to whoever owns the statement (§2.3).

This is a deliberate brake. Research arrives in batches, and a single strong-looking study can bear on many statements at once. If findings applied themselves, one misread paper could rewrite a dozen contracts before anyone looked. Routing every finding to the owner means each change is reviewed where its consequences are understood. The same brake holds at the top: a contract cannot overrule the constitution, however good its reason; the constitution has to change by its own process first.

### 3.5 No silent resolution

A conflict between levels is logged with both statements before the lower one is brought into line (§2.2). The entry is what makes the resolution reviewable later. A conflict resolved in someone's head leaves no trace, and the next agent that finds the same two statements has the same conflict.

### 3.6 Dependencies are declared; the reverse is generated

Each contract declares the contracts it builds on, and a tool generates the reverse lists (Contract Standard §3.2, §9). The split matters. A declared dependency is an author's claim and can be reviewed. A hand-maintained reverse list drifts the first time someone forgets it, and a stale reverse list is worse than none, because it looks complete.

When the tool proposes a dependency the author rejects, the rejection is written down as an exclusion rather than deleted, so the next run does not propose it again and a reviewer can see that the edge was considered (§7.5). In the reference installation the generated reverse list counts every document whose text mentions the target, which is a wider set than the documents that declare a dependency on it.

### 3.7 Deprecate, never delete

Retired contracts and evidence entries keep their records with their status, and a superseded entry names its replacement (Contract Standard §6.2 for contracts, Truth Chain Standard §4.2 for evidence entries). The reason is the links. A statement that pointed at a deleted entry points at nothing, and nothing can say whether that is a typo or a retraction. A statement that points at a retracted entry can be found and judged.

### 3.8 The file is the record

Evidence entries are files, and the database the tools query is derived from them (§4.3). The rule exists because a row without a file has no history and no review. It also assumes that the agent writing the entry can write files: the release's known issues note that an agent on a chat platform may reach only a database, and that the standards have no form for a table as the record.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02), engine commit `acba054` and the database as loaded on 2026-11-02, and gives the rule that reproduces it. The case study describes that installation.

**The contract corpus.**
- 153 documents carry a status: 135 in force and 18 deprecated, which remain in the corpus. *(The status field.)*
- 90 documents declare the constitution as a direct dependency, 76 of them in force. *(Dependency lists that name it.)* The generated reverse list on the constitution names 91 documents, because it counts mentions in the text rather than declared dependencies. Three documents carry the constitution as an explicit exclusion: the tool proposed the edge and an author rejected it.

**The evidence registry.**
- 960 entry files and 961 rows in the database mirror. *(Entry files with an ID field; rows in the mirror.)* One row has no file; no contract's or value's evidence field names it.
- 871 entries in force — 390 at the highest evidence tier, 403 at the middle and 78 at the lowest — and 90 retired entries kept with their status. *(Rows in the mirror by status and tier; the files' tier fields are written in mixed forms.)*

**Declared and cited evidence.** *(The citation check at the measuring commit.)* Of 152 documents scanned, 73 declare evidence in their metadata, 1,281 identifiers in all. 379 declared identifiers, in 57 documents, are not cited anywhere in the document's body — about three in ten. 78 identifiers cited in a body are not declared, in 11 documents.

**Code to contract.** The engine's source carries 341 header lines naming the contract each file implements, in 123 files. Four of them name something that is not a canonical contract. *(Header lines compared with the slugs of the canonical contracts.)*

**Contract to registry.** 613 lines in the contract corpus cite a registry key in the link form, 745 citations in all, and none of them names a deprecated key. *(Lines in the link form, and citations counted per line.)*

What these figures show is that the chain's structure is in place and can be counted: an order, links in every direction the standard names, and a history that keeps what it retires. They also show where the links are weakest — declared evidence that the text never uses, and code headers that nothing checks. § 6 returns to both.

---

## 5 — Where This Sits in the Field

The idea that a component's obligations should be written down and checked is old. Bertrand Meyer's 1992 article *Applying "Design by Contract"* gave routines preconditions and postconditions and classes invariants, and treated a violated assertion as always a bug: checking is a compilation option, a monitored violation raises an exception, and a routine that cannot meet its contract reports the failure to its caller. The truth chain uses the same idea one level up. The contract is not attached to a routine but is a separate document that exists, and is reviewed, before any code is written, and it governs a whole behaviour rather than a call.

Two other traditions explain the rest of the chain.

- **Common law.** A legal system and a contract-governed agent system solve a similar problem: many actors make decisions independently, over a long time, and no decision may contradict the body as a whole. Precedent corresponds to declared dependencies, following precedent to the order of authority, supersession to deprecation with a named replacement, and citation checking in legal research to the generated reverse index that shows what a change touches. Both systems also share a failure mode: a rule that is never overturned but slowly stops being applied. The analogy is conceptual, not legal.
- **Spec-driven development.** Birgitta Böckeler's account of specification-driven development distinguishes three levels: *spec-first*, where a well-considered specification is written first and used for the task at hand; *spec-anchored*, where it is kept after the task for further development and maintenance; and *spec-as-source*, where it is the main source file and the only thing a person edits. Simon Martinelli's later reading of the same levels describes the first as a one-off artefact, not needed once the feature is done. The truth chain sits closest to the middle level, with a stricter order — the specification changes before the code, never together — and with verification regenerated from the specification. Those levels describe where a specification lives; they do not say who may change it or how it is checked against evidence, which is what the chain adds.

What we want to point to is not contracts as such, but the combination: a fixed order of authority that an agent can apply without judgement, links from code through contracts and values down to evidence, and a rule that evidence proposes and governance decides. We have not checked whether this combination is formulated elsewhere, and this paper does not claim it is new.

**Sources.** Meyer, B. (1992). Applying "Design by Contract". *Computer*, 25(10), 40–51. https://doi.org/10.1109/2.161279 · Böckeler, B. (2025-10-15), on spec-driven development tools, martinfowler.com, https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html · Martinelli, S. (2026-08-27), on the three levels of spec-driven development, https://martinelli.ch/the-three-levels-of-spec-driven-development-and-where-the-ai-unified-process-sits/

---

## 6 — Limitations

- **Declared and cited evidence disagree, and nothing stops it.** The standard says a contract's declared evidence and the evidence its text cites are the same set. In the reference installation about three in ten declared identifiers are not cited, and the check that finds them reports without blocking a commit. A declaration that the text never uses says the contract rests on evidence that it may not, in fact, use.
- **Code headers are not checked.** No tool verifies at commit that the contract a code file names exists and is in force. Four headers name something else today.
- **Link checks read the mirror, not the record.** The tools that check whether a cited evidence entry exists, and whether it is in force, read the database. A row without a file passes them, and existence is checked at every commit while being in force is checked only by hand.
- **The bottom of the chain is held by people.** Whether an evidence entry's key finding is actually in its source is not checked by any tool, and no tool reads the research record behind an entry. Both rest on the discipline of the agent that writes the entry and on manual verification.
- **Evidence strength does not travel up.** A contract may rest on low-tier evidence without saying so, and the coverage count that summarises a contract's evidence counts identifiers, not tiers. Nor does any rule say that a value's confidence may not exceed the tier of the evidence it cites.
- **Conflicts between levels are found by verification, not by the chain.** Conflicts within the contract level are checked at every commit to the corpus. No tool detects a conflict between levels as such. It surfaces when a verification step reads one level against another — a test written from the contract fails against the code — and is then logged. A conflict that no verification exercises stays invisible.
- **The dependency graph is not the authority order.** Declared dependencies record what a document builds on; they are not checked against the levels. In the reference installation the constitution declares eighteen documents as dependencies. Nothing is wrong with that as a statement of what it draws on, but it means the order of authority cannot be read off the dependency graph.
- **The chain records what, not when, and links run one way.** The release's known issues list three gaps: a level has no declared scope, so two top documents of different scope split the chain; a statement records what it rests on but not when its links were read; and evidence entries have no relations to each other, so two entries that seem to corroborate each other while resting on one study cannot be told apart by the chain. The structure that would carry those relations is to be called a *governed evidence graph*.

---

## 7 — What Comes Next

- A check at commit that every code header names a contract in force.
- A citation check that blocks a commit on a declared-but-uncited or cited-but-undeclared identifier, once the existing population is cleared contract by contract.
- Link checks that read the evidence files, so that a row without a file fails instead of passing.
- A rule that a contract resting only on low-tier evidence says so, and a coverage measure that reads tiers.
- The directions the release's known issues give for the Truth Chain Standard — scope per level, time on links, relations between evidence entries, and the knowledge-corpus shape — each entering it only through a new release.

---

## 8 — Map

- **The GAE overview** places the truth chain among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - Truth Chain Standard: the levels, the order of authority, the links, the evidence registry and the tool classes
  - Contract Standard: the contract, its metadata, declared and generated dependencies, and the completeness gate that checks the link from contract to code
  - Registry Standard: the registry of governed values and its link to evidence
  - GEM Standard: the form of the decision-log entry a conflict writes
  - GIP Standard: how a contract reaches the implementation
- **Related white papers:**
  - *The Canonical Standard*, on the contract format the chain links together
  - *Numberless Code*, on the registry level of the chain
  - *Graph Architecture*, on the dependency and evidence graphs the links form
  - *Verification Architecture*, on the verification that finds conflicts between levels
  - *Case Study*, on the reference installation
- **Under NDA:** *Harness Gate Specification* describes the link checks of the reference installation in implementation detail.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
