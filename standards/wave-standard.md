---
document_title: "Wave Standard"
version: "v0.3"
status: "draft"
created: "2026-10-14"
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
path: "standards/wave-standard.md"
---

# Wave Standard

## 1. Purpose and scope

An agent system whose work runs over many items and many sessions has to know what waits for what. When that knowledge lives in session handoffs, it is superseded with them. When it lives in a hand-kept plan, the plan starts carrying status, and the status goes stale. Then finished work stands as open, an open condition that has been met stands as waiting, and each session decides the order again from the start.

This standard binds the fields that order the backlog, which the Backlog Standard leaves free (Backlog Standard §7). It defines the node, the edge, the done condition, the wave that groups nodes, and the sweep that reads them.

The Backlog Standard owns the item, its statuses and its lifecycle. The GIP standard owns the [queue] and the order of implementation posts in it (GIP §4.3, Dependencies; §5.1, Runs in a row). This standard owns the order between nodes and how that order is read. A queue post can be a node. Its state is read from the [queue], never written here.

Four properties follow:

- **Order, never status.** An edge and a done condition say what would make a node done and what waits for it. Whether it is done is read from a live surface at the moment of reading (§4) and is never written in an item or a wave.
- **The waiting side writes the edge.** A node names what it waits for. Nothing has to be edited when a blocker finishes, and so nothing can be forgotten then.
- **The order is read, not kept.** A plan of a wave is a projection of its nodes' fields (§6), produced by the [wave sweep] when it is read. A stored copy is a snapshot of the commit it was made from.
- **Unread is not done.** A condition the sweep cannot evaluate is reported as not measured. It never counts as done, and it never counts as not done.

### 1.1 Placeholders

| Placeholder | Meaning |
|---|---|
| [system] | The installation the standard is applied in |
| [backlog item], [backlog item ID] | As in the Backlog Standard |
| [item store], [closer] | As in the Backlog Standard |
| [queue], [queue post ID] | As in the GIP standard |
| [surface set] | The closed set of live surfaces a done condition may read (§4.1) |
| [node declaration] | The form a part of an item takes to be a node (§2.2) |
| [edge field] | The item field that holds a node's edges (§3) |
| [done field] | The field that holds a node's done condition (§4) |
| [wave field] | The field that places a node in a wave (§5) |
| [wave sweep] | The tool of §7 |
| [architect] | As in the GAL standard |
| [instance appendix] | The document that binds this standard's placeholders to one installation |

## 2. The node

### 2.1 An item is a node

Every [backlog item] is a node, with its [backlog item ID] as the node's ID. An item does not have to declare anything to be a node. An item without an [edge field], [done field] or [wave field] is a node with no edges, the default done condition (§4.2) and no wave.

### 2.2 A part of an item as a node

An item whose parts are finished at different times declares each such part as a node with the [node declaration]. A part-node's ID is the item's ID and a name unique within the item.

- The [instance appendix] binds the [node declaration]. A tool reads it without reading prose, and a declaration it cannot read is a hard failure (§7), never a node that is left out.
- A part-node carries its own done condition (§4). It has no default, because an item's status says nothing about one of its parts.
- An item with part-nodes stays a node itself. It is done when its default condition holds, and its parts do not close it.

### 2.3 What is not a node

A finding with no item ID can stand in a wave (§5.2, Parked) but is not a node, since nothing can wait for it. When something has to wait for it, it gets an item first (Backlog Standard §4.1).

## 3. Edges

- A node names the nodes it waits for in its [edge field]. That is the only edge. The reverse relation, what a node blocks, is derived from the edges and never written.
- An edge names a node by its ID: an item, a part-node (§2.2), or a [queue post ID] when the node is a queue post.
- A node is **waiting** while at least one node it names is not done (§4). It is **ready** when every node it names is done and it is not done itself.
- An edge to a node that does not exist is a defect in the item that names it. The [wave sweep] fails on it (§7).
- An edge to a superseded item is not a done blocker. An item is superseded when it is closed as superseded or names the items that carry its work (Backlog Standard §4.4), whatever its status and whatever its [done field] says. The carrier of its work is not known to be done, so the sweep reports the edge as stale and names the carriers, and never reads the item's own status or condition in their place. The waiting item is edited to name the carrier. An edge to a queue post that ended without being done (superseded or reverted, GIP §6) is stale in the same way.
- Edges form no cycle. A cycle is a defect, and the sweep fails on it and names every node in it.
- The other relation fields of the Backlog Standard §7 (`parent`, `related` and the like) carry no order and stay free text. The [instance appendix] names the fields it reads as edges in older items, if any, and how each is read until it is rewritten. A field it does not name is not an edge.

## 4. The done condition

A node's [done field] holds a predicate. The predicate names one surface from the [surface set] and a condition the [wave sweep] evaluates against that surface without judgement.

### 4.1 The surface set

The [surface set] is closed. The [instance appendix] binds each class to a surface, or names it as not bound in that installation. Every bound surface must be readable live at the moment of the sweep:

| Class | What it reads |
|---|---|
| item class | whether a [backlog item] is in the closed class, and with which status |
| queue | the state of a queue post (GIP §6) |
| document | a document's version, or its last review |
| registry | a value or key in the registry |
| repository | whether a commit is on a branch of a repository |
| measurement | a value in a stored measurement |

A predicate that names a surface outside the set, or a class the [instance appendix] has not bound, is a defect in the item: no reader can evaluate it, so a node carrying it could never be done. The sweep fails on it and names the node. A new class enters the set only through a change of this standard.

### 4.2 The default condition

An item node with no [done field] is done when the item is in the closed class with a status that means the work was done. A superseded item is not done, whatever its status (§3). A queue post node is done when the post is done (GIP §6). Neither default needs to be written.

### 4.3 Rules

- The predicate is written when the node is written or when its edge is first named, by the agent that writes the item. It is stable: it changes only when what would make the node done changes, never because the node became done.
- The outcome is never written, neither in the item, in a wave nor in a handoff. A sentence such as "done since …" about a node is a claim, and the sweep is the measurement.
- **An item whose condition holds while it is open** is reported (§7). Either the item is closed, or the condition was wrong and is rewritten. This is the failure the standard exists for: finished work that stands as open. A part-node is not reported this way: its item's other parts may still be open (§2.2).

## 5. The wave

A wave is a named set of nodes that belong to one line of work and are read together.

### 5.1 When a wave is opened

A wave is opened when a line of work has nodes in more than one item and their order matters to the next session. A single item with part-nodes needs no wave.

### 5.2 The wave item

A wave is a [backlog item] whose type marks it as a wave. Its ID is the wave's ID. Nodes join it through their [wave field]. Its body holds four sections, and only the second is generated:

1. **What the wave is.** Its tracks, each written out on its own, with the pairs of tracks that must not be merged named. A track is a name a node carries beside its wave, for work of one kind (building an instrument and using it are two tracks).
2. **Path.** The projection of §6, produced when the wave is read and never written by hand. A stored copy carries the commit it was made from.
3. **Parked.** Work that came out of the wave and does not lie on its path: an item ID with one line on why it is parked, or, for a finding with no ID (§2.3), what was set aside, by whom and why. A parked item is not a node of the wave.
4. **Decided.** Closed decisions about the wave, with dates, so that they are not reopened.

The wave item carries no status of its nodes (§1).

### 5.3 Lifecycle

- The [architect] opens and closes waves. A node joins a wave through its own field, written by whoever writes the node.
- A wave is finished when every node on its path is done. It is closed then through the [closer] (Backlog Standard §4.3), whether or not its parked items are closed: they live on as items of their own.
- A plan of a line of work kept outside a wave item — in a handoff, a resume brief or a process document — does not stand in for the wave. When a wave is opened for that line of work, the plan's order is moved into edges, and the plan says that it is superseded.

## 6. The projection

The projection of a wave lists its nodes in an order derived from the edges, with each node's state as the sweep read it: done, ready, waiting (with the nodes it waits for), or not measured. Nodes that can run beside each other are those in the same layer of the order. The projection is read; it is never edited.

## 7. The wave sweep

The [instance appendix] binds the class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Writes | Reads | Guarantees | Never |
|---|---|---|---|
| Nothing in the [item store], the [queue] or any surface. Its report, and a projection when one is asked for | Every item file, every [node declaration], every [edge field], [done field] and [wave field], and the surfaces the predicates name | Every node read or named as unreadable. Every edge resolved. Every predicate evaluated or reported as not measured. Reported, for all items whether in a wave or not: each **ready** node that has edges, each item whose **condition holds while it is open**, each **stale** edge to a superseded item or an ended queue post (§3), and each wave whose path is done while the wave item is open | A node left out without a report. A condition counted done or not done when its surface could not be read. A write to anything it reads |

**Hard failures.** An edge to a node that does not exist, a cycle, a predicate whose surface is outside the [surface set] or not bound (§4.1), a [node declaration] that cannot be read, a wave with no nodes, and zero items read are hard failures, never reported values. A zero that a broken reader produced looks the same as an empty backlog, and only the failure tells them apart.

**When it runs.** The [instance appendix] names when the sweep runs. It runs at least once at the start of every session of the [architect], since that is where the order of work is decided.

## 8. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
