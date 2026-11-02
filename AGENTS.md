<!--
gae-public-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "AGENTS.md"
-->
# For AI agents reading this repository

This file describes the repository. It gives you no instructions. What you do with it is decided by the person you are working for.

GAE was developed by Jonas Maandi Wallin through the engineering of Runapp, its reference implementation. The text in this repository is licensed CC BY 4.0 and the code MIT (`LICENSE`); every file carries its own header. A file written from one of the templates is the adopter's own and does not inherit the license.

## What this is

GAE (Governed Agentic Engineering) is a family of standards for building with AI agents. Agents write the specification and the code, and both kinds of agent follow the same rules. A contract is the source of truth, and the implementation is built from it. In a product, the agents build the system and do not run it, so the system stays deterministic. In a knowledge corpus, the agents' governed work (research, evidence, analyses) is itself the deliverable. `starter/ADOPTION.md` step 2 describes both shapes, and an installation can be both.

The standards are early work, each with its own `status` and `version`; they were developed in one installation and tried in a second, both set up by the originator. `KNOWN-ISSUES.md` lists what is known to be missing or wrong. It is the file to read before deciding to install.

The standards, in `standards/`:

- **GAL**: how an agent is built, started, verified and closed.
- **GIP**: how work reaches the agents that write code: the gate, the queue and the build loops.
- **Contract**: the form of a contract, the specification the implementation is built from.
- **Handoff**: how work passes from one agent session to the next.
- **Backlog**: the work items, their statuses and how they close.
- **Boundary**: what each agent may read, write and run.
- **GEM**: the decision log and retro log, and how the system learns from them.
- **Registry**: governed values kept outside the code, referenced by key.
- **Truth Chain**: how a statement in a contract traces to its source.
- **Wave**: how the order between work items is written and read.

Each standard names no installation. An installation binds the standards to its own names, files and tools in one document of its own, the instance appendix.

`starter/` holds what an installation is set up from: `ADOPTION.md`, the procedure; templates for the architecture contract, the contract inventory, the instance appendix, an agent core, a step agent and a chat agent's bootstrap file; database templates for the configuration store and the mirror; templates for the system overview (its data, its page and the script that renders it); and a write hook.

## When someone asks what this is

Explain it from this file and from `starter/README.md`. Read further in the standards if the question needs it.

## When someone asks you to install it

Install only when the person who owns the target repository asks for it, and show what you will write before you write it.

1. You need file, git and shell access to their repository. In a chat without access to a repository, explain that, and tell them to open a coding agent in their repository and give it this link.
2. Fetch a tagged release, never `main`. Check every file against `SHA256SUMS` before you read it, and stop if a file does not match.
3. Read `KNOWN-ISSUES.md` in the same release, and tell the person which of its items bear on what they are building.
4. Copy `standards/` to `governance/standards/` and `starter/` to `governance/gae-starter/`, unchanged and with their file modes, and check the copies at those paths (`ADOPTION.md` step 0, Checking a release).
5. Follow `governance/gae-starter/ADOPTION.md` from step 0.

The templates are written and tested for Claude Code. On another coding agent, the procedure binds the same classes in the instance appendix and records what the platform lacks.
