---
title: How is the successor configured and where does data live?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [06-stack-composition.md]
---
## Question

Default credentials (none / random / env-required), env-var configuration surface, volume layout for web root and DB data, and whether to keep `/www` or `/opt/lampp/htdocs` compatibility paths for migrating users.

Input from the image-name ticket: compatibility with the old image comes from shims, not a shared name. Consider `/www` and `/opt/lampp/htdocs` aliases for the web root. Watch out for MariaDB upgrading old `/opt/lampp/var/mysql` data files in place, after which the old image can't read them. The upgrade has to be a deliberate migration step.
- `PHPMYADMIN=0` toggle belongs to the env-var surface; phpMyAdmin login must use real DB credentials (no passwordless root).
- `XDEBUG_MODE` (xdebug off by default) is part of the env-var surface.

## Resolution

- **Credentials:** the default root password is the well-known dev value `lamp`, chosen to stay friendly to start with. Containment: `MARIADB_ROOT_PASSWORD` overrides it on the first init. Root is **local-only** (`root@localhost`), so PHP and phpMyAdmin work but a published 3306 doesn't expose root. A startup banner warns while the default is in use.
  - **Amended by the migration-guide ticket (2026-10-21):** the default is now **root/root**, and root is reachable from the host (`root@%`), matching XAMPP-style convenience. `MARIADB_ROOT_PASSWORD` still overrides it, and the startup banner still warns while the default is in use.
- **Paths:** the web root is `/var/www/html`, the official `php:*-apache` default. `/www` and `/opt/lampp/htdocs` are symlinks to it, and mounting over the symlink path needs verifying at build. DB data lives in `/var/lib/mysql`, declared as a `VOLUME`. No other volumes are declared. Config overrides go into drop-ins (`/usr/local/etc/php/conf.d`, `/etc/mysql/conf.d`) and are documented.
- **Old-data guard:** this is version-based, not path-based. If data is mounted at `/opt/lampp/var/mysql`, or the data dir's recorded server version (`mysql_upgrade_info`) is older than the bundled MariaDB, the container refuses to start with a migration-guide link, unless `MARIADB_AUTO_UPGRADE=1` is set. This also covers bookworm→trixie.
- **Migration path:** the documented primary path is dump and restore of the **user databases only**, never `--all-databases`, which would overwrite the new root setup. Users and grants are recreated by hand or via `MARIADB_USER`. The old data stays untouched, so rollback is possible. In-place upgrade via `MARIADB_AUTO_UPGRADE=1` is the advanced alternative: back up first, and consider going through 10.11 when coming from 10.4.
- **Env-var surface:** `MARIADB_ROOT_PASSWORD` (default `lamp`). `MARIADB_DATABASE`/`MARIADB_USER`/`MARIADB_PASSWORD` (first init, and this user may connect remotely). `MARIADB_AUTO_UPGRADE`. `PHPMYADMIN` (default `1`). `XDEBUG_MODE` (default `off`). `PUID`/`PGID` (default 33, remaps the Apache user so bind-mount file ownership matches the host). There's no generic `PHP_INI_*` mechanism; drop-in config files cover tuning instead.
