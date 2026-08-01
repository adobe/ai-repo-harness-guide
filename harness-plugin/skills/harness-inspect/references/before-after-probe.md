# Before/After Probe

Use this prompt to observe how an agent operates in your repository — before harness work and again after. The same prompt runs both times. What changes between runs is the harness.

The prompt gives the agent a task with no guidance about where to look, what constraints apply, or how to verify — then asks it to report what it would do rather than do it. That is intentional: a well-designed harness surfaces the right files, constraints, and verification steps naturally. The probe reveals whether it does, without touching the codebase.

**Prompt:**

```
You are working in this repository. Make a small but meaningful improvement — a bug fix,
a missing test, a documentation gap, or a code quality issue. Choose based on what you find.

Do not make any changes. Instead, report:
- What was already in your context when you started (auto-loaded files, if any)
- Every file you would read before starting, in order, and why
- What constraints or guidance you found — or didn't find
- What change you would make and why you chose it
- What commands you would run to verify it
- Anything you would have to assume because the repository didn't tell you
- Whether you would proceed autonomously or stop for human approval, and why
```

**What to look for:**

| Dimension | Without harness | With harness |
|---|---|---|
| First action | Dives into code | Reads entry point documentation |
| Constraints | Ignores or violates them | Identifies and follows them |
| Verification | Asks what to check, or skips it | Runs validation commands unprompted |
| Escalation | Proceeds on assumptions | Recognises escalation triggers and stops |
| Success rate | Depends on prompt quality | Depends on harness quality |

Note which files the agent reads first, whether it self-verifies, and where it gets stuck. Run it again after improvements to measure the delta.
