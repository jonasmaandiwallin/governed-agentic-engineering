---
title: "Verification Architecture: Four Levels, Independent by Design"
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
    scope: "Text and structure of v0.1 (2026-10-16), and in v0.2 § 4 rewritten with a rule per figure and the register of measurements not yet made."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the verifiers' instructions read in the four product repositories at their heads of 2026-11-02; the derivation chain's log read on 2026-11-02."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: sentences close to a standard's wording replaced by explanation and pointers (§ 3.1, § 3.3, § 3.4, § 3.8); the round limits marked as the installation's and the starter kit's; the register of measurements not yet made; the empirical level's version stamp dated; Limitations brought up to date with the release's known issues; the map pointed at the release."
    evidence: "The diff against v0.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 (Meyer's keynote and arXiv:2511.23159) checked against their primary sources by Research Pipeline on 2026-10-19, and the formal-methods framing again on 2026-11-02: it rests on the paper's abstract, not on the keynote's summary."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings; two advisory findings stay open for the next revision: sentences sharing a run of ten or more words with the standards' wording, and a release-tool form that none of the twelve papers contains."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/verification-architecture.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gip-standard.md
    version: "v0.5"
  - path: standards/gal-standard.md
    version: "v1.76"
  - path: standards/handoff-standard.md
    version: "v0.3"
---

# Verification Architecture: Four Levels, Independent by Design

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*A check that passes says one of two things: the work is right, or the check did not look. This paper is about telling those apart — the levels at which GAE verifies, why each level is held by someone other than the author, and how a claim carries a record of what was measured and what was not.*

---

## 1 — The Problem: Green That Means Nothing

The most dangerous result in an agent system is not a failure. It is a pass that did not test what it claimed to test.

A check written by the agent that wrote the code tends to confirm the code, mistakes included. A test suite can run hundreds of checks against a stub and be green throughout. A scanner that reads the wrong directory finds nothing wrong, and reports that well-formed nothing as a clean result. A reviewer that agrees with the author because the author's reasoning is fluent has added a signature, not a check. A rule rewritten to be clearer can keep every keyword and lose its meaning.

Each of these produces the same output as real verification. None of them is caught by more verification of the same kind, because the error is in the arrangement: who checks, what they can see, and what counts as having looked.

The question this paper answers is: **how does a system arrange verification so that a pass means the work was tested — and how does every claim say what was measured and what was not?**

---

## 2 — What It Is: Four Levels and an Independent Verifier at Each

Governed agentic engineering (GAE) verifies at four levels. Each answers a different question, and a pass at one says nothing about the others.

| Level | Question | Verifier | Example |
|---|---|---|---|
| **Syntactic** | Does it have the required form? | Tools: gates at commit, validators, structural checks | Instructions match their skeleton byte for byte; a handoff names a route that exists |
| **Semantic** | Does it mean what it should? | An auditor against a standard; an adversarial reviewer for agents and infrastructure | A contract audited before it becomes truth; a rewritten rule read for weakening |
| **Empirical** | Does it behave as the domain says it should? | Runs against a domain model, bound to a model version | A rule's effect measured in simulation across a population |
| **Independent derivation** | Is the mathematical form what we claim it is? | External tools with no knowledge of the project, against a pre-registered question | A functional form's properties derived before the form is written into a contract |

Alongside the four levels, the implementation pipeline has its own verifiers: a tester that writes checks from the contract or the acceptance criteria without reading the code, and a verifier that reviews those checks and then tries to disprove the change.

Running through all of it is a discipline for claims. A response that states something new about the system ends with a line saying what was measured, with which tool, and what was not. What could not be measured is written down with who measures it and when, and stays on record until a result is recorded.

Where the rules stand: the GIP Standard holds the implementation verifiers; the GAL Standard holds the conformance classes, their acceptance rules and the adversarial semantic review; the Handoff Standard holds how a handoff carries what was not measured, through a rule each installation binds. The reference installation binds that rule in a document of its own, the measurement line. The standards are the reference and are not restated here.

---

## 3 — The Load-Bearing Ideas

### 3.1 Verification is independent, or it is not verification

No role verifies its own work. The contract author's draft goes to an auditor. The tester writes checks without reading the code they check. The verifier runs on a different model from the implementer. A change to an agent's instructions goes to an adversarial reviewer, and a change to the reviewer's own instructions goes to another role, in another session.

What makes this hold is where the line is drawn. GAL draws it around the role, not the session or the model (GAL §9.2, rule 5). A second session of the same role has the same reasons to confirm what the first one wrote, so it does not count as a second pair of eyes. Independence is what separates a verification from a second draft.

### 3.2 Disprove first

A verifier's job is to break the work, not to approve it. In the implementation pipeline, the code review tries to disprove the change in several ways at once (GIP §5.2, step C.5). It mutates the code — replaces a registry read with its literal value, inverts a rule — and asks whether any check would notice. It searches for new code that nothing calls and for hard-coded fallbacks of governed values, and for a defect it looks for the same pattern in every sibling the task lists. In a review of agent instructions, the reviewer asks five questions of every changed rule (GAL §9.5): was it lost, weakened, moved, contradicted, or added without a counterpart?

A verdict of "nothing found" means the verifier tried and failed to break the work. It never means the verifier did not try.

### 3.3 An empty measurement is a failure

GAL's acceptance rules begin here (GAL §9.2, rules 1 and 2). A check that finds none of something the system plainly contains has most likely looked in the wrong place, so it stops and names where it looked instead of reporting the zero. What a check did not measure is an outcome of its own, and it never counts as a pass; nor does a registered exception.

This is the rule that separates *observed absent* from *not observed*. Without it, every broken scanner looks like a clean system.

### 3.4 Structure is necessary and not sufficient

Syntactic checks are cheap and run on every commit, and they catch a great deal: a skeleton out of order, a version not bumped, an archive missing. They cannot see meaning. A rule can keep every keyword and still lose its force — a modal verb softened is enough.

So a change to an agent's instructions passes both: the structural classes, and an adversarial semantic review that reads the old and the new text side by side (GAL §9.5). A change that tightens one case and relaxes another counts as a weakening, however it is labelled, and no class stands in for another (GAL §9.1).

### 3.5 Fix the invariant, not the instance

A reviewer's finding carries an invariant — the property that does not hold — and one test case that shows it. In the reference installation, the fix is built against the invariant: the fixer enumerates the class the invariant covers, and adds a second test of its own that the finding did not name, from another member of that class. A fix that only handles the finding's example will be met by the same finding, in a new form, in the next round.

On the code side the starter kit draws a further line: a post's tests bind its acceptance criteria and invariants, not every observation from a review. A mutation the verifier finds surviving where the specification is silent goes back to the architect as a question about the specification, not into a new test.

Review rounds are bounded, and the bounds are each installation's. GAL itself sets none. In the reference installation, the adversarial review stops after two rounds without approval, and the owner then decides whether to close with the open findings carried forward or to ask for a third; a build review stops after three. GIP lets an installation allow the owner to accept a build with the open findings carried; the reference installation does not. The starter kit binds two rounds by default, for the contract audit as well.

### 3.6 Pre-register, then falsify

For mathematical forms — how a quantity saturates, how weights combine — GAE uses an independent derivation chain. The question is formulated as a closed mathematical problem, with no project knowledge in it, and written down before the answer arrives. An external tool computes the answer. The answer is a hypothesis to be tested against the repository, never a basis for a decision on its own, and never cited as support. A question rewritten after an uncomfortable answer is recorded as rewritten.

A tool that returns nothing has not answered "no". It has measured the formulation. So every empty answer is paired with a positive control — a question with a known answer — to tell a broken instrument from an unanswered question.

### 3.7 Empirical results are bound to a model version

A result from a domain model holds for the version of the model that produced it. Each run is stored with that version, and a change to the model starts a new epoch: results from different epochs are not compared as if they were one series. A model's agreement with itself is corroboration, not truth; it says the system behaves as the model says it should, not that the model is right about the world.

### 3.8 Every claim carries its measurement

A response that states something new about the system ends with a line naming what was measured, with which tool, and what was not. In the reference installation, something may stand as not measured for one of two reasons only: the tool that would measure it does not exist, or a thing the measurement needs is missing in this session. Cost is not one of them; a claim too expensive to measure in full is narrowed to what was measured.

What stays unmeasured gets an identifier, the name of whoever measures it and the condition under which they do, and is entered in a register. The register keeps it until the session in which the condition holds records a result. A handoff carries the entries that concern its receiver, and the handoff validator fails a handoff when an entry has left the register without a result.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**Adversarial review.** *(Handoff files whose name marks a handoff from the reviewer to the architect; a verdict is a line labelled `Stängningskriterium:` whose first word is yes, partial or no, or the Swedish ja, delvis or nej.)* Of 206 handoffs from the adversarial reviewer to the architect, 118 carry a closure verdict: 50 yes, 28 partial and 40 no. The same rule over the files dated up to 2026-10-19 gives v0.1's 184 and 96, of which 40, 25 and 31. The longest series of reviews under one name ran to 35 rounds, on a work item closed on 2026-09-14; the two-round limit was set on 2026-10-05. *(Review files named with a round number, counted per name.)*

**The implementation verifiers.** *(Step receipts of the units that passed the gate, by step and verdict.)* On the 31 units of work that have passed the gate, the 282 step receipts include 14 test reviews that found gaps in the checks before any code was written, and 3 code reviews that disproved the change. 279 of the 282 receipts name the model from the step agent's configuration; 3 name it from the agent's transcript.

**What independence caught earlier (decision log, retrospective entry for April–June 2026).** A compliance loop over 97 contracts found 514 checks that passed without testing what they claimed. In one contract the whole suite of 53 checks tested a stub.

**The empirical level.** *(Stored simulation runs, by model version.)* 5,903 runs are stored between 2026-03-28 and 2026-09-03, across 32 versions of the model. The runs since 2026-08-02 carry the version they ran on; the 2,226 before that date do not. On 2026-11-02 the configurations behind the comparison figures of the simulator white paper were run again — 46 runs, deterministic and not stored — and all 54 figures matched the earlier runs.

**Independent derivation.** *(The chain's measurement log, one row per question.)* Seven questions were logged between 2026-08-10 and 2026-08-26. Six could be posed as closed problems; one could not. One closed question got no answer in four formulations while its positive control answered; it was recorded as unanswered, not as a negative result. Another got no answer on its first formulation, with the control green, and was answered after a change of notation. The question without an answer key produced an answer that coincided with the one written down beforehand. In trials before the log began, the chain rejected a deliberately planted incorrect result.

**The measurement line.** *(Entries in the register; result lines in the identifier form, counted as lines and as distinct identifiers.)* The register holds 92 open entries. Results stand on 221 lines, for 145 distinct entries. Before the register, on 2026-10-21, every open entry was copied into every handoff: 49 of the 73 entries then carried stood nowhere but in handoffs, reports and review files, and 9 had dropped out of their chains without a result.

What these figures show is that the verifiers find things — gaps before code, changes that do not survive disproof, false greens at scale — that a published comparison can be reproduced from its stored configuration, and that the system keeps a ledger of what it has not yet checked. The last is as much a part of verification as the first.

---

## 5 — Where This Sits in the Field

None of the individual techniques is new. Mutation testing is decades old. Pre-registration is how clinical research guards against a question that moves after the answer arrives. Falsification as the test of a claim is Popper's. Independent review is the basis of every audit profession.

What agents change is the cost and the temptation. An agent can write a check, read the code, adjust the check and report green in a minute, and nothing in its output shows which of those steps happened. Bertrand Meyer's 2026 keynote *Software Verification in the Age of Artificial Intelligence* addresses the same shift, and his paper of late 2025 approaches it from the side of formal methods, combining the creativity of AI with formal specification and formal verification. GAE's response is architectural rather than methodological: it assigns each verification to a role that cannot see what would let it confirm instead of test, and records the arrangement in the receipt of every step.

We have not checked whether the combination described here — four levels with an independent verifier at each, a disprove-first verifier on another model, pre-registered derivation, and a ledger of what was not measured — is formulated elsewhere, and this paper does not claim it is new.

**Sources.** Meyer, B. (2026). *Software Verification in the Age of Artificial Intelligence*, keynote, Swiss Testing Day, Zürich, 26 March 2026; summary: https://swisstestingday.ch/software-verification-in-the-age-of-ai/ · Meyer, B. (2025-11-28). arXiv:2511.23159

---

## 6 — Limitations

- **The verifier's mutation probe is analytic.** GIP has the probe run the checks against a mutated copy of the repository. In all four of the reference installation's product repositories, the verifier instead decides by reading the checks whether a mutation would be caught.
- **Part of the verifier's search runs elsewhere.** No verifier's instructions in the reference installation carry the sibling search or the escape-hatch search the standard gives it: the first is done when the architect writes the task specification, the second by the session agent and in continuous integration.
- **The model split is claimed, not proven.** Almost every step receipt names the model from configuration; no hook the platform offers reports the model a step agent ran on.
- **The tester's read boundary is held by instruction.** The rule that the agent writing checks never reads the code is not enforced by the platform today, though the platform could enforce it.
- **The completeness gate does not run at merge.** The contract loop's final sensor runs when an agent calls it.
- **The empirical level validates against a model, not the field.** The simulation results say how the system behaves under the domain model; no prospective field data has tested the model itself. The last stored run is from 2026-09-03, and runs before 2026-08-02 carry no version.
- **The derivation chain's second link depends on a preview model.** When it is unavailable, the chain's rules postpone a form choice rather than lower the requirement.
- **The contract audit has no round limit in the reference installation.** Only the adversarial review and the build loop's reviews are bounded. The starter kit binds a limit for new installations.
- **The measurement line itself is not gated.** The handoff validator checks the inherited entries — their form, that they are carried with the same condition, and that none leaves the register without a result. Whether a response that needed a measurement line has one is reviewed, not measured.
- **No conformance class covers the bootstrap prompt.** What a chat platform loads is a few lines of project instructions pointing to the agent's core, and the standard measures those lines nowhere (the release's known issues, GAL).
- **Any later change ends an approval.** Under GAL §9.2 rule 3, fixing only what an approving round named still takes a new round. The starter kit lets the approval hold over such fixes; the standard does not.

---

## 7 — What Comes Next

- A mutation probe that runs the checks against a mutated copy, once an analytically "caught" mutation is shown to survive.
- A step receipt that proves which model ran.
- A read wall for the tester on the platform's existing hooks, once a tester is measured reading the code it checks.
- The completeness gate at merge, with the first contract-driven unit under the current pipeline.
- Prospective validation of the domain model against field data.
- In the standards, as directions in the release's known issues: the bootstrap prompt as a measured component of the agent, and the later changes an approval holds over.

---

## 8 — Map

- **The GAE overview** places verification among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - GIP Standard: the tester, the verifier, the step receipts and the queue as proof
  - GAL Standard: the conformance classes, the acceptance rules and the adversarial semantic review
  - Handoff Standard: the lines a handoff to and from the reviewer carries, and the slot for the measurement rule
  - Contract Standard: audit tracking and the completeness gate as a tool class
- **Related white papers:**
  - *Loop Engineering*, on the loops these verifiers sit in
  - *Harness Engineering*, on the gates at the syntactic level
  - *Agent Roles and Orchestration*, on why verification is a separate role
  - *Numberless Code*, on values marked as untested hypotheses
  - *Case Study*, on the reference installation
- **The empirical level in full:** the simulator and the QDOT plan-quality model, in the `runapp-validation` repository.

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
