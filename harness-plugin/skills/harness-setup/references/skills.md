# M4: Skills

---

## Create new skills (optional)

Skills are not required by default. A capable model often handles a repo's task types well from `AGENTS.md`/`INVARIANTS.md` context alone — only add a skill where a task type is frequent or error-prone enough that a dedicated procedure measurably helps.

**Always ask** — do not skip this step even in a clean repo with nothing to consolidate. Only create a `SKILL.md` for task types the developer actually names; do not create skills to hit a target count, and "none" is a complete, valid answer.

**Prompt:**

```
Ask the developer: "Which task types do agents handle often enough in this repo that a dedicated
SKILL.md would help — e.g. code review, implementation, testing, documentation, something specific
to this repo, or none of these?" Do not assume a default set, and skip this work item entirely if
the answer is "none."

For each task type named:

1. Check whether this repo's harness auto-loads AGENTS.md/INVARIANTS.md into every agent session
   (e.g. a CLAUDE.md shim, or native support in the target tool). If it does, the skill must NOT
   include a step telling the agent to (re-)read them — that content is already in context by the
   time the skill loads, and restating it is dead weight, not a safety net. If it doesn't, or the
   skill needs to stay portable across tools that vary on this, add one line pointing to them
   instead of restating their content. Module-level AGENTS.md files are the exception either way —
   they are not auto-loaded, so name the ones relevant to this task type as a Resource.

2. Ask the developer: "What has to be true for this task type to count as done in this repo?"
   Surface concrete candidates already visible in the repo — a CHANGELOG.md to update, a docs/
   file that needs a matching edit, a required test or lint command — rather than assuming a fixed
   list. A repo with no changelog gets no changelog step; a repo with one names it explicitly.

3. Ask the developer to scope the skill's checks in one or two sentences (what to look for, when
   to escalate to a human).

4. Create `.agents/skills/<task-type>/SKILL.md` following the Agent Skills spec structure
   (https://agentskills.io/specification):
   - Frontmatter: name and description only
   - Keep instructions procedural and concise
   - Do NOT duplicate content already in AGENTS.md, module-level AGENTS.md, or INVARIANTS.md
   - Reference canonical docs instead of restating them
   - Include clear entry criteria, execution steps, and the completion criteria from step 2

Present your draft for each major section (entry criteria, steps, completion criteria), then write
the complete SKILL.md. Repeat once per task type named.
```

---

## Consolidate from non-canonical locations

**Applies when**: You have any of the following:
- Files under `.cursor/rules/` (current Cursor location) or a `.cursorrules` file (legacy)
- `.github/copilot-instructions.md` or files under `.github/instructions/`
- Files under `.claude/` that function as instructions or skills
- `SKILL.md` files that exist outside `.agents/skills/`

**Target state**: Every skill lives under `.agents/skills/<skill-name>/SKILL.md`. Tool-specific files are deleted.

### Step 1: Group Rules by Task Type

**Prompt:**

```
Based on the inventory, read all AI-tool-specific rule files identified — for example:
`.cursorrules`, files under `.cursor/rules/`, `.github/copilot-instructions.md`,
files under `.github/instructions/`, and any skill or instruction files under `.claude/`.

Please analyze the content and group the rules into logical task types. For each group:
- Suggest a skill name (e.g., code-review, implementation, write-tests, refactoring, documentation)
- List which rules belong in that skill
- Flag any rules that are actually constraints (belonging in AGENTS.md or INVARIANTS.md rather than a Skill)
- Flag any rules that are model-specific quirks (may not be needed in a portable Skill)

Output a table: Rule → Skill or File (AGENTS.md / INVARIANTS.md / discard)
```

### Step 2: Convert Each Group to a SKILL.md

**Prompt:**

```
Convert the rules for the "<skill-name>" skill to a SKILL.md.
Use the grouping and constraint flags from the Step 1 analysis above (already in context).

The file must follow the Agent Skills spec (https://agentskills.io/specification):
- Front matter: name and description only — loaded on every agent instance
- Instructions: procedural and concise
- Do NOT duplicate content from AGENTS.md or INVARIANTS.md; reference them instead
- Include clear entry criteria, execution steps, and completion criteria
- Add a Resources section with the files an agent needs to read for this skill

Produce the complete .agents/skills/<skill-name>/SKILL.md
```

Repeat for each skill group identified in Step 1.

### Step 3: Delete Non-Canonical Files

Once all skill content is in `.agents/skills/`, delete every non-canonical file.

| File | Action after consolidation |
|------|---------------------------|
| `.cursor/rules/*.mdc` | Delete |
| `.cursorrules` | Delete (legacy location) |
| `.github/copilot-instructions.md` | Delete |
| `.github/instructions/<name>.md` | Delete — do not update paths or keep as a shim |
| `.claude/skills/<name>/` (real content) | Move content to `.agents/skills/<name>/SKILL.md`, then replace with a symlink `.claude/skills/<name>` → `.agents/skills/<name>`. A symlink already pointing at `.agents/skills/` is correct — leave it |
| `.claude/commands/<name>.md` | Replace with a symlink `.claude/skills/<name>` → `.agents/skills/<name>` — Claude Code does not scan `.agents/skills/`; the symlinked skill is discovered directly (auto-invocation *and* `/name`). A command shim gives only manual `/name` and is the legacy surface |
| `SKILL.md` outside `.agents/skills/` | Delete after moving content to `.agents/skills/<skill-name>/SKILL.md` |

**Note on `applyTo` scope**: When migrating `.github/instructions/` files, capture the scope in the SKILL.md's `description` field (e.g., *"Use when working with Java files"*). Then delete the `.github/instructions/` file — a shim from `.github/instructions/` into `.agents/` provides no benefit.
