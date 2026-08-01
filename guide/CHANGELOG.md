# Changelog — Guide

All notable changes to *Repository Harnesses for AI Coding Agents: A Practical Guide* are tracked here.

**Skills version independently.** Each skill has its own changelog under `.agents/skills/<skill>/CHANGELOG.md`.

---

## 1.0.0 (2026-08-01)

Initial public release.

- **Ten-chapter guide** (00–09) covering the case for repository harnesses, the five control layers, seven harness components, how agents navigate a harness, a reference repository layout, and step-by-step guides to build, migrate, and maintain a harness — plus a reading list, FAQ, and this changelog.
- **Two skills** — `harness-setup` (build or migrate a harness; pairs with chapters 7–8) and `harness-inspect` (health check or full audit of an existing harness; pairs with chapter 9) — installable via the Claude Code and Cursor plugins, or read natively by any agent that supports `.agents/skills/`.
- **Plugin distribution**: Claude Code (`.claude-plugin/`) and Cursor (`.cursor-plugin/`) marketplace manifests, plus a `harness-plugin/` package for VS Code / GitHub Copilot.
- **Reference layout**: this repository is itself structured as the harness it describes — `AGENTS.md`, `INVARIANTS.md`, `.agents/skills/`, and a `CLAUDE.md` shim.
