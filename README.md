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

Standards for building software with AI agents, where the agents that write the specification are governed as strictly as the agents that write the code.

Governed Agentic Engineering (GAE) was developed by Jonas Maandi Wallin through the engineering of Runapp. He established the framework's governing principles, requirements and architectural direction. AI agents working in governed roles designed and built the architecture that implements them, under his direction and final authority.

Runapp is the reference implementation: the system in which the methods, controls and verification practices were developed, applied and measured. The same engineering effort also produced the QDOT plan-quality model and the simulator used to investigate and validate system behavior.

- `standards/`: the standards. Each one names no installation; an installation binds them in its own appendix.
- `starter/`: how to set them up in your own repository. Start with `starter/README.md`.
- `AGENTS.md`: the same overview, written for an AI agent that reads this repository.

## Try it

Open a coding agent in your repository, paste the link to this repository, and ask it what this is. If you want it, ask it to install GAE. It fetches a tagged release, checks it against `SHA256SUMS`, and walks you through the setup.

## Releases

Each release is a tag. `SHA256SUMS` lists every file under `standards/` and `starter/`, so a copy can be checked as unchanged. Report what did not fit your domain as an issue; do not edit your copy.

## License and attribution

Text, including the standards, the starter kit and the templates: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Code, including the hook scripts: MIT. Both texts are in `LICENSE`. Every file carries its own header with license, editor and attribution, so a copy that travels outside this repository still says where it came from.

A file you write from a template is your own; it does not inherit the license. The standards you copy stay under CC BY 4.0, attributed to Jonas Maandi Wallin, and your instance appendix names the release you copied them from.

Each document also carries an `ai_disclosure` block: AI agents drafted the text and ran the measurements under the editor's direction, and the block says which roles were done, which were checked, and which are still pending. The editor takes full editorial responsibility for what is published.

Contact: [Jonas Maandi Wallin on LinkedIn](https://www.linkedin.com/in/jonasmaandiwallin).
