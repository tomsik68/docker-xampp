---
title: Make the default-password banner check the real password
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: [09-t0-day.md]
---
## Task

After T0. The banner currently checks the env var, not the actual DB password. Until this is fixed, `docs/configuration.md` should say what the banner checks. Then make it check the real password.

## Resolution

Done on 2026-10-22 in `tomsik68/lamp` commit `44bff64` (pushed; CI build, lint and shellcheck passed).

- The warning moved out of `init-lamp` into a new oneshot, `check-root-password`, which runs after `mariadb`. It waits for the server, logs in as root over the socket (unix_socket), and warns if any root account outside `localhost`/`127.0.0.1`/`::1` has `PASSWORD('root')`. If the socket login fails (unix_socket removed), it skips the check without a warning.
- `docs/configuration.md` now says that the check reads the accounts in the database.
- `tests/smoke.sh` checks that the warning shows by default, then changes `root@'%'` with SQL, restarts the container, and checks that the warning is gone. It passes on 8.4 with rootless podman (`RUN_FLAGS=--userns=host`; keep-id still breaks init, as found in the PUID task).
