---
document_title: "GIP — Governed Implementation Pipeline"
version: "v0.5"
status: "draft"
created: "2026-09-29"
last_updated: "2026-11-02"
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
ai_disclosure:
  - role: drafting
    status: complete
    scope: "All prose, structure and wording."
    evidence: "The document text itself."
  - role: technical-analysis
    status: complete
    scope: "Each rule was written from the behaviour of the reference installation's agents and tools, read in their source, logs and database."
    evidence: "The reference installation's decision log and retro log, not published; its binding of this standard in its instance appendix."
  - role: fact-check
    status: not-applicable
    reason: "The standard cites no external source."
  - role: review
    status: pending
    scope: "Adversarial review of the released package as a whole."
    evidence: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "standards/gip-standard.md"
---

# GIP — Governed Implementation Pipeline

## 1. Purpose and prerequisites

The Governed Implementation Pipeline (GIP) ensures that what is built is what the [contract] says — complete, independently checked, never ahead of an unresolved specification — and that this can be proven afterwards. The way through is kept proportionate, so that no one has a reason to go around it.

GIP is the only way work reaches the implementation agents, as the Governed Agent Lifecycle (GAL) defines them (GAL §3, Agent kinds). It has two steps. In step 1 the [architect] dispatches the work (Code Dispatch Protocol, CDP). In step 2 the implementation agents build it, in one of two build loops: the Contract Implementation Loop (CIL) for work driven by a contract, and the Task Implementation Loop (TIL) for work without one.

**Scope.** GIP governs work that changes a product repository. Tools the [architect] writes for the governance system itself lie outside it and pass the architect's own gates.

**A product as paths.** A product is a repository, or a set of path prefixes in a repository that the [tool appendix] declares — for example where a schema and its templates share a repository with the governance files. Where it is a set of paths, every rule in this standard that names a product repository applies to those paths: the write gate refuses an agent's writes under them, the merge check checks every change under them, and a change outside them is not a change to the product. [task specification path] then lies outside the prefixes, so the [architect]'s commit of a task specification (§4.3) is not a write under the gate; and where this standard names the [architect]'s repository (§4.3, §7), it means the files of the same repository outside the prefixes. The [tool appendix] names, per product, its repository and, where it is paths, the prefixes.

**Prerequisite.** The contract loop requires contracts that can be measured. The values a contract governs stand in a [registry] and are referenced by key, and its invariants, enforcement rules and prohibitions — its *normative statements* — are stated so that the [completeness gate] can count whether the code consumes and tests them ([contract standard]). A contract that cannot be measured cannot be declared done by the contract loop; one that the completeness gate cannot read — a normative statement written as prose where the [contract standard] asks for a list — is reported as a finding (§7) and not built. Work without such a contract runs the task loop, where the task specification's acceptance criteria take the contract's place.

**Five properties.** Sections 2 to 7 each serve at least one of them. Section 8 collects what the [owner] decides and carries no rule of its own.

1. **The goal is the contract's content, not the passage through the process.** Work is done when the completeness gate finds the contract complete on the main branch, not when the tests are green (§6).
2. **The specification goes first.** A build never proceeds against a contract under dispute. A finding goes back to the specification side, and the contract is blocked until the finding is resolved (§7).
3. **Independence is the mechanism.** The agent that writes the checks does not read the code, the agent that reviews never runs on the implementer's model, and no agent reviews its own work. A boundary stated only in prose is not a boundary (§2).
4. **Proportionality.** Cost grows with the size and reach of a change, never by skipping a step. The answer to a heavy path is a cheaper way through the pipeline, not a wider exit (§3, §5).
5. **Proof.** Every state the queue shows was made by a reported run and can be checked afterwards. A state no one can check — a post set done by hand, a model known only from configuration, a green suite that ran no check — is a claim, not proof (§5.1, §6).

**Stops or detects.** Every gate states whether it stops the work or detects it afterwards. A gate the platform cannot enforce as a stop runs as detection, and the [tool appendix] states which form each gate has in [system]. What the [owner] decides is collected in §8.

**Tokens.** The hard stops RED-BASELINE and NEEDS-MANUAL-REVIEW (§5.1) are GIP's own tokens and are the same in every instance. The [finding token] (§7) is the instance's, named in the [tool appendix].

## 2. Roles

GAL §3 names the roles and why they exist. This section states what each implementation role may read, write and run. The concrete paths per agent stand in the [boundary contract]. The boundaries in the table, and the rules after it unless a rule says otherwise, are enforced by the platform — the agent's tool list and hooks (GAL §4.6, part 2).

| Role | Reads | Writes | Runs | Required in every product repository |
|---|---|---|---|---|
| Session agent | The task specification, the [contract], the queue post, the [learnings function], the step agents' reports | Nothing in the product's code or checks. The [queue] only through the [report path] | The full suite, version control (branch, staging of named files, commit, pull request, merge on the conditions in §5.1), and dispatch of the step agents | Yes |
| Planner | The [contract], the task specification, the code | Only its plan, at [plan path] | Nothing | No — the task specification states whether the planner runs (§4) |
| Tester | The [contract] or the acceptance criteria, and type declarations — whether a file is a type declaration is decided by its content, not its name. Never the code | Only checks, at [check path] | Only the type check and the test run of its own checks | Yes |
| Verifier | In test review: the [contract] and the checks, never the code. In code review: the change, the code, the checks and the [contract] | Nothing that remains. A mutation probe runs in a copy of the repository of its own, which is discarded | The checks, against the code and against each mutation; otherwise read-only commands | Yes |
| Implementer | The task specification, the [contract], the plan, the checks, the code | The product's code within its path, and for task work the paths the task specification names (§4.3, Paths) — configuration, continuous integration, migrations. Never the checks | Build and tests | Yes |
| Fixer | The failure output, the code | A minimal fix to the product's code | Build and tests | No — without a fixer, a build or test failure goes back to the implementer |

Rules that hold across the table:

- **Only the session agent dispatches, and only the session agent changes branch.** A step agent starts no other agent.
- **A dispatch routes; it never carries content.** It names the queue post, the task specification, the plan where there is one, the step and any earlier failure. A step agent reads its sources itself. Where the platform cannot inspect a dispatch, this rule is the step agent's check: a step agent that receives pre-read content — contract text, registry values — refuses the dispatch and records the refusal in its step receipt. The check then detects rather than stops, and the [tool appendix] states which form it has in [system].
- **The session agent never implements and never writes checks.** It reads, triages and dispatches.
- **Only the tester changes what a check asserts.** A fixer or an implementer that needs a check changed reports it; the session agent dispatches the tester.
- **The verifier never runs on the implementer's model.** The step receipt records the model that ran, as the platform reports it, so that the split is proven rather than claimed (§6). Where the platform cannot report it, the receipt records the model the agent is configured with, marked `configured` (GAL §6.5); the split is then claimed, not proven, and the [tool appendix] says so.
- **One agent fills one role.** A role may be filled by several agents, split by path — for example one implementer for modules and one for endpoints.

- **Every check is written by the tester**, from the [contract] or the acceptance criteria. No agent writes a check from what the code does: such a check freezes the code's behaviour, errors included.

## 3. The gate

No code reaches the main branch of a product repository without a queue post whose gate has passed (§4), with one exception that lapses at its merge: the first post, below. The rule holds for every session in the repository, whether dispatched or started by hand: the gate guards the repository, not the agents. The bypasses that made the gate necessary were work started beside the queue, not agents breaking a rule.

The gate stands at three places.

1. **Write gate — stops.** A hook in the product repository ([write gate]) refuses every write an agent makes, through the file tools and through the shell alike, unless the session has claimed a queue post with a passed gate. A write gate that watches only the file tools stops nothing while the agent has a shell. A session without a claimed post may read, not write.
2. **Merge check — stops, or detects where it cannot stop.** A required check on the pull request verifies that the change belongs to a queue post with a passed gate. It is the one point every change passes, changes made outside the agent platform included. Where the repository host cannot make the check required, the check runs as detection: it fails visibly, and the [architect]'s session start reports every commit on the main branch without a queue post. The [tool appendix] states which form the check has in [system].
3. **Emergency path — detects.** The gate can be bypassed, and every bypass leaves a trace (below).

**No write around the gate.** A product repository is written by a session in that repository, under its write gate. A tool that writes into a product repository from outside it — a server writing through its own clone, for example — is an opening in the gate and is never used for code. The [architect] writes task specifications in a product repository, never code.

**Emergency path.**

- **When:** only when the gate itself does not work — a gate tool is broken, the [queue] or the continuous integration is down, or production is broken and cannot wait. A small fix is not a reason. It goes the normal way, as a short task specification with one acceptance criterion (§4).
- **Who:** only the [owner].
- **Trace:** every use writes a line with its reason to the [bypass log]. The [architect]'s session start reports the bypasses since its last session.
- **Afterwards:** the work is always brought into GIP — a queue post, and review of what was already done — so that all code on the main branch has in the end passed through a build loop.

**The first post.** A first post that builds what the gate itself needs — the [queue], a runnable suite, the store the [architect] writes to — cannot pass the gate or a baseline (§5.1). It is not a use of the emergency path, which is for a gate that exists. The [tool appendix] names that one post, says what replaces each requirement it cannot meet — for example, the tester's new checks are the first baseline and are red before implementation — and records who dispatched it and where the dispatch is logged. Every step of §5 that can run, runs. The replacement lapses when the post is merged: the post is then entered in the [queue] with its merge commit, its receipts and the [tool appendix]'s record of what replaced each requirement, who dispatched it and where the dispatch is logged, so that the entry is told apart from a post whose gate passed. It is the one entry the [architect] makes without a passed gate (§6), and from then on the gate holds without exception. A second post never takes this path.

## 4. Step 1 — dispatch (Code Dispatch Protocol)

The [architect] runs dispatch, the Code Dispatch Protocol (CDP). Its output is a queue post: the only thing a session agent can build from. Only the architect adds posts to the [queue], and only with a passed gate (§6); the first post's entry (§3) is the one exception. The architect never writes instructions to a step agent; the dispatch goes to the session agent, which runs the build loop the post names.

### 4.1 Two entries, one path

- **Entry A — seeded.** The architect takes a backlog item and dispatches it.
- **Entry B — selected.** The [completeness gate] lists the contracts that are not yet complete, and the architect dispatches the next. A completeness run is a series of B entries. A contract whose change is not yet merged is never selected again: the gate reads the main branch, where an unmerged change still reads as missing.

Both entries run every step below. Entry B is not a shortcut: it has the same gate record, the same task specification and the same queue post as entry A.

A defect found by a scan, a review or a build is not dispatched from where it was found. It becomes a backlog item and reaches the code through entry A. Nothing reaches the code from a scan directly.

### 4.2 Before a contract is dispatched

For contract work, four checks come first, in this order. They apply to every contract whose values the code reads or whose rules it implements at run time; a pure reference contract that no code reads is not dispatched. A contract implemented before this pipeline is not exempt: the gate reaches it when entry B selects it.

1. **No open finding.** The contract carries no open [finding token]. A contract under dispute is not dispatched (§7).
2. **Registry sweep.** Every value the contract governs is read from the [registry] by key. A value stated inline beside its key, or a value that could change with a new finding and has no key, is fixed on the specification side before dispatch — never in the task specification.
3. **Completeness before.** The [completeness gate] measures what the code lacks against the contract. That measurement is the task's scope, whichever the entry. The task specification asks for the contract to be complete, never for a listed number of values to be wired: logic that already reads a value may still be wrong.
4. **Gate record.** A passed sweep is written as a [gate record]. A contract changed after its record is swept again and gets a new record.

A product repository may add its own checks of the contract before dispatch — for example that a presentation layer shows no raw signal. The [tool appendix] names them per repository. They run with point 2, and a failure is fixed on the specification side, as there.

### 4.3 The task specification

The architect writes the task specification and commits it before the queue post is added. It stands at [task specification path] in the product repository, unless writing it there would change what the build is measured against; then it stands in the architect's repository, and the [tool appendix] names the case.

Every task specification carries:

- **What drives it:** the [contract], or for task work the acceptance criteria (§4.4).
- **Backlog item:** the item the task serves. The session agent reads the [learnings function] by it (GAL §4.5).
- **Disposition** (contract work)**:** `new`, `covered` or `partial`, found by reading the code that owns the contract — never inferred from the contract's name. `partial` lists the gaps that remain.
- **What the system already knows:** what the target files already carry, and what the evidence, the archive, earlier backlog items and the [registry] hold on the question. Never empty; with no hit, it names where the architect searched, and "nothing found" is written only when every one of those places was searched. The specification asks its question openly; it never plants a hypothesis about the cause for the build to confirm.
- **Data verified:** every table and column the task reads or writes, found in the data store's migrations — or named as a prerequisite, or as a value that stays empty until it exists. A write that can repeat, such as a re-sync, lands on stable keys.
- **Call site:** for a new function, where and when the existing flow calls it, and one check that runs it through that flow. A function nothing calls is not delivered.
- **Siblings** (a defect)**:** the pattern the defect follows, and every other place in the code where it occurs, found by a search of the whole code. Each is fixed in the post. With no other place found, the specification names the search. Where the architect cannot search the product repository's code, the session agent runs the search when it claims the post, before step A, and records the list with the post, so that the list is fixed before anything is built; the [tool appendix] states which holds. A sibling found later in the build is reported (§7), never fixed in the post.
- **Checks affected:** the existing checks the change touches, and what must stay as it is.
- **Paths:** every path in the specification, read in the repository before it is written.
- **Planner:** whether the planner runs (§2).
- **Dependencies:** the tasks this one waits for. An order between this post and work outside the queue is written in the backlog items under the Wave Standard, where the post can be a node; it is never written in the queue.

A task specification is self-contained. Every gap and finding it acts on is written into it — file, function, current and required behaviour — never as a pointer to another file. A session agent that finds a pointer where a finding should be reports the specification as incomplete and does not start the post.

### 4.4 Task work

Work without a driving contract — tooling, continuous integration, data jobs in a product repository — runs the task loop. Its gate is the task specification itself:

- every acceptance criterion states its kind of check: an automated test for code, or a command with its expected outcome for configuration and operations;
- the specification is committed, and a [gate record] line names it;
- the queue post points to the specification instead of a contract.

A small fix goes this way too, as a short specification with one acceptance criterion. That is the cheap way through the pipeline, and it is why a small fix is never a reason for the emergency path (§3).

### 4.5 The queue post

A queue post names the task, its specification, its entry — contract or specification — and the build loop: the contract loop for a post with a driving contract, the task loop for a post with a specification. The session agent starts the loop the post names; it never chooses one.

Work that several contracts share — a [registry] value read by more than one of them — is dispatched once, in the task of the contract that owns it. The others are measured again after that task is merged.

The dispatch to the session agent follows the [handoff standard] and names the queue post. The question "was the protocol followed?" is not asked: a post without a passed gate does not exist. The first post (§3) is dispatched without a post, and its entry is made at its merge.

## 5. Step 2 — the build

Both loops run the same steps. **A** — the tester writes the checks. **A.5** — the verifier reviews the checks, without the code. **B** — the implementer makes them pass. **C** — the session agent's scoped check. **C.5** — the verifier tries to disprove the change. **D** — the full suite, the pull request and the merge. §5.2 and §5.3 state what each step does in each loop.

### 5.1 What every build shares

- **One post at a time.** A session agent builds one queue post at a time, on its own branch, to its own pull request (§4.5).
- **Baseline first.** Before anything changes, the full suite runs. Not green → RED-BASELINE, a hard stop: the post is not started. No failure is "pre-existing"; everything red later in the run was introduced by the run. A suite that runs no check is not a green baseline: a repository without a runnable suite runs no build loop until it has one, and the [tool appendix] names such repositories.
- **Isolation.** A step agent that writes works in its own isolated copy of the repository. Branches are changed by the session agent only (§2).
- **Step receipts.** Every step — A, A.5, B and C.5 — leaves a step receipt in the [queue] (GAL §6.5). A step agent does not end without it. When a step runs again, the latest receipt counts.
- **Both reviews, always.** The test review (A.5) and the code review (C.5) run in every build: in both loops, in every size lane, for every disposition. No lane skips a step.
- **Size lanes.** The change's size decides its lane: small, medium or large. A lane chooses the implementer's model, never the role or the steps. A large change → NEEDS-MANUAL-REVIEW, a hard stop. A predicted lane that the actual change exceeds moves up.
- **Limits.** A review runs no more rounds than the review-round limit; a gap it finds is closed in the same run — a gap in the checks by the tester, a gap in the code by the implementer. No pass within the limit → hard stop. A build or test failure goes back to the role that owns the failing file — the tester for a check, the fixer (or without one the implementer) for code — up to the retry limit; one failure more is a hard stop. The bounds of the size lanes, the review-round limit, the retry limit, the batch threshold and the context limit are calibration, not rule: their values stand in the [tool appendix].
- **Verdicts.** Every review ends with a verdict from its closed set, and the verdict in the step receipt is the gate: without it the post is not done. The number of findings per class and severity is recorded beside it, without free text. The counts never stop a run; they show where the checks keep falling short.
- **A crashed step runs again.** Its partial result is discarded. The session agent never substitutes its own review for a verifier's; a session that cannot run a pending review stops with the review pending.
- **Staging.** Only named files are staged — the changed code and the checks — never everything in the tree.
- **No escape hatches.** A skipped or pending check, a suppressed type error or a disabled lint rule in the change fails the build. The [tool appendix] lists the patterns.
- **Hard stops** end the post before any merge and go to the [owner]: RED-BASELINE, NEEDS-MANUAL-REVIEW, the review-round limit reached without a pass, a build or test failure beyond the retry limit, a missing prerequisite — one the task names, or the switch a reserved part is to be built behind (§5.2) — and the session's context limit. The owner decides whether the post continues, is split, or goes back to dispatch. At the review-round limit, and where the [tool appendix] allows it, the owner may instead accept the post with the open findings of that review carried — the verifier's findings in the step whose receipt carries the acceptance. Each is held by a backlog item, by its text or a pointer, and the item names the post, the step that found the finding and its class. The acceptance stands in that step's receipt beside the verifier's own verdict, which is never changed: the receipt keeps the verdict the verifier gave and adds the owner's acceptance, the reference of the decision that made it and who entered it. A [finding token] (§7) is never carried, and a post with an open [finding token] is not merged on an acceptance. A failing check is never carried — the full suite and continuous integration must still be green — and every other condition of the merge below holds unchanged. A finding stops its contract and goes to the [architect] (§7).
- **Merge.** The session agent merges when every condition holds: an approved step receipt for A, A.5, B and C.5 — or, for a review step, one whose verifier's verdict stands beside the owner's acceptance (Hard stops, above) — the full suite green, continuous integration green on the pull request, and no hard stop. No one else is asked (§8).
- **Runs in a row.** The [owner] can let a session agent take posts in a row without a word between them, once the most recent posts, as many as the batch threshold, ran with both reviews passing and continuous integration green. The owner sets the batch threshold. Any hard stop ends the series.

### 5.2 The contract loop (Contract Implementation Loop, CIL)

| Step | Who | What |
|---|---|---|
| 0 | Session agent | Baseline (§5.1). The [completeness gate] measures the contract again; the run works to that measurement. |
| A | Tester | Checks from the whole [contract] — every value, invariant, enforcement rule and prohibition. The check file is regenerated whole, never extended, and maps every normative statement of the contract to at least one check. A statement too ambiguous to check gets a [finding token] (§7), never a guessed check. Registry data in the checks is generated from the production [registry]; a sensitivity check overrides a value openly on top of it, never with a hand-written copy. A part of the contract marked reserved gets checks for both states of its switch. |
| A.5 | Verifier | Reviews the checks against the contract, without the code: the mapping complete in both directions, and no check missing, contradicting, weak or vacuous; each registry value shown to steer the result; no mock that makes a check green without the code being tested; every [finding token] justified. |
| A→B | Session agent | At least one check fails before the implementation starts. When every check passes — possible when the contract had only behaviour gaps — the verifier reviews the checks again with that result, before B. The session agent does not judge vacuity itself. |
| (plan) | Planner | When the task specification says so, a plan before B. |
| B | Implementer | Makes the checks pass without changing them. A reserved part is built inactive behind its switch. Where the contract does not say unambiguously how something is done, the implementer stops with a finding (§7) — it never guesses. |
| C | Session agent | Type check and the contract's checks, scoped. A failure goes to the fixer (§5.1). |
| C.5 | Verifier | Tries to disprove the change: against the contract, by mutation probes run against the checks in a discarded copy of the repository — a registry read replaced by its value, and a rule inverted — by a search for new code without a production caller, for hard-coded fallbacks of registry values and for escape hatches, by a search for a defect's pattern in every sibling the post lists (§4.3), and by confirming that the check file is unchanged since A→B. Then the drift review: for every contract whose checks run the changed code, affected or unaffected. Affected → deeper review, and the checks adjusted in this post, before it is done. |
| D | Session agent | Full suite, type check, the escape-hatch search on the whole change, branch, pull request, merge (§5.1). At every merge the [completeness gate] runs over all contracts; a contract that has lost completeness becomes a backlog item. |
| E | Session agent, or the [architect] | After the merge, the [completeness gate] on the contract. Complete → the merge is reported and the post is done (§6). Not complete → back into the loop, or a finding (§7). |

The [completeness gate] in steps D and E runs where it can read the [registry] and the code on the main branch — in the session agent's run, in continuous integration, or at the [architect]'s session start. Where it runs by someone other than the session agent, the post stays built until that run (§6), and the [tool appendix] states which holds.

### 5.3 The task loop (Task Implementation Loop, TIL)

The task loop is the contract loop with the task specification's acceptance criteria in the contract's place (§4.4). The frame in §5.1 holds unchanged.

- **A.** For a criterion about code, the tester writes an automated test from the criterion, without reading the code. For a criterion about configuration or operations, the check is the command and its expected outcome in the task specification.
- **A.5.** The verifier reviews every check — tests and commands — against its criterion.
- **B, C, D** as in the contract loop.
- **C.5.** The verifier reviews the change against the criteria, and for a defect searches its pattern in every sibling the post lists (§4.3). The drift review applies as in the contract loop: a task that touches code a contract's checks run is reviewed against that contract.
- **E.** After the merge, the session agent runs every command criterion on the main branch and reports its outcome; the automated tests are covered by continuous integration on the merge.
- **Done** when every criterion has a green check on the main branch. There is no completeness measurement, because there is no contract.

## 6. The queue as proof

The [queue] is proof, not a note. A post in it always means that the gate was passed, and a post that is done always means that a reported run made it so. The one exception is the first post's entry (§3), which carries the record of what replaced the gate; a second entry without a passed gate breaks this section.

- **Who writes.** Only the [architect] adds posts, and only with a passed gate (§4), or for the first post at its merge (§3). A session agent claims a post, reports a run, reports a finding and reports a merge, through the [report path] — nothing else. No session writes the queue by any other route.
- **The step receipts.** Every step of a build leaves its receipt with the post (§5.1). Each value in it is filled by whoever knows it: the platform names the agent and the model that ran, the agent's file gives its path and version, and the agent gives only its verdict (GAL §6.5). An owner's acceptance at the review-round limit stands beside that verdict and never replaces it (§5.1).
- **Built, then done.** A post whose loop is finished — an approved receipt for every step, the full suite green, the pull request open — is built, not done. It is done when a merge commit on the main branch with green continuous integration is reported and checked, and, for contract work, when the [completeness gate] finds the contract complete after the merge (§5.2, step E). A built post keeps its claim. Before a session agent claims a new post, it takes the built posts in its repository: it merges one whose conditions in §5.1 hold and reports the merge; one whose continuous integration failed goes back into its loop (§5.1, Limits); one whose continuous integration still runs is reported and left.
- **Who reports the merge.** The session agent, when the merge happens in its session. Otherwise the [architect], at its next session start, when the merge commit appears.
- **Nothing is set directly.** No one sets a post done, and a post is never done on local evidence. The first post's entry (§3) is made with its merge commit and its receipts, as a reported merge is. A claimed post whose session ended without a report — a post not built — goes back to the queue.
- **A stopped post.** A post stopped by a finding is blocked until its contract re-enters (§7). A post stopped by a hard stop waits for the [owner] (§5.1).

**At every session start the [architect] reports, as detection:** the reports not yet read; each change merged since its last session, read against its task specification — a deviation becomes a backlog item or a revert; the commits on the main branch without a queue post (§3); and the uses of the emergency path (§3).

## 7. Back to the specification side

The build never changes the specification. What it learns about the specification goes back as a report, and the specification side decides.

- **The report.** The session agent reports results, findings, status and its retro entry through the [report path]. It never writes in the [architect]'s repository. The architect reads the reports and enters what belongs in the logs.
- **Findings.** A statement the build cannot follow becomes a [finding token] of one of three types: *ambiguity* — the contract does not say unambiguously what to do — goes to the [contract author]; *suspected error* — a value or rule looks wrong — goes to the [domain researcher]; *missing key* — the contract needs a [registry] value that does not exist — goes to the [contract author], who adds the key through the process the [tool appendix] names for the [registry]. A finding blocks its contract, never the rest of the queue.
- **The specification goes first.** A build never proceeds against text under dispute. The order is: the specification is fixed, the [contract auditor] reviews it, it becomes the source of truth again, it gets a new [gate record], and the contract re-enters through entry A or B (§4).
- **"Out of scope" is not a verdict.** A build passes a normative statement in exactly three ways: a finding whose justification the verifier has reviewed; NEEDS-MANUAL-REVIEW to the [owner]; or an entry in the [exemption register], which the specification side owns and no build writes to.
- **What the build sees beside its post** — a defect outside the task, a gap in another contract — is reported, and the [architect] makes it a backlog item. It is never fixed in the post.

## 8. What the owner decides

A hard stop is the only thing in the pipeline that waits for the [owner]. Everything else runs on conditions a machine can check. This section collects the owner's decisions; each rule stands in the section it names.

- **Hard stops** (§5.1): whether the post continues, is split, or goes back to dispatch; at the review-round limit, where the [tool appendix] allows it, whether the post is accepted with the open findings of that review carried, never a [finding token].
- **The first post** (§3): which post builds what the gate needs, and what replaces each requirement it cannot meet, as the [tool appendix] records it.
- **The emergency path** (§3): only the owner uses it.
- **Runs in a row** (§5.1): the owner lets a session agent take posts in a row, and sets the batch threshold.
- **Not the owner's:** the merge, which the session agent makes on its conditions (§5.1); the choice of build loop, which the queue post makes (§4.5); the routing of a finding, which §7 makes.
