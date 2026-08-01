# Validation

Two prompts — run both after completing either path.

**Do not write validation output to a file.** Report inline, in the conversation.

A self-graded assessment persisted as a doc — verdict tables, health scores, "Action Items
Addressed" checklists — is not a measurement. An LLM reviewing its own output produces a
self-impression, not an audit. The confident form (percentages, ✅ checkboxes) makes results
look more authoritative than they are, which makes developers *less* likely to inspect the
underlying claims.

---

## Structural Validation

Verifies everything is in the right place. Run this first.

**Prompt:**

```
I've completed harness work on this repository. Please validate:

1. **No orphaned content**: Does any guidance, constraint, or rule exist only in a non-canonical
   file (CLAUDE.md real content, .cursorrules, .github/instructions/, .claude/) and not in
   AGENTS.md, INVARIANTS.md, or a SKILL.md?

2. **No duplication**: Is the same content stated in more than one file? Each piece of guidance
   should have one canonical location.

3. **CLAUDE.md is a shim**: Does CLAUDE.md contain only @-references?

4. **AGENTS.md is operational**: Does AGENTS.md contain only operational context (roles, footguns,
   decision links, module context) — no hard constraints?

5. **INVARIANTS.md is complete**: Does INVARIANTS.md contain all hard constraints, each with an
   "Enforced by:" annotation?

6. **Skills in canonical location, originals deleted**: Are all real SKILL.md files under
   `.agents/skills/<name>/`? Are `.github/instructions/`, `.cursor/rules/`, and `.cursorrules/`
   empty or absent? `.claude/skills/` must hold no real content — only symlinks pointing to
   `.agents/skills/<name>` (Claude Code's discovery path) are permitted there.

7. **Skills are warranted, not generic**: Skills are optional — do not flag as incomplete if none
   exist. For each SKILL.md present, does it map to a task type this repo's agents actually perform
   regularly, and does it add procedure beyond what AGENTS.md/INVARIANTS.md already say? Flag any
   skill that is generic boilerplate or duplicates canonical content instead.

8. **Makefile has required targets**: Does `make check` run lint + typecheck + test?

9. **Cross-links are intact**: Does AGENTS.md link to module-level files, and vice versa?
   Does README.md link to AGENTS.md and Skills? Are README.md's factual claims accurate —
   version numbers, build commands, environment variable names, and API paths verified against
   file:line evidence?

10. **No unreviewed citations**: Do any harness files contain `[review: ...]` markers? These are
    temporary source citations added during generation for the reviewer to confirm and then delete.
    Their presence in a committed file means the review step was skipped.

11. **Files are concise**: Do files in the harness contain only what is necessary? Flag any file
    with redundant restatements, filler sentences, or content already covered in another canonical file.

Report inline as a checklist: ✅ complete, ⚠️ partial, ❌ missing. Do not write this to a file.
```

**Target**: All 10 items ✅. The harness is complete when the [validation checklist in chapter 07](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/07-Build-Your-Harness.md#validation-checklist-is-your-harness-complete) is fully satisfied.

---

## Behavioral Tests

Verifies that agents can actually use the harness correctly. Run these after the structural validation passes.

### Test 1: Agent Discovery

Tests that AGENTS.md, module-level files, and Skills are discoverable and coherent.

**Prompt:**

```
You're an AI agent working in a new repository. Your task:

1. Discover the repository structure
2. Read AGENTS.md and the nearest relevant module-level AGENTS.md to understand constraints
3. Identify which SKILL applies to your task
4. Summarize what you learned

Go to the repository and:
- List the directory structure
- Read AGENTS.md and the nearest relevant module-level AGENTS.md, then summarize the applicable invariants and local constraints
- Read the relevant SKILL.md for your task
- List the commands available in Makefile

Then navigate into one subdirectory that has a module-level AGENTS.md and answer:
- What local constraints does it add?
- Which root constraints does it inherit?
- What footguns are specific to that module?

Report back with a structured summary.
```

**Expected**: Agent reads AGENTS.md first, locates module-level file when navigating, distinguishes local from inherited constraints, identifies the right Skill, knows available validation commands.

### Test 2: Constraint Validation

Tests that INVARIANTS.md is specific enough to catch real violations.

**Prompt:**

```
I've written a new feature that:
- Adds a new POST endpoint to create users
- Stores the password in the database
- Doesn't have any tests yet

Please review this code against INVARIANTS.md and AGENTS.md.

What constraints does it violate?
What should I fix before submitting?
```

**Expected**: Agent identifies violations (passwords must be hashed, tests required, endpoint must be in openapi.yaml if applicable) and provides specific fixes.

### Test 3: Skill Execution (skip if no relevant skill exists)

Tests that Skills guide agents through the correct process. Skip this test if the repo has no
skill covering implementation-type work — skills are optional, so this is not a failure.

**Prompt:**

```
I want to implement a new feature:
Add a GET /api/users/{id}/settings endpoint to retrieve user settings.

I have the openapi.yaml spec ready.

Using the implementation SKILL, walk me through implementing this step-by-step.
What do I need to do? What tests should I write?
```

**Expected**: Agent references the implementation SKILL.md, follows spec → code → tests → docs order, cites relevant constraints, provides concrete examples.

