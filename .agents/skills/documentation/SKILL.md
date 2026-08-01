---
name: documentation
description: Write, edit, or restructure content in this repository harnesses guide. Use when adding, updating, or reviewing any of the nine numbered chapters (01–09) or the companion materials (`guide/README.md`, `guide/READING.md`, `guide/FAQ.md`).
when_to_use: When asked to write, edit, improve, or review content in this repository.
---

# Documentation

## Instructions

1. Read `AGENTS.md` first — understand the two-audience structure, document map, companion materials, invariants, and known footguns before touching any file.
2. Identify the right file for the task using the *Document Map* and *Companion Materials* tables in `AGENTS.md` — do not add content to the wrong file.
3. Search all nine numbered chapters for existing coverage of the topic. If it already exists, link to it — do not duplicate it.
4. Write for the correct audience:
   - 01–02: plain language, no implementation detail, accessible to non-technical readers
   - 03–09: precise technical language, assume engineering context
5. Follow the style rules:
   - Direct prose — no filler phrases, no meta-commentary ("this section explains…")
   - Short sentences; cut anything that doesn't add meaning
   - Mermaid diagrams, not ASCII art
   - No buzzwords or jargon in 01–02
6. **Prompts belong only in the skill reference files** — see [`INVARIANTS.md`](../../../INVARIANTS.md) for the rule and the chapter-to-skill pairings.
   - Editing a prompt → edit the skill reference file. Review the paired chapter's narrative description (what the prompt covers, what it produces) in the same change to confirm it still matches.
   - Treat prompts as executable: an agent following the prompt should produce correct output without additional clarification.
   - Never copy a prompt back into a chapter "for convenience" — that re-introduces drift.
7. Before completing, verify:
   - No content duplicated elsewhere in the series
   - All cross-links are accurate and point to the right file and section
   - The two-audience structure is preserved
8. After substantive changes, record them in the appropriate changelog and bump the matching version. **The guide and each skill version separately.**

   **For guide changes** (chapters 01–09, `guide/README.md`, `guide/READING.md`, `guide/FAQ.md`):
   - Update [`guide/CHANGELOG.md`](../../../guide/CHANGELOG.md)
   - Bump the `Current` line in [`guide/README.md`](../../../guide/README.md)

   **For skill changes** (any file under `.agents/skills/<skill>/`), two files always move together — missing either leaves them out of sync:
   - [ ] Update `.agents/skills/<skill>/CHANGELOG.md`
   - [ ] Bump `metadata.version` in `.agents/skills/<skill>/SKILL.md` front matter

   The skill's `README.md` links to `CHANGELOG.md` for the current version and does not need updating.

   **If the change touches `harness-setup` or `harness-inspect`**, also bump `version` in `harness-plugin/.claude-plugin/plugin.json` and `harness-plugin/.cursor-plugin/plugin.json`. `.agents/skills/harness-setup/` and `.agents/skills/harness-inspect/` are symlinks into `harness-plugin/skills/`, the plugin's canonical source — Claude Code's marketplace detects available updates by comparing this `version` field (falling back to comparing git commit SHAs only when no version field exists), so a content change without a version bump is invisible to already-installed plugins.

   **Versioning** (applies to both):
   - **Patch** (`x.y.Z`): typo fixes, link fixes, README/doc-only updates that don't change behavior or content. Batch into the next minor unless explicitly requested.
   - **Minor** (`x.Y(.0)`): new sections, new prompts, new sources, new resources, new behavior. Default for most substantive edits.
   - **Major** (`X.0(.0)`): structural change — added or removed chapter/phase, breaking output format, audience or scope change.

   **Format**:
   - New entry at the **top** of the changelog under `Added` / `Changed` / `Removed` / `Fixed` as appropriate
   - Each item names the affected file(s) and links to the relevant chapter or resource
   - The version line in the README (or skill README) and the latest changelog entry must agree — bump one, bump the other

   **If a change spans both** (e.g., editing a prompt in a skill reference file that requires updating how chapter 09 describes it), record the prompt change in the skill changelog and the description update in the guide changelog, with a cross-reference between them.

   **When editing files inside skill directories** (`.agents/skills/harness-setup/`, `harness-inspect/`), two rules apply:
   - **Guide references**: use absolute HTTPS URLs (e.g., `https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/CHANGELOG.md`), not relative paths. Relative paths break when skills are symlinked into `~/.claude/skills/`.
   - **Inter-skill references**: don't link at all — relative *or* absolute. Users may have only one skill installed locally and the symlinked directory structure is unknown. Mention other skills by name only (e.g., *"use the `harness-inspect` skill instead"*).
   The internal `documentation` and `guide-review` skills are not symlinked — relative paths are fine (e.g., `[CHANGELOG.md](../../../guide/CHANGELOG.md)`).
