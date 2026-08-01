# INVARIANTS.md — Hard Constraints

These are non-negotiable. Violations require explicit human sign-off.
All constraints are enforced by human review — this is a documentation repository with no automated checks.

## Canonical Locations

- Agent context in `AGENTS.md`; skills in `.agents/skills/<skill-name>/SKILL.md`
- No agent-facing **content** in tool-specific directories (`.claude/`, `.cursor/`, `.github/instructions/`)
- **Pointers back to canonical locations are the one exception** — a `.claude/skills/<name>` symlink to `.agents/skills/<name>`, or a `CLAUDE.md` / `.claude/commands/*` `@`-reference. Never real content. Claude Code does not scan `.agents/skills/`, so a symlink is what makes each skill discoverable (native auto-invocation *and* `/name`) without duplicating it. Prefer symlinks over `@`-reference command shims: the symlink *is* the canonical file and restores auto-invocation, which a `.claude/commands` shim does not provide.
- `CLAUDE.md` contains only `@`-references — not a location for real content
- **Exception**: plugin distribution manifests (`.claude-plugin/marketplace.json`, `harness-plugin/.claude-plugin/plugin.json`, `.cursor-plugin/marketplace.json`, `harness-plugin/.cursor-plugin/plugin.json`, `harness-plugin/package.json`) are exempt — they contain distribution metadata, not agent-facing content

## Content Rules

- No duplication: if a point exists in one file, link to it — do not copy it
- Mermaid only — no ASCII art for diagrams. **Exception**: directory/file listings (e.g. `tree`-style `├──`/`└──` blocks showing a repository layout) are listings, not diagrams of a relationship, and are exempt.
- **Prompts live only in `.agents/skills/<skill>/references/`** — chapters 07–09 describe and link, never duplicate. The skill references are the single source of truth. Pairings: chapter 07 ↔ `harness-setup` (create path), 08 ↔ `harness-setup` (migrate path), 09 ↔ `harness-inspect`. Editing a prompt in either place is editing both — but only one copy exists, so drift is structurally impossible.
- `guide/README.md` is the navigation hub — every document links to adjacent documents where relevant
- SKILL.md front matter is minimal — include only what an agent needs to select and invoke the skill
- **Skills** (`harness-setup`, `harness-inspect`) are installed via symlink from this repo and MUST be self-contained. Allowed external references: (a) absolute HTTPS URLs to the guide repo (chapters, `INVARIANTS.md`, `guide/README.md`, `guide/CHANGELOG.md`); (b) external specs and articles via absolute HTTPS. **Inter-skill links are NOT allowed**, relative or absolute — users may have only one skill installed and the symlinked directory structure is unknown. Mention other skills by name only (e.g., *"use the `harness-inspect` skill instead"*), without a link. The internal `documentation` skill is not symlinked — relative paths are fine.

## Context Budget

This repo overrides the guide's default thresholds (4,000 warn / 8,000 polluting) with tighter values appropriate to a small documentation repository. Larger codebases that implement a full harness should keep the guide defaults or raise them further.

- Auto-loaded content (root `AGENTS.md`, `INVARIANTS.md`, `CLAUDE.md` shim) ≤ 2,000 tokens — *Enforced by: harness-inspect Q7 (warning)*
- Polluting threshold: 4,000 tokens — *Enforced by: harness-inspect full audit (❌)*

## File Size Budget

This repo uses the guide's default line budgets (small documentation repo; no override needed).

- Root and module-level `AGENTS.md` files ≤ 200 lines — *Enforced by: harness-inspect Q8*
- `SKILL.md` ≤ 100 lines (excluding `references/`, `scripts/`, `assets/`) — *Enforced by: harness-inspect Q8*
