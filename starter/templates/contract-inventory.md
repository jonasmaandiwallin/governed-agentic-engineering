<!--
GAE starter — template for the contract inventory (ADOPTION.md step 6, Design the corpus).
It lists the contracts the installation expects to need, in the folders the corpus design
gives them. Strike what the system does not need and add what it does; the order of writing
follows depends_on, not this list. The rows below are a starting point for a knowledge corpus;
a product installation replaces the method and output groups with its own domains.
Replace every <...>. Delete this comment block when the file is filled in.

gae-template-header:
  framework: "Governed Agentic Engineering (GAE)"
  originator: "Jonas Maandi Wallin"
  editor: "Jonas Maandi Wallin"
  contact: "https://www.linkedin.com/in/jonasmaandiwallin"
  license: "CC-BY-4.0"
  template_version: "v0.1"
  repository: "https://github.com/jonasmaandiwallin/governed-agentic-engineering"
  path: "starter/templates/contract-inventory.md"
This license covers the template as published. The file you write from it is your own
and does not inherit the license; delete this comment block and the attribution goes
with it.
-->
---
title: "<System> — contract inventory"
version: "v0.1"
status: "draft"
---

# <System> — contract inventory

One row per contract. A deliverable is not a contract: a contract says how something is produced and what it must meet, and a deliverable is produced under it (ADOPTION.md step 6, Contracts and deliverables).

| Group | Contract | Folder | Store | Depends on | Backlog item | State |
|---|---|---|---|---|---|---|
| Governance | System architecture | `contracts/governance/` | system | — (the constitution, from the version after it exists) | | |
| Governance | Constitution: what the system is for and how its work is done; level 1, above every contract (Truth Chain §2.1) | `contracts/governance/` | system | — | | |
| Governance | Data layers and data ownership | `contracts/governance/` | system | constitution | | |
| Governance | Mandate: what the agents may do on the owner's behalf | `contracts/governance/` | system | constitution | | |
| Method | Evidence levels | `contracts/method/` | system | constitution | | |
| Method | Research method | `contracts/method/` | system | evidence levels | | |
| Method | Evidence graph: entries and the relations between them | `contracts/method/` | system | evidence levels | | |
| Method | Priority | `contracts/method/` | system | constitution | | |
| Output | Common spine for every deliverable | `contracts/output/` | system | method contracts | | |
| Output | <One per deliverable surface> | `contracts/output/` | system | common spine | | |
| Output | Presentation form, which the visual deliverables point to | `contracts/output/` | system | common spine | | |
| Engagement | Strategy | <engagement repository> | <engagement> | — | | |
| Engagement | Brand | <engagement repository> | <engagement> | — | | |
| Engagement | Market | <engagement repository> | <engagement> | — | | |

**State** is one of: planned, in review, attested, canonical. A governed value is created only after the contract that states it is merged (ADOPTION.md step 5).
