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

This file lists what is known to be missing or wrong in the standards and the starter kit of this release, so that nothing is hidden by it. The standards are unchanged since `gae-standards-v0.1`; the starter kit's `ADOPTION.md` is at v0.8.

The items were found in two places: the reference installation, Runapp, and a second installation set up from this starter kit, in a domain where the agents' knowledge work is the deliverable and the product has no code. Both were set up by the framework's originator.

Each item says what is missing and the direction a fix takes. A direction is a proposal, not a rule. A rule enters a standard only through a new release, with a new version of that standard. Where a standard already carries part of a rule, the item names the standard and section and says only what is still missing. If you meet one of these in your own installation, or something not listed, report it as an issue in this repository.

## 1. Standards

### Truth Chain

- **A level has no declared scope.** The standard assumes one constitution at the top of a fixed order. An installation with two top documents of different scope, one for how the work is done and one for how the system is built, has had to say that neither stands above the other. That splits the chain in two. *Direction:* keep one order, and add a rule that a level applies only within the scope it declares and says nothing outside it. Every top document declares its scope.
- **The chain records what a statement rests on, not when.** A statement cannot be reproduced as it was read. *Direction:* every change of an entry's level and status is kept with its time; a statement carries the time its links were read; an optional validity period is set only from the source. The Registry Standard gets the same rule for governed values.
- **No relations between evidence entries.** Links run in one direction: implementation to contract, contract to registry and evidence, evidence to source. That one entry supports, contradicts or derives from another has no form. So two entries that appear to corroborate each other while resting on one study cannot be told apart. *Direction:* a closed set of relations between entries, and a rule that corroboration counts only across distinct sources. The structure built under the Truth Chain will be called a *governed evidence graph*; the term enters with this change.

### Contract

- **No type for the architecture contract.** The closed set of document types has no type for an installation's architecture contract, the contract that binds the standards and the instance appendix. The kit uses `contract`. `governance` is for the corpus's own standards, logs and process documents, and `framework` organises a set of contracts; neither says that a document binds the installation's standards and appendix and is reviewed against what is built. *Direction:* a type for it.
- **An empty implementation scope is allowed.** A contract whose rules govern something built may leave its implementation scope empty, and a completeness check then has nothing to count. *Direction:* such a contract names its implementation, or states why it does not.
- **The review basis for top documents is too narrow.** A full review of a constitution or an architecture contract reads the Contract Standard only. *Direction:* it also reads the Truth Chain's order and the instance appendix's intake.

### GEM

- **An outcome is read without its conditions.** The memory standard compares outcomes, but not the conditions each arose under, so a better result can be credited to a change when the circumstances made the difference. *Direction:* a rule that an outcome is read against the conditions it arose under, and that those conditions are stored with it.

### Handoff and Boundary

- **Carrying a handoff is not separated from deciding on it.** The standards assume the operator carries every handoff from one session to the next. A coding-agent platform can let one agent open the next agent's session with the handoff as its first message; the operator then confirms the decision in the new session but no longer carries the text. The standards do not say which of the two is the operator's role. *Direction:* transport and decision are separate in the Handoff and Boundary standards, and the decision stays with the operator.
- **The receiver's starting point is not in the handoff's metadata.** The metadata carries the giver's last durable write, but not the commit and branch the receiver should find, so the operator cannot compare it with the receiver's start receipt. *Direction:* the metadata carries both.

### GAL

- **How an agent puts a decision to the owner is only partly covered.** GAL §9.3 (Approved-change list governance, p. 3) requires that an attestation carries its material and one yes/no question. Nothing in GAL requires that a decision question states what a yes will lead to. The starter kit's procedure and its core template carry the rule; the standard does not. *Direction:* the requirement in GAL.
- **The agent split is not measured.** GAE divides work between agents by role. Whether a split beats one agent with modules, and how many tools an agent can hold before its choice of tool degrades, has not been measured. *Direction:* measure on fixed end-to-end cases before changing the split; merge tightly coupled agents first, and keep a split only where the merged version is measurably worse.

## 2. Starter kit

`ADOPTION.md` v0.8 runs the setup as eight checkpoints, starts with an architecture contract and a corpus design, carries a starting backlog, the contract flow, profile A's mirror and configuration, the language default and an upgrade step. The kit has templates for profile A's bootstrap file, configuration store and mirror; the database templates are for PostgreSQL only. What follows is still missing.

- **No template for the system overview.** Step 8 says what the overview shows, that it reads a view through a read-only connection and that the checkpoints' status is computed. The page is drawn by each installation; a template with fixed sections, design tokens and a data format, rendered by a script so that an agent fills data and never layout, has been designed and tried but is not in the kit.
- **The boundary between chat agents stands in text.** In profile A the database cannot tell one agent from another or from the owner, so a narrow write function limits what is written but not who writes it. The read connection holds the limit for an agent that only reads. *Direction to examine:* a connector per role, each with a database role that has only that role's write functions.
- **The measurement of test growth has no form.** Step 4 says a post's tests bind its acceptance criteria, not every observation, and orders assertions per acceptance criterion to be measured now and then. In the second installation the suite kept growing with the rule in place. What is missing is the measurement's form: what is counted, where it is recorded, how often, and what count shows the rule broken. *Direction:* that form, before anything more is specified.

## 3. Scale

Everything in this release has been measured with one installation per operator and one operator. Three tracks are open.

- **Autonomy.** A human checkpoint could become a mechanical gate or a sample once it has never changed an outcome. No log records how often the owner approved, changed or refused, so no checkpoint can be removed on evidence. *Direction:* log every confirmation with its outcome.
- **Parallel sessions and several operators.** Specification agents share one working copy and run in turn. That holds for one operator and is the bottleneck for several. *Direction:* the set of affected contracts computed from the dependency graph before work is routed; locks per cluster of dependencies instead of per working copy; decision rights per cluster.
- **Context.** The methods already keep state outside the context window, but the standards do not state that as a principle. Implementation sessions stop at a measured context limit; specification sessions in chat rely on the model's own estimate. *Direction:* context control as a stated principle, and the two limits described as what they are.

## 4. What this release has not shown

- **Adoption by someone other than the originator.** Both installations were set up by the person who developed the framework. That a team or an outside adopter can install GAE from the starter kit alone has not been shown.
- **The whitepapers** that explain the framework are not part of this release.
- **Use of the starter kit as a whole.** Each standard was reviewed adversarially when it changed, and the v0.1 release — the headers, the release tooling and this file — in two rounds. The starter kit at v0.8, its procedure and its templates, was reviewed adversarially against the standards before this release, and its database templates were tested on PostgreSQL 16. No installation has yet been set up from v0.8 from start to end.
