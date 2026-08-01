# Harness Setup

Build or migrate a repository harness.

| | |
|---|---|
| **Version** | [CHANGELOG.md](CHANGELOG.md) |
| **Author** | [Arne Franken](https://github.com/afranken) |
| **Visibility** | Public |

---

## When to use

Use this skill whenever you need to establish or repair a repository harness — regardless of the repository's current state. The skill scans for existing files and chooses the right path automatically:

| Current state | What happens |
|---|---|
| No harness files at all | Create path — five phases from scratch |
| Tool-specific files (`.cursorrules`, `.github/instructions/`, `.claude/`) | Migrate path — consolidate into canonical locations |
| `AGENTS.md` exists but is monolithic or stale | Migrate path — split, trim, fill gaps |
| `CLAUDE.md` contains real content | Migrate path — extract to AGENTS.md / INVARIANTS.md |
| Partial canonical harness (missing docs, Makefile, skills) | Migrate path — fill gaps only |

---

## Prerequisites

- Git repository (the scanner uses `git rev-parse` to find the repo root, falling back to `pwd`)
- Bash 3.2+ (macOS default) or later

---

## Usage

Invoke the `harness-setup` skill in your AI coding tool. The SKILL.md will guide you through:

1. Running `scripts/scan.sh` to detect existing artifacts
2. Following either the migrate or create path based on the scan result
3. Validating the result with the Before/After Probe and structural/behavioral tests

To set the execution mode upfront — bypasses the interactive prompt, useful in CI or scripted runs:

```
/repo-harness:harness-setup interactive
/repo-harness:harness-setup one-shot
```

---

## Structure

- `SKILL.md` — agent-facing instructions
- `scripts/scan.sh` — artifact scanner
- `assets/` — templates: AGENTS.md, module-AGENTS.md, INVARIANTS.md, CLAUDE.md, Makefile
- `references/` — one file per work item (see table in SKILL.md), plus discovery, inventory, validation, and shared conventions
- `evals/evals.json` — test cases

For work item definitions and run order, see the table in `SKILL.md`.

---

## Related

This skill is described in the guide at:
- **[Chapter 07 — Build Your Harness](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/07-Build-Your-Harness.md)** (create path)
- **[Chapter 08 — Migrate Your Harness](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/08-Migrate-Your-Harness.md)** (migrate path)

Use the `harness-inspect` skill for ongoing health checks and audits after setup is complete.
