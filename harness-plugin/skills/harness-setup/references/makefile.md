# M5: Makefile

Start from `assets/Makefile.template`. Replace the commented example commands with the actual commands for the detected toolchain.

**Prompt:**

```
Create or update a Makefile that wraps the tools discovered in Phase 1.
Start from assets/Makefile.template and adapt all commands to the actual toolchain.

Important: a Makefile may already exist.
- Preserve existing targets and behavior unless clearly incorrect.
- Do not remove or rename existing targets.
- Add missing targets in an additive, backwards-compatible way.
- If an equivalent target already exists under another name, keep it and add an alias target when helpful.

Important: the repo may have more than one toolchain (see the layout check from Phase 1
discovery). If Phase 1 found more than one module with its own build manifest — e.g. a Python
backend and a TypeScript frontend in one repo — each top-level validation target fans out to every
module's command instead of picking one language and silently skipping the rest:

    test: test-backend test-frontend
    test-backend:
    	cd backend && pytest
    test-frontend:
    	cd frontend && npm test

- The fan-out target (`test`, `lint`, `typecheck`, `check`) stays the one command agents are told
  to run — never require an agent to know which per-module target covers which language.
- Name per-module targets `<target>-<module>` so `make help` can also list them individually for a
  developer who wants to run just one module's checks.
- If a target category doesn't apply to a given module (e.g. a frontend has no `typecheck`
  equivalent), omit that module from the fan-out rather than adding a no-op target.

Ensure these target categories are available:

1. **Development** — install, build, run, dev
2. **Validation** (most important) — test, lint, format, typecheck, check
3. **Maintenance** — clean, help

The Makefile should:
- Include a comment at the top: `# Agents: run only make targets listed here. No direct shell commands.`
- Include this restriction in the `make help` output
- Use tabs for indentation (Makefile standard)

Present each target category with the commands you intend to use, then write the complete Makefile.
```
