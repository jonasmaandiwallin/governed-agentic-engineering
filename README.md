<!--
gae-public-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "README.md"
-->
# Governed Agentic Engineering

Standards for building with AI agents, where the agents that write the specification are governed as strictly as the agents that write the code. What they build is either a product that runs without them or a governed body of knowledge that is itself the deliverable.

Governed Agentic Engineering (GAE) was developed by Jonas Maandi Wallin through the engineering of Runapp. He established the framework's governing principles, requirements and architectural direction. AI agents working in governed roles designed and built the architecture that implements them, under his direction and final authority.

Runapp is the reference implementation: the system in which the methods, controls and verification practices were developed, applied and measured. The same engineering effort also produced the QDOT plan-quality model and the simulator used to investigate and validate system behavior.

- `whitepapers/`: what the standards are for and why they are built the way they are, with what was measured in the reference implementation.
- `standards/`: the standards. Each one names no installation; an installation binds them in its own appendix.
- `starter/`: how to set them up in your own repository. Start with `starter/README.md`.
- `KNOWN-ISSUES.md`: what is known to be missing or wrong.
- `AGENTS.md`: the same overview, written for an AI agent that reads this repository.

## What to read

The white papers explain; the standards are the rules. Read a paper to understand a part, and its standard when you need the rule itself.

1. **The overview**, [`whitepapers/governed-agentic-engineering.md`](whitepapers/governed-agentic-engineering.md): what GAE is, its parts, what has been measured and what has not.
2. **The case study**, [`whitepapers/case-study-runapp.md`](whitepapers/case-study-runapp.md): how the method worked in the system it was developed in.
3. **The part you are interested in:**

| To understand | Read | The rules are in |
|---|---|---|
| Which agent may do what, and why the agents that write specifications are governed too | [Agent Roles and Orchestration](whitepapers/agent-roles-orchestration.md) | GAL, Boundary, Handoff |
| The one document format that agents and people both read | [The Canonical Standard](whitepapers/canonical-standard.md) | Contract |
| How a statement in a contract traces back to its source | [Contracts as the Source of Truth](whitepapers/contracts-source-of-truth.md) | Truth Chain, Contract |
| Why the code holds no tunable numbers | [Numberless Code](whitepapers/numberless-code.md) | Registry, Contract |
| Dependencies, evidence and work order as declared graphs | [Graph Architecture](whitepapers/graph-architecture.md) | Contract, Truth Chain, Registry, Wave |
| The tools, hooks and gates that hold the rules | [Harness Engineering](whitepapers/harness-engineering.md) | GAL, Boundary, GIP |
| How work reaches the agents that write code | [Spec-Governed Dispatch](whitepapers/spec-governed-dispatch.md) | GIP |
| The levels of verification and who holds each | [Verification Architecture](whitepapers/verification-architecture.md) | GIP, GAL, Handoff |
| Loops that end, and how the system learns from them | [Loop Engineering](whitepapers/loop-engineering.md) | GIP, GEM |
| What the system remembers between sessions | [Context, Coherence and Memory](whitepapers/context-coherence-memory.md) | GEM, Backlog, Wave, GAL |

4. **To install it:** `KNOWN-ISSUES.md`, then `starter/README.md`, then `starter/ADOPTION.md`.

## Try it

Open a coding agent in your repository, paste the link to this repository, and ask it what this is. If you want it, ask it to install GAE. It fetches a tagged release, checks it against `SHA256SUMS`, and walks you through the setup.

## Status

The standards and the white papers are early work, and each one carries its own `status` and `version`. `status: draft` on every file means just that: the text may still change in a later release. It does not mean unreviewed; every released file has been approved by its editor, and each document's `ai_disclosure` block says which checks were done. The standards were developed in one installation, Runapp, which is not public, and tried in a second installation in another domain. Both were set up by the framework's originator; no outside adopter has installed GAE yet. `KNOWN-ISSUES.md` lists what is known to be missing or wrong.

## Releases

Each release is a tag. `SHA256SUMS` lists every file under `standards/` and `starter/`, and `KNOWN-ISSUES.md`, so a copy can be checked as unchanged; `starter/ADOPTION.md` step 0 says how to check the copies at the paths they are installed under. The white papers are not in it, since an adopter does not install them; each paper carries its own version. The licence and the other files at the root are not in it. Report what did not fit your domain as an issue; do not edit your copy. Before each release, every candidate rule — from the installations, from the issues reported and from `KNOWN-ISSUES.md` — is tested and given one of four outcomes: taken into a standard, merged with another, refused with a reason, or kept in `KNOWN-ISSUES.md` with a direction.

## License and attribution

Text, including the standards, the starter kit and the templates: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Code, including the hook scripts: MIT. Both texts are in `LICENSE`. Every file carries its own header with license, editor and attribution, so a copy that travels outside this repository still says where it came from.

A file you write from a template is your own; it does not inherit the license. The standards you copy stay under CC BY 4.0, attributed to Jonas Maandi Wallin, and your instance appendix names the release you copied them from.

Each document also carries an `ai_disclosure` block: AI agents drafted the text and ran the measurements under the editor's direction, and the block says which roles were done, which were checked, and which are still pending. The editor takes full editorial responsibility for what is published.

Contact: [Jonas Maandi Wallin on LinkedIn](https://www.linkedin.com/in/jonasmaandiwallin).
