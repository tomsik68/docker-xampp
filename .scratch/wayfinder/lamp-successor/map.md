---
labels: [wayfinder:map]
status: open
---
# Map: Successor to docker-xampp

## Destination

A deprecation plan for `tomsik68/xampp` **plus** a named successor: either a recommended existing maintained image, or (if none fits) a spec for a new single-container LAMP image. Both must be safe under ongoing PHP CVE remediation.

## Notes

- Domain: Docker images and PHP/LAMP dev environments. Audience: people who can't or won't learn compose, so it must be **one `docker run`**.
- Standing decisions from charting:
  - Only **upstream-supported** PHP branches. EOL tags (5.6, 7.4) get frozen and marked unsupported, never rebuilt.
  - The successor should be an existing maintained image if one fits. Build our own only if none does.
  - We build on the official `php:*-apache` images (trixie only) with Debian MariaDB under s6-overlay, change-triggered rebuilds, and no SSH (see the stack-composition decision). The DB defaults to root/root, reachable from the host (see the migration-guide decision).
- Tracker: local markdown. Tickets live in `tickets/`. Each has frontmatter `type`, `status` (open/closed), `assignee`, `blocked_by` (ticket filenames). The frontier is open tickets whose blockers are all closed and that have no assignee.
- Skills: `/grilling`, `/domain-modeling`, `/research`.

## Decisions so far

- [Does an existing maintained single-container LAMP image fit?](tickets/01-existing-images.md) — no; the all-in-one images are stale and the maintained ones have no DB, so this points to building our own
- [How to deprecate a Docker Hub image and gauge its usage?](tickets/02-deprecation-mechanics.md) — archive on Hub and GitHub after notices; no per-tag counts but every tag is still pulled, so delete none
- [Recommend an existing image or build our own?](tickets/03-adopt-or-build.md) — build our own; the bundled DB in one `docker run` is non-negotiable
- [What is the successor image called and where does it live?](tickets/05-image-name.md) — `tomsik68/lamp` on Docker Hub, mirrored to GHCR, built from a new `tomsik68/lamp` GitHub repo; this repo gets archived
- [What is the deprecation plan and timeline for tomsik68/xampp?](tickets/04-deprecation-plan.md) — no tag deletions; at T0 (first stable `tomsik68/lamp` tag) add notices and a warn-and-run tombstone, at T0+3mo switch to fail-closed with an opt-out env var, and archive Hub and GitHub a week later
- [What exactly is in the successor container?](tickets/06-stack-composition.md) — `php:X.Y-apache` on trixie (bookworm dropped later), Debian MariaDB, s6-overlay, bundled DB admin UI (now Adminer, see below), xdebug off by default, a common extension set with imagick, soap, redis and memcached, composer, no SSH; the Valkey/memcached servers are a derived-image docs recipe
- [How is the successor configured and where does data live?](tickets/07-config-and-volumes.md) — root/root by default, reachable from the host and overridable (amended by the migration-guide decision); web root `/var/www/html` with old-path symlinks, data in `/var/lib/mysql`; dump-and-restore is the only migration path (the in-place auto-upgrade route [failed on real xampp data](launch/07-auto-upgrade-test.md) and was dropped)
- [What are the tag scheme and rebuild policy?](tickets/08-tags-and-rebuilds.md) — PHP 8.4 and 8.5 on trixie only (bookworm dropped); `8.x`/`8`/`latest` plus `-trixie` and patch tags; GitHub Actions, amd64+arm64, daily rebuild-on-change plus Renovate, smoke-tested before push

- [What does the xampp → lamp migration guide cover, and how is it structured?](tickets/09-migration-guide.md) — one page at `docs/migrating-from-xampp.md` in `tomsik68/lamp`, linked from the README: a tag map, the common steps, gotchas and per-version PHP notes; ports 80/3306 and root/root (reachable from the host) kept, so only SSH, the dashboard and the paths change
- [What reference docs does tomsik68/lamp ship with at T0?](tickets/10-successor-docs.md) — all at T0: a README that doubles as the Hub description (auto-synced by CI), `docs/configuration.md` (env vars + drop-ins), `docs/extending.md` (derived-image recipe), and the migration guide
- [Should the bundled DB admin UI be phpMyAdmin or an alternative?](tickets/12-phpmyadmin-alternatives.md) — keep phpMyAdmin at `/phpmyadmin` (URL and `PHPMYADMIN` unchanged), test on 8.4 and 8.5, document the upstream PHP < 8.4 limit and Adminer as a DIY drop-in; switch to Adminer only if phpMyAdmin breaks (superseded below)
- [What must be done before tomsik68/lamp is published?](tickets/11-pre-publish-checklist.md) — public repo + CI beta tags first; T0 gated on CI/arm64/real-docker, PUID bind mounts and one auto-upgrade test; xampp tombstones and notices go out the same day, right after lamp stable
- [Should lamp switch from phpMyAdmin to Adminer after all?](tickets/13-reconsider-phpmyadmin.md) — yes: MySQL-only Adminer with the login-defaults plugin at `/adminer`, `/phpmyadmin` redirects there, `ADMINER=0` toggle, sha256-pinned and bumped by reviewed PRs

## Not yet specified

## Out of scope

- Compose-based or multi-container setups as the primary offering.
- Maintaining EOL PHP versions (5.6, 7.4).

## Execution

The decisions are turned into launch tasks in [`launch/`](launch/) (same frontmatter; `mode` is HITL or AFK). Start with any open task that has no assignee and whose blockers are all closed.
