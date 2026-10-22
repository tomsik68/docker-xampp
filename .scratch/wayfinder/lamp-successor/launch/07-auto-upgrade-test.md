---
title: Test MARIADB_AUTO_UPGRADE on real xampp data
type: task
mode: HITL
status: closed
assignee: Tomas Jasek
blocked_by: [04-beta-ci.md]
---
## Task

Start a beta tag once with `MARIADB_AUTO_UPGRADE=1` on a copy of a real xampp (MariaDB 10.4) data dir. If it works, keep the route in the migration guide. If it fails, **remove the route from the guide; don't fix it.**

## Resolution

**Failed, so the route was removed from the guide** (2026-10-22, `tomsik68/lamp:8.4-beta`, rootless podman with `--userns=host`).

Test data: real `tomsik68/xampp:8` (MariaDB 10.4.32). Created a `shop` DB with an InnoDB and a MyISAM table plus an `app@%` user, stopped MySQL cleanly, and copied `/opt/lampp/var/mysql`. Mounted a copy at `/var/lib/mysql` with `MARIADB_AUTO_UPGRADE=1`.

- **The upgrade never runs.** XAMPP's data dir has no `mysql_upgrade_info`, and init-lamp detects old data only by that file. So the version guard neither refuses nor upgrades: `MARIADB_AUTO_UPGRADE=1` is a no-op on XAMPP data.
- **MariaDB can't start**: init chowns only the top of the data dir, not its files, so `ibdata1`/`aria_log_control` aren't writable ("Permission denied"). The s6 service keeps restarting.
- After a manual `chown -R mysql:mysql`, 11.8.6 starts on the **un-upgraded 10.4 system tables** (errors on `mysql.event`, `innodb_table_stats`; event scheduler disabled). User data reads fine (`CHECK TABLE` OK), but it's an unsupported state.
- XAMPP's accounts come along: root has **no password** (not root/root), and the anonymous `''@localhost` user shadows `app` on local connections.

Guide change (in `~/workset/src/lamp`, **uncommitted**): deleted the "Advanced: upgrading data files in place" section; the "Mounting old data files" gotcha now says a copy at `/var/lib/mysql` doesn't work either, even with `MARIADB_AUTO_UPGRADE=1`. `MARIADB_AUTO_UPGRADE` stays in `docs/configuration.md` for lamp-to-lamp MariaDB upgrades.

Side finding, not fixed (per the task): a data dir without `mysql_upgrade_info` slips past the old-data guard. Worth a post-T0 look; it's not a T0 blocker now that the guide no longer sends anyone down this path.
