# Health Check Prompt

A fast rot scan — ten questions only. Run this after any structural change or monthly, whichever comes first.

**Run this through the runtime your agents actually use in production.** Some runtimes (e.g., AWS Bedrock agents) re-route or override system prompts in ways that can silently drop `INVARIANTS.md` content. A health check run in Claude Code or against the raw model API may pass while the production runtime is operating without the invariants. Question 2 below is designed to catch this.

**Expected output**:

| Q | Check | Status | Action Items |
|---|-------|--------|-------------|
| 1 | Integrity | ✅ Pass | — |
| 2 | Constraint propagation | ✅ Pass | — |
| 3 | Sensors | ⚠️ Partial | `make lint` fails: tool not installed |
| 4 | Coverage gaps | ❌ Fail | `src/payments/` lacks module AGENTS.md |
| 5 | Enforcement gaps | ✅ Pass | — |
| 6 | Footgun freshness | ✅ Pass | — |
| 7 | Token budget | ✅ Pass | 2,840 tokens (default 4,000 threshold) |
| 8 | File size discipline | ✅ Pass | — |
| 9 | Content accuracy | ❌ Fail | AGENTS.md:14 claims `make deploy` — not in Makefile |
| 10 | Claude Code integration | ⚠️ Quick fix | `.claude/commands/code-review.md` shim duplicates the `.claude/skills/code-review` symlink |

**Escalate to full audit**: Yes — Q4 and Q9 failed

**Prompt:**

```
Run a health check on this repository's AI agent harness.

Answer these ten questions only — no full analysis. Do not inventory build / tool-config / lock / container / repo-config files (e.g., `pyproject.toml`, `package.json`, `pom.xml`, `Cargo.toml`, `Dockerfile`, `LICENSE`, `.gitignore`); the harness is the agent-facing layer.

1. **Integrity**: For every file path, command, and internal link referenced in `AGENTS.md`,
   `INVARIANTS.md`, and any `SKILL.md` files — does it still resolve? List broken references.

2. **Constraint propagation**: Without re-reading any files, list the top 3 hard constraints
   from `INVARIANTS.md` that you currently have in context. If you cannot — or the list is
   substantially shorter than the file content — the runtime is not delivering the invariants
   to the model intact. Flag where they are likely being dropped (system prompts, instruction
   fields, orchestration layers, or auto-load configuration).

3. **Sensors**: Run `make check` (or the equivalent validation command). Does it pass?
   If not, what fails?

4. **Coverage gaps**: Are there modules or directories added since the last assessment that lack
   an `AGENTS.md` and that contain security-sensitive code, API boundaries, or complex logic?

5. **Enforcement gaps**: Scan `INVARIANTS.md` for items marked "[not yet enforced]" or
   "human review." Could any now be automated? List candidates.

6. **Footgun freshness**: For each footgun in `AGENTS.md`: is it still an active risk, or has it
   been resolved or changed? Can it be traced to a discoverable pattern in source code — a specific
   file, API, or recurring commit? If not, flag it as aspirational. List any that should be
   updated, removed, or grounded in a concrete example.

7. **Token budget**: Identify all auto-loaded files (loaded before the first message — typically via
   `CLAUDE.md` `@`-references or native reading). Sum their token counts using **your own
   tokenizer** (do not estimate via `chars/4` — counts are tokenizer-relative and rough heuristics
   are within ~10% but not authoritative). **Before judging pass/fail, check `INVARIANTS.md` for a
   `Context Budget` section** — if the repo declares its own threshold there, use that. Otherwise
   apply the guide default of ≤ 4,000 tokens. If over budget, name the largest contributor and note
   which threshold (repo override or default) you used and which tokenizer/model produced the count.

8. **File size discipline** (count + linking pattern): For each harness file (categorize as **core** =
   `AGENTS.md` root + module + `SKILL.md`; **flexible** = `INVARIANTS.md` + `README.md`; **harness support** =
   `Makefile`, `docs/*`, `CONTRIBUTING.md`, `CHANGELOG.md`):
   - Check `INVARIANTS.md` for a `File Size Budget` override; otherwise apply chapter 04 defaults
     (≤ 200 lines for `AGENTS.md`, ≤ 100 for `SKILL.md`).
   - For **core** files: flag ⚠️ only if **both** over budget **and** not using progressive discovery
     (linking to module-level files, `references/`, `docs/`). A large file that already links out is
     a future-split candidate, not a current defect.
   - For **flexible** files: flag ℹ️ informationally if substantially over the soft target.
   - For **harness support** files: skip the size check; suggest splitting only if a file has become hard to scan.

9. **Content accuracy**: For every harness file — `AGENTS.md`, `INVARIANTS.md`, all `SKILL.md` files, and `README.md` — read the file in full and identify factual claims: version numbers, dependency names, build commands, environment variable names, file paths, and API endpoint paths. For each claim, open the corresponding source file (package manifest, Makefile, route definitions, `.env.example`, etc.) and verify. Do not verify from memory — open the files. List every discrepancy as rot, with: harness file:line of the claim, claimed value, actual value, and source file:line evidence.

10. **Claude Code integration**: First determine whether Claude Code is a target for this repo — is there a root `CLAUDE.md`, or a `.claude/` directory? If neither, answer **N/A** (Claude Code is not a target; the `.claude/` surface is a Claude-specific workaround, not part of the portable harness — do not flag its absence). If either is present, check three things and route each finding:
    - For each skill under `.agents/skills/<name>`, confirm a `.claude/skills/<name>` symlink exists and resolves to it. Claude Code does not scan `.agents/skills/`, so a missing link means the skill is undiscoverable — **rot**.
    - Confirm no `.claude/skills/<name>` entry is a plain text file instead of a symlink. That happens when `core.symlinks` is off (e.g. on Windows) and the symlink checks out as text holding the target path; the skill silently isn't discovered — **rot**.
    - List any `.claude/commands/<name>.md` `@`-reference shim that points at a skill which now also has a `.claude/skills/` symlink. The command shim is a redundant legacy surface (manual `/name` only, no auto-invocation) — **quick fix** to remove.

**Output format** — produce exactly this table, nothing else:

| Q | Check | Status | Action Items |
|---|-------|--------|-------------|
| 1 | Integrity | [✅ Pass / ⚠️ Partial / ❌ Fail] | [items, or —] |
| 2 | Constraint propagation | … | … |
| 3 | Sensors | … | … |
| 4 | Coverage gaps | … | … |
| 5 | Enforcement gaps | … | … |
| 6 | Footgun freshness | … | … |
| 7 | Token budget | … | [token count and threshold used] |
| 8 | File size discipline | … | … |
| 9 | Content accuracy | … | … |
| 10 | Claude Code integration | [✅ Pass / ⚠️ Quick fix / ❌ Fail / N/A] | … |

**Escalate to full audit**: [Yes — reason | No]
```

**When to escalate to a full audit**: if any question returns a fail or reveals more than one or two action items, load `full-audit.md` and run the complete assessment.
