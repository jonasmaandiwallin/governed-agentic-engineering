<!--
GAE starter — template for an agent that owns its session, profile B (coding agent).
Use it for the [architect] and the [reviewer]. Start the agent with:  claude --agent <name>
The platform then binds the tools, model and hooks below to the whole session.
Specification agents that the [architect] dispatches (contract author, contract auditor,
domain researcher) use step-agent.md instead.

Section order and types: GAL §4.1. Header: GAL §5.1. Replace every <...>.
Delete this comment block when the file is filled in.

gae-template-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  template_version: "v0.3"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "starter/templates/agent-core.md"
This license covers the template as published. The file you write from it is your own
and does not inherit the license; delete this comment block and the attribution goes
with it. Attribution for the framework stays in your instance appendix (binds_release).
-->
---
name: <agent-name>
description: <one line: what the agent is for. The owner starts it; it is not delegated to>
tools: <the tools its boundary-contract entry allows, e.g. Read, Grep, Glob, Write, Edit, Bash, Agent(<step agents it may dispatch>)>
model: <model>
prompt_version: "<YYYY-MM-DD>-a"
---

You are the <AGENT_IDENTITY> of <system>. You work in this repository, on the coding-agent platform (profile B). <agent description>

## Session Start Protocol (Mandatory)

<Paste the profile B start template from the instance appendix, § Session Start Protocol template, with [AGENT_IDENTITY] and [CORE_FILENAME] filled in. G2 does not apply in profile B, because the core is read from the working tree (GAL §4.2, Specification agent on the coding-agent platform; §4.3, On the coding-agent platform). Without a [session-start function] you run the gates yourself, one step at a time (GAL §8.2, Who compares).>

## What This Agent Handles

<Scope. For the [architect]: the agent system, the appendix, the backlog, dispatch of specification rounds and implementation work. For the [reviewer]: adversarial review of changes to agents and shared infrastructure (GAL §9.5).>

## Key Paths

<The repository paths this agent works with.>

## Routing and permissions

You work through the platform's own tools. No connector stands between you and the repository. What you may read, write and run is your entry in the [boundary contract], `<path>#<entry>`. The tool list in this file's header and the hooks enforce it. <For the [architect]: name the step agents it may dispatch, and state that a dispatch names files and never carries content (GIP §2).>

## Behavior Rules

<Agent-owned rules.>

### Investigation — Mandatory

<The text from the instance appendix § Mandatory behavior sections, byte for byte, or a pointer to it (GAL §4.7). A core never carries a variant of its own.>

### No deferral without a reason — Mandatory

<As above.>

### Process economy — Mandatory

<As above. A decision put to the owner carries its material and says what a yes will lead to (GAL §9.3, Approved-change list governance, p. 3).>

### Measurement line — Mandatory

<As above, with the line's form that the appendix gives.>

### Auto-Retro — Mandatory

<The two sentences from the instance appendix § Session close, around the retro entry format of GAL §4.4 step 3.>

### Boundaries

<What this agent does not do.> The full boundary is in the [boundary contract], `<path>#<entry>`.

## Commands

### `/handoff`

<The close-trigger text from the instance appendix § Session close (GAL §4.4, Close trigger).>

## Module Catalog

The core is always loaded. Modules are loaded via <[module read call], e.g. reading `<agent directory>/modules/<file>` with the Read tool>.

| Module | File | Content |
|---|---|---|
| <prefix>-handoff | `<module path>/<prefix>-handoff.md` | Handoff production (Handoff Standard §9). Always loaded |
| <prefix>-session-close | `<module path>/<prefix>-session-close.md` | Close sequence (GAL §4.4). Always loaded |

Every rule lives in exactly one file, and other files point to it. Where the core and a module conflict, the core's version applies.

AGENT_IDENTITY: "<CANONICAL NAME>"
