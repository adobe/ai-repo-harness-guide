# Repository Harnesses for AI Coding Agents: A Practical Guide

## Documents

| # | Document | Audience | Purpose |
|---|----------|----------|---------|
| — | [Introduction](00-Introduction.md) | All | Guide overview, scope, and reading paths |
| 1 | [Beyond Prompting](01-Beyond-Prompting.md) | All | The problem, the solution, and why the framing matters |
| 2 | [What a Harness Is](02-What-a-Harness-Is.md) | All | What a harness is; the five control layers; maturity spectrum |
| 3 | [Five Control Layers](03-Five-Control-Layers.md) | Engineers | Five control layers in depth |
| 4 | [Harness Components](04-Harness-Components.md) | Engineers | Seven concrete harness components |
| 5 | [How Agents Navigate](05-How-Agents-Navigate.md) | Engineers | How agents operate within a harness |
| 6 | [Reference Layout](06-Reference-Layout.md) | Engineers | Reference production repository structure |
| 7 | [Build Your Harness](07-Build-Your-Harness.md) | Engineers | Step-by-step implementation with discovery prompts |
| 8 | [Migrate Your Harness](08-Migrate-Your-Harness.md) | Engineers | Migrating a partial implementation to a full harness |
| 9 | [Keep It Current](09-Keep-It-Current.md) | Engineers | Keeping the harness current: inspection prompts and cadence |

**Total read time:** ~2 hours 40 min for the complete series.

---

## Skills

This repository includes two skills for building and maintaining harnesses:

- **`harness-setup`** — builds a new harness or migrates scattered scaffolding to the canonical structure (pairs with chapters 7 and 8)
- **`harness-inspect`** — health check or full audit of an existing harness (pairs with chapter 9)

### Claude Code

```
/plugin marketplace add adobe/ai-repo-harness-guide
/plugin install repo-harness
```

Then invoke with `/repo-harness:harness-setup` or `/repo-harness:harness-inspect`.

### Cursor (2.5+)

Cursor natively reads `.agents/skills/` — open this repo as a workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Skills are available immediately.

A `.cursor-plugin/plugin.json` is included for future Cursor Marketplace submission.

### GitHub Copilot

Copilot natively reads `.agents/skills/` — open this repo as a VS Code workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Skills are available immediately.

For global install across all workspaces, see [`harness-plugin/README.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/harness-plugin/README.md).

---

## Version

- **Current**: 1.0.0 (2026-08-01) — see [CHANGELOG.md](CHANGELOG.md) for history
- **Site**: [opensource.adobe.com/ai-repo-harness-guide](https://opensource.adobe.com/ai-repo-harness-guide/)
- **Author**: [Arne Franken](https://github.com/afranken)
- **Audience**: Technical practitioners building AI-assisted systems
