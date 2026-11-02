---
title: "Harness Engineering: Infrastructure That Holds the Rules"
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
    scope: "Text and structure of v0.1 (2026-10-16), and in v0.2 the new parts: the two platform profiles, the product declared as paths, the version check that can compare two stale copies, and § 4 rewritten with a rule per figure."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the required declared paths measured in operation on 2026-10-22 and again in the session that wrote v0.2; the product repositories' guards read in the instance appendix at the same commit."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 3.3 and § 3.7 rewritten as explanation with pointers, where v0.1 restated the GIP and Boundary Standards closely; § 3.8 corrected for the reference installation's own exception to the module halt; the declared paths described as in force; § 5 brought in line with the checked harness study; Limitations and the map brought up to date with the release. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline on 2026-10-19; the harness study's longitudinal scope and Saltzer and Schroeder's bibliography again on 2026-11-02. Nadella's X post refused automated access; the quoted sentence is confirmed from the search-index text of that URL and three independent verbatim press reproductions."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/harness-engineering.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gal-standard.md
    version: "v1.76"
  - path: standards/boundary-standard.md
    version: "v0.3"
  - path: standards/gip-standard.md
    version: "v0.5"
---

# Harness Engineering: Infrastructure That Holds the Rules

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*An instruction is read by the same model it is meant to constrain. This paper is about the infrastructure around the agents — the tools they can call, the places they may write, the checks that run before anything lands — and about saying honestly which rules that infrastructure holds and which it only asks for.*

---

## 1 — The Problem: Rules That Only the Agent Reads

The simplest way to govern an agent is to tell it what to do. Write the rules into its instructions, and trust it to follow them. For a single agent on a small task this works well enough.

It stops working for three reasons, and each of them gets worse as the number of agents grows.

**The rule is read by the thing it constrains.** An agent that is told not to write outside its folder is the same agent that decides where to write. If it misreads the rule, loses it at the edge of its context, or is persuaded by a well-meant request that this case is an exception, nothing outside the agent notices. The rule held for exactly as long as the agent held it.

**A guard can look like a guard without being one.** A tool that asks for a confirmation flag, and receives one, has proved only that something set the flag. A check that reads no configuration and therefore finds nothing to object to passes everything. A tool description that says a rule is enforced, with no code behind the sentence, is a wish. Each of these looks like control in a review, and each of them stops nothing.

**Agents share infrastructure.** Several agents write to the same repository, often through the same server and the same working copy. One agent's half-finished work is in the tree when another commits. One agent's switch of branch moves the ground under another's feet. None of them broke a rule; they simply did not know about each other.

The question this paper answers is: **how does a system hold the rules its agents must follow in infrastructure rather than in the agents' own instructions — and how does it say, for each rule, whether it is held at all?**

---

## 2 — What It Is: The Harness

In governed agentic engineering (GAE), the harness is everything around the model that decides what the model can actually do. It has four parts.

- **The tool surface.** The fixed set of tools an agent can call. What is not on the surface cannot be done.
- **The write surfaces.** For every agent, the paths it may write, stated once in a boundary contract together with what it may read, run and decide — and, for each rule, whether a tool holds it.
- **The gates.** Checks that a tool runs on the state it reads itself, before it acts: before a commit lands, before a write reaches the disk, before a unit of work is queued. Each gate states whether it stops the work or only detects it afterwards.
- **The lifecycle frame.** Every agent session has a measurable start and end. At the start a fixed sequence of gates runs and its results are emitted as a receipt; at the end a fixed sequence closes the session and leaves a trace for the next one.

**Two platform profiles.** Where an agent runs decides what the harness can hold for it. On a chat platform, a specification agent reaches the repository through a tool server, and its limits are held by its instructions and by whatever the server's tools refuse. On a coding-agent platform, an agent definition — its tool list, model and hooks — is enforced by the platform when the agent is started as that agent or dispatched as a sub-agent; a session started from a plain bootstrap line holds its limits by instruction again. The reference installation runs its specification agents in chat and its implementation agents on a coding-agent platform. The starter kit describes both profiles and lets an installation choose per agent.

The rules themselves stand in three standards, which are the reference: the GAL Standard for the lifecycle, the start gates and the receipt; the Boundary Standard for the boundary contract and the class of tool that guards a write surface; and the GIP Standard for the implementation roles and the gate in front of every product repository.

---

## 3 — The Load-Bearing Ideas

### 3.1 Every rule says what holds it

A boundary rule is held by a tool, or it is held only by the agent's instructions. Both are allowed. What is not allowed is leaving the reader to guess which.

So every entry in the boundary contract names the tool that holds each rule, or says that none does. Each gate is declared as one that **stops** the work or one that **detects** it after the fact (GIP §1). And where a platform cannot stop something, the gate runs as detection and says so.

This is the most important idea in the paper, because it keeps the others honest. A harness that claims to hold everything invites the reader to stop looking. A harness that lists what it does not hold tells the reader exactly where to look.

### 3.2 The tool boundary is the first boundary

What an agent cannot call, it cannot do. So the first decision is not what to forbid, but what to offer.

The reference installation offers specification agents a fixed set of tools, and scripts only from a fixed list. A script that is not on the list is refused by name; there is no general way to run code on the server. A whitelist is narrower than a blacklist, and it is meant to be. Each new tool is a decision someone made, not a capability that arrived by default.

### 3.3 Guard the repository, not the agent

GIP puts its gate on the product repository, not on the agents (GIP §3): every write needs a claimed unit of work with a passed gate, whoever makes it, and a server that writes into the repository from outside is an opening in the gate.

The reason is in how the gate came about. The changes that made it necessary were not agents breaking their rules. They were sessions started beside the queue — work done in the right repository, by an agent that had no rule against it, outside the path that records what was built and why. A gate that only bound agents would have missed every one of them. A gate on the repository catches them whoever starts the session.

Where a product is declared as paths inside a shared repository rather than as a repository of its own, the gate covers only those paths, and what holds a session's writes elsewhere in the repository is left open; the release's known issues name it. The reference installation keeps each product in its own repository.

### 3.4 A confirmation the agent gives itself is not a gate

Many tools in the reference installation take a flag that says the human operator confirmed the step. The flag is useful: it makes the agent stop and ask before a commit, a push or a write to the database. But no tool can verify that the operator actually confirmed. Setting the flag is the agent's own statement.

So the flag is treated as what it is — a prompt to the agent, not a check — and is never cited as one. What stops a bad commit is the set of gates the commit tool runs on what is staged. The same distinction applies to the write gate's claim: the mark that a session has claimed its work is a file the session writes itself. It stops a write made by mistake beside the queue. It does not stop a write made on purpose, and the documentation says so.

### 3.5 An empty read fails closed

A guard that reads no configuration has nothing to object to. If it then passes everything, it is not a guard; it is a green light with a guard's name. The Boundary Standard therefore makes a write guard whose declaration is absent or empty either refuse every write or fail visibly (§6).

The same rule runs through the rest of the reference installation's harness. The commit tool refuses a declared path that matches no change, rather than making an empty commit. The search tool refuses to answer when it searched no file. An unread result is never reported as a clean one.

### 3.6 When the caller cannot be identified, it declares

The tool server in the reference installation is stateless and does not know which agent is calling. Every specification agent writes to the same working copy. For a long time, the commit tool staged by directory — and so took with it whatever another session had left uncommitted in those directories.

Identity at the tool layer would solve this properly, and it is not built. The answer in the meantime is declaration: the caller names the files it wrote, only those are staged, and every other uncommitted file is left in place and listed in the answer. A call that names no files is refused. It is a weaker guarantee than identity — an agent can still declare a file it did not write — but it turns a silent sweep into a visible choice.

### 3.7 The way through is cheaper than the way around

A gate that is expensive to pass will be bypassed, and the bypass will not be recorded. So GIP keeps the normal path proportionate: a small change goes through as a short task with one acceptance criterion, not as an exception, and the emergency path is kept for a gate that does not work (GIP §3). Only the owner may use it, every use is to leave a trace, and the work is brought back into the normal path afterwards. A wider exit is never the answer to a heavy path; a cheaper way through is.

### 3.8 Start and end are measured, not assumed

Every agent session starts with the same gate sequence: the right agent for this handoff, the right version of its instructions, a clean and current repository, the right extensions loaded at the right version, the task's recorded learnings read. The results are emitted as a receipt with the values that passed, not the word "verified".

Where it can, the reference installation runs these gates as one deterministic call rather than as steps the model performs (GAL §4.2). A gate that a script runs is no longer a matter of the model remembering to do it. This is what lets the harness scale the number of agents without scaling the risk: every agent is assembled, started and closed the same way, and a new agent is not operational until it is registered in every place a tool reads agents from.

The standard has a session halt when a module is older than its core (GAL §8.2). The reference installation's architect does not halt there: it loads the module and marks it in the receipt, under an exception the installation registers. The receipt still shows the stale module; what changes is that the session does not wait for an answer.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The tool surface.** *(The tool server's source at the measuring commit.)*
- The tool server registers 61 tools. One of them runs scripts, from a fixed list of 50; any other name is refused.
- The commit tool for non-canonical files reports up to 15 named checks in its answer, each triggered by what is staged: among them checks on instruction structure, version bumps and their archives, standards bookkeeping, the test fixtures that guard a changed check, and the backlog index. *(Distinct check labels in the tool's status lines.)* A refused commit leaves nothing staged.
- On 2026-10-15 that tool refused a commit of four instruction files whose shared close sequence no longer matched the reference text byte for byte. The change was withdrawn and made later, together with the reference text.

**The shared working copy.**
- At least 12 retrospective entries between 2026-08-23 and 2026-10-14 record another session's files riding along in a commit, or another session's work blocking a push. *(Counted 2026-10-14.)*
- Since 2026-10-22 the commit tool requires the list of files the caller wrote. Measured that day in operation, a call without the list was refused with nothing staged and no commit made. In the session that wrote this version, a commit of three declared files left another session's uncommitted file in place and named it in the answer.

**The product repositories.** *(The instance appendix's rows for the write gate, at the measuring commit.)*
- Each of the four product repositories carries a write gate and three role guards: one that keeps the implementer out of the checks, one that keeps a step agent inside its prefixes, and one that refuses version-control writes. In two of the repositories the last refuses every form that writes history, refs, branches or the stash; in the other two, only a command that begins with a commit or a push.
- That guard answers a dated incident. On 2026-07-03 a step agent switched a shared working copy to the main branch and pulled during a unit of work, and the coordinator's commit then landed on main.

**The queue.** *(The queue and its step receipts.)*
- 31 units of work have passed the gate and entered the queue: 25 are done and 6 were superseded. They carry 282 step receipts.
- 279 of those receipts name the model from the step agent's configuration and 3 from the session's transcript, which is not a documented interface. No hook the platform offers reports the model a step agent ran on.

**The harness tested against itself (2026-10-09).** In an adversarial review, a reviewer wrote a claim for a unit of work that does not exist. The write gate then let every write through, commits and pushes included. The finding did not change the gate; it changed what the documentation says the gate is. The claim is described as a local mark that stops mistakes, and the rule that writing waits for a real claim is described as held by the queue and by the detection at the architect's next session start.

What these figures show is that the harness stops real errors at the point they would land — a broken instruction file, another session's files in a commit, a write without a claim — and that testing it adversarially finds where it does not. Both kinds of result end up in the same tables.

---

## 5 — Where This Sits in the Field

The underlying ideas are old in computer security. Saltzer and Schroeder's design principles of 1975 include least privilege, fail-safe defaults and complete mediation: give each actor the least it needs, base access on permission rather than exclusion, and check every access. Harness engineering applies them to a new kind of actor.

A recent study by Barbaste and colleagues read the source code of eleven production coding-agent harnesses. For the eight it had already examined in an earlier edition, it compared the two snapshots and found behavioural policy moving out of the prompt and into configuration. GAE draws the line that movement implies — a rule stated in a tool description, without code that holds it, is a wish and not a mechanism — and adds the obligation to write it down: each rule names its holder, and each gate says whether it stops or detects. As we read the study, the policy it examines is the harness's own operation — tools, memory, permissions, orchestration — and it does not address domain specifications. GAE's harness guards that layer as well, because the specification is what the implementation is built from.

Addy Osmani has described agent quality in terms of three kinds of constraint: some shape the work before it begins, some give feedback while the agent works, and some decide whether the output may cross the production boundary at all. In GAE these correspond to the gate before work is queued, the review loops during a build, and the gates in front of the main branch and the commit tools. More recently, Satya Nadella has argued that capable models should be treated like insiders with access, not because they are necessarily malicious, and that the controls belong outside the model: "we need to separate the supply of intelligence from the authority over it." The harness is one concrete form of that separation.

We have not checked whether the combination described here — every rule declaring its holder, gates that state stop or detect, declaration where identity is missing — is formulated elsewhere, and this paper does not claim it is new.

**Sources.** Saltzer, J. H., & Schroeder, M. D. (1975). The protection of information in computer systems. *Proceedings of the IEEE*, 63(9), 1278–1308. https://doi.org/10.1109/PROC.1975.9939; Section I, "Design Principles" · Barbaste, Darrigol, Vu & Wiltberger (2026). *Harness Engineering*. arXiv:2609.00006 · Osmani, A. (2026-08-08). Agentic Code Quality. https://addyosmani.com/blog/agentic-code-quality/ · Nadella, S. (2026-10-10), essay on X, https://x.com/satyanadella/status/2108931348857827686, quoted as reproduced verbatim by Bloomberg (via The Edge Malaysia, https://theedgemalaysia.com/node/821387)

---

## 6 — Limitations

- **No per-agent guard in the specification repository.** The tool server does not know which agent is calling. Every specification agent's write surface is held by its instructions; the declared paths keep other sessions' files out of a commit, but nothing stops an agent from writing outside its own surface. The machine-readable declaration of the write surfaces exists, and no tool reads it. On a coding-agent platform an agent definition could hold it; the reference installation does not run its specification agents there.
- **The tool server can write into product repositories.** It does so through its own working copy, outside those repositories' write gates. It is used for task specifications only, and that is held by the architect's instructions.
- **One script list for every caller.** The read-only subset that the adversarial reviewer may run is held by the reviewer's instructions, not by the server.
- **The write gate's claim is a local mark.** As shown in § 4, a session can write a claim for work that does not exist. The commands the gate allows without a claim are not all read-only, and the gate's scan of a command follows the rules of one shell while the command runs in another.
- **The tester's read boundary is held by instruction.** The rule that the agent writing checks never reads the code it checks stops nothing today. A spike showed the platform can enforce it; it is not built.
- **Merge checks detect.** The repository host cannot make the queue check required on private repositories at the current plan, so a merge without a queued unit of work is found at the next session start, not stopped.
- **The emergency path leaves no trace.** The bypass log is not built. A bypass is detectable only as a commit on main that no unit of work explains.
- **The model split is claimed, not proven.** Nearly every step receipt names the model from configuration, so a reviewer that ran on the implementer's model would not show in the receipt.
- **The version check can compare two copies of one stale state.** The start gate that compares the loaded instructions with the version registry passes whenever both reach the session through one periodic sync. The release's known issues propose that the two sides come from independent routes.
- **The receipt is not stored.** Session receipts are emitted to the operator and are not parsed or kept by any tool. Whether every agent starts with the deterministic start call is not measured.
- **The confirmation flag proves nothing.** It is kept because it makes the agent stop and ask, not because it holds anything.

---

## 7 — What Comes Next

- Agent identity at the tool layer, so that the declared write surfaces can be enforced per agent. It is built when the first commit is found that writes outside its agent's surface.
- A claim that the queue confirms, rather than a mark the session writes. It is built when a write, commit or merge is measured from a session beside a claimed unit of work.
- A read wall for the agent that writes checks, on the platform's existing hooks.
- A bypass log, and a receipt parser that stores and checks each session's receipt.
- A step receipt that proves which model ran, once the platform reports it.

Each of these has a trigger: a measured failure that would have been caught. None is built ahead of one.

---

## 8 — Map

- **The GAE overview** places the harness among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - GAL Standard: the start gates, the session receipt, the version gate and the registration checklist
  - Boundary Standard: the boundary contract, crossing a boundary, work between agents and the write guard
  - GIP Standard: the implementation roles, what each may read, write and run, and the gate in front of a product repository
  - Handoff Standard: how work passes between agents through the operator
  - The starter kit: the two platform profiles, and what each holds
- **Related white papers:**
  - *Agent Roles and Orchestration*, on who the boundaries are drawn around
  - *Verification Architecture*, on the checks and reviewers the harness carries
  - *Spec-Governed Dispatch*, on the gate before work enters the queue
  - *Context, Coherence and Memory*, on what a session leaves for the next one
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
