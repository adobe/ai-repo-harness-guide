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

The two skills ship with this guide and work in Claude Code, GitHub Copilot, and Cursor. One `repo-harness` plugin (source: `harness-plugin/`) is published through Claude- and Cursor-format marketplace manifests; the Claude-format manifest is also auto-detected by GitHub Copilot. Any agent that scans `.agents/skills/` can read the skills with no install.

> **Updates are not automatic** (except VS Code's periodic extension check). After a new skill version ships, run the update command for your tool — see each section below.

### Claude Code

```
/plugin marketplace add adobe/ai-repo-harness-guide
/plugin install repo-harness@repo-harness
```

Then invoke with `/repo-harness:harness-setup` or `/repo-harness:harness-inspect`.

Update later by enabling [auto-updates](https://code.claude.com/docs/en/discover-plugins#configure-auto-updates), or manually with `/plugin marketplace update repo-harness` then `/plugin update repo-harness`.

### GitHub Copilot

**Zero-config (recommended for this repo):** Copilot natively scans `.agents/skills/` — open this repo as a VS Code workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Skills are available immediately and always in sync with the checkout.

**Install without cloning (CLI):** Copilot auto-detects the Claude-format marketplace manifest.

```
copilot plugin marketplace add adobe/ai-repo-harness-guide
copilot plugin install repo-harness@repo-harness
```

Update later with `copilot plugin update repo-harness` — installs pin a version and do not update automatically.

**Install without cloning (VS Code):** add `"chat.plugins.marketplaces": ["adobe/ai-repo-harness-guide"]` to `settings.json`, then install `repo-harness` from the **Agent Plugins** view. VS Code re-checks marketplace repos every 24h when `extensions.autoUpdate` is on.

A standalone `.vsix` extension is a niche fallback only — see [`harness-plugin/README.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/harness-plugin/README.md).

### Cursor (2.5+)

Cursor natively reads `.agents/skills/` — open this repo as a workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Skills are available immediately.

A `.cursor-plugin/` marketplace manifest is included for future Cursor Marketplace submission.

---

## Version

- **Current**: 1.0.1 (2026-08-05) — see [CHANGELOG.md](CHANGELOG.md) for history
- **Site**: [opensource.adobe.com/ai-repo-harness-guide](https://opensource.adobe.com/ai-repo-harness-guide/)
- **Author**: [Arne Franken](https://github.com/afranken)
- **Audience**: Technical practitioners building AI-assisted systems
