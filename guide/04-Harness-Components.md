# Harness Components

This document describes the concrete files, tools, and structures that encode the [five control layers](03-Five-Control-Layers.md) into a working harness.

A production-grade harness has three **essential** components, four that are **strongly recommended** (including Skills, which is situational — add only where a task type warrants one), plus a `Further Components` section covering additions that pay off as the repo matures.

> **Already have a `.claude/`, `.cursor/`, or `.github/` setup?** Those files work — but only for the one tool that reads them. `AGENTS.md`, `INVARIANTS.md`, and `.agents/skills/` are read by all AI tools implementing the open standards. If you have partial harness artifacts in tool-specific locations, see [Migrate Your Harness](08-Migrate-Your-Harness.md) before continuing.

---

- [Essential Components](#essential-components)
  - [1. AGENTS.md — Operational Context](#1-agentsmd---operational-context)
  - [2. README.md — Human Entry Point](#2-readmemd---human-entry-point)
  - [3. INVARIANTS.md — Hard Constraints](#3-invariantsmd---hard-constraints)
- [High-Leverage Additions (Strongly Recommended)](#high-leverage-additions-strongly-recommended)
  - [4. Skills — Capability & Method Contract (Optional)](#4-skills---capability--method-contract-optional)
  - [5. docs/ — Design Authority](#5-docs---design-authority)
  - [6. API Documentation — Machine-Verifiable Contracts](#6-api-documentation---machine-verifiable-contracts)
  - [7. Makefile — Single Execution Surface](#7-makefile---single-execution-surface)
  - [8. Further Components](#8-further-components)
- [Progressive Discovery: The Pattern Every Harness File Follows](#progressive-discovery-the-pattern-every-harness-file-follows)
- [How These Components Work Together](#how-these-components-work-together)

---

## Essential Components

### 1. AGENTS.md - Operational Context

> `AGENTS.md` is an official project of the [Agentic AI Foundation](https://aaif.io/projects/agents-md/) — reportedly present in [60,000+ repos](https://openai.com/index/agentic-ai-foundation/) and natively supported by Cursor, OpenAI Codex, GitHub Copilot, and others. See [agents.md](https://agents.md) for the full specification. A lightweight shim may be needed for support across agents.

**Purpose:** Replace brittle prompting with repository-local context. Establish invariants that hold everywhere.

**Audience:** Any agent or human operating inside the codebase.

**Key Principles:**
- **Portable Across Tools**: `AGENTS.md` is an open standard ([agents.md](https://agents.md)) supported by GitHub Copilot, Cursor, OpenAI Codex, and others (Claude Code requires a shim — see footnote) — see [READING.md](READING.md#specifications) for per-tool adoption details. Agent context placed in tool-specific files (`.github/copilot-instructions.md`, `.cursorrules`, or a `CLAUDE.md` with real content) is readable by only one tool.[^claude-shim]
- **Operational Context First**: Keep `AGENTS.md` focused on roles, boundaries, module context, escalation paths, and known footguns.
- **Canonical Invariants Elsewhere**: Keep hard non-negotiables in `INVARIANTS.md`.
- **Hierarchy with Inheritance**: Use one mandatory root `AGENTS.md`; optional module files may extend/tighten parent rules but never contradict them.
- **Progressive Discovery**: Agents read root first, then discover nearest module `AGENTS.md` as they traverse subdirectories.
- **Deterministic Navigation**: Add explicit up/down links between parent and child `AGENTS.md` files to reduce ambiguity.
- **High-Signal Brevity**: Keep each file concise to limit context pollution — see [Progressive Discovery](#progressive-discovery-the-pattern-every-harness-file-follows) below for line budgets and override mechanism.

**Recommended Structure:**

**Root `AGENTS.md`**
- One per repository
- Defines all agents' responsibilities, roles, and hierarchies
- Establishes repository-wide invariants ("PII must never be logged")
- Lists known footguns and how to avoid them

**Module-Level `AGENTS.md` (Optional)**
- Refines or extends the root for specific modules
- Captures local context close to the code where it matters
- Cannot contradict the root; only extends or tightens constraints
- Inherits all root invariants automatically

**Scope split with `INVARIANTS.md`**
- `AGENTS.md`: operational context (roles, boundaries, module context, escalation, footguns, links to decision records)
- `INVARIANTS.md`: hard non-negotiables (security/compliance/data/API guarantees)
- In `AGENTS.md`, add a blockquote at the top that points agents to `INVARIANTS.md` — do not summarise the constraints inline

**Progressive discovery pattern:**
1. Read root `AGENTS.md` first
2. When entering a submodule, look for a local `AGENTS.md`
3. Merge local rules with inherited root rules
4. If no local file exists, continue with inherited context only

**Navigation links (recommended):**
Use bidirectional links between hierarchy levels so agents can traverse context deterministically.

- Each module `AGENTS.md` should link **up** to its parent `AGENTS.md`
- Parent `AGENTS.md` should link **down** to child/module `AGENTS.md` files
- Keep the links near the top of each file (high visibility)
- Keep the child link list curated; include only real module boundaries

Example pattern:

```markdown
# AGENTS.md (module)

## Navigation
- Up: [`../AGENTS.md`](../AGENTS.md)
- Down:
  - [`./payments/AGENTS.md`](./payments/AGENTS.md)
  - [`./auth/AGENTS.md`](./auth/AGENTS.md)
```

This complements progressive discovery: agents can still discover files by walking folders, but links reduce ambiguity and speed up navigation.

**Enforcement:** Submodule constraints may override or extend parent context, but never contradict it. Keep each `AGENTS.md` short (line budget in [Progressive Discovery](#progressive-discovery-the-pattern-every-harness-file-follows)) and ensure hierarchy links are present so progressive discovery stays deterministic.

**Example Structure:**

```markdown
# AGENTS.md (Root)

> **Read [INVARIANTS.md](INVARIANTS.md) first** — non-negotiable constraints.

## Repository Overview
[High-level description of project]

## Agent Authorization
### CodeReviewer
- Authority: can propose changes; cannot merge without human approval
- Escalation: security-impacting changes require human decision

### BugTriager
- Authority: can read and analyze code; cannot modify files

## Known Footguns
- The `legacy_parser` module has quirky edge cases; see DECISIONS.md#legacy-parser
- Avoid importing from `internal/` directly; use the public API instead
- [more warnings...]

## Decision Records
- [Links to DECISIONS.md entries]
```

See [Build Your Harness §2.1](07-Build-Your-Harness.md) for a fully worked root `AGENTS.md` — real footguns, real escalation paths — built for a running example repo.

---

### 2. README.md - Human Entry Point

**Purpose:** Orient humans entering the codebase. Unlike the other essential components, `README.md` doesn't encode a control layer itself — it's the deliberate human-facing exception that makes the rest of the harness discoverable to the people who work alongside the agents.

**Audience:** Human contributors, team members, and stakeholders. Not the primary entry point for agents — agents enter through `AGENTS.md`, which is loaded directly or via agent-specific shims.

**Key Principles:**
- **Tight description**: one paragraph on what the repo is and what problem it solves
- **Minimal quickstart**: the fewest commands to install and run; full setup lives in `docs/SETUP.md`
- **Gateway, not an encyclopedia**: link to canonical sources; do not duplicate their content

**Good Contents:**
- One-paragraph description: what it is, what problem it solves, key technical choices
- Minimal quickstart: prerequisites callout and the two or three commands to get started
- "For Agents and Contributors" link list: `AGENTS.md`, `INVARIANTS.md`, `docs/`
- External references: team wiki, Jira, API specs, related projects or services (always present; add a reviewer callout if none are known yet)

**What NOT to Include:**
- Full setup instructions → `docs/SETUP.md`
- Architecture diagrams or component descriptions → `docs/ARCHITECTURE.md`
- Role definitions or agent instructions → `AGENTS.md`
- Hard constraints or invariants → `INVARIANTS.md`
- A separate "For Agents" section — `CLAUDE.md` and `AGENTS.md` serve agents directly

**Recommended Structure:**

````markdown
# ProjectName

[One paragraph: what this project is, what problem it solves, and the key technical choices.]

## Quickstart

Requires [prerequisites]. See [docs/SETUP.md](docs/SETUP.md) for full local setup.

```bash
make build    # build the project
make run      # start locally
```

## For Agents and Contributors

- [AGENTS.md](AGENTS.md) — roles, footguns, and module context (read this first)
- [INVARIANTS.md](INVARIANTS.md) — hard constraints (non-negotiable)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — system design and components
- [docs/SETUP.md](docs/SETUP.md) — full local development setup
- [docs/TESTING.md](docs/TESTING.md) — test strategy and how to run tests

## References

- [Team wiki](https://wiki.example.com)
- [API spec](https://api.example.com/openapi.yaml)
````

**Enforcement:** If content belongs in `AGENTS.md`, `INVARIANTS.md`, or `docs/`, put it there and link — not here.

---

### 3. INVARIANTS.md - Hard Constraints

**Purpose:** Encode non-negotiable constraints explicitly, separate from operational context. `AGENTS.md` links to `INVARIANTS.md` as the canonical constraint source; agents read it during constraint discovery.

**Audience:** Any agent or human operating in the codebase, plus maintainers responsible for policy and compliance governance.

**Key Principles:**
- **Canonical-source rule**: each invariant has one location — here. `AGENTS.md` and other docs reference by link, never by duplicating the text
- **Separate from AGENTS.md**: some constraints are so critical they deserve their own document for visibility and governance; keeping them here also keeps `AGENTS.md` focused on operational context

**Recommended Structure:**

Explicitly list **non-negotiables** — constraints that cannot be relaxed without explicit human sign-off:

- Security constraints ("All credentials must use HashiCorp Vault")
- Data handling rules ("PII is encrypted at rest and in transit")
- Performance ceilings ("Query response time must be < 200ms for 99th percentile")
- Backwards-compatibility guarantees ("API v1 will be supported for 2 years")

**Enforcement:** `AGENTS.md` should open with a blockquote pointing agents to `INVARIANTS.md` — agents must consult it before any action that could touch a non-negotiable.

---

## High-Leverage Additions (Strongly Recommended)

### 4. Skills - Capability & Method Contract (Optional)

> `SKILL.md` is an emerging open standard for encoding agent capabilities directly in repositories. See [agentskills.io](https://agentskills.io/specification) for the full specification. GitHub Copilot, OpenAI Codex, and Cursor read `.agents/skills/` natively; Claude Code does not scan it, so symlink each skill into `.claude/skills/` — a pointer, not a copy (see [chapter 07](07-Build-Your-Harness.md) step 2.1c).

**Purpose:** Define the capabilities an agent has in this repository and the concrete instructions for exercising each one. Add a skill only for a task type frequent or error-prone enough that a dedicated procedure measurably helps — not as a fixed set every repo must have.

**Audience:** Any AI tool operating in this codebase.

**Key Principles:**
- **Portable Across Models and Tools**: `SKILL.md` under `.agents/skills/` is an open standard ([agentskills.io](https://agentskills.io/specification)) supported by GitHub Copilot, OpenAI Codex, Cursor, and others — see [READING.md](READING.md#specifications) for per-tool adoption details. Skills placed in tool-specific directories (`.claude/`, `.cursor/`, `.github/`) are readable by only one tool.
- **Declarative, Not Instructional**: State what the agent can do, not how to prompt it
- **Stable Across Repo Lifetime**: Should not require constant rewrites as the codebase evolves
- **Minimal Metadata**: Include only what the agent needs to select and invoke the skill. The front matter block is loaded on every new agent instance — every unnecessary field costs tokens on every invocation

**Recommended Structure:**

Example skills directory structure:
```
.agents/skills/my-skill/
               ├── SKILL.md          # Required: instructions + metadata
               ├── scripts/          # Optional: executable code
               ├── references/       # Optional: documentation
               └── assets/           # Optional: templates, resources
```

Example `SKILL.md` layout:
```markdown
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when the user needs to work with PDF files.
---

# PDF Processing

## When to use this skill
Use this skill when the user needs to work with PDF files...

## How to extract text
1. Use pdfplumber for text extraction...

## How to fill forms
...
```

**Enforcement:** This document is read by the agent before each task. It serves as the feedforward control layer.

---

### 5. docs/ - Design Authority

**Purpose:** Replace tribal knowledge with durable documentation.

**Audience:** Any agent or human operating in the codebase.

**Key Principles:**
- **Architecture docs are the design authority**: when code diverges, treat it as a signal to reconcile — either the code drifted from design intent, or the docs need updating
- **Maintain as living documentation**: Docs should evolve with the system
- **Searchable and linkable**: Use plain Markdown with durable anchors
- **Auditable and agent-friendly**: Keep decisions easy to trace and cite
- **Diagrams in Mermaid, not ASCII**: Mermaid diagrams are renderable, diffable, and editable by agents; ASCII art breaks on reformatting and is opaque to automated tooling

**Recommended Structure:**

```
docs/
├── ARCHITECTURE.md       # System design and major components
├── DECISIONS.md          # ADRs or decision records explaining why
├── SETUP.md              # Local development environment
├── API.md                # API reference (or link to OpenAPI spec)
├── CONTRIBUTING.md       # How to work in this repo
├── SECURITY.md           # Security policies and sensitive info handling
└── TESTING.md            # Testing strategy and patterns
```

**Enforcement:** When architecture or behavior changes, update `docs/` in the same change. If code and docs diverge, treat it as a signal to reconcile — either the code drifted from design intent, or the docs need updating.

---

### 6. API Documentation - Machine-Verifiable Contracts

**Purpose:** Replace tribal knowledge with enforceable contracts.

**Audience:** Any agent or human operating in the codebase.

**Key Principles:**
- **OpenAPI-first**: API behavior is contract-defined, not implicit
- **Machine-verifiable**: Schemas must be testable in automation
- **Generator-friendly**: Specs should support docs and client/server generation

**Recommended Structure: OpenAPI (v3.x)**

If this is a service repo, check an OpenAPI spec into the repository:

```yaml
# openapi.yaml
openapi: 3.0.0
info:
  title: MyService
  version: 1.0.0
paths:
  /api/users/{id}:
    get:
      summary: Get user by ID
      responses:
        '200':
          description: User object
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
# components/schemas defined below...
```

**Enforcement:**
```
Any API change requires a corresponding OpenAPI change.
```

This prevents spec drift and enables schema validation as a sensor in CI.

---

### 7. Makefile - Single Execution Surface

**Purpose:** Replace tribal knowledge about "how to run things" with a unified interface.

**Audience:** Any agent or human operating in the codebase.

**Key Principles:**
- **Tool-agnostic**: The Makefile abstracts from the tools used (e.g., Maven, Gradle, npm) and provides a consistent interface for all agents and humans.
- **Works equally for humans and agents**: Both can run `make test`
- **Prevents command hallucination**: Agents cannot invent commands; they should use only what's in the Makefile
- **Single source of truth**: One place to update when tools change
- **Dynamic help (`## ` + awk pattern)**: The help output is generated from `##`-annotated comments co-located with each target. Adding a target automatically adds it to `make help` — no separate list to maintain. Agents reading `make help` see the complete, current action surface; a hardcoded `@echo` list drifts the moment a target is added or renamed.
- **Target-local `.PHONY`**: Each target carries its own `.PHONY` declaration immediately above it. This keeps declaration and target co-located, making them easy to add, delete, and review together. A single `.PHONY` block at the top requires editing two places for every change and invites the block and the target list to diverge.
- **Target-local documentation**: The `##` comment serves double duty — it is the target's description in the source and its entry in `make help`. Writing it once, inline, means it cannot fall out of sync: edit the target, the description is right there.

**Recommended Structure:**

```makefile
# Agents: run only make targets listed here. No direct shell commands.

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available commands
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS=":.*## "}; /^[a-zA-Z0-9_-]+:.*## / { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: build
build:          ## Build the project
	python -m pip install -e .

.PHONY: test
test:           ## Run all tests with coverage
	pytest tests/ --cov=src --cov-report=term-missing

.PHONY: lint
lint:           ## Run linters
	ruff check .

.PHONY: format
format:         ## Auto-format code
	ruff format .

.PHONY: typecheck
typecheck:      ## Run type checker
	ty check .

.PHONY: check
check: lint typecheck test  ## Run all validation (lint + typecheck + test)
```

**Enforcement:** Agents may only run commands exposed via `make`. Gate merges on `make check` so declared command surfaces and runtime behavior stay aligned.

---

### 8. Further Components

**Purpose:** Add governance and quality controls that reduce ambiguity and improve long-term operability as the repo matures.

**Audience:** Any agent or human operating in the codebase, plus maintainers responsible for policy and architecture governance.

**Key Principles:**
- Keep canonical sources explicit — link from `AGENTS.md` rather than duplicating content
- Prefer durable, linked records over tribal knowledge
- Encode policy in automation wherever possible

**Recommended Structure:**

#### DECISIONS.md and ADRs

Capture **why** the system looks like this, not just what it does.

Without decision history, agents and humans may repeat old debates. A record of [ADRs](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) prevents that.

Recommended: keep a concise `DECISIONS.md` index (status, title, link) and store full decisions in `docs/adr/`. For smaller repos, a single `DECISIONS.md` with inline records is fine. Either way, ensure decisions are discoverable from `AGENTS.md`.

For each decision, include at least:
- Context
- Decision
- Alternatives considered
- Consequences/trade-offs
- Links to related decisions

ADRs can live in `docs/adr/` or at the repository root, but they should be linked from `AGENTS.md` or `DECISIONS.md` for visibility.

Example ADR directory structure:
```
docs/adr/
├── 2024-03-15-legacy-parser.md
├── 2024-04-01-database-choice.md
└── 2024-05-10-api-versioning.md
```

Example `DECISIONS.md` layout:
```markdown
## [Decision Title] (ADR-YYYY-NNN)

**Date:** [date]  
**Status:** Accepted / Superseded / Deprecated  
**Context:** [why this decision was needed]  
**Decision:** [what was decided]  
**Alternatives considered:** [what else was evaluated]  
**Consequences:** [trade-offs — performance, maintenance, risk]  
**Links:** [related decisions]

---

## [More decisions...]
```

#### CONTRIBUTING.md

> **Location**: `CONTRIBUTING.md` — works everywhere and GitHub recognises it natively; no tool-specific directory needed.

Human-facing only — most agents do not read it. Put agent escalation policy in `AGENTS.md` instead.

Explain:
- What good PRs look like
- Required checks (which `make` targets must pass)
- When human review is mandatory (reviewer checklist)
- Branch naming convention (e.g., `feat/`, `fix/`, `docs/`, `chore/` prefixes)
- Commit message format (e.g., [Conventional Commits](https://www.conventionalcommits.org/))

Root `AGENTS.md ## Conventions` should link here, not restate the rules.

#### Code Style: .editorconfig, Linters, Formatters

Don't **explain** style; **encode** it.

Every automated check is a **sensor**. Encode style rules in:
- `.editorconfig` (cross-tool compatibility)
- Linter configs (`ruff.toml`, `.eslintrc`)
- Formatters (`black`, `prettier`)

When agents run these, they self-correct without needing lectures about style.

#### .agentignore

If tools support it, explicitly exclude:
- Secrets and credentials
- Generated files
- Vendored code

Prevents agents from accidentally modifying or learning from files they shouldn't touch.

#### Observability Infrastructure

The components above cover Layers 1–4 (Guides, Sensors, Context, and Tool & Permission Boundaries via the Makefile). Layer 5 — cost limits, retry ceilings, health checks, audit logs, and lifecycle controls — requires tooling beyond repository files (APM, metrics platforms, alerting). For implementation guidance on Layer 5, see [Five Control Layers](03-Five-Control-Layers.md#layer-5-observability--lifecycle-controls).

**Enforcement:** If an optional addition is adopted, make it discoverable from `README.md` or `AGENTS.md`, and wire corresponding checks into `make`/CI where applicable.

---

## Progressive Discovery: The Pattern Every Harness File Follows

[Chapter 03](03-Five-Control-Layers.md#layer-1-guides-feedforward-control---acting-before-the-agent-runs) introduced progressive discovery as a folder-traversal mechanism: agents read root `AGENTS.md` first, then the nearest module file as they descend. The same discipline applies to every harness file's internal structure: **a small entry point that links to detail, not a large monolith that inlines it.** Root `AGENTS.md` links to module-level files. `SKILL.md` links to `references/`, `scripts/`, `assets/`. `README.md` links to chapters and `docs/`. Progressive discovery is the discipline that keeps the harness loadable, scannable, and maintainable.

A few harness files have no enforced line limit — `Makefile` is monolithic so `.PHONY` can advertise every target in one place; `docs/` files and `CHANGELOG.md` grow with the project and are navigated by section, not loaded whole. Tool-defined config files (`pyproject.toml`, `package.json`, `pom.xml`) are outside the harness entirely. Everything else: small + linked.

### What Counts as a Harness File

This table is the authoritative inventory — every harness file, its build priority, and its line budget in one place.

| Category | Files | Essentiality | Line budget |
|---|---|---|---|
| **Harness core** | Root and module-level `AGENTS.md`; each `SKILL.md` | Essential | ~200 lines for `AGENTS.md`, ~100 for `SKILL.md`. Override-able via `INVARIANTS.md` (see [Overriding the Defaults](#overriding-the-defaults)) |
| **Harness flexible** | `INVARIANTS.md`, `README.md` | Essential | Soft targets (~200 / ~100 lines). Length scales with constraints / repo size |
| **Harness support** | `Makefile`, `docs/*` (`ARCHITECTURE.md`, `DECISIONS.md`, `SETUP.md`, `TESTING.md`) | Strongly recommended | No enforced limit. Qualitative signal: split when a file becomes hard to scan (e.g., `DECISIONS.md` → `docs/adr/<date>-<title>.md` per ADR) |
| **Harness support** | `CONTRIBUTING.md`, `CHANGELOG.md`, `.agentignore` | Nice-to-have | No enforced limit |
| **Out of harness scope** | Build / package / lock / tool / container / infra / repo config: `pyproject.toml`, `package.json`, `pom.xml`, `build.gradle*`, `Cargo.toml`, `go.mod`, `requirements.txt`, `tsconfig.json`, `.eslintrc*`, `Dockerfile`, `docker-compose.yml`, `*.tf`, `LICENSE`, `.gitignore`, lock files | — | Not inventoried by harness skills. The harness is the agent-facing layer, not the language toolchain it sits on |

The `harness-setup` and `harness-inspect` skills generate, maintain, and audit only the harness layer — they do not touch out-of-scope files.

### Overriding the Defaults

A repo can override the line budgets by adding a `File Size Budget` section to its `INVARIANTS.md`:

```markdown
## File Size Budget

- ✅ Root and module-level `AGENTS.md` files ≤ 250 lines — *Enforced by: harness-inspect Q8*
- ✅ `SKILL.md` ≤ 120 lines (excluding `references/`, `scripts/`, `assets/`) — *Enforced by: harness-inspect Q8*
- *Reason*: large multi-team monorepo with security-sensitive modules requiring deeper documented context
```

`harness-inspect` checks for this section before applying the chapter defaults.

### When the Pattern Fails

A core file over budget that already links out is not a defect — it's a candidate for the next split (push more detail to module files). A core file under budget that inlines content the harness expects to see split *is* a defect — the structure isn't progressive even though the size is fine. The audit check measures both: count + linking pattern. Flag only when both fail.

---

## How These Components Work Together

1. **First Time Agent Enters**: Auto-loads AGENTS.md; agent reads roles, constraints link, and discovers Skills
2. **Building Context**: Reads AGENTS.md to understand invariants and roles
3. **Before Taking Action**: Consults INVARIANTS.md and docs/ for hard constraints
4. **Running Commands**: Only uses commands exposed in Makefile
5. **Checking Work**: Sensors (tests, linters, schema validation) validate output
6. **Understanding Why**: References DECISIONS.md to understand system design choices

The harness is not a pile of documentation. It is a **system** where each component serves a specific purpose, and together they encode your team's standards and practices directly into the codebase.

---


**← Previous:** [Five Control Layers](03-Five-Control-Layers.md) · **Next:** [How Agents Navigate](05-How-Agents-Navigate.md)

[^claude-shim]: Claude Code does not yet natively read `AGENTS.md` — add a minimal `CLAUDE.md` containing only `@AGENTS.md` and `@INVARIANTS.md` references as a compatibility shim. This keeps the canonical context in the portable, tool-agnostic location while satisfying Claude Code's current entry point requirement. Tracked in [claude-code#6235](https://github.com/anthropics/claude-code/issues/6235); the shim becomes unnecessary once resolved.