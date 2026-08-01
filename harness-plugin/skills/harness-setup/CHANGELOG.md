# Changelog — harness-setup

Changes to the `harness-setup` skill. See the [guide changelog](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/CHANGELOG.md) for changes to chapters and shared materials.

---

## 1.0.0 (2026-08-01)

Initial public release.

- **Single execution sequence** (interactive or one-shot mode) covering discovery, bootstrap, documentation, integration, and validation — work items apply based on what the repo needs, with no upfront create-vs-migrate routing decision.
- **Manifest-based module enumeration** for discovery and coverage checks, scaling from single-manifest repos to large monorepos: handles Maven/Gradle/npm/Cargo reactors, workspace declarations, git submodules, shared-manifest multi-service repos, `requirements/`-style per-service manifests, and manifest-less C/C++ repos via directory-layout fallback.
- **Claude Code integration is optional and gated**: the `CLAUDE.md` shim and `.claude/skills/` symlinks are generated only when Claude Code is a detected or confirmed target, never unconditionally.
- **Before/After Probe** to record agent behavior before and after building the harness, and a four-reviewer validation panel to confirm the result before declaring the harness complete.
