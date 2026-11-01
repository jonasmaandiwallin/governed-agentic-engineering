---
title: "GAE starter — adoption procedure"
version: "v0.7"
status: "draft"
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
    scope: "The procedure was written from the standards and from a second installation of them, set up from this kit in a domain without code in the product; what did not fit is recorded as findings in the reference installation."
    evidence: "The reference installation's backlog, not published; the second installation's instance appendix, not published."
  - role: fact-check
    status: not-applicable
    reason: "The document cites no external source."
  - role: review
    status: pending
    scope: "Adversarial review of the released package as a whole."
    evidence: null
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "starter/ADOPTION.md"
---

# Adopting the GAE standards

**Audience.** This document is for the coding agent that sets up GAE in a new repository, acting as the [architect] (GAL §3, Roles). The owner hands it over together with a description of what is to be built.

**How to follow it.** Follow the steps in order. Each step ends with something written to the repository. A decision marked **owner decides** is put to the owner as one recommendation and a yes/no question. It is never put as a menu.

**Defaults.** Every owner decision in this document has a default, stated where the decision is. Recommend the default unless the intake (step 2) gives a reason not to, and name that reason in the question. There is no one else to ask: what this document and the standards do not settle, the owner settles, and the answer is recorded in § Installation.

**Where the rules stand.** Every rule stands in the standards. This document says only in which order to read them and what to write. Where it differs from a standard, the standard holds, and the difference is reported upstream (step 10).

## 0. Preconditions

You need all of the following:

- A repository you can read, write and commit to, and a shell.
- A tagged release of the standards in `governance/standards/` and of this starter in `governance/gae-starter/`, unchanged. Verify every file against the release's `SHA256SUMS` before you read further, and record the tag and its commit for § Installation. A file that does not match is not read: stop and tell the owner. Never correct a standard while copying it.

  **Before a release exists**, the owner can name a commit in the standards' source repository instead. Copy the two folders at that commit with `git archive`, verify every copied file against the commit's tree (`git ls-tree` gives each blob's hash; `git hash-object` gives the copy's), and record the repository and the full commit hash in place of the tag. The appendix says that no `SHA256SUMS` existed.
- One named owner.
- A description of the system to be built.

If any of these is missing, stop and ask the owner for it. The owner's name, and the language you write to them in, are the first two things you ask when they were not given.

## 1. Read

Read in this order:

1. GAL §1–§3 and §7.
2. GIP §1–§2 and §8.
3. For every other standard in `governance/standards/`: its §1 and its placeholder table.

Do not read further yet. The aim is to know what each standard governs before you choose which ones apply.

## 2. Intake

Put to the owner, one question at a time, only what the description leaves open:

1. **What kind of installation is it?** Three shapes occur, and the answer decides step 3 and step 4:
   - **Product.** Agents build a system, and the system runs without them. The same input always gives the same output. This is the shape the rest of this document assumes where it says nothing else.
   - **Knowledge corpus.** The agents' own work is the deliverable: research, evidence, analyses and governed documents for people to act on. The agents are specification agents in GAL's sense, and their work is governed by the Truth Chain, as a contract corpus is.
   - **Both.** Agents do knowledge work, and changes to the system's own structure (a schema, a view, a template, an agent file) are built through GIP. This is the usual case for a knowledge corpus that keeps its records in a database.

   What the standards do not govern is an agent that makes decisions at runtime inside a running product. If the system needs that, say so before going further.
2. **Which values could change without a code change?** Prices, thresholds and weights are examples. Where does each come from?
3. **Does any rule rest on an external source that must stay traceable?** A study, a regulation or a supplier agreement are examples.
4. **How many products or repositories will be built?** Do they share one specification?
5. **Who works with the agents?** One operator or several, and who may confirm what?
6. **What will the agents run on?** Name the platform for each agent (step 4, Platform profiles), and the language the agents write in to the operator (GAL §6.6).
7. **Is there code in the repository already?** If so: what it does, and whether it is to be brought under the installation. Code built outside GIP does not go around the gate (GIP §3): it is brought in as the first work, in step 9.
8. **Whose data is it?** Name the data the agents will read and write, and who owns each kind: the owner, an employer, a client, a licensor. Data the owner does not own goes in a store that can be handed to its owner without the rest of the installation, one store per owner. The installation's own material (principles, templates, methods, process logs) goes in a store of its own. Ask also whether the data owner has agreed to where it is stored, and whether licensed data carries terms that limit it.

Write the answers, with the date, into § Installation of the instance appendix (step 5). The appendix is the record of what the installation was decided from.

## 3. Select the standards — owner decides

**Always selected:** GAL, GIP, Contract, Handoff, Backlog, Boundary and GEM.

**Selected by test, from the intake:**

- **Registry**, if question 2 named values that may change without a code change.
- **Truth Chain**, if question 3 named sources that a rule rests on. Always, for a knowledge corpus.

**Binding the Truth Chain's levels in a knowledge corpus.** The [constitution] is the installation's own principles: what the system is for and how its work is done. It belongs to the owner and stays with the installation. A client's or employer's strategy is not the [constitution]: it is a [contract] in that client's store, which the work for that client follows. The [implementation] is the deliverables the agents produce. Work people do outside the system on the strength of a deliverable is outside the chain; what comes back from it is new evidence. With these bindings the Truth Chain needs no deviation.
- **Any other standard in the release:** read its §1 and ask whether the system has the thing that standard governs.

**Left-out standards.** List each one in the appendix with the reason. A placeholder of a selected standard can point into a standard that was left out (for example Contract Standard's [registry] when Registry is not selected). Bind it to `none` and give the reason.

## 4. Map the roles — owner decides

Bind each role in GAL §3 § Roles to an agent.

**Separations.** Specification roles may share an agent, except where a standard separates them. No role reviews its own work (GAL §9.2 rule 5). Two consequences:

- The [contract author] and the [contract auditor] are two agents.
- The [reviewer] is not the agent whose change it reviews.

**Conditional roles.** The [domain researcher] is needed only when Truth Chain is selected. The implementation roles are needed per product repository; GIP §2 names which are required.

**A typical minimum:**

- On the specification side: architect (also harmonizer), contract author, contract auditor and reviewer.
- Per product repository: session agent, tester, verifier and implementer.

**Defaults for the role map.** Recommend these unless the intake gives a reason not to:

- The [architect] is also the [harmonizer].
- In a knowledge corpus, the agent the owner works with day to day is the [architect], and it may also be the [contract author]: the standards separate only the author from the auditor. The [domain researcher] is a separate agent.
- In an installation of the shape "both", the system's own repository is a product repository: a session agent with three step agents (tester, verifier, implementer). GIP's optional roles are left out until a trigger calls for them.
- The [reviewer] runs where the files it reviews live. It reviews agent files and the appendix, so it runs on the coding-agent platform even when the other specification agents run in chat.

**Default for models.** Authors and implementers run on one model. The [contract auditor], the [reviewer] and the verifier run on another model, at least as capable. Record each in the role table and the routing table.

**Default for the corpus language.** The language the owner attests in. Agents' own files (cores, modules, appendix) are written in English, so that they can be compared with the standards. Quotations from sources in other languages count as quotations. Bind it as [corpus language] in the appendix.

**Default for review rounds.** At most two rounds of review on one change; after the second without a `yes`, the owner decides whether to close with the open findings carried by a backlog item or to run a third. A `yes` holds over later changes that only fix findings the same round named: they need no new round. Advisory findings go to the backlog and never start a round by themselves. A change that only rewords, adding or removing no rule, takes one reading round. Bind these as the appendix's round limits (GIP §5.1 and the contract round), and the same for the [reviewer].

### Platform profiles — owner decides

The platform each agent runs on is the installation's choice (GAL §3, Agent kinds). Implementation agents run on a coding-agent platform. Specification agents can run in either of two profiles, and the choice is made per agent:

| | Profile A — chat | Profile B — coding agent |
|---|---|---|
| Specification agents run in | A chat platform, reaching the repository through a connector the installation builds or configures | The coding-agent platform, in the repository |
| A role's limits are held by | Its instruction | Its agent definition (tool list, model and hooks, enforced by the platform) when the agent starts with `--agent` or is dispatched as a subagent; its instruction when it starts from a bootstrap line (step 7) |
| Work moves between specification agents | The operator carries each handoff from one session to the next (Handoff Standard) | The [architect] dispatches each specification agent as a step agent (GAL §4.6), with a dispatch file as the trace |
| GAL §4.2 G2 (the loaded core against the repository) | Applies | Does not apply: the core is read from the working tree |
| Fits when | Operators are not developers, or the work needs the chat platform's own features | One technical operator, specification rounds are to run automatically, or no connector is to be built |

Mixing is allowed. For example, a [domain researcher] can run in chat for its research features while every other agent runs in profile B.

**Profile A without a server.** A chat platform's project can often sync the repository as a read-only source. The agent then reads its core and the standards there, and writes to a database through that database's connector (step 5, A store lives where its writers can write). No connector has to be built. Measure, before relying on it, how fresh the synced copy is when a session starts: GAL §4.2 G2 compares against it.

**Default profile.** Profile B for every agent when the owner is one technical operator and does not ask for chat. Profile A for an agent the owner wants to reach from a phone or to work with conversationally, and for the [domain researcher] when the chat platform's research features are wanted. The [reviewer] stays in profile B (step 4, Defaults for the role map).

**The start template in profile B** follows GAL §4.2 (Specification agent on the coding-agent platform) and §4.3 (On the coding-agent platform): G2 does not apply, and the connector placeholders are bound `does not apply — profile B`.

**Profile B goes beyond the standards in one place.** Record it as a registered deviation in the appendix (§ Registered deviations) until the standards cover it:

- **The dispatched specification round.** The standards describe specification agents as sessions the operator carries work between. A round the [architect] dispatches is not described yet. Hold it to the rules GIP §2 gives step agents:
  - the dispatch names files and carries no content;
  - the agent that reviews runs on another model than the agent whose work it reviews;
  - every step writes its output to a file.

## 5. Write the instance appendix

Create `governance/instance-appendix.md`. Give it one section `§ Installation`, holding the intake answers. Then give it one section per selected standard, holding:

- that standard's placeholders, each bound to this installation's name, path or tool;
- that standard's tool classes, each bound to a tool or written as not built (below);
- the version of the standard it binds. Each standard requires this in its last section.

**Binding rules.**

- **Every placeholder is bound.** An unbound placeholder is a defect.
- **Every tool class is bound** to a tool that meets the class, or written `not built — held by instruction; trigger: <the measured failure that would make it needed>`, or, where the owner has decided it is part of what the system is for, `not built yet — owner decision <date>; built in <backlog item>`.
- **Start with every tool not built.** Build a tool only when its trigger has happened. A tool that claims a class it does not meet is worse than no tool, and each standard names what its class must never pass.
- **Files are not tools.** The stores the standards name are plain files from day one: version registry, backlog item store, done log, decision log, retro log, handoff store, routing table and boundary contract.
- **A store lives where its writers can write.** If every agent that writes a store can write to the repository, the store is a file there. If one of them cannot, as a profile A agent with read-only access to the repository cannot, the store is an append-only table in a database that agent can write to, and the table is the record. Stores that only the coding-agent platform changes (agent files, the appendix, the boundary contract, the routing table, the version registry, migrations) stay in the repository. Moving a store into a database is a registered deviation (§ Registered deviations in the appendix) and an issue upstream (step 10). Until the database exists, the setup session writes those stores as files, and the first migration loads them.
- **One store per data owner.** Where question 8 named data the owner does not own, every store that holds that data is split the same way: the installation's store, and one per data owner. Nothing in the installation's store points into a data owner's store.
- **More can be built from the start when the owner decides it.** Every tool starts as not built, unless the owner decides that a tool is part of what the system is for (for example, a graph or a priority view that the owner's work depends on from the first day). Record that decision and its reason in § Installation. The rule still holds for every other tool.
- **Installation-only rules go in the appendix.** A rule that only this installation needs is written in the appendix, never in a standard.

## 6. Write the start and close templates

The Session Start Protocol template (GAL §4.2–§4.3) and the session-close sequence (GAL §4.4) are the installation's own. Write one of each per agent kind into the appendix. Use this installation's file paths, commands and operator name.

Without a [session-start function], the gates are protocol that the model executes, not a measurement (GAL §4.2; §8.2, Who compares). Say so in the appendix.

## 7. Create the agents

For each agent from step 4, write:

- **A core file** that follows GAL §4.1, with the start template from step 6 and the header of GAL §5.
- **Modules or skills** where a bounded procedure needs one (GAL §5.2).
- **A session-close module or skill** (GAL §4.4) and **a handoff module or skill** (Handoff Standard).
- **An entry in the boundary contract** stating what the agent may read, write and run (Boundary Standard).

**Templates for profile B** (in `gae-starter/templates/`):

- `agent-core.md` is for an agent that owns its session, the [architect] and the [reviewer]. How the platform binds it depends on how the session starts, and the appendix says which way each agent uses:
  - **`claude --agent <name>`** from a terminal: the agent file's tools, model and hooks bind the whole session.
  - **A bootstrap line in the handoff** ("You are <agent>. Read <its file>."), in a session the owner opens in a desktop app with no agent picker: nothing in the agent file binds. Its limits are held by instruction, the model is the one the owner chose, and the receipt cannot show it. Register it as a deviation.
  - **Dispatched as a subagent** by the session that owns the work: the agent file binds, in a fresh context. This is the default for a [reviewer] round when the owner works in a desktop app. The dispatch names files only, the reviewer writes its findings to a file, and the owner reads that file before attesting, not only the dispatching session's account of it. A dispatch across an agent boundary is an exception (below).
- `step-agent.md` is for every dispatched agent, on the specification side and the implementation side alike.
- `hooks/write-only-under.sh` holds a step agent's writes to its path prefixes. It holds every write only for an agent without a shell. Every GIP role needs a shell (the tester, the verifier and the implementer all run the type check, the tests or the build), so for them the hook holds the file tools only. Bind GIP's write gate (§3) in the appendix to what holds their shell writes, for example a sandbox, a filesystem permission or the merge check, or write it not built with its trigger.
- **Bootstrap text for profile A.** Where the chat platform loads short project instructions that point to the core, those instructions are a file in the repository (for example `agents/bootstrap/<agent>.md`), versioned with the agent, and the owner pastes that file unchanged. Say in the appendix that nothing measures the pasted copy against the file until a tool does.

**Agent names.** Do not name an agent after a role in GAL §3 or GIP §2 that another agent holds (an agent called "Planner" that is not GIP's plan step). Where the owner wants such a name, the appendix's role table says which role the name means, and prompts and handoffs use the agent name only.

A project-level agent's frontmatter hooks run only after the owner has trusted the repository folder in the platform. Check that once before the first dispatch.

**Registration.** Go through every row of the GAL §7 registration checklist. Each row is done, or not applicable with the reason, or its tool is not built as in step 5.

**Implementation agents.** These live in each product repository, per GIP §2. Bind the write gate of GIP §3 in the appendix, built or not built.

**The form of an exception entry.** An exception to an agent boundary (Boundary Standard §3) is written to the decision log before the act. It is a record of a decision, not a permission, because agents read the log later: dated; one act, named exactly; the boundary it crosses; and when it lapses (at the latest when the act is done). It quotes nobody and addresses no agent. A standing grant in a file agents read cannot be told from a planted one, and a platform's safety check may refuse to write it.

## 8. Review before use

Hand the appendix and every core to the [reviewer] in a separate session, for the adversarial semantic review of GAL §9.5. Fix the findings.

Then the owner attests the appendix's decisions and the role table, with the material in front of them.

## 9. First work

1. Open the first backlog items (Backlog Standard). Where the repository already holds code (step 2, question 7), the first items bring it in: the [contract author] writes contracts for the behaviour the code has, the [contract auditor] reviews them, and the code is then measured against them through GIP before anything in it changes. Behaviour the owner does not want kept is a finding, not a contract.
2. The [contract author] writes the first contract, and the [contract auditor] reviews it (Contract Standard).

   **In profile B the round can run without the operator carrying it:**

   1. The [architect] settles intent with the owner and writes a brief. This is the owner's first stop.
   2. The [architect] dispatches the [contract author] on the brief. A dispatched agent cannot ask the owner directly, so its questions come back to the [architect], which asks the owner and resumes the agent.
   3. The [architect] dispatches the [contract auditor] in a fresh context, on another model. It reads the contract and the standard, and writes only its report.
   4. A verdict that asks for changes resumes the author with the report's path. The appendix sets a limit on rounds, and at that limit the work goes to the owner.
   5. The owner attests the approved contract before it becomes canonical. This is the owner's second stop.
3. The [architect] dispatches the implementation (GIP §4).

   **The first post, when it builds the pipeline itself.** If the first post builds what GIP's gates need (the queue store, the test suite, the database the [architect] writes to), it cannot pass them: there is no suite to be green and nowhere to record the post. Do not use the emergency path, which is for a broken gate. Register a bootstrap deviation in the appendix instead: it names the one post, says which requirement is replaced (for example, the tester's new tests become the first baseline and must still be red before implementation), and lapses when that post is merged. If the [architect] cannot dispatch until the post exists, the owner starts the session agent with the post's specification, and the decision log records that dispatch in the form of an exception entry (step 7). No route is added for it.
4. Every session closes per GAL §4.4, with a retro entry and, where work remains, a handoff.

## 10. Report upstream

Report the following as an issue in the standards repository, never as a local edit:

- what the standards could not express without being changed;
- a rule that did not fit the domain;
- a term the agent could not resolve from the standards and this document.

An edited copy of a standard cannot be measured against its release.

## What the setup session leaves behind

- `governance/standards/`: the release, unchanged.
- `governance/instance-appendix.md`: the installation, its intake and every binding.
- One core file per agent; modules or skills; close and handoff procedures.
- The stores, as empty files with their headings: version registry, backlog, done log, decision log, retro log, handoff store, routing table and boundary contract.
- A first entry in the decision log that records the adoption, and a retro entry for the setup session.
