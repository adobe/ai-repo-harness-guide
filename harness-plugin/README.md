# Repo Harness Skills — VS Code Extension (Copilot)

This extension contributes `harness-setup` and `harness-inspect` as Copilot chat skills.

GitHub Copilot already reads `.agents/skills/` natively in any open workspace, so for most users **no extension is needed**. This scaffold exists for users who want the skills available globally across all workspaces without cloning the guide repo.

## Install options

### Option 1 — workspace-scoped (no extension needed)

Open the guide repo as a VS Code workspace (or copy `.agents/skills/harness-{setup,inspect}/` into your project). Copilot discovers the skills automatically.

### Option 2 — global install via sideload

Build a `.vsix` and install it globally:

```bash
npm install -g @vscode/vsce
cd harness-plugin
vsce package
code --install-extension repo-harness-1.0.0.vsix
```

Then invoke in Copilot chat:

```
/harness-setup
/harness-inspect
```

## Marketplace submission

This extension is not yet published to the VS Code Marketplace. Publish it with:

```bash
vsce publish
```

See [publishing extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension) for setup requirements (publisher account, personal access token).
