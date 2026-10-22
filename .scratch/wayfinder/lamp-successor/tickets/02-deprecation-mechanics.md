---
title: How to deprecate a Docker Hub image and gauge its usage?
type: wayfinder:research
status: closed
assignee:
blocked_by: []
---
## Question

What mechanisms exist to deprecate `tomsik68/xampp` on Docker Hub and GitHub: repo description/README, the Docker Hub "deprecated"/archive features, GitHub archive, a final image that prints a warning on start? What usage data can Docker Hub expose per tag (pull counts, last pulled)? And what do well-known deprecated images do (precedent)?

## Resolution

- **Docker Hub:** "Archive repository" makes the repo read-only, still pullable and reversible. There's no separate deprecated flag. It freezes descriptions and blocks pushes, so notices and any final image must go out first.
- **GitHub:** archiving is read-only and reversible. Close issues and PRs first.
- **Usage:** 552,540 total pulls. Only last_pulled/last_pushed per tag, with no per-tag counts unless DVP/DSOS. As of 2026-10-21 all 18 tags were pulled within ~10 days, including 5.6/7.3, so delete no tags.
- **Precedent** (java, centos, openjdk): "DEPRECATED;" short-description prefix plus a README banner naming the replacement and a date. Nothing deleted, nothing archived.
- **Suggested order:** notices, then an optional final warning image (an unsourced suggestion), then archive Hub and GitHub.

Findings: branch `research/deprecation-mechanics`, file `research/deprecation-mechanics.md`.
