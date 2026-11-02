---
title: "Spec-Governed Dispatch: The Factory Floor"
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
    scope: "Text and structure of v0.1 (2026-10-16), and in v0.2 § 4 rewritten with a rule per figure and the main branches' explained commits."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the session-start detection read on 2026-11-02."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 3.2–3.6 rewritten as explanation with pointers to the standard; the options the standard leaves to an installation — a product as paths, the first post, acceptance with open findings carried — named, with which the reference installation uses; the sibling search placed where it runs; a claim about the main branches corrected; Limitations brought up to date with the release's known issues; the map pointed at the release. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 (Böckeler, Martinelli) checked against their primary sources by Research Pipeline on 2026-10-19, and Böckeler's definition of spec-as-source again on 2026-11-02."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/spec-governed-dispatch.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gip-standard.md
    version: "v0.5"
---

# Spec-Governed Dispatch: The Factory Floor

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*Between a governed specification and governed code there is a handover: someone decides what to build next, writes down what is to be built, and gives it to the agents that build. This paper is about making that handover a gate rather than a conversation — and about why the specification governs the work for as long as the work exists, not only at its start.*

---

## 1 — The Problem: The Gap Between the Specification and the Build

A system can govern its specifications carefully and its code carefully and still lose the thread between them. The loss happens at dispatch: the moment work is chosen, described and handed to the agents that build.

It goes wrong in four ways.

**The task is described from memory.** Whoever writes the task summarises the specification instead of pointing to it, or points to a discussion instead of stating the finding. The build agent works from the summary, and the summary is where the error is.

**The task plants its answer.** "Fix the rounding in the pace calculator" tells the build agent what the cause is before anyone has measured it. An agent asked to confirm a hypothesis will confirm it.

**The scope is a list, not a goal.** "Wire these six values" is done when six values are wired, even if the logic around them is wrong and a seventh was missed. The task ends, and the specification is still not met.

**Work starts beside the path.** A small fix is made directly, because the formal path is too heavy for it. The fix is fine; nobody can tell afterwards that it happened, what it was measured against, or whether it was reviewed.

Each of these leaves the specification nominally in charge and practically ignored. The question this paper answers is: **how does work reach the implementing agents so that the specification governs what is built, the scope is measured rather than listed, and every piece of code on the main branch can be traced to a passed gate?**

---

## 2 — What It Is: Dispatch as a Gate, Build as a Loop

In governed agentic engineering (GAE), all work that changes a product goes through one pipeline in two steps. A product is either a whole repository or the path prefixes within one that the installation declares as the product; in the reference installation each product is a repository of its own.

- **Step 1 — dispatch.** The architect turns a backlog item into a queue post. Before the post may exist, a set of checks runs and is written down as a gate record. The post names the task specification, the entry it came from, and the build loop it must run.
- **Step 2 — build.** A session agent claims the post and runs the loop the post names, with its step agents: a contract loop for work driven by a contract, a task loop for work driven by acceptance criteria. The loop ends with a merge that is reported and checked.

There are two ways into step 1. In the first, the architect takes a backlog item and dispatches it. In the second, the architect works through the contracts the completeness gate still reports as incomplete, one at a time. Both run every check; neither is a shortcut.

The specification governs throughout. It decides what is built, it is what the checks are written from, it is what the build reports back against when it cannot follow it, and it is what the gate measures afterwards to decide whether the work is done. That is why the approach is called spec-governed rather than spec-first: the specification is not only a starting document for the task at hand, but the standing authority the code is measured against for as long as the code exists.

The rules stand in the GIP Standard, which is the reference and is not restated here.

---

## 3 — The Load-Bearing Ideas

### 3.1 No post without a passed gate

A queue post is the only thing a session agent can build from, and the tool that creates posts refuses one without a gate record. It checks that the record stands in the decision log in the required form and names this post's contract or specification, that the specification is committed on the remote, that the posts it depends on are in the queue, and that the main branch of the product repository is green.

The question "was the protocol followed?" therefore never has to be asked of a post: the post is the proof. GIP makes one exception, for an installation's very first post, which builds what the gate itself needs and so cannot pass it (GIP §3). It lapses at that post's merge, and its queue entry says what replaced each requirement. The reference installation never used it: every product repository had its queue, its suite and its gate before the exception was written.

### 3.2 The specification is fixed before dispatch, never in the task

For contract work, the specification side is settled first (GIP §4.2): no open dispute against the contract, every governed value read from the registry by key, a measurement of what the code lacks, and the gate record. A value the sweep finds written inline, or a value without a key, is fixed in the contract and the registry before dispatch. The task specification never patches the contract it is dispatched from, because the build would then be measured against a contract nobody audited.

### 3.3 Scope is measured, not listed

The task's scope is what the completeness gate measured before dispatch, and the task asks for the contract to be complete (GIP §4.2, point 3). A list of values to wire would miss the logic that already reads a value and gets it wrong, and the next value nobody listed.

### 3.4 A task specification is self-contained and asks openly

The task specification carries what the build needs to start without asking: what drives it, what the target files and the system already hold on the question and where the architect looked, the data and the call sites, the checks the change touches, and every path, read in the repository before it was written (GIP §4.3).

Two things it never carries. It never points to another file where a finding should be stated, and a session agent that meets a pointer instead of a finding does not start. And it never plants a hypothesis about the cause: it states what is observed and asks what is wrong. Both rules exist for the same reason: whatever the specification leaves unsaid, the build fills in from somewhere less governed.

### 3.5 What exists is read, not inferred

Before a contract is dispatched, the architect reads the code that owns it and records whether the work is new, already covered, or partly covered with the gaps listed. A contract's name, or a file name that looks right, is not a reading. For a defect, the specification names the pattern and lists each place in the code that repeats it, so that the post fixes the class rather than one instance.

GIP lets the session agent run that search when it claims the post, if the architect cannot reach the code. In the reference installation the architect searches at dispatch, and it is the only search of its kind.

### 3.6 Nothing reaches the code from a scan

Where a defect was found — in a scan, a review or a build — is never where it is dispatched from (GIP §4.1). It is filed as a backlog item and enters by the first entry, with its own gate record. What a build sees beside its post — a gap in another contract, a defect outside its task — is reported, never fixed in the post. The build stays the size its gate measured.

### 3.7 The cheap way through is the normal way

A small fix goes through the same pipeline as a large one, as a short task specification with one acceptance criterion. That is what keeps the emergency path for emergencies. A pipeline that is expensive to use for small changes will be bypassed for them, and the bypasses will be the changes nobody can trace.

### 3.8 The post names the loop

The session agent does not choose how to build. The queue post names the loop — contract or task — and the session agent starts that loop. Every step leaves a receipt with the post, and the post counts as done only once its merge on the main branch has been reported and its check confirmed — for contract work, also once the completeness gate, run after the merge, finds nothing missing in the contract.

A loop ends at a hard stop, and it is then the owner who chooses between continuing the post, splitting it and sending it back to dispatch. GIP lets an installation also allow the owner, at a review limit, to accept the post with the review's open findings carried as backlog items. The reference installation does not allow it.

### 3.9 What the gate misses is detected afterwards

At every session start, the architect reads what has happened since the last: unread reports from build sessions, posts built but not merged, posts claimed without a sign of life, and every commit on the main branch of each product repository that no queue post explains. A commit that cannot be explained becomes a backlog item or is reverted, and is then entered in a register beside the queue under that item's name. The gate is meant to stop work beside the queue; the detection is what makes the claim that it did checkable.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The queue.** *(Posts that are not marked legacy, by repository, loop and status.)*
- 31 posts have passed the gate, created between 2026-10-02 and 2026-10-09: 11 in the engine, 9 in each of the iOS and ChatGPT apps, and 2 in the simulator. All 31 ran the task loop; no contract-driven post has run. No post has been created since.
- 30 specifications stand in the product repository and 1 in the architect's repository, for a repository whose own specifications would have triggered a redeployment.
- 25 are done, each with its merge commit reported and verified; 6 were superseded. The median time from post to done was 2.9 hours, between 0.65 and 47.7.
- The queue also holds 544 posts from before the gate, marked as legacy: 538 done and 6 reverted. They are kept as history and never counted as passed.
- 1 of the 31 posts names a post it waits for.

**Gate records.** *(Decision-log headings of the two gate types, dated from 2026-10-02, when the gate was introduced; the 95 older headings of the same names belong to the legacy flow before it.)* 42 gate records have been written, 32 first passes and 10 re-passes, the latest on 2026-10-10. A re-pass is a new check after the specification or its sweep changed.

**A gate that held up its own author (tool appendix, measured 2026-10-07 and 2026-10-08).** Three times, the architect's own push of a task specification started continuous integration on the main branch, and the gate refused to create the post until that run finished — about two and a half minutes each time in that repository. The tool now walks past commits that change only dispatch files and decides on the newest commit whose run is complete. The rule did not relax: a commit that changes anything else still holds the post.

**A limit that was not built (tool appendix, 2026-10-09).** Two posts merged on 2026-10-09 with 743 and 123 changed lines. The installation's size lanes would have sent both to manual review; no tool counts changed lines, so neither went. The architect's post-merge read compared every changed file byte for byte with the end state its specification carried, which is the review the large lane asks for. The size lanes are listed as not built, with that merge as the reason the trigger has been narrowed.

**Detection.** *(The session-start read of 2026-11-02, and the register beside the queue.)* In each of the four product repositories, the read mark stands at the head of the main branch and no commit is flagged. Six commits on the main branches — the four heads among them — are explained not by a post but by register lines, all six naming the same backlog item. Two of them are text corrections that the owner had made directly on main in two repositories on 2026-10-12, after a series of reviews.

**Back to the specification side.** *(Findings in the build sessions' reports.)* Builds filed 15 findings against their specifications, from 10 posts, between 2026-10-05 and 2026-10-09, instead of resolving them in the code.

What these figures show is the task loop working end to end: posts that cannot exist without a gate, specifications committed before the post, merges reported and verified, and a main branch on which every commit is explained — by a post, or by a register line that names the work item carrying it. They do not yet show the contract loop, which is the part of the pipeline the rest of this paper is most about.

---

## 5 — Where This Sits in the Field

Spec-driven development has become a recognised way of working with coding agents. Birgitta Böckeler's account distinguishes three levels: *spec-first*, where a well-considered specification is written first and used for the task at hand; *spec-anchored*, where it is kept after the task for further development and maintenance; and *spec-as-source*, where it is the main source file and the only thing a person edits. In that vocabulary "spec-first" names the specification as a starting document, and Simon Martinelli's later reading calls it a one-off artefact, not needed once the feature is done — the opposite of what this paper describes. GAE's dispatch sits closest to the middle level, with a stricter order: the specification changes first, through its own audit, and the code follows through a gate that measures it against the specification before and after.

What is particular here is not that a specification comes first, but what stands between the specification and the build: a gate record that a tool verifies before work can be queued, a scope that is a measurement rather than a list, a specification that may not point or hypothesise, a loop the queue chooses rather than the agent, and detection afterwards of anything that went around.

We have not checked whether this combination is formulated elsewhere, and this paper does not claim it is new. Claims about when the reference installation's dispatch graph was built, relative to published work, are left out until they can be shown with commits and dates.

**Sources.** Böckeler, B. (2025-10-15), on spec-driven development tools, martinfowler.com, https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html · Martinelli, S. (2026-08-27), on the three levels of spec-driven development, https://martinelli.ch/the-three-levels-of-spec-driven-development-and-where-the-ai-unified-process-sits/

---

## 6 — Limitations

- **The contract loop has not run.** Every post since the gate was introduced has been task work. The contract loop, the completeness measurement before dispatch and the completeness check after the merge are defined and have not been exercised under this pipeline.
- **The second entry has not been used.** Dispatch selected by the completeness gate is defined; no post has come that way.
- **The completeness gate does not run at merge.** It runs when an agent calls it.
- **Size lanes, the lane's choice of model and the batch threshold are not built.** As shown in § 4, a large change merged without the manual review the large lane asks for, and the review was done by hand after the merge.
- **The merge check detects.** The repository host cannot make the queue check required on private repositories at the current plan; the session-start read finds what went around.
- **The emergency path leaves no trace.** There is no bypass log. A bypass shows only as a commit on main that no post explains.
- **The write gate's claim is a local mark.** It stops a write beside the queue made by mistake, not one made on purpose; the queue and the detection hold the rest.
- **Dependencies are rarely declared.** One of the 31 posts names the post it waits for. How order between the others was kept is not recorded in the queue.
- **The standards leave three gaps around dispatch**, all in the release's known issues:
  - Where a product is declared as paths, the write gate refuses a session's writes under the prefixes only, and the lifecycle standard does not say what holds its writes elsewhere in the repository.
  - The architect commits task specifications and adds queue posts. An installation whose owner rules out a write connector for the architect has no executor of those writes in the standards.
  - The Truth Chain lets code rest on a task specification with a passed gate, and does not name the first post's entry.

---

## 7 — What Comes Next

- The first contract-driven post, with the completeness gate before dispatch and after the merge.
- The completeness gate at merge, so that contract work is declared done by the gate.
- Size lanes counted by a tool from the change itself.
- A bypass log, and a claim the queue confirms.
- Order between posts written as dependencies, or as order edges in the backlog where it spans work outside the queue.
- In the standards, as directions in the release's known issues: what holds a session's writes outside a product's prefixes, an executor of the architect's writes, and the first post's entry in the Truth Chain.

---

## 8 — Map

- **The GAE overview** places dispatch among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - GIP Standard: dispatch, the two entries, the task specification, the queue post, the build loops and the queue as proof
  - Contract Standard: the completeness gate as a tool class
  - Registry Standard: the registry and the sweep tool classes that the sweep before dispatch (GIP §4.2) runs
  - Wave Standard: order between posts and work outside the queue
  - Handoff Standard: the dispatch to the session agent
- **Related white papers:**
  - *Loop Engineering*, on the build loops a post runs
  - *Verification Architecture*, on the tester and the verifier inside the loop
  - *Harness Engineering*, on the write gate and the detection at session start
  - *Contracts as the Source of Truth*, on why the specification governs
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
