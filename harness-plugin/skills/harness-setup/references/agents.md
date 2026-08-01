# M2 + M3: AGENTS.md, INVARIANTS.md, and Module-Level Files

---

## Root AGENTS.md (M2)

**Target state**: `AGENTS.md` — operational context only: overview, roles, footguns, module context links. A blockquote at the top points agents to `INVARIANTS.md`. Hard constraints live in `INVARIANTS.md`, not here.

### If AGENTS.md does not exist — create

Start from `assets/AGENTS.md.template`. Fill in each section using the discovery output.

**Prompt:**

```
Now we'll create the root AGENTS.md file. This is the top-level entry point for
repository-wide constraints and context.

Start from the AGENTS.md.template structure. Based on the analysis above, fill in:

1. **Repository Overview**
   - One-line service description
   - What problem does it solve?
   - Component overview: briefly describe the main components and how they relate, in prose.
     Do not produce a diagram here — the canonical diagram lives in docs/ARCHITECTURE.md
     (created in M6). Once M6 is complete, add: see [Architecture](docs/ARCHITECTURE.md).

2. **Module Context**
   - Placeholder section — fill in links to module-level AGENTS.md files as you create them in M3

3. **Agent Authorization**
   For each agent type that will operate in this repo (e.g., CodeReviewer, FeatureImplementer, BugFixer):
   - Authority: what they can commit or merge without human approval
   - Escalation: what always requires a human decision

   Before drafting **Authority** and **Escalation** for any role, ask the developer:
   "What is your team's policy on agent-driven commits, merges, and approvals?
    What actions must always require a human sign-off?"
   Do not fill in these fields with assumed defaults — a wrong authority model is worse
   than a placeholder.

4. **Known Footguns**
   - Document the tricky areas identified in Phase 1/2 where agents and engineers commonly make mistakes
   - For each: what happened, why it exists, what to watch out for
   - Link to relevant decisions in docs/DECISIONS.md

Keep AGENTS.md lightweight and readable. Target: under 200 lines.

Follow the interaction pattern: one section at a time.
```

### If AGENTS.md exists and mixes constraints with operational context — split

**Applies when**: `AGENTS.md` contains hard, non-negotiable constraints mixed in with operational context — or you have no `INVARIANTS.md` at all.

**Prompt:**

```
I need to split my AGENTS.md into AGENTS.md (operational context) and INVARIANTS.md (hard constraints).

Read AGENTS.md from the repository root.

Please:

1. Identify each section and classify it:
   - AGENTS.md content: roles, responsibilities, authority, escalation paths, module context, footguns, decision links
   - INVARIANTS.md content: non-negotiable rules, security constraints, performance SLAs, compliance requirements, API contract rules, data integrity requirements

2. Produce the new AGENTS.md:
   - Keep all operational context
   - Remove the constraints section. Add this blockquote immediately after the `#` heading:
     `> **Read [INVARIANTS.md](INVARIANTS.md) first** — it lists non-negotiable constraints that apply to all work in this repository.`
   - Keep within the line budget: default ≤ 200 lines; if `INVARIANTS.md` declares a *File Size Budget* override, use that.

3. Produce INVARIANTS.md with all the hard constraints.
   - Read `assets/INVARIANTS.md.template` — the comment at the top defines the constraint format, status markers, and "Enforced by:" annotations. Apply that format to every constraint.
   - Group by category: Security, Performance, Testing, Data Integrity, API Contract, Code Quality
   - For gaps (constraints not yet automated), mark as "[not yet enforced]" — these are your automation backlog

Show both files in full.
```

After splitting, M1 (`references/claude.md`) will ensure CLAUDE.md is updated to reference both files.

---

## INVARIANTS.md (M2)

Start from `assets/INVARIANTS.md.template`. Fill in constraints from the Phase 1 constraint discovery.

**Prompt:**

```
Create INVARIANTS.md with the hard constraints from our analysis.
Start from the INVARIANTS.md.template structure.

Include sections:

1. **Security** (top priority)
   - Authentication & authorization rules
   - Credential management
   - Encryption requirements
   - Session management
   - PII handling

2. **Performance**
   - Response time SLAs
   - Query execution limits
   - Cache requirements
   - Rate limiting rules

3. **Testing**
   - Coverage minimums
   - Required test types (unit, integration, etc.)
   - Test categories that cannot be skipped

4. **Data Integrity**
   - Database constraints
   - Migration requirements
   - Backwards compatibility rules

5. **API Contract**
   - OpenAPI spec enforcement
   - Response schema validation
   - Versioning rules

6. **Code Quality**
   - Linting rules
   - Type checking requirements
   - Import restrictions
   - Naming conventions

Follow the interaction pattern: one constraint category at a time.
The template comment defines the constraint format, status markers, and "Enforced by:" annotations — the template is already loaded; apply that format to every constraint.

For each constraint that names a specific identifier (env var, config key, file path, endpoint, class):
- Add a `[review: file:line]` marker after the constraint — e.g. `[review: src/config.js:42]`.
  This gives the reviewer the evidence to confirm the constraint is real. The reviewer deletes
  the marker once confirmed; it must not remain in the committed file.
- If no citation exists, replace the name with `[verify with maintainers: suspected name "<X>"]`.
  Do not assert the name as a fact if you cannot observe it.
- Do not produce two bullets that express the same rule in different words — duplicate coverage
  dilutes the binding constraints and makes the real ones harder to find.
```

---

## Module-Level AGENTS.md (M3)

Module-level files are optional. Most subdirectories do not warrant one. Run the three checks below before creating or updating any file.

"Module" here means any directory unit — a Java module (many files, tests, resources), a Python package (a directory with `__init__.py`), a Go package, a subdirectory in a monorepo, etc. What counts as a meaningful unit depends on the project structure discovered in Phase 1.

**Prompt:**

```
Enumerate candidate modules by build manifest, not by a raw directory walk — a flat directory
listing misses modules past an arbitrary cutoff in a monolith with dozens of subdirectories, and
wastes budget checking leaf directories that aren't modules at all.

Run:

  find . \( -name 'pom.xml' -o -name 'build.gradle*' -o -name 'package.json' \
    -o -name 'pyproject.toml' -o -name 'setup.py' -o -name 'requirements*.txt' -o -name 'Pipfile' \
    -o -name 'go.mod' -o -name 'Cargo.toml' -o -name '*.csproj' -o -name 'CMakeLists.txt' \
    -o -name 'conanfile.*' -o -name 'vcpkg.json' -o -name 'meson.build' \) \
    -not -path '*/.git/*' -not -path '*/node_modules/*' -not -path '*/vendor/*' \
    -not -path '*/target/*' -not -path '*/dist/*' -not -path '*/build/*' \
    -not -path '*/venv/*' -not -path '*/.venv/*'

Each match's containing directory is a candidate module. If a directory has no manifest of its own
but is clearly a distinct unit in the layout from Phase 1 (e.g. a Go package with no manifest, a
Python namespace package), add it manually.

C and C++ repos often have no manifest signal at all — a handwritten `Makefile` with ad-hoc
per-directory conventions and no `CMakeLists.txt`/`conanfile`/`vcpkg.json` anywhere is common, and
the manifest search above then returns nothing for the actual library code (it may still surface
an unrelated `requirements.txt` for a Python build-tooling script — apply the existing automation
skip rule below to that). Unlike every manifest-driven ecosystem above, the directory-layout
fallback is the *primary* method here, not a rare exception: use Phase 1's observed source-root
convention (`src/`, `main/`, `lib/`, or similar) and treat its immediate children as candidates.

If this returns far more matches than the repo has obvious top-level modules, it's a nested build
reactor or workspace — Maven/Gradle, npm/yarn workspaces, and Cargo workspaces let a parent
manifest declare child artifacts, and one real feature module can nest 5–9 build-artifact
sub-manifests (`service`, `service-impl`, `caching`, `workflow`, ...; a single module can outnumber
another repo's entire module count). Do not treat every match as a candidate module in that case.
Instead, group matches by the nearest ancestor directory that reads as a feature or capability
boundary — commonly one level below a directory literally named `modules/`, `packages/`,
`services/`, or `apps/` — and treat each such group as one candidate. Manifests nested further
inside are internal build splits of that one capability, not separate modules.

Also skip any manifest under a path listed in `.gitmodules` — a git submodule is externally owned
and versioned code with its own repository and its own README; documenting its internals here
would duplicate content that belongs (and may already exist) in the submodule's own repo. If the
submodule is a real dependency worth noting, mention it as one line in the *enclosing* module's
AGENTS.md ("depends on the `<name>` submodule — see its own README"), not as a candidate module.

Also skip a manifest if its directory is not declared anywhere as a real member of the repo's own
build — check the nearest ancestor manifest's member list (a Maven `<modules>` block, an npm/yarn
`workspaces` field, a Cargo `[workspace] members` glob, an Nx project list) — and it instead sits
under an automation directory such as `scripts/`, `tooling/`, `.ci/`, or `.github/`: a stray
`requirements.txt` for a helper script or CI job is not a documentable code module. Do not skip a
manifest based on its directory *name* alone — a top-level `config/` directory that IS listed in
the workspace globs (e.g. `workspaces: ["packages/*", "config/*"]`) holds real, independently
documentable packages, not automation noise. Check the declaration, not the name.

An unlisted manifest is not always automation, though — it can be a genuine embedded sub-toolchain
nested inside a single-language module (e.g. a Playwright/Node `package.json` for UI smoke tests
buried inside an otherwise pure-Rust or -Python crate, not declared in the workspace/reactor member
list). This is real, ongoing test code, not disposable plumbing — but it's also not its own
top-level module. Apply Check 1's toolchain-boundary criterion at the *enclosing* module's scope:
note it in that module's own AGENTS.md ("`<path>` runs a separate Node/Playwright toolchain — see
its own config") rather than promoting the nested directory to a first-class candidate.

A shared manifest can also hide multiple independently deployed services — common in Python repos
where one `pyproject.toml`/`requirements.txt` serves several runtime processes (a web server, a
background worker, a retry worker) distinguished only by which container image builds them, not by
a separate manifest. Check for this even when the manifest search found only one candidate:
- Read `docker-compose.yml`/`docker-compose.yaml` `services:`. Each entry with its own `build:` key
  (as opposed to a plain `image:` pulling an external image) is a service this repo builds and
  deploys independently. If more than one such service exists, each is its own candidate for
  Check 1, even though they all share one manifest.
- If there's no compose file, check for multiple `Dockerfile*` files at the root instead.

If the code isn't physically separated into subdirectories, document the split in the shared
module's own AGENTS.md rather than creating one per service: name each service, its Dockerfile,
and what process it runs (e.g. "this codebase serves three processes from one manifest: web
(`Dockerfile.asgi`), async worker (`Dockerfile.async_worker`), callback retry
(`Dockerfile.callback_retry`)").

Watch for one more variant: a Python repo can centralize per-service dependency files in a
`requirements/` (or `reqs/`) directory instead of naming each file `requirements.txt` — e.g.
`app/requirements/async_worker.txt`, `app/requirements/ml_worker_1.txt`, one per Dockerfile. The
`requirements*.txt` glob misses these, since the *directory* carries the name, not the file. If
such a directory exists, treat each file inside as a per-service manifest and cross-reference its
name against the docker-compose/Dockerfile service names found above to confirm the match.

For each candidate module, run this check before creating or modifying anything.

**Check 1 — Does it qualify?**
A subdirectory warrants a module-level AGENTS.md if it has at least one of:
- Security-sensitive or data-writing logic
- API boundary or contract responsibility
- Legacy code with known quirks
- Rules that genuinely differ from or tighten root guidance
- Significant local context: the directory is large or complex enough that an agent
  working in it would benefit from local orientation not present in root AGENTS.md
  (e.g., a major Java module, a large Python package, a monorepo service)
- A different build/test/lint toolchain than the repo root or a sibling module (e.g., a Python
  package inside a primarily TypeScript repo, or vice versa) — root AGENTS.md cannot state one
  true set of commands for both, so the toolchain boundary qualifies on its own, regardless of
  size or risk

"Module" means any meaningful directory unit in the detected project structure — not a fixed definition. Use the Phase 1 layout analysis to calibrate what counts.

If none apply, skip the subdirectory. Do not create a file.

**Check 2 — Is the content genuinely local?**
For each candidate fact (rule, footgun, workflow, architecture note):
- Is it already stated in root AGENTS.md, INVARIANTS.md, or docs/ARCHITECTURE.md?
- If yes, skip it. Do not restate or summarise upstream content — even a brief restatement
  creates a second copy that will drift and may contradict the source.
- Carry forward only content not covered anywhere upstream.

**Check 3 — Is there enough?**
If the genuinely local content from Check 2 is fewer than ~10 lines of real observation:
- Do not create the file.
- Surface the content as a candidate root-level addition instead:
  "Consider adding to root AGENTS.md Known Footguns: [content]"

If all three checks pass, create or update the module-level AGENTS.md:
- If a file already exists: read it first, then fill any gaps; do not duplicate content already there
- If missing: create from assets/module-AGENTS.md.template
- Include only sections that have content — omit empty sections entirely
- A 10-line file that says one true thing is better than a 99-line file padded with
  templated boilerplate
- If content was moved from root AGENTS.md: remove the duplicate from root after confirming
  it is captured here
- Add or verify a link in root AGENTS.md Module Context pointing to this file

Follow the interaction pattern: one section at a time.
```
