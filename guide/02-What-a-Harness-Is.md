# What a Harness Is

## There Is No Formal Standard (Yet)

As of 2026, no formal specification exists—the term is new (late 2025) and the space moves faster than standards bodies. Teams that have adopted harnesses treat them as **repository-local control systems**, not one-size-fits-all templates.

This mirrors the early days of CI/CD: no spec, but strong convergence on essential patterns. The same is happening with repository harnesses. (See [Beyond Prompting](01-Beyond-Prompting.md) for the full convergence narrative and source references.)

## What This Means

When we say "Agent," we are not referring to the language model alone. A modern AI agent is a complete system comprising:

1. **The Model** — The neural network that generates text (GPT-4, Claude, etc.)
2. **The Harness** — Everything else that makes the model useful, safe, and reliable

The model is the engine; the harness is everything else that makes the car drivable. An engine alone gets you nowhere.

### Why Separate These Concerns?

**The model is commodity.** It is external, versioned independently, sometimes proprietary. You cannot change it directly.

**The harness is your domain.** It lives in your repository, is version controlled, and encodes your team's standards and practices.

By separating these concerns explicitly, you gain:

- **Portability**: Your harness works across different models *and* different AI tools, because it is built on open standards that Cursor, Copilot, and other agents read directly — rather than tool-specific files that only one tool can see. (Claude Code needs a one-line shim; the file-level details are in [Harness Components](04-Harness-Components.md).)
- **Clarity**: Behavioral issues become clearly attributable to either model limitations or harness design failures
- **Stability**: Your harness remains consistent while models evolve
- **Auditability**: You can explain why the system behaves as it does by pointing to harness code, not prompting incantations

## Scope: Engineering-Time vs Runtime

This guide covers the same engineering-time vs. runtime split introduced in the [Introduction](00-Introduction.md#scope) — the repository-local system you set up while engineers code, not the production infrastructure that runs agents as services. Both share the same five-layer structure ([chapter 03](03-Five-Control-Layers.md)), but live in different files and mature at different rates. See [`READING.md`](READING.md) → *Foundations* for runtime-focused material that complements this guide.

## The De Facto Harness Specification

Even without a standard, the implementations we're aware of converge on the same **five control layers**:

| Layer | Purpose |
|-------|---------|
| **Guides** | Encode expectations in durable, versioned documentation (e.g. `AGENTS.md`) |
| **Sensors** | Automated checks that catch errors before human review (tests, linters, policy checks) |
| **Context & State** | Rules for what context is loaded, pruned, and persisted — prevents the agent from losing track of what's actually true and compounding its own errors |
| **Tool & Permission Boundaries** | Restrict what actions an agent can take to a safe, approved set |
| **Observability & Lifecycle Controls** | Cost limits, retry ceilings, health checks—makes agents operable, not just impressive |

The file conventions that implement these layers — `AGENTS.md`, `INVARIANTS.md`, and `SKILL.md` under `.agents/skills/` — are open standards ([agents.md](https://agents.md), [agentskills.io](https://agentskills.io/specification)) adopted across AI coding tools. A harness built on these conventions is read by GitHub Copilot, Cursor, and any agent implementing the specs (Claude Code requires a minimal shim — see [Harness Components](04-Harness-Components.md)) — not just the tool you happen to use today.

None of this is exotic — it's existing engineering discipline, re-applied to a new kind of teammate. The table below shows exactly which practice maps to which layer.

For deep-dive explanations, implementation considerations, and "why this layer matters" for each, see [Five Control Layers](03-Five-Control-Layers.md).

## What's New (and What Isn't)

A harness is mostly a re-arrangement of engineering practices that predate AI. Four of the five control layers map directly onto disciplines you already use:

| Existing engineering practice | Harness layer |
|---|---|
| Documentation (READMEs, decision records, runbooks) | **1.** Guides |
| Automated checks (tests, linting, CI) | **2.** Sensors |
| Access controls, review rules, approved tool lists | **4.** Tool & Permission Boundaries |
| Monitoring, cost tracking, health checks | **5.** Observability & Lifecycle |

Only Layer 3 — Context & State — is genuinely AI-native. Managing what an agent loads, prunes, and remembers across turns is a problem the rest of software engineering didn't have to solve at this granularity.

**What's new is the framing**: tying these layers together into a repository-local control system specifically scoped for AI agents, with the equation `Agent = Model + Harness` as the load-bearing distinction. The industry is slowly converging on the same set of components — but they use different vocabulary for the parts, and no source goes end-to-end on implementation.

**This guide is slightly opinionated synthesis.** It pulls the convergent practices into one executable form — concrete file structures, prompts, workflows, and skills — because no single source does this end-to-end. The structures here are starting points, not prescriptions: internalize the discipline, not the file names or locations (with the exception of `AGENTS.md`, `INVARIANTS.md`, and `SKILL.md` under `.agents/skills/` — open standards that AI tools read by convention). A team that adopts the five layers in their own vocabulary, with their own conventions, has built a harness.

## The Spectrum of Maturity

A minimal harness might include only guides and a Makefile. A production harness will include all five layers plus robust observability, testing, and documentation. The levels below are a working framework, not an industry taxonomy.

| Maturity Level | Includes | Use Case |
|---|---|---|
| **Experimental** | Guides only | Prototyping, learning |
| **Functional** | Guides + Sensors + Makefile | Early production |
| **Robust** | All 5 layers + Observability | Team-scale deployment |
| **Enterprise** | All of the above + comprehensive auditability and compliance | Multi-team, regulated environments |

## Key Principle: Repo-Specific Design

Your harness should reflect **your** system's constraints, not anyone else's. A harness for a code-generation tool looks different from a harness for data classification, which looks different from a harness for bug triage.

What is constant across all these harnesses:
- The five control layers exist (with different implementations)
- Documentation is explicit and durable
- Constraints are encoded, not implied
- Failures are detectable and debuggable

What varies:
- The specific components and tools
- The strictness of each boundary
- The fidelity of observability
- How much is automated vs. human-gated

The harness is not a template you install. It is a discipline you practice, adapted to your specific engineering context.

This chapter named the five layers. The next one takes each in turn — the failure mode it guards against, how to build it, and why it earns its place.

---

**← Previous:** [Beyond Prompting](01-Beyond-Prompting.md) · **Next:** [Five Control Layers](03-Five-Control-Layers.md)