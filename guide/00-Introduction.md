# Introduction

This guide covers **repository harnesses**—the repository-local control systems that make AI-assisted coding workflows reliable and repeatable. It focuses on the **engineering-time** half: the repository-local control system that shapes AI coding agents. See [Scope](#scope) below for what's in and out.

---

## Why This Matters

AI coding agents are only as reliable as the system around them. Without explicit constraints, a capable model will confidently make the wrong call — ignoring a security invariant, repeating a mistake you've already fixed, or choosing the wrong abstraction because no one told it not to. A harness is the infrastructure that closes the loop: it encodes what agents need to know, what they must not do, and how to verify their output. With it, agents catch their own mistakes. Without it, you catch them instead.

That reliability comes from putting human-reviewed context into the codebase itself. Once someone captures how the repository is structured, what its conventions are, and which constraints must hold — and confirms it's right — every agent works from the same approved starting point, and its responses grow far more predictable from one session to the next. It also cuts repeated work: because those facts are written down and reused, agents spend less of each session rediscovering the same things about the repository.

Predictability is what separates teams that get real gains from AI from those that don't. The bottleneck usually isn't the model's capability; it's whether its behavior can be trusted and repeated. A harness scopes what agents can do autonomously, enforces quality and compliance constraints regardless of who — or what — wrote the code, and keeps humans in the loop for the decisions that matter. The difference between "we tried AI coding tools and it didn't work out" and "AI tools work for us" is usually the harness.

---

## What This Guide Is

Most of a harness is a re-arrangement of practices already common in software engineering — versioned docs, automated checks, permission boundaries, observability. What's new is the framing that ties them together for AI agents specifically. This guide is **slightly opinionated synthesis** — convergent practices from industry sources, pulled into one executable form because no single source covers this end-to-end. See [What a Harness Is](02-What-a-Harness-Is.md#whats-new-and-what-isnt) for the full mapping of existing practices to harness layers.

---

## Scope

Industry usage of "harness engineering" tends to mix two related-but-distinct concerns. **This guide focuses on the first.**

| | Engineering-time (this guide) | Runtime (not this guide) |
|---|---|---|
| **What it is** | The repository-local control system that shapes AI coding agents at development time | The production infrastructure that runs AI agents as services |
| **What's in scope** | `AGENTS.md`, `INVARIANTS.md`, skills, sensors, the `Makefile`, `docs/` | Tool dispatch, retry logic, cost ceilings, runtime observability, verification loops on live calls |
| **Where it lives** | Checked into your repo | Deployed alongside your service |
| **When it runs** | While engineers code with AI assistance | While end users invoke your agent in production |

The five control layers in [chapter 03](03-Five-Control-Layers.md) apply to both — but they're implemented in different files, run at different stages, and mature at different rates. Most articles you'll find blend the two concepts because they are related; this guide deliberately scopes to engineering-time so the recommendations stay concrete.

If you're shipping AI agents that run as part of a production service, treat this guide as the engineering-time half and use [`READING.md`](READING.md) for runtime-focused material that complements it.

---

## Where to Start

**New to repository harnesses?** → Start at [Beyond Prompting](01-Beyond-Prompting.md) and read in order.

**Need to build a harness?** → [Five Control Layers](03-Five-Control-Layers.md) → [Harness Components](04-Harness-Components.md) → [Build Your Harness](07-Build-Your-Harness.md)

**Already have a partial harness?** → [Migrate Your Harness](08-Migrate-Your-Harness.md)

**Need to maintain an existing harness?** → [Keep It Current](09-Keep-It-Current.md)

**Need the reference layout?** → [Reference Layout](06-Reference-Layout.md)

For the full document index, see [README.md](README.md).

---

## The Five Control Layers

A harness works through five control layers — Guides, Sensors, Context & State, Tool & Permission Boundaries, and Observability & Lifecycle Controls. [What a Harness Is](02-What-a-Harness-Is.md) introduces what each one does; [Five Control Layers](03-Five-Control-Layers.md) covers each in depth.

---

## Acknowledgements

While I wrote most of the content in this guide myself, it was shaped with the assistance of large language models — Claude 4.5 Sonnet, Claude 4.6 Opus and ChatGPT 5.4. I relied on them for prose refinement, structural review, synthesizing suggestions, and as thought partners for continuous learning throughout the writing process. Their contributions are a fitting testament to the very approach this guide describes.

The ideas here also draw on published research and engineering writing from Thoughtworks, Anthropic, Spotify, Stripe, OpenAI, and Langchain; the AGENTS.md and Agent Skills open specifications; and the agent documentation from Anthropic, GitHub Copilot, OpenAI Codex, and Cursor. See [READING.md](READING.md) for the full annotated list.

---

**Next:** [Beyond Prompting](01-Beyond-Prompting.md)
