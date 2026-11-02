---
title: "Agent Roles and Orchestration: The Specification Agent's Mandate"
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
    scope: "Text and structure of v0.1 (2026-10-16), and in v0.2 the new parts: the harmonizer role, the two ways work moves between specification agents, the owner's acceptance at a review limit, and § 4 rewritten with a rule per figure."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817, its database as loaded on 2026-11-02, and the four product repositories at engine acba054, iOS 8090c02, ChatGPT app 47ea542 and simulator 20d9d8c, each with the rule that reproduces it; the review of the reviewer's own instructions in § 4 taken from the review files of 2026-10-15 and not repeated."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: § 3.4–3.7 rewritten as explanation with pointers, where v0.1 restated the Boundary, Contract, GIP, Handoff and GAL Standards closely; § 3.5 corrected for the reviewer's return to the same session; § 5 brought in line with the checked Design by Contract reference and widened from nine to nineteen prior-art candidates; Limitations and What Comes Next brought up to date. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline: the keynote, the delegation paper and the nine sources of the first search on 2026-10-19; Meyer's 1992 article, read in the paginated original, the ten further candidates and the delegation paper's passage on permissions on 2026-11-02, partly through the platform's research mode."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it, the agent or the research mode."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/agent-roles-orchestration.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gal-standard.md
    version: "v1.76"
  - path: standards/boundary-standard.md
    version: "v0.3"
  - path: standards/handoff-standard.md
    version: "v0.3"
  - path: standards/gip-standard.md
    version: "v0.5"
  - path: standards/truth-chain-standard.md
    version: "v0.5"
  - path: standards/contract-standard.md
    version: "v0.6"
  - path: standards/registry-standard.md
    version: "v0.4"
---

# Agent Roles and Orchestration: The Specification Agent's Mandate

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*In a contract-driven system the specification is what the implementation is built from. If it says the wrong thing, a flawless build delivers the wrong thing. This paper is about the agents that write the specification — what they may decide, what they must refer, and why defining, building and checking are kept in different hands.*

---

## 1 — The Problem: Who Is Allowed to Decide What Is Correct?

Most writing about agent roles is about the agents that write code. A planner, an implementer, a reviewer; a coordinator that hands out the steps. The specification they work from is usually treated as input — written by a person, or by an agent that is mostly a planning assistant, and then handed over.

That leaves the most consequential decision ungoverned. If the specification says the wrong thing, every downstream agent can do its job perfectly and the system will still be wrong. The code passes its checks, because the checks were written from the specification. The reviewer finds nothing, because the code matches what was asked. The error is not caught; it is built.

Three things go wrong when the specification side is not governed with the same rigour as the code side.

**The writer approves its own work.** An agent that drafts a specification and decides that the draft is right has reviewed itself. Nothing outside it was asked.

**The builder fills the gaps.** When a specification is silent on something the code needs, an implementing agent will supply a plausible answer. The answer is now in the code, and nobody decided it.

**The roles blur under pressure.** An agent that can see a problem is tempted to fix it, even when the problem belongs to another agent. Each such fix is small and well meant, and each removes the separation that the other agent's review depended on.

The question this paper answers is: **what is a specification agent allowed to decide, how are the decisions it may not make routed to the role that owns them, and why does the system keep the authority to define what is correct, the ability to build it and the power to verify it in different roles?**

---

## 2 — What It Is: Roles, Boundaries and the Operator

The working thesis of this paper is that **the specification agent is not merely a planning assistant. It takes part in a governed process that establishes, maintains and verifies the authority of the specification over the implementation.**

Governed agentic engineering (GAE) gives that process four parts.

- **Two kinds of agent.** Specification agents work on the specifications and on the governance system itself. Implementation agents build the product from a specification that has passed a gate. Only an implementation agent writes product code.
- **Roles.** The specification side has an owner (a person), an architect who shapes the agent system and dispatches implementation work, a domain researcher who gathers the knowledge contracts rest on, a contract author, a contract auditor, an adversarial reviewer of agents and shared infrastructure, and a harmonizer who, when an agent is checked against the lifecycle standard, prepares the lists of approved changes. The implementation side has a session agent and its step agents: planner, tester, verifier, implementer and fixer.
- **A boundary contract.** One document states, for every agent, what it may and may not read, write, run and decide, and which of those rules a tool holds.
- **The operator.** A person starts the agents' sessions and decides on the work that passes between them, in a handoff of a fixed form along a route listed in one table.

The rules stand in the standards, which are the reference and are not restated here: the GAL Standard for the kinds of agent and their roles, the Boundary Standard for the boundary contract and crossing a boundary, the Handoff Standard for how work passes between sessions, and the GIP Standard for the implementation roles.

---

## 3 — The Load-Bearing Ideas

### 3.1 Defining, building and verifying are three roles

The central separation is not between agents that think and agents that type. It is between three kinds of authority:

- **the authority to define what is correct** — held by the contract author, the contract auditor and, for intent, the owner;
- **the ability to implement it** — held by the implementation roles;
- **the power to verify it** — held by roles that neither wrote what they check nor built it: the auditor on the specification side; the tester, which writes checks from the contract without reading the code, and the verifier on the implementation side; and the adversarial reviewer for agents and infrastructure.

No role holds two of the three for the same piece of work. That is what makes each of them a check on the others rather than a step in one agent's pipeline.

The owner stands outside the three, and the standards keep it there. When a build reaches its limit of review rounds without a pass, an installation may let the owner accept the work with the verifier's open findings carried as work items. The verifier's verdict is then kept as it was given, with the owner's acceptance beside it, so the record still says that the review did not pass. The reference installation does not allow it.

### 3.2 The specification agent's mandate, question by question

What it means for the specification to have authority can be stated as five questions. Each has an answer, and each answer is owned by a standard.

| Question | How GAE answers it | Owned by |
|---|---|---|
| What may a specification agent decide, and what must it refer? | Its boundary entry lists what it may and may not do. A request outside the entry is declined, the owning agent is named, and no part of the work is done | Boundary Standard |
| How are gaps handled? | An implementation that needs a decision the contract does not make reports a finding against the contract and invents nothing. A missing value is added to the registry only after the contract specifies it | GIP Standard, Registry Standard |
| How are conflicting requirements resolved? | The higher level of the truth chain holds; the conflict is logged with both statements; the lower one is corrected. Between two contracts, declared priority decides | Truth Chain Standard, Contract Standard |
| Who approves a change to a contract? | An independent auditor, in a full audit with an approving verdict on the document's current version. The author never approves its own document | Contract Standard |
| How is it verified that the implementation follows the contract? | A completeness gate counts whether the code consumes and tests every normative statement and every registry key the contract cites. Work is done when, on the main branch, that gate counts the contract as fully covered; passing tests alone do not end it | GIP Standard, Contract Standard |

Read together, the five answers describe a specification that is not a suggestion to the builders. It is the thing their work is measured against, and it can only be changed by a route that does not pass through them.

### 3.3 A gap is a finding, never a guess

The most important behaviour asked of an implementing agent is restraint. When the contract does not say what to do, it does not choose. It files a finding — an ambiguity, a suspected error or a missing value — and the contract is blocked until the specification side has resolved it.

The finding goes back to the role that owns the answer: an ambiguity to the contract author, a suspected error to the domain researcher, a missing value to the contract author through the registry's process. The specification is fixed, audited, and gated again before the build resumes. The build never changes the specification, and "out of scope" is not a verdict it may give itself.

### 3.4 A boundary that a request can widen is a default

The Boundary Standard has an agent decline a request that crosses its entry, name the owner of the action and do none of it (§3). The reason for the last part is that a partial answer is the hardest violation to see: the work looks helpful, and the boundary has already moved.

The rule holds for the operator too. That is deliberate. A boundary the operator can widen with a sentence in the chat leaves no trace, and the next session inherits a boundary nobody wrote. So the operator widens a boundary in one of two recorded ways — by a governed change to the boundary contract, or by an exception for one action that stands in the decision log — and one rule of a reviewer's boundary admits no exception at all, the rule that it leaves the work under review untouched (Boundary Standard §3, §5).

### 3.5 Work passes through the operator's decision

No agent starts another agent's session without the operator. The Boundary and Handoff Standards put the operator between every two agents and list every permitted route once (Boundary Standard §4). The session agent's dispatch of its step agents, and its report back to the architect, are the two named exceptions.

The reason is not that a person must type every message. It is that one actor sees every transition and can stop any of them. Two practices test that reading:

- **The reviewer's answer comes back to the session that sent the round.** When the architect sends a change to the adversarial reviewer, the session pauses, and the findings return to it rather than to a fresh session that would not know the work. The operator still carries the answer.
- **On a coding-agent platform the architect can dispatch a specification round itself.** The starter kit allows it, with the dispatch naming files and carrying no content, the reviewer on another model than the author, and every step writing its output to a file. The standards do not yet describe such a round, so the kit registers it as a departure. The release's known issues propose separating the carrying of a handoff from the decision on it, with the decision kept by the operator.

With one operator, routing everything through one person is the architecture's strength. With several it is a bottleneck, and the release lists that as an open track.

### 3.6 No agent reviews itself — including the reviewer

The rule that an author never approves its own work applies at every level. A contract author's draft goes to the auditor. A change to an agent's instructions or to shared infrastructure goes to the adversarial reviewer. A reviewer never changes the work it reviews, because once a reviewer repairs its own finding, the next round has it reviewing what it wrote (Boundary Standard §5).

That leaves the reviewer's own instructions. Someone has to review them, and it cannot be the reviewer. In the reference installation the architect does, under a registered exception with conditions: the review runs in another session than the one where the change was written, findings written to a file, the owner confirming the intent, and nothing outside the reviewer's own surface.

### 3.7 Roles are stated once and retired explicitly

A role that exists only in an agent's instructions drifts with the instructions. So the Boundary and GAL Standards tie a role to a registration: an entry in the boundary contract before the agent first runs, and a place in every list a tool reads agents from. Retirement is registered the same way. A retired agent keeps its entry, marked with the date and with whoever took over its work, so that a later reader can tell a role that was removed from one that was forgotten.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at one measuring point: corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, with the four product repositories at engine `acba054`, iOS `8090c02`, ChatGPT app `47ea542` and simulator `20d9d8c`. Each figure gives the rule that reproduces it. The case study describes that installation. In the reference installation, the owner is Jonas Maandi Wallin, the originator of the framework.

**The roles.**
- Six specification agents are registered, each with the version of its instructions. Five fill the roles above, the architect also as harmonizer; the sixth writes explanatory articles for readers and carries the same lifecycle and registration. *(The version registry.)*
- In each of the four product repositories a session agent, a tester, a verifier and an implementer are defined. The engine repository also has a planner, a fixer and a second implementer for its endpoints; the standard leaves the planner and the fixer optional. *(Agent definition files in each repository.)*
- The boundary contract holds an entry for every specification agent and every implementation role, and two agents marked as retired on 2026-09-10, each with the process that took over.

**The routes.** The routing table lists 31 permitted routes between agents. *(Its rows.)* One starts with the operator, sending work straight to the reviewer. Three end in a new session of the same agent: a resume, a tooling track and a research layer. The reviewer's findings return to the same architect session that sent the round, and to a new one only as a fallback. The boundary contract's overview of the routes points to the table and keeps no second list.

**Exceptions to a boundary.** No exception has been recorded in the form the Boundary Standard asks for since that form was introduced on 2026-10-13. *(The decision log, searched for the exception's type in the file and the database.)* Earlier exceptions, on 2026-08-12, were recorded in a comment in the file they concerned.

**Audits.** The folder of audit reports holds 960 files; reports are append-only, so a new audit is a new file. 142 documents carry an audit record: 131 from a full audit and 11 from a standard audit. Five documents in force carry only a standard audit, which no longer suffices for entry into the corpus. *(The audit record in each document's metadata, joined with its status.)* The top-level architecture document, the constitution, has had a full audit since 2026-10-17 and is typed as a framework.

**Findings back to the specification side.** Implementation sessions have filed 15 findings against their specifications, from 10 units of work in all four product repositories, between 2026-10-05 and 2026-10-09: 14 suspected errors and 1 ambiguity. None asked for a missing registry value. *(Reports of kind finding, by type and repository.)* All came from task-driven work: of the 31 units that have passed the gate, none was contract-driven. Under the pipeline's rule, a finding blocks its unit of work until the specification side has answered.

**The reviewer reviewed (2026-10-15; not repeated).** A change that touched the reviewer's own instructions was reviewed by the architect in a separate session. The review found one rule weakened: a sentence that every other agent's instructions carry had not been carried to the reviewer's. It was fixed, and a second review in a further session found nothing weakened.

What these figures show is that the separation is not only stated. Findings go back instead of being guessed; the reviewer is itself reviewed; the routes are one list rather than a habit. They also show where the stated rule is ahead of the record: five documents in force without the audit the rule now requires, and an exception form that has not yet been used.

---

## 5 — Where This Sits in the Field

The separation of *what* from *how* is old. Bertrand Meyer's 1992 article *Applying "Design by Contract"* put preconditions, postconditions and invariants at the centre of software construction. In his 2026 keynote *Software Verification in the Age of Artificial Intelligence* (Swiss Testing Day, Zürich), he described an ecosystem of seven agents — for requirements, architecture, contracting, coding, test generation, proving and deployment — with the human at the centre, and called stating what you need one of the hardest parts of the work. (A published summary of the talk puts coding at 10–20 % of the effort; that figure is the summary's, not a quotation from Meyer.) GAE's roles map closely onto that ecosystem. The difference is where the contract lives: GAE keeps it as a separate, audited layer that exists before and without any code, rather than embedded in the code it governs.

Recent work on delegation between agents, such as the paper on intelligent AI delegation by Tomašev and colleagues at Google DeepMind, treats the transfer of authority and responsibility, with clear specifications of roles and boundaries, as part of delegation itself, and asks that an agent which delegates a sub-task cannot pass on its full set of authorities. GAE's write surfaces and boundary entries are one concrete form of such boundaries, held where a tool can hold it and declared where it cannot; a session agent's dispatch, which names files and carries no content, is one form of that narrowing.

Spec-driven development has made specifications a first-class artefact in agent-assisted coding, and several tools already separate roles around them. GitHub's Spec Kit describes its checklists as reviewer-owned artefacts that the implementation may not silently self-approve. BMAD-METHOD runs reviews in a fresh context, without the original reasoning, and puts a readiness gate before implementation. Warp has described separate agents for writing specifications, reviewing and triage, with changes to the agents' own skills going through ordinary pull-request review. Wang's VibeContract has a model generate contracts that developers validate and that drive the tests. These are partial predecessors of what this paper describes, and the claim that no one reviews specifications independently would be wrong.

The question this paper turns on is narrower: what happens when the agents that write specifications are governed as strictly as the agents that write code — with every rule and value in the specification citing evidence, review by someone other than the author before the specification becomes authoritative, and a route back to the contract for every gap the build finds. Two searches for this package read nineteen tools, methods and papers. None combined evidence for the specification's own rules and values with review by someone other than the author before the specification becomes authoritative. The searches covered those nineteen and no others, so they do not show that no one does it.

**Sources.** Meyer, B. (1992). Applying "Design by Contract". *Computer*, 25(10), 40–51. https://doi.org/10.1109/2.161279 · Meyer, B. (2026). *Software Verification in the Age of Artificial Intelligence*, keynote, Swiss Testing Day, Zürich, 26 March 2026; summary: https://swisstestingday.ch/software-verification-in-the-age-of-ai/ · Tomašev, Franklin & Osindero (2026-02-12). *Intelligent AI Delegation*. arXiv:2602.11865 · GitHub Spec Kit, documentation · BMAD-METHOD, repository and documentation · Segner, M. (2026-08-26). Claude blog post on Warp's agents. https://claude.com/blog/how-warp-builds-self-improving-agents-on-claude · Wang, S. (2026). *VibeContract: The Missing Quality Assurance Piece in Vibe Coding*. arXiv:2603.15691 · The other candidates of the two searches are listed in the GAE overview's Sources.

---

## 6 — Limitations

- **Most specification-side boundaries are held by instruction.** The tool server that the specification agents use does not know which agent is calling, so an agent's may-not list is enforced by its own instructions. The harness paper describes what is and is not held. On a coding-agent platform an agent definition can hold more; the starter kit's profile for that platform says how.
- **The completeness gate does not run at merge.** It runs when an agent calls it. A unit of contract work cannot yet be declared done by the gate on the main branch, and no contract-driven unit has run under the current pipeline (§ 4).
- **The session agent's own boundary is held by instruction.** On the platform used, a session started with the session agent's bootstrap line runs with the full tool list; that it writes no product code and no checks rests on its instructions.
- **Five documents in force lack a full audit.** As shown in § 4, the rule that entry requires a full audit postdates their records.
- **The split into roles is not measured against an alternative.** No measurement compares separate agents with a single agent that loads modules, and none shows at what number of tools an agent starts choosing the wrong one.
- **The operator is one person.** The architecture assumes that every transition passes through the operator's decision. With several operators, nothing yet says who decides when two of them decide about the same contracts; the overview's section on scale describes the track.

---

## 7 — What Comes Next

- The completeness gate at merge, so that contract work is declared done by the gate rather than by the session. It is built when the first contract-driven unit needs it.
- A full audit of the five documents in force that carry only a standard audit.
- Per-agent enforcement of the specification agents' write surfaces at the tool layer, once a commit is found that writes outside its agent's surface.
- A form in the standards for a specification round the architect dispatches, which the starter kit now carries as a departure.

---

## 8 — Map

- **The GAE overview** places the roles among the other parts of the framework, and describes the open tracks on scale.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - GAL Standard: the two kinds of agent, the roles and the registration checklist
  - Boundary Standard: the boundary contract, crossing a boundary, work between agents and review
  - Handoff Standard: the form of a handoff, the routing table and the checks on both sides
  - GIP Standard: the implementation roles, findings and the route back to the specification side
  - Truth Chain Standard: the order of authority and how conflicts are resolved
  - Contract Standard: audit tracking and the rule that an author never approves its own document
  - Registry Standard: how a missing value becomes a registry key
  - The starter kit: the two platform profiles, and the dispatched specification round
- **Related white papers:**
  - *Harness Engineering*, on the infrastructure that holds the boundaries
  - *Contracts as the Source of Truth*, on the chain the specification sits in
  - *Verification Architecture*, on the roles that verify
  - *Spec-Governed Dispatch*, on how work reaches the implementation roles
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
