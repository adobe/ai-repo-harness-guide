# Contributing

Thanks for choosing to contribute!

The following is a set of guidelines to follow when contributing to this project.

## Code Of Conduct

This project adheres to the Adobe [code of conduct](CODE_OF_CONDUCT.md). By participating,
you are expected to uphold this code. Please report unacceptable behavior to
[Grp-opensourceoffice@adobe.com](mailto:Grp-opensourceoffice@adobe.com).

## Have A Question?

Start by filing an issue. The existing committers on this project work to reach
consensus around project direction and issue solutions within issue threads
(when appropriate).

## Contributor License Agreement

All third-party contributions to this project must be accompanied by a signed contributor
license agreement. This gives Adobe permission to redistribute your contributions
as part of the project. [Sign our CLA](https://opensource.adobe.com/cla.html). You
only need to submit an Adobe CLA one time, so if you have submitted one previously,
you are good to go!

## Code Reviews

All submissions should come in the form of pull requests and need to be reviewed
by project committers. Read [GitHub's pull request documentation](https://help.github.com/articles/about-pull-requests/)
for more information on sending pull requests.

Lastly, please follow the [pull request template](.github/PULL_REQUEST_TEMPLATE.md) when
submitting a pull request!

## From Contributor To Committer

We love contributions from our community! If you'd like to go a step beyond contributor
and become a committer with full write access and a say in the project, you must
be invited to the project. The existing committers employ an internal nomination
process that must reach lazy consensus (silence is approval) before invitations
are issued. If you feel you are qualified and want to get more deeply involved,
feel free to reach out to existing committers to have a conversation about that.

## Security Issues

Security issues shouldn't be reported on this issue tracker. Instead, [file an issue to our security experts](https://helpx.adobe.com/security/alertus.html).

---

## Local Setup

The Claude Code skill links under `.claude/skills/` are committed as **symlinks** to the canonical skills in `.agents/skills/`. Git checks them out as real links only when `core.symlinks` is enabled — auto-detected `true` on Linux and macOS, but often `false` on Windows. If they appear as small plain-text files after cloning, enable [Developer Mode](https://learn.microsoft.com/windows/apps/get-started/enable-your-device-for-development), run `git config core.symlinks true`, and re-checkout with `git checkout -- .claude/skills`. Background: [Build Your Harness](https://github.com/adobe/ai-repo-harness-guide/blob/main/guide/07-Build-Your-Harness.md) (step 2.1c).

## Commit Messages

Format: [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): subject`

```
feat(04): add sensor pattern for test coverage checks
docs(agents): clarify ContentEditor authority boundary
fix(07): correct broken link to harness-setup skill
chore: bump version to 1.25.0
```

- **type**: `feat` | `fix` | `docs` | `chore` | `refactor` | `style` | `test`
- **scope** (optional): chapter number (`04`), file, or area (`agents`, `invariants`, `skills`)
- **subject**: imperative mood, lowercase, no trailing period
- **body** (if needed): explain *why* — the diff shows *what*

## Branch Naming

Prefix mirrors the commit type:

| Prefix | Use |
|--------|-----|
| `feat/` | new content or new section |
| `fix/` | corrections, broken links, errors |
| `docs/` | guide updates that are not corrections |
| `chore/` | tooling, CI, changelog, version bumps |
| `refactor/` | restructuring without content change |
| `test/` | adding or updating tests |

Example: `docs/contributing-conventions`, `fix/broken-link-ch04`, `chore/bump-v1-25`

## Common Tasks

| Task | Skill |
|------|-------|
| Write or edit guide content | [documentation](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/documentation/SKILL.md) |
| Build or extend a harness | [harness-setup](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/harness-setup/SKILL.md) |
| Audit an existing harness | [harness-inspect](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/harness-inspect/SKILL.md) |
| Review chapters or books | [guide-review](https://github.com/adobe/ai-repo-harness-guide/blob/main/.agents/skills/guide-review/SKILL.md) |

## Escalation Checklist

Any of the following requires human review before merge:

- [ ] Change would violate a constraint in [INVARIANTS.md](INVARIANTS.md)
- [ ] Structural change — adding/removing a chapter, changing the five-layer model, changing series sequence
- [ ] Content that contradicts existing material or changes the core model (Agent = Model + Harness)
- [ ] Changes to skills (`harness-setup`, `harness-inspect`) in `.agents/skills/`
