# AGENTS.md — Repository Constraints & Context

> **Read [INVARIANTS.md](INVARIANTS.md) first** — it lists non-negotiable constraints that apply to all work in this repository.

## Repository Overview

This repository is a blog post series and practical implementation guide for **repository harnesses** — the repository-local control systems that make AI-assisted coding reliable and repeatable. It consists of ten numbered documents (00–09) plus a README navigation hub and companion materials (`READING.md`, `FAQ.md`, `CHANGELOG.md`).

This repo is itself structured as a harness using the conventions it teaches: `AGENTS.md` for operational context, `.agents/skills/` for skills, and `CLAUDE.md` as a shim only. It should model what it describes.

**Two audiences:**
- **Non-technical readers**: 00–02 (introduction, concept, and definition — no implementation detail)
- **Engineers and practitioners**: all ten, especially 07 (build), 08 (migrate), and 09 (maintain) — the actionable implementation chapters

## Agent Authorization

### ContentEditor
- Authority: can edit any markdown file; cannot change the structural intent or reading order of the series
- Escalation: structural changes (adding/removing documents, changing the five-layer model, changing the series sequence) require human decision

### Writer
- Authority: can propose additions; cannot merge without human review
- Escalation: any content that contradicts existing material or changes the core model (Agent = Model + Harness)

## Conventions

- **Commits & branches**: see [CONTRIBUTING.md](CONTRIBUTING.md) — single source of truth

## Known Footguns

### Duplicating content instead of linking
The series covers overlapping concepts (progressive discovery appears in 03, 04, and 05; the five layers are summarised in 02 and detailed in 03). Before adding content, search all ten files for existing coverage. If it exists, link — don't copy. A previous version of this repo had near-identical closing sentences in both 04-Harness-Components.md and 06-Reference-Layout.md.

### Scope creep between documents
Each document has a defined scope. Don't move actionable prompts outside 07–09 (build, migrate, maintain), don't put implementation detail in 01–02, and don't add deep-dive content to 06 (it's a reference layout, not a tutorial).

### Writing for the wrong audience
01–02 are readable by non-technical stakeholders. 03–09 assume engineering context. Adding jargon or implementation detail to 01–02 breaks the non-technical entry point. Oversimplifying 03–09 reduces their value to practitioners.

### Skipping the changelog after guide edits
Any substantive edit to the guide content (chapters 01–09, `README.md`, `READING.md`, `FAQ.md`) requires a `CHANGELOG.md` entry and a version bump in the `Current` line in `README.md`. The full procedure is in the [`documentation` skill](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/documentation/SKILL.md) step 8, but the obligation applies even when the skill isn't explicitly invoked. Patch for wording fixes; minor for new content; major for structural changes.

### Skipping the changelog after skill changes
Structural skill changes — adding a new skill, deprecating a skill, or editing `AGENTS.md` Module Context — also require a `CHANGELOG.md` entry at the guide level, in addition to the skill's own changelog. The guide changelog is the index of record for what skills exist and why they changed. Skill-only changes (prompt edits, bug fixes) go only in the skill's changelog; structural changes that affect the module context or the guide's description of a skill go in both.

### Forgetting to bump the plugin manifest version after a skill change
Editing `harness-setup` or `harness-inspect` updates the same files distributed via the `repo-harness` plugin (`.agents/skills/harness-setup/` and `.agents/skills/harness-inspect/` are symlinks into `harness-plugin/skills/`). Claude Code's marketplace update check compares the `version` field in `harness-plugin/.claude-plugin/plugin.json` (and `.cursor-plugin/plugin.json`) — bumping only the skill's own `CHANGELOG.md`/`SKILL.md` version does not make installed plugins detect the change. See the [`documentation` skill](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/documentation/SKILL.md) step 8 for the full checklist.

### Placing agent guidance in tool-specific directories
Any agent context or skill *content* added to `.claude/`, `.cursor/`, `.github/instructions/`, or similar tool-specific locations violates the portability principle central to this series. The portability of `AGENTS.md` and `.agents/skills/` is a central claim — this repo must live by it. All agent guidance goes in the canonical locations only. The one permitted exception is a **pointer** back to a canonical location — this repo's `.claude/skills/<name>` symlinks to `.agents/skills/<name>` (Claude Code does not scan `.agents/skills/`), and the `CLAUDE.md` `@`-shim. See [INVARIANTS.md](INVARIANTS.md) *Canonical Locations*.

## Document Map

| File | Audience | Purpose |
|------|----------|---------|
| guide/README.md | All | Navigation hub |
| guide/00-Introduction.md | All | Guide overview, scope, reading paths, acknowledgements |
| guide/01-Beyond-Prompting.md | All | Problem and solution framing |
| guide/02-What-a-Harness-Is.md | All | What a harness is; the five layers; maturity spectrum |
| guide/03-Five-Control-Layers.md | Engineers | Five control layers in depth |
| guide/04-Harness-Components.md | Engineers | Seven concrete harness components |
| guide/05-How-Agents-Navigate.md | Engineers | How agents operate within a harness |
| guide/06-Reference-Layout.md | Engineers | Reference production repository structure |
| guide/07-Build-Your-Harness.md | Engineers | Step-by-step implementation guide with discovery prompts |
| guide/08-Migrate-Your-Harness.md | Engineers | Migrating a partial implementation to a full harness |
| guide/09-Keep-It-Current.md | Engineers | Keeping the harness current: inspection prompts and cadence |

## Companion Materials

Files that complement the numbered chapters but live outside the series:

| File                                              | Purpose |
|---------------------------------------------------|---------|
| [`READING.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/READING.md) | Annotated reading list — sources that shaped the guide, plus pieces worth reading for runtime concerns and counterpoints |
| [`FAQ.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/FAQ.md) | Objections and questions expanded into fuller prose answers, cross-linked to the relevant chapters. |
| [`CHANGELOG.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/CHANGELOG.md) | Versioned record of guide changes; skills version separately under `.agents/skills/<skill>/CHANGELOG.md` |

## Module Context

The skills (`harness-setup`, `harness-inspect`) live in this repo at `.agents/skills/`. Install via the Claude Code plugin:

```
/plugin marketplace add adobe/ai-repo-harness-guide
/plugin install repo-harness
```

Cursor (2.5+) and GitHub Copilot read `.agents/skills/` natively — open this repo as a workspace or copy the skill directories into your project. See `guide/README.md` for per-tool install details.

Distribution wrappers live at `.claude-plugin/`, `.cursor-plugin/`, `harness-plugin/` — they're manifests, not agent guidance.

Each skill contains a `SKILL.md` (agent-facing instructions), `README.md` (human-facing usage docs), `CHANGELOG.md` (independent skill versioning), and a `references/` folder with prompt templates. Internal-only skills (`documentation`, `guide-review`) may use relative paths.

- [`.agents/skills/documentation/SKILL.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/documentation/SKILL.md) — skill for writing and editing content in this series
- [`.agents/skills/harness-setup/SKILL.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/harness-setup/SKILL.md) — skill for building or migrating a harness (scan-first; drives 07 and 08)
- [`.agents/skills/harness-inspect/SKILL.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/harness-inspect/SKILL.md) — skill for health checks and full audits of an existing harness (drives 09)
- [`.agents/skills/guide-review/SKILL.md`](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/guide-review/SKILL.md) — six-agent review panel for multi-chapter guides and books (internal; reusable beyond this guide)
