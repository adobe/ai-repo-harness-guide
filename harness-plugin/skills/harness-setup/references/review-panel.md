# Review Panel

A quality gate for harness-setup output. Run after Step 5 (Validate).

Four reviewers. Each reads fresh — do not carry forward context from previous steps. Run all four; do not skip any. Surface all findings inline; do not write to a file.

---

## Reviewer 1: Architect

**Role**: Accuracy judge for structural documentation.

**Read** (fresh):
- `docs/ARCHITECTURE.md` and `docs/DECISIONS.md` — skip gracefully if absent
- Repository file tree: list top-level directories and key subdirectories
- Key config files: build manifests, service entry points, framework config

**Assess**:
1. Do all paths, filenames, and directory names mentioned in the documents exist in the repository?
2. Do all described components, services, or layers correspond to real code?
3. Are the described dependencies and boundaries accurate?
4. Is anything significant missing — a major component or integration not documented?

**Output format**:

| File | Line | Claim | Actual |
|------|------|-------|--------|
| docs/ARCHITECTURE.md | 12 | `services/auth/` | Directory does not exist |

If no issues: `Architect: accurate — no inaccuracies found.`

---

## Reviewer 2: Tester

**Role**: Accuracy judge for operational documentation.

**Read** (fresh):
- `docs/TESTING.md`, `docs/SETUP.md`, `CONTRIBUTING.md` — skip gracefully if absent
- `Makefile` — list all targets
- Test configuration files (`pytest.ini`, `jest.config.*`, `go.mod`, `package.json`, etc.)

**Assess**:
1. Does every documented command exist as a Makefile target or verifiable executable?
2. Does the described test strategy match the actual test directories and config files?
3. Are there test types present in the repo (unit, integration, e2e) not mentioned in TESTING.md?
4. Can a developer follow SETUP.md to completion? Are there missing steps or broken prerequisites?

**Output format**:

| File | Line | Documented | Actual |
|------|------|-----------|--------|
| docs/TESTING.md | 8 | `make test-integration` | Target not in Makefile |

If no issues: `Tester: accurate — all commands verified.`

---

## Reviewer 3: Agent Proxy

**Role**: Usability judge for harness guidance.

**Read** (fresh — do not rely on prior session context):
- `AGENTS.md` (root and all module-level files linked from it)
- `INVARIANTS.md`
- All `SKILL.md` files under `.agents/skills/`

**Assess** — as an agent arriving in this repository cold:
1. After reading `AGENTS.md`, do you know which role applies to your task and what the escalation path is?
2. Are the constraints in `INVARIANTS.md` specific enough to enforce without judgment calls? Flag any that are too vague to produce consistent agent behavior.
3. Are there obvious footguns in the codebase not documented in `AGENTS.md`?
4. Do the skill descriptions accurately represent what invoking each skill will produce?

**Output format**:

| File | Issue | Impact |
|------|-------|--------|
| AGENTS.md | Role "Writer" has no escalation path | Agent stalls on scope boundary decisions |

If no issues: `Agent Proxy: sufficient — no gaps found.`

---

## Reviewer 4: Token Auditor

**Role**: Context-budget judge for auto-loaded files.

**Read** (fresh):
- `CLAUDE.md`
- `AGENTS.md` (root only)
- `INVARIANTS.md`

**Assess**:
1. Estimate the token count for each file (rough guide: 1 token ≈ 4 characters of English prose).
2. Check `INVARIANTS.md` for custom thresholds. If none, use defaults: **4,000 tokens warn / 8,000 tokens polluting**.
3. For any total exceeding the warn threshold: identify specific sections that are redundant, already covered elsewhere, or could be trimmed without losing meaning.

**Output format**:

| File | Est. tokens | Auto-loaded | Status |
|------|------------|-------------|--------|
| CLAUDE.md | 15 | ✅ | Healthy |
| AGENTS.md | 1,850 | ✅ | Healthy |
| INVARIANTS.md | 420 | ✅ | Healthy |
| **Total** | **2,285** | | ✅ Healthy |

Threshold used: [repo-declared N warn / N polluting | default 4,000 warn / 8,000 polluting]

If over warn threshold, add: `Cut from [file]: [section] — [reason]`

---

## Quality Gate

Setup is complete when all four reviewers find no blocking issues:

- [ ] Architect: no inaccuracies that would mislead an agent navigating the codebase
- [ ] Tester: all documented commands are verifiably correct
- [ ] Agent Proxy: an agent reading cold can navigate, identify constraints, and select the right skill
- [ ] Token Auditor: total auto-loaded context is below the warn threshold
