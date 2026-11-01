---
document_title: "Handoff Standard"
version: "v0.3"
status: "draft"
created: "2026-10-13"
last_updated: "2026-11-01"
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
path: "standards/handoff-standard.md"
---

# Handoff Standard

## 1. Purpose and scope

An agent session ends, and the next one starts with nothing but what it is given. A handoff that carries a claim nobody checked, a path nobody opened or a number worked out by hand passes the error on as an instruction, and the receiving session builds on it. This standard defines the handoff: the one message that carries work from one agent session to the next. It covers its form, the routes it may take, what it must and must not contain, what the producing agent checks before it is shown, what the receiving agent checks before it acts, the extra lines of a handoff to and from a reviewer, and what the tool that validates a handoff must guarantee.

The GAL standard owns when a handoff is produced (GAL §4.4, the session close) and the learnings line it carries (GAL §4.5). The GIP standard owns the dispatch of an implementation session and its report (GIP §4, §6). The Boundary Standard owns which agents may hand work to which, and requires the routes to stand in one list (Boundary Standard §4). The GEM standard owns the retro entry written before it. This standard owns the handoff itself.

Four properties follow:

- **One message, self-contained.** A handoff is one block the [operator] copies whole. The receiving session needs nothing else from the session that wrote it.
- **Addresses, not assertions.** A handoff names where a value stands — a file, a field, a line — so that the receiver can read it. It never asks the receiver to trust a value the sender read earlier.
- **Checked before it is shown.** The producer validates the handoff with the [handoff validator] before the [operator] sees it.
- **Checked before it is acted on.** The receiver confirms that the handoff is addressed to it, and that the state it assumes is the state that holds, before it changes anything.

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system whose agents hand work to each other |
| [operator] | The person who carries every handoff from one session to the next |
| [architect] | The agent that maintains the agents' instructions and tools (GAL §3) |
| [reviewer] | The agent that reviews another agent's work (GAL §1.2, row 4) |
| [agent identity] | The exact name each agent declares in its instructions, against which a handoff's target is checked |
| [routing table] | The one list of permitted routes, with the model and settings each route runs with |
| [handoff store] | The place every handoff is written before it is shown |
| [handoff module] | The part of an agent's instructions that produces its handoffs |
| [measurement rule] | The rule for entries a session states as not measured, and how the next session carries them |
| [backlog item] | As in the Backlog Standard |
| [handoff validator] | The tool of the class in §8 |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. Form

- A handoff is one fenced block. The [operator] copies it with one action.
- It opens with a metadata section for the [operator], which the receiving agent ignores except for the target. The section carries, each on a line of its own and each once:
  - the route: giver and target, the target written as its [agent identity];
  - the route's descriptor, where the [routing table] has several rows for the same giver and target;
  - the [backlog item] or items, and the date;
  - the last commit the giver made, as a hash with a short description;
  - the model and settings the target session runs with, as the [routing table] gives them for the route;
  - where the [operator] opens the target session;
  - the module or skill the target loads for the task, where it has more than one;
  - the learnings consulted (GAL §4.5).
- The first line after the metadata names the session: the [backlog item] and a short title. An implementation session's handoff opens with the bootstrap line its platform requires instead (GIP §4).
- Everything after that line is the start prompt (§4).
- Every handoff is written to the [handoff store] under a name of its own before it is shown (§5).

## 3. Routes

- The [routing table] is the one list of routes (Boundary Standard §4). Each row names the giver, the target, a descriptor where needed, what triggers the route, and the model and settings the target session runs with.
- A handoff whose route has no row in the [routing table] is not shown. The route is added first, by the [architect].
- The [routing table] names every [agent identity] exactly as the agent declares it.

## 4. The start prompt

### 4.1 What it contains

- What was done in the previous step, and the [backlog item] it belongs to.
- The paths the receiver reads: the brief, the documents, the findings — every path the task needs, and nothing it does not.
- The scope: what to do, and what not to do where the task could be read wider.
- **The state an order assumes.** A handoff that orders a state change — a promotion, a value change, a closure, a deletion — states what the target carries today (version, status, value), so that the receiver can confirm it (§6).
- A question the sender could not settle, marked as open, with what would settle it.

### 4.2 What it does not contain

- Process history. It carries decisions and outcomes, not the discussion that led to them.
- Content that stands in a file. It points to the file.
- Model and settings, which belong in the metadata (§2).
- **An assertion about a value a field carries.** It names the field and where it stands. A state-dependent observation carries the date and the place it was read: "on [date], [field] in [file] carried [value]".

## 5. Before it is shown — the producer

The producing agent checks, in the session that writes the handoff:

1. **Every path, field name, symbol and line number in the handoff was read in this session.** Not recalled, not taken from a sibling file, not carried from an earlier handoff. A value from a closed set is taken from the set with a tool, not from memory.
2. **Every derived number was computed with a tool in this session.** A statistic, a ratio, a count or a percentage that does not stand verbatim in a read source is computed, never worked out by hand.
3. **An order to correct something rests on the target's current content.** The producer reads the target today and confirms the defect persists. A dated snapshot — an archive, an earlier review — is not the current state.
4. **What is measured is kept apart from what is assumed.** An open question is marked as one.
5. **The work the handoff relies on is committed.** A change the receiver needs is in the last commit the handoff names, or the handoff says it is not.
6. **The handoff is written to the [handoff store] and validated by the [handoff validator].** It is shown only when the validator passes. When the validator cannot run, the producer says so in the handoff and checks the validator's rules by hand.

The [instance appendix] may add checks for particular routes.

## 6. Before it is acted on — the receiver

When a handoff reaches an agent:

1. **The target is checked.** The agent compares the target in the metadata with its own [agent identity]. On a mismatch it does no work and answers in the form the [instance appendix] names.
2. **The premises are checked, visibly.** Before work begins, the agent reads every field whose current state the handoff asserts, and states the result in its reply: each field, what the handoff says, what the field carries. On a mismatch it stops and reports to the sender. A check that does not appear in the reply was not made.
3. **A state-changing order is checked against its target.** Before a promotion, a value change, a closure or a deletion, the agent confirms the target is in the state the order assumes. If it is not, it does not act, and reports.

## 7. Handoffs to and from the reviewer

A handoff that sends work to the [reviewer], or returns its verdict, carries these lines in addition, each on a line of its own:

- **To the [reviewer]:**
  - the closure criterion the round is judged against, written out;
  - the path of the handoff's own file in the [handoff store];
  - in a round that answers earlier findings, each finding answered with its invariant, the test the [reviewer] runs and the test the producer ran, which are not the same; and the files changed outside the findings' scope;
  - the earlier round an observation is followed up from, where one is.
- **From the [reviewer]:**
  - the verdict on the closure criterion, in one of the forms the [instance appendix] names (yes, no, partial);
  - the path of the findings file, and the counts of findings by class;
  - the path of the handoff it answers.
- **Both directions:** the entries the [measurement rule] covers, each carried verbatim from the previous handoff, or closed by a result recorded where the [measurement rule] says.

## 8. Tool classes

The [instance appendix] binds the class to a tool.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [handoff validator] | Whether a handoff meets this standard's form and its route's required lines | The handoff file, the [routing table], every [agent identity], and the files the handoff names for its route | A target that is an exact [agent identity]; a route with a row in the [routing table], and the model and settings that row gives; a last commit that exists; every line §7 requires for the route present and consistent with the files it names; every inherited entry carried or closed. Every failure named, and the run fails | A handoff passed with a failure that was only printed; a route with no row passed; a setting the row does not give passed; a run over zero identities or zero routes reported as clean; an inherited entry dropped without a recorded result |

**Zero result.** A missing input, an empty input, or a count of zero where the input plainly holds entries is a hard failure, never a reported value.

## 9. The handoff module

Every agent that produces handoffs has a [handoff module] with six sections in fixed order:

1. **Handoff rule.** The unconditional requirement: every session that produces the agent's deliverable ends with a handoff. Absence of a handoff is a violation, whatever the reason.
2. **Trigger.** What makes the agent produce a handoff.
3. **Routing.** Each outcome mapped to its target, as an [agent identity] from the [routing table].
4. **Checklist.** The producer's checks (§5), including the learnings line (GAL §4.5) and the validator (§5, point 6).
5. **Must include.** The lines this agent's handoffs carry for their receivers (§7).
6. **Consequence.** A session that reaches its end without a handoff produces it as its final action.

No section is empty: a section with nothing of the agent's own points to this standard. Sections of the agent's own may follow the six. The module points to this standard for the handoff's form (§2); it never restates it.

## 10. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A tightened form applies to handoffs produced from the version that tightens it. A handoff written earlier is not revalidated, and a failure on it is not a defect in it.
