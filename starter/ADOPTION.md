---
title: "GAE starter — adoption procedure"
version: "v0.17"
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
    status: complete
    scope: "Adversarial review of the starter kit at v0.8 in two rounds before its release; the changes in v0.9 in two more rounds, including the release check's commands run on a clean copy of the previous release; the database templates tested on PostgreSQL 16. The system overview templates of v0.10 tested on PostgreSQL 16 and in a browser engine and reviewed in two rounds; the changes in v0.11 reviewed with the standards they follow, in two rounds; the changes in v0.12 reviewed with the standards of gae-standards-v0.5, in two rounds."
    evidence: "The reference installation's review records, not published."
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "starter/ADOPTION.md"
---

# Adopting the GAE standards

**Audience.** This document is for the coding agent that sets up GAE in a new repository, acting as the [architect] (GAL §3, Roles). The owner hands it over together with a description of what is to be built.

**How to follow it.** Work in checkpoint order (§ The checkpoints). The steps are numbered by subject, not by order of work: the table's last column says which steps describe each checkpoint, and one step can serve two (step 8 writes the agents for CP2 and describes the overview for CP4). Within a checkpoint, take its steps in number order. Each step ends with something written to the repository. A decision marked **owner decides** is put to the owner as one recommendation and a yes/no question, never as a menu. The question carries its material (GAL §9.3, Approved-change list governance, p. 3) and says what a yes will lead to, so that a one-word answer is an informed one.

**Defaults.** Every owner decision in this document has a default, stated where the decision is. Recommend the default unless the intake (step 2) gives a reason not to, and name that reason in the question. There is no one else to ask: what this document and the standards do not settle, the owner settles, and the answer is recorded in § Installation.

**Where the rules stand.** Every rule stands in the standards. This document says in which order to read them and what to write. Where it differs from a standard, the standard holds, and the difference is reported upstream (step 13).

## The checkpoints

The setup runs as eight checkpoints. Each has a visible result and an owner attestation, so that the owner can see, at each stop, that what is being built is what was intended. No checkpoint starts before the one before it is attested. Between two checkpoints, only the critical path to the next one is worked (step 10, The critical path).

| Checkpoint | Result | Steps |
|---|---|---|
| **CP0 Intake** | Shape, domain, deliverables, data owners and platforms, on one page. The owner attests that this is what he wants. | 0–3 |
| **CP1 Architecture contract** | The installation's first contract, with the contract tree drawn. Reviewed by the [reviewer] and attested by the owner. Nothing is built before CP1. | 4–6 |
| **CP2 Infrastructure built** | Only what the standards and the architecture contract require. The governance stores and their write functions, the mirror, the queue and the read connection are built through GIP against the architecture contract. The agent files are written by the [architect] (step 8), outside GIP (GIP §1, Scope). | 7, 8, 10 |
| **CP3 Agents answer** | Every agent starts and shows a correct start receipt. The [contract auditor] runs a full review of the architecture contract. | 9 |
| **CP4 System overview live** | An overview of the installation reads the system through the read connection, and the checkpoints' status is computed, not written by hand. | 8 (The system overview) |
| **CP5 Domain contracts** | The constitution, then the governance and method contracts, each reviewed, attested and merged. | 11 |
| **CP6 Domain built** | The domain's schema and implementation, built through GIP against the merged contracts. The first output contract is written alongside. | 11 |
| **CP7 All systems go** | The first real deliverable, produced under the contracts, reviewed and attested. | 11 |

**Four rules hold across them:**

1. Nothing is built before an attested architecture contract (CP1).
2. Infrastructure is built only against the standards and the architecture contract.
3. Domain implementation is built only against its merged contract. Its backlog item depends on the contract's item, and its priority never goes ahead of the contract's.
4. Anything built before its contract is listed, one line per part (the part → the contract that is to carry it), reviewed against that contract when it exists, and where the two differ the contract governs. Nothing is torn down in advance.

Bind the checkpoints, with these definitions and their conditions, in the architecture contract (step 6).

## 0. Preconditions

You need all of the following:

- A repository you can read, write and commit to, and a shell.
- A tagged release of the standards in `governance/standards/` and of this starter in `governance/gae-starter/`, unchanged. Check the release before you read further and the copies after you make them (§ Checking a release, below), and record the tag and its commit in the appendix's § Source of the standards. A file that does not match is not read: stop and tell the owner. Never correct a standard while copying it. Read the release's `KNOWN-ISSUES.md` and tell the owner which items bear on the system.

  **Before a release exists**, the owner can name a commit in the standards' source repository instead. Copy the two folders at that commit with `git archive`, verify every copied file against the commit's tree (`git ls-tree` gives each blob's hash; `git hash-object` gives the copy's), and record the repository and the full commit hash in place of the tag. § Source of the standards says that no `SHA256SUMS` existed.
- One named owner.
- A description of the system to be built.

If any of these is missing, stop and ask the owner for it. The owner's name, and the language you write to them in, are the first two things you ask when they were not given.

**Checking a release.** `SHA256SUMS` lists every file of the release by its path in the release: `standards/…`, `starter/…` and `KNOWN-ISSUES.md`. The licence and the other files at the repository's root are not in it. The copies stand under other paths, so the check runs twice. The commands below are for a POSIX shell; the files they write (`installed.sums`, `listed.txt`, `present.txt`) are scratch, kept outside the repository or deleted after.

1. **The release, before anything is read.** From the root of the fetched tag, run `sha256sum -c SHA256SUMS` (on macOS, `shasum -a 256 -c SHA256SUMS`). Every line answers OK.
2. **The copies, after copying.** From the installation's root, map the paths and check the result:

   ```
   sed -n -e 's#  standards/#  governance/standards/#p' \
          -e 's#  starter/#  governance/gae-starter/#p' <release>/SHA256SUMS > installed.sums
   sha256sum -c installed.sums
   ```

   `sed -n … p` writes only the lines it mapped, so `KNOWN-ISSUES.md`, which is read and not copied, drops out. Every line of `installed.sums` answers OK. On macOS, the second command is `shasum -a 256 -c installed.sums`.
3. **What the check does not see, checked on its own.**
   - *An entry the release does not list.* The check reads only the listed files, so a file or a symbolic link added to either folder passes unseen, and a listed file replaced by a link to the same bytes passes the checksum. The release holds only regular files and directories. Compare the lists of regular files, then list everything else; both `diff` and the last `find` print nothing:

     ```
     cut -c67- installed.sums | sort > listed.txt
     find governance/standards governance/gae-starter -type f | sort > present.txt
     diff listed.txt present.txt
     find governance/standards governance/gae-starter ! -type f ! -type d
     ```

   - *A file's mode.* A checksum reads the bytes, not the mode. `templates/hooks/write-only-under.sh` is executable in the release, and the platform runs it as a command; `test -x governance/gae-starter/templates/hooks/write-only-under.sh` succeeds. `templates/database/mirror.sh` is run with `bash` and needs no mode.

Moving an installation to a later release is step 12.

## 1. Read

Read in this order:

1. GAL §1–§3 and §7.
2. GIP §1–§2 and §8.
3. For every other standard in `governance/standards/`: its §1 and its placeholder table.

Do not read further yet. The aim is to know what each standard governs before you choose which ones apply.

## 2. Intake — CP0

Put to the owner, one question at a time, only what the description leaves open:

1. **What kind of installation is it?** Three shapes occur, and the answer decides step 3 and step 4:
   - **Product.** Agents build a system, and the system runs without them. The same input always gives the same output. This is the shape the rest of this document assumes where it says nothing else.
   - **Knowledge corpus.** The agents' own work is the deliverable: research, evidence, analyses and governed documents for people to act on. The agents are specification agents in GAL's sense, and their work is governed by the Truth Chain, as a contract corpus is.
   - **Both.** Agents do knowledge work, and changes to the system's own structure (a schema, a view, a template) are built through GIP. Agent files are the [architect]'s own (step 8; GIP §1, Scope). This is the usual case for a knowledge corpus that keeps its records in a database.

   What the standards do not govern is an agent that makes decisions at runtime inside a running product. If the system needs that, say so before going further.
2. **Which values could change without a code change?** Prices, thresholds and weights are examples. Where does each come from?
3. **Does any rule rest on an external source that must stay traceable?** A study, a regulation or a supplier agreement are examples.
4. **How many products or repositories will be built?** Do they share one specification?
5. **Who works with the agents?** One operator or several, and who may confirm what?
6. **What will the agents run on, and in which languages?** Name the platform for each agent (step 4, Platform profiles), the language the agents write in to the operator (GAL §6.6), and the language each kind of deliverable is written in. The governance surface itself is written in English (step 4, Default for languages).
7. **Is there code in the repository already?** If so: what it does, and whether it is to be brought under the installation. Code built outside GIP does not go around the gate (GIP §3): it is brought in as the first work, in step 10.
8. **Whose data is it?** Name the data the agents will read and write, and who owns each kind: the owner, an employer, a client, a licensor. Data the owner does not own goes in a store that can be handed to its owner without the rest of the installation, one store per owner. The installation's own material (principles, templates, methods, process logs) goes in a store of its own. Ask also whether the data owner has agreed to where it is stored, and whether licensed data carries terms that limit it.

Write the answers, with the date, into § Installation of the instance appendix (step 5), and summarise them on one page: shape, domain, deliverables, data owners and platforms. **CP0** is the owner's attestation of that page.

## 3. Select the standards — owner decides

**Always selected:** GAL, GIP, Contract, Handoff, Backlog, Boundary and GEM.

**Selected by test, from the intake:**

- **Registry**, if question 2 named values that may change without a code change.
- **Truth Chain**, if question 3 named sources that a rule rests on. Always, for a knowledge corpus.

**Binding the Truth Chain's levels in a knowledge corpus.** The [constitution] is the installation's own principles: what the system is for and how its work is done. It belongs to the owner and stays with the installation. A client's or employer's strategy is not the [constitution]: it is a [contract] in that client's store, which the work for that client follows. The [implementation] is the deliverables the agents produce. Work people do outside the system on the strength of a deliverable is outside the chain; what comes back from it is new evidence. Truth Chain §1.1 and Registry §1.1 define [implementation] so for a knowledge corpus.
- **Any other standard in the release:** read its §1 and ask whether the system has the thing that standard governs.

**Left-out standards.** List each one in the appendix with the reason. A placeholder of a selected standard can point into a standard that was left out (for example Contract Standard's [registry] when Registry is not selected). Bind it to `none` and give the reason.

## 4. Map the roles — owner decides

Bind each role in GAL §3 § Roles to an agent.

**Separations.** Specification roles may share an agent, except where a standard separates them. No role reviews its own work (GAL §9.2 rule 5). Two consequences:

- The [contract author] and the [contract auditor] are two agents.
- The [reviewer] is not the agent whose change it reviews. A change to the [reviewer]'s own files is reviewed under GAL §9.3 (Approved-change list governance, p. 4); write the table to a path the agent that writes the change can reach.

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

**Default for languages.** The whole governance surface is written in English: agent files, standards, the appendix, the contract corpus (constitution, system and engagement contracts) and decision entries, rule text included. Mixed-language instructions are followed measurably worse than one-language ones; an instruction in another language inside an English context reads as a quotation, not an order. The owner attests the English text as written, never a translation of a text already attested.

- The language towards the operator is free and is asked at intake (GAL §6.6).
- The language of a deliverable is set per output contract.
- Wording in another language that is data, not a rule (a brand phrase, a quotation from a source), stands as a marked quotation: in straight double quotes followed by its ISO 639-1 code in brackets, `"…" [xx]`. The [reviewer]'s language check counts any other text in another language as a finding. Contract §7.3 exempts the marked quotation.
- An installation that writes its corpus in another language does so as an explicit owner decision, with this paragraph put to the owner. It then binds its modal verbs (MUST, MUST NOT, SHOULD, MAY), a glossary from each term to its identifier in code, and an id per normative rule that tests and code refer to.
- Bind [corpus language] and the quotation form in the appendix. Language and every other installation choice is bound in the appendix only, never in an agent file: an agent file reads the binding, never the value.

**Default for review rounds.** Bind these as the appendix's round limits (GIP §5.1 and the contract round), and the same for the [reviewer]. Four of them are the round rules of GAL §9.7: closing a change the [reviewer] reviews with open advisory findings at the round limit, the `yes` that holds over fixes, the reading round, and the bounded round for a factual error. Closing a GIP post with open advisory findings (GIP §5.1) and the advisory finding routed to its surface (Backlog §4.2) are options of the standards; take them by binding them in the appendix.

- At most two rounds of review on one change. After the second without a `yes`, the owner decides whether to close with the open advisory findings carried by a backlog item or to run a third. A blocking finding is never carried: while one is open after the second round, the owner decides after each round whether to run another or to withdraw the change. For a GIP post this is the acceptance of GIP §5.1: only the review's own advisory findings are carried, each by an item that names the post, the step and the class; the verifier's verdict stays in the receipt beside the acceptance; and a [finding token] is never carried. A contract is the exception: it does not become canonical without an approving full audit of its current version (Contract §8.4), so closing a contract round means it stays out of the canonical corpus.
- A `yes` holds over later changes that only fix findings the same round named: they need no new round.
- An advisory finding never starts a round and never becomes a backlog item of its own, once the search of Backlog §4.1 has found no item, open or closed, that carries it. It is held by an open item that collects advisory findings for that surface (the same file or contract), or by the open item that next changes it, provided no order for that change has been written yet — and is taken there (Backlog §4.2). Bind the class and the collecting items in the appendix; the order for a change of a surface reads them when it is written, and they are in its frozen scope (Handoff §5 p. 7); the item that makes a change without an order reads them when it takes up the change. An advisory finding that an order's own review leaves open is held by the order's follow-up item (next point), never by a collecting item and never by a later part of that order.
- Every order whose reviews can leave findings open names its follow-up item when it is written, with the order's closure as its trigger (Backlog §4.2, An order and its follow-up item). A finding in what the order has delivered is fixed in the round that found it, and a blocking one is never carried; what lies outside the order's frozen scope, and an advisory finding a round closed with under the stop rule, at the round limit or in a reading round, goes to the follow-up item. Nothing goes into a later part of the order (GAL §4.7.2).
- A change that only rewords, adding or removing no rule, takes one reading round, which still answers Q1 and Q2 of GAL §9.5 (GAL §9.7 p. 3). The reading round closes the change: an advisory finding it leaves open goes to the follow-up item and needs no further round; a blocking one is fixed and reviewed again. A reading round that finds a rule, gate or check added or removed gives a blocking finding, and the change takes the full rounds.
- A factual error found after approval (a statement that does not match what is built) is corrected before canonical in one bounded extra round that the owner decides. The round covers only the changed places and what depends on them, the owner attests the new lines before it, and it does not count as a third round, because it does not reopen the text.
- A post's tests bind its acceptance criteria and invariants, not every observation from a review. A verifier mutation that survives where the specification is silent goes to the [architect] as a specification question, not into a new test.

**Measuring test growth.** A rule in text does not hold a test suite back on its own: in the second installation the suite kept growing with the rule above in place. So the rule is measured, at every merge of a post:

1. **Each test names what it binds.** A post's specification gives each acceptance criterion and invariant an id (for example `AC-3`). Each test carries the id it binds in its name or in a comment on the line before it, in the form the appendix binds, so that a search finds it.
2. **The verifier counts, per post:** the criteria and invariants in the specification; the assertions added, per id; and the tests added that carry no id.
3. **The counts are recorded** in the post's report, at the [report path], and the appendix names the line.
4. **The rule is broken when** a merged post adds a test that carries no id, or adds assertions to an id whose criterion the post did not change. Either is a finding to the [architect], which names the gap in the specification the test closes or has the test removed.

Bind the id form and the report line in the appendix. The rest of the suite's history is read from the reports, so nothing else is kept.

### Platform profiles — owner decides

The platform each agent runs on is the installation's choice (GAL §3, Agent kinds). Implementation agents run on a coding-agent platform. Specification agents can run in either of two profiles, and the choice is made per agent:

| | Profile A — chat | Profile B — coding agent |
|---|---|---|
| Specification agents run in | A chat platform, reaching the installation's store through a connector | The coding-agent platform, in the repository |
| A role's limits are held by | Its instruction, and the database where a write function holds it | Its agent definition (tool list, model and hooks, enforced by the platform) when the agent starts with `--agent` or is dispatched as a subagent; its instruction when it starts from a bootstrap line (step 8) |
| Work moves between specification agents | The operator carries each handoff from one session to the next (Handoff Standard) | The [architect] dispatches each specification agent as a step agent (GAL §4.6), with a dispatch file as the trace |
| GAL §4.2 G2 (the loaded core against the repository) | Applies, against the mirror | Does not apply: the core is read from the working tree |
| Fits when | Operators are not developers, or the work needs the chat platform's own features | One technical operator, specification rounds are to run automatically, or no connector is to be built |

Mixing is allowed. For example, a [domain researcher] can run in chat for its research features while every other agent runs in profile B.

**Profile A reads from a mirror, never from a repository sync.** A chat platform's repository sync is not refreshed at session start, and the platform often reads synced files only in excerpts, so a core is assembled from fragments and an old copy is read after a merge. Instead:

1. At every merge, every directory a profile A agent may need is mirrored whole to the installation's store: the agent files of both platforms, the copied standards and this starter, the contracts, the appendix, the boundary contract and the routing table. Mirror by directory, never by a list of files, so that a new governance file comes with it.
2. Profile A agents read governance files only from the mirror. A file missing there stops the agent, which says so instead of reading another copy.
3. The chat projects have no repository sync.
4. The core compares, at start, the mirror's commit with the latest merge in the version registry, and reports `mirror current` or `mirror behind (<commit>)` on the start receipt's `Gates:` line. The receipt's labels are fixed (GAL §6.2 p. 5), so the check takes no label of its own.

The mirror is built from `templates/database/mirror.sql` (the tables, a status view and the one write function, which checks every file's sha256 against its bytes and writes nothing if one fails) and `templates/database/mirror.sh` (the statement, built from git at the merged commit for the directories the appendix binds), run by a job at every merge. Both are for PostgreSQL; on another database, keep what they hold: by directory, whole, checked, in one transaction.

Until the mirror exists, a rule holds: whoever has not read a file whole states the rule and what it is to achieve, and whoever reads the file whole chooses the place and reports it.

**Default profile.** Profile B for every agent when the owner is one technical operator and does not ask for chat. Profile A for an agent the owner wants to reach from a phone or to work with conversationally, and for the [domain researcher] when the chat platform's research features are wanted. The [reviewer] stays in profile B (Defaults for the role map).

**The start template in profile B** follows GAL §4.2 (Specification agent on the coding-agent platform) and §4.3 (On the coding-agent platform): G2 does not apply, and the connector placeholders are bound `does not apply — profile B`.

**Profile B goes beyond the standards in one place.** Record it as a registered deviation in the appendix (§ Registered deviations) until the standards cover it:

- **The dispatched specification round.** The standards describe specification agents as sessions the operator carries work between. A round the [architect] dispatches is not described yet. Hold it to the rules GIP §2 gives step agents:
  - the dispatch names files and carries no content;
  - the agent that reviews runs on another model than the agent whose work it reviews;
  - every step writes its output to a file.

## 5. Write the instance appendix

Create `governance/instance-appendix.md` from `templates/instance-appendix.md`. Give it one section `§ Installation`, holding the intake answers. Then give it one section per selected standard, holding:

- that standard's placeholders, each bound to this installation's name, path or tool;
- that standard's tool classes, each bound to a tool that meets the class or written as not built (below);
- the version of the standard it binds. Each standard requires this in its last section.

The appendix also points to the architecture contract (step 6) once it exists.

**Binding rules.**

- **Every placeholder is bound.** An unbound placeholder is a defect.
- **Every tool class is bound** to a tool that meets the class, or written `not built — held by instruction; trigger: <the measured failure that would make it needed>`, or, where the owner has decided it is part of what the system is for, `not built yet — owner decision <date>; built in <backlog item>`.
- **Start with every tool not built.** Build a tool only when its trigger has happened. A tool that claims a class it does not meet is worse than no tool, and each standard names what its class must never pass.
- **More can be built from the start when the owner decides it.** A tool the owner decides is part of what the system is for (for example, a graph or a priority view that the owner's work depends on from the first day) is built from the start. Record that decision and its reason in § Installation. The rule still holds for every other tool.
- **Files are not tools.** The stores the standards name are plain files from day one: version registry, backlog item store, done log, decision log, retro log, handoff store, routing table and boundary contract.
- **A store lives where its writers can write.** If every agent that writes a store can write to the repository, the store is a file there. If one of them cannot, as a profile A agent cannot, the store is an append-only table in a database that agent can write to, and the table is the record. Stores that only the coding-agent platform changes (agent files, the appendix, the boundary contract, the routing table, the version registry, migrations) stay in the repository. Moving a store into a database is a registered deviation (§ Registered deviations in the appendix) and an issue upstream (step 13).
- **Contracts live in git**, also where the knowledge lives in a database. A governing document changes seldom, is versioned, reviewed as a diff and attested. The installation's contracts are in its repository; an engagement's contracts are in a repository of their own per data owner, which goes with that owner's store when it is handed over. Each is mirrored to the store at every merge and read whole from there. The file is the record (Truth Chain §4.3), so no deviation is needed. Contracts are written through the coding-agent platform, never through the database path.
- **A governed value is created after the contract that states it** (Registry §4.1). A value loaded at setup, before its contract, gets the contract as its source in a new entry once the contract is merged.
- **Agents write text through narrow functions.** A profile A agent writes to the database through functions that take one row or one column and append where they can, never through raw `UPDATE` or `DELETE`. A database connector in a chat app may review a statement before running it, misread it (a `;` inside a text value read as a statement without `WHERE`) and cancel it without a prompt. An encoding that gets past such a review exists only as a registered, time-limited deviation, and never as dynamic SQL.
- **Configuration is data in the system store, never a migration.** What can change about the installation — the overview's address, the engagements' store references, the tools each agent expects — is configuration. Its schema is a migration; its installation-specific rows are written as data in the system store only, through a narrow write function that takes only the keys the appendix binds and the id of the owner decision behind each value. Only values that are the same in every store and owned by the system may come from a migration. A row that widens what an agent may reach is always an owner decision, and every agent's start receipt shows the values it read, so a widening is seen at the next start. Who writes the rows stands in the boundary contract; rows needed before that right exists are written through a recorded exception (Boundary Standard §3). The schema is in `templates/database/configuration.sql`: an append-only table, so that every earlier value stays readable with its time and decision, a view with the current value per key, and the write function. The table's owner and a superuser can pass the append-only trigger, so the tables are owned by a migration role that no agent and no connector runs as; the appendix binds it.
- **One store per data owner.** Where question 8 named data the owner does not own, every store that holds that data is split the same way: the installation's store, and one per data owner. Nothing in the installation's store points into a data owner's store. The installation's files name no engagement, no client and no client's store: they refer to one by reference only (`<engagement store>, ref <ref>`), and the concrete names live in the owner's own copies (the pasted project instructions).
- **Until the database exists**, the setup session writes the stores as files, and the first migration loads them. A record still being written at the import is written again in the database after the deploy: from then on the database row is the record and the file is frozen.
- **Identifiers have no fixed length.** An identifier format names a minimum number of digits, never an exact one.
- **Installation-only rules go in the appendix.** A rule that only this installation needs is written in the appendix, never in a standard.

**Rules ahead of the standards.** This document gives some rules that its standards do not yet carry. Each one the installation uses is a registered deviation: an entry in the appendix's § Registered deviations that names the rule, the standard and section it goes beyond, and the item in the release's `KNOWN-ISSUES.md` that carries it upstream. A registered deviation is not a pass (GAL §9.2 rule 2); it says where the installation knowingly differs, until a release of the standard carries the rule.

| Rule | Step | Goes beyond |
|---|---|---|
| The dispatched specification round in profile B | 4 | Handoff Standard §1.1, where the [operator] carries every handoff; GAL §4.6, where a step agent does a step of a build loop for a session agent |
| A store kept as an append-only table in a database | 5 | Backlog §1 and §6, Registry §5, Truth Chain §4 and GEM §2.1, where the file is the record |

A bootstrap-line start in profile B (step 8) is registered too, but as a departure from the installation's own binding of profile B, not from a standard: no standard requires the platform to hold the limits of an agent that owns its session.

## 6. The architecture contract — CP1

The architecture contract is the installation's first contract, written first because everything built rests on it. It is a contract, so it stands at level 2 of Truth Chain's order, below the constitution (Truth Chain §2.1). It says what the system is, and it points up to the standards and the appendix and down to the domain contracts. Without it, a descriptive document fills the role without being a contract, and the system is built against a text nobody reviewed. Write it from `templates/contracts/system-architecture.md` to `contracts/governance/system-architecture.md` (or the path the corpus design below gives it).

It stands on the standards and the intake, and depends on no other contract until the constitution exists. It holds:

- the system's purpose in the owner's words (from the intake);
- which GAE standards are adopted, and that the appendix binds them. The release and the versions stand in the appendix only (§ Source of the standards, § Standards), so that an upgrade changes the appendix and not this contract (step 12);
- the layers and which way references between them may run, and the store per layer and data owner;
- the agents, with roles, platforms and boundaries (by reference to the boundary contract);
- the read connection (step 8);
- **the corpus design** (below);
- the checkpoints, with the definitions above and their conditions;
- which rules other contracts own. Domain rules (data layers, evidence levels, a graph, a priority formula, a mandate) are not here but in their own contracts.

It says how the system is built. The constitution, written later (step 11), says what the system is for and how the work is done, and stands above it: a contract that conflicts with the constitution is invalid until the constitution is changed (Truth Chain §2.3). So the constitution is written against the attested architecture contract, a conflict between them is settled in the same round by changing one of the two, and the next version of the architecture contract depends on the constitution.

**Design the corpus.** Before the first domain contract, the architecture contract draws the corpus:

- a taxonomy: domains, layers and which combinations are allowed;
- a folder per domain;
- an index with a reading order;
- where an engagement's corpus stands (its own repository, step 5);
- the **contract inventory**, from `templates/contract-inventory.md`: governance (constitution, data layers, mandate), method (evidence levels, research method, evidence graph, priority), output (a common spine, one contract per deliverable surface, and one for the presentation form the visual ones point to) and engagement (strategy, brand, market). Strike and add; the order follows `depends_on`, not the list.

**Contracts and deliverables.** A contract says how something is produced and what it must meet. A deliverable is produced under it, stored as knowledge and reviewed against it. A brief or an analysis is a deliverable, not a contract. Three levels: the installation's contracts (for every engagement), an engagement's premises (strategy, brand, constraints: contracts in the engagement's store), and the work itself (in the engagement's database).

**Review and attest.** At CP1 no [contract auditor] has started yet. The architecture contract is reviewed by the [reviewer] and attested by the owner; the [contract auditor]'s first job at CP3 is a full review of it, which closes the bootstrap. A first overview may be drawn from the contract (step 8, The system overview), so that the owner can answer "is this the system you had in mind?" before anything is built.

**An architecture contract written after the build** — in an installation that built first, and at every later version — is reviewed against what is built before it becomes canonical, by an agent that can read the repository and the store. Its statements about the system (which code exists, which connections) are checked there. Where the contract and the build differ, rule 4 of the checkpoints applies.

## 7. Write the start and close templates

The Session Start Protocol template (GAL §4.2–§4.3) and the session-close sequence (GAL §4.4) are the installation's own. Write one of each per agent kind into the appendix. Use this installation's file paths, commands and operator name.

Without a [session-start function], the gates are protocol that the model executes, not a measurement (GAL §4.2; §8.2, Who compares). Say so in the appendix.

**Profile A's start template** also carries:

- the mirror check (step 4), reported on the `Gates:` line;
- reading the installation's configuration (step 5), with the values read in the receipt and an expected tool that is missing flagged;
- the bootstrap check (step 8), reported on the `Gates:` line.

**Every core** carries the rule on putting a decision to the owner: the material in the same message, one recommendation, a yes/no question, and what a yes leads to (How to follow it, above).

## 8. Create the agents

For each agent from step 4, write:

- **A core file** that follows GAL §4.1, with the start template from step 7 and the header of GAL §5.
- **Modules or skills** where a bounded procedure needs one (GAL §5.2).
- **A session-close module or skill** (GAL §4.4) and **a handoff module or skill** (Handoff Standard).
- **An entry in the boundary contract** stating what the agent may read, write and run (Boundary Standard). The Boundary Standard requires an entry before an agent first runs and keeps a retired agent's entry, marked as retired (§2), and changes a boundary by changing the entry (§3). That the entry changes in the same change as the agent's reach is this kit's rule, not the standard's. If the installation has a skeleton check, the boundary contract is among its inputs. From setup, the boundary contract also carries the standing rule for an upgrade (step 12), with its exception in every place that repeats the prohibition.

**Templates for profile B** (in `gae-starter/templates/`):

- `agent-core.md` is for an agent that owns its session, the [architect] and the [reviewer]. How the platform binds it depends on how the session starts, and the appendix says which way each agent uses:
  - **`claude --agent <name>`** from a terminal: the agent file's tools, model and hooks bind the whole session.
  - **A bootstrap line in the handoff** ("You are <agent>. Read <its file>."), in a session the owner opens in a desktop app with no agent picker: nothing in the agent file binds. Its limits are held by instruction, the model is the one the owner chose, and the receipt cannot show it. Register it as a deviation.
  - **Dispatched as a subagent** by the session that owns the work: the agent file binds, in a fresh context. This is the default for a [reviewer] round when the owner works in a desktop app. The dispatch names files only, the reviewer writes its findings to a file, and the owner reads that file before attesting, not only the dispatching session's account of it. A dispatch across an agent boundary is an exception (below).
- `step-agent.md` is for every dispatched agent, on the specification side and the implementation side alike.
- `hooks/write-only-under.sh` holds a step agent's writes to its path prefixes. It holds every write only for an agent without a shell. Every GIP role needs a shell (the tester, the verifier and the implementer all run the type check, the tests or the build), so for them the hook holds the file tools only. Bind GIP's write gate (§3) in the appendix to what holds their shell writes, for example a sandbox, a filesystem permission or the merge check, or write it not built with its trigger.

**Bootstrap text for profile A.** The chat platform's project instructions are a file in the repository (`agents/bootstrap/<agent>.md`, from `templates/bootstrap.md`), versioned with the agent. It holds only what never changes:

- the agent's identity;
- the query that fetches the core from the installation's store, with the system store's reference (the only reference that must be known before the core is read), and the line that halts if the fetch fails;
- a boundary that never needs updating: "only the system store and the engagement stores listed in the installation's configuration; never any other project". The list itself is configuration (step 5), not bootstrap text.

Everything that can change — the overview's address, the engagements' references, the tools the agent expects — is configuration, read by the core at start. The core compares, at start, the bootstrap it was started with against the bootstrap file in the mirror and reports `bootstrap current` or `bootstrap differs (<version>)` on its receipt's `Gates:` line, so the owner never compares texts. The bootstrap file in the repository carries placeholders for the data owners' stores; the owner fills them in the pasted copy. A bootstrap changes only when the system store moves.

**Connectors in profile A.** Limit a database connector to the installation's projects where the platform allows it. Where it does not, the start protocol compares the target project against the appendix's reference.

**The read connection.** Add a connector to the installation's database that (1) only reads, held by the database (a user without write rights), not by the caller's code; (2) is limited to the system store, reaching no engagement store; (3) has database tools only. Name it `<installation> System Overview`. The overview (below) and any agent that only reads — the [contract auditor], for example — use it, so that their limit is held by the database.

**The system overview.** A page that shows the installation: what it does for the owner (in the owner's words), the deliverables, the agents and where they run, the corpus structure, the stores, the main flows, how each GAE standard acts in this system, and the checkpoints with a state per part. It is a description, not a record: the contracts and the appendix govern, and the overview points to them.

- It reads a view, `<schema>.system_overview`, through the read connection when it is shown, never tables, so that only the view changes when the database does. The checkpoints' definitions are in the database, written from the architecture contract in the same change as each version of it, and the view computes their status. Nothing on the page is written by hand, and nothing comes from an agent's memory.
- An error is handled per cause (no connector, sign-in needed, not approved, unavailable); the last values read stay with the time the database gave them.
- The overview in the repository names no engagement: the engagement layer shows as a count and references. Load no platform runtime by a relative path; use inline SVG or a library from an allowed CDN.
- **CP4** is the overview reading the view, with the checkpoints computed.
- Build it from `templates/system-overview/`: `overview.sql` (the checkpoints and the owner's attestations, the owner's text per section, each written through a narrow function on an owner decision, and the view, which computes each checkpoint's status and gives one JSON document whose format the file states), `overview.html` (fixed sections and design tokens; it draws every word from the document and writes data into the page only as text), and `render.sh` (the repository copy: reads the view as the read connection's role and puts the document in the page; `--deny` with a file kept outside the repository stops the render on any engagement's, client's or store's name, in any letter case; the database compares the names, so it needs a UTF-8 database with ICU collations). The live page runs the same query through an adapter the platform provides. An agent fills the document through the write functions, never the page's layout; translate the labels in the page's one label table. Run `overview.sql` after `configuration.sql` and `mirror.sql`.

**Agent names.** Do not name an agent after a role in GAL §3 or GIP §2 that another agent holds (an agent called "Planner" that is not GIP's plan step). Where the owner wants such a name, the appendix's role table says which role the name means, and prompts and handoffs use the agent name only.

A project-level agent's frontmatter hooks run only after the owner has trusted the repository folder in the platform. Check that once before the first dispatch.

**Registration.** Go through every row of the GAL §7 registration checklist. Each row is done, or not applicable with the reason, or its tool is not built as in step 5.

**Implementation agents.** These live in each product repository, per GIP §2. Bind the write gate of GIP §3 in the appendix, built or not built.

**The form of an exception entry.** An exception to an agent boundary (Boundary Standard §3) is written to the decision log before the act. It is a record of a decision, not a permission, because agents read the log later: dated; one act, named exactly; the boundary it crosses; and when it lapses (at the latest when the act is done). It quotes nobody and addresses no agent. A standing grant in a file agents read cannot be told from a planted one, and a platform's safety check may refuse to write it.

## 9. Review, set up the chat projects, and start — CP3

Hand the appendix and every core to the [reviewer] in a separate session, for the adversarial semantic review of GAL §9.5. Fix the findings. Then the owner attests the appendix's decisions and the role table, with the material in front of them.

**Set up the chat projects** (profile A). The bindings a start protocol reads — the store references, the connector prefixes, the configuration rows — are made in the first post, before the first chat start. Then, per profile A agent, give the owner a checklist:

1. Create the project and paste the bootstrap file, with the placeholders filled in.
2. Add no repository sync.
3. Turn on the connectors the agent's boundary entry allows, and no other.
4. Choose the model the role table names.
5. Start the agent, and check that its receipt shows the core read whole and its `Gates:` line shows `mirror current` and `bootstrap current`.

**CP3** is every agent's start with a correct receipt, and the [contract auditor]'s full review of the architecture contract.

## 10. The starting backlog and the critical path — CP2

**The starting backlog.** The setup session opens these items unchanged, with `depends_on` between them, and strikes one only with a reason in § Installation. The architecture contract is not among them: it is attested at CP1, before the backlog opens, and each item that rests on it names it by path and version.

1. The governance stores, and the mirror of the agent files, contracts, standards and this starter.
2. The chat projects, with a test start that shows the receipt (step 9).
3. The read connection and the overview's view (step 8).
4. The constitution, then the domain contracts in the inventory's `depends_on` order (step 11).
5. Governed values, each from its contract (step 5).
6. The measurements the setup left open (for example the connector's reach and the licence terms).

A deliverable produced before the contract for its surface is merged is marked *before contract* and cites no contract version. That keeps a departure from the order visible instead of forbidden, so the owner can choose to deliver anyway. Truth Chain §2.3 names the case.

**The critical path.** Governance work is limited to the critical path to the next checkpoint and, after CP5, to the first deliverable: the contract infrastructure and the domain contracts that delivery needs. Triage the backlog at each checkpoint: what is done is closed, advisory findings go to their surface or to their order's follow-up item, never into the order they came from (step 4), the rest is parked. Without this, a review that yields four or five advisory findings per change, each becoming an item, grows the backlog faster than it closes.

**The first posts.**

1. Where the repository already holds code (step 2, question 7), the first items bring it in: the [contract author] writes contracts for the behaviour the code has, the [contract auditor] reviews them, and the code is then measured against them through GIP before anything in it changes. Behaviour the owner does not want kept is a finding, not a contract.
2. Before the first post is dispatched, read its specification for open interpretations — a format as rule or description, a template verbatim or runnable — and settle them in the text, because no [architect] can answer during the bootstrap.
3. An implementer's interpretation where the specification is silent goes to the [architect] as a finding and becomes part of the specification or a contract. It never stands as an implementation detail nobody decided.
4. **The first post, when it builds the pipeline itself.** If the first post builds what GIP's gates need (the queue store, the test suite, the database the [architect] writes to), it cannot pass them: there is no suite to be green and nowhere to record the post. Do not use the emergency path, which is for a broken gate. Take GIP §3's first post instead: the appendix names the one post, says what replaces each requirement it cannot meet (for example, the tester's new tests become the first baseline and must still be red before implementation), and records who dispatched it and where the dispatch is logged. The replacement lapses when that post is merged, and the post is entered in the queue with its merge commit, its receipts and that record. If the [architect] cannot dispatch until the post exists, the owner starts the session agent with the post's specification, and the decision log records that dispatch in the form of an exception entry (step 8). No route is added for it.
5. The owner's review of a large bootstrap post is not a reading of its lines. It is a reading of the implementer's interpretations, the steps' receipts and the verifier's mutation results.

**CP2** is the infrastructure built through GIP against the standards and the architecture contract, and the agent files written (step 8).

## 11. Domain contracts, the domain, and the first deliverable — CP5 to CP7

**CP5.** The owner's domain decisions from the intake and the description become contracts, the constitution first, in the inventory's `depends_on` order. From then on the description is history and the contracts govern. In profile B the round can run without the operator carrying it:

1. The [architect] settles intent with the owner and writes a brief. This is the owner's first stop.
2. The [architect] dispatches the [contract author] on the brief. A dispatched agent cannot ask the owner directly, so its questions come back to the [architect], which asks the owner and resumes the agent.
3. The [architect] dispatches the [contract auditor] in a fresh context, on another model. It reads the contract and the standard, and writes only its report.
4. A verdict that asks for changes resumes the author with the report's path. The appendix sets a limit on rounds, and at that limit the work goes to the owner.
5. The owner attests the approved contract before it becomes canonical. This is the owner's second stop.

**Order between the appendix and a contract.** An appendix change that a contract rests on — a section a contract may leave out, a reference form, a priority in the taxonomy — goes as a governance change merged before the contract. Prohibitions that stand with the rules they bound (Contract §4.1) and a reference by a unique, indexed key (Contract §4.10) are bound in the appendix in the same change. The contract's change has that merge as a premise. Appendix changes never ride along in a contract's change.

**In a knowledge corpus**, three bindings of the Contract Standard are settled in the appendix before the first domain contract:

- **Who writes `last_audit`** when the reviewer cannot reach git: the agent that writes the repository, from the review report in the store, in the same commit. Contract §8.4 allows it.
- **An empty `evidence_ids` at start:** the contract says in its text what it rests on (owner decisions, with dates), so that empty is not read as no basis; the ids are added in a new version when the sources are registered.
- **`layer`**, where the installation binds it to the data layer (system or engagement) instead of a content axis. Record the binding and whether the Contract Standard's text allows it.

**CP6.** The domain's schema and implementation are built through GIP against the merged contracts, and the completeness check decides when it is done. The first output contract is written alongside.

**CP7.** The first real deliverable is produced under the contracts, reviewed against them and attested by the owner.

Every session closes per GAL §4.4, with a retro entry and, where work remains, a handoff.

## 12. Moving to a new release

The copies in `governance/standards/` and `governance/gae-starter/` are never edited, so the agent that writes the repository may not touch them by its boundary entry. An upgrade needs one write that this forbids: replacing both folders with a release's files.

**The standing rule comes first.** The boundary contract carries one standing rule for that write: the agent that writes the repository may replace both folders with a tagged release's files, byte-identical, at an owner decision that names the tag, and only when the release check passes (step 0, Checking a release). Written at setup with the boundary contract (step 8), it is in force before the first upgrade. An installation that lacks it merges it in a change of its own before the upgrade begins. Written on the upgrade's own branch, it is not in force when the copy is made, and the owner's decision has to be recorded as an exception after all.

**Every place that repeats the prohibition** carries the rule's exception, in the same change as the rule: the boundary contract's entry for that agent, any machine-readable declaration of write areas that a hook or a check reads, and the agent's own core where it restates what it may not write. A place left out still forbids the write. An installation that merged the standing rule without these exceptions merges them in a change of its own before the upgrade, as it would the rule.

Then:

1. The owner decides the upgrade, naming the tag, and the decision log records it.
2. Fetch the tag, never a branch, and run the release check on it before reading (step 0, Checking a release, point 1). Read its `KNOWN-ISSUES.md`.
3. For each standard, compare its body with the copy installed. A body that is unchanged moves only the version. A changed body is read against every binding of that standard in the appendix, against the registered deviations, and against the architecture contract.
4. Replace the two folders, and check the copies (step 0, Checking a release, points 2 and 3).
5. In the same change as the copies, update every place that binds the release or a version, found by a search of the repository for the old tag and its commit, never from memory: the appendix (`binds_release`, § Source of the standards, § Standards) and any other file the appendix lists as binding one. The architecture contract names no version (step 6), so an upgrade does not change it. It changes only when point 3 finds a changed body that one of its rules rests on, or when a standard is adopted or dropped. That change is a contract change with its own review and attestation, merged after the upgrade, because it rests on the new copies (step 11, Order between the appendix and a contract); the decision log names it as pending until it is merged. An architecture contract that still lists versions moves them to the appendix in its next version.
6. Mirror the result, and record the upgrade in the decision log with each changed file's old and new version.
7. Report what did not fit as an issue upstream (step 13).

## 13. Report upstream

Report the following as an issue in the standards repository, never as a local edit:

- what the standards could not express without being changed;
- a rule that did not fit the domain;
- a term the agent could not resolve from the standards and this document.

An edited copy of a standard cannot be measured against its release.

## What the setup session leaves behind

- `governance/standards/` and `governance/gae-starter/`: the release, unchanged.
- `governance/instance-appendix.md`: the installation, its intake and every binding.
- `contracts/governance/system-architecture.md`, attested at CP1, and the contract inventory.
- One core file per agent; modules or skills; close and handoff procedures; a bootstrap file per profile A agent.
- For profile A: the configuration store and the mirror, with the job that runs the mirror at every merge.
- The stores, as empty files with their headings or as tables: version registry, backlog, done log, decision log, retro log, handoff store, routing table and boundary contract.
- The starting backlog, opened (step 10).
- The chat projects set up, each with a test start (step 9).
- A first entry in the decision log that records the adoption, and a retro entry for the setup session.
