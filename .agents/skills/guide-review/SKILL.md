---
name: guide-review
description: >-
  Review a multi-chapter guide, series, or book from six specialist perspectives.
  Orchestrates Series Editor, Non-Technical Proxy, Practitioner Proxy, Consistency
  Auditor, Diagram Reviewer, and Claims Auditor. Use for single-chapter review,
  full-series audit, consistency checks, diagram audits, and claims audits.
metadata:
  version: 1.0.0
---

# Guide Review — Multi-Perspective Review Panel

## Configure for your work

Before running any workflow, read the work's README or table of contents to establish:
- All chapters, their titles, and reading order
- Which chapters target non-technical readers vs. practitioners
- Diagram format in use (Mermaid, PlantUML, images, etc.)
- Any stated style rules, invariants, or editorial constraints

## Agent roster

| Agent | Persona | Activate for |
|-------|---------|-------------|
| [Series Editor](agents/series-editor.agent.md) | Narrative Architect | Arc, voice, flow, and bloat across all chapters |
| [Non-Technical Proxy](agents/nontechnical-proxy.agent.md) | Skeptical decision-maker | Non-technical chapters — accessibility, business clarity, engagement |
| [Practitioner Proxy](agents/practitioner-proxy.agent.md) | Impatient senior engineer | Technical chapters — actionability, depth, implementability |
| [Consistency Auditor](agents/consistency-auditor.agent.md) | Cross-chapter editor | Terminology drift, duplication, model consistency, link integrity |
| [Diagram Reviewer](agents/diagram-reviewer.agent.md) | Visual clarity judge | Diagram quality, placement, accuracy, and format compliance |
| [Claims Auditor](agents/claims-auditor.agent.md) | Skeptical copy editor | Unsupported claims, overstatements, weasel words, false precision |

## Workflows

### Single-chapter review (quick)
1. Identify whether the chapter targets a non-technical or practitioner audience.
2. Relevant Proxy reviews for engagement and actionability.
3. Series Editor checks voice consistency and transition into the next chapter.
4. Claims Auditor flags any unsupported assertions.
5. Surface findings to author.

### Full series audit (thorough)
1. Series Editor reads all chapters for arc, flow, and bloat.
2. Non-Technical Proxy reviews non-technical chapters.
3. Practitioner Proxy reviews practitioner chapters.
4. Consistency Auditor runs a cross-chapter pass.
5. Diagram Reviewer audits all visuals.
6. Claims Auditor audits all chapters.
7. Series Editor synthesizes findings into a prioritized revision list.
8. Surface to author for approval.

### Consistency check (targeted)
1. Consistency Auditor scans for terminology drift, duplication, and broken links.
2. Series Editor reviews findings for impact on arc and voice.
3. Surface to author.

### Diagram audit (targeted)
1. Diagram Reviewer scans all chapters for visual opportunities and format issues.
2. Series Editor reviews visual density and cross-chapter consistency.
3. Surface to author.

### Claims audit (targeted)
1. Claims Auditor reads all chapters and produces structured report.
2. Surface flagged claims to author for resolution.

## Quality gates

Every chapter must pass before the author approves:
- [ ] Series Editor: voice consistent, no bloat, transition to next chapter present
- [ ] Relevant Proxy: engagement and actionability confirmed
- [ ] Claims Auditor: all claims verified, qualified, or flagged for removal
- [ ] Diagram Reviewer: visuals present where needed, accurate, format-compliant
- [ ] Author approval
