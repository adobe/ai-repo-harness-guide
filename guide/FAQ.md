# FAQ

Objections and questions that come up when introducing this guide, expanded into fuller answers.

---

- [Does this make agents safe? Will they stop failing?](#does-this-make-agents-safe-will-they-stop-failing)
- [Won't the agent discover rules on its own?](#wont-the-agent-discover-rules-on-its-own)
- [Why not just use plan mode?](#why-not-just-use-plan-mode)
- [I already have a README.md. Why bother with even more READMEs?](#i-already-have-a-readmemd-why-bother-with-even-more-readmes)
- [I already have a CLAUDE.md](#i-already-have-a-claudemd)
- [Why not just solve this with MCP?](#why-not-just-solve-this-with-mcp)
- [Why bother with generic skills like "implementation" or "testing"?](#why-bother-with-generic-skills-like-implementation-or-testing)

---

### Does this make agents safe? Will they stop failing?

No — and it's worth being clear about what a harness does and doesn't do.

A harness makes output **more reliable**, not guaranteed. Agents will still make mistakes, misread context, and produce output that needs review. The failure rate goes down; it doesn't go to zero.

A harness is also not a replacement for sandboxes, permission boundaries, and execution controls. Those guard against what the agent *does*. The harness guards against what the agent *decides* — by giving it better information to decide from. See [Tool & Permission Boundaries](03-Five-Control-Layers.md) for where that enforcement actually lives.

Think of it as the difference between a well-briefed contractor and an unsupervised one. Better briefing leads to fewer mistakes. It doesn't eliminate the need for oversight.

---

### Won't the agent discover rules on its own?

Yes — during the session, a capable agent will infer patterns from your code. Two problems follow from that.

**You won't know what it discovered.** Did it pick up the right convention, or the legacy one? There's no visibility into what it concluded.

**It doesn't carry over.** Every new session starts from scratch. The agent rediscovers — or misses — the same things again.

Checking conventions into `AGENTS.md` and `INVARIANTS.md` makes context explicit, visible, and consistent across every session and every engineer, instead of leaving it to silent, unverifiable inference. The `harness-setup` skill walks an agent through that discovery process once and finishes with a repository harness you review and commit — see [Build Your Harness](07-Build-Your-Harness.md).

---

### Why not just use plan mode?

Plan mode helps — it gives the agent a chance to explore before acting. But without a harness underneath it, plan mode is high-effort and low-durability.

**High effort**: the agent has to discover your conventions, constraints, and context from scratch every session. That discovery work is on you to review and correct before anything starts.

**Low durability**: whatever the agent learns during planning doesn't carry over. Next session, it starts from scratch again.

A harness gives plan mode something to work *from*. The conventions and constraints already exist in `AGENTS.md`, `INVARIANTS.md`, and the repo's skills — the agent plans against them rather than discovering them.

---

### I already have a README.md. Why bother with even more READMEs?

Most repositories have one — and it's probably outdated. But even a current README isn't quite the right thing.

A README tells humans how to set up and use the project. `AGENTS.md` tells agents how to *operate* in it: what modules exist, who owns what, what to never do, where the footguns are. Different audience, different content — see [README.md - Human Entry Point](04-Harness-Components.md#2-readmemd---human-entry-point) for how the two are meant to divide responsibility.

Both are worth having, and the `harness-setup` skill will help update and trim an existing README down to the right scope rather than writing a second one from nothing.

---

### I already have a CLAUDE.md

Two issues.

**It's not agent-agnostic.** `CLAUDE.md` is read by Claude Code. Cursor, Copilot, and other agents ignore it. A harness should work regardless of which tool an engineer is using.

**Scope is hard to get right.** Too short and the agent lacks context. Too large and it pollutes the context window — in our experience, models tend to deprioritize content buried deep in a long file. Both are common failure modes.

`CLAUDE.md` should be a tool-specific shim, not the canonical file — see the footnote on `AGENTS.md` portability in [Harness Components](04-Harness-Components.md#1-agentsmd---operational-context). `AGENTS.md` is the portable equivalent, and most agents read it natively. Check your tool's documentation for current support.

---

### Why not just solve this with MCP?

MCP is a good tool — for context that lives outside your repository.

Jira tickets, Confluence pages, New Relic dashboards, Splunk logs, Prometheus metrics — MCP lets agents query live external systems instead of guessing. That's genuinely useful.

But MCP is executed by a probabilistic agent. The agent decides what to query, how to interpret the result, and whether it asked the right question. It may query the wrong field, misread an ambiguous ticket, or miss relevant data entirely.

Harness files are different. When you check in `AGENTS.md` and `INVARIANTS.md`, the context is defined the same way every time — version controlled, reviewed, and loaded consistently across every session and every engineer.

**MCP for live external context. Harness files for what your repo always needs to be true.**

---

### Why bother with generic skills like "implementation" or "testing"?

Often you shouldn't. A capable model handles most task types well from `AGENTS.md`/`INVARIANTS.md` context alone — add a skill only when a task type is frequent or error-prone enough that a dedicated procedure measurably helps. There's no fixed set every repo needs.

When a skill *is* warranted, it isn't as generic as it looks: a "code review" skill in your repo tells the agent to check against *your* `INVARIANTS.md`, follow *your* module structure from `AGENTS.md`, and run *your* `make check`. The same skill name in another repo does something subtly different — because it reads different files.

The skill is the method. The harness files are the context. See [Skills - Capability & Method Contract](04-Harness-Components.md#4-skills---capability--method-contract-optional) for how that contract is written.

---

**← Back to:** [README.md](README.md)
