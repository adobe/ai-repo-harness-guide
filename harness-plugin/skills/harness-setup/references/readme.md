# M0: README Scope, Accuracy, and Structure

Ensures README.md matches the canonical template, removes content that duplicates harness files, verifies factual accuracy, and keeps the References section always present.

**Applies when**: Always.

**If README.md does not exist**: Defer this step until all other work items are complete — so links in "For Agents and Contributors" resolve. Then skip Steps 2–5 and go directly to Step 6, using `assets/README.md.template` as the starting structure and filling each section from the codebase.

**Prompt:**

```
Restructure and audit README.md against the actual codebase, existing harness files,
and the canonical template at assets/README.md.template.

README.md is the human entry point. Its structure is:
  1. Title (H1)
  2. One-paragraph description
  3. Quickstart (minimal prerequisites + two or three commands)
  4. For Agents and Contributors (links to harness files and docs)
  5. References (external links — always present; see below)

It must not duplicate content that lives in AGENTS.md, INVARIANTS.md, or docs/.

Step 1: Read all of the following before making any assessment:
- assets/README.md.template (the target structure)
- README.md (in full)
- AGENTS.md (if present)
- INVARIANTS.md (if present)
- Every file under docs/ (if present)

Step 2: Scope audit — for each section in README.md, classify its content:

- **Keep**: belongs in README.md (description, quickstart, links, external references)
- **Already canonical**: same content exists in AGENTS.md, INVARIANTS.md, or docs/ →
  collapse to a link, no migration needed
- **Migrate now**: belongs in a canonical file that exists but does not yet have this
  content → add the content to that file in Step 5, then collapse to a link
- **Migrate later**: belongs in a canonical file that does not exist yet → preserve
  the content in the conversation; the work item that creates that file will pick it up

Canonical destinations:
- Role definitions, footguns, team policies → AGENTS.md
- Hard constraints, invariants → INVARIANTS.md
- Architecture and component descriptions → docs/ARCHITECTURE.md
- Full setup steps → docs/SETUP.md
- API documentation → docs/ or openapi spec

Do not discard content that belongs somewhere — classify it and route it.

Step 3: Factual accuracy — for each claim that belongs in README.md, verify it
against source files. Do not rely on memory — open the files.

1. **Version numbers** — Read manifests: package.json, pom.xml, pyproject.toml,
   go.mod, Cargo.toml, etc.
2. **Build and run commands** — Read the Makefile or scripts; confirm targets exist.
3. **Environment variables** — Read code, config files, or .env.example.
4. **API endpoint paths** — Read actual route definitions.
5. **Dependency names** — Read the manifest.
6. **Directory structure** — Confirm each path exists.

If README.md contains no claims in a category, state that explicitly.

Step 4: Report all findings before making any changes.
- **Scope** (Step 2): section, classification (keep / already canonical / migrate now /
  migrate later), canonical destination, proposed action.
- **Accuracy** (Step 3): claim (README line number), actual value (file:line), required fix.
- **Structure gaps**: sections present in the template but missing from README.md.

Step 5: Migrate content before rewriting.
For every section classified "migrate now": add the content to the existing canonical
file, then mark the README section for collapse. For every section classified "migrate
later": state the content and its destination explicitly in the conversation — the work
item that creates that file will use it. Do not discard any content without routing it.

Step 6: Rewrite README.md to the template structure.
- Map surviving content into the five template sections in order.
- Collapse "already canonical" and "migrate now" sections to links in
  "For Agents and Contributors".
- Correct wrong values from Step 3.
- Populate "For Agents and Contributors" with links to files that actually exist;
  omit links to files that are absent.
- **References section**: always include it. If external references exist in the
  current README.md or codebase (wikis, Jira, API specs, design docs), list them.
  If none are found, keep the section and add:
  > **Reviewer**: Add links to your team wiki, Jira project, API docs, and related
  > services here. Remove this line when done.
- Do not add content beyond the five template sections.
```

**After M0**: Return to the work item plan in SKILL.md and continue with the next applicable item.
