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

The two skills ship with this guide and work in **Claude Code, GitHub Copilot, and Cursor**. Any agent that scans `.agents/skills/` reads them with no install; a `repo-harness` plugin (source: [`harness-plugin/`](harness-plugin/)) is also published through Claude- and Cursor-format marketplace manifests, and the Claude-format manifest is auto-detected by GitHub Copilot.

**See [`guide/README.md` → Skills](guide/README.md#skills) for the canonical per-tool install and update instructions** (Claude Code, Copilot CLI/VS Code, Cursor).

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). By participating you agree to the [code of conduct](CODE_OF_CONDUCT.md).

## License

Apache 2.0 — see [LICENSE](LICENSE).

- **Current**: 1.1.0 (2026-08-05) — see [CHANGELOG.md](guide/CHANGELOG.md) for history
- **Site**: [opensource.adobe.com/ai-repo-harness-guide](https://opensource.adobe.com/ai-repo-harness-guide/)
- **Author**: [Arne Franken](https://github.com/afranken)
- **Audience**: Technical practitioners building AI-assisted systems
