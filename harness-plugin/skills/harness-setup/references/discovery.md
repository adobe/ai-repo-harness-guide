# Discovery Prompts

Run both prompts in order. Capture the full output before creating any files.

---

## 1.1 Repository Structure Discovery

**Prompt:**

```
I'm building a harness for our repository. Help me understand the structure.

Please analyze the repository and answer:

**First, check the layout.** Enumerate modules by build manifest (`pom.xml`, `build.gradle*`,
`package.json`, `pyproject.toml`, `setup.py`, `requirements*.txt`, `Pipfile`, `go.mod`,
`Cargo.toml`, `*.csproj`, `CMakeLists.txt`, `conanfile.*`, `vcpkg.json`, `meson.build`, etc. — a
Python service without packaging metadata is often just a bare `requirements.txt`, so don't rely
on `pyproject.toml`/`setup.py` alone) rather than guessing from directory names. C/C++ repos often
have no manifest at all — a bare `Makefile` with directory-only conventions — in which case fall
back to the observed source-root convention (`src/`, `main/`, `lib/`) from item 2 below. If there is exactly one manifest at the root, or the repo is clearly
single-purpose, treat it as one module and answer items 1, 3, and 5 once for the whole repo. If
there is more than one manifest — a monorepo, or a polyglot repo mixing languages with different
toolchains in one repo (e.g. a Python backend and a TypeScript frontend) — list each module's path
and language, and answer items 1, 3, and 5 once **per module**. A single repo-wide answer to "how
are tests organized?" hides that the real answer is `pytest` in one module and `vitest` in
another — the harness needs both, not an average of the two.

If the manifest search returns far more matches than the repo has obvious top-level modules, it's
a nested build reactor or workspace (Maven/Gradle, npm/yarn, Cargo) where a parent manifest
declares child artifacts — one real module can nest several build-artifact sub-manifests. Group by
the nearest ancestor that reads as a feature boundary (often one level below a `modules/`,
`packages/`, `services/`, or `apps/` directory) rather than listing every nested manifest as its
own module — this is the same grouping M3 applies (`references/agents.md`).

The opposite case exists too: a single manifest can hide multiple independently deployed services
— common in Python repos where one `pyproject.toml`/`requirements.txt` serves several runtime
processes distinguished only by which container image builds them. If `docker-compose.yml` (or
multiple root-level `Dockerfile*` files) shows more than one service built from this repo, treat
each as its own module for items 1, 3, and 5 even though the manifest search found only one match.
Also check for a `requirements/`-style directory holding one dependency file per service (e.g.
`app/requirements/async_worker.txt`) — the manifest glob only matches files named
`requirements*.txt`, not files inside a directory of that name.

1. **Language & Frameworks** (once per module if the layout check above found more than one)
   - What programming languages are used? (primary and secondary)
   - What major frameworks are in use? (e.g., Django, FastAPI, React, Kubernetes)
   - What are the key dependencies? (use the appropriate package manager for the detected language)

2. **Repository Layout**
   - What is the main entry point(s)? (e.g., src/main.py, app.js, Dockerfile)
   - Are there subdirectories for src/, tests/, docs/? What's the naming convention?
   - Are there any existing configuration files? (.env, config/, terraform/, etc.)

3. **Testing Structure** (once per module if the layout check above found more than one)
   - How are tests organized? (tests/, __tests__/, .test.js files?)
   - What testing framework is used? (e.g., pytest, unittest, Jest, Mocha)
   - Are there integration tests? Performance tests? E2E tests?
   - What's the current test coverage?

4. **Existing Documentation** (inventory only — do not carry identifiers forward without code verification)
   - Is there a README.md? What does it cover?
   - Are there any docs/ files? What topics?
   - Is there any ADR (Architecture Decision Record) history?
   - Are there SECURITY.md, CONTRIBUTING.md, or SETUP.md files?
   - Search beyond `docs/` for documentation living elsewhere — `doc/` (singular), `wiki/`,
     `playbooks/`, `runbooks/`, `parliament/`, `notes/`, or any directory with a README and several
     `.md` files that reads as reference material. Distinguish genuine documentation from things
     that merely have a `.md` extension: tool config (e.g. `.obsidian/`), eval/test fixtures (a
     directory of per-repo subdirectories with a history log), and ephemeral working-memory scratch
     files (a root-level progress log describing uncommitted, in-flight work) are not documentation
     to surface. For each genuine location found, note its path and topics — Phase 3 links it from
     `docs/README.md` or the relevant `AGENTS.md` section rather than leaving it undiscoverable or
     duplicating it into a new file.

   For each document found: record its existence and topics, but treat all concrete identifiers
   it contains — env var names, route paths, class names, endpoint paths, queue names, bucket
   names — as unverified claims until confirmed against code. A claim that has lived in a doc
   for years is evidence of visibility, not correctness. Without this step the harness amplifies
   pre-existing tech debt: one stale identifier in a README becomes the same wrong identifier
   in every new harness file.

5. **Build & Deployment** (once per module if the layout check above found more than one)
   - How is the service built? (make, gradle, npm, tox, etc.)
   - What's the deployment mechanism? (Docker, Kubernetes, lambda, direct?)
   - Are there multiple environments? (dev, staging, prod)
   - Is there a CI/CD pipeline? (GitHub Actions, GitLab CI, Jenkins, etc.)

6. **Existing Harness Artifacts**
   For each item below, answer **present** (list the path) or **absent** (say explicitly):
   - AGENTS.md at the root
   - CLAUDE.md at the root
   - SKILL.md files (check .agents/ or skills/)
   - INVARIANTS.md
   - Module-level AGENTS.md files in any subdirectories
   - docs/ folder; if present, which of: ARCHITECTURE.md, DECISIONS.md, SETUP.md, TESTING.md, CONTRIBUTING.md
   - Any decisions/ or adr/ directory, or ADR naming convention in commit messages or PR descriptions

   Explicitly marking items absent is as important as listing what exists. A repo with no ADR
   convention takes a different DECISIONS.md path than one with existing records. A repo with
   no docs/ folder needs all Phase 3 docs created from scratch rather than extended.

Please provide the output as a structured checklist so we can use this as a starting point.
```

**What this reveals:**
- Language determines which tools to encode in the Makefile
- Test structure shows where sensors already exist
- Existing docs show what can be reused vs. created from scratch
- Build system determines the Makefile interface
- Existing harness artifacts show what to extend vs. create from scratch
- **Negative-space inventory** makes downstream generation honest — knowing what *doesn't* exist prevents Phase 2 and Phase 3 prompts from generating content as if those conventions were already in place
- **Per-module answers** (when the layout check finds more than one module) feed M5's per-toolchain Makefile fan-out and M3's module-level `AGENTS.md` content directly — one module's answer per row

---

## 1.2 Constraint Discovery

**Prompt:**

```
Now that we understand the repo structure, let's identify the constraints and invariants.

Please analyze the codebase and answer:

1. **Reliability Constraints**
   - Are there SLAs or performance targets? (API response time, uptime %, etc.)
   - What are the critical paths? (auth, data writes, payment processing, etc.)
   - Any known performance bottlenecks?
   - What's the current error rate or failure mode?

2. **Security & Compliance**
   - Is there sensitive data? (PII, secrets, payment info, health records?)
   - Are credentials hardcoded, in .env files, or in a vault?
   - Is there encryption at rest or in transit?
   - Any compliance requirements? (SOC 2, HIPAA, GDPR, etc.)
   - Are there authentication mechanisms? (API keys, OAuth, JWT, etc.)
   - Any audit logging requirements?

3. **Quality Standards**
   - What's the required test coverage %?
   - Are there code style rules? (linters, formatters in use?)
   - Type checking? (mypy, pyright, ty, TypeScript?)
   - Any static analysis tools?
   - Code review requirements?

4. **Backwards Compatibility**
   - Can you make breaking changes freely, or are there backwards compatibility requirements?
   - How long do you need to support deprecated APIs?
   - How are database migrations handled?
   - Are there client SDKs or public APIs that need contract stability?

5. **Operational Requirements**
   - How is the service monitored? (APM, metrics, logging, alerting?)
   - Is there a rate limiting or quota system?
   - Are there feature flags or experiment mechanisms?
   - How are secrets/credentials rotated?
   - What's the disaster recovery story?

6. **Documentation Standards**
   - How much documentation is expected per feature?
   - API documentation standard? (OpenAPI, Swagger, custom?)
   - Are there architectural diagrams expected?
   - Decision record requirements?

7. **Existing Enforcement**
   - Which constraints are already enforced by automation? (CI checks, pre-commit hooks, linters currently running)
   - Which checks fail or are currently skipped in CI?
   - Are there any pre-commit hooks configured?
   Mark any gaps as "enforced: no" — these become INVARIANTS.md entries that need automation wired up.

8. **Incident History**
   - Have there been any notable outages or bugs caused by specific areas of the codebase?
   - What were the root causes?
   - Which modules or patterns have caused the most problems?
   These are the best source of real footguns for AGENTS.md.

Please provide answers as a checklist, marking unknown items with "?"
```

**What this reveals:**
- Hard constraints go into INVARIANTS.md
- Known footguns go into AGENTS.md (incident history is the richest source)
- Documentation needs shape the docs/ folder structure
- Tool requirements determine which sensors must pass
- Enforcement gaps (constraints not yet automated) become explicit TODO items in INVARIANTS.md
