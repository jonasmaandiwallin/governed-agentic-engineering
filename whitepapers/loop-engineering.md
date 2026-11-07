---
title: "Loop Engineering: Designed Loops That Converge"
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
    scope: "Text and structure of v0.1 (2026-10-16), and in v0.2 the sensors at the architect's session start and § 4 rewritten with a rule per figure."
    evidence: "The document text itself."
    reason: null
  - role: technical-analysis
    status: complete
    scope: "Figures in § 4 measured in the reference installation at corpus commit bac7817 and its database as loaded on 2026-11-02, each with the rule that reproduces it; the predecessor loop and the stricter completeness gate taken, with their dates, from the decision log and the completeness report, and not recounted."
    evidence: "§ 4 gives the measuring point and a rule for each figure."
    reason: null
  - role: editing
    status: complete
    scope: "v0.2: triage described as run at every architect session start since 2026-10-20; the regression rule brought in line with the standard and the installation's practice; the round limits marked as the installation's; § 3.5 rewritten as explanation with pointers; § 5 dated to the checked Osmani post; Limitations brought up to date with the release's known issues. v0.2.1: sentences that shared a run of ten or more words with a standard or the known issues rewritten in the paper's own words, with the pointer kept. v0.2.2: brought up to gae-standards-v0.5. The two-round limit and its exception for contracts are now GAL's, and every advisory finding of a contract audit now ends as a fix or a drop the architect validates (§ 2, § 3.4, § 6). Every sentence about a standard was read against the v0.5 text before the change."
    evidence: "The diff against v0.2.1."
    reason: null
  - role: fact-check
    status: complete
    scope: "External references in § 5 (Osmani, Warp) checked against their primary sources by Research Pipeline on 2026-10-19; the Osmani post's date again on 2026-11-02. The plan–do–check–act cycle is named without attribution."
    evidence: "Research Pipeline's reference reports of 2026-10-19 and 2026-11-02, one row per claim with the source's own text and who read it."
    reason: null
  - role: review
    status: complete
    scope: "Adversarial review of the twelve papers and the release tool in two rounds against six classes: a refusal of the release tool that lets a member of its class through, a change to what the standards release ships, a figure the stated rule does not reproduce, a claim beyond its source, internal material in released text, and two papers contradicting each other."
    evidence: "Round 1 (2026-11-02): 6 blocking and 9 advisory findings, all corrected in this version. Round 2 (2026-11-02): no blocking findings and two advisory ones, both corrected after the round: sentences that shared a run of ten or more words with the standards' wording were rewritten (v0.2.1), and the release tool now refuses a reference-corpus path that opens an HTML comment."
    reason: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "whitepapers/loop-engineering.md"
package: gae
release: public
audience: "External — no IP disclosure. Readable without NDA."
describes:
  - path: standards/gip-standard.md
    version: "v0.6"
  - path: standards/gem-standard.md
    version: "v0.10"
  - path: standards/gal-standard.md
    version: "v1.78"
  - path: standards/contract-standard.md
    version: "v0.7"
---

# Loop Engineering: Designed Loops That Converge

Part of Governed Agentic Engineering (GAE), a framework developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation.

*Agents work in loops whether anyone designs them or not: try, check, try again. This paper is about the difference between a loop that emerges and one that is designed — what its parts are, who owns each part, and what keeps it from running forever or settling on the wrong answer.*

---

## 1 — The Problem: Loops Nobody Designed

An agent that is told to make the tests pass will try something, run the tests, and try again. That is a loop. Nobody designed it, and it has three properties that make it dangerous.

**The actuator can move the sensor.** If the agent that writes the code can also change the tests, the fastest way out of the loop is to make the tests easier. The loop ends green, and the green means nothing. The same holds one level up: a build that can change the specification it is checked against will, sooner or later, change it.

**It stops when it is tired, not when it is done.** An emergent loop ends when the agent runs out of ideas, context or patience. The state it ends in is whatever it happened to reach, and nothing records whether that state was the goal.

**It does not learn across runs.** The same mistake is made, noticed and fixed in one session, and made again in the next one, because the lesson lived in a context window that is gone. Every run starts from zero.

None of these failures is caused by a bad agent. They are caused by a loop whose parts nobody named: what it measures, who judges the measurement, what it does with the judgement, what it may never change, and when it gives up.

The question this paper answers is: **what does a designed loop consist of, how is each part kept independent of the others, and how can one tell from the record whether a loop is converging?**

---

## 2 — What It Is: Five Parts, a Bound and an Exit

In governed agentic engineering (GAE), a designed loop has five named parts.

- **Sensor.** What the loop measures, and the tool that measures it.
- **Evaluator.** The rule that turns the measurement into a judgement: pass, gap, regression.
- **Decision.** What happens on each judgement: another round, a route to another role, a stop.
- **Actuator.** The role that changes something in response.
- **Invariant.** What the loop may never change in order to get out of itself.

Every loop also has a **bound** — a number of rounds after which it stops — and an **exit** to a person when the bound is reached.

The reference installation runs several such loops. Two are described here in full: the build loop, in which code is made to meet a contract, and the memory loop, in which the system turns its own friction into changes to its rules and tools. The rules stand in the GIP Standard (the build loops) and the GEM Standard (the memory), which are the reference.

| Loop | Sensor | Evaluator | Decision | Actuator | Invariant | Bound and exit |
|---|---|---|---|---|---|---|
| **Build (contract-driven)** | Completeness gate on the contract; checks written from the contract | Verifier's verdicts; gate's count of statements and values covered | Back into the loop, a finding to the specification side, or done | Implementer (code), tester (checks) | Checks unchanged by the implementer; the contract unchanged by the build | Review-round and retry limits; hard stop to the owner |
| **Memory** | Retro entries with named patterns | A threshold of undisposed occurrences; regression after a countermeasure | A work item, a countermeasure, or an accepted pattern with a re-review date | Architect (rules and tools) | Logs are append-only; only the architect disposes a pattern | Re-review date; a regression reopens the countermeasure |
| Contract review | Audit against the contract standard | Auditor's verdict | Approve, or return with findings | Contract author | The author never approves its own document | A contract takes effect only on an approving full audit of its current version, so GAL's round limit does not close it; every advisory finding ends as a fix or a drop, and the architect validates each drop. The reference installation has not yet bound a round limit here |
| Adversarial review | Reviewer's findings by class | A closure criterion stated in the handoff | Fix round, or close | Architect | The reviewer never fixes what it found | Two rounds (GAL), then the owner decides |
| Research intake | New sources | Classification against the evidence registry | No action, an evidence entry, or a proposal to change a contract | Domain researcher, contract author | Evidence never changes a contract directly | One pass per intake |

---

## 3 — The Load-Bearing Ideas

### 3.1 The sensor is out of the actuator's reach

The most important design decision in a loop is who may change what the loop measures. In a designed loop, the answer is: not the actuator.

In the build loop, the tester writes the checks from the contract without reading the code, the implementer makes them pass without changing them, and only the tester changes what a check asserts. The verifier, which judges both, never runs on the implementer's model. One level up, the build never changes the contract: what it learns about the contract goes back to the specification side as a finding. In the memory loop, the logs are append-only, so the record of what went wrong cannot be edited into what should have gone wrong.

A loop whose actuator can reach its sensor will converge — on whatever the actuator finds easiest to produce.

### 3.2 The loop must prove its sensor sees something

A check that passes before the code is written is not checking that code. So the build loop requires at least one check to fail before the implementation starts, and sends the checks back for review when none does. A completeness gate that reads nothing fails rather than reporting "complete". A memory tool that parses zero entries from a non-empty log fails rather than reporting "no patterns".

This is the loop version of a principle that runs through all of GAE: an unread result is never a clean result.

### 3.3 Done is the goal's content, not the loop's passage

A build loop that ends when the tests are green measures its own passage. GAE's contract loop ends only after the merge, when the completeness gate counts the contract on the main branch as fully covered — every normative statement and every governed value consumed and tested. Green tests are a condition for merging; they are not the definition of done.

The distinction matters because a loop optimises for whatever ends it. A loop that ends on green tests produces green tests. A loop that ends on a complete contract produces a complete contract, or a finding that says why it cannot.

### 3.4 Every loop is bounded, and the bound exits to a person

When a bound is reached, the loop does not try harder. It stops, and the decision goes to a person: continue, split the work, or send it back (GIP §5.1). GIP also lets an installation allow the owner, at the review limit, to accept the work with the open findings carried as work items, the verifier's verdict kept unchanged beside the acceptance; the reference installation does not allow it.

The build loop's bounds are calibration, not doctrine. Their values stand in the installation's appendix, and changing one is a decision someone makes, not a drift. The bound on adversarial review is different: GAL itself sets it at two rounds (§9.7), after which the owner decides, so no installation calibrates it away.

### 3.5 Learning is a loop with a counter

The memory loop has the same five parts as the build loop, but its unit is a pattern rather than a check.

A session ends with a retro entry, and an entry may name a pattern. Because a name means the same thing in every entry, occurrences can be counted, and a pattern that reaches a threshold without a disposition gets a work item (GEM Standard §6). The architect then either puts a countermeasure in place — a change to a rule, a tool or a gate — or accepts the pattern with a date on which it comes back.

What makes it a loop rather than a list is the regression rule. A countermeasure counts from the day its work item closes, and an occurrence after that shows that it did not hold. The standard has the countermeasure's own item reopened, so the record keeps one thread per pattern. The loop thus has its own evaluator for whether its actions worked, not only for whether it took them.

### 3.6 Convergence is visible, not assumed

A designed loop is not guaranteed to converge. What the design guarantees is that convergence, or its absence, is visible in the record. The build loop's step receipts show how often each review found something. The memory loop's counts show whether a pattern recurs after its countermeasure. A loop that keeps detecting the same thing without it going away is a finding about the countermeasure, and the record says so.

What the record does not yet show is the conditions an outcome arose under. A pattern that recurs less may have met a better countermeasure or easier work, and the counts cannot tell which; the release's known issues propose storing the conditions with the outcome.

### 3.7 Why emergent loops diverge

An emergent loop has the same five parts as a designed one, but nobody assigned them. The sensor is whatever the agent happens to run, the evaluator is the agent's own sense of "good enough", the actuator is the same agent, there is no invariant, and the bound is the context window. Each of those defaults pulls the loop towards the cheapest state that looks finished.

Designing a loop is mostly a matter of taking those defaults away: a sensor someone else owns, an evaluator written down, an invariant the actuator cannot cross, a bound that stops it, and a person at the end of the bound.

---

## 4 — Measured and Shown

Every figure below was read from the reference installation in which GAE was developed, at corpus commit `bac7817` (2026-11-02) and the database as loaded on 2026-11-02, unless a line gives another date, and gives the rule that reproduces it. The case study describes that installation.

**The build loop's predecessor (decision log, retrospective entry for April–June 2026).** Before the current pipeline, a compliance loop ran over the whole contract corpus for about six weeks. It checked 97 contracts against their implementations, caught 514 checks that passed without testing what they claimed to test, made 33 fixes in the source and added 2,260 checks. In one contract, the entire check suite turned out to be testing a stub: 53 checks were green and none of them reached the real code.

**A stricter sensor (completeness report, 2026-09-11).** The completeness gate was then made stricter: a value counts as consumed only when changing it changes the behaviour, and every normative statement must be mapped to a check. Measured that way, 22 of 132 contracts were complete on their governed values and 47 incomplete; 83 of the 97 contracts with an implementation scope had at least as many checks as normative statements, and none yet carried the map from statements to checks that the gate now requires. Raising the sensor's standard turned a corpus that the earlier loop had called healed into one with most of its work still ahead. No contract-driven unit has run under the current pipeline since.

**The build loop's inner rounds.** *(Step receipts of the units that passed the gate, by step and verdict.)* On the 31 units of work that have passed the gate, all of them task-driven, the 282 step receipts include 14 test reviews that found gaps in the checks, 3 code reviews that disproved the change, 1 failed implementation step and 2 baselines that were red before work began. Every one of the 31 units ended done or superseded.

**The memory loop.**
- 1,550 retro entries in the log since 2026-04-19, and 39 more from implementation sessions' reports. Of the 1,589, 567 name a pattern, under 224 distinct names. *(Entries in the database; names counted from each entry's list of names.)*
- 48 patterns carry a disposition: 23 a countermeasure, 20 accepted and 5 dormant. Every accepted record carries a re-review date, and four of the five dormant ones; the fifth is a placeholder for entries that name no pattern.
- Pattern triage has opened 22 work items for patterns at the threshold, 10 of them closed, and 5 for regressions, all closed. *(Work items by title.)*
- Until 2026-10-20 triage ran only when the architect ran it. Since then a sensor at every architect session start reads the patterns that stand at the threshold, or have regressed, without a work item, and runs triage when it finds one. Its first reading found 9; at the measuring point it found none. 12 patterns stand at the threshold without a disposition, each with an open triage item.

**A loop that has not converged.** The most frequent named pattern — taking a count or a claim on trust instead of measuring it — has 152 entries between 2026-09-24 and 2026-11-02. A countermeasure was put in place and closed on 2026-10-03; a regression item opened on 2026-10-13 counted 44 entries after it; the same day the pattern was accepted with a re-review date of 2026-11-12, and 18 entries have followed. It is among the learnings returned at the start of the session that wrote this version, and the session's own measurement file exists to counter it. The loop detects the pattern reliably. It has not yet found a countermeasure that makes it go away.

What these figures show is that the loops run, that their sensors find real problems — false-green checks, gaps in checks, changes that a verifier could disprove — and that the record is honest about the loop that is not converging. That last figure is the reason the memory loop has a regression rule at all.

---

## 5 — Where This Sits in the Field

Loops as a management tool are old. The plan–do–check–act cycle of quality management rests on the idea that quality is built into a process that measures itself, not inspected in at the end. GAE's loops are that cycle with the roles assigned: the check is owned by someone other than the doer, and the act is a change to the process, not only to the product.

Addy Osmani wrote about loop engineering in June 2026: designing the loop, he argued, replaces the person who prompts the agent, though it does not remove the person from the work. GAE agrees, and adds that a designed loop is also a small graph: a fixed sequence of typed steps with one back edge, a bound on how often that edge is taken, and an exit to a person.

Warp has described a scheduled improvement skill that gathers people's feedback on its agents' output, compares the agents' proposals with how people responded, and proposes a small change to the agents' own base skill, which then goes through ordinary pull-request review before it is merged. The memory loop does something similar with named patterns, with one difference in emphasis: the decision step is owned by a role, and the record says whether the change worked.

We have not checked whether the combination described here — the five named parts, a sensor out of the actuator's reach, regression as the loop's own evaluator — is formulated elsewhere, and this paper does not claim it is new.

**Sources.** Osmani, A. (2026-06-07). Loop Engineering. https://addyosmani.com/blog/loop-engineering/ · Segner, M. (2026-08-26), Claude blog post on Warp's agents, https://claude.com/blog/how-warp-builds-self-improving-agents-on-claude

---

## 6 — Limitations

- **The contract loop has not run under the current pipeline.** The build loop described in § 3 runs today only in its task-driven form, where acceptance criteria take the contract's place. The contract-driven form, with the completeness gate before and after, is defined but has not run since the pipeline was introduced. Its predecessor's figures in § 4 come from an earlier process with weaker definitions.
- **The completeness gate does not run at merge.** It runs when an agent calls it. The loop's final sensor is therefore not yet automatic.
- **The verifier's mutation probe is analytic.** It reads the checks and decides whether a mutation would be caught, rather than running the checks against a mutated copy.
- **Triage runs at the architect's session start, not between sessions.** A pattern can reach the threshold, or regress, and stand without a work item until the next such session.
- **A regression opens a new item.** The standard has the countermeasure's own item reopened; the tool opens a new one, and the architect reopens the countermeasure's item by hand in the same session.
- **The contract review loop has no bound in the reference installation yet.** An audit can be repeated until it approves. GAL now limits review rounds, and a contract that closes at the limit stays out of the canonical corpus until a full audit approves it; the starter kit binds the same for new installations.
- **Most retro entries name no pattern.** About a third of entries carry a name the loop can count. The rest are read only as text.
- **Outcomes are read without their conditions.** A change in a count is not separated from a change in the work that produced it.
- **Whether reading a learning changes behaviour is measured by nobody.** A metric exists that relates reads to later occurrences; no agent or tool reads it.
- **The most frequent pattern has not converged.** As shown in § 4.

---

## 7 — What Comes Next

- The first contract-driven unit under the current pipeline, with the completeness gate before and after, and the gate at merge.
- A mutation probe that runs the checks against a mutated copy, once an analytically "caught" mutation is shown to survive.
- A triage tool that reopens the countermeasure's own item, as the standard asks.
- A naming rule for patterns in the retro entry's own template, so that more entries can be counted.
- A countermeasure for the most frequent pattern that is measured by its occurrences after the re-review date.

---

## 8 — Map

- **The GAE overview** places loop engineering among the other parts of the framework.
- **The release:** the standards, the starter kit and the list of known issues, in the GAE repository:
  - GIP Standard: the contract loop and the task loop, their steps, limits and hard stops
  - GEM Standard: the retro entry, pattern names, triage, dispositions and regressions
  - GAL Standard: the retro entry at session close and the recall of learnings at decision points
  - Contract Standard: the completeness gate as a tool class
- **Related white papers:**
  - *Verification Architecture*, on the sensors and evaluators the loops use
  - *Spec-Governed Dispatch*, on how work enters the build loop
  - *Context, Coherence and Memory*, on the logs the memory loop reads
  - *Harness Engineering*, on the gates around the loops
  - *Case Study*, on the reference installation

---

*This document is part of the GAE documentation package. The standards it points to are the reference; where this paper and a standard differ, the standard holds.*
