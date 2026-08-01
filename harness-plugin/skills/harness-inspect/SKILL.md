---
name: harness-inspect
description: Audit an existing harness for rot, gaps, and improvement opportunities. Use monthly (health check, quick pass) or quarterly (full audit, thorough assessment), and after any agent incident, major refactor, or structural change.
metadata:
  author: https://github.com/afranken
  version: 1.0.0
  visibility: public
---

# Harness Inspect

Two modes. Choose based on available time and the trigger:

| Mode | Scope | When |
|------|-------|------|
| Health check | Quick pass | Monthly; after any structural change, `make` target rename, or harness file edit |
| Full audit | Thorough assessment | Quarterly; after an agent incident, major refactor, or new AI tool adoption |

If the health check surfaces issues, escalate to a full audit.

## Instructions

### Mode selection

Check for an argument before proceeding:

| Argument | Action |
|---|---|
| `health-check` | Run the health check directly — skip to the Health check section below |
| `full-audit` | Run the full audit directly — skip to the Full audit section below |
| *(none)* | Ask the user: *"Which mode — **health-check** (quick pass, monthly) or **full-audit** (thorough assessment, quarterly)?"* Do not assume a default. |

### Before starting (optional baseline)

Load `references/before-after-probe.md` to record current agent behavior before making changes. Run again after fixes to measure impact.

### Health check

Load `references/health-check.md` and run the prompt **twice independently** (without referencing your first pass on the second run). Compare pass/fail verdicts; resolve any disagreements. Report pass/fail for each of the ten questions and list action items only — no full analysis.

### Full audit

Load `references/full-audit.md` and run the prompt **twice independently** (without referencing your first pass on the second run). Compare verdicts; resolve disagreements. For repeat runs, fill in the inspection mode and paste the prior verdict table — the agent will produce a delta automatically.

### Processing results

| Finding type | Action |
|---|---|
| Rot | Fix immediately — stale guidance actively misleads agents |
| Critical gaps | Address before the next agent task in the affected area |
| Quick fixes | Address in the current session — they compound if deferred |
| Token optimizations | Address when convenient; reduces initialization cost over time |
| Larger improvements | Add to project backlog with the assessment date as context |

Before acting on any finding immediately (rot, quick fixes), write a specific plan — file, change, reason. If your tool supports a planning mode (e.g., Claude Code `/model opusplan`), use it for the audit run itself, then switch to execution mode for fixes.
