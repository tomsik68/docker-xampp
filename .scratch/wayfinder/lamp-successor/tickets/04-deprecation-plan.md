---
title: What is the deprecation plan and timeline for tomsik68/xampp?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [02-deprecation-mechanics.md, 03-adopt-or-build.md, 05-image-name.md]
---
## Question

What steps, in what order, and on what dates do we deprecate the image: messaging, final rebuild or warning image, archiving the GitHub repo and Docker Hub repo, and where we point people?

Input from the image-name ticket: the maintainer wants a way to pull or "yank" the vulnerable `tomsik68/xampp` images once a migration plan exists. This conflicts with the research finding that every tag is still pulled and none should be deleted. Weigh the two. The GitHub repo `tomsik68/docker-xampp` will be archived, and the notices point to `tomsik68/lamp`.

## Resolution

**No tag is ever deleted.** "Yanking" is done with a tombstone image pushed over all 18 existing tags, in two stages. Everything is reversible, and pulls never fail with "manifest unknown".

The timeline is anchored on events, not calendar dates:

| When | Step |
|---|---|
| **T0**: `tomsik68/lamp` publishes its first stable tag, with the migration guide | Add a "DEPRECATED;" prefix to the Hub short description, a README banner on Hub and GitHub naming `tomsik68/lamp` and linking the migration guide, and a pinned GitHub issue. Push the **warn-and-run** tombstone: the last real build plus a loud deprecation banner on startup. |
| **T0 + 3 months** | Push the **fail-closed** tombstone: it prints the banner and migration link, then exits non-zero unless `XAMPP_I_ACCEPT_THE_RISK=1` is set, in which case it runs the old stack. Close open issues and PRs with a pointer to `tomsik68/lamp`. |
| **T0 + 3 months + 1 week** | Archive the Docker Hub repo `tomsik68/xampp` and the GitHub repo `tomsik68/docker-xampp`. The week leaves room to fix the fail-closed image, because archiving blocks pushes. |

- There's no pre-announcement before T0, so nobody is told to migrate before there's something to migrate to.
- **Rejected:** deleting tags, including EOL ones. All tags are still pulled, and deletion breaks unattended users with no explanation.
