---
document_title: "Boundary Standard"
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
path: "standards/boundary-standard.md"
---

# Boundary Standard

## 1. Purpose and scope

A boundary that only an agent's instructions state drifts with the instructions. An agent that does a neighbour's work, because it was asked or because it was quicker, removes the separation that the neighbour's review depends on. This standard defines the [boundary contract]: the one document that states what each agent of a [system] may and may not do. It covers the form of an entry, what an agent does when it is asked to cross its boundary, how work passes from one agent to another, and what a tool that guards a boundary must guarantee.

The GAL standard owns which agents and roles exist (GAL §3), and it requires every agent's prompt to point to its entry (GAL §4.1, the Boundaries section; GAL §7, row 14). The GIP standard owns what each implementation role reads, writes and runs, and it owns the [write gate] in a product repository (GIP §2, §3). The [handoff standard] owns the form of a handoff. This standard owns the [boundary contract] itself.

Three properties follow:

- **Stated once, where it can be checked.** Every agent's permissions stand in one entry in the [boundary contract]. What an agent's prompt says about them is governed by GAL §4.1: row 5 states the surface and points to the entry, and row 7 points to the [boundary contract]. This standard adds no rule on the prompt's text. Where a prompt and the entry differ, the entry holds.
- **Each rule says what holds it.** A rule is held by a [write guard] or another tool, or only by the agent's instructions. The entry says which, so that a reader knows which rules can be broken without anything noticing.
- **Work passes through the [operator].** No agent starts another agent's work on its own. The exceptions are named (§4).

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The system whose agents the [boundary contract] governs |
| [operator] | The person who starts every agent session and carries work between agents |
| [architect] | The agent that maintains the agents' instructions and tools (GAL §3) |
| [agent] | An agent of the [system], of a kind GAL §3 names |
| [boundary contract] | The one document that holds every agent's entry |
| [write surface] | The paths an agent may write, per repository |
| [report path] | As in the GIP standard |
| [decision log] | As in the GEM standard |
| [handoff standard] | The document that owns the form of a handoff between agents |
| [write guard], [write gate] | Tools of the class in §6, and the GIP standard's gate in a product repository |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. The entry

- Every [agent] has one entry in the [boundary contract] before it is first run. An agent without an entry is not deployed.
- An entry has two lists: what the agent **may** do and what it **may not** do. Together they cover what the agent reads, what it writes (its [write surface], per repository), what it runs (tools and scripts), and what it decides.
- A rule that a tool holds names the tool. A rule that no tool holds says so, or the [instance appendix] says it for the whole list. A reader can tell, for each rule, whether breaking it is stopped, detected, or neither.
- An implementation agent's entry follows the role it fills (GIP §2) and adds what the repository requires. An entry may name the role once and list the agents that fill it.
- A retired agent keeps an entry marked as retired, with the date and the agent or process that took over its responsibilities.
- Every [write surface] stands, in addition to the lists, in one machine-readable declaration in the [boundary contract], for the repositories the [instance appendix] names. The declaration and the lists say the same thing there. Where they differ, the lists hold, and the [instance appendix] names the difference until the declaration is brought into line. An agent whose surface lies outside the declared repositories is named in the [instance appendix].

## 3. Crossing a boundary

When an agent is asked to act outside its entry:

1. It declines, and states which boundary the request crosses.
2. It names the agent or process that owns the requested action, and states the request so that the owner can act on it.
3. It does not do part of the work. Partial compliance outside the boundary is still a violation.

A request does not widen a boundary, also when it comes from the [operator]. The [operator] widens a boundary in one of two ways. The first is to change the entry, which is a change to a governance document (GEM §4.3). The second is a recorded exception for one action: the [operator]'s decision, the action, and the boundary it crosses are written in the [decision log] before or with the action. An entry may exclude exceptions for a rule whose purpose they would defeat, as §5 does for a reviewer.

## 4. Work between agents

- An agent hands work to another agent through the [operator], in the form the [handoff standard] gives. No agent starts another agent's session.
- The permitted routes, each as giver, [operator] and receiver, stand in one list: in the [boundary contract], or in the [handoff standard] where a tool reads them there. The other document points to the list and does not keep a second one. A route that names the same agent on both sides is a session boundary: the work stays inside that agent's entry, and the [operator] carries it into a new session.
- Two exceptions are permitted, and the [boundary contract] names each:
  - **Dispatch inside a session.** A session agent dispatches its step agents inside the one session the [operator] started, with fields only, never content (GIP §2).
  - **Reports back.** A session agent reports to the [architect] through the [report path] (GIP §6).
- Any other automatic start of one agent by another is a violation, whatever tool makes it possible.

## 5. Boundaries and review

An agent that reviews another agent's work never changes that work, also when the [operator] asks it to, and no exception under §3 makes it do so. It names the agent that owns the change and states the finding so that the owner can act on it. A reviewer that fixes what it found has reviewed its own work in the next round.

## 6. Tool classes

The [instance appendix] binds each class to a tool for each repository. A repository with no bound [write guard] is declared as such in the [instance appendix], with the rules that then hold only by instruction.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [write guard] | Whether a write falls inside the writing agent's [write surface] | The write, the agent that makes it, the [write surface] declaration | A write outside the surface refused before it lands, with the agent and the path named; a write inside it passed | A write outside the surface passed; a guard that passes everything because it read no surface (a missing or empty declaration); a guard that knows the paths but not which agent writes, reported as guarding per agent |

In a product repository, the GIP standard's [write gate] is a [write guard] for the implementation roles. Its own requirements (GIP §3) come in addition.

**Zero result.** A [write guard] that reads a missing or empty declaration fails closed or fails loudly. It never passes writes by default.

## 7. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A new agent, a retired agent or a changed role changes the [boundary contract] in the same pass as the agent's prompt (§2).
