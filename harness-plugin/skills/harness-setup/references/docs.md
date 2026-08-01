# Documentation Prompts

For each docs/ file: check whether it already exists before running its prompt.
- **Exists** — read the file first, then follow the prompt below to fill any missing sections
- **Missing** — run the prompt to create from scratch

Both paths use the same templates and rules.

---

## Topic Ownership

Each topic has exactly one owner. Non-owner docs reference the owner with a section-level link rather than restating content. Producing duplicate content is not a completeness signal — it is drift scheduled for later.

| Topic | Owner | All other docs |
|---|---|---|
| Hard constraints (security, performance, testing %, API contract) | `INVARIANTS.md` | One sentence + link |
| Test commands and strategy | `docs/TESTING.md` | One sentence + link |
| System architecture and components | `docs/ARCHITECTURE.md` | One sentence + link |
| Setup and installation | `docs/SETUP.md` | One sentence + link |
| Contribution workflow (humans only — agents use `AGENTS.md`) | `CONTRIBUTING.md` | One sentence + link |
| Architectural decisions | `docs/DECISIONS.md` | One sentence + link |
| Task-specific methodology (how to do a task) | relevant `SKILL.md` | Link to the skill — do not restate steps |

When a section in your current file would duplicate an owned topic, write one sentence summarising it and link to the owner instead of writing the content out.

If the inventory (`references/inventory.md`) found genuine reference documentation living outside
`docs/` — a `wiki/`, `playbooks/`, `parliament/`, or similar directory, classified there as
⚠️ orphaned — add a link to it from the relevant owner file above (or from `docs/README.md` if no
single topic fits) instead of recreating its content. Closing an orphaned-documentation gap means
making it discoverable, not duplicating it into a new file.

---

## Generation Mode

Two prompt types require different approaches:

| Type | Examples | Approach |
|---|---|---|
| **Describe what is** (code-groundable) | Architecture, components, setup, test commands, config layers | Auto-generate; verify identifiers against code |
| **Explain why** (requires a human) | Decision rationale, historical context, trade-off reasoning, team conventions | Dialogue: mine signals, ask the developer, transcribe answers |

Prompts of the second type produce plausible-sounding historical fiction when run without a human in the loop. Code shows *what* exists; only the developer can provide *why* it was chosen over the alternatives that were rejected and left no trace. `DECISIONS.md` is the clearest example, but the same pattern applies to any prompt asking for rationale, historical narrative, or team conventions.

---

## Per-File Prompts

Derive content from the actual repository. Use the Phase 1 discovery output.

### ARCHITECTURE.md

**Step 0 — Prior context check (run first):**

```
Before generating any content for docs/ARCHITECTURE.md, ask:

Does prior architecture documentation exist for this system — team wikis, Confluence pages, sibling repo docs, prior docs/ content, or recent PR descriptions with architectural context?

If yes:
1. Ask the developer to list or share the documents.
2. Ingest each one.
3. For each document, ask the developer to rate its trustworthiness: trusted | partially trusted | outdated.
4. Use trusted and partially-trusted documents as the primary source. Use fresh codebase observation only to fill gaps — not to replace what is already documented.
5. Where fresh observation conflicts with a trusted document, flag the conflict explicitly rather than silently resolving it.

If no prior context exists, note this and proceed to Step 1.

Architecture documents that look authoritative but contain errors are worse than no docs — every downstream agent treats them as ground truth and propagates the errors.
```

**Step 1 — Component review (run first, stop before writing any file):**

```
Before creating docs/ARCHITECTURE.md, list the components you plan to include in the diagram.

For each component:
- **Name**: what you will call it in the diagram
- **Evidence**: which file(s) or import(s) confirm it exists — cite as `path/to/file:line`
- **Connections**: which other components it calls or is called by; for each connection cite the evidence as `path/to/file:line`
- **Confidence**: certain (direct citation found) | inferred (no direct citation) | uncertain (contradictory evidence)

Any connection listed as inferred or uncertain must carry a `[verify: path/to/file:line]` edge label in the final diagram. If you cannot find a citation, do not upgrade the confidence to certain — leave it inferred.

Do not produce any diagram or write any file. Output the list and stop — wait for the human to confirm or correct it before continuing.
```

**Step 1b — Trace reconciliation (run if observability tooling is available; skip otherwise):**

```
Check whether the repository has tooling that records actual service-to-service calls — distributed traces (Jaeger, Zipkin, Datadog APM, OpenTelemetry), service mesh telemetry, or structured request logs.

If available:
1. Retrieve at least one representative production trace covering the main request path.
2. Compare the actual call graph against the component list from Step 1.
3. For each discrepancy — edge present in traces but absent from Step 1, or vice versa — update the component list: add missing connections or downgrade confidence on connections not seen in traces.
4. Note the trace source (e.g., "reconciled against Datadog trace ID xyz on 2026-05-20").

If no observability tooling is accessible, skip this step and note in ARCHITECTURE.md: "Diagram based on static analysis only — runtime behavior unverified."
```

**Step 2 — Write ARCHITECTURE.md (run only after the component list is confirmed):**

```
Read assets/ARCHITECTURE.md.template — use that structure and follow the rules in its header comment. Use Mermaid syntax for all diagrams — no ASCII art.

Using the confirmed component list, create docs/ARCHITECTURE.md.

Identifier-grounding rule: every named identifier (env var, config flag, file path, class name,
queue name, endpoint) must have a file:line citation. Write [verify with maintainers] if none found.

Data Flow: before writing, produce a numbered outline — one entry per diagram edge with a
file:line citation per step. Present the outline and wait for developer confirmation before writing
the narrative. If generated in one pass without confirmation, prepend the unconfirmed-draft callout
from the template.

Key Components — enumeration sources (run before writing this section):
- Processes: Dockerfiles, Procfiles, deployment manifests, systemd units
- Data stores: DATABASE_URL, REDIS_URL, S3_BUCKET, or equivalent connection string env vars
- Messaging: QUEUE_*, TOPIC_*, SQS_*, SNS_* env var patterns; queue/topic config files
- External services: API-client modules, SDK imports, *_API_KEY / *_API_URL env vars
- Observability sinks: monitoring/tracing SDK imports (NewRelic, Datadog, OpenTelemetry, etc.)
- If observability tooling is available, cross-check against trace destinations

For each candidate: include if — and only if — its failure at runtime would cause a system failure
a reader of this document needs to anticipate. Before writing each entry, verify it contains none
of the excluded values listed in the template header.
```

### DECISIONS.md

Decision records are not derivable from code. Code shows *what* exists; an ADR captures *why* it was chosen over alternatives that don't exist anywhere. This section uses a three-step dialogue rather than generation.

**Step 1 — Git archaeology (mine for candidates):**

```
Mine the git history for architectural change candidates.

Run:
- git log --oneline --merges
- git log --oneline --all -- Dockerfile docker-compose.yml requirements.txt package.json pyproject.toml
- git log --oneline --all --diff-filter=M -- src/ (or the detected primary source tree)

Surface up to 10 candidates that look architecturally significant:
- Commit/PR hash, title, and date (from git log — do not infer)
- Files affected (summarised)
- Any PR body or commit message referencing a wiki, issue tracker, or design doc

Do not create any file yet. Present the list and stop.
```

**Step 2 — Developer dialogue (do not proceed without responses):**

```
Present the candidate list to the developer.

For each candidate the developer wants to record, ask:
1. What was the problem or context that drove this decision?
2. What alternatives were considered, and why was this path chosen?
3. Where does the full rationale live (PR thread, wiki page, design doc, meeting notes)?

Record the developer's answers verbatim. If the developer says "I don't know" or "not worth
recording", note that and move on. Do not infer or fill in gaps.

Stop after collecting answers. Do not create any file yet.
```

**Step 3 — Transcribe into DECISIONS.md (run only after Step 2):**

```
Read assets/DECISIONS.md.template — use that structure for every entry.

Using the developer's answers, create docs/DECISIONS.md.

For existing entries: verify dates against git log; mark any field that cannot be confirmed as `[verify with maintainers]`.

For each recorded decision:
- **Title**: developer's description
- **Date**: from git log; otherwise `TODO — not derivable from code`
- **Status**: developer's answer; otherwise `TODO`
- **Source**: link or reference the developer gave (PR, wiki, doc)
- **Context**: developer's answer, verbatim or lightly edited
- **Decision**: developer's answer
- **Consequences**: developer's answer if provided; omit if not
- **Agents Should Know**: derive from the decision and consequences — this is the one
  field safe to generate, since it concerns current code implications that are observable

For decisions where the developer had no answer:
- Create a stub with `TODO` in every field
- Add: "Source needed — decision rationale not available in code or from developer"

Never fabricate a date, status, Context, or Decision. A blank TODO invites correction;
a fabricated field silently misleads any agent that reads this file as historical ground truth.
```

### SETUP.md

**Prompt:**

```
Read assets/SETUP.md.template — use that structure for the file.

Create docs/SETUP.md. Derive every command, env var name, and file path from the actual
repository. Write [verify with maintainers] for anything that cannot be confirmed.

Running Tests section: one sentence + link to TESTING.md only — do not restate test strategy,
coverage targets, or fixture patterns (TESTING.md owns those).
```

### TESTING.md

**Prompt:**

```
Read assets/TESTING.md.template — use that structure for the file.

Create docs/TESTING.md. Derive content from the actual test suite, test configuration,
and Makefile. Coverage target: link to INVARIANTS.md — do not restate the number.
Running Tests: derive available make targets from the Makefile; omit targets that don't exist.
```

### CONTRIBUTING.md

**Step 1 — Decide conventions (do before writing):**

```
Before writing docs/CONTRIBUTING.md, ask the developer two questions:

1. Commit convention: which commit message format should this project use?
   Suggested default: Conventional Commits (https://www.conventionalcommits.org/)
   — type(scope): subject format with types feat, fix, docs, chore, refactor, style, test.
   If the developer has no preference, proceed with Conventional Commits.

2. Branch naming: which branch prefix scheme should this project use?
   Suggested default: prefixes that mirror commit types (feat/, fix/, docs/, chore/, refactor/).
   If the developer has no preference, proceed with the mirrored-type scheme.

Record the answers. Do not write the file yet.
```

**Step 2 — Write CONTRIBUTING.md:**

```
Read assets/CONTRIBUTING.md.template — use that structure for the file.

Place it at CONTRIBUTING.md (repo root).

For Humans section: fill in the branch naming and commit style TODOs using the answers from
Step 1. Include concrete examples — at least two commit message examples and one branch name
example. Add in the commit body guidance: "body explains *why* — the diff shows *what*."

Quality Standards: one sentence + link to INVARIANTS.md only — do not restate constraint values.

Common Tasks: list available skills from .agents/skills/ and link to each SKILL.md — do not
document task steps here, that belongs in the skill.

After creating CONTRIBUTING.md, update root AGENTS.md ## Conventions to replace any
standalone commit or branch rules with a single pointer:
  - **Commits & branches**: see [CONTRIBUTING.md](CONTRIBUTING.md) — single source of truth
```

### Final Pass — Identifier Verification

Run this after all docs/ files are written.

**Prompt:**

```
Extract every named identifier cited across the docs/ files just created — env var names,
config flags, file paths, class names, constants, queue names, bucket names, endpoint paths.

For each identifier:
1. Grep the repository for it.
2. If found: note the file:line and mark it verified.
3. If not found: flag it as [unverified: "NAME" — not found in codebase] and note the file
   and section where it appears.

Produce a short report: verified count, unverified list with locations. Do not silently drop
unverified identifiers — surface them so the developer can decide whether to correct, remove,
or mark as [verify with maintainers].
```

### Final Pass — Cross-Doc Dedup

Run this after the identifier verification pass.

**Prompt:**

```
Read all generated files: docs/ARCHITECTURE.md, docs/DECISIONS.md, docs/SETUP.md,
docs/TESTING.md, CONTRIBUTING.md, INVARIANTS.md, AGENTS.md, and any SKILL.md files.

Find every topic that appears substantively in more than one file.

For each duplicated topic:
1. Identify the owner file using the topic-ownership map at the top of this reference file.
2. In every non-owner file: replace the duplicate content with one sentence summarising it
   and a section-level link to the owner.
3. Leave the owner file unchanged.

Produce a report: duplicated topics found, owner file, files edited, and the replacement
text used in each non-owner file.
```

