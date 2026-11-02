---
title: "Numberless Code: Keeping Every Governed Value in One Registry"
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
  - model: "Claude Fable 5.1"
    model_id: "claude-fable-5-1"
    roles: [review]
    source: handoff
ai_disclosure:
  - role: drafting
    status: complete
    scope: "Text and structure of v0.1 (2026-10-16), written in a session whose handoff named the model, and in v0.2 § 3.3 and § 4 rewritten after the reference installation's reclassification of its values."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817, engine commit acba054 and the database as loaded on 2026-11-02, each with the rule that reproduces it; statements about the reference installation's tools read in its instance appendix and tool source."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 2 and § 3 rewritten as explanation with pointers, where v0.1 restated the Registry Standard closely; the class for values in use without demonstrated support added to § 3.3, which v0.1 did not name; § 4 recounted with a fresh code sweep; Limitations brought up to date with the release's known issues; the map pointed at the release."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: not-applicable
    scope: null
    evidence: null
    reason: "§ 5 names no specific external source; it cites only general ideas (named constants, external configuration, evidence-based practice, falsifiability)."
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings; two advisory findings stay open for the next revision: sentences sharing a run of ten or more words with the standards' wording, and a release-tool form that none of the twelve papers contains."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/numberless-code.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/registry-standard.md
    version: "v0.4"
  - path: standards/contract-standard.md
    version: "v0.6"
---

# Numberless Code: Keeping Every Governed Value in One Registry

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*A threshold written into a specification, and again into the code that implements it, is two thresholds the moment one of them changes. This paper is about the rule that removes the second copy, and about what a value has to carry before an agent may use it.*

---

## 1 — The Problem: A Number Goes Stale Where It Stands

A system that makes decisions is full of numbers: how many sessions before a state may change, how far a value may move in a week, at what point a signal counts as a warning. Each number is a decision. Most of them are written down more than once — in the specification, in a table that explains it, in the code that implements it, in a test that checks it.

When the decision changes, every copy has to be found. The copy nobody found keeps the old value, and nothing says so. The specification and the code now disagree, and the system's behaviour follows whichever copy the running code happens to read.

Agents make this worse in two ways. An implementing agent reads the value it sees. If a specification shows a number inline, the agent writes that number into the code, and the code is correct today and wrong after the next change. And an agent that needs a value no one has specified does what a capable engineer under time pressure does: it picks a sensible number and moves on. The number works, and the code now carries a decision that no specification made and that no evidence supports.

The question this paper answers is: **where does a governed value live, and what must it carry, so that changing it once changes it everywhere, and using it is never a guess?**

---

## 2 — What It Is: The Registry Pattern

Governed agentic engineering (GAE) keeps every value that a contract governs in one registry, one entry per key. A contract cites the key and the implementation reads it; neither carries the number. Every entry says, besides its value, where the value came from and how sure it is. Sweeps read the contracts and the code for the values that should have been keys.

The registry has a database mirror that implementations read by key. The registry file is the record and the mirror is derived from it (Registry Standard §5).

The Registry Standard is the reference for the entry, its references, its lifecycle and the tools around it, and the Contract Standard owns the rule that a contract cites a governed value by key (§7.2). This paper explains why the registry is built the way it is and does not restate those rules.

---

## 3 — The Load-Bearing Ideas

### 3.1 One value, one place

The core rule is that a governed value stands in one place, under one key, and everything else carries the key (Registry Standard §1, §3).

What the rule buys is that a contract stays correct *without being edited* when a value changes. A contract that names the key that governs a threshold is still true after the value moves. A contract that writes the number down is a second source of truth, and it will eventually disagree with the first.

What the rule costs is that a constant in code becomes suspicious by default. One whose value equals a registry value may be a copy of it; one that equals none may be a decision no contract made. The sweep names both, and someone decides.

There is no readability exception. A number shown inline for the reader's convenience is exactly the number an implementing agent will copy.

### 3.2 Every value says where it came from

A value without a source cannot be checked, and an agent cannot tell it apart from a guess. So every entry carries its provenance: what it governs, its source, the evidence that bears it, a confidence level and a derivation class (Registry Standard §2.2).

Two choices in that list do most of the work. The evidence field is never blank: "no evidence bears this value" is a claim someone made and can be held to, while a blank cannot be told apart from a field nobody filled in. And an entry that lacks a field stays readable but is named as incomplete, so missing provenance is reported instead of being hidden behind a default.

### 3.3 A parameter is a hypothesis

The derivation class carries the idea at the centre of this paper. It says how a value relates to its source: stated by it, derived from it by a calculation, interpolated between sources, corroborated from a figure, calibrated against a model — or none of these. The classes are a closed set, defined in one place (Registry Standard §2.3).

Two classes say *none of these*, and they are the important ones.

- **An engineering default** is a value the system chose where the source establishes the concept but not the number. It comes with a stated rationale.
- **A value in use without demonstrated support** is a value the system already relies on, whose origin was investigated and could not be shown. The class can only be given retroactively, never to a new value, and every value in it points to an open work item that must move it to the class the investigation supports.

Both are, in Karl Popper's sense, hypotheses that have not been exposed to a test, and the registry marks them as such. The system therefore declares, in a field a tool can count, which of its decisions it has not tested. That turns a vague worry ("how much of this is made up?") into a query, and gives research a work list: a value that moves from one of these classes to *derived from a source* is a measurable step.

The second class exists because the first can be claimed too easily. A value marked as derived from a source looks supported; whether the source says it is a separate question, and § 4 shows what the answer did to the registry's own figures.

### 3.4 Contract first

An implementation that needs a value no contract specifies has found a gap in the contract. It reports the gap as a finding against the contract and does not add a key (Registry Standard §4.1).

The order matters because of what a key carries. A key added because the code needed one brings the code's assumption into the registry, where it acquires the authority of a governed value without ever having been specified or reviewed, and the registry then confirms the implementation instead of governing it. For the same reason, a key the code already reads is examined against its evidence rather than confirmed because it is in use.

### 3.5 A change is made once, and recorded

A value changes in the registry only, and the change is logged with its reason and the source of the new value (Registry Standard §4.2). The contracts that cite the key need no edit, and the implementation reads the new value at its next load.

The log entry is what makes the change reviewable later. Without it a registry that changes is a mutable table; with it, every value has a history of who changed it, when and on what evidence.

### 3.6 Deprecate before removing

A key is deprecated before it is removed, keeps its value while deprecated, and is removed only when nothing depends on it any longer (Registry Standard §4.3).

This protects against the quiet failure where a contract cites a key that no longer exists, and an implementation that cannot find it falls back to something — a default, a zero, an old cached value — without anyone noticing. § 4 shows the closely related failure of code that reads a key under a name the registry no longer uses.

### 3.7 Sweeps are the verification

A rule that no tool checks is a hope. The registry is checked from both sides: a code sweep for literals that equal registry values and for keys the code reads that the registry does not hold, a contract sweep for values written inline and for cited keys that do not exist, and the completeness gate for keys a contract cites that the implementation does not consume (Registry Standard §6; Contract Standard §9).

All of them follow the zero-result rule: a sweep that read zero files, or found zero keys where the registry plainly holds them, fails. A clean result from a sweep that read nothing looks exactly like a clean result from a clean codebase, and only the failure tells them apart.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02), engine commit `acba054` and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The registry.** *(Key blocks in the registry file, by the sync's own extraction rule; the mirror gives the same.)*
- 926 keys, of which 63 are deprecated and 863 live.
- Derivation of the 863 live keys: 569 in use without demonstrated support, 232 engineering defaults, 29 derived from a source, 26 stated by a source, 3 calibrated against a model, 2 corroborated from figures and 2 interpolated between sources.
- 218 of the 863 live keys state that no evidence bears them. Every key carries the evidence field; the sync refuses a key without it.

**What the reclassification did.** v0.1 of this paper counted, on 2026-10-16, 637 live values classed as stated by or derived from a source, and called the engineering defaults, a quarter of the registry, the important class. In October 2026 the installation applied what its derivation definitions require of those classes: the place in the source for a stated value, the written calculation for a derived one. Values that could not show it were reclassified as in use without demonstrated support, with their values and confidence unchanged, and each with an open work item. 55 live values carry a source class today. Two thirds of the live registry, 66 per cent, is a declared, untested assumption inherited from use, and a further 27 per cent is a declared engineering choice.

That figure is not a measure of quality. It is the size of what the system has not shown, and it is visible because the field exists and because someone checked the claim the field made.

**Confidence.** *(A `Confidence:` clause in the key's block in the file; a non-empty confidence in the mirror.)* The file states a confidence level for 841 of 926 keys. The mirror holds one for 551, because the sync reads the level in only one of the two places the file writes it. § 6 returns to this.

**A code sweep.** *(The code sweep's report at engine commit `acba054`, run 2026-11-02.)* The sweep read 123 implementation files against the registry's 926 keys and found:
- 194 distinct keys read by the code, 21 per cent of the registry;
- 3 keys the code reads that the registry does not hold. All three are older names of keys the registry renamed; the rename was carried into a contract or into the simulator, and not into the engine;
- 23 constants in 13 files whose value equals a registry value;
- 81 lines that mention a missing key, a planned key or a hardcoded value. The sweep does not tell which of them are gaps.

Most of the 23 are coincidences of value: a retry count of 2, a day of the week, the bounds of a percentage, each matching unrelated keys that happen to share the number. At least one is a genuine copy: a population fallback for a physiological maximum, written as a constant with the same value as its registry key. The three renamed keys are the failure § 3.6 is about, reached by another road.

What these figures show is that the registry's provenance fields are filled, counted and acted on, and that the sweeps find both real copies and noise. They do not show how many governed values remain in code that no sweep has read; § 6 says where the sweeps are blind.

---

## 5 — Where This Sits in the Field

Moving numbers out of code is old advice. Named constants replaced magic numbers in the programming literature decades ago, and external configuration — values read from the environment rather than compiled in — is standard practice in deployed services. The registry pattern sits at the end of that line: one step further than configuration, because every value must also say where it came from and how sure it is.

Two older ideas explain that step.

- **Evidence-based practice.** Clinical medicine learned to ask of every recommendation which evidence supports it and how strong that evidence is. The registry asks the same of every governed value, and records the answer in the entry, including the answer "none".
- **Falsifiability.** Popper's point that a claim is scientific only if it says what would refute it applies to parameters too. A value marked as untested says, in effect: this has not been exposed to a test. A value derived from a source says which source would have to be wrong for the value to be wrong. Both are more honest than an unmarked number.

What we want to point to is not externalising values — that is common — but making each value **carry its own provenance in fields a tool can count**, and making the contract, not the code, the reason a value exists. We have not checked whether this combination is formulated elsewhere, and this paper does not claim it is new.

---

## 6 — Limitations

- **The mirror is not field-complete.** In the reference installation the sync that builds the database from the registry file reads a confidence level in only one of the two places the file writes it, has no place for the *governs* and *source* fields, and stores an explicit "no evidence" the same way as a field never read. A reader of the database therefore sees less provenance than the file holds. The file is the record, but implementations read the mirror.
- **Deprecation is not enforced at the reader.** The implementation's registry loader returns a deprecated key as live. The marker exists in the registry and the mirror; the code does not act on it.
- **Sweeps report; few block.** The code sweep never fails its run, matches by value rather than meaning (so it reports coincidences), recognises fewer read forms than the completeness gate, and reads one implementation repository. The contract sweep stops a task from being dispatched, but skips a bare number with no unit or operator and does not check that a cited key exists.
- **A renamed key is not followed into the code.** The three keys of § 4 were renamed in the registry, and the engine still reads the old names. Whether those reads fail at run time has not been measured.
- **Provenance is only as good as the evidence registry.** An entry can cite evidence that does not say what the entry claims. Checking that is the job of evidence verification, not of the registry; the registry only records the link. § 4 shows how far apart the two can be.
- **Definitions are not governed values.** Lookup tables that define things (types, categories) sit beside the governed registry in the same mirror but carry no provenance fields, and the standard does not bind them.
- **The standards leave three gaps around the registry**, all in the release's known issues:
  - Confidence and evidence tier have no rule between them, so nothing stops a value's confidence from exceeding the strongest evidence it cites.
  - The registry records what a value rests on, not when: a value's history of class and status is not kept with its time.
  - The record must be a file. An installation whose agents can write only a database has no form in the standard.

---

## 7 — What Comes Next

- A sync that writes every field the file holds, distinguishes "none" from unread, and compares what it wrote with the file.
- Registry loaders that refuse or flag a deprecated key, and a rename that is followed into the code that reads the old name.
- Sweeps that fail on a real finding, so that a hardcode blocks a merge instead of appearing in a report.
- The work items behind the untested values, each moving its values to the class the investigation supports.
- In the standards, as directions in the release's known issues: a rule binding confidence to evidence tier, time on a value's changes, and a database table as a possible record.

---

## 8 — Map

- **The GAE overview** places the registry among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - Registry Standard: the entry, its references, its lifecycle, the mirror and the tool classes
  - Contract Standard: the rule that a contract cites a governed value by key, and the completeness gate
  - Truth Chain Standard: what a contract that cites a deprecated key holds, and the link from a value to evidence
  - GEM Standard: the form of the log entry a change of value writes
- **Related white papers:**
  - *Contracts as the Source of Truth*, on why the contract and not the code decides
  - *Graph Architecture*, on the evidence graph that the registry's evidence field links into
  - *Verification Architecture*, on the gates and sweeps as mechanical verification
  - *Case Study*, on the reference installation
- **NDA:** *Harness Gate Specification* describes the sweeps and gates of the reference installation in implementation detail.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
