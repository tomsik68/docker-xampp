---
title: What reference docs does tomsik68/lamp ship with at T0?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Question

Decide the scope and layout of the successor's own docs (README and `docs/`), apart from the migration guide. Candidates: the derived-image recipe (Valkey/memcached servers via trixie apt, extra extensions via `docker-php-ext-install`/`pecl`), the full env-var reference (including `PUID`/`PGID` and the root/root, host-reachable default warning), the config drop-in directories, and the supported-branches/tags table plus the frozen-EOL-tag policy. Which are required at T0, and which can follow?

## Resolution

Every candidate ships at T0, alongside the migration guide.

- **README.md:** a short quick start (one `docker run`, ports 80/3306, the `/var/lib/mysql` volume), the supported-tags table with the frozen-EOL policy, the root/root host-reachable warning, and links to `docs/`. It doubles as the Docker Hub description.
- **docs/configuration.md:** the full env-var reference (defaults, first-init vs every start, `PUID`/`PGID`) plus the config drop-in directories (`/usr/local/etc/php/conf.d`, `/etc/mysql/conf.d`).
- **docs/extending.md:** the derived-image recipe (Valkey/memcached servers via trixie apt, extra extensions via `docker-php-ext-install`/`pecl`).
- **docs/migrating-from-xampp.md:** as decided in the migration-guide ticket.
- **Hub sync:** the CI release workflow pushes `README.md` to the Hub description automatically (e.g. `peter-evans/dockerhub-description`). README links to `docs/` are absolute GitHub URLs so they work on Hub.
