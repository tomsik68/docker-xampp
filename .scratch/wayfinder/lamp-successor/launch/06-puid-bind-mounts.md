---
title: Test bind mounts with a non-1000 PUID/PGID
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: [04-beta-ci.md]
---
## Task

Bind-mount the web root and `/var/lib/mysql` from a host directory owned by a UID/GID other than 1000. Set `PUID`/`PGID` to match, then check that the files are written with the host ownership and that MariaDB starts.

## Resolution

Done (2026-10-22, `tomsik68/lamp:8.4-beta`, rootless podman with `--userns=host`; the host dirs were chowned to 2001:2002 via `podman unshare`, which matches a rootful Docker host).

- Web root: with `PUID=2001 PGID=2002`, `www-data` becomes 2001:2002, and files PHP writes into the bind mount are owned 2001:2002 on the host. Passes.
- `/var/lib/mysql`: MariaDB 11.8.6 initialised a fresh DB and started; `root`/`root` connects from PHP and the CLI. But init **chowns the data dir to `mysql` (100:101)**, so it does not keep the host ownership. PUID/PGID affect only Apache, as `docs/configuration.md` says. This matches the official mariadb image and is not a T0 blocker. Worth one line in `docs/configuration.md`, since the host user then needs sudo to delete the dir.
- Side finding: with podman `userns=keep-id` (set in the maintainer's `containers.conf`), the container isn't real root, `groupmod` fails, and init-lamp exits 10 (fail-closed, clear log). Not a Docker concern; optionally document "rootless podman: don't use keep-id".
