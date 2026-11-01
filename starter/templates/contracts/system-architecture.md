<!--
GAE starter — template for the architecture contract, the installation's first contract
(ADOPTION.md step 6, CP1). It is a contract, at level 2 of Truth Chain's order, below the
constitution. It says what the system is, points up to the standards and the instance
appendix, and down to the domain contracts.
Section order: Contract Standard §4.3. Replace every <...>. Keep a rule in the contract that
owns it: domain rules (data layers, evidence levels, a graph, a priority formula, a mandate)
belong in their own contracts, and this one names where they stand.
Delete this comment block when the file is filled in.

gae-template-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  template_version: "v0.2"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "starter/templates/contracts/system-architecture.md"
This license covers the template as published. The file you write from it is your own
and does not inherit the license; delete this comment block and the attribution goes
with it.
-->
---
document_title: "<title prefix>System Architecture"
document_type: "contract"
version: "v1.0"
status: "draft"
domain: "governance"
layer: "<layer the appendix binds for governance>"
priority: <the highest priority in the governance domain>
last_updated: "<YYYY-MM-DD>"
depends_on: []
referenced_by: []
overrides: []
superseded_by: null
evidence_ids: []
implementation_scope: [<the implementation units this contract governs: the governance stores, the mirror, the queue, the read connection>]
last_audit: {}
---

# <title prefix>System Architecture

## Purpose

<What the system does for the owner, in the owner's words, from the intake (ADOPTION.md step 2). One paragraph.>

This contract says how the system is built. What the system is for and how the work is done is the constitution's, which stands above this contract (Truth Chain §2.1).

## Scope

<What this contract governs: the system's structure, its stores, its agents and their boundaries, its corpus design and its checkpoints. What it does not govern, and which contract does.>

## Definitions

- **<Term>** — <definition>. <One per term the rules below use: store, layer, data owner, engagement, mirror, read connection, checkpoint.>

## Core Assertions

1. **Standards.** The system adopts the GAE standards <list, by name>, copied unchanged from a tagged release. The instance appendix `<path>` binds them and names the release and each standard's version (§ Source of the standards, § Standards); this contract restates neither. Moving to a new release is the owner's decision and changes the appendix. This contract gets a new version only on the triggers ADOPTION.md step 12 point 5 names: a changed standard body that one of its rules rests on, or a standard adopted or dropped.
2. **Layers.** <The layers (for example system and engagement) and which way a reference between them may run. Nothing in the system layer points into an engagement layer.>
3. **Stores.** <The store per layer and per data owner (ADOPTION.md step 5). Contracts live in git and are mirrored to the store at every merge.>
4. **Agents.** <Each agent, its role (GAL §3), its platform and profile, and its boundary by reference to the boundary contract `<path>`.>
5. **Read connection.** <The read-only connection to the system store, held by the database, named `<installation> System Overview`, and who uses it.>
6. **Corpus design.** <The taxonomy (domains, layers, allowed combinations), one folder per domain, the index with its reading order, and where an engagement's corpus stands.> The contract inventory is `<path>`.
7. **Checkpoints.** <CP0–CP7 with each one's result and condition (ADOPTION.md, The checkpoints). Their status is computed by the overview's view, which the instance appendix binds (§ Architecture contract and checkpoints).>
8. **Rules owned elsewhere.** <Each domain rule this contract does not own, and the contract that owns it.>

## Invariants

- Nothing is built before this contract is attested.
- Infrastructure is built only against the standards and this contract.
- Domain implementation is built only against its merged contract.
- <Further invariants of the system's structure.>

## Enforcement Rules

- <How each invariant is held: a gate, a database permission, a review. Where an invariant is held by instruction only, say so.>
- Anything built before its contract is listed here, one line per part, until its contract is merged and the part has been reviewed against it: <part → contract>.

## Prohibited Behavior

- <What the system must never do, for example: an engagement's material in the system store; a write to an engagement store through the system's connector.>

## Failure Modes

- <What happens when a part fails, for example: the mirror behind the repository; the read connection unavailable; a store unreachable.>

## Architectural Position

<Where this contract stands: a contract at level 2 of Truth Chain's order (§2.1), below the constitution, with the standards and the instance appendix binding it; the first contract of the governance domain, with no `depends_on` until the constitution exists and the constitution in `depends_on` from the version after; above the domain contracts that rest on it. A descriptive document written before this contract is history and points here.>
