---
title: Run the beta image on a real Docker host
type: task
mode: HITL
status: closed
assignee: Tomas Jasek
blocked_by: [04-beta-ci.md, 15-adminer.md]
---
## Task

One manual `docker run` of a beta tag on real Docker, not podman. Check that `HEALTHCHECK` works, Adminer is at `/adminer` (logs in as root/root), `/phpmyadmin` redirects there, and the DB is reachable from the host as root/root.

## Resolution

Done (2026-10-22). The user ran the beta image on a real Docker host and every check passed: `HEALTHCHECK` reports healthy, Adminer at `/adminer` logs in as root/root, `/phpmyadmin` redirects to `/adminer/`, and the DB is reachable from the host as root/root on 3306.
