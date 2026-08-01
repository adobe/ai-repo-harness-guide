# Inventory Prompt

Run this prompt after the scan. It builds on the scan's file list and classifies each artifact so the migration decision table can be populated accurately.

**Prompt:**

```
Perform a harness inventory for this repository.

Canonical locations (use these when classifying every file you find):
- Agent context → `AGENTS.md` (operational: roles, footguns, module context) and `INVARIANTS.md` (hard constraints)
- Skills → `.agents/skills/<skill-name>/SKILL.md`
- `CLAUDE.md` → Claude Code's entry point; shim only (`@AGENTS.md` / `@INVARIANTS.md` references, no real content); must always exist
- Everything else (`.claude/`, `.cursor/`, `.github/instructions/`, `.cursorrules`, etc.) → non-canonical; content must move to the locations above, then originals deleted
- **Wrong answer**: recommending to update or keep existing files other than CLAUDE.md as shims pointing at canonical locations — delete them after migration, do not update their paths

Scan the repository and identify all existing harness-related artifacts:

1. **Agent Context Files**
   - Is there an `AGENTS.md` at the root? Check with `ls -la` (not just `cat`) — a symlink reads
     identically to a real file but is structurally backwards if it points at `CLAUDE.md`.
     `AGENTS.md` must hold the real, portable content; `CLAUDE.md` is the thing allowed to be a
     thin pointer, never the reverse. If `AGENTS.md -> CLAUDE.md`, treat this as ⚠️ needs work:
     the fix is to make `CLAUDE.md` a real `@`-reference shim (`references/claude.md`, M1) and
     `AGENTS.md` a real file with the actual content currently sitting in `CLAUDE.md`.
   - What sections does the (real) `AGENTS.md` content have?
   - Are there `AGENTS.md` files in subdirectories? List each path.
   - Scan for any other agent-facing files across all directories (`CLAUDE.md`, `.cursorrules`,
     `.github/copilot-instructions.md`, `.github/instructions/`, `CONTEXT.md`, `SYSTEM.md`, etc.).
     List each, note whether it contains real content or is a shim, and identify which canonical
     file the content belongs in.
   - **Coverage check**: list the repo's actual top-level modules/packages — found by build
     manifest (`pom.xml`, `build.gradle*`, `package.json`, `pyproject.toml`, `setup.py`,
     `requirements*.txt`, `Pipfile`, `go.mod`, `Cargo.toml`, `*.csproj`, `CMakeLists.txt`,
     `conanfile.*`, `vcpkg.json`, `meson.build`, etc.; for a manifest-less C/C++ repo — a bare
     `Makefile` with directory-only conventions is common — fall back to the observed source-root
     layout instead), the same technique
     as M3's module enumeration — including its reactor/workspace grouping caveat for nested
     build manifests (a Maven module can nest several build-artifact sub-poms; group by capability,
     not by every manifest match), its `docker-compose.yml`/`Dockerfile*` check for multiple
     services sharing one manifest (common in Python repos with a web/worker/retry-worker split),
     and its `requirements/`-directory variant where per-service files don't match the
     `requirements*.txt` glob (`references/agents.md`), not a raw directory walk, so the list scales with real modules
     in a monolith or monorepo instead of stopping at an arbitrary directory count. For each,
     check whether the root `AGENTS.md` or a module-level `AGENTS.md` documents it. A file that
     exists but covers only a fraction of the repo's real modules is ⚠️ needs work, not
     ✅ complete — name the uncovered modules explicitly so M2/M3 can address them.

2. **Skill/Rule Files**
   - Is there a `.cursorrules` or `.cursor/rules/` directory? List each rule file.
   - Are there `SKILL.md` files anywhere? List each path and note whether it is under `.agents/skills/`.
   - Are there skill or instruction files under `.claude/` (e.g., `.claude/skills/`, `.claude/commands/`)? List each.
   - Are there files under `.github/instructions/`? List each and note its `applyTo` scope.
   - Are there any `.agents/` or `agents/` directories? List contents.

3. **Constraint Files**
   - Is there an `INVARIANTS.md`? What sections does it have?
   - Are constraints scattered in `AGENTS.md` instead of a dedicated file?
   - Are there any `SECURITY.md`, `CONTRIBUTING.md`, or policy files with constraint-like content?

4. **Documentation**
   - Is there a `docs/` directory? List files.
   - Which docs files exist: `ARCHITECTURE.md`, `DECISIONS.md`, `SETUP.md`, `TESTING.md`?
   - Is there a `CONTRIBUTING.md`? Check both `docs/CONTRIBUTING.md` and `.github/CONTRIBUTING.md`.
   - Are there ADRs anywhere (`docs/adr/`, `*.adr.md`, etc.)?
   - Is there documentation living outside `docs/` entirely — `doc/` (singular), `wiki/`,
     `playbooks/`, `runbooks/`, `parliament/`, or similar? Classify each as ✅ **linked** (referenced
     from `docs/README.md` or `AGENTS.md`), ⚠️ **orphaned** (genuine reference documentation that
     exists but isn't linked from anywhere), or excluded as noise (tool config, eval fixtures,
     ephemeral scratch files — same judgment as the discovery prompt). An orphaned location is a
     gap for M6 to close by linking it, not a reason to recreate its content in `docs/`.

5. **Execution Surface**
   - Is there a `Makefile`? What targets exist?
   - Are `test`, `lint`, `typecheck`, and `check` targets present?
   - Are there any shell scripts that agents or engineers run directly?

6. **README**
   - Does `README.md` link to `AGENTS.md`, `INVARIANTS.md`, and Skills?
   - Does it have a "For Agents" section?
   - **Accuracy**: Cross-check README.md claims against the actual codebase. Flag any claim that contradicts code: version numbers, dependency names, build commands, API endpoint paths, environment variable names. List each discrepancy with `file:line` evidence.

For each item found, classify as ✅ complete, ⚠️ needs work, or ❌ missing, and specify the required action.

Rules for actions:
- `CLAUDE.md` missing → action is **create shim**, but only if Claude Code is a target — see `SKILL.md` Step 3's M1 gate: a `CLAUDE.md` or `.claude/` directory already existing means it is; otherwise ask the developer. If Claude Code is not a target, no action — do not create a shim unconditionally.
- Files with real content in non-canonical locations (`.github/instructions/`, `.cursor/rules/`, `.cursorrules`, a `.claude/skills/<name>/` holding an actual `SKILL.md`, etc.): action is **migrate content to `.agents/skills/`, then DELETE**. "Update paths" and "keep as shim" are not valid actions.
- Exception — a `.claude/skills/<name>` **symlink** pointing to `.agents/skills/<name>` is a valid pointer, not content: it is how Claude Code discovers the canonical skill. Leave it. Real content in `.claude/skills/<name>/` should be migrated to `.agents/skills/`, then replaced with such a symlink.
- `applyTo` scope in `.github/instructions/` files is not a reason to preserve them — note the scope so it can be expressed in the SKILL.md description field.
```

**Using the output:**

The inventory classifies each artifact as complete, needs work, or missing, and identifies which migrations apply. Use the classification to populate the migration decision table in the SKILL.md and determine run order.
