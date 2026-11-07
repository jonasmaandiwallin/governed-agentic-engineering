---
title: "Case Study: Runapp — Governed Agentic Engineering Applied"
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
    scope: "Text and structure of v0.1 (2026-10-19), and in v0.2 the new parts: the runtime boundary in § 2, the engine's reads of renamed keys in § 3.3, the round limit and the longest series in § 3.4, the sensors and the register in § 3.5, and § 4 rewritten with a rule per figure."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures about the present measured in the reference installation at corpus commit bac7817, engine commit acba054 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the runtime boundary in § 2 read in the engine, iOS app and ChatGPT app at commits acba054, 8090c02 and 47ea542; the history in § 3 read on 2026-10-19 from the repository's history, the decision log, the retro log, the compliance loop's process records, the review findings and the work items, and not recounted."
    evidence: "§ 1 states the figure rule; § 3 names the record and date of each historical figure, and § 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: the operator's confirmations, the guards in the product repositories and the declared files of the commit tool brought up to date (§ 2, § 3.2); the parser rule in § 3.5 replaced by an explanation and a pointer to the memory standard; v0.1's eight-round series, which could not be reproduced, removed from § 3.4; § 5 widened from nine to nineteen prior-art candidates; Limitations shortened to what this case adds, with scale pointed at the overview and the release's known issues; the map pointed at the release. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept. v0.2.2: brought up to gae-standards-v0.5. The cases are history and keep their dates; where a rule they describe has since entered the standards (the reviewer's finding form, stop rule and round limit in § 3.4; staging only declared files in § 3.2; the session-start sensors and the register in § 3.5), a pointer says so. Every sentence about a standard was read against the v0.5 text before the change."
    evidence: "The diff against v0.2.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline: the nine sources of the first search on 2026-10-19, and the ten further candidates on 2026-11-02, partly through the platform's research mode."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it, the agent or the research mode."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/case-study-runapp.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gal-standard.md
    version: "v1.78"
  - path: standards/boundary-standard.md
    version: "v0.4"
  - path: standards/handoff-standard.md
    version: "v0.4"
  - path: standards/gip-standard.md
    version: "v0.6"
  - path: standards/contract-standard.md
    version: "v0.7"
  - path: standards/truth-chain-standard.md
    version: "v0.6"
  - path: standards/registry-standard.md
    version: "v0.5"
  - path: standards/gem-standard.md
    version: "v0.10"
  - path: standards/backlog-standard.md
    version: "v0.9"
  - path: standards/wave-standard.md
    version: "v0.3"
---

# Case Study: Runapp — Governed Agentic Engineering Applied

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*The other papers in this package describe GAE one part at a time. This one describes the system it was developed on: an evidence-based running coach, built by one person with specification agents and implementation agents. It does not restate the method. It shows what the method caught, what it missed, and what each miss changed.*

---

## 1 — The Problem: Does the Method Survive a Real System?

A method for governing AI agents is easy to draw and hard to keep. On a whiteboard, every rule has a gate and every decision has a record. In a real build, the sessions pile up, two agents write to the same working copy, a test is green for the wrong reason, and the log meant to remember a decision has a gap that nobody noticed.

A reader of the other papers may fairly ask whether any of this holds when one person builds a real product with agents, in a domain where a wrong number can hurt someone, and which controls only looked like control until something tested them.

The question this paper answers is: **what happened when GAE was applied to building a real system, what did its controls catch, where did they fail, and what does the record show about each?**

Runapp is that system. A second installation, in another domain and set up by the same person, is described in the overview; this paper keeps to the first. It is a case, not an experiment. It has no control group and no second team, and § 6 says what that leaves open.

**The figure rule.** Every figure about the system as it is now was read at one measuring point: corpus commit `bac7817` (2026-11-02), engine commit `acba054`, and the database as loaded on 2026-11-02. § 4 gives the rule that reproduces each one. A figure from the history in § 3 keeps the date of the record it comes from. Where nothing could be measured, no figure is given.

---

## 2 — What Runapp Is

**The product.** Runapp is an evidence-based, adaptive running coach. It builds a training plan from a measurement of the runner's fitness and the runner's goal. It then adjusts the plan as signals arrive from the runner's body and life: heart rate and its variability, sleep, training load, missed sessions, reported pain. Deterministic rules make every training decision, so the same inputs give the same decisions. The rules use thresholds, such as recovery spacing, intensity ceilings and the rate of progression. Every one of them is a governed value in a registry, together with the evidence that bears it, or with an explicit statement that no evidence does. Plan design and plan quality are the subject of the Runapp and validation papers; this paper is about how the system was built. In the overview's terms Runapp is a product: software that runs without the agents that built it.

**The corpus.** Behind the product stands a specification corpus. Its documents, mostly contracts, are written in Markdown with machine-readable front matter: a domain, a layer, a status, dependencies and an audit record. The nine domains run from physiology and signals to safety, plan execution, user experience and behaviour. Contracts cite governed values in the parameter registry by key, and registry entries cite evidence records, one per study, each with its evidence tier. Beside them stand a decision log, a retro log, a work-item tracker and a folder of handoffs, through which work passes from one session to the next. They are files in one repository, with a database mirror that tools query.

**The agents.** Six specification agents are registered. A research agent reads studies and writes evidence records. A contract writer drafts and revises contracts. An auditor reviews every contract before it takes effect. An architect owns the tooling, the backlog and the boundaries. An adversarial reviewer tries to disprove finished work. A sixth agent writes explanatory articles for readers. Implementation agents work in four product repositories, among them the engine that holds all coaching logic. Each repository has a session agent, a tester that writes checks from the contract, a verifier and an implementer; the engine adds implementers for modules and endpoints, a planner and a build fixer. One human operator, Jonas Maandi Wallin, routes work between sessions and decides what the agents may not decide. He confirms every commit and push, at the time or, for a named class of work, in advance: the architect may, for instance, commit what the reads at its own session start produce. He is also the originator of the framework.

**Build-time agents, runtime determinism.** The agents build the system. They take no part in a training decision when the product runs: classifying the runner's state, setting load and granting escalation are deterministic code that reads contracts and registry values. A model runs at runtime in three places outside that layer, read in the product's code at the commits named in § 1:

- **Wording.** A language model writes the text a runner reads, from a snapshot of a decision already made. A filter checks the text; text that fails is generated again a bounded number of times and then replaced by fixed copy, and legal text never passes through the model.
- **Search.** A question typed into the search over the knowledge articles is turned into an embedding to find matching articles. It retrieves and decides nothing.
- **A chat assistant.** In the app for ChatGPT, the runner's own assistant holds the conversation and calls the engine's functions. Three of them change the plan, and they are declared to the platform as calls with consequences. The plan that results is computed by the engine.

The iOS app makes no model call of its own. A model chooses words, finds articles or decides when to call; what the plan contains stays in deterministic code. That is what makes the rest of GAE worth the effort: if behaviour is the specification executed deterministically, governing the specification governs the behaviour.

---

## 3 — Cases

Each case follows the same order: what happened, what caught it (or failed to), what it cost, and what changed. The sources are the installation's own records. Where a record does not state a cost, the case says so instead of estimating one.

### 3.1 From PDFs to governed contracts (February–March 2026)

**What happened.** Runapp's specification began as a set of PDF documents. On 2026-02-28 the corpus repository was created, with 83 documents converted to Markdown as a baseline. The 83 source PDFs were added the same day, so that the auditor could compare against them, and they are still kept in the repository. The first agent instructions were committed on 2026-03-01. On 2026-03-07 every converted document was replaced by an audited version. Over 2026-03-07 and 2026-03-08, the corpus was rewritten domain by domain to the next version of the document standard (repository history, read 2026-10-19).

**What caught it.** Two problems surfaced in the first ten days. The first was that converted text is not yet a governed contract. A conversion keeps the words, not the sections, fields and precision that tools and implementing agents need. All 83 were replaced by audited versions before any of them served as the reference.

The second problem was dependencies. A tool read the documents and proposed the dependencies it detected in the text, and some of the proposals were wrong. On 2026-03-08 the standard gained a field in which an author rejects a proposed dependency, so that the rejection stays on record instead of disappearing. The same day, a circular dependency between two adaptation documents was removed.

**What it cost.** Not measured. The repository records what was done and when, but not the hours it took.

**What changed.** The PDFs stayed as source material, never again the source of truth: a converted document takes effect only once audited. One gap from that period is still open. The installation's appendix to the Contract Standard records that the conversion tool writes its output marked as in force before any audit. The tool has not been rebuilt, because no conversion has run since. The next conversion run is the trigger.

### 3.2 The harness at the point of landing

**What happened, and what caught it.** Two incidents show the harness stopping an error where it would land.

- On 2026-07-03, a step agent switched a shared working copy to the main branch and pulled in the middle of a unit of work. The coordinator's next commit then landed on main. Every product repository now carries a guard against version-control writes. In two of them it refuses every form that writes history, references, branches or the stash; in the other two, only a command that begins with a commit or a push (*Harness Engineering*, § 4).
- On 2026-10-15, the commit tool refused a commit of four instruction files. Their shared closing sequence no longer matched the reference text byte for byte. The change was withdrawn and made later, together with the reference text.

**What failed.** The specification agents all write to one working copy through one tool server, and the server cannot tell them apart. A work item was opened to keep one session's half-finished files out of another session's commit. It was closed with that part of its acceptance criterion unmet. At least 12 retro entries between 2026-08-23 and 2026-10-14 then record another session's files riding along in a commit, or another session's work blocking a push, and no open item carried the defect in that period (counted 2026-10-14). It was found on 2026-10-14, when a review finding was traced back to the closed item and its criterion read against what had been built.

A deliberate test found a second gap. On 2026-10-09, in an adversarial review, a reviewer wrote a claim for a unit of work that does not exist. The write gate in front of the product repository then let every write through, commits and pushes included.

**What it cost.** Friction recorded in at least 12 retro entries over seven weeks. The records do not give a time cost.

**What changed.** The commit tool now requires the list of files the caller wrote, and stages only those; since 2026-10-22 a call without the list is refused with nothing staged. The Boundary Standard has since made staging only one's own files a rule for every agent (§2.1). Other uncommitted files stay in place and are named in the answer. The write gate itself was not changed after the 2026-10-09 test. What changed was the documentation's account of it: the claim is described as a local mark that stops mistakes, not deliberate bypasses, and what holds the rule that writing waits for a real claim is the queue and the detection at the architect's next session start (*Harness Engineering*, § 4 and § 6).

### 3.3 The compliance loop (spring 2026)

**What happened.** By spring 2026 the engine's tests and the contracts had drifted apart. A deep audit of the implementation recorded 266 defects, 46 of them of high severity. Among them were tests that matched faulty code instead of the contract (compliance-loop process log, opened 2026-06-10). The answer was a compliance loop over the whole corpus, one contract at a time:

1. An adversarial verifier read the contract and its test file, never the source code, and listed every requirement that no test checked.
2. A tester closed those gaps, writing from the contract and again without reading the source.
3. The verifier re-checked, for at most three rounds.
4. The code was then fixed: narrow fixes by a fixer, medium ones by an implementer. Deep changes were flagged and left for the specification-driven pipeline. Every contract ended in a commit and the operator's go or no-go.

**What caught it.** The verifier's independence did the work, because it never saw the code that the tests described. On the plan-generator contract, the tester wrote 65 tests. 40 of them were green but tested what the implementation did rather than what the contract required, and the verifier caught all 40 in its second round. In another contract, the entire suite tested a stub: 53 tests were green and none of them reached the real module. A third contract, a list of phrases the product must never show a user, had no test file at all. A probe run before any agent was dispatched showed that the contract's own example of forbidden language passed the filter that was supposed to block it. The contract went from 0 tests to 93 (compliance-loop process log and progress tracker).

**Stale and phantom values.** The loop also found values that had drifted out of line with the registry.

- One test file hard-coded a data-staleness limit of 14 days where the registry held 60.
- Other tests seeded their mock registry from the same local constants that their assertions compared against, so code that hard-coded the value instead of reading the registry would have passed. The fix was a differential test: inject a value that is not the default, and probe between the default and the injected value.

Shortly after the loop, a post-mortem found that three registry keys had been implemented and mock-seeded across several sessions without ever existing in the registry. A production crash had been masked by tests that passed (decision log, 2026-06-30).

**What it cost.** The decision log's retrospective entry, written on 2026-06-22, records 97 contracts verified against their implementations, 514 false-green tests caught, 33 fixes in the source and about 2,260 tests added. It also records that the run took about six weeks. The sprint's own table gives a test increase of 5,961 to 8,193, which is 2,232. The two records do not agree exactly, and both are given. A further cost was context. In one measured session, the process log records that fixed overhead used about half of the context consumed, which held a session to two or three contracts before the operator's 60 % context limit, today a hard stop in implementation sessions.

**What changed.** The verifier's re-check became a fixed step of the loop, not an option. The implementation agents' instructions gained two mandatory rules: confirm that a registry key exists before reading it, and seed mocks only with confirmed keys (decision log, 2026-06-30). The completeness gate was later made stricter. A value now counts as consumed only when changing it changes the behaviour, and every normative statement must map to a check. Measured that way on 2026-09-11, 22 of 132 contracts were complete on their governed values (*Loop Engineering*, § 4). Raising the standard of the sensor turned a corpus that the loop had called healed into one with most of its work still ahead. The loop found real defects at scale. It did not leave the corpus finished.

**The same class, four months later.** The rule about confirming keys is held by instruction. At the measuring point, a sweep of the engine found it reading three registry keys that do not exist. All three are older names: the keys were renamed in the contracts and in the simulator, and the rename was never carried into the engine. The sweep that found them is a measurement run, not a gate. Whether those reads fail in operation is not measured (§ 6).

### 3.4 A review loop without a stop rule, and the rule that ended it

**What happened.** In September 2026 the adversarial reviewer ran five rounds on one tooling work item: a set of gates in front of the commit tool. Round by round, the findings went from 1 blocking and 6 advisory to 0 and 7, then 0 and 5, 0 and 3, and 0 and 1. The series was converging, but slowly, and partly on itself. Three of the late advisory findings were the reviewer's own fix proposals from earlier rounds, coming back as new findings (retro log, 2026-09-15).

**What caught it.** The retro entry for the fifth round names the pattern: a reviewer that writes fixes, rather than the invariant a fix must meet, drafts its own next findings, and a loop with no explicit stop criterion produces hardenings of hardenings until someone ends it from outside. The decision log adds that the rule against reviewers writing fixes already stood in the reviewer's instructions: it was triggered five times in the series and followed none of them (decision log, 2026-09-16).

**What it cost.** Five review rounds, each followed by a fix round. The records give no time cost.

**What changed.** Four things, written down between 2026-09-16 and 2026-10-05.

- Findings now carry an invariant and a test, not a fix (2026-09-16).
- The series has a stop rule that a tool reads from the review's handoff, not one the reviewer remembers: no blocking finding in two consecutive rounds closes the series.
- On 2026-09-18, series that end in advisory findings only got their own exit. Each advisory finding states whether it establishes a new rule or applies an existing one, and a finding that only applies an existing rule no longer opens another round.
- On 2026-10-05 the reference installation set a limit: after two rounds without approval, the next step is the owner's: close, with the open findings carried by other work items, or ask for a third round (*Verification Architecture*, § 3.5).

Three of the four are now in GAL: the finding's form and the stop rule (§9.5), and the two-round limit (§9.7). The exit for series that end in advisory findings is still the installation's own.

**How long a series could run.** Before those rules, nothing bounded a series. The longest series of review rounds under one name ran to 35, on a work item closed on 2026-09-14. Across all series, 206 handoffs have gone from the reviewer back to the architect, and 118 of them carry a closure verdict: 50 *yes*, 28 *partial* and 40 *no* (§ 4 gives both rules).

### 3.5 Memory: where coherence held and where it broke

Every session in Runapp starts cold. What it knows comes from the handoff, the two logs and the learnings that a tool selects for its task.

**Where it held.**
- Retro entries are written in a fixed form, with a scope, the friction and a named pattern. At the measuring point, 517 of the 1,589 retro entries in the database had been returned to a reader at least once.
- Patterns that recur are triaged. Since 2026-10-20 the triage runs as a sensor at the architect's session start: a read that never stops work and whose finding becomes an action. Its first reading found nine patterns at the threshold with no work item. At the measuring point, 12 patterns stood at the threshold, every one carried by an open item. Triage runs only at that session start, not between sessions. GAL now names such sensors as part of the architect's start (§4.2).
- A measurement that a session could not make is carried in a register until someone makes it, as the standards now require (GAL §4.7.4, Handoff Standard §7). At the measuring point the register held 92 open entries, and results had been recorded for 145. Before the register, 49 of 73 such entries stood only in handoffs, reports and review files, and 9 had fallen out of their chains without a result (counted 2026-10-21).
- The shared-working-copy defect in § 3.2 could be traced to its closed item only because the item, its criterion and the retro entries were on record.

**Where it broke: a gap in the decision log.** On 2026-06-22, the architect found that about three months of decisions on contracts, governance and agent instructions had not been written to the decision log. The compliance loop in § 3.3 was among them. They were reconstructed from commit messages, at lower detail. The root cause recorded in the backfill entry is plain: throughput was high, and the logging step was skipped (decision log, retrospective block, 2026-06-22).

**Where it broke: a parser that dropped entries.** Between the retro log and the agents stands a parser that loads entries into the database, from which the learnings are selected. Eight retro entries used a heading form that the parser did not recognize. The first is dated 2026-07-07 and the last 2026-09-15. Each unrecognized entry's fields were written into the entry above it, and six of the eight overwrote that entry's fields. One overwritten row had been returned to readers 20 times with another entry's content. In the decision log, 52 entries with a heading at a different level were neither stored nor reported (review findings, 2026-10-13).

Both parsers passed their own check, because that check compared the number they stored with the number they had parsed, and both numbers came from the same parser. The adversarial reviewer found the defect on 2026-10-13 by counting a different way. It counted the heading lines in the file with a looser pattern of its own, got 1,360 against 1,352 stored, and looked at the eight that were missing. The defect had been in place for 98 days.

**What it cost.** 98 days in which the memory could return wrong or missing learnings without saying so, and one review round to find it. The fix closed on 2026-10-15.

**What changed.** The fix was to count twice, by two rules, and to fail when they disagree. The memory standard makes that a condition of every log parser (GEM § 8): a parser whose count is checked only against itself does not conform, whatever it reports.

**A loop that has not converged.** The most frequent named pattern in the retro log is taking a count or a claim on trust instead of measuring it. At the measuring point it had 152 entries, from 2026-09-24. A countermeasure was put in place and closed on 2026-10-03; on 2026-10-13 a regression item counted 44 entries after it. The pattern was then accepted, with a re-review date of 2026-11-12, and 18 more entries have followed. The memory detects it reliably. It has not yet made it go away. The parser break and this pattern belong to the same family: a number that was believed instead of counted.

---

## 4 — Measured and Shown

Every figure below was read at the measuring point in § 1: corpus commit `bac7817` (2026-11-02), engine commit `acba054`, and the database as loaded on 2026-11-02. Each gives the rule that reproduces it.

**History.**
- 11,340 commits, from the first, dated 2026-02-28, to the measuring commit, 247 days later. *(The commit count of the measuring commit's history; the days between the first commit's date and the measuring commit's.)*

**The specification corpus.**
- 153 typed documents in nine domains: 88 contracts, 14 clauses, 14 frameworks, 12 appendices, 11 governance documents, 8 registries, 4 model specifications and 2 orientation documents. 135 are in force and 18 are deprecated; of the 88 contracts, 83 are in force. *(Documents that carry a document-type field, by their type, status and domain fields.)*
- The parameter registry holds 926 entries, 63 of them deprecated, and the database mirror holds the same. Of the 863 live entries, 218 state that no evidence bears them. *(The registry sync's extraction rules over the registry file; an evidence field that reads none.)*
- 960 evidence records, one file per study, and 961 rows in the database: one row has no file. 871 records are in force — 390 at tier 1, 403 at tier 2 and 78 at tier 3 — and 90 are tombstoned. *(Files that carry an evidence ID; the database's status and tier fields.)*

**The standards and the agents.**
- 10 GAE standards: the Governed Agent Lifecycle, Boundary, Handoff, Governed Implementation Pipeline, Contract, Truth Chain, Registry, Governed Engineering Memory, Backlog and Wave Standards.
- 6 specification agents in the version registry, each with the version of its instructions in force.
- In each of the four product repositories, a session agent, a tester, a verifier and at least one implementer are defined (§ 2). *(The repositories' agent definitions.)*

**The records.**
- The work-item tracker holds 1,267 items: 1,120 done, 102 pending, 16 blocked, 14 open, 13 in progress, 1 awaiting a discussion and 1 ready. *(One item per work-item file, by the `status` field in its front matter; the database mirror gives the same distribution.)*
- The retro log file holds 1,550 entries, the first dated 2026-04-19, and 39 more from implementation sessions' reports are stored beside them in the database. *(A line that opens, after at most eight non-alphanumeric characters, with the word RETRO, case-insensitive — the looser rule of § 3.5.)*
- The decision log holds 1,703 entries, the first dated 2026-03-09, the same number in the file and the database. *(A heading that opens with a full date, the parser's rule.)*
- The handoff folder holds 1,490 Markdown files, handoffs and briefs, and 1,643 with its subfolders of test fixtures and task specifications. *(Files at the folder's top level; all files under it.)*
- The folder of adversarial review findings holds 307 files, 271 of them named as a round of a review. *(Files at the folder's top level; a name that ends in a round number.)*
- The adversarial reviewer has sent 206 handoffs back to the architect; 118 carry a closure verdict: 50 *yes*, 28 *partial* and 40 *no*. *(Handoff files whose name marks them as reviewer-to-architect; a verdict is the closure line opening with yes, partial or no.)* The same rule over the files up to 2026-10-19 gives v0.1's 96 verdicts: 40, 25 and 31. The longest series under one name has 35 rounds. *(Review files named with a round number, counted per name.)*

**The gates.**
- The commit tool for non-canonical files reports up to 15 named checks, each triggered by what is staged. *(Distinct check labels in the tool's status lines, in the server's source.)*
- Since 2026-10-02, 31 units of work have passed the gate in front of the implementation queue: 25 are done and 6 were superseded. All 31 were task work, and none names a contract. Their 282 step receipts include 14 test reviews that found gaps in the checks and 3 code reviews that disproved the change. *(The queue's posts after the gate, by status and driving contract; their receipts by step and verdict.)*

**What the figures and cases show.** The installation is large enough for its own governance to fail in ways a small project would not: two sessions' files in one commit, a parser wrong for 98 days, a review loop hardening its own hardenings, a renamed key that the engine still reads by its old name. In each case in § 3, the failure was found by something the method put there: an auditor, an independent verifier, a count made a different way, a retro entry naming the pattern, a sweep. Several rules the standards now hold were written in answer: the parser's independent count, the reviewer's stop rule, the commit that stages only declared files.

---

## 5 — Where This Sits in the Field

Spec-driven development has made the specification a first-class artefact in agent-assisted coding, and several tools already separate roles around it. Two searches for this package read nineteen candidates on how agents that write specifications are governed. The first read nine: Birgitta Böckeler's account of spec-driven development tools, GitHub's Spec Kit, AWS Kiro, BMAD-METHOD, MetaGPT, MARE, Bertrand Meyer's keynote and paper on agents for requirements, contracts and proofs, Warp's agents, and Simon Martinelli's AI Unified Process. Spec Kit describes its checklists as reviewer-owned artefacts that the implementation may not silently self-approve. BMAD-METHOD runs reviews in a fresh context, without the original reasoning, and puts a readiness gate before implementation. Warp has described separate agents for writing specifications, reviewing and triage, with changes to the agents' own skills going through ordinary pull-request review. The second search added ten; the nearest are Tomašev, Franklin and Osindero's framework for intelligent delegation, which treats roles, boundaries and contracts as part of delegation, and Wang's VibeContract, in which a model generates contracts that developers validate. These are partial predecessors of what this case shows. Runapp's arrangement did not arise in a vacuum, and it is not presented as if it did.

What the case adds is a record of one installation in which the specification itself is governed the way code is: rules and values that cite evidence, review by someone other than the author before a document takes effect, and a route back to the contract for every gap the build finds. None of the nineteen required both of the first two together. The nearest on evidence, Google's OKF specification, attributes claims to sources but makes its trust tiers advisory. The searches covered the candidates named and no others, so they do not show that no one does this, and this paper makes no claim that Runapp was first.

**Sources.** Böckeler, B. (2025-10-15), on spec-driven development tools, martinfowler.com, https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html · GitHub Spec Kit, documentation · AWS Kiro, documentation · BMAD-METHOD, repository and documentation · MetaGPT, arXiv:2308.00352 · MARE, arXiv:2405.03256 · Meyer, B. (2026). *Software Verification in the Age of Artificial Intelligence*, keynote, Swiss Testing Day, Zürich, 26 March 2026; and arXiv:2511.23159 · Segner, M. (2026-08-26), Claude blog post on Warp's agents, https://claude.com/blog/how-warp-builds-self-improving-agents-on-claude · Martinelli, S. (2026-08-27), on the three levels of spec-driven development, https://martinelli.ch/the-three-levels-of-spec-driven-development-and-where-the-ai-unified-process-sits/ · Tomašev, Franklin & Osindero (2026-02-12). *Intelligent AI Delegation*. arXiv:2602.11865 · Wang, S. (2026). *VibeContract: The Missing Quality Assurance Piece in Vibe Coding*. arXiv:2603.15691 · Google Cloud, OKF specification, `okf/SPEC.md` in GoogleCloudPlatform/knowledge-catalog

---

## 6 — Limitations

- **Two installations, one originator.** Every case comes from one system built by one person; a second installation, set up by the same person, carries no case here. Nothing here shows that the method transfers to anyone but its originator, or to a team, or compares it with building the same system another way; what the second installation shows about a domain other than training is set out in the overview (§ 4). How the method might scale, and what it lacks for that, is set out in the overview (§ 6.2) and in the release's known issues.
- **Self-recorded logs.** The decision log and the retro log are written by the agents and the operator they describe. § 3.5 shows both a three-month gap and a parser that dropped entries for 98 days. Sources also disagree at the margin: the compliance loop's test increase is 2,232 in one record and 2,260 in another. The figures in § 4 were all read at one measuring point; earlier versions of the package read them on other dates, under rules not always written out, and are superseded.
- **Costs are mostly unrecorded.** The records state what was done and when, rarely how long it took, and never what the whole build cost in money or tokens.
- **Current state and target state.** The compliance loop of § 3.3 is the predecessor of the current contract-driven pipeline, which has not yet run: none of the 31 units after the gate names a contract. Under the stricter completeness gate of 2026-09-11, most contracts were not complete on their governed values. The harness gaps listed in *Harness Engineering* § 6 are open, among them the absence of a per-agent write guard in the specification repository.
- **Not measured.** This paper reports no outcomes for runners; the plan-quality and simulation work is reported elsewhere. It does not measure whether the memory has reduced recurring friction; the most frequent pattern in § 3.5 says it has not yet done so for that pattern. It does not measure whether the engine's reads of the three renamed keys in § 3.3 fail in operation. And it does not measure how many defects the method missed entirely, since only what was found can be counted.

---

## 7 — What Comes Next

- The first contract-driven unit of work under the current pipeline. It is the part of the method that this case can describe only through its predecessor.
- The engine brought onto the registry's current key names, which is open as a work item.
- A second count of every figure in § 4 at release, with the release date, so that the paper never carries a stale number as if it were current.
- A countermeasure for the count-on-trust pattern that makes it recede, not just a record of it recurring. Its re-review date is 2026-11-12.

---

## 8 — Map

- **The GAE overview** places the reference installation among the parts of the framework, and describes the second installation.
- **The release:** the ten standards (GAL, Boundary, Handoff, GIP, Contract, Truth Chain, Registry, Governed Engineering Memory, Backlog and Wave), the starter kit and the list of known issues, in the GAE repository. The Memory Standard holds the parser rule of § 3.5; the GIP Standard holds the build loop that succeeds the compliance loop of § 3.3.
- **White papers:**
  - *Agent Roles and Orchestration: The Specification Agent's Mandate*
  - *The Canonical Standard: One Document Format for Agents and People*
  - *Contracts as the Source of Truth: The Truth Chain*
  - *Harness Engineering: Infrastructure That Holds the Rules*
  - *Loop Engineering: Designed Loops That Converge*
  - *Verification Architecture: Four Levels, Independent by Design*
  - *Spec-Governed Dispatch: The Factory Floor*
  - *Graph Architecture: Explicit Structure Over Implicit Convention*
  - *Numberless Code: Keeping Every Governed Value in One Registry*
  - *Context, Coherence and Memory: How an Agent System Remembers What Its Agents Forget*
- **The other parts of the work:** Runapp itself, in the `runapp-platform` repository; and the simulator and the QDOT plan-quality model, used to investigate and validate what Runapp produces, in the `runapp-validation` repository.
- **Under NDA:** *Governance Log Analysis* holds the structured extraction from the decision and retro logs behind § 3.3 and § 3.5.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
