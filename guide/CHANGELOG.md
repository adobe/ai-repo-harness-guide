# Changelog — Guide

All notable changes to *Repository Harnesses for AI Coding Agents: A Practical Guide* are tracked here.

**Skills version independently.** Each skill has its own changelog under `.agents/skills/<skill>/CHANGELOG.md`.

---

## 1.1.0 (2026-08-05)

### Changed
- **Introduction** ([`guide/00-Introduction.md`](00-Introduction.md)): reworked *Why This Matters* — replaced the "For engineers / For managers" split with unified prose, and added the human-reviewed-context argument (checking vetted context into the codebase makes agent responses more predictable across sessions and reduces the repeated repository-level rediscovery each session would otherwise do).
- **Install docs — canonical page** ([`guide/README.md`](README.md)): `guide/README.md → Skills` is now the single source for per-tool install/update instructions. Reframed the GitHub Copilot section around the Claude-format marketplace manifest (same `repo-harness` plugin via `copilot plugin marketplace add` / `install`, or the `chat.plugins.marketplaces` setting), with the standalone `.vsix` as a niche fallback. Labeled the VS Code Agent Plugins path as **Preview**, and scoped the "not automatic" update guidance per install method (native scan tracks the checkout, copies must be re-copied, Cursor uses the scan).
- **Deduplicated install docs** ([`README.md`](../README.md), [`harness-plugin/README.md`](../harness-plugin/README.md), [`AGENTS.md`](../AGENTS.md)): removed the copied per-tool install blocks (per `INVARIANTS.md` "link, don't copy") — the root README and plugin README now link to the canonical page, and the `AGENTS.md` Module Context pointer replaces its stale `/plugin install repo-harness` command with a link.

### Added
- **Update instructions** ([`guide/README.md`](README.md)): documented that plugin/marketplace updates are not automatic by default (except VS Code's periodic extension check) and added the per-tool update commands — Claude Code [auto-updates](https://code.claude.com/docs/en/discover-plugins#configure-auto-updates) or manual `/plugin update`, and `copilot plugin update` (Copilot CLI).

---

## 1.0.0 (2026-08-01)

Initial public release.

- **Ten-chapter guide** (00–09) covering the case for repository harnesses, the five control layers, seven harness components, how agents navigate a harness, a reference repository layout, and step-by-step guides to build, migrate, and maintain a harness — plus a reading list, FAQ, and this changelog.
- **Two skills** — `harness-setup` (build or migrate a harness; pairs with chapters 7–8) and `harness-inspect` (health check or full audit of an existing harness; pairs with chapter 9) — installable via the Claude Code and Cursor plugins, or read natively by any agent that supports `.agents/skills/`.
- **Plugin distribution**: Claude Code (`.claude-plugin/`) and Cursor (`.cursor-plugin/`) marketplace manifests, plus a `harness-plugin/` package for VS Code / GitHub Copilot.
- **Reference layout**: this repository is itself structured as the harness it describes — `AGENTS.md`, `INVARIANTS.md`, `.agents/skills/`, and a `CLAUDE.md` shim.
