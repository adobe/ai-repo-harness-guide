# Shared Conventions

These rules apply to every work item prompt. Load this file at the start of Step 4.

**Identifier-grounding rule:**
Every named identifier cited in a harness file — env var names, config flags, file paths, class names, constants, queue names, bucket names, endpoint paths — must have a `file:line` observation behind it. If you cannot find a code citation for an identifier, write `[verify with maintainers]` rather than copying the name from an existing prose document or inventing a plausible-sounding one.

A wrong identifier attached to a rule survives review because reviewers check whether rules *sound* right, not whether each named identifier *exists*. A reader who tries to comply by setting a non-existent env var will silently get nothing — or may add the var to the codebase to satisfy the doc, manufacturing a constant the system never had.

**Interaction pattern:**
Work section by section, not file by file:
1. State what evidence you found (cite `file:line`) or note explicitly that no evidence exists.
2. Present what you intend to write for this section.
3. Wait for confirmation before proceeding to the next section.

A wrong fact caught at section 2 does not propagate into sections 3–N.

For sections where the answer cannot come from the codebase — team policy, incident history,
operational agreements — **ask the developer** rather than writing a plausible default.

**Execution mode**: Apply the mode chosen at skill start — do not ask again. If one-shot: generate all sections without pausing, then prepend the completed file with:
> ⚠️ Generated in one pass without per-section verification. Treat every claim as a hypothesis until confirmed by the team.
