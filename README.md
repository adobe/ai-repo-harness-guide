# Repository Harnesses for AI Coding Agents

A practical guide for building **repository harnesses** — the repository-local control systems that make AI-assisted coding reliable and repeatable.

> Humans: read this guide at **[opensource.adobe.com/ai-repo-harness-guide](https://opensource.adobe.com/ai-repo-harness-guide/)** — or browse raw markdown starting at [Introduction](guide/00-Introduction.md).

---

## Guide

| # | Document | Audience | Purpose |
|---|----------|----------|---------|
| — | [Introduction](guide/00-Introduction.md) | All | Guide overview, scope, and reading paths |
| 1 | [Beyond Prompting](guide/01-Beyond-Prompting.md) | All | The problem, the solution, and why the framing matters |
| 2 | [What a Harness Is](guide/02-What-a-Harness-Is.md) | All | What a harness is; the five control layers; maturity spectrum |
| 3 | [Five Control Layers](guide/03-Five-Control-Layers.md) | Engineers | Five control layers in depth |
| 4 | [Harness Components](guide/04-Harness-Components.md) | Engineers | Seven concrete harness components |
| 5 | [How Agents Navigate](guide/05-How-Agents-Navigate.md) | Engineers | How agents operate within a harness |
| 6 | [Reference Layout](guide/06-Reference-Layout.md) | Engineers | Reference production repository structure |
| 7 | [Build Your Harness](guide/07-Build-Your-Harness.md) | Engineers | Step-by-step implementation with discovery prompts |
| 8 | [Migrate Your Harness](guide/08-Migrate-Your-Harness.md) | Engineers | Migrating a partial implementation to a full harness |
| 9 | [Keep It Current](guide/09-Keep-It-Current.md) | Engineers | Keeping the harness current: inspection prompts and cadence |

---

## What's in this repo

| Path | Contents |
|------|----------|
| [`guide/`](guide/) | Ten-chapter guide (00–09) plus reading list, FAQ, and changelog |
| [`.agents/skills/`](.agents/skills/) | `harness-setup` and `harness-inspect` skills for Claude Code, Cursor, and Copilot — symlinked from `harness-plugin/skills/`, their canonical source |
| [`.claude-plugin/`](.claude-plugin/) | Claude Code plugin manifest |
| [`.cursor-plugin/`](.cursor-plugin/) | Cursor plugin manifest |
| [`harness-plugin/`](harness-plugin/) | Canonical skill source (both marketplaces point here) plus Claude/Cursor plugin manifests and an optional VS Code/Copilot extension |

---

## Install the skills

The two skills ship with this guide and work in Claude Code, GitHub Copilot, and Cursor. One `repo-harness` plugin (source: [`harness-plugin/`](harness-plugin/)) is published through Claude- and Cursor-format marketplace manifests; the Claude-format manifest is also auto-detected by GitHub Copilot. Any agent that scans `.agents/skills/` can also read the skills with no install at all.

> **Updates are not automatic** (except VS Code's periodic extension check). After the guide ships a new skill version, run the update command for your tool — see each section below.

### Claude Code

```
/plugin marketplace add adobe/ai-repo-harness-guide
/plugin install repo-harness@repo-harness
```

Then invoke with `/repo-harness:harness-setup` or `/repo-harness:harness-inspect`.

Update later by enabling [auto-updates](https://code.claude.com/docs/en/discover-plugins#configure-auto-updates), or manually with `/plugin marketplace update repo-harness` (refresh the catalog) then `/plugin update repo-harness`.

### GitHub Copilot

**Zero-config (recommended for this repo):** Copilot natively scans `.agents/skills/` — open this repo as a VS Code workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project) and the skills are available immediately, always in sync with the checkout.

**Install without cloning (CLI):** Copilot auto-detects the Claude-format marketplace manifest.

```
copilot plugin marketplace add adobe/ai-repo-harness-guide
copilot plugin install repo-harness@repo-harness
```

Update later with `copilot plugin update repo-harness` (installs pin a version — this does not happen automatically).

**Install without cloning (VS Code):** add `"chat.plugins.marketplaces": ["adobe/ai-repo-harness-guide"]` to `settings.json`, then install `repo-harness` from the **Agent Plugins** view. VS Code re-checks marketplace repos every 24h when `extensions.autoUpdate` is on, or update manually with **Extensions: Check for Extension Updates**.

A standalone `.vsix` extension is a niche fallback only — see [`harness-plugin/README.md`](harness-plugin/README.md).

### Cursor (2.5+)

Cursor natively reads `.agents/skills/` — open this repo as a workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Skills are available immediately. A `.cursor-plugin/` marketplace manifest is also included for future Cursor Marketplace submission.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). By participating you agree to the [code of conduct](CODE_OF_CONDUCT.md).

## License

Apache 2.0 — see [LICENSE](LICENSE).

- **Current**: 1.0.1 (2026-08-05) — see [CHANGELOG.md](guide/CHANGELOG.md) for history
- **Site**: [opensource.adobe.com/ai-repo-harness-guide](https://opensource.adobe.com/ai-repo-harness-guide/)
- **Author**: [Arne Franken](https://github.com/afranken)
- **Audience**: Technical practitioners building AI-assisted systems
