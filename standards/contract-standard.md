---
document_title: "Contract Standard"
version: "v0.6"
status: "draft"
created: "2026-10-12"
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
path: "standards/contract-standard.md"
---

# Contract Standard

## 1. Purpose and scope

This standard defines the form of the documents that carry a system's specification — the [contract corpus]. A document in the corpus is read by agents and by people, and the same text must give both the same answer. Four properties follow:

1. **Deterministic reading.** Structure, cross-references and normative statements leave no room for inference.
2. **Measurable completeness.** The values a contract governs stand in a [registry], and its normative statements are lists that a [completeness gate] can count (GIP §1, Prerequisite).
3. **Traceable truth.** Dependencies, precedence and supersession are declared in metadata, and every document records which version of its text was last audited.
4. **Stable change.** Version lives in metadata, history lives in one log, and the text of a document stays clean between versions.

**Placeholders.** Terms in brackets are bound to concrete names, paths and tools by the system's [instance appendix]. Normative text in this standard names no instance. A rule that holds only in one system belongs in that system's appendix, not here.

| Placeholder | What the appendix binds it to |
|---|---|
| [system] | The system the corpus specifies |
| [contract corpus] | The directory or store that holds the canonical documents |
| [instance appendix] | The document that binds this standard for [system] |
| [title prefix] | The prefix every document title carries, possibly empty |
| [domain taxonomy] | The closed list of valid domain and layer combinations, with their reading order |
| [registry] | The store of governed values, referenced by key |
| [evidence registry] | The store of evidence entries, referenced by ID |
| [implementation unit] | The named units of the implementation a contract can be mapped to (modules, services) |
| [corpus language] | The single language the corpus is written in |
| [change log] | The central log of changes to corpus documents |
| [index] | The machine-generated index of the corpus |
| [audit report path] | Where audit reports are stored |
| [author] | The role that writes canonical documents |
| [auditor] | The role that validates a document against this standard before it becomes canonical |
| [owner] | The person who decides what the reviewers leave open |
| [post-processor], [index generator], [conversion tool], [completeness gate] | Tools of the classes in §9 |

## 2. Document types

The type set is closed. Each document declares exactly one type in `document_type`.

| Type | Role | Section order |
|---|---|---|
| `contract` | States behavioural rules and invariants of [system] | §4.3 |
| `registry` | A contract that also carries structured data tables | §4.4 |
| `clause` | A narrow rule within the boundary of a contract | §4.5 |
| `framework` | Organises a set of contracts | Set by the [instance appendix], or free |
| `appendix` | Calibrates or clarifies a contract | §4.6 |
| `orientation` | Describes [system] for a reader | §4.2 |
| `governance` | Standards, logs and process documents of the corpus itself | Set by the [instance appendix], or free |
| `model-spec` | The public specification of a predictive or adaptive model | §4.7 |

A new type enters through a revision of this standard, not through an appendix.

## 3. Metadata

### 3.1 Required frontmatter

Every document begins with YAML frontmatter. Fields are mandatory unless marked optional.

```yaml
---
document_title: "[title prefix][Document Title]"
document_type: "contract"          # §2
version: "v1.0"
status: "canonical"                # canonical | draft | deprecated
domain: "[domain]"                 # §5
layer: "[layer]"                   # §5
priority: 50                       # 0–100, §6.1
last_updated: "YYYY-MM-DD"
depends_on: []                     # upstream dependencies, §3.2
depends_on_exclude: []             # optional, §7.5
referenced_by: []                  # informational, §3.2
overrides: []                      # §6.1
superseded_by: null                # §6.2
evidence_ids: []                   # optional, IDs in [evidence registry]
implementation_scope: []           # optional, names of [implementation unit]s; the appendix may name the field differently
last_audit: {}                     # §8
audience: "both"                   # orientation only: human | llm | both
---
```

Fields beyond this list are defined in the [instance appendix], never ad hoc in a document.

### 3.2 Field rules

- `depends_on` lists upstream dependencies by slug. An entry the [post-processor] detected automatically carries the appendix's auto marker and is unverified until a person or the [author] confirms it; an unverified entry is not canonical.
- `referenced_by` is informational and carries no authority. The [post-processor] maintains it.
- `evidence_ids`, when present, names entries that exist in the [evidence registry].
- `implementation_scope`, when present, names [implementation unit]s, never file paths. A document that drives no implementation leaves it empty.
- `audience` is mandatory on orientation documents and unused on other types.
- Version is stored in the frontmatter only — never in a file name, a slug or a title.

## 4. Structure

### 4.1 Global rules

- **One H1.** Each document has exactly one H1, `# [title prefix][Document Title]`, matching `document_title`. All other sections are H2 or lower. A change to [title prefix] is applied to the whole corpus by one scripted pass, never by hand.
- **Title Case headers.** `## Core Assertions`, never `## CORE ASSERTIONS` or `## core assertions`.
- **Fixed order.** Where a type has a section order, sections are not reordered, and no section is left empty. Only the contract order (§4.3), and the registry order that follows it (§4.4), lets a section that does not apply be omitted; every other order applies in full.

### 4.2 Orientation

```
## Purpose
## Audience
## Core Principles        (FAQ documents may use ## Overview)
## Scope Boundaries
## Final Position
```

An orientation document governs no behaviour: it carries no invariants, enforcement rules, prohibitions or operational logic.

### 4.3 Contract

```
## Purpose
## Scope
## Definitions
## Core Assertions
## Invariants
## Enforcement Rules
## Prohibited Behavior
## Failure Modes
## Architectural Position
```

### 4.4 Registry

The contract order, with additional H2 sections permitted between `## Core Assertions` and `## Invariants`. The [instance appendix] lists the permitted names; another name needs an appendix change. Additional sections carry data, never enforcement-grade language — constraints stand in `## Invariants` and `## Enforcement Rules`.

### 4.5 Clause

```
## Purpose
## Boundary Definition
## Enforcement
## Failure Condition
```

A clause introduces no new architectural logic and redefines no system invariant, whichever document in the [contract corpus] states it.

### 4.6 Appendix

```
## Purpose
## Context
## Research Basis
## System Implication
## Architectural Impact
## Limitations
## References
```

An appendix introduces no invariant, overrides no contract and defines no enforcement logic. It only calibrates or clarifies.

### 4.7 Model specification

```
## Purpose
## Inputs and Outputs
## Parameters
## Assumptions and Limitations
## Validation Criteria
## Version History
```

A model specification is the public layer of a model. It states what the model takes and produces, which parameters govern it (named, not valued), its assumptions and limitations, and how it is validated. It never contains formulas or equations, numerical coefficients or weights, calibration constants or lookup tables, or step-by-step computational logic — those belong to the implementation. `## Mathematical Formulation` is not a permitted section, and the [auditor] does not report its absence. The [instance appendix] states where model specifications live and the metadata they require.

### 4.8 Prohibitions

- ALL CAPS headers; more than one H1.
- Unstructured paragraphs as the primary carrier of logic.
- Emotional, rhetorical, motivational or metaphorical framing.
- "END OF DOCUMENT" markers.
- Structure carried by inline bold instead of headers or lists.
- Implicit cross-references (§4.10).

### 4.9 Normative statements

Invariants, enforcement rules and prohibitions are written as explicit list items, one rule per item, separate from explanation:

```
- The system must not act on an input whose source is unverified.
- The system must not treat a missing value as zero.
```

A normative statement written as prose cannot be counted by the [completeness gate], and is a finding against the document, not a rule the build can rely on (GIP §1).

### 4.10 Cross-references

A reference to another document uses its full title: `See: [title prefix][Document Title]`. Abbreviated or informal references are not permitted.

### 4.11 File names

kebab-case, reflecting the title, without version numbers or parentheses, and not ambiguous with another file name.

## 5. Domain and layer

Every document declares a `domain` and a `layer`, and the pair is a valid combination in the [domain taxonomy]. The taxonomy is closed in the [instance appendix] and carries:

- every valid combination and its typical use;
- the reading order of the domains, from the most constitutional to the implementation-near;
- any combination rule of the instance (a pair a document may not mix).

Within a domain, documents are read by `priority`, highest first. The full reading order is written by the [index generator] into the [index] and is the canonical reference.

## 6. Relations and precedence

### 6.1 Priority and overrides

`priority` is a governance value, not cosmetic metadata. It sets audit order and precedence in a conflict.

- A document may declare `overrides` only for an explicit partial replacement of another document.
- A document may not declare `overrides` on a document of higher priority.
- Two documents with the same `domain` and `layer` and the same `priority` above 50 are in conflict, and the conflict is resolved before the change enters the corpus.

### 6.2 Supersession and duplicates

- A document with `status: deprecated` has a non-null `superseded_by`, and `superseded_by` names an existing slug.
- No two documents share a canonical name, share domain ownership without explicit layering, or carry the same semantic responsibility. Overlap is resolved by renaming one document, or by deprecating one with `superseded_by` pointing to the other.

The [post-processor] detects the conflicts in §6.1 and §6.2 and reports them (§9).

## 7. Content boundaries

### 7.1 Implementation boundary

A contract states behavioural rules and invariants. Data schemas, field definitions and storage representations belong to the implementation and do not appear in a document body. A contract may state that a thing has a lifecycle or a type; it does not define the fields, types or storage that implement them. Frontmatter is governance metadata and is exempt. Schema content in a body is a violation the [auditor] reports.

### 7.2 Governed values

A numeric value in a body that represents a tunable boundary — a limit, threshold, score, window or cutoff — references its key in the [registry]. A hardcoded tunable value is a violation whether or not the [registry] holds a matching key: without a key the value is both hardcoded and unmanaged, and the fix is a [registry] entry. Definitional constants of the domain are exempt.

### 7.3 Language

The corpus is written in the [corpus language]. Mixed-language text in a body is not permitted. Exempt: metadata values and quoted system-defined identifiers (domain names, slugs, enum values), and comments in code blocks that serve as implementation references.

### 7.4 Change history

A document does not embed its change history. Changes are recorded in the [change log]. Exempt: this standard, the [instance appendix], and the `## Version History` section a model specification carries (§4.7).

### 7.5 Metadata hygiene

Every entry in `depends_on_exclude` matches a slug occurrence in the body; the field exists only to suppress a false automatic detection. An entry that matches nothing is removed.

## 8. Audit tracking

### 8.1 The audit record

Every canonical document carries `last_audit`:

```yaml
last_audit:
  date: none             # ISO date, or none if never audited
  type: none             # none | standard | deep | full
  verdict: none          # none | approved | needs-work | coherent | needs-review
  version: none          # the document's own version as read at audit time
  patch_revision: none   # patch documents only — audit round, integer from 1
  auditor_version: none  # optional — version of the [auditor]'s instructions
  ref: none              # optional — the work item the audit belongs to; the appendix may name the field differently
```

`date: none` means never audited. Omitting an optional field is not a violation.

### 8.2 What the record means

- `version` records which text was examined. A record whose `version` differs from the document's current `version` describes a superseded state and is not a basis for promotion. A record written before the [instance appendix] required `version` reads as *audited version unknown*, never as a match. Its missing `version` is not a violation. Whether the audit it records covers the document's current text is the [owner]'s decision, never the [auditor]'s or the [author]'s; the decision replaces only that comparison (§8.4). A record with `date: none` records no audit, whatever its `version` says.
- A patch document has no version of its own; `patch_revision` distinguishes its audit rounds, incremented each round whatever the verdict.
- **Divergence exemptions.** A change class the [instance appendix] lists as exempt bumps `version` without an audit, and the divergence is correct; it is never resolved by editing `last_audit.version`. A governance document without a `version` field skips the comparison. Neither exemption lifts the promotion requirement in §8.4.

### 8.3 Types and verdicts

- `standard` — structure, metadata, dependencies, evidence coverage. Verdicts `approved` or `needs-work` (blocking issues).
- `deep` — doctrine alignment, logic, edge cases, boundaries. Verdicts `coherent` or `needs-review` (advisory issues for the [owner] to decide).
- `full` — both in one pass. The record carries the more restrictive verdict: `needs-work` over everything, then `needs-review`, and `approved` when neither applies. `approved` on a `full` record is the approving verdict of §8.4; `coherent` is a Deep Audit verdict only.

### 8.4 Updating and promotion

- The [auditor] writes `last_audit` immediately after delivering a verdict, with the `version` it actually read, and stores the full report at [audit report path]. Reports are append-only: a new audit is a new file, and no report is deleted.
- No document enters the canonical corpus without a `full` audit with an approving verdict. The audit is on the document's current `version`; for a record without `version`, the [owner] decides whether it covers the current text (§8.2). The [owner]'s decision never replaces the `full` type or the approving verdict: a record of a `standard` or `deep` audit, or with `needs-work` or `needs-review`, is not a basis for promotion. The [author] never approves its own document.

## 9. Tool classes

The [instance appendix] binds each class to a tool. A tool that does not meet the class is not conforming, however it is named.

| Class | Measures or produces | Input | Passes | Never passes |
|---|---|---|---|---|
| [post-processor] | Automatic `depends_on` candidates (marked unverified), `referenced_by` propagation, the conflicts in §6.1–§6.2, stale `depends_on_exclude` entries | The whole [contract corpus] | A report listing every conflict and every unverified entry; in strict mode, no conflict | Zero documents scanned; an unverified entry reported as verified; a conflict left out of the report |
| [index generator] | The [index]: slug, title, domain, layer, version, priority, in reading order (§5) | The whole [contract corpus] and the [domain taxonomy] | An index that lists every canonical document | An empty index; an index edited by hand |
| [conversion tool] | Canonical documents from source material in another format, where [system] has such sources | The source material | Output that meets this standard before it is canonical | Output treated as canonical before the [auditor]'s approval |
| [completeness gate] | Whether the implementation consumes and tests each normative statement and each [registry] key a contract cites (GIP §6) | A contract and the implementation | Every statement and key accounted for | A statement it cannot read counted as covered |

## 10. Maintenance

- Every change to this standard raises `version`.
- The [instance appendix] states the version of this standard it binds. An appendix bound to an older version is read against that version until it is revised.
- A rule that two instances need belongs here; a rule that one instance needs belongs in its appendix.
