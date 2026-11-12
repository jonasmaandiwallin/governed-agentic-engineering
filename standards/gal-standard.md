---
document_title: "GAL Standard (Governed Agent Lifecycle)"
version: "v1.82"
status: "draft"
created: "2026-09-11"
last_updated: "2026-11-12"
author: "Tooling & Architecture"
supersedes: "dpal-standard v1.0 (archived), dpal-standard v2.0 (name change)"
framework:
  name: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
editor: "Jonas Maandi Wallin"
contact: "https://www.linkedin.com/in/jonasmaandiwallin"
author_llm:
  - model: "Claude Opus 5"
    roles: [drafting, technical-analysis]
    source: handoff
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
path: "standards/gal-standard.md"
---

# GAL Standard (Governed Agent Lifecycle)

## 1. Purpose and Position

GAL is the standard for how a [system] agent is built, started, verified, and closed. A new agent is constructed by following this standard. Existing agents are harmonized against it.

Most practice governs the agents that write code. GAL governs the agents that write the specification with the same rigour. In a contract-driven architecture the [contract] is the source of truth, and it is the specification the implementation is built from — an error in the specification is implemented faithfully, however well the implementation is governed. GAL is an answer to how specification work can be done agent-driven and deterministically: two kinds of agent (§3), one lifecycle.

### 1.1 Hierarchy

```
GAE — Governed Agentic Engineering                    (public tier)
│
├── GAL — Governed Agent Lifecycle                    (this standard: how an agent is built, started, verified and closed)
│   ├── Two kinds of agent (§3)
│   │   ├── Specification agent (Tier 1)              core + modules
│   │   └── Implementation agent (Tier 2)             core + skills
│   ├── Core skeleton + registration                  (how an agent is built)              → req 1
│   ├── DPAL — Deterministic Prompt Assembly & Linking (how a core and its extensions are linked) → req 1
│   ├── Session receipt                                (how a session start is proven)      → req 2
│   ├── Session close                                  (how a session end is proven)        → req 2, 5
│   └── Harmonization                                  (how existing agents are measured)   → req 3
│
├── GIP — Governed Implementation Pipeline            (sibling: how work reaches the implementation agents)
│   ├── CDP — Code Dispatch Protocol                  (step 1, dispatch by the [architect]: specification side)
│   ├── CIL — Contract Implementation Loop            (step 2, the build loop for contract work: implementation side)
│   └── TIL — Task Implementation Loop                (step 2, the build loop for task work: implementation side)
│
├── GEM — Governed Engineering Memory                  (sibling)
│   [decision log] + [retro log] → [database] → [learnings function] → auto-triage  → req 5
│
└── Verification architecture                          (gates, audit, derivation, [reviewer]) → req 3, 4
```

GAL *depends on* GEM at start (Learnings line in receipt), at decision points (§4.5 recall obligation), and *feeds* GEM at close (retro). GAL *is measured by* [verification tools]. GAE *generalizes* GAL in the public tier. GEM is a sibling, not a child of DPAL — GAL owns the receipt that calls the [learnings function], the recall obligation that re-consults learnings mid-session, and the retro entry that GEM parses; GEM owns the function and the parser.

GIP is a sibling, like GEM. GAL governs the agents; GIP governs how work reaches the implementation agents — the gate, the queue and the build loops — and lives in its own file. GAL owns what every implementation agent's file and session must carry; GIP owns what a unit of work must pass.

### 1.2 Five requirements

| # | Requirement | Owned by | Measured by |
|---|---|---|---|
| 1 | The prompt is versioned, linked software | GAL — the Deterministic Prompt Assembly & Linking (DPAL) layer | [version-bump tool], [module listing]; the version gate in every core is model-executed protocol, not a script, until [receipt parser] (§8.2 § Who compares) or a [session-start function] runs it (§4.2) |
| 2 | A session has a measurable start and end | GAL | Start: receipt (`GAL start`/`GAL ready`) + [receipt parser]. End: retro entry ([retro parser]) + handoff ([handoff validator]) per §4.4 |
| 3 | The standard measures itself | Governed Agentic Engineering (GAE) harness | The conformance classes in §9, all required for a green agent on every component each applies to (§9.1): invariant loss (§9.3), structural conformance (§9.4), adversarial semantic review (§9.5), key/string integrity (§9.6). |
| 4 | Adversarial verification is a role, not a step (prompts = infrastructure consumed by all agents) | GAE verification | [reviewer] findings per [backlog item] |
| 5 | The system learns without human memory | Governed Engineering Memory (GEM) | `Learnings:` line in receipt makes "are learnings read" measurable; §4.5 recall obligation makes "do they change outcomes" measurable (re-consultation at decision points); retro entry at close makes the session's friction available to the next [learnings function] call |

GAL owns requirements 1–2 and points to 3–5. Without all five there is nothing to publish.

## 2. Scope

This standard governs:

- **Roles** — the roles a contract-driven harness needs, and where their rules stand (§3).
- **Core skeleton** — mandatory sections, their order, and which are invariant vs agent-owned (§4.1).
- **Session start** — gate sequence and invariant template (§4.2, §4.3).
- **Session close** — close sequence and session-close module skeleton (§4.4).
- **Mandatory behavior sections** — four rules every agent that owns a session carries, in one text (§4.7).
- **Step agent skeleton** — the four parts a step agent's file carries (§4.6).
- **Header contract** — YAML frontmatter for cores and modules (§5).
- **Session receipt** — structured proof of successful assembly (§6).
- **Interface localization** — separation of instruction logic from the strings the agent writes to [operator], and how those strings are inventoried and replaced (§6.6).
- **Registration checklist** — touchpoints a new agent must be registered in (§7).
- **Deterministic Prompt Assembly & Linking (DPAL) runtime** — module loading, version gate, fail-fast — consequences of the skeleton (§8).

Beyond the four rules of §4.7 and the review rules of §9.5, §9.7 and §9.8, the standard does NOT govern behavioral content. It governs the container.

## 3. Definitions

### Agent kinds

GAL governs two kinds of agent. They differ in the work they do and its purpose, not in whether they write code.

| Kind | Alias | Works on | Form | Loading |
|---|---|---|---|---|
| **Specification agent** | Tier 1 | The specifications — [contracts], research, review, knowledge texts — and the governance system itself, the tools that measure agents included. | Core + modules | Deterministic — [module field] or classification rules; the system decides |
| **Implementation agent** | Tier 2 | The product, built from a specification in the product's repository. Work arrives through the Governed Implementation Pipeline (GIP). | Core + skills | The agent selects skills; hooks enforce what it may do |

The parts named under Form — core, module and skill — are defined in § Terms below.

A specification agent may write code for the governance system's own tools. Only an implementation agent writes product code, and only from a specification that has passed the GIP gate.

The platform each kind runs on is an instance and is named in the [tool appendix]. A specification agent may run on a [chat platform] that reaches the repository through a connector, or on the [coding-agent platform] in the repository; where a gate takes a different form on the second, §4.2 states it. Tier 1 and Tier 2 are accepted aliases for the two kinds.

This standard prescribes both kinds fully. Where a rule takes a different form for each kind, the section states both; where a rule does not apply to one kind, the section says so and why.

### Terms

| Term | Definition |
|---|---|
| **Core** | The main prompt of an agent. Always loaded. Contains the Session Start Protocol, behavior rules, and the module or skill catalog. File: [core file] or, for a session agent, [session agent file]. |
| **Module** | A prompt extension loaded at runtime. Extends the core within a bounded scope. File: [module file]. |
| **Skill** | An extension of a session agent, loaded at runtime from its catalog. It is to a session agent what a module is to a specification agent's core. File: [skill file]. |
| **DPAL** | Deterministic Prompt Assembly & Linking. The loading mechanism within GAL: how core + modules are selected, loaded, and version-gated. |
| **Invariant section** | A core section whose text is identical across agents except for placeholders. Owned by GAL. |
| **Invariant frame** | A core section whose structure and named elements are identical across agents, but whose rows or write surface are agent-owned. GAL prescribes the frame; the agent fills it. |
| **Agent-owned section** | A core section whose content varies by agent. GAL prescribes existence and position, not content. |
| **Session receipt** | Structured block emitted after assembly. Proves every start gate passed and carries their values. |
| **Retro entry** | Structured block appended to [retro log] at close. Proves the session ended and carries its friction. Parsed by [retro parser]. |
| **Registration** | The set of files and entries that must exist for the system's tooling to recognize an agent — whether that tooling fails without them or silently omits the agent. |
| **Session agent** | The implementation agent that owns a build session: it takes work from the [queue], dispatches each step, and reports. It carries the core skeleton (§4.1). |
| **Step agent** | An implementation agent that does one step of a build loop for the session agent, reports, and ends. It carries the step agent skeleton (§4.6). |
| **Role** | A function a harness needs, listed in § Roles. Every step agent fills exactly one. |
| **Tool appendix** | The document that binds this standard's placeholders, tools and templates to one installation. The other standards of the family call their binding document the [instance appendix]; an installation may hold all of them in one file. |

### Roles

A contract-driven harness needs the roles below. GAL names each role and says why it exists; the rules for a role stand where the last column says, and nowhere else. The [tool appendix] names the agent that fills each role in [system].

| Role | Kind | Why it exists | Rules in |
|---|---|---|---|
| [owner] | — (a person) | Decides intent, and confirms what no agent may decide for itself | GAL |
| [architect] | Specification | Owns and shapes the agent system: the agent table, the backlog item template, dispatch of implementation work | GAL; dispatch in GIP |
| [domain researcher] | Specification | Gathers and classifies the domain knowledge the contracts rest on, so that a claim in a contract can be traced to its source | the agent's core |
| [contract author] | Specification | Writes the contracts — the specification the implementation is built from | the agent's core; [contract standard] |
| [contract auditor] | Specification | Validates a contract against the [contract standard] before it becomes truth; the author never approves its own contract (§9.2 rule 5) | the agent's core; [contract standard] |
| [reviewer] | Specification | Adversarial review of changes to agents and shared infrastructure (§1.2 requirement 4) | GAL §9.5 |
| [harmonizer] | Specification | Writes the approval lists when an agent is measured against this standard | GAL §9.3 |
| Session agent | Implementation | Runs a build session: takes work from the queue, dispatches each step, reports | GIP |
| Planner | Implementation | Plans the change from the contract before any code is written | GIP |
| Tester | Implementation | Writes checks from the contract or the acceptance criteria without reading the code | GIP |
| Verifier | Implementation | Tries to disprove the checks and the change; never runs on the implementer's model | GIP |
| Implementer | Implementation | Makes the change | GIP |
| Fixer | Implementation | Makes minimal fixes to build or test failures, nothing else | GIP |

A system may have further specification agents for its own product. GAL requires of them only what it requires of every agent: the skeleton, the lifecycle and registration.

## 4. Core Skeleton

### 4.1 Section order

The core skeleton below is carried by every specification agent's core and by an implementation agent's session agent. A step agent carries the step agent skeleton (§4.6).

| # | Section | Type | Content |
|---|---|---|---|
| 1 | **Preamble** | Invariant | Identity sentence, repo connection. Placeholder: `[agent description]`. |
| 2 | **Session Start Protocol** | Invariant | Gate sequence per §4.2, text per §4.3. The [tool appendix] holds one template per kind of agent. Placeholders: `[version registry row]` (specification agents on a [chat platform] only — a session agent, and a specification agent on the [coding-agent platform], has no registry check, §4.2 G2), `[AGENT_IDENTITY]`, `[CORE_FILENAME]`. |
| 3 | **What This Agent Handles** | Agent-owned | Scope description. (A specification agent's heading carries `What This Agent Handles` or `What This Project Handles`.) |
| 4 | **Key Paths** | Agent-owned | Repo paths relevant to the agent. |
| 5 | **Routing and permissions** | Invariant frame | Frame: the [primary MCP connector] or the platform's tools, the wrong-connector warning where the agent reaches the repository through a connector, the stale-clone rule where the agent works in a clone that a server keeps for it and does not bring to the remote on its own, and the fresh-clone rule: the working copy is brought to the remote before the session's first write, and again after any pause in which another session may have written. Agent-owned: what the agent may read, write and run — its entry in the [boundary contract]. For an implementation agent the platform enforces the entry (tool list, hooks); the section states it and points to the entry. For a specification agent the agent-owned part also names which commit tool routes each path it writes. (A specification agent's heading carries `MCP Routing` on a [chat platform], and the section name in this table on the [coding-agent platform].) |
| 6 | **Behavior Rules** | Agent-owned | Mandatory protocols and the agent's own rules. MUST contain the invariant H3 **§ Auto-Retro — Mandatory** (text per §4.4 step 3) and the four mandatory H3s of §4.7. Position of the H3s within the block is agent-owned. |
| 7 | **Boundaries** | Agent-owned | What the agent does NOT do. MUST exist as an H3 and MUST point to [boundary contract]. Title is agent-owned and carries `Boundary` or `Boundaries` (`Agent Boundary Rule`, …). |
| 8 | **Commands** | Invariant frame | Frame: `/handoff` with invariant text per §4.4 § Close trigger. Agent-owned: further commands (`/sprint`, `/report`, …). |
| 9 | **Module or Skill Catalog** | Invariant frame | Frame: header row `\| Module \| File \| Content \|` — for a session agent `\| Skill \| File \| Content \|` —, the intro sentence "The core is always loaded. Modules are loaded via [module read call]." — for a session agent "The core is always loaded. Skills are loaded via [skill read call]." —, the single-source rule, the always-loaded rule (§8.1). Rows are agent-owned; the always-loaded set MUST contain `[prefix]-handoff` and `[prefix]-session-close` — for a session agent, its handoff skill and close skill. A session agent's catalog also lists its loop skills and support skills (§8.1). (A specification agent's heading is an H2 that carries `Module Catalog`.) |
| 10 | **AGENT_IDENTITY** | Invariant | Last line: `AGENT_IDENTITY: "[canonical name]"`. |

**Section headings (§9.4).** A section's heading is an H1–H3, an H2 for row 9, that carries the name the row gives for the agent's kind, with any text before or after it (`## Key Paths in the Repo`, `## MCP Routing — MANDATORY`). Where a row names no heading, the heading carries the section name in the table. Rows 1 and 10 have no heading. The structural check accepts exactly these names and no others.

**Invariant** = text prescribed by GAL. Agent fills placeholders only. A change to invariant text is a GAL change that propagates to all agents.

**Invariant frame** = structure and named elements prescribed by GAL; rows or surface filled by the agent.

**Agent-owned** = content varies by agent. GAL prescribes that the section exists and its position.

**Order.** Commands (8) precede Module Catalog (9). This matches every current core; the order is retained because a reorder carries harmonization cost with no measured benefit.

### 4.2 Session Start Protocol — gate sequence

The gate sequence is invariant. Every core carries these gates in this order: a specification agent's core as the table states, a session agent's in the form given after the table. A step agent runs no gates; its session agent starts it, and its report opens with the step receipt (§6.5). The order matches the session receipt lines (§6).

| Gate | Name | Action | Receipt line |
|---|---|---|---|
| G1 | **Handoff validation** | Extract target from `HANDOFF:` line. Compare against `AGENT_IDENTITY`. Mismatch → HALT. | `Handoff:` |
| G2 | **Core verification** | Read [version registry]. Compare `[version registry row]` against `prompt_version` in this file's YAML frontmatter. Mismatch → read full prompt from repo, follow it for the rest of the session, warn. The two sides come from independent routes; where the only route to the current core is the copy being checked, G2 halts (§8.3). | `Core:` |
| G3 | **Persistence gate** | [repo status] + [last commit], on the branch the handoff names, or main when it names none. Warn if [agent directory] dirty or HEAD ≠ Last commit. Where the giver's last durable write is not a commit, the handoff names it in a form the receiver reads back (Handoff §2). | `HEAD:` |
| G3b | **Tool preload** | [tool preload call]. [Chat platform] lazy-loads tools; narrow initial queries miss newer tools. | — |
| G4 | **Deterministic Prompt Assembly & Linking (DPAL) module loading** | Classify task → load modules via [file read]. Version gate each (§8.2). | `Modules:` |
| G5 | **Task context** | Read [backlog item] if indicated. Run [learnings function]. | `Learnings:` |
| G6 | **Agent-specific gates** | Agent-owned, the [architect]'s sensors included (below). Results summarized in receipt. | `Gates:` |
| — | **Receipt emit** | Emit `GAL ready` (or `GAL halt`). | *(receipt itself)* |

**Session agent.** A session agent runs the same gate sequence. Where the platform makes a gate's check different or empty, the gate takes this form:

| Gate | Form for a session agent |
|---|---|
| G1 | Same. The target stands on the bootstrap line of the code-session handoff. No handoff → the null form; the session can then only read, because the [write gate] (GIP §3) refuses a write without a claimed queue post. Where a product is declared as paths (GIP §1), the [write gate] holds the prefixes only; the agent's entry in the [boundary contract] holds its writes outside them. |
| G2 | Does not apply. G2 compares a copy of the core with the repository; the [coding-agent platform] loads the core from the working tree, so there is no copy to compare. The version is read from the file and printed on the `Core:` line. |
| G3 | Same, with a pull first: the working tree is brought to the branch the handoff names, or to the remote main when it names none, before status and HEAD are read. |
| G3b | Same, where the [coding-agent platform] defers tool loading; otherwise it does not apply. The [tool appendix] states which holds. |
| G4 | The loop skill named by the queue post, and the always-loaded skills; each version-gated (§8.2). |
| G5 | Claim the queue post and read its task specification; run the [learnings function] for its backlog item (§4.5). |
| G6 | Agent-owned — for example the baseline: the full suite green before work begins. |

**Specification agent on the [coding-agent platform].** A specification agent that runs in the repository on the [coding-agent platform] (§3, Agent kinds) takes the session agent's form for the three gates whose form the platform decides: G2, G3 and G3b above. The core is read from the working tree, so G2 has no copy to compare and the `Core:` line carries the version read from the file (§6.2 p. 6). Because G2 no longer catches a stale core, G3 brings the working tree to the branch the handoff names, or to the remote main when it names none, before status and HEAD are read. The platform loaded the core before the pull, so when the pull changes the agent's core file, the agent reads it, follows it for the rest of the session and warns the [operator], as on a G2 mismatch; the `Core:` line carries the version after the pull. The modules are loaded at G4, after the pull. Every other gate keeps the specification agent's form in the first table; G4 and G5 differ for a session agent because of its kind, not its platform. The [tool appendix] states which platform each agent runs on.

**One call for several gates.** A system may run gates G2–G5 in one deterministic call, a [session-start function], instead of one model step per gate. The gates, their order, their halt and warn conditions and the receipt lines do not change: the call runs the gates in the order above and answers each gate's values, marking each value on which a gate halts or warns (a G2 mismatch, a module older than its core or missing); the model halts or warns where the mark stands and carries out what the call cannot — the warning to the [operator] and following the full core on a G2 mismatch, the version-gate halt question — and emits the receipt from the answer. A halt the model makes on a mark is the gate's halt: the text the call answered for a module older than its core is not followed until the [operator] confirms (§8.2). G1 stays the model's, decided from the handoff before any read. G3b stays the model's where the [chat platform] defers tool loading; when the call returns the modules' text, G4 no longer needs the full tool set, and G3b may follow the call. G6 stays agent-owned. A gate the call runs is executed by a script, not by the model, which closes for that gate the gap §1.2 requirement 1 names. The [tool appendix] states which gates the instance's call runs.

**Sensors.** The [architect]'s G6 may read sensors: reads that never stop the start and whose finding becomes an item in the start reply's checklist — recurring patterns and regressions (GEM §6), unread intake, the age of the latest architecture review, the work graph (Wave Standard §7) and the register of inherited measurements (§4.7.4). A sensor whose read fails is named under what is unclear. The [tool appendix] names the sensors and their reads.

**A handoff received mid-session.** A handoff that reaches a session already running names a state the session has not seen. Before any work on it, the agent runs G1, G3 and G4 again — and G2 where a route to the [version registry] exists — and emits those receipt lines; a line that cannot have changed since the start is left out.

Gate ordering is load-bearing. G1 before file reads (wrong project). G2 before module loading (stale core). G3 before writes (dirty tree). G3b before G4 (module loading and the version-gate halt both need the full tool set). G4 before task work (stale module). G5 before work begins (learnings may change approach). G6 before receipt (the `Gates:` line cannot be filled after emit).

The close side of the lifecycle is §4.4. It is not a receipt line — the retro entry is the close proof.

### 4.3 Session Start Protocol template

Invariant text. Placeholders in `[BRACKETS]`. There is no inline `prompt_version:` line in the body — the YAML frontmatter is the single source (§5.1).

**The template is the instance's.** It writes the §4.2 gate sequence out in one system's tool calls, file paths, connector names and operator name, so a system adopting GAL writes its own. It is held in the [tool appendix] § Session Start Protocol template, and the cores are byte-matched against it there (§9.4). A change to it changes the invariant text of every core (§10 p. 2).

**Its steps, in order.** (1) Read the [version registry] through the [primary MCP connector], stopping on the [wrong-connector prefix] and reconnecting before proceeding. (2) Compare the core's row in it with `prompt_version` (G2). (3) The persistence gate (G3). (4) On a mismatch, read the full core from the repo, follow it for the rest of the session, and warn the [operator]; the warning is an emit (§6.6). (5) The tool preload (G3b). (6) Module loading with the version gate (G4); its halt question is an emit (§8.2). (7) Task context and the [learnings function] (G5). (8) Agent-specific gates (G6). (9) The start reply, opening with the receipt block (§6.1, §6.2 p. 2). A tail follows step 9: the fallback when the connector is unreachable (§8.3), and handoff target validation (G1) with its halt reply, an emit.

**On the [coding-agent platform].** A template for a specification agent that runs in the repository (§4.2) has no connector: step 1 reads the version from the core file's frontmatter, step 2 does not apply and step 4 applies only through step 3 (G2), step 3 pulls first and, when the pull changed the core file, reads and follows it with step 4's warning (G3), step 5 follows G3b's form, and the tail carries handoff target validation only. The step numbers, their order and the halts do not change; the receipt's `Core:` line takes the form §6.2 p. 6 gives.

**With a [session-start function] (§4.2).** Step 1 loads and runs the call, which reads the [version registry]; steps 2, 3, 6 and 7 take their values from its answer, and step 4's full core is in it on a mismatch. Step 2 names the step-by-step reads — the [version registry], the [repo status] and [last commit], each module, the [backlog item] file and the [learnings function] — as the path when the call is not found or answers an error. The step numbers, their order, the halts and the receipt do not change.

The receipt block in step 9 is embedded literally so that its labels are present in every harmonized core — this is what makes them [invariant inventory] invariants (§6.2 principle 5, §6.4). A template that only points to §6 leaves the cores without the labels.

**Invariant strings are never re-wrapped.** Every string that is an [invariant inventory] token (the receipt labels, the step 4 warning, the step 6 halt question) stays on one line in the template and in every core, regardless of line length. Prose may wrap; tokens may not. The rule applies to the string in each locale (§6.6), not to its key.

**Localized strings in the template.** The step 4 warning and the step 6 halt question are emits (§6.6): the template shows the [locale] string, which is what a core carries today. A core built for another locale carries that locale's string from the inventory, on one line, with the same key comment.

NOTE: The template carries steps 1–9 + the tail section (the connector fallback, where the template has one, through handoff target validation). Agent-owned step 10 content (gate detail) is placed between `GAL ready` and the tail.

### 4.4 Session close

The lifecycle closes through the session-close module. The core carries only the trigger; the sequence lives in the module. The retro entry (step 3) is the close proof — [retro parser] reads it into the Governed Engineering Memory (GEM), which is how requirement 5 holds for every agent.

#### Close trigger

The core's § Commands carries the close trigger as invariant text. `/handoff` is a mandatory sequence, not a question: the agent reads the session-close module from the repo, never from memory; it executes every step in the module's order; and it produces the handoff block only after all preceding steps are complete. A session that reaches its end without `/handoff` runs the same sequence as its final action, from step 1. A session that wrote a file or a row runs it before it ends, whatever else it did. The instance's text is in the [tool appendix] § Close trigger.

#### Session-close module skeleton

Every [prefix]-session-close module follows this skeleton. Four H4 steps in fixed order, one exception, one anti-pattern list. Empty steps are not permitted.

| # | Section | Owner | Content |
|---|---|---|---|
| — | **Header** | skeleton | `### Session Close Protocol — Mandatory`, then `**Trigger:**` ([operator] writes `/handoff`, session reaches context cap (~70%), or all tasks are complete) and `**Purpose:**` (agent-owned sentence). |
| 1 | **Pre-commit verification** | agent | What must be true before commit: deliverables present, backlog state verified against the item files, brief, governance-log, and every other repository the session wrote in committed or named as left uncommitted. Agent-owned content beyond these. |
| 2 | **Commit + push** | skeleton | [commit non-canonical] → [commit canonical] (only if canonical changes) → [push]. Post-push verification: [last commit] — confirm the commit is HEAD; a push that reports nothing to send is a warning, not a confirmation. The report and the handoff cover only the files this session wrote. |
| 3 | **Retro-log** | skeleton | Append to [retro log] via [append with commit] (message `retro: [RETRO_KEY] [date]`), then [push]. Format below. Trivial session → skip append and push. |
| 4 | **Produce handoff** | skeleton | Delegate to `[prefix]-handoff` (§ Handoff checklist). Work remains → handoff. All tasks complete → no handoff, checkpoint line. Session cap → resume handoff. The handoff is the last thing produced. |
| — | **Trivial session (exception)** | skeleton | Single question, no repo changes → none of the steps. Criterion: no file written, no commit. (The block under [tool appendix] § Skeleton text is the reference; this row restates it.) |
| — | **Anti-patterns — never** | skeleton + agent | Skeleton rows: never skip step 1; never produce a handoff without commit + push; never omit the retro-log. Agent may add rows. |

**Retro entry format (invariant).** The form, and how a pattern is named in it, is the GEM standard's §3.1 and §3.2: a header line `RETRO [RETRO_KEY] [YYYY-MM-DD]:` and the fields `- Scope:`, `- Friction:` and `- Pattern:`, in that order. The byte-matched block is in the [tool appendix] § Retro entry format.

`[RETRO_KEY]` is the agent's key in the [retro parser alias table] (§7 row 11). A key the parser does not normalize leaves the entry stored but unattributed, and the [learnings function] cannot route it. This is a registration defect, not a format choice.

**Skeleton text (byte-matched by the [skeleton check], §9.4).** Steps 2 and 4, the exception and the anti-pattern rows are skeleton-owned. Their canonical text is the instance's, as carried by the session-close modules, and is held in the [tool appendix] § Skeleton text.

`[AGENT_OWNED_QUOTE]` is the only placeholder in the anti-pattern block. Agent-added rows follow the three skeleton rows. Step 3's text is the retro format above plus the two sentences in the §4.4 table row.

The same format is the invariant text of the core's § Auto-Retro H3 (§4.1 row 6), prefixed by a sentence that says where and how the entry is appended and suffixed by the rule that a trivial session skips it; the instance holds one such text per agent kind in the [tool appendix] § Auto-Retro core text, because a session agent carries its entry in its report (step 3 below) while a specification agent appends it. Core and module state the same format; the module is the executing location, the core is the standing rule.

**Machine-readable exceptions.** A session-close module that deviates from the skeleton text is registered in the [tool appendix] § Registered deviations twice: in prose that says why, and in an HTML comment the [skeleton check] can read. Both are required — the comment alone says nothing about why, and the prose alone left the tool reporting `✘` on a deviation the standard had already accepted.

Semantics and constraints:

- An exception downgrades `✘ FAIL` to `⊘ INFO` for exactly one `(file-stem, check, block name)` triple — `check` is the [skeleton check]'s own identifier for the check that fails, declared in the [tool appendix]. It never makes anything green — §9.2 rule 2 reserves `⊘` for *not measured*, which is precisely what a registered deviation is. An agent carrying one is not a green agent by the structural conformance class (§9.4) alone.
- **An exception that never fires is a FAIL**, on the same principle §9.3 § Approved-change list governance p. 1 applies to unused approval-list rows: a stale registration silently excuses a future defect that happens to land on the same triple. Two checks, with different populations: a registration whose `file-stem` is not a **candidate** — not one of the files the [skeleton check] discovers for either candidate kind, cores or session-close modules (§9.4 Input) — is `UNUSABLE` and a FAIL on **every** run, whichever kind the run checks, because no run can ever apply it and it would otherwise stay invisible forever. Existence on disk is not the test: the [version registry], a handoff module and the like exist but are never candidates, so a registration naming one is exactly as unusable as a misspelled stem. A registration whose file *was* opened and whose block passed is `STALE` and a FAIL on that run. A run over cores therefore does not judge whether a session-close registration fired, but it does judge whether its stem is a candidate at all.
- Adding one is a normative change: it changes the [tool appendix], bumps its version and is reviewed by the [reviewer] before it counts (§10 p. 2).

**Session agent.** The close skill carries the four steps in this form:

1. **Pre-commit verification** — every task in the run has a step receipt for every step (§6.5), the full suite is green, and every finding is reported.
2. **Delivery** — branch, pull request, continuous integration, merge; then post-merge verification: the merge commit is on main with green CI. When the merge does not happen within the session, the step ends with the pull request and its CI status, and the delivery proof is taken by whoever sees the merge commit (GIP §6).
3. **Retro** — the entry, in the invariant format, is carried in the session's final report. The [architect] enters it in the [retro log], which remains the single record (GEM reads it from there).
4. **Handoff** — the final report to the [architect] through the [report path]; a handoff when work remains.

The close trigger has the same form as a specification agent's (§ Close trigger): `/handoff`, the session's context limit (a hard stop, GIP §5.1), or the end of the run — the series of posts ended or the queue empty. A session that reaches its end without `/handoff` runs the close skill as its final action, from step 1. The model never closes for any other reason. A step agent has no close; its report is its end.

**Handoff module skeleton:** defined in [handoff standard] § Handoff Module Skeleton (six H3 sections). GAL does not restate it — §7 row 7 points there.

### 4.5 Task-learnings recall obligation

G5 loads the [learnings function] at session start. This subsection governs what happens to those learnings *during* the session.

**Problem.** Learnings read at start and never re-consulted are wallpaper: the agent has them in context but does not reference them at decision points.

**Rule.** The sending agent re-consults the [learnings function] at every decision point below and cites relevant learnings in the output. The obligation is on the *sender*, regardless of who the receiver is.

**Decision points (triggers):**

| # | Decision point | What the agent does | Where the citation appears |
|---|---|---|---|
| 1 | **Handoff production** | Before producing the handoff block: review the learnings for entries that concern the scope the handoff addresses. | In the handoff block — a `Learnings consulted:` line listing the cited entries, each with the step the receiver takes about it (a file or section to read, a run, a measurement), or `none relevant`. |
| 2 | **Scope definition** | When a new scope declaration is made during the session (not the initial task from the handoff — the *narrowing or expanding* that happens mid-session). | In the response that declares the scope. |
| 3 | **Closure declaration** | Before [closure tool] or equivalent: review for entries that say a dimension must not be forgotten. | In the pre-close reasoning. |

**Trigger 1 is mandatory and produces a visible artifact** (the line in the handoff). Triggers 2 and 3 are mandatory obligations on the agent's reasoning but produce no separate artifact — the citation appears in the response's prose.

**Adversarial verification.** The [reviewer] checks handoffs for trigger 1 compliance: was `Learnings consulted:` present, and if a learning was relevant to the handoff's scope, was it cited? This is secondary — the [reviewer] should not need to catch what the sender should have done. The [reviewer] does not gate triggers 2 and 3 (no artifact to verify).

**Scope.** Every specification agent, and an implementation agent's session agent. For the session agent the decision points are: its report or handoff at the end of a run (trigger 1); a change to a task's scope during the run — a task stopped by a finding, split, or widened (trigger 2); and the report that a task is done (trigger 3). It reads the [learnings function] through the same narrow path it uses for the queue.

Step agents are exempt: they own no decision point. A learning that should change a step agent's behaviour reaches it as a change to its file or to the task specification, never as text in a dispatch — a dispatch carries no pre-read content, and a tester must not be told what the implementation does.

**Anti-pattern:** Reading learnings at start, listing "[relevant learnings]: [list]" in the opening, and never referencing them again. The obligation is at decision points, not at session start — session start is G5, already covered by the receipt.

### 4.6 Step agent skeleton

A step agent does one step of a build loop for the session agent, reports, and ends. It owns no session — no start protocol, no close, no handoff and no retro entry — so the core skeleton (§4.1) does not apply to it. Its file carries four parts.

| # | Part | Content |
|---|---|---|
| 1 | **Header** | Name, version, parent agent and role. The role is a value from the role table (§3); an agent that fills no role in it is not a step agent. The platform's own fields (tools, model, hooks) stand beside these; GAL requires only the four. The header contract is §5. |
| 2 | **Permissions** | What the agent may read, write and run. Every permission the text states is enforced by the platform — the tool list and hooks — and a permission stated only in prose is not a permission. |
| 3 | **Report** | The report opens with the step receipt (§6.5) and ends with a verdict from a closed set the file declares. |
| 4 | **Agent-owned** | Everything else: reading order, method, modes, input checks and failure formats. |

A step agent's file is measured by the conformance classes like any other component (§9): the header by structural conformance (§9.4), the rules by the adversarial semantic review (§9.5).

### 4.7 Mandatory behavior sections

Four rules hold for every agent that owns a session: every specification agent and every session agent. Each core carries them as H3s in Behavior Rules (§4.1 row 6), titled `Investigation — Mandatory`, `No deferral without a reason — Mandatory`, `Process economy — Mandatory` and `Measurement line — Mandatory`. The text of each is the instance's, held once in the [tool appendix] and byte-matched in every core (§9.4). A core may carry a pointer to that text instead; the pointer binds only because the start reads the [tool appendix]'s section at G4, with the modules or skills (§4.2, §8.1), and §9.4 then byte-matches the pointer line. A core never carries a variant of its own. A step agent is held to them through its task specification and its report (§4.6).

#### 4.7.1 Investigation

It protects against a fix, a recommendation or a verdict built on something nobody read.

1. **Fix.** No fix without investigation: read the files, logs and state; form a hypothesis; verify it against the system; then fix. While the investigation runs, nothing outside the part under examination changes. The same failure three times stops the work: the agent classifies it and escalates to the [operator].
2. **Recommend or decide.** Every rule a recommendation, specification, verdict or finding rests on or cites is read in full at its source — the contract, the standard, the decision entry — in the session, with every dependency it touches. The output says what was read and in which version. A claim that something does not exist names the search that did not find it.
3. **Assume nothing silently.** Where the work needs a fact nobody has stated, the agent says what it would have assumed and asks.

Not a reason to skip: the rule being familiar, the task being small, or a summary of the rule in a handoff.

#### 4.7.2 No deferral without a reason

It protects against work that is described well enough to feel handled and is never done, and against work that never closes because everything found in it is added to it.

1. What a session finds — a finding, a gap, a rider — is done in the session or in the work in progress, unless one of four reasons holds: it needs a route or an agent the session does not have, and is handed over now, in parallel; it needs an [owner] decision, and the question is asked now; it depends on something that does not yet exist, and the dependency is named as one; or it lies outside the frozen scope of the work in progress ([handoff standard] §5 p. 7), and a named item holds it with a trigger. The work in progress is the order, not a part split from it, and what it delivers is what any of its parts has delivered so far: a finding there lies inside its scope. A blocking finding there is fixed in the round that found it and reviewed again, past the round limit in a round the [owner] decides on (§9.7 p. 1); it is never carried. An advisory one is fixed in that round too, unless the stop rule (§9.5) or the round limit (§9.7 p. 1) closes that round with it open; then the order's follow-up item holds it. Nothing found goes into a later part of the order. Work whose scope is frozen closes when that scope is done: a rule that forbids deferral and allows no closure has no exit.
2. Every deferral names its reason and its trigger: the event that brings it back. A deferral without a trigger is not permitted.
3. "Pre-existing", "out of scope", "next version", "later" and "increases scope" are not reasons. A frozen scope is one only with its named item and its trigger.
4. No data is removed to get past a gate, and a workaround is committed only with a blocking item that removes it.

#### 4.7.3 Process economy

It protects against rules and checks that only accumulate, and against control that stalls progress.

1. A decision that is the agent's — form, tooling, order of work — is made and carried out, and the reply says what was decided. A decision that is the [owner]'s gets one recommendation and a yes/no question.
2. A check that does not say stop warns and continues. Before stopping on a failing measurement, the agent tries another way to the same measurement or narrows its claim to what was measured.
3. A check, gate or mandatory procedure that has not stopped a real error in 30 days, counted from the [retro log] and the [decision log], is removed. A sensor (§4.2) is measured instead by whether it showed, in 30 days, something no other step showed.
4. A new rule enters only with a rule removed or merged in the same change. A rule states what it protects and why; a rule that only prescribes a procedure is rewritten or left out.
5. A review finding is a change: it is fixed where it points, and never by itself becomes a new check or case (§9.8). It stays open, carried by a backlog item, only when it lies outside the frozen scope of the work it reviews (§4.7.2), or when it is advisory and the stop rule (§9.5) or the round limit (§9.7 p. 1) closes the round with it open. A blocking finding in the work is never carried: it holds the work open until it is fixed.

#### 4.7.4 Measurement line

It protects against a result that looks measured and was not.

1. A reply that reports a new result, or asks for a decision on evidence the agent produced, ends with one line: what was measured, with which tool or source, and what was not. The [tool appendix] gives the line's form.
2. Two reasons for not measuring are allowed: the tool to measure it does not exist, or the measurement is impossible in this session, with the cause named. Time, cost and scope are not reasons: a claim too costly to measure is narrowed to what was measured.
3. A value not read or computed in this session — another agent's, a handoff's, a summary's, or the agent's own earlier one — is not measured until it is measured at its source. Derived numbers and copied text are produced with a tool, never by hand.
4. An entry that stays not measured is written once to the register that the [handoff standard]'s [measurement rule] binds, with who measures it and when.

## 5. Header Contract

### 5.1 Core prompts

Every core carries YAML frontmatter with `prompt_version`. This is the version of record and the only occurrence.

```yaml
---
prompt_version: "YYYY-MM-DD-x"
---
```

### 5.2 Modules

```yaml
---
module: "[prefix]-[name]"
version: "YYYY-MM-DD-x"
parent_agent: "[PARENT_AGENT_KEY]"
---
```

| Field | Required | Rule |
|---|---|---|
| `module` | Yes | Matches filename stem. Unique across all agents. |
| `version` | Yes | `YYYY-MM-DD-x`. Compared as a string, not as a semantic version (§8.2): date zero-padded; `x` is a lowercase letter ordering bumps within one day and carries no meaning — no major/minor/patch, no breaking-change signal. Same format and rule for the core's `prompt_version` (§5.1). |
| `parent_agent` | Yes | Must match the parent agent's entry in the [version-bump tool] agent register. This is the linkage key. |

`parent_agent` is a tooling key, not a display name. The rule is `parent_agent = AGENT_IDENTITY` of the parent core.

Cross-agent loading is permitted. A module with `parent_agent: "[AGENT_A]"` may be loaded by another agent's catalog (e.g. [agent B] loads an [agent A] module). `parent_agent` determines which atomic bump includes the module, not which agents may load it.

### 5.3 Bump on change

Every change to the content of a core or a module bumps its version, in the same commit as the change. The version names a text: the [version-bump tool] archives the pre-state as the file at the commit that set the version (§9.3 § Archive provenance), so an unbumped change leaves two texts under one version and the archive then holds the older one — the before/after comparison of the next harmonization reads a pre-state that is not the one it claims. The bump is atomic per agent by default; a module may be bumped alone between atomic bumps. The converse is an anti-pattern: a bump without a content change, made only to silence the version gate (§8.2), removes the signal the gate exists to give. What counts as content is everything below the frontmatter; the version line itself does not.

### 5.4 Implementation agents

A session agent's core carries `prompt_version` as §5.1. A skill and a step agent carry `version` and `parent_agent` as §5.2, beside the platform's own frontmatter; the name the platform reads stands in for `module`. A step agent also carries `role`, a value from § Roles. Where the platform refuses fields it does not know, these fields stand instead in a comment block at the top of the file, which the tools read in the same way; the [tool appendix] states which holds. §5.3 applies unchanged.

## 6. Session Receipt

### 6.1 Format

```
GAL start · [AGENT_IDENTITY]
Handoff:    [From] → [To] ✔ ([descriptor], [backlog item ID, …])
Core:       [prompt_version] · [version registry name] ✔
HEAD:       [7-char hash] · [tree status] · [= Last commit ✔ | ≠ Last commit [expected] ⚠]
Modules:    [name version ✔, …]
Learnings:  [backlog item ID · N rows, …]
Gates:      [agent-specific gate results]
GAL ready
```

The block with every placeholder resolved, null forms included, is the instance embedded in §4.3 step 9. Every line is one line; `Gates:` carries the G6 results as a one-line summary.

**Several backlog items.** A session that carries more than one [backlog item] lists them on the `Handoff:` line as `[ID], [ID]` and on the `Learnings:` line as `[ID] · [N] rows, [ID] · [N] rows`, in the order the handoff names them — one separator, `, `, on both lines, so a [receipt parser] reads them the same way (§6.2 p. 5). `[expected]` on the `HEAD:` line is the handoff's `Last commit`, the value §8.3 names.

**Null forms.** Every line always carries a value; three lines have defined null values:

| Line | Null form | When |
|---|---|---|
| `Handoff:` | `Handoff:    none ([operator]-initiated)` | No `HANDOFF:` line in the first message (routing table `[operator] → [agent] ad hoc`). |
| `Learnings:` | `Learnings:  no [backlog item label]` | No [backlog item] ID from handoff or [operator]; [learnings function] not run. |
| `Gates:` | `Gates:      none` | The agent's core defines no agent-specific checks with reportable output (G6). |

`Modules:` has no null form. `[prefix]-handoff` and `[prefix]-session-close` are always loaded (§4.1 row 9), so a completed G4 lists at least two modules; an incomplete G4 is a halt, and on halt the `Modules:` line *is* the `GAL halt:` line (§6.2 principle 3) — nothing else is written on it.

A null form is a passed gate with an empty input, not a warning. Principle 6 below applies to lines that have neither a value nor a defined null form.

### 6.2 Principles

1. **Every line carries the value that passed.** `Core: 2026-09-11-b · [version registry name] ✔` is verifiable. `Core: verified` is not.
2. **The receipt opens the start reply, and the start reply ends the turn.** The start reply is emitted after the last gate, and no tool call follows it in the same turn: text written before a later tool call does not reach the [operator]. It has four parts, in this order. First, the receipt, as its first text. Second, a numbered checklist of the session's work, with one item per task. A task counts whether it comes from the handoff, the [backlog item] or the [operator]'s message, and a task named in more than one of them is one item. Third, what in the handoff, the [backlog item] or the [operator]'s message is unclear, or that nothing is. Fourth, one question: whether to start, or what must be resolved first. The question ends the turn. Task work begins in the next turn. A receipt alone is not a start reply: a turn that ends on the receipt reads to the [operator] as a dropped connection. The block is not split around the gates — an opening line written before the first tool call would never be seen. A session agent that has claimed a queue post starts work in the same turn when its receipt carries no ⚠ and nothing is unclear; otherwise its start reply ends with the question, as for every other agent. No gate asks a question of its own or starts the task: each speaks through the start reply. A question to the [operator] ends the turn, and work that depends on the answer, a commit included, waits for the next. The [architect] may instead, as an option its core declares, start the first checklist item in the same turn; then only a halt, a handoff addressed to another agent or an unreachable connector ends the start reply with a question.
3. **Halt: same block, different terminal.** `GAL halt: [line] — [reason]`. Nothing written after halt.
4. **Warn: `⚠` on the affected line.** Session continues.
5. **Fixed labels, free values.** Labels (`GAL start`, `Handoff:`, `Core:`, `HEAD:`, `Modules:`, `Learnings:`, `Gates:`, `GAL ready`, `GAL halt:`; for a session agent also `Skills:`, in place of `Modules:`, and `Task:`) are invariants in the [invariant inventory]. They are present in every core because the template embeds the block (§4.3 step 9). Values are session-specific. Enables parsing by a [receipt parser].
6. **Same lines for every agent of a kind.** Every specification agent emits the §6.1 lines; one on the [coding-agent platform] writes `Core:` in the session agent's form (§6.5) — the version read from the file, without a registry check, since G2 does not apply (§4.2). Every session agent emits the §6.1 lines with the differences §6.5 names. A field an agent cannot fill — neither with a value nor with its defined null form (§6.1) — is a defect in the core, not a receipt exemption.

### 6.4 Inventory migration

The [invariant inventory] is a presence inventory: the [invariant-loss check] fails when an inventory row is absent from the reference file ("stale inventory"). Every row whose string leaves the cores must therefore leave the inventory in the same commit.

### 6.5 Implementation agents' receipts

**Session receipt.** The session agent emits the §6.1 block with these differences: the `Modules:` line reads `Skills:`; a `Task:` line follows `Learnings:` — `[queue post ID] · [task specification path]`, or `interactive` when no queue post was claimed; `HEAD:` names the repository before the hash, `[repository] [hash]`, since one kind of session agent runs in several repositories; and `Core:` carries the version read from the file, without a registry check (§4.2, G2). §6.2 applies.

**Step receipt.** Every step agent's report opens with

    GAL step · [role]
    Agent:      [agent file path] · [version]
    Model:      [model] · reported | configured
    Task:       [queue post ID]

and ends with `Verdict: [a value from the agent's closed set]`. Together they are the step receipt, stored with the run in the [queue] (GIP §6). Each value is filled by whoever knows it: the platform names the agent and the model that ran — `reported` when the platform reports the model, `configured` when only the agent's configuration is known (GIP §2) — the file gives its path and version, and the agent gives only its verdict — a model can write anything about itself.

### 6.6 Interface localization

An agent has two kinds of text: instruction logic (what the agent does) and interface strings (what the agent writes to [operator] or to a log). GAL requires them to be separable, so that the interface language can change without touching the logic.

1. **Three classes of text.** (i) **Instruction logic** — English; what the agent does. (ii) **Emit** — a string the agent writes verbatim to [operator], to a log, or into a file the agent writes (a [backlog item] template's YAML comment, a handoff block's SESSION SETUP text): locale-bound, inventoried, keyed. (iii) **Input token** — a string the agent recognizes when [operator] types it (`"[yes]"`, `"[go]"`, the inventory's input section): locale-bound, inventoried in the existing input section, never emitted, not keyed. Every string in a file in the prompt surface (core, module, [handoff standard] — any of the scope keys the [invariant-loss check] knows) is exactly one of the three. A sentence in the interface locale that is neither a registered emit nor a registered input token is a defect in the file — and a defect is resolved by translating it (→ logic) or by keying it and adding its inventory row (→ emit, §6.4); there is no fourth class.
2. **Inventory = locale table.** The Emits section of the [invariant inventory] carries four columns: `scope | key | locale | string`. An emit that belongs to several files names them all in the scope column — a scope is a file.
3. **The receipt is not localized.** `GAL start`, `GAL ready`, `GAL halt:`, the six line labels (`Handoff:`, `Core:`, `HEAD:`, `Modules:`, `Learnings:`, `Gates:` — nine tokens with the three above, §6.2 principle 5), and `RETRO` are machine-parsed tokens, identical in every locale. They live in the inventory without a locale. Values and halt reasons are free text or emits. An implementation agent's receipts add `Skills:` and `Task:` (§6.5), and the step receipt's `GAL step`, `Agent:`, `Model:` and `Verdict:`, with the model values `reported` and `configured`. They are tokens on the same terms.
4. **The file carries the string, and the key beside it.** Bootstrap reads raw markdown; no substitution runs at load. A file in the prompt surface therefore contains the literal string of its locale, on one line, with the key as an HTML comment on the same line or on the adjacent line (the line directly before or directly after): `<!-- emit:version_gate_question -->`. The comment is invisible to the agent's behavior and visible to tooling.
   **Placement when the string lives inside a reproduced block.** If the string sits inside a fenced block, an HTML comment, or a YAML block that the agent reproduces verbatim (a handoff template, the SESSION SETUP comment, the [backlog item] frontmatter template), the key comment goes **outside the block, on the line directly before the block's opening** (the fence line or the `<!--` line), never inside it. Two reasons: HTML comments do not nest — a key comment placed beside the SESSION SETUP note closes the SETUP comment at its `-->`; and a key comment inside a template block is copied by the agent into the artifact it writes. **Block boundaries:** a block is the span from its opener to its matching closer — a fence closes at the next fence line with the same character and at least the same length (CommonMark), an HTML comment at the first `-->`. When openers nest, the key comment precedes the **outermost** opener; a comment between the outer and an inner opener sits inside the rendered example and is copied by anyone copying the outer block. The adjacent-line form is what the §4.3 template already uses at steps 4 and 6 and at target validation (`<!-- emit:version_mismatch_warning -->`, `<!-- emit:version_gate_question -->`, `<!-- emit:handoff_wrong_target -->`, `<!-- emit:handoff_wrong_project -->`); the outside-block form applies to the SESSION SETUP note and to the [backlog item] template's YAML comment in the [architect] core. Each key comment is also registered as a locale-independent token row in the inventory (§6.4), which is what makes "keys unchanged" measurable.
5. **Re-wrap rule per locale.** §4.3 § Invariant strings applies to each locale's string. Keys are single tokens and cannot wrap.
6. **Text to another model.** What an agent writes to another model — a dispatch to a step agent — is instruction logic: English, not keyed, not inventoried. A word another agent or a tool parses — a verdict, a finding class, a receipt label — is a token, the same in every locale. Only what reaches the [operator], or what is written into a log or a file, is an emit.

**Measured by.** The key/string integrity class (§9.6): every key comment resolves to a row whose string stands in the file, and every keyed row in scope has its key comment, so a file with N keyed rows in scope and 0 key comments fails rather than passing vacuously. The reverse direction — no unkeyed interface string in a file — is not gated: it would require classifying prose by language. A heuristic that flags suspect lines is a finding generator for the [reviewer], never the gate (§9.6).

## 7. Registration Checklist

A new agent is not operational until every point that applies to its kind is completed. Each corresponds to a file or entry that a tool or gate **enumerates agents or modules from** — whether that tool fails without the entry or silently omits the agent. The silent ones are the ones that rot: rows 10 and 11 were found with measured rot precisely because nothing fails when they are missing. The instance's file or entry for each point is in the [tool appendix].

| # | Registration point | Applies to | Without it |
|---|---|---|---|
| 1 | Core file — the filename suffix and the form of the `AGENT_IDENTITY` last line are load-bearing; for a step agent, its agent file with the header of §4.6 | all | Agent does not exist; the [handoff validator] derives its identity set from the core files by suffix and last-line form — wrong suffix or line form = agent absent from the set. A step agent without a file cannot be dispatched |
| 2 | [version registry] entry | specification and session agents | [version-bump tool] hard-fails. A step agent is covered by its session agent's entry through `parent_agent`, as a module is |
| 3 | [version-bump tool] agent entry | specification and session agents | Atomic bumps skip agent; unknown agent exits. A step agent is bumped with its session agent |
| 4 | [bootstrap prompts] entry | specification and session agents | Agent has no bootstrap; Session Start Protocol cannot run |
| 5 | [handoff standard] routing rows — to and from the [architect] | specification and session agents | Handoff production halts; the [handoff validator] fails a handoff whose route has no row (Handoff Standard §3, §8) |
| 6 | [invariant inventory] scopes — scope on every token row and every emit row of the agent's locale (§6.6) | all | The [invariant-loss check] cannot run the before/after gate for the file (§9.3) |
| 7 | Handoff module or skill — per [handoff standard] § Handoff Module Skeleton | specification and session agents | Session close cannot produce handoff |
| 8 | Session-close module or close skill — per §4.4 skeleton | specification and session agents | Session close sequence undefined; no retro → agent invisible to the Governed Engineering Memory (GEM) |
| 9 | [architect] agent table | all | [architect] unaware of agent |
| 10 | [agent-map generator] entry — for the core **and every module or skill**, and every step agent | all | Silent: agent, module or skill absent from the published agent map. Missing files hard-fail; missing entries do not |
| 11 | [retro parser alias table] entry — retro key → canonical short name | specification and session agents | Silent: retro entries stored unattributed; the [learnings function] cannot attribute them |
| 12 | *(conditional)* [handoff validator alias table] entry | specification and session agents | Needed when the agent uses a short *From* name in the routing table; `To` must always be the canonical AGENT_IDENTITY — the identity check is an exact match against the core-derived set and does not consult the alias table. Without the alias, the routing check finds no routing rows for the short From-name. |
| 13 | *(conditional)* a row in the [handoff validator]'s receiver rule set | specification and session agents | Needed when the agent's handoffs carry mandatory receiver-specific fields. Without a row the fields are documented but not gated. Adding a receiver means adding a row, not a branch. |
| 14 | [boundary contract] entry — what the agent may read, write and run | all | The agent's permissions are stated nowhere they can be checked |
| 15 | Role — a value from § Roles in the step agent's header; and, per product repository, a registered step agent for every role the Governed Implementation Pipeline (GIP) marks as required (GIP §2) | step agents | A harness can run a build loop with a role missing, and nothing notices |

Deregistration: same list in reverse.

## 8. DPAL Runtime Rules

These rules of Deterministic Prompt Assembly & Linking (DPAL) are consequences of the skeleton (§4) and header contract (§5). They define what happens when gates G2 and G4 execute.

### 8.1 Module loading

Assembly is deterministic: same handoff + same classification rules = same modules.

**Sources (priority order):** (1) Handoff [module field]. (2) Core classification rules. (3) No match → no task-specific module.

**Sources for a session agent:** (1) the queue post names the loop skill — the only source for a loop skill; the platform's automatic selection is disabled for it; (2) the always-loaded handoff and close skills; (3) support skills, loaded on demand from the catalog only.

**Always-loaded modules.** Defined per agent in the module catalog. GAL prescribes that the set exists and that it contains `[prefix]-handoff` and `[prefix]-session-close` (§4.1 row 9); further members are agent-owned.

**Multiple modules allowed.** On-demand loading permitted mid-session (same mechanism, same version gate).

**Module authority.** A loaded module's rules are binding protocol, not reference material. A pointer is not a loading: a rule that a core or module points to binds only when its file is read in the session in which the rule has force.

### 8.2 Version gate

Module `version` compared lexically against core `prompt_version`:

- **module < core → HALT.** Receipt: the halt question §4.3 step 6 carries — `GAL halt: Modules — ` followed by the question that names the module, both versions, and asks whether to continue with possibly stale rules, in the interface locale (§6.6), on one line. The question is an emit: its inventory row, keyed `version_gate_question`, is a substring of the step 6 string — the part that follows the module name — not the whole string, and the key comment stands beside the string in the template. Nothing written after the question. [operator]'s next message decides. **Confirmation → load the module and continue** ([operator] has accepted the staleness; note it in the `Modules:` line as `[name version ⚠ confirmed]`). **Without confirmation → do not load the module, run the session with core only.** Where a [session-start function] has already answered the module's text (§4.2), "load" reads "follow": the template says "follow the module" and "do not follow the module", and the two mean the same here.
- **module ≥ core → PASS.** A module newer than its core passes because independent module bumps are permitted ([module versioning rules] rule 2); that the newer module is compatible with the older core is not gated — the atomic bump is the synchronization point (rule 4). The gate measures staleness in one direction only: `≠` produced a false positive on every independent bump, `<` catches only the module that was not updated when the core was (rule 3).

Anti-pattern: asking the question and then rationalizing past it in the same response. The question is the last thing the agent writes.

Independent module bumps permitted per [module versioning rules]. Atomic bumps ([version-bump tool], per agent) synchronize all.

**Who compares.** At session start, the [session-start function] where the instance has one (§4.2): it reads the two YAML fields and marks the module, and the model halts on the mark. Without one, only the model: the gate above is executed by the model reading two YAML fields — it is protocol text, not a measurement, until a [receipt parser] parses the `Modules:` line of the receipt against the files. Scripts that compare the two versions at other points — on the files, or at commit — are named in the [tool appendix]; they measure the files, not what a session loaded. §1.2 row 1 lists the gate as an instrument with that caveat.

**Session agent.** The same gate compares each skill's `version` against the session agent's `prompt_version`, with the same rule and the same halt question; the result stands on the `Skills:` line. A step agent has no gate: it loads nothing but its own file, and it is bumped with its session agent (§7 points 2 and 3).

### 8.3 Fail-fast

| Condition | Response | Receipt |
|---|---|---|
| Module not found | HALT | `GAL halt: Modules — [file] not found` |
| Queue post claimed, but it names no loop skill | HALT | `GAL halt: Skills — no loop skill named` |
| Skill not found | HALT | `GAL halt: Skills — [skill] not found` |
| Version gate fails | HALT (confirmation fallback §8.2) | The §4.3 step 6 halt question, `GAL halt: Modules — ` + question (§8.2) |
| Target ≠ AGENT_IDENTITY | HALT | `GAL halt: Handoff — target [X] ≠ [AGENT_IDENTITY]` |
| [version registry] mismatch | WARN | `Core: [ver] · [version registry name] ⚠ (repo: [Y])` + warning text per §4.3 step 4 |
| No route to the current core independent of the copy checked (§4.2 G2) | HALT | `GAL halt: Core — no independent route` |
| Connector unreachable (an agent that reaches the repository through one) | FALLBACK | Read [fallback instructions] |
| [agent directory] dirty | WARN | `HEAD: [hash] · [agent directory] dirty ⚠` |
| HEAD ≠ Last commit | WARN | `HEAD: [hash] · ≠ Last commit [expected] ⚠` |

A fallback path runs every gate the primary path runs, or forbids what it cannot measure.

### 8.4 Context isolation

1. **Extension, not modification.** A module extends the core. Never modifies, overrides, or removes.
2. **Core wins.** Conflict → core's version applies.
3. **Single-source rule.** Every rule in exactly one file. Others reference.

## 9. Conformance Classes

An agent — harmonized or new — is green only when every class below passes on every component it applies to (§9.1). Each class states what it measures, what input it requires, what passes, and what never passes. No class names a tool: the [tool appendix] declares which tool implements which class (§10). A tool that meets a class's pass condition while doing something on its never-passes list does not implement the class.

### 9.1 Scope and independence

**Measures.** That §9.3–§9.6 have run on the whole agent.

**Input.** The agent's full surface: the core and every module or skill in its catalog. Each step agent of an implementation agent is measured as an agent of its own.

**Passes.** Every class passes on every component it applies to, and each class reports its own outcome per component — exit status, units counted, rows read. A component outside a class's input (§9.4), or one on which a class's outcome is "does not apply" (§9.6), is named in that class's report with that outcome; it is never left out of the report, and neither outcome is ⊘.

**Never passes.** In addition to §9.2:
- a core that passes while one of its modules is unmeasured;
- one class standing in for another — the classes answer different questions, and a pass on one says nothing about the others;
- a structural change whose meaning of green is defined after the run rather than before it;
- a self-reported list of classes run. A list that says "run" without each outcome cannot be failed, and so does not count.

A component whose only change is its version is compared byte for byte with its pre-state and attested as unchanged; it needs no other class.

### 9.2 Acceptance rules

These rules hold for every class. A class's never-passes list adds to them and never relaxes them. The list is closed: a new rule enters only when one of these leaves (§10).

1. **An empty measurement is a failure, not a result.** A check that counts zero of something the surface plainly contains has most likely measured the wrong thing. It stops and names what it scanned and where; it never reports the zero. *Case: a provenance check reported "0 documents with evidence" because it read a directory that did not exist where it ran. The output was well-formed and wrong.*
2. **Not observed is not observed absent.** What a check did not measure is reported as its own outcome (⊘), and ⊘ is never green. A registered deviation is ⊘, not a pass. *Case: a file carrying key comments passed a two-direction key check because its inventory scope held no rows — the comments were present and nothing protected them.*
3. **An attestation holds against its inputs, not only its subject.** It names the state of every input it read and lapses when any of them changes, with one exception: a [reviewer]'s `yes` holds over later changes that only fix findings the same round named (§9.7). *Case: a recorded before/after check on a file could not be reproduced a day later; the inventory it had read was changed after the attestation, in the same round.*
4. **An approval list is read row by row.** Every row that authorises a change is read by someone other than its writer, and the reading records what was read, not only that it was. An unused row is a failure: it authorises a change that may arrive later unnoticed. *Case: a row type the checker accepted without a reader let an inserted section pass with none of its content measured.*
5. **No role reviews its own work.** The author of a change is a role, not a session or a model: the same role in a new session is still self-review. The one exception is the reviewer's own surface, under the conditions in §9.3 § Approved-change list governance p. 4.
6. **A gate never stands before its only remedy.** When a tool's output is the only way to satisfy a gate, the gate may not stop the run before that tool has produced it. *Case: a presence check aborted the comparison before the step that writes the approval list — the one list that would have satisfied the check could never be produced.*
7. **An ordering that directs work is checked against an independent method.** A count can be right over the wrong population and look identical to a correct one. Before a ranking decides what is done first, its top entries are reproduced by a second method; if the orderings diverge, the selection is wrong. *Case: a verification queue of plausible size ranked entries by a pattern that missed whole numbers and matched an abbreviation, so the entries that mattered most never entered it.*

### 9.3 Invariant loss

**Measures.** Whether every invariant of the pre-state is still present in the post-state.

**Input.** The pre-state as committed (§ Archive provenance), the post-state, an inventory of what counts as invariant, and approval lists for additions, removals and structural change.

**Passes.** Every difference is authorised by a list row, and every row has been read under § Approved-change list governance.

**Never passes.** In addition to §9.2:
- zero matched sections between pre-state and post-state;
- a sub-check skipped (⊘) without the [reviewer] reading, and saying in the findings, what it did not measure — a skipped placement check is read section by section, pre-state against post-state, to establish that no behavioral rule moved to a weaker section or was dropped; this is stated here, not left to happen;
- a fall in the file's total of any normative marker without an approved row that the [reviewer] has read, recording the old and new count and where each lost marker went (relocated, replaced by a stronger form, or dropped).

#### Archive provenance

The pre-state is the committed file, retrieved from version control — never the working tree. A pre-state taken from an edited working tree records the post-edit state under the old name and measures nothing. A file new to version control has no committed state and falls back to the working tree; any other failure to retrieve the committed state stops the run. A file that stands in a repository of its own — an implementation agent's file in its product repository — is retrieved from that repository, as committed there.

#### Structural change

A harmonization that re-levels headings, adds invariant sections or introduces interface keys the pre-state never carried changes the structure on purpose. What counts as green for such a run is declared before the run (§9.1): which sub-checks are skipped, and what replaces them. A skipped sub-check is read by the [reviewer] as §9.3's never-passes list says. A per-section count that can no longer be compared is replaced by a whole-file count with tolerance zero — a marker that appears five times in the pre-state and nowhere in the post-state is lost even if the five sat in a section that was renamed.

#### Approved-change list governance

1. An unused row in any approval list is a failure, not a warning. A stale row authorises a change that may appear later without being noticed.
2. The lists are written by the [harmonizer]. Before the outcome counts, the [reviewer] reads **every row of every list** — none is self-attested, and a row type the checker accepts without a reader is an unguarded door. Each row is read against what it authorises: an addition against the section it enters, a removal against the pre-state to establish that what leaves is not a rule, a size change against the lines added or removed, an inserted section against its own content, a marker-total row against the markers lost and gained. The reading is recorded in the [reviewer]'s findings and carries, per row, what was read, not only that it was:
   - (a) the scope the row claims against the scope the file carries — a row that authorises 40 lines for a section of 60 authorises the section, not its size;
   - (b) the invariant tokens and normative markers the row introduces, listed, where nothing else in the run measures them;
   - (c) a verdict. For an addition or an inserted section: the change belongs where the row says, or it is a rule that moved in from elsewhere, which is a relocation and is read against its origin rather than as an addition. For a removal: the text leaving is bookkeeping — history, tool detail relocated to the [tool appendix], or a rule restated elsewhere, with the place named — or it is a rule leaving, which is a loss and blocks the outcome however the row is worded.

   The [harmonizer] proposes, the [reviewer] verifies.
3. **An attestation handed on carries its material.** Whoever leaves an attestation to another party — the [reviewer], or the [owner] for intent — sends in the same message: the diff or rows to be judged (inline, or an exact path plus lines), what each list or row means in one sentence, and one yes/no question with what a yes leads to. It also names the decisions the sender took itself and, for each check it ran, what that check did not prove. For standard text or an architecture contract the sender may add a short comprehension test: a question the [owner] answers before attesting. Naming a directory or a file is not the material; an attestation requested without it is not requested.
4. **The reviewer's own surface.** The [reviewer] does not attest lists or run the §9.5 review for changes to its own core and modules. For that surface the [architect] does, under four conditions, all required: (a) a different session from the one that wrote the change; (b) the §9.5 findings table written to a file, one row per changed rule, with verdict and basis; (c) the [owner] confirms intent with material per p. 3; (d) the reviewer's own surface only — for every other agent the [reviewer] attests as above. Registered in the [architect] core § Agent Boundary Rule.

### 9.4 Structural conformance

**Measures.** Whether a file follows the skeleton: its sections and their order (§4.1), invariant text byte for byte (§4.3, §4.4), and the header contract (§5). A run that also measures key/string integrity leaves that outcome to §9.6.

**Input.** The reference blocks, as held in the [tool appendix] (§4.3, §4.4) — the complete set: the §4.3 template for each kind of agent, and the §4.4 close trigger, retro format and session-close skeleton blocks — the registered deviations beside them, and the candidate file. A candidate for the skeleton — sections, their order and invariant text — is a file this standard defines a skeleton for: a core, a session agent's included (§4.1, §4.3, §4.4 close trigger and retro format); a session-close module or close skill (§4.4); or a step agent's file (§4.6). Every other module or skill carries no skeleton here and is outside that part of the class; the handoff module's skeleton belongs to the [handoff standard]. The header contract (§5) has no skeleton and applies to every component: every core, module, skill and step agent file is a candidate for it, whatever its content. A registered agent's file is a candidate in its own repository, and the tools read it there.

**Passes.** Zero failures in this class's own checks, **and** §9.6 passes for the same file or does not apply to it (§9.6).

**Never passes.** In addition to §9.2:
- any reference block of the complete set not found where the [tool appendix] holds it — a partial set fails however many blocks were found — or zero candidate files;
- a candidate checked against fewer reference blocks than the standard defines for its kind;
- a registered deviation (§4.4) counted as green;
- a registration that matches nothing in a run that opened its file;
- a module left out of the header-contract measurement because it is outside the skeleton part.

A before/after comparison cannot stand in for this class: a file compared against a skeleton with fewer sections measures nothing about conformance (§9.1).

### 9.5 Adversarial semantic review

**Measures.** Loss, weakening, strengthening, relocation and conflict of behavioral rules, and rules added without a counterpart. A reformulation can keep every keyword and change what the rule means; §9.3 and §9.4 cannot see it.

**Input.** The pre-state and the post-state of the whole agent, core and every module — and the files the agent is bound by, read against the change for rules whose meaning it touches (Q2). Those files are the ones the agent's own files name: every path in the core's § Key Paths and every standard, contract or shared file a sentence in the core or a module cites. A file named nowhere in them does not bind the agent. An implementation agent is also bound by the Governed Implementation Pipeline (GIP) and by its entry in the [boundary contract], whether or not its own files name them.

**Passes.** Zero rows with verdict `weakened` or `lost`, and every row carries cited text and a verdict — with a justification where the verdict requires one.

**Never passes.** In addition to §9.2:
- review by the role that wrote the change (§9.2 rule 5), except under §9.3 § Approved-change list governance p. 4;
- text excluded from review without being byte-matched by §9.4;
- a findings table without cited text.

Runs once per agent, after §9.3 and §9.4 pass. The [reviewer] reads the pre-state files (core + every module) and the post-state files side by side and answers five questions:

1. **Loss.** Is there a behavioral rule in the archive that is absent from the live files — the core and every module? A rule that lived under a heading that was removed, inside inline prose that was restructured, in a section whose content was relocated to a module without being preserved there, or in a module that dropped it without any other file taking it up.
2. **Reformulation.** Has the meaning of an existing rule changed — through its own wording, or through text elsewhere that governs it: a new sentence or point that qualifies it, a definition or list it depends on that was removed or narrowed, or text in a file the agent is bound by? The rule is the row even when its own text is untouched, and it may stand outside the agent's files — in a standard or shared file the agent is bound by; the row's archive and live locations then name that file. "Do not proceed" → "STOP" is equivalent. "always verify" → "consider verifying" is a weakening. "MANDATORY" → "recommended" is a weakening. A change that makes the rule stricter — everything it required is still required, and something it permitted no longer is — is a strengthening. A change that tightens one case and relaxes another is a weakening. Heading-level changes (H2 → H3) and section reordering are structural, not semantic — they do not count unless the rule's text, or text that governs it, changed.
3. **Relocation.** Rules that moved between files of the agent — core to module, module to core, or module to module — do they survive with the same semantics where they now stand? A rule the archive already delegated to another file via a pointer (e.g. "See the module X. All Y rules are there.") is expected and requires no attestation beyond confirming the destination preserves it. A rule that was ONLY in one file and now lives ONLY in another is a relocation that the [reviewer] must attest: the origin text and the destination text are read side by side, the semantic equivalence is confirmed, and the finding is recorded. Equivalence includes loading: the destination is loaded in every situation in which the rule has force; a destination that misses one is a weakening.
4. **Conflict.** Does a live file of the agent — the harmonized core, a new invariant section, or a module — contradict another of its files? The criterion is whether this change wrote either side, not how the text is worded. If one side is text the change added or altered — a new module, a skeleton-generated step, a new sentence — and it instructs or permits something a rule on the other side forbids, that rule is relaxed: it is answered under Q2 with the forbidding rule as the row, whether the text is written as an exception ("X does not apply when Y") or as a step ("commit path P" where the core's MCP Routing excludes P). If both sides are unchanged from the archive, the contradiction predates the change and is a conflict — the review surfaced it, the harmonization did not cause it.
5. **Addition.** Is there a behavioral rule in the live files with no counterpart in the archive? Q1–Q3 start from a rule in the archive and Q4 from a pair of files; none of them has a row for it. An addition is read against the rules in force that it touches. A rule that adds an obligation, or narrows what the agent may do, is an addition. A rule that relaxes an existing rule — an exception to it, a newly permitted case, a lower threshold, a further basis for passing — is not an addition however new its text is: it changes what the existing rule means, and is answered under Q2 with that rule as the row. A rule that entered from another file of the agent is read under Q3, against its origin.

The [reviewer] produces a findings table:

| Rule (short description) | Archive location | Live location | Cited text | Verdict | Justification |
|---|---|---|---|---|---|
| [rule] | [file:section — or `—` for an addition] | [file:section] | [key phrase from the text] | identical / equivalent / strengthened / relocated / added / non-rule / weakened / lost / conflict | [required for equivalent, strengthened, relocated, added, conflict] |

**Verdicts:**
- `identical` — verbatim same text (heading level changes permitted), and no text elsewhere that governs the rule has changed its meaning (Q2).
- `equivalent` — wording changed but meaning preserved. Justification column states what changed and why it is equivalent.
- `strengthened` — the rule's meaning is stricter in the live version: everything the archive rule required is still required, and something it permitted no longer is. Justification column cites what the archive permitted that the live rule does not, and states that nothing it required was dropped. A change that also relaxes any case is `weakened`, not this. Does not block.
- `relocated` — rule moved between files of the agent (Q3), with the same semantics and loaded in every situation in which it has force. Justification column cites the origin text, the destination text, and the line of the core's § Session Start Protocol that loads the destination.
- `added` — rule in the live version with no counterpart in the archive, relaxing no existing rule (Q5). Justification column names the obligation it adds, the rules in force it touches, and why it relaxes none of them. Does not block.
- `non-rule` — explanatory text, clarification, or formatting that carries no behavioral obligation. Drop is permitted.
- `weakened` — rule's meaning is weaker in the live version. **Blocking.**
- `lost` — rule absent from live version and not relocated. **Blocking.**
- `conflict` — a live file of the agent contradicts another of its files and both sides are unchanged from the archive (Q4). If the change wrote either side, the forbidding rule's row is `weakened`, not this. **Advisory** — it must be fixed, but it does not block this class: the conflict lies in the combination, not in the harmonization itself.

**Scope.** Agent-owned content within each file, and the rules outside the agent that Q2 reaches. Invariant text (§4.3 template, §4.4 close trigger, session receipt, retro format) is byte-matched by §9.4 and excluded here — the [reviewer] does not re-verify text that is mechanically identical. A component whose only change is its version needs no row (§9.1).

**Findings.** Each finding states where it is (file, section and cited text — never a line number alone), its source, how it was verified, the invariant it breaks, and a test that tells holds from does not hold. The [reviewer] assumes the change is wrong until it has measured otherwise; a sender's pass is not a pass.

**Verdict boundary.** Only the criteria the handoff names decide the round's verdict; everything else is advisory. A `yes` names its basis — the stop rule, or the handoff's closure criterion — and a checkpoint left unread blocks it. The summary lists every checkpoint with its outcome.

**Stop rule.** A round with no blocking finding, after a round with no blocking finding, closes with `yes`; what remains goes to a follow-up item.

**Fence.** The findings name what the fix must not touch. A fix that touches files outside the findings' places names them.

**Repetition.** The same invariant broken in two rounds is one finding about how the invariant is enforced, not two about its instances. The [reviewer] also reviews the fixer's method: whether the fix built the invariant or the example (§9.8).

**Timing.** This review runs in the same [reviewer] round as the final §9.3 check, not a separate round, and the [reviewer] handoff for the agent's exit code names it as in scope.

### 9.6 Key/string integrity

**Measures.** That every interface key in a file resolves to an inventory row in the file's locale whose string stands on one line in the file (§6.6 rule 4 placement), and that every keyed inventory row whose scope includes the file has its key comment in the file.

**Input.** The file, the inventory, and the selected locale. The class covers every component of the agent's surface.

**Passes.** Both directions hold.

**Does not apply.** A third outcome, distinct from a pass and from ⊘: the file's scope resolves, the inventory holds zero keyed rows for it in the selected locale, **and** the file carries zero key comments. Both populations are measured and both are empty — there is nothing to key and nothing unprotected. A core never takes this outcome: the §4.3 template carries interface strings, so a core with zero keyed rows in scope is an empty measurement (§9.2 rule 1) and fails.

**Never passes.** In addition to §9.2:
- N > 0 keyed rows in scope and zero key comments in the file — a vacuous pass;
- zero keyed rows in scope and one or more key comments in the file — the comments are present and nothing protects them (§9.2 rule 2); this is a failure, never "does not apply";
- zero keyed rows in scope (⊘) counted as a pass, or counted as "does not apply" without the key comments having been counted;
- zero inventory rows for the selected locale;
- a file whose scope cannot be resolved — an unresolved scope and a resolved scope with no rows are different outcomes and stay distinguishable;
- an approximation, such as a language heuristic over prose, counted as the gate;
- a string that has left the files but remains in the inventory.

### 9.7 Review rounds

It protects against review that never ends, against a change closed with a blocking finding open, and against approval that lapses with no change of meaning.

1. A change gets at most two rounds. After the second without a `yes`, the [owner] decides: close with the open advisory findings, each carried by a backlog item that names it, or run a third. A blocking finding is never carried: while one is open after the second round, the [owner] decides after each round whether to run another or to withdraw the change. A [contract] is the exception: it does not become canonical without an approving full audit of its current version ([contract standard]).
2. A `yes` holds over later changes that only fix findings the same round named (§9.2 rule 3); any other change resets it.
3. A change that rewords and adds or removes no rule, gate or check takes one reading round, which still answers Q1 and Q2 of §9.5.
4. A factual error found after approval — a statement that does not match what is built — is corrected in one bounded extra round over the changed places and what depends on them. It does not reopen the text and is not a third round.
5. A change merged without its review is a bypass: it is logged, and reviewed before anything else changes the same surface. Where it cannot be determined whether a change was reviewed, it was not.

### 9.8 Before review: the producer's duties

It protects against fixes that repair the example and relax a case nobody looked at.

1. **Fix the invariant.** A fix to a finding quotes the finding's invariant and enumerates the class it covers from the source — every case, path, producer or state its words cover, read from the rule text and, where a tool decides the answer, from the tool's code — and checks the fix against each member. It adds a test case of its own: a member of the class the finding did not name.
2. **Trace what the change relaxes.** Before a change to a prompt, module or standard goes to review, the producer reads it for what it relaxes: each case it narrows, merges or removes, against every rule that names the same step, tool, event or field; each sequence it changes, walked as if the session ended after each step; and, when a concept changes, every statement, producer and consumer of it, its empty set and its extremes. A change that tightens one path and relaxes another is a weakening (§9.5 Q2).
3. **Build a check only against a measured failure.** A new check, gate or validator answers a failure that happened, named by its retro entry, finding or backlog item. A change to an existing check counts what the check accepts and rejects from its source before the fix, and adds a case that tries to get past it, drawn from the artifact the check reads, never invented.
4. **Check the whole.** Before handing over, the producer runs the reviewer's checklist over the whole document, not only over the change.

## 10. Maintenance and History

1. **The standard changes only when a class changes.** A [reviewer] finding about a tool lands in the [tool appendix] or in the tool — never here. What costs a [reviewer] round is the question *does this finding change a class?*, not the finding itself.
2. **Every normative change bumps the version and is reviewed** by the [reviewer] before it counts. The same holds for the [tool appendix] where it holds the instance's invariant text and its registered deviations (§4.3, §4.4): a change there changes what the cores and modules are measured against, and it bumps the appendix's version. Adding a registered deviation (§4.4) is a normative change.
3. **Classes and tools are bound by declaration.** The [tool appendix] names, per class, the tool that implements it, and is versioned on its own. A tool change changes the appendix; the standard is touched only under point 1.
4. **History lives in version control.** Every prior text of this file is there. A standard restates none of its history; a third copy here is the one nobody corrects when it turns out wrong.
5. **Tools and their descriptions change together.** A sentence that says what a tool does is read against the tool's source in the change that alters either. Every tool, script and path a prompt names resolves when it is committed, and a name changed in a standard is searched for in the tools in the same change.

