<!--
gae-public-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "KNOWN-ISSUES.md"
-->
# Known issues

This release, `gae-standards-v0.1`, publishes the standards and the starter kit as they stand. This file lists what is known to be missing or wrong in them, so that nothing is hidden by the release.

The items were found in two places: the reference installation, Runapp, and a second installation set up from this starter kit, in a domain where the agents' knowledge work is the deliverable and the product has no code. Both were set up by the framework's originator.

Each item says what is missing and the direction a fix takes. A direction is a proposal, not a rule. A rule enters a standard only through a new release, with a new version of that standard. If you meet one of these in your own installation, or something not listed, report it as an issue in this repository.

## 1. Standards

### Truth Chain

- **A level has no declared scope.** The standard assumes one constitution at the top of a fixed order. An installation with two top documents of different scope, one for how the work is done and one for how the system is built, has had to say that neither stands above the other. That splits the chain in two. *Direction:* keep one order, and add a rule that a level applies only within the scope it declares and says nothing outside it. Every top document declares its scope.
- **The chain records what a statement rests on, not when.** A statement cannot be reproduced as it was read. *Direction:* every change of an entry's level and status is kept with its time; a statement carries the time its links were read; an optional validity period is set only from the source. The Registry Standard gets the same rule for governed values.
- **No relations between evidence entries.** Links run in one direction: implementation to contract, contract to registry and evidence, evidence to source. That one entry supports, contradicts or derives from another has no form. So two entries that appear to corroborate each other while resting on one study cannot be told apart. *Direction:* a closed set of relations between entries, and a rule that corroboration counts only across distinct sources. The structure built under the Truth Chain will be called a *governed evidence graph*; the term enters with this change.

### Contract

- **No type for the architecture contract.** The closed set of document types has no type for an installation's architecture contract, the contract that binds the standards and the instance appendix. *Direction:* a type for it.
- **An empty implementation scope is allowed.** A contract whose rules govern something built may leave its implementation scope empty, and a completeness check then has nothing to count. *Direction:* such a contract names its implementation, or states why it does not.
- **The review basis for top documents is too narrow.** A full review of a constitution or an architecture contract reads the Contract Standard only. *Direction:* it also reads the Truth Chain's order and the instance appendix's intake.

### GEM

- **An outcome is read without its conditions.** The memory standard compares outcomes, but not the conditions each arose under, so a better result can be credited to a change when the circumstances made the difference. *Direction:* a rule that an outcome is read against the conditions it arose under, and that those conditions are stored with it.

### Handoff and Boundary

- **Carrying a handoff is not separated from deciding on it.** The standards assume the operator carries every handoff from one session to the next. A coding-agent platform can let one agent open the next agent's session with the handoff as its first message; the operator then confirms the decision in the new session but no longer carries the text. The standards do not say which of the two is the operator's role. *Direction:* transport and decision are separate in the Handoff and Boundary standards, and the decision stays with the operator.
- **The receiver's starting point is not in the handoff's metadata.** The metadata carries the giver's last durable write, but not the commit and branch the receiver should find, so the operator cannot compare it with the receiver's start receipt. *Direction:* the metadata carries both.

### GAL

- **No rules for how an agent asks the owner.** *Direction:* every line put to the owner for attestation is shown whole, and every decision question states what a yes will lead to. The same rules go into the starter kit's core templates.
- **The agent split is not measured.** GAE divides work between agents by role. Whether a split beats one agent with modules, and how many tools an agent can hold before its choice of tool degrades, has not been measured. *Direction:* measure on fixed end-to-end cases before changing the split; merge tightly coupled agents first, and keep a split only where the merged version is measurably worse.

## 2. Starter kit

What follows is not yet in `ADOPTION.md` v0.7 or the templates.

### The order of the setup

- **Contracts come too late.** The procedure goes from the instance appendix to the agents and the first work. Missing: the architecture contract first; a step that designs the corpus (domains and layers, one folder per domain, an index with a reading order); the owner's domain decisions written as the first contracts; and a template for the contract inventory.
- **Contracts and deliverables.** A contract says how something is produced; a deliverable is what is produced. Contracts live in git, also where the knowledge lives in a database.
- **No checkpoints.** The setup should run as a series of checkpoints, each with a visible result and an owner attestation, so that the owner can see that what is built is what was intended.
- **No starting backlog and no critical path.** The procedure says only "open the first backlog items". Missing: the kit's own starting backlog, and the rule that governance work is limited to the critical path to the first delivery. An advisory finding goes to the next change of the same surface; it never becomes an item of its own.

### The contract flow

- An appendix change that a contract rests on is merged before the contract.
- A factual error found after approval is corrected in one bounded extra round that the owner decides, limited to the changed lines.
- An architecture contract written after the build is reviewed against what was built before it becomes canonical.
- A governed value is created only after the contract that states it.
- In a knowledge corpus, three bindings of the Contract Standard need to be foreseen: who writes the audit record when the reviewer cannot reach git; what an empty evidence list at start means; and whether the layer can be bound to the data layer.

### Specification agents in chat (profile A)

- Steps for setting up the chat projects, and the order between the first post and the first chat session.
- A database connector's reach limited to the installation.
- Agent files, standards, contracts and the appendix mirrored to the installation's store by whole directory, read only from the mirror, with no repository sync in the chat projects, and a mirror check in the start receipt.
- A database connector in a chat app can cancel a write silently. Agents write text through narrow database functions, not raw updates.
- The bootstrap holds only what never changes. Everything that changes is configuration, written as data in the system layer through a narrow write function, and shown in the start receipt. A bootstrap check in the start receipt.
- No client or engagement names in the installation's own files.
- *Open:* in profile A the database cannot tell one agent from another or from the owner, so the boundary between chat agents stands in text only. A connector per role, with a database role that has only that role's write functions, is the direction to examine.

### Language

- The default in v0.7 binds the corpus language to the language the owner attests in. That is wrong. *Direction:* English across the governance surface; the language of a deliverable set per output contract; a quotation in another language marked `"…" [xx]` with its ISO 639-1 code. Language and other installation choices are bound in the appendix only, never in an agent module.

### The implementation side

- The first post's specification is read for open interpretations before it is dispatched.
- An implementer's interpretation where the specification is silent goes to the architect as a finding, instead of standing as a rule nobody decided.
- What the owner's review of a large bootstrap post consists of.
- A record still being written when a snapshot is taken.
- Identifiers without a fixed length.
- A change to what an agent runs or writes changes its entry in the boundary contract in the same change.
- A change to the reviewer's own files is reviewed by the architect in another session, with the owner confirming the intent.
- A test suite binds the acceptance criteria and invariants, not every observation from a review round.

### A system overview

- A live overview of the installation, reading through a read-only connection: what the system does for the owner, the agents, the flow and the checkpoints. It has been designed and tried, and is not yet a template.

## 3. Scale

Everything in this release has been measured with one installation per operator and one operator. Three tracks are open.

- **Autonomy.** A human checkpoint could become a mechanical gate or a sample once it has never changed an outcome. No log records how often the owner approved, changed or refused, so no checkpoint can be removed on evidence. *Direction:* log every confirmation with its outcome.
- **Parallel sessions and several operators.** Specification agents share one working copy and run in turn. That holds for one operator and is the bottleneck for several. *Direction:* the set of affected contracts computed from the dependency graph before work is routed; locks per cluster of dependencies instead of per working copy; decision rights per cluster.
- **Context.** The methods already keep state outside the context window, but the standards do not state that as a principle. Implementation sessions stop at a measured context limit; specification sessions in chat rely on the model's own estimate. *Direction:* context control as a stated principle, and the two limits described as what they are.

## 4. What this release has not shown

- **Adoption by someone other than the originator.** Both installations were set up by the person who developed the framework. That a team or an outside adopter can install GAE from the starter kit alone has not been shown.
- **The whitepapers** that explain the framework are not part of this release.
- **Review of the release as a whole.** Each standard was reviewed when it changed. The adversarial review of the released package as a whole is pending, as the `ai_disclosure` block in each document says.
