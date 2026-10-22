---
title: What does the xampp → lamp migration guide cover, and how is it structured?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [04-deprecation-plan.md, 07-config-and-volumes.md, 08-tags-and-rebuilds.md]
---
## Question

Decide the scope and outline of the migration guide every deprecation notice and the tombstone banner link to (must exist by T0). Settled inputs: the core path is user-DB dump and restore, with `MARIADB_AUTO_UPGRADE=1` as the advanced route (config-and-volumes); the `XAMPP_I_ACCEPT_THE_RISK` opt-out (deprecation plan); PHP 8.4+ on trixie only (tags-and-rebuilds).

Open: which XAMPP-specific gotchas get covered (old root/no-password credentials, SSH removal, XAMPP dashboard gone, `/opt/lampp` paths and `php.ini`/`my.cnf` locations, `docker run` flag/port/volume mapping old → new, jumping from PHP 5.6/7.4/8.x to 8.4+); audience level and format (one page vs. per-source-version sections, tag-mapping table); where it lives (successor repo README section, separate doc, Hub description link) and its stable URL.

## Resolution

- **Location:** `docs/migrating-from-xampp.md` in the `tomsik68/lamp` repo, linked from its README. Its stable URL is `https://github.com/tomsik68/lamp/blob/main/docs/migrating-from-xampp.md`, built into the banners and tombstones.
- **Structure:** one linear page:
  1. Old-tag → new-tag mapping table (everything maps to `8.4`/`latest`).
  2. Common steps: dump the user DBs, `docker run` old → new, restore.
  3. Gotchas.
  4. "Upgrading your PHP code", with one short paragraph each for 5.6, 7.4 and 8.x, linking the php.net migration guides.
- **Compatibility changes to the image** (these narrow the gotchas):
  - **Credentials:** the DB defaults to root/root, reachable from the host as in XAMPP. This amends *How is the successor configured and where does data live?*. `MARIADB_ROOT_PASSWORD` still overrides it, and the banner warns while the default is in use.
  - **Ports:** 80 and 3306 stay on the same container ports, so the old `-p` flags keep working. Only 22 goes away. Verify that `/www/` and `/phpmyadmin/` keep their old URLs.
- **Gotchas covered:** no SSH (`docker exec` and `docker cp` instead); no XAMPP dashboard (where phpMyAdmin is now); paths (`/opt/lampp/htdocs` → `/var/www/html` with symlinks, plus the php.ini and my.cnf drop-in locations); the `docker run` mapping (drop `-p …:22`); a note that the root password is now `root` for anyone who relied on XAMPP's empty one; missing extensions point to the derived-image recipe.
- **Left out:** the `XAMPP_I_ACCEPT_THE_RISK` opt-out, because the tombstone banner explains it.
