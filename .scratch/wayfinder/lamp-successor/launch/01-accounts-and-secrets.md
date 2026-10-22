---
title: Create the lamp repos, registries and secrets
type: task
mode: HITL
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Task

Create the public GitHub repo `tomsik68/lamp` and the Docker Hub repo `tomsik68/lamp`, and enable GHCR. Set the secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` and `PINS_TOKEN`. Install the Renovate app. Enable GitHub private vulnerability reporting.

Done when the repo exists and every secret is set (only the maintainer can do this).

## Progress

- [x] GitHub repo `tomsik68/lamp` created (private for now; make it public before T0 day)
- [x] Docker Hub repo, GHCR (`lamp` package present, confirmed by maintainer)
- [x] Secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` (set 2026-10-21)
- [x] Secret `PINS_TOKEN` (set 2026-10-22)
- [x] Renovate app (installed 2026-10-22, limited to `tomsik68/lamp`)
- [-] Private vulnerability reporting and "Allow auto-merge": moved to [T0 day](09-t0-day.md), since both need the repo public

## Resolution

Done 2026-10-22. The repo (still private), Docker Hub and GHCR (`lamp` package) are in place. Secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` and `PINS_TOKEN` (a fine-grained PAT, so it expires; renew it or pin bumps stop without any error) are set. Renovate is installed. Its first onboarding PR or Dependency Dashboard had not appeared yet when this was closed. Turning on "Allow auto-merge" and private vulnerability reporting needs a public repo, so both moved to [T0 day](09-t0-day.md).
