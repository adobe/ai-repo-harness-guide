# Repo Harness Skills — plugin package

This directory is the **canonical source** of the `harness-setup` and `harness-inspect` skills. The repo's Claude-format (`.claude-plugin/`) and Cursor-format (`.cursor-plugin/`) marketplace manifests both point here, and `.agents/skills/harness-{setup,inspect}/` are symlinks into `skills/`.

# Repo Harness Skills — plugin package

This directory is the **canonical source** of the `harness-setup` and `harness-inspect` skills. The repo's Claude-format (`.claude-plugin/`) and Cursor-format (`.cursor-plugin/`) marketplace manifests both point here, and `.agents/skills/harness-{setup,inspect}/` are symlinks into `skills/`.

## Installing the skills

For per-tool install and update instructions (Claude Code, GitHub Copilot, Cursor), see the canonical page: **[`guide/README.md` → Skills](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/README.md#skills)**.

Most users need nothing from this directory: Copilot reads `.agents/skills/` natively in any open workspace, and the same skills install without cloning via the plugin marketplace (Copilot auto-detects the Claude-format manifest). The `.vsix` extension below is a **niche fallback** — only useful if you want the skills globally across all workspaces *and* prefer a VS Code Marketplace extension over the plugin marketplace. It is heavier and less portable.

### Building the `.vsix` (fallback only)

```bash
npm install -g @vscode/vsce
cd harness-plugin
vsce package
code --install-extension repo-harness-1.0.0.vsix
```

Then invoke `/harness-setup` or `/harness-inspect` in Copilot chat. This extension is not published to the VS Code Marketplace; publish with `vsce publish` if desired (see [publishing extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)).

```bash
npm install -g @vscode/vsce
cd harness-plugin
vsce package
code --install-extension repo-harness-1.0.0.vsix
```

Then invoke `/harness-setup` or `/harness-inspect` in Copilot chat. This extension is not published to the VS Code Marketplace; publish with `vsce publish` if desired (see [publishing extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)).
