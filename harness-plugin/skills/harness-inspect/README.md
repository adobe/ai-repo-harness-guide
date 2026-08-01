# Harness Inspect

Audit an existing harness for rot, gaps, and improvement opportunities. Two modes — health check (quick pass) or full audit (thorough assessment).

| |  |
|---|---|
| **Version** | [CHANGELOG.md](CHANGELOG.md) |
| **Author** | [Arne Franken](https://github.com/afranken) |
| **Visibility** | Public |

---

## When to use

| Trigger | Mode |
|---|---|
| Monthly cadence | Health check |
| After any structural change, `Makefile` edit, or harness-file change | Health check |
| Quarterly cadence | Full audit |
| After an agent incident or major refactor | Full audit |
| After adopting a new AI tool or runtime | Full audit |
| Health check surfaced more than one or two issues | Escalate to full audit |

If the repository has no harness yet, or has one that needs migration, use the `harness-setup` skill first. It scans for existing artifacts and chooses the right path automatically.

## How to execute

Invoke the skill from any agent that supports the [Agent Skills spec](https://agentskills.io/specification):

```
/repo-harness:harness-inspect
```

To run a specific mode directly — bypasses the interactive prompt, useful in CI:

```
/repo-harness:harness-inspect health-check
/repo-harness:harness-inspect full-audit
```

Claude Code does not scan `.agents/skills/` — symlink this skill into a Claude skills directory so it's discovered (both auto-invocation and `/harness-inspect`): `ln -s <repo>/.agents/skills/harness-inspect ~/.claude/skills/harness-inspect` for a user-global install, or `.claude/skills/harness-inspect` → `.agents/skills/harness-inspect` inside a repo.

> **Run this through the runtime your agents actually use in production.** Some runtimes (e.g., AWS Bedrock agents) re-route or override system prompts in ways that can silently drop `INVARIANTS.md` content. An audit run in Claude Code or against the raw model API may pass while the production runtime is operating without the invariants. The Health Check's question 2 (constraint propagation) is designed to catch this.

## What to expect

**Health check** — ten questions, pass/fail per question, action items only:

1. **Integrity** — file paths, commands, and links resolve
2. **Constraint propagation** — invariants actually reach the model
3. **Sensors** — `make check` passes
4. **Coverage gaps** — module-level `AGENTS.md` files where they should exist
5. **Enforcement gaps** — `INVARIANTS.md` items that could move from human review to automation
6. **Footgun freshness** — known footguns in `AGENTS.md` are still active
7. **Token budget** — auto-loaded total ≤ 4,000 tokens (tokenizer-relative heuristic; see chapter 09 *Context Budget*; override via `INVARIANTS.md`)
8. **File size discipline** — core files within line budget AND using progressive discovery (see chapter 04; override via `INVARIANTS.md`)
9. **Content accuracy** — factual claims in harness files (versions, paths, commands) match actual source files
10. **Claude Code integration** — *only if Claude Code is a target* (`CLAUDE.md` or `.claude/` present): skills are discoverable via resolving `.claude/skills/` symlinks, and no stale `.claude/commands/` `@`-shims duplicate them

**Full audit** — eight-step assessment producing a verdict table. For repeat runs, paste the prior verdict table into the prompt — the agent produces a delta automatically.

## Prerequisites

- Read access to the repository
- An existing harness to audit (run `/harness-setup` first if there isn't one)
- (Optional) Prior verdict table pasted into the prompt for delta tracking

## Background

This skill operationalizes [chapter 09 — Keep It Current](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/09-Keep-It-Current.md) of *Repository Harnesses for AI Coding Agents: A Practical Guide*.

Full guide: **https://github.com/adobe/ai-repo-harness-guide**
