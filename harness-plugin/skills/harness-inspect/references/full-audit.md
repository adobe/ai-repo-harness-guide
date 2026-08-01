# Full Audit Prompt

A complete assessment across all harness dimensions. For repeat runs, fill in the inspection mode and prior assessment fields — the agent will produce a delta automatically.

**Prompt:**

```
Assess this repository's AI agent harness — how well does it set you up to do real work autonomously?

You are evaluating whether this repo is well-equipped for an AI coding agent to successfully execute
tasks such as bug fixes, feature implementations, and refactors — with minimal human intervention.

**Inspection mode**: [baseline | repeat — delete one]
**Prior assessment date**: [date, or omit if baseline]
**Prior verdict table**: [paste prior table here, or omit if baseline]

---

**1. Discover the harness**

Find and inventory all files intended to guide, constrain, or assist an AI agent. Look for:

- `AGENTS.md`, `CLAUDE.md`, `CURSOR.md`, `.github/copilot-instructions.md`
- `Makefile`, `justfile`, `Taskfile.yml`
- Skills directories (`.agents/skills/`, `/skills`, `/mnt/skills`)
- Claude Code integration surface, only if Claude Code is a target (a root `CLAUDE.md` or a `.claude/` directory exists): `.claude/skills/` (symlinks pointing at the canonical `.agents/skills/`) and `.claude/commands/` (legacy `@`-reference command shims)
- `.cursorrules`, `.clinerules`, `aider.conf`
- `CONTRIBUTING.md`, `DEVELOPMENT.md`, `ARCHITECTURE.md`, `README.md`
- CI workflow files (`.github/workflows/`)

**Do not inventory** build-system, tool-config, lock, container, or repo-config files — they are not part of the harness:
- Build / package manifests: `pyproject.toml`, `package.json`, `pom.xml`, `build.gradle*`, `Cargo.toml`, `go.mod`, `*.csproj`, `requirements.txt`, `Pipfile`, `Gemfile`
- Lock files: `package-lock.json`, `yarn.lock`, `Cargo.lock`, `Pipfile.lock`, `go.sum`
- Tool config: `tsconfig.json`, `.eslintrc*`, `.prettierrc`, `ruff.toml`, `mypy.ini`, `pytest.ini`
- Container / infra: `Dockerfile`, `docker-compose.yml`, `*.tf`
- Repo config: `.gitignore`, `.editorconfig`, `LICENSE`

The harness is the agent-facing layer, not the language toolchain it sits on.

For each file found, produce a table:

| Path | Tokens (est.) | Auto-loaded? | Summary |
|------|--------------|-------------|---------|

"Auto-loaded" means the file enters context before the first message — via `CLAUDE.md` `@`-references,
native `AGENTS.md` reading, or tool auto-loading. Everything else is on-demand.

Then compute:
- **Auto-loaded total**: sum tokens for all auto-loaded files. Default thresholds: flag ⚠️ if > 4,000, ❌ if > 8,000. **Before applying the defaults, check `INVARIANTS.md` for a `Context Budget` section.** If the repo declares its own values there, use those instead and note in the report that you used the repo override. **Use your own tokenizer to count** (do not estimate via `chars/4`); report which model and tokenizer you used. Counts are tokenizer-relative — the same content yields different totals across Claude / OpenAI / Gemini.
- **Full harness total**: sum tokens for all harness files

Then verify integrity: for every file path, command, and internal link referenced in any harness file,
confirm it still resolves. List broken references explicitly as **rot**.

Then verify content accuracy: for each harness file inventoried above, identify factual claims — version numbers, dependency names, build commands, environment variable names, file paths, API endpoint paths — and verify each by opening the corresponding source files (package manifests, Makefile, route definitions, `.env.example`, etc.). Do not verify from memory — open the files. List every discrepancy as **rot** with: harness file:line of the claim, claimed value, actual value, and source file:line evidence.

---

**2. Assess discoverability**

- Would you find these files naturally from the repo entry point, or do they require prior knowledge?
- Are they cross-referenced from README?
- Is there a clear "start here" for an agent bootstrapping itself?
- Are skills auto-loaded into context, or must they be explicitly invoked?
- **Claude Code integration** (only if Claude Code is a target — a root `CLAUDE.md` or a `.claude/` directory exists; otherwise N/A, and do not flag the absence of the `.claude/` surface — it is a Claude-specific workaround, not part of the portable harness): Is each `.agents/skills/<name>` discoverable by Claude Code via a `.claude/skills/<name>` symlink that resolves? Claude Code does not scan `.agents/skills/`, so a missing or broken symlink means the skill is invisible to it — **rot**. Is any `.claude/skills/<name>` entry a plain text file rather than a symlink (happens when `core.symlinks` is off, e.g. on Windows — the skill silently isn't discovered) — **rot**. Does any leftover `.claude/commands/<name>.md` `@`-shim duplicate a skill that now also has a `.claude/skills/` symlink? That is a redundant legacy surface (manual `/name` only, no auto-invocation) — **quick fix**.
- **`AGENTS.md`/`CLAUDE.md` direction**: run `ls -la AGENTS.md` (not just `cat`) — a symlink reads identically to a real file. `AGENTS.md` must hold the real, portable content; `CLAUDE.md` is the one allowed to be a thin `@`-reference pointer, never the reverse. If `AGENTS.md` is itself a symlink (to `CLAUDE.md` or anywhere else), that is **rot** — the fix is a real `AGENTS.md` with the actual content and a real `CLAUDE.md` shim pointing at it.

---

**3. Assess completeness**

For each item, mark: ✅ present and accurate | ⚠️ present but stale or incomplete | ❌ absent

**Guides**
- [ ] Root `AGENTS.md`: repo overview, agent authorization, footguns (blockquote link to `INVARIANTS.md` at top)
- [ ] `INVARIANTS.md`: specific, measurable constraints each marked with "Enforced by:"
- [ ] Module-level `AGENTS.md` files for high-risk subdirectories
- [ ] Skills (optional — no fixed set required): mark ✅ if none exist and no recurring, error-prone
      task type is evident from repo activity; ⚠️ only if a present skill is generic boilerplate or
      duplicates `AGENTS.md`/`INVARIANTS.md`; ❌ only if a clearly recurring, error-prone task type
      has no skill and evidence (e.g. repeated mistakes) shows agents need one
- [ ] `README.md` references the harness entry point

**Sensors**
- [ ] `make test` (or equivalent) runs and passes
- [ ] `make lint` (or equivalent) runs and passes
- [ ] `make check` combines all validation
- [ ] Coverage target stated in `INVARIANTS.md`

**Context**
- [ ] Architecture documented (system diagram, component roles)
- [ ] Decision record exists (major architectural decisions)
- [ ] Setup instructions let a new engineer run the repo from scratch
- [ ] Known footguns documented in `AGENTS.md`

**Token budget**
- [ ] Auto-loaded total within budget (from section 1: repo override if `INVARIANTS.md` has `Context Budget`, otherwise ≤ 4,000)

**File size budget** (count + linking pattern, not count alone)

For each file inventoried in section 1, categorize and check:
- **Core** (`AGENTS.md` root + module, `SKILL.md`): default budgets — ≤ 200 lines for `AGENTS.md`, ≤ 100 for `SKILL.md`. Override via `INVARIANTS.md` *File Size Budget* if present.
- **Flexible** (`INVARIANTS.md`, `README.md`): soft target ~200 / ~100 lines.
- **Harness support** (`Makefile`, `docs/*`, `CONTRIBUTING.md`, `CHANGELOG.md`): no line limit.

For each **core** file: flag ⚠️ only if it is **both** over budget **and** does not use progressive discovery (linking to module-level files, `references/`, `docs/`). A core file over budget that already links out is a candidate for the next split, not a defect. A core file under budget that inlines content the harness expects to see split *is* a defect — flag it.

For **flexible** files: flag ℹ️ informationally if substantially over the soft target.
For **harness support** files: skip the size check; suggest splitting only if a file has become hard to scan.

**Compute the health score**: ✅ = 1 point, ⚠️ = 0.5, ❌ = 0. Divide by 14 and multiply by 100.
Report the score.

---

**4. Assess content quality**

- Is there redundancy? (same content stated in more than one file)
- **Orphaned documentation**: search beyond `docs/` for genuine reference documentation living elsewhere — `doc/` (singular), `wiki/`, `playbooks/`, `runbooks/`, `parliament/`, or similar. Exclude tool config, eval/test fixtures, and ephemeral working-memory scratch files (a root-level progress log describing uncommitted, in-flight work) — those are not documentation. If a genuine location isn't linked from `docs/README.md` or `AGENTS.md`, it's a **quick fix**: link it, don't duplicate it.
- Is anything critical missing that you had to infer rather than read?
- Did you learn anything from source code that the harness should have told you?
- Regardless of whether the token budget passes: identify specific content in auto-loaded files that could move to a skill or `docs/` file without information loss. List each as an optimization opportunity in section 7.
- **Specific vs. generic**: Are instructions specific to *this* codebase — referencing real files, commands, and patterns you can verify — or generic advice ("write tests", "handle errors") that would apply to any project? Generic content is a signal the harness was templated rather than crafted. Flag it.
- **Discoverable vs. aspirational**: For each constraint or footgun, can you find supporting evidence in the actual source code? If a claim cannot be traced to a discoverable pattern, flag it as aspirational — it describes desired practice, not current reality, and will mislead agents acting on it.
- **Source-first coverage check**: Everything above starts from the harness files and asks whether they're accurate. Now invert the direction — start from the codebase. List the repo's top-level modules/packages by build manifest (`pom.xml`, `build.gradle*`, `package.json`, `pyproject.toml`, `setup.py`, `requirements*.txt`, `Pipfile`, `go.mod`, `Cargo.toml`, `*.csproj`, `CMakeLists.txt`, `conanfile.*`, `vcpkg.json`, `meson.build`, etc. — a Python service is often a bare `requirements.txt` with no `pyproject.toml`/`setup.py`; a C/C++ repo often has no manifest at all, just a `Makefile` with directory-only conventions, in which case fall back to the observed source-root layout), not a raw directory walk — a flat listing misses modules past an arbitrary cutoff in a monolith and gives no signal in a polyglot repo (e.g. a Python backend plus a TypeScript frontend), where each distinct toolchain root is its own module regardless of directory depth. If the manifest search returns far more matches than the repo has obvious top-level modules, it's a nested build reactor or workspace (Maven/Gradle, npm/yarn, Cargo) where a parent manifest declares child artifacts — one real module can nest several build-artifact sub-manifests (`service`, `service-impl`, `caching`, ...). Group matches by the nearest ancestor that reads as a feature or capability boundary — often one level below a `modules/`, `packages/`, `services/`, or `apps/` directory — rather than treating every nested manifest as a separate module. Also skip any manifest under a path listed in `.gitmodules` — externally owned, separately versioned code whose documentation belongs in its own repo, not duplicated here; if worth noting, it's one line in the enclosing module's `AGENTS.md`, not a coverage target of its own. Also skip a manifest whose directory is not declared as a real member of the repo's own build — check the nearest ancestor manifest's member list (Maven `<modules>`, npm/yarn `workspaces`, Cargo `[workspace] members`, an Nx project list) — and instead sits under an automation directory such as `scripts/`, `tooling/`, `.ci/`, or `.github/`: a stray `requirements.txt` for a helper script or CI job is not a documentable code module. Do not skip based on directory *name* alone — a top-level `config/` directory declared in the workspace globs (e.g. `workspaces: ["packages/*", "config/*"]`) holds real, independently documentable packages, not automation noise. An unlisted manifest is not always automation, though — it can be a genuine embedded sub-toolchain nested inside a single-language module (e.g. a Playwright/Node `package.json` for UI smoke tests buried inside an otherwise pure-Rust crate, undeclared in the workspace/reactor member list). Treat that as coverage for the *enclosing* module, not a separate candidate: flag it as a gap in that module's `AGENTS.md` if undocumented, not as its own missing-file finding. The opposite case exists too: a single manifest can hide multiple independently deployed services — common in Python repos where one `pyproject.toml`/`requirements.txt` serves several runtime processes distinguished only by which container image builds them. Read `docker-compose.yml` `services:` (each entry with its own `build:` key, not a plain `image:`) or, absent a compose file, count root-level `Dockerfile*` files. If more than one service builds from this repo, each is its own coverage target — a shared manifest with only one service documented is a **gap**, not full coverage. Watch for a `requirements/`-style directory holding one dependency file per service (e.g. `app/requirements/async_worker.txt`) — the `requirements*.txt` glob only matches files named that way, not files inside a directory of that name; cross-reference filenames against the service names found above. Also list entry points and the config/env vars actually referenced in source. For each, check whether root or module-level `AGENTS.md`, `INVARIANTS.md`, or a skill documents it. An area with zero coverage is a stronger signal than an existing file being thin — list it as a **critical gap** in section 7, not a content-quality note.

---

**5. Simulate a canonical task**

Use this fixed task so results are comparable across audit runs:

> "Locate the most recently modified non-trivial source file. Simulate implementing a small improvement
> to it — a missing test, a clearer variable name, or a one-line documentation fix. Walk through which
> harness files you would read, what commands you would run, and where you would get stuck."

Report:
- Which harness files you loaded and in what order
- What commands you would run to verify the change
- Where you got stuck or had to make assumptions
- What information the harness should have provided but didn't

---

**6. Give a verdict**

Rate each dimension using these definitions:

| Rating | Meaning |
|--------|---------|
| Strong | Explicitly documented and discoverable without prior knowledge |
| Good | Documented but requires minor inference or a manual step |
| Partial | Implied; an agent would likely guess correctly but might not |
| Weak | Absent; agent must infer from source code or context |

| Dimension | Rating | Notes | Delta from prior |
|-----------|--------|-------|-----------------|
| Discoverability | | | |
| Instruction clarity | | | |
| Build/test/lint commands | | | |
| Architecture context | | | |
| Token efficiency | | | |
| Agent autonomy support | | | |

**Health score**: [from section 3]

**Overall**: Can you confidently execute a non-trivial task end-to-end without asking for help?
Yes / Partially / No — and why.

---

**7. Recommend improvements**

Before sorting findings into categories, filter out low-value noise. Discard — do not list — a
finding if it is any of:
- a wording preference that doesn't affect correctness or clarity
- a stylistic complaint with no bearing on what an agent can do
- a cross-reference that would be convenient but isn't necessary to understand the topic
- speculative, without a specific file:line, command output, or source citation backing it up

Organize what survives into four categories:

**Rot** (broken references or stale commands — fix before the next agent task):
[list each with: file, what's broken, what it should say]

**Critical gaps** (blocks autonomous work — address before next agent task in affected area):
[list each with: what's missing, what file to create or update, what to add]

**Quick fixes** (agent can address autonomously, under 30 minutes each):
[list]

**Larger improvements** (require human decision or significant effort):
[list]

**Token optimizations** (auto-loaded content that could move to on-demand without information loss):
[list each with: file, content to move, suggested destination]

For each item: name the specific file and what to add or change, and add one sentence — why fixing
this changes what an agent can do, not why it's technically imperfect. Distinguish what was
explicitly provided in the harness vs. what you had to guess.

**Principles for recommended AGENTS.md updates**: preserve existing structure and section ordering; place additions in the most logical existing section rather than creating new ones; do not rephrase content that is still accurate — leave it exactly as it is; reference specific files and line numbers as examples when suggesting new content.

---

**8. Delta (repeat runs only)**

- Which recommendations from the prior assessment were addressed?
- Did any dimension regress since the prior run?
- Is the health score trending up or down?
- Are there new issues not present in the prior run?
```

