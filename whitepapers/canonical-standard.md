---
title: "The Canonical Standard: One Document Format for Agents and People"
type: white-paper
status: draft
version: "v0.2.1"
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
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817, each with the rule that reproduces it; statements about the reference installation's tools read in its instance appendix at the same commit."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 3 rewritten as explanation with pointers to the standard's sections, where v0.1 restated rules nearly word for word; rules that hold only in the reference installation (the floor for agent instructions, the reading order of its domains, a check at every commit) marked as the installation's; the registry order added to the orders that may omit a section; § 4 recounted; § 5 brought in line with the checked Markdoc reference; Limitations brought in line with the instance appendix and the release's known issues; the map pointed at the release. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline: the Open Knowledge Format on 2026-10-19 and against its specification on 2026-11-02; Markdoc on 2026-11-02, Stripe's own post read by the agent, the rest partly through the platform's research mode."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/canonical-standard.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/contract-standard.md
    version: "v0.6"
---

# The Canonical Standard: One Document Format for Agents and People

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*A specification that a person reads correctly and an agent reads differently is two specifications. This paper is about a document format built so that the same text gives both readers the same answer — and so that tools can check whether it does.*

---

## 1 — The Problem: Prose Is Read by Inference

Specifications are usually written for people. People read them generously: they skip what does not apply, infer what the author meant from context, recognise that "the protection contract" means a particular document, and know that a rule stated in a paragraph about something else still holds.

An agent reads the same text differently. It infers too, but its inferences are not the author's. A rule buried in an explanatory paragraph may be read as an example. An informal reference may resolve to the wrong document. A section that a human would skim — a rationale, a metaphor, an aside — may be weighed as heavily as the rule next to it. And nothing in the text says which version of it was last reviewed, which documents it depends on, or which one wins when two disagree.

None of this is a defect in a single document. It is what happens when a corpus of hundreds of specifications is written to be read, not to be processed. The failures are quiet: an agent implements a rule that the author meant as an illustration, or misses one that was stated in passing, and the implementation is "correct" according to its reading.

The question this paper answers is: **what form must a specification take so that an agent and a person read it the same way, and so that a tool can check the parts of that form that matter?**

---

## 2 — What It Is: A Contract Standard and Its Appendix

Governed agentic engineering (GAE) writes every specification in the form of one standard, the Contract Standard. Its main parts:

- **A closed set of document types**, each with its purpose, and for most of them a fixed section order.
- **Metadata that carries the relations**: type, version, status, domain and layer, priority, dependencies, overrides, supersession, evidence and the record of the last audit, in structured frontmatter.
- **A closed taxonomy** of domains and layers, with a reading order.
- **Normative statements as lists**, one rule each, apart from explanation.
- **Content boundaries**: behaviour rather than schemas, governed values by key, one language, history in one log.
- **Tool classes**: a post-processor, an index generator, a conversion tool and a completeness gate, each defined by what it must and must never pass.

The standard is generic and names no system. Each installation binds it in an **instance appendix**: its title prefix, its domain taxonomy, its paths and its tools. The starter kit carries a template for that appendix. Where this paper describes the reference installation's appendix, it says so.

The Contract Standard is the reference for the rules. This paper explains why they are there and points to where they stand.

---

## 3 — The Load-Bearing Ideas

### 3.1 One text, two readers

The property everything else serves is deterministic reading: two readers who know nothing about each other should extract the same obligations from the same document.

Most of the standard's prohibitions (§4.8) follow from that. A reference by full title (§4.10) cannot resolve to the wrong document. A header carries structure in a way bold text inside a paragraph does not. Metaphor and rhetoric are excluded not because they are bad prose, but because a reader that cannot tell an image from a rule will sometimes obey the image.

The test is not whether a person can understand the document. It is whether the two readings agree.

### 3.2 The type decides the shape

A document's type fixes its section order (§4.2–§4.7). A reader therefore knows where to look before reading. An agent asked for a contract's invariants goes to one section and finds them all there, instead of deciding whether a sentence in the scope section was also one. A reviewer sees a missing section at a glance. The contract order, and the registry order that follows it, let a section that does not apply be left out; the others apply in full.

The type also limits what a document may do. An appendix only calibrates or clarifies; a clause adds no new architectural logic; an orientation document governs no behaviour. So the type promises a level of authority as well as a template. The set has no type yet for the documents at the top of the chain — the constitution and an installation's architecture contract — and the release's known issues say so.

### 3.3 A rule that cannot be counted is not a rule

The reason for writing invariants, enforcement rules and prohibitions as list items (§4.9) is the completeness gate. Before a contract counts as implemented, a tool checks that every normative statement it makes is consumed and tested by the implementation. A tool can count list items; it cannot reliably count rules inside paragraphs. The format is what makes "did we implement everything this contract says?" an answerable question, and that is why a rule written as prose counts as a finding against the document.

### 3.4 Relations live in metadata, where tools can read them

Dependencies, overrides, precedence and supersession are fields, not sentences (§3, §6). Priority is a governance value: it sets the audit order and decides a conflict.

Because they are fields, a tool can detect a conflict and report it, which is all the standard requires of the post-processor (§6.2, §9). The reference installation goes further and runs it in strict mode at every commit to the corpus, so that most conflicts stop the commit. A tool can also generate what should never be maintained by hand: the reverse dependency lists and the reading-order index. A dependency the tool detects on its own is marked unverified until an author confirms it, and an unverified entry is not canonical (§3.2); the tool reports every one. In the reference installation such a marker still stood once at the measuring point (§ 4).

### 3.5 The audit record names the text it read

Every canonical document carries the record of its last audit, and the record says which version of the document the auditor actually read (§8).

That one field closes a specific gap. Without it, a document audited in the morning and changed in the afternoon carries an approval that may or may not cover its current text, and nothing in the document says which. With it, a record for an older version is plainly a record of a superseded state, and a record written before the field existed reads as *audited version unknown*, never as a match. Entry into the corpus needs a full audit with an approving verdict on the current version, and the author never approves its own document.

### 3.6 A contract says what, not how

A contract states behaviour; schemas, field definitions and storage belong to the implementation (§7.1). A model specification states what a model takes and produces and how it is validated, and never its formulas or coefficients (§4.7).

The boundary does two things. It keeps contracts stable when the implementation changes, so that a refactoring does not require a contract revision. And it keeps the specification readable by people outside the build — reviewers, partners, auditors — without disclosing the implementation. The behaviour can be public while the code that produces it is not.

### 3.7 The standard is the floor

The standard and its instance appendix are read together. A rule that only one installation needs belongs in its appendix, not in the standard (§1, §10), and the appendix states which version of the standard it binds and the change classes it exempts from audit (§8.2, §10). The reference installation adds a rule about the agents' own instructions: they may hold a document to something stricter than the floor, never to something looser, and an instruction that makes a finding of something the standard expressly allows gives way.

The reason is that the format should live in one place. Without such a rule, each agent's instructions slowly become their own version of the standard, and two agents end up enforcing two formats on the same corpus.

### 3.8 A closed taxonomy with a reading order

Every document declares one domain-and-layer pair from a closed list, and the appendix gives the domains a reading order, from the most constitutional to the most implementation-near (§5). Within a domain, documents are read by priority, and a tool writes the full order into the corpus index.

The order is what lets an agent that loads part of the corpus load the right part first: the constraints before the logic that operates within them. The reference installation reads the rules of the corpus itself and the constitutional architecture first, then the core model, safety, signals and execution, and advisory and user-facing documents, with research and calibration last.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02), and gives the rule that reproduces it. The case study describes that installation.

**The corpus by type.** 153 documents declare a type: 88 contracts, 14 clauses, 14 frameworks, 12 appendices, 11 governance documents, 8 registries, 4 model specifications and 2 orientation documents. They sit in nine domains; 135 are in force and 18 are deprecated. *(Documents that carry a document-type field, by its value, their domain and their status.)*

**Structure.**
- The corpus holds 1,167 second-level headers, 94 of them the prohibited-behaviour header that the contract order names. *(Headers outside code blocks in documents that carry a type; a raw count of every line that opens with a second-level header gives 1,174.)*
- The marker for an unverified, tool-detected dependency occurs once, in the parameter registry, where it should not stand. *(A search of the corpus for the marker.)* The installation carries it as a defect to fix.
- One document's first-level header does not match its title. *(The first top-level header compared with the title field.)* When the rule was introduced on 2026-10-12, two did; the rule that a version never appears in a file name, slug or title had no deviation then and was not recounted.

**Audit records.**
- 142 documents carry an audit record: 131 of a full audit and 11 of a standard audit only. Five of those eleven are documents in force. *(The audit record in each document's metadata, joined with its status.)*
- 57 of the 142 records name the version of the text the auditor read, and 56 of those name the document's current version. The other 85 do not name a version, and read as *audited version unknown*. *(The version field in the audit record, compared with the document's own.)*

What these figures show is that the format is applied across the whole corpus and can be counted: types, sections, dependencies and audit records are all fields a tool reads. They also show the cost of adding a rule to a living corpus. The version field in the audit record closes a real gap, and most of the corpus's records do not yet carry it, though 57 do where 27 did on 2026-10-16.

---

## 5 — Where This Sits in the Field

Structured Markdown as machine-readable knowledge is not a new idea, and the standard does not claim it is.

- **Documentation as data.** Stripe's Markdoc, released in 2022, treats documentation as structured Markdown with typed tags whose attributes are defined in a schema, and Stripe runs its validator at build time. By design it allows simple page logic — conditions and variables — but no loops, no variable assignment and no arbitrary code mixed with the content. It showed that a large documentation site can be maintained as data. The Contract Standard rests on the same primitives — Markdown, structured metadata, validation in the toolchain — and applies them to a different job: not rendering documentation but governing a system's behaviour.
- **Knowledge for agents.** Google's Open Knowledge Format, published in 2026, represents knowledge as a directory of Markdown files with YAML frontmatter and a small set of conventions, so that wikis from different producers can be read by different agents without translation. One field, the type, is required, and a git repository is recommended for distribution. It aims at interchange. The Contract Standard uses the same primitive with a different ambition: a closed type set, fixed section orders, declared relations and precedence, an audit record and tool classes that must refuse what does not conform.

Put simply, the formats agree on the floor and differ on how much governance they build on it. What we want to point to is not structured Markdown as such, but the combination of a format an agent reads deterministically with relations, precedence and an audit trail that tools check. We have not checked whether this combination is formulated elsewhere, and this paper makes no claim about which came first.

**Sources.** Paul, R. (2022-09-13). How Stripe builds interactive docs with Markdoc. https://stripe.dev/blog/markdoc · Markdoc documentation, https://markdoc.dev · Google Cloud blog post introducing the Open Knowledge Format, https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing · Open Knowledge Format specification, `okf/SPEC.md` in GoogleCloudPlatform/knowledge-catalog

---

## 6 — Limitations

- **Some conflicts are left to reading.** The reference installation's post-processor checks eight things at every commit: priority conflicts, overrides of a higher-priority document, broken and missing supersession, a dependency on or a full-title reference to a document no longer in force, a name form the corpus has replaced, and a precedence order stated outside the documents that own it. It does not check the other duplicate rules — a shared name, shared domain ownership without explicit layering, the same responsibility carried twice — which the auditor finds by reading. Strict mode stops a commit on every check but one: a priority conflict is rated a warning and passes, although the class allows no conflict.
- **Stale exclusions are not detected.** An exclusion of a tool-detected dependency must match a mention in the body; the tool checks only that the excluded document exists.
- **Tools that do not yet refuse an empty run.** The index generator writes an index over zero documents rather than failing, and the post-processor does not refuse a scan of zero documents.
- **The conversion tool writes before the audit.** Converting source material produces documents marked canonical before any auditor has approved them. Until that is fixed, a conversion run is a manual checkpoint.
- **Most audit records lack the version field.** For 85 of 142 records, whether the audit covers the current text is a decision for the owner, not something the record can show. Five documents in force carry only a standard-audit record.
- **Some rules can only be read.** No mechanical search separates a metaphor from plain language, and no tool checks that a document's declared type matches what its content does. These rest on the auditor's reading, which is checked by its own process rather than by a tool.
- **The standard assumes one way of writing in places.** The release's known issues list where a second installation did not fit: no type for the top documents, a reference that must use the full title where a unique key would do, nowhere to put text that has to stay in its original language, an auditor that may not be able to write its own record, a prohibition that must stand apart from the rule it qualifies, and an empty implementation scope that the standard allows.

---

## 7 — What Comes Next

- A post-processor that checks the remaining duplicate rules, detects stale exclusions and blocks on every conflict in strict mode.
- An index generator and a post-processor that fail on an empty corpus.
- A conversion tool that writes to the draft area, not the canonical corpus.
- Re-audits that bring the audit record's version field to the documents in force.
- The directions the release's known issues give for the Contract Standard, each entering it only through a new release.

---

## 8 — Map

- **The GAE overview** places the format among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - Contract Standard: the document types, metadata, structure, taxonomy, content boundaries, audit tracking and tool classes
  - The starter kit's instance-appendix template: how an installation binds the standard
  - Truth Chain Standard: the order of authority between contracts and the levels around them
  - Registry Standard: the registry that contracts cite by key
  - GIP Standard: the completeness gate that counts a contract's normative statements
- **Related white papers:**
  - *Contracts as the Source of Truth*, on why the contract decides
  - *Numberless Code*, on governed values cited by key
  - *Graph Architecture*, on the dependency graph the metadata forms
  - *Verification Architecture*, on the audit and the gates
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
