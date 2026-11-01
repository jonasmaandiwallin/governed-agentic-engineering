---
title: "GAE starter"
version: "v0.6"
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
    scope: "The kit's contents were written from the standards and from a second installation of them, set up from this kit."
    evidence: "The reference installation's backlog, not published."
  - role: fact-check
    status: not-applicable
    reason: "The document cites no external source."
  - role: review
    status: complete
    scope: "Adversarial review of the starter kit at v0.8 in two rounds before its release; the changes in v0.9 in two more rounds; the database templates tested on PostgreSQL 16."
    evidence: "The reference installation's review records, not published."
license: "CC-BY-4.0"
repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
path: "starter/README.md"
---

# GAE starter

GAE (Governed Agentic Engineering) is a family of standards for building software with AI agents. Agents write the specification and the code, and both kinds of agent follow the same rules. A contract is the source of truth, and the implementation is built from it. The agents build the system, but they do not run it: the system itself stays deterministic.

GAE also governs a **knowledge corpus**, where the agents' own work is the deliverable: research, evidence and documents people act on. There every claim points to its evidence, and every deliverable to the contracts it follows. Many installations are both: agents do knowledge work, and changes to the system that holds it are built like any other code.

This starter sets GAE up in your own repository, for your own domain. You need no knowledge of any earlier installation. Your coding agent reads the standards and this starter, asks you what it cannot decide, and writes the installation.

## What you need

- A repository, empty or with code in it.
- A coding agent with file, git and shell access to it. The templates are written and tested for **Claude Code**. On another coding agent, the setup session binds the same classes in your appendix and records what your platform lacks.
- One person who is the **owner**. The owner decides intent and confirms what no agent may decide for itself.
- A description of what you are building: what it does, who uses it, and what it must never do. Half a page is enough.

## Install

Open your coding agent in your repository, paste the link to the GAE repository and ask it to install GAE. The agent:

1. fetches a tagged release, never `main`;
2. checks every file against the release's `SHA256SUMS` before reading it, and tells you which items in the release's `KNOWN-ISSUES.md` bear on your system;
3. copies `standards/` to `governance/standards/` and `starter/` to `governance/gae-starter/`, unchanged, and checks the copies at those paths (`ADOPTION.md` step 0);
4. follows `governance/gae-starter/ADOPTION.md`, and asks you what the procedure leaves to you.

You never copy anything yourself. If the agent cannot reach the network, it asks you to download the release and put the two folders in place; the check against `SHA256SUMS` runs the same way.

Do not edit the copied standards. If a standard does not fit, the agent records the deviation in your own appendix and reports it upstream.

## Starting by hand

If you prefer to start the session yourself, give the agent this prompt, filled in:

```
You are setting up GAE in this repository, in the architect role.
Fetch release <tag> of <the GAE repository's URL>, check it against SHA256SUMS,
and copy standards/ to governance/standards/ and starter/ to governance/gae-starter/, unchanged.
Then read governance/gae-starter/ADOPTION.md and follow it step by step.
Ask me before every decision the procedure marks "owner decides".

Owner: <name>
Write to me in: <language>

What we are building:
<description>
```

## What you get

The setup runs as eight checkpoints, from the intake (CP0) to the first real deliverable (CP7). You attest each one before the next starts, so you see at every stop that what is being built is what you meant. The first thing written is an **architecture contract**: what your system is, attested by you before anything is built.

The setup session writes the following:

- the **architecture contract** and a **contract inventory** of the contracts your system will need;
- an **instance appendix**, which binds every placeholder in the standards to your names, files and tools;
- one **core file** per agent, with its start and close procedures;
- the stores the standards need: backlog, decision log, retro log, handoffs, version registry and boundary contract;
- a **starting backlog**, opened in order, so that what is skipped is visible.

Every tool the standards describe starts as *not built*. Each one carries the failure that would make it worth building. The installation runs on files and instructions until such a failure actually happens.

## Moving to a new release

When a new release is tagged, the agent follows `ADOPTION.md` step 12. Your boundary contract already allows the one write an upgrade needs, at your decision naming the tag. The agent checks the new tag, compares each standard's body with your copy, replaces the copies, and updates your instance appendix in the same change. Your architecture contract changes only on the triggers step 12 point 5 names: a changed standard body that one of its rules rests on, or a standard adopted or dropped.

## Feedback

When the standards could not express something your domain needed, report it upstream. Do not edit your copy: an edited standard cannot be measured against its release.

## License

Text: CC BY 4.0. Code: MIT.
