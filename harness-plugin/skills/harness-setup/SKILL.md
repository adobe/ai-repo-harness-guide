---
name: harness-setup
description: Build or extend a repository harness. Understands the repo first, then determines what to build, migrate, or create based on what exists.
metadata:
  author: https://github.com/afranken
  version: 1.0.0
  visibility: public
---

# Harness Setup

One execution sequence. Work items apply based on what the repo needs — there is no upfront routing decision.

## Mode selection

Check for an argument before doing anything else:

| Argument | Mode |
|---|---|
| `interactive` | Pause after each section for review before proceeding |
| `one-shot` | Generate all sections without pausing (prepend verification warning to each file) |
| *(none)* | Ask: *"Interactive (I pause after each section) or one-shot (generate all at once, with a verification warning)?"* |

Carry the chosen mode through all steps — do not ask again.

## Step 1: Before/After Probe

Load `references/before-after-probe.md` and record current agent behavior before making any changes.

## Step 2: Understand the Repository

Run the scan for a quick artifact overview (optional but fast):

```bash
bash .agents/skills/harness-setup/scripts/scan.sh
```

Then load and run both prompts in `references/discovery.md`, followed by the prompt in `references/inventory.md`. Capture all output before creating any files.

- **Discovery** answers: what is this repo — language, frameworks, constraints, testing, build system
- **Inventory** answers: what harness artifacts exist, what is missing, what is in the wrong place

**Multi-pass analysis**: Run every analysis prompt twice independently — without referencing your first pass on the second run. Resolve disagreements before proceeding.

## Step 3: Plan

From the combined discovery and inventory output, determine which work items apply and which sub-path each takes:

| Work item | Applies when | Reference |
|-----------|-------------|-----------|
| M0: README scope and accuracy | Always | `references/readme.md` |
| M1: CLAUDE.md shim + `.claude/skills/` symlinks | Claude Code is a target (see gate below) — skip entirely otherwise | `references/claude.md` |
| M2: AGENTS.md + INVARIANTS.md | Missing, mixes concerns, or no INVARIANTS.md | `references/agents.md` |
| M3: Module-level AGENTS.md | Root AGENTS.md over line budget, or high-risk dirs undocumented | `references/agents.md` |
| M4: Skills | Always — ask whether any task type warrants a new skill (developer may decline); consolidate from non-canonical locations whenever they exist | `references/skills.md` |
| M5: Makefile | Missing targets or no Makefile | `references/makefile.md` |
| M6: docs/ | Any of ARCHITECTURE.md, DECISIONS.md, SETUP.md, TESTING.md, CONTRIBUTING.md missing | `references/docs.md` |

**M1 gate — is Claude Code a target?** The `CLAUDE.md` shim and `.claude/skills/` symlinks are Claude-Code-specific compatibility artifacts, not part of the portable harness — Copilot, Cursor, and Codex read `AGENTS.md` and `.agents/skills/` natively and need neither. Decide before running M1:
- A `CLAUDE.md` or a `.claude/` directory already exists → Claude Code is a target; run M1.
- Neither exists → **ask the developer**: *"Do you use Claude Code in this repo? I'll add a `CLAUDE.md` shim and `.claude/skills/` symlinks only if so — other tools read `AGENTS.md` and `.agents/skills/` natively and need neither."* If they decline, skip M1 entirely (no shim, no symlinks) and record the decision in the plan. Carry the answer through; do not ask again.

**Run order**: M0 → M2 → M1 → M3 → M4 → M5 → M6

**Plan before changes**: Write out which work items apply, which sub-path each takes, and in what order. Present for confirmation before making any changes. If your tool supports a planning mode (e.g., Claude Code `/model opusplan`), use it for Steps 2–3, then switch to execution mode.

## Step 4: Execute

Load `references/bootstrap.md` — shared conventions (identifier-grounding, interaction pattern, execution mode) that apply to every work item.

Work through the plan in order. For each work item:

- **Artifact exists with good content** → extend only where needed, leave the rest untouched
- **Artifact exists in the wrong location** → migrate content to canonical location, then delete the original
- **Artifact is missing** → create from scratch using the reference file

Never delete a file before confirming its content is preserved or no longer needed.

## Step 5: Validate

Load `references/validation.md` and run both prompts. Run the Before/After Probe again.

## Step 6: Review

Load `references/review-panel.md` and run all four reviewers. Each reads fresh — do not carry forward context from previous steps. Surface findings inline; do not write to a file.
