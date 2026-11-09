---
title: "Governed Agentic Engineering: Building Systems With Agents You Can Check"
type: overview
status: draft
version: "v0.4"
date: "2026-11-09"
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
    scope: "Text and structure of v0.1 (2026-10-19), and in v0.2 the new parts: the two shapes and the runtime boundary in § 2, the second installation in § 4, § 4 rewritten with a rule per figure, and § 6.2 on scale. In v0.3 the directions added to the three tracks of § 6.2: autonomy per class of work in a policy that code applies, a replay of the decision history before a class is given more room, several operators as several sources of events into one routing step, and a routing step that keeps no state of its own. In v0.4: governed ablation in § 2, § 6.1 and § 7; in § 6.2 an opening on what scale requires, a heading sentence for the autonomy track, gates judged by what they let through, the regret-free merge rate, progress rather than activity, and the version-control rebuilds at Anthropic, GitHub and OpenAI as anchoring."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817, engine commit acba054 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the runtime boundary in § 2 read in the engine, iOS app and ChatGPT app at commits acba054, 8090c02 and 47ea542; the context limits in § 6.2 read in the implementation coordinator's definition and the architect's session-close procedure; the origin classification in § 2 and § 4 built on 2026-10-19 from the repository's history, decision log, retro log and work items, and not recounted."
    evidence: "§ 4 gives the measuring point and a rule for each figure; § 2 and § 6.2 say what was read."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: sentences close to a standard's wording replaced by the framework's own words and a pointer (§ 1, § 2); § 3.7 brought in line with the first post of the implementation pipeline; § 5 widened from nine to nineteen prior-art candidates and the harness study scoped to its longitudinal sample; Limitations and What Comes Next brought up to date with the release of the standards and the starter kit; the map pointed at the release. v0.3.1: brought up to gae-standards-v0.5. The standards now carry the knowledge-corpus shape, so § 2 and § 6.1 name only what still assumes a product, and § 4 says that much of the second installation's report went into the standards. Every sentence about a standard was read against the v0.5 text before the change."
    evidence: "The diff against v0.1, and for v0.3.1 the diff against v0.3."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 checked against their primary sources by Research Pipeline: the nine sources of the first search on 2026-10-19; the ten further candidates, the harness study's longitudinal scope and the delegation paper on 2026-11-02, partly through the platform's research mode. In v0.3 the two sources of § 6.2, the DeepSeek Harness article and the Anthropic text it cites, read on 2026-11-02: the article in the English text the editor pasted, since x.com refused automated fetching, and the Anthropic page directly. In v0.4 the seven sources added to § 6, read by Research Pipeline on 2026-11-09: the two Anthropic pages and the GitHub page directly, the OpenAI page in a print of the English page, and the two posts and the article on X in screenshots and text the editor supplied, since x.com and openai.com refused automated fetching."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it, the agent or the research mode; for v0.3 a report with one row per claim about the two sources, the version each was read in, and the two rows that hold only in part. For the additions of this version, a report of 2026-11-09 with one row per claim, its outcome and the source's own words: 17 of 23 rows confirmed and 6 in part; where a row holds only in part, the text follows the source's wording."
    reason: null
  - role: review
    status: complete
    scope: "v0.2: adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other. v0.3: one reading round on the additions to § 6.2 and the matching items of the known issues: whether the text says more about its two sources than the source check bears, whether anything proposed stands as measured, whether the overview and the known issues agree, and what the release tool ships. v0.4: one reading round on the additions: whether any sentence says more about the seven new sources than the source check bears, whether anything proposed stands as measured, whether the sentences shared between the four papers are identical, and what the release tool ships."
    evidence: "v0.2 round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment. v0.3 round (2026-11-02): no blocking findings and two advisory ones, both corrected in the known issues after the round: the scale section named the routing step in fewer directions than it counted, and two of its sentences shared a run of ten or more words with § 6.2. v0.4 round (2026-11-09): no blocking findings, one advisory finding and five observations. The advisory finding, a measure attributed to a source whose check does not bear it, was corrected after the round, together with two of the observations."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/governed-agentic-engineering.md"
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
  - path: standards/truth-chain-standard.md
    version: "v0.6"
  - path: standards/contract-standard.md
    version: "v0.7"
  - path: standards/registry-standard.md
    version: "v0.5"
  - path: standards/gem-standard.md
    version: "v0.10"
  - path: standards/backlog-standard.md
    version: "v0.9"
  - path: standards/wave-standard.md
    version: "v0.3"
---

# Governed Agentic Engineering: Building Systems With Agents You Can Check

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*Getting agents to do things turned out to be the easy part. The hard part was building a system in which you could tell whether they had done the right things. This overview describes the framework that came out of that work — what it governs, the ideas it rests on, what has been measured, and what has not.*

---

## 1 — The Question: Can You Tell Whether the Agents Did the Right Thing?

Coding agents can now produce working software quickly. A growing part of the industry talks about software factories: systems in which agents write most of the code and people direct, review and decide. The discussion has mostly been about speed, cost and the quality of the code.

A different question decides whether such a factory can be trusted with a real system: **how does anyone know that what the agents built is what should have been built?**

Three things make that question hard.

**The specification is written by agents too.** In a system of any size, agents draft more than the code. They draft the requirements, the contracts and the parameter values the code is built from. A wrong rule in the specification survives every check on the code, because the code does exactly what it was told. Yet the controls the field has built — tests, review, sandboxes — sit mostly around the agents that write code. The agents that write the specification are usually governed by a person reading what they wrote.

**A check can pass without looking.** An agent can write a test, read the code, adjust the test and report green, and nothing in its output shows which of those steps happened. A rule written into an agent's instructions is read by the same model it is meant to constrain. A gate that reads no input finds nothing to object to. Each of these looks like control, and each of them stops nothing.

**Agents forget, and systems drift.** Every session starts with an empty context. What one session learned has to be written somewhere the next one finds it, and decisions taken months apart must still agree. Without that, a system built by agents becomes a pile of locally reasonable choices that no longer fit together.

GAE is an answer to that question, developed while building one real system with agents and kept honest by measuring what it actually holds.

---

## 2 — What It Is: A Governed Factory

Governed agentic engineering (GAE) is a set of standards for building with AI agents. In it the specification is the source of truth, and every agent — the ones that write the specification as much as the ones that write code — works inside rules that a tool can check.

**Two shapes.** What the agents build takes one of two shapes. A *product* is software that runs without them; the reference installation, a running-coach platform, is one. A *knowledge corpus* is a governed body of knowledge — analyses, plans, decisions and their sources — in which the agents' work is itself the deliverable. The standards were written on a product, and they now carry both shapes: in a knowledge corpus the implementation level holds the agents' deliverables, and a deliverable made before its contract stands only with a visible mark (Truth Chain and Registry Standards). The starter kit sets up both. Where the standards still assume a product, the release's list of known issues says so: the record is taken to be a file, and the top documents have no type of their own.

**In a product: build-time agents, runtime determinism.** Agents build the system. Every decision the product takes for its users is made by deterministic code that reads governed contracts and governed values, so the same inputs give the same decision. In the reference installation those are training decisions: classifying the runner's state, setting load, granting escalation. A model may run at runtime only outside that decision layer. The reference installation uses one in three places, read in its code at the commits named in § 4:

- **Wording.** A language model writes the text a runner reads, from a snapshot of a decision already made; the snapshot is all it is given. A filter checks the text. Text that fails is generated again a bounded number of times and then replaced by fixed copy, and legal text never passes through the model.
- **Search.** A question typed into the search over the knowledge articles is turned into an embedding to find matching articles. It retrieves; it decides nothing.
- **A chat assistant.** In the app for ChatGPT, the runner's own assistant holds the conversation and calls the engine's functions. Three of them change the plan — creating one, pausing it and confirming a missed session — and they are declared to the platform as calls with consequences. The plan that results is computed by the engine, not by the model.

A model chooses words, finds articles or decides when to call. What the plan contains stays in deterministic code.

In a knowledge corpus there is no runtime to keep the agents out of, because their deliverables are the product. The same discipline moves to the deliverable: it rests on a contract and on the sources it cites, as code does in a product.

Everything the agents produce — specifications, values, code, checks, deliverables — passes through gates before it becomes part of the system, and everything in the system can be traced back to the specification that required it and the evidence that specification cites.

**The way of working: specify first, harden by failure.** The founding architecture was specified before the system was built: separated roles, with the author of a specification never its approver; an order of authority that decides which document wins a conflict; a canonical format for contracts; and registries for governed values and for the evidence behind them. Running the system then hardened that architecture, and most of the verification and dispatch controls were introduced in response to observed failures — a check that passed on a stub, a session that bypassed the pipeline, a parser that silently dropped records, a review series that would not end. Each failure was named, traced and turned into a rule, a tool or a gate, and the rule records the failure it came from. An origin table kept in the reference installation classifies 37 load-bearing parts this way (§ 4).

**Then scale it down.** Governance is built in two steps, a method this package calls governed ablation. Step 1 secures quality with rules, gates and mechanical measurement. Step 2 removes them one at a time against a fixed answer key until the result changes, and keeps what the result needs. Each removal is a hypothesis that the owner decides; nothing fades on its own. Step 2 has not been run, and its answer key, a regression suite for the governance itself, does not exist yet. The standards as released are step 1, and the growth of their rules is deliberate rather than the end state (§ 6.1, § 7).

**The family of standards.** At the centre is the Governed Agent Lifecycle (GAL), which says how an agent is built, started, verified and closed. Under the same name stand the Governed Implementation Pipeline (GIP), which takes work from a governed specification to the agents that write code; Governed Engineering Memory (GEM), the decision log, the retro log and what learns from them; and the verification architecture of gates, audit, independent derivation and adversarial review. GAL §1.1 draws the hierarchy.

Beside them stand the standards for what the agents work on: the Contract Standard (the document format), the Truth Chain Standard (the order of authority and the links to evidence), the Registry Standard (governed values), the Boundary and Handoff Standards (who may do what, and how work passes between agents), and the Backlog and Wave Standards (what is to be done, and in what order). The standards are the reference. This overview and the papers it points to explain why the rules are what they are; they do not restate them.

---

## 3 — The Load-Bearing Ideas

Each idea below is the subject of one companion paper.

### 3.1 The specification agent is governed as strictly as the coding agent

The authority to define what is correct, the ability to implement it and the authority to verify it lie with different roles. A specification agent drafts a contract; a different agent audits it against a fixed standard; neither of them writes the code; and the author never approves its own document. Gaps the build finds go back to the contract as gaps, rather than being filled by whoever noticed them. *Agent Roles and Orchestration.*

### 3.2 One document format for agents and people

A specification that a person reads correctly and an agent reads differently is two specifications. The contracts follow one format — typed sections in a fixed order, declared relations and precedence, structured metadata — so that the same text gives both readers the same answer and a tool can check whether it does. *The Canonical Standard.*

### 3.3 The contract is the source of truth

When the specification and the code disagree, a fixed order of authority decides, without judgement, which one is right. Code cites contracts, contracts cite governed values, and values cite evidence; evidence proposes and governance decides. *Contracts as the Source of Truth.*

### 3.4 Infrastructure holds the rules, and says which rules it holds

An instruction is read by the model it constrains. So the rules that matter are held by infrastructure — the tools an agent can call, the places it may write, the checks that run before a commit lands — and every rule states whether a tool holds it or only the agent's instructions do. *Harness Engineering.*

### 3.5 Loops are designed, bounded and owned

Agents work in loops whether anyone designs them or not. A designed loop has named parts — sensor, evaluator, decision, actuator, invariant — owned by different roles, a bound on its rounds, and an exit to a person. *Loop Engineering.*

### 3.6 Verification is a role, not a step

A passing check says either that the work is right or that the check did not look. Each level of verification — mechanical gates, semantic audit, empirical tests against a model of the domain, and derivation by an independent tool against an answer written down in advance — is held by someone other than the author, and every claim carries a record of what was measured and what was not. *Verification Architecture.*

### 3.7 Work reaches the builders through a gate

Between a governed specification and governed code stands a gate. A unit of work enters the queue only with a verified record that its specification passed audit, a scope that is measured rather than listed, and a specification that does not point or speculate. A new installation has one exception: the first post, which builds what the gate itself needs, and whose queue entry records what replaced each requirement it could not meet. After it the only way past the gate is the emergency path, which the owner may use when the gate itself does not work and which the standard requires to leave a trace (GIP Standard §3); in the reference installation that trace is not yet built (*Spec-Governed Dispatch*, § 6). The specification governs the work for as long as the work exists. *Spec-Governed Dispatch.*

### 3.8 Structure is explicit

Relations between contracts, between values and evidence, between modules, and between units of work are graphs with declared edges. One side writes an edge; everything else is derived. In the reference installation a tool refuses some edges that point nowhere — a dependency on a deprecated contract, an evidence ID with no entry, an order edge to a missing node — and only reports others, such as a dependency on a document outside the contract corpus (*Graph Architecture*, § 3.3). *Graph Architecture.*

### 3.9 Code carries no governed numbers

Every governed value lives once, in a registry, with its source and its confidence. A threshold written into both a specification and the code is two thresholds the moment one changes. *Numberless Code.*

### 3.10 Memory is governed, not just kept

Decisions and lessons are written in forms a parser can count, tools report what they did not carry, and recurring patterns become work items whose fix can be shown not to have held. *Context, Coherence and Memory.*

---

## 4 — Measured and Shown

Every figure below was read from the reference installation, Runapp, at one measuring point: corpus commit `bac7817` (2026-11-02), engine commit `acba054`, and the database as loaded on 2026-11-02. The runtime boundary in § 2 was read at the same engine commit, the iOS app at `8090c02` and the app for ChatGPT at `47ea542`. Each figure gives the rule that reproduces it. The companion papers carry the detailed figures.

**Scale.**
- 11,340 commits, from the first, dated 2026-02-28, to the measuring commit, 247 days later. *(The commit count of the measuring commit's history.)*
- 153 typed documents in the specification corpus, in nine domains: 135 in force and 18 deprecated. *(Documents that carry a document-type field, by their status and domain fields.)*
- Ten standards govern the framework; six specification agents work under them.

**Origin.** *(Origin table, built 2026-10-19 from the repository's history, decision log, retro log and work items; not recounted.)* Of 37 load-bearing parts of the framework, 15 were introduced in response to a named, dated failure; 2 are borderline; 19 were specified before the system was built and hardened later, 16 of them by named failures; and for 1 the origin is not recorded. The founding architecture appears in specification documents dated 2026-02-24 and 2026-02-25, before the first commit. The incident-born parts are mostly verification and dispatch controls.

**Harness.** *(The tool server's source at the measuring commit.)* The server registers 61 tools. One of them runs scripts from a fixed list of 50 and refuses any other name. The commit tool for non-canonical files reports up to 15 named checks in its answer. *(Distinct check labels in the tool's status lines.)*

**Verification at scale.** *(Decision log, retrospective entry for April–June 2026.)* A compliance loop over the contract corpus checked 97 contracts against their implementations and caught 514 checks that passed without testing what they claimed — in one contract, an entire suite of 53 green checks that tested a stub.

**The factory floor.** *(The implementation queue, all posts made since the gate was introduced.)* 31 units of work passed the gate and entered the queue. 25 are done, each with a reported merge on the main branch whose check is recorded, and 6 were superseded. Their 282 step receipts include 14 test reviews that found gaps in the checks before any code was written and 3 code reviews that disproved the change. *(Receipts of the test-review and code-review steps, by verdict.)* The median time from entry to done is 2.9 hours.

**Adversarial review.** 206 handoffs went from the reviewer back to the architect; 118 of them carry a closure verdict: 50 *yes*, 28 *partial* and 40 *no*. *(Handoff files whose name marks them as reviewer-to-architect; a verdict is the closure line opening with yes, partial or no.)* The same rule applied to the files up to 2026-10-19 gives v0.1's figures: 96 verdicts, 40, 25 and 31.

**Memory.**
- The retro log holds 1,550 entries in its file, and 39 more from implementation sessions' reports are stored beside them. *(An entry is a line that opens, after at most eight non-alphanumeric characters, with the word RETRO.)* The decision log holds 1,703 entries, the same number in the file and the database. *(A heading that opens with a full date.)*
- Of the 1,589 retro entries in the database, 567 (35.7 %) name a pattern; there are 224 distinct names.
- Pattern triage has opened 22 work items for patterns at the threshold, 10 of them closed, and 5 for regressions, all closed. 48 patterns carry a disposition: 23 fixed, 20 accepted and 5 dormant.
- The most frequent pattern — taking a count on trust instead of measuring it — has 152 entries, from 2026-09-24 to 2026-11-02. A regression item opened on 2026-10-13 counted 44 entries after its fix of 2026-10-03. The pattern has since been accepted, with a date for review, and 18 more entries have followed.
- A register of measurements that a session could not make holds 92 open entries; results have been recorded for 145.

**A second installation.** A second installation was set up from the starter kit in another domain: a strategy and planning system for a marketing role, in which the agents' knowledge work is the delivered product and the record is a database rather than files. The standards were copied unchanged. What did not fit was reported upstream. Much of it now stands in the standards, among it the knowledge-corpus shape, the round limits and the start gates' questions; the rest stands in the release's known issues, each item with a direction. The installation shows that the standards could carry an installation with no code in its product and with its record in a database, in a domain other than training. It does not show that the method transfers to anyone but the originator, or to a team, since the same person set it up. No figures from it are given here.

What these figures show is that the framework runs on a real system, that its checks find real errors, and that its records say plainly where it has not worked — its most frequent pattern among them.

---

## 5 — Where This Sits in the Field

GAE touches three current discussions.

**Software factories.** Uber has described running a software factory at scale, in which agents author most pull requests and managed agents handle code review, CI repair and triage under human review and escalation. Its thesis is cost: a model of what sessions, turns and tokens cost, with quality measured afterwards by outcome signals such as revert rates. GAE addresses a different control question — whether the factory builds the right thing — and answers it with contracts and gates before the work lands rather than outcome measures after it. It also draws a boundary Uber's factory does not: Uber's managed agents work in operation, on call and on bugs, while in a GAE product no agent takes part in a decision when the system runs.

**Spec-driven development.** A first search for this package read nine sources on how agents that write specifications are governed: Birgitta Böckeler's account of spec-driven development tools, GitHub's Spec Kit, AWS Kiro, BMAD-METHOD, MetaGPT, MARE, Bertrand Meyer's keynote and paper on agents for requirements, contracts and proofs, Warp's agents, and Simon Martinelli's AI Unified Process. Several already separate roles around specifications. Spec Kit has reviewer-owned checklists that the implementation may not silently self-approve; BMAD-METHOD runs reviews in a fresh context and puts a readiness gate before implementation; Warp has described separate agents for writing specifications, reviewing and triage, with changes to the agents' own skills reviewed as pull requests. A second search added ten candidates. The nearest of them are the framework for intelligent delegation by Tomašev, Franklin and Osindero, which treats roles, boundaries and contracts as part of delegation and asks for permissions as versioned policy, and Wang's VibeContract, in which a model generates contracts that developers validate and that drive the tests. These are partial predecessors of GAE's governance of specification agents.

None of the nineteen combined two things that GAE requires together: that the specification's own rules and values cite evidence, and that someone other than the author reviews the specification before it becomes authoritative. The nearest on evidence, Google's OKF specification, attributes claims to sources but makes its trust tiers advisory.

**Guardrails and harnesses.** A source-code study of eleven production coding-agent harnesses compared eight of them with snapshots from the study's earlier edition and found behavioural policy moving out of prompt prose and into configuration. The companion paper on harness engineering places GAE in that movement. GAE's particular contribution there is bookkeeping: every rule says what holds it.

The searches behind these statements covered the sources named and no others. This overview does not claim that GAE, or any combination in it, is new.

**Sources.** Medisetty, U. K. (2026-08-27). Running a Software Factory Efficiently at Uber Scale. https://www.uber.com/us/en/blog/efficient-software-factory/ · Böckeler, B. (2025-10-15), on spec-driven development tools, martinfowler.com, https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html · GitHub Spec Kit, documentation · AWS Kiro, documentation · BMAD-METHOD, repository and documentation · MetaGPT, arXiv:2308.00352 · MARE, arXiv:2405.03256 · Meyer, B. (2026). *Software Verification in the Age of Artificial Intelligence*, keynote, Swiss Testing Day, Zürich, 26 March 2026; and arXiv:2511.23159 · Segner, M. (2026-08-26), Claude blog post on Warp's agents, https://claude.com/blog/how-warp-builds-self-improving-agents-on-claude · Martinelli, S. (2026-08-27), on the three levels of spec-driven development, https://martinelli.ch/the-three-levels-of-spec-driven-development-and-where-the-ai-unified-process-sits/ · Tomašev, Franklin & Osindero (2026-02-12). *Intelligent AI Delegation*. arXiv:2602.11865 · Wang, S. (2026). *VibeContract: The Missing Quality Assurance Piece in Vibe Coding*. arXiv:2603.15691 · Google Cloud, OKF specification, `okf/SPEC.md` in GoogleCloudPlatform/knowledge-catalog · Barbaste, Darrigol, Vu & Wiltberger (2026). *Harness Engineering*. arXiv:2609.00006

---

## 6 — Limitations

### 6.1 What is not shown

- **Two installations, one originator.** GAE was developed and measured on one system and tried in a second, in another domain. The same person set up both. Nothing here shows how it behaves when someone else adopts it, with a team, or on another agent platform.
- **Not everything is incident-born.** The founding architecture was designed up front. The claim that failures shaped the framework holds for most of its controls, not for its foundations, and the origin of one part is not recorded.
- **The logs are self-reported.** The retro log and much of the decision log are written by the agents about their own sessions. A rule removed for having caught nothing may have prevented errors no one wrote down.
- **Several rules are held by instruction.** The companion papers list them: per-agent write surfaces in the specification repository, the read boundary of the agent that writes checks, the model split between builder and verifier. Each says so where it is described.
- **Some loops do not converge yet.** The most frequent recurring pattern regressed after its fix and has been accepted rather than fixed again (§ 4).
- **The standards assume a product in places.** They carry the knowledge-corpus shape, but they still take the record to be a file, which an installation whose agents can write only a database cannot follow without a departure, and they have no document type for the top documents (§ 2).
- **No external evaluation.** The figures are the installation's own. No independent party has reproduced them.
- **The method grows.** Every named failure has added a rule, a tool or a gate, so the method grows by construction, and critics of software factories have a point. One observes that the companies selling a software factory "produce a shockingly tiny amount of software" (dax). Osmani argues that with agents, too much process becomes a new kind of micromanagement. Anthropic reports a fixed rule for what agent memory should record costing Opus 5 and Opus 4.7 much of the gain memory gave them, and a review that led an agent to add excessive validation against another internal service. The answer here is measured production rather than the number of rules, the factory floor in § 4, and step 2 of governed ablation (§ 2), which has not been run.

### 6.2 Scale

To scale is not only to run more agents. Coordination, governance and verification have to grow with the work, or the operator's attention becomes the bottleneck; Osmani's heading for the point is "Scale verification, not attention." Everything measured here was measured with one operator. The release lists three tracks as open. For each, this is what the method already has, what is missing, and the direction a solution takes. A direction is a proposal, not a measured result; this section does not claim that the method scales. Three of the directions name a routing step: an agent that classifies and dispatches incoming items but does no work itself. None has been built. The routing step is taken from a design the DeepSeek Harness team published in 2026: a long-lived router layer handles all human interaction and starts new tasks on isolated workers, while follow-up events on a task go straight to the worker that owns it. The routing step proposed here differs on one point. In that design the router session carries the working memory across tasks in its own context, with persistent state kept in a database; the routing step proposed here would carry nothing from one decision to the next and read the record each time, the stateless form of harness that Anthropic describes for its managed agents.

**Autonomy: when a human checkpoint can go.** Autonomy is earned by reliability that has been shown, not granted by configuration, and the track below is the evidence for and against it.
- *Has.* A mechanical check that has not stopped a real error within thirty days is removed. Since 2026-10-20 the reference installation also tells a gate from a sensor. A sensor is a read at the architect's session start that never stops work, and it is judged by whether it showed something no other step showed; a gate is judged by what it stopped.
- *Missing.* The same evidence for a human checkpoint. The operator's confirmation is a flag the agent sets, not a log entry, and the emergency path has no log of its uses. So no checkpoint can be lowered on evidence. Nor is any gate judged by what it let through: the thirty-day rule counts what a check stopped, and nothing traces a later failure back to the gate that passed it. Eno Reyes describes validation that makes that trace, from each failure in production back to the change that caused it.
- *Direction.* Log every confirmation with its outcome: approved, changed or refused. Lower a checkpoint to a gate or a sample only when the log shows it has changed nothing over a set number of occasions. Removing a human checkpoint is governed ablation applied to a person, and its measure is how often an attestation changes an outcome. For the result, count how many merged changes later needed no correction, for the agents' changes and for people's. Reyes describes validation whose goal is to raise a regret-free merge rate until most changes can merge automatically. Grant autonomy per class of work rather than per checkpoint, in a policy that code applies. The line between classes runs between work that restores agreement with a contract as it stands, which an agent may start, and work that changes what a contract says, which waits for the owner's decision. A routing step may propose the class of an incoming item; the policy decides what that class allows, so a wrong classification cannot widen its own mandate. Before a class is given more room, replay the installation's decision log and handoffs as a test set: compare the proposed classification with what the operator actually did, class by class, and count the events where nothing should have happened as cases of their own.
- *Not measured.* No class policy or replay has been run, and whether the history is consistent enough to serve as the answer key is not known.

**Parallel sessions and several operators.**
- *Has.* Declared dependencies between contracts; the Wave Standard's explicit edges and its rule that unread is not done; a commit tool that stages only the files a session names; and a queue in which an implementation session claims and releases a post. In the reference installation the architect's session start also lists units of work that have stood built for more than a day and claimed units with no sign of life.
- *Missing.* The contracts a change affects are found by the audit, after the work is routed, and in the reference installation that has happened. The specification agents work in one shared copy, one at a time: enough with a single operator, a queue as soon as there are more (the release's known issues, § 3). With several operators, nothing says who decides when two of them decide about the same cluster of contracts.
- *Direction.* Compute the affected set from the dependency graph before work is routed, and carry it with the work. Lock per cluster of dependencies rather than per working copy, so that sessions whose clusters do not overlap can run at once, each on its own branch, merged through the gates. Give decision rights per cluster, with the same escalation to a person that an open question takes today. Let several operators become several sources of events into one routing step and one truth chain, not several truths; the routing step is where the affected set above is computed, when an item is triaged. Measure progress, not activity: a unit of work shows verifiable progress at set points, and work that stands still or drifts apart is raised rather than waited out. The rebuilds of version control for agent load at Anthropic, GitHub and OpenAI rest on a related principle, agreement only where two writers touch the same place: GitHub's "Only reference updates need agreement"; OpenAI coordinating each branch on its own, so that clients conflict only when they push to the same reference at once; and Anthropic, which could not replicate a global lock on its merge queue, testing after the merge and before deploy instead. Those systems are measured at a scale this method does not have.

**Context.**
- *Has.* The method already keeps state outside the context window. Modules are loaded when needed. Registries are read through tools rather than whole. A resume brief and a handoff carry what was not measured to the next session. Learnings are recalled at decision points, and sub-agents read broadly and return a conclusion. Implementation sessions stop hard at 60 % of their context and report the stop with their post. Specification sessions in chat begin their close at about 70 %, a figure the model estimates for itself, since nothing in chat measures it.
- *Missing.* The standards do not state context control as a principle, and nothing measures how much context a session spends on a task.
- *Direction.* Context control as a stated principle, with the mechanisms above as its instances, and the two limits described as what they are: one measured, one estimated. A routing step, if one is added, is another instance: it keeps no state of its own and reads the corpus and the database at every decision, so that its choices can be audited, it can be replaced, and the record stays in the truth chain rather than in a long-lived agent.

**Sources.** Qiao, Y. (2026-11-01). *Exploring Super-agent Design: Towards a More Autonomous Agent System*. DeepSeek Harness, X article, machine-translated from a Chinese original. https://x.com/DeepSeekHarness/status/2116857257245987236 · Martin, L., Cemaj, G. & Cohen, M. (2026-04-08). *Scaling Managed Agents: Decoupling the brain from the hands*. Anthropic. https://www.anthropic.com/research/managed-agents · Martin, L. (2026-11-06). *The components of agent memory*. Anthropic. https://www.anthropic.com/research/components-of-agent-memory · Nick G. and the source control team (2026-10-13, updated 2026-10-15). *Redesigning source control at Anthropic*. Anthropic. https://www.anthropic.com/research/redesigning-source-control · Raman, K. & Celenza, B. (2026-11-05). *Inside GitHub's new Git storage architecture*. GitHub. https://github.blog/engineering/architecture-optimization/inside-githubs-new-git-storage-architecture/ · Friel, A., Blau, T. & Nyman, T. (2026-11-02). *Scaling Git at OpenAI*. OpenAI. https://openai.com/index/scaling-git-at-openai/ · Reyes, E. (2026-11-06). Post on X. https://x.com/EnoReyes/status/2118767454721851680 · dax (2026-11-06). Post on X. https://x.com/thdxr/status/2118604739428426223 · Osmani, A. (2026-11-08). *Your coding agents made you a manager*. Article on X. https://x.com/addyosmani/status/2119332146485891501

---

## 7 — What Comes Next

- **An outside adopter.** The standards and the starter kit are released together. The next test of the method is an installation set up by someone other than its originator, from the kit alone.
- **The known issues.** The release lists what is missing in the standards, each with a direction. A direction enters a standard only through a new release.
- **The controls not yet built.** The companion papers list them, each with the measured failure that will trigger it.
- **Step 2 of governance.** Governed ablation needs its answer key first: a regression suite for the governance, built from the findings a reviewer is expected to make, the patterns that recur in the retro log and the checks that must fail. It is then run after each release of the standards and at each change of model, since a stronger model may not need what a weaker one did. A rule that guards a rare failure is tried against a planted fault, not judged by a quiet window.
- **Prior art.** Searches for the parts not yet searched, the Wave Standard's ideas among them, before any claim about them is made.

---

## 8 — Map

- **Companion white papers:**
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
  - *Case Study: Runapp*, on the reference installation
- **The release:** the ten standards (GAL, GIP, GEM, Contract, Truth Chain, Registry, Boundary, Handoff, Backlog and Wave), the starter kit, which begins with its README, and the list of known issues, all in the GAE repository.
- **Under NDA:** the anatomy of the agents' instructions with annotated excerpts; the specification of the reference installation's gates and tools; an analysis of its decision and retro logs.
- **The other parts of the work:** Runapp, the system GAE was developed on, in the `runapp-platform` repository; and the simulator and the QDOT plan-quality model, used to investigate and validate what Runapp produces, in the `runapp-validation` repository.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this overview and a standard differ, the standard holds.*
