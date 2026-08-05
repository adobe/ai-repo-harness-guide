# Repo Harness Skills — plugin package

This directory is the **canonical source** of the `harness-setup` and `harness-inspect` skills. The repo's Claude-format (`.claude-plugin/`) and Cursor-format (`.cursor-plugin/`) marketplace manifests both point here, and `.agents/skills/harness-{setup,inspect}/` are symlinks into `skills/`.

## GitHub Copilot

Copilot has three ways to load these skills, in order of preference:

1. **Zero-config workspace scan (recommended).** Copilot natively reads `.agents/skills/` in any open workspace. Open the guide repo (or copy `.agents/skills/harness-{setup,inspect}/` into your project) — no install, always in sync.
2. **Marketplace, without cloning.** Copilot auto-detects the repo's Claude-format plugin manifest. No separate Copilot artifact is needed:
   ```bash
   # Copilot CLI
   copilot plugin marketplace add adobe/ai-repo-harness-guide
   copilot plugin install repo-harness@repo-harness
   copilot plugin update repo-harness   # updates are manual
   ```
   In VS Code, add `"chat.plugins.marketplaces": ["adobe/ai-repo-harness-guide"]` to `settings.json` and install `repo-harness` from the **Agent Plugins** view.
3. **Standalone `.vsix` extension (niche fallback).** Only useful if you want the skills globally across all workspaces *and* prefer a VS Code Marketplace extension over the plugin marketplace above. This is heavier and less portable — most users should not need it.

### Building the `.vsix` (fallback only)

```bash
npm install -g @vscode/vsce
cd harness-plugin
vsce package
code --install-extension repo-harness-1.0.0.vsix
```

Then invoke `/harness-setup` or `/harness-inspect` in Copilot chat. This extension is not published to the VS Code Marketplace; publish with `vsce publish` if desired (see [publishing extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)).
