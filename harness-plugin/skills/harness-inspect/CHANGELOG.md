# Changelog — harness-inspect

Changes to the `harness-inspect` skill. See the [guide changelog](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/CHANGELOG.md) for changes to chapters and shared materials.

---

## 1.0.0 (2026-08-01)

Initial public release.

- **Two modes**: a quick monthly health check (ten pass/fail questions, run twice independently and reconciled) and a thorough quarterly full audit.
- **Source-first coverage check** in the full audit: enumerates the codebase's actual modules, entry points, and config/env vars by build manifest (scaling to monoliths, reactors, and polyglot repos) and checks each against `AGENTS.md`/`INVARIANTS.md`/skills — zero coverage on a real structural area is a critical gap, not a footnote.
- **Claude Code integration hygiene check**, gated on detection: verifies each skill is discoverable via a resolving `.claude/skills/` symlink, flags a symlink checked out as a plain file, and flags a leftover legacy `.claude/commands/` `@`-shim duplicating a symlinked skill.
- **Orphaned-documentation and reversed `AGENTS.md`/`CLAUDE.md`-direction detection**, and a noise filter that discards wording nitpicks and uncited claims so findings stay actionable.
- **Before/After Probe** to record agent behavior before and after remediation.
