# M1: CLAUDE.md

**Target state**: `CLAUDE.md` contains only `@AGENTS.md` and `@INVARIANTS.md` references — nothing else. All real content lives in `AGENTS.md` and `INVARIANTS.md`.

> **Applies only when Claude Code is a target.** The `CLAUDE.md` shim and the `.claude/skills/` symlinks below are Claude-Code-specific compatibility artifacts — Copilot, Cursor, and Codex read `AGENTS.md` and `.agents/skills/` natively and need neither. If a `CLAUDE.md` or a `.claude/` directory already exists, Claude Code is a target — proceed. If neither exists, ask the developer whether they use Claude Code before running this work item; if they don't, skip it entirely — no shim, no symlinks.

---

## Create or Consolidate CLAUDE.md

**Prompt:**

```
Inspect CLAUDE.md in the repository root (it may not exist yet).

1. If CLAUDE.md does not exist:
   Copy assets/CLAUDE.md.template without modification.
   Omit the @INVARIANTS.md line only if INVARIANTS.md does not exist and will not be created in M2.
   Report: "Created CLAUDE.md shim."

2. If CLAUDE.md exists and already contains only @-references pointing to AGENTS.md and INVARIANTS.md:
   Report: "CLAUDE.md is already a shim — no action needed."

3. If CLAUDE.md exists with real content (rules, constraints, documentation):
   Read AGENTS.md from the repository root (note if it doesn't exist yet).

   a. Classify each section of CLAUDE.md:
      - Operational context (roles, responsibilities, boundaries) → AGENTS.md
      - Hard constraints (non-negotiables, security rules) → INVARIANTS.md
      - Content already present in AGENTS.md → drop (do not duplicate)

   b. Produce an updated AGENTS.md that merges the operational content.
      Keep existing content intact; add migrated sections where they logically fit.

   c. Produce an updated INVARIANTS.md (or create it) with any hard constraints.

   d. Produce the new CLAUDE.md from assets/CLAUDE.md.template.
      Omit the @INVARIANTS.md line only if INVARIANTS.md does not exist and was not created in step c.

   Show all changed files in full.
```

**Expected result:**
- `CLAUDE.md` has 3–5 lines (header + `@` references, nothing else)
- If content was migrated: every constraint from the old `CLAUDE.md` is findable in `AGENTS.md` or `INVARIANTS.md`
- Diff old vs. new `AGENTS.md` to confirm nothing was dropped

---

## Claude Code Skill Symlinks

Claude Code does not scan `.agents/skills/` — it discovers skills only under `.claude/skills/` (and `~/.claude/skills/`). For each skill, add a symlink so Claude Code discovers it directly, giving both native auto-invocation and a persistent `/<skill-name>` command. The symlink points to the canonical skill, so nothing is duplicated.

Prefer a symlink over a `.claude/commands/<skill-name>.md` `@`-reference shim: a command shim gives only the manual `/<skill-name>` command (no auto-invocation) and is the legacy surface — custom commands have been merged into skills.

**Prompt:**

```
For each skill under .agents/skills/, create a relative symlink under .claude/skills/ that points to it:

  mkdir -p .claude/skills
  ln -s ../../.agents/skills/<skill-name> .claude/skills/<skill-name>

.claude/skills/ may not exist yet (a repo can have a .claude/ directory with only settings.local.json).
Use a relative target (../../.agents/...) so the link survives clones and checkouts.
Do not copy SKILL.md content into .claude/skills/ — the symlink is the only artifact.
Verify each link resolves: .claude/skills/<skill-name>/SKILL.md must be readable.

If .claude/commands/<skill-name>.md already exists for this skill, delete it once the symlink is
in place. Leaving both is not a neutral extra — it is the exact "redundant legacy surface" a
harness-inspect run would flag as a quick fix, and a repo that already ran this skill before is a
common way to end up with the shim never cleaned up.
```

**Note (Windows / `core.symlinks`)**: Git only checks out a committed symlink as a real link when `core.symlinks` is enabled — auto-detected `true` on Linux and macOS, but often `false` on Windows without Developer Mode and symlink-enabled Git. Where symlinks are unavailable, either have the user enable Developer Mode and run `git config core.symlinks true`, or fall back to a `.claude/commands/<skill-name>.md` file containing a single `@.agents/skills/<skill-name>/SKILL.md` line — that restores the `/<skill-name>` command (manual only, no auto-invocation).
