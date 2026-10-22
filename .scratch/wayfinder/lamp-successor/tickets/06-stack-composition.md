---
title: What exactly is in the successor container?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [03-adopt-or-build.md]
---
## Question

Confirm or revise the lean: base on official `php:*-apache` (which Debian release), MariaDB vs MySQL, process supervisor (supervisord vs alternatives), phpMyAdmin bundled vs optional, which PHP extensions ship by default, and that there's no SSH.

## Resolution

A development image: official `php:X.Y-apache-<codename>` + Debian MariaDB under s6-overlay, with phpMyAdmin and xdebug included. No SSH.

- **Debian:** build both `trixie` (Debian 13, MariaDB 11.8) and `bookworm` (Debian 12, MariaDB 10.11) as matrix rows. Codename pinned in `FROM` (`php:X.Y-apache-<codename>`), never the floating tag.
- **Database:** MariaDB from Debian apt (11.8 on trixie, 10.11 on bookworm). No MySQL; version is tied to the Debian variant, not independently selectable.
- **Supervisor:** s6-overlay (revises the supervisord lean). Gives ordered init (DB setup oneshot → mariadb → apache) and readiness. Not from apt: release tarball pinned by version + checksum, so its updates must be tracked explicitly.
- **phpMyAdmin:** bundled, on by default at `/phpmyadmin`, disable with `PHPMYADMIN=0`. Upstream release tarball pinned by version + checksum (Debian package lags). No passwordless root login. Image remains a **development** image.
- **PHP extensions (default):** `mysqli`, `pdo_mysql`, `gd` (jpeg/webp/freetype), `intl`, `zip`, `bcmath`, `exif`, `opcache`, `imagick`, `soap`, `redis` (phpredis, Valkey-compatible), `memcached` (plus base-image `mbstring`, `curl`, `openssl`, `pdo`). `xdebug` installed but off; enabled via `XDEBUG_MODE`.
- **Apache:** `mod_rewrite` on, `AllowOverride All` on the web root.
- **Tools:** `composer` binary included.
- **Excluded:** SSH; Valkey and memcached **servers**. The PHP client extensions ship; docs show a derived image adding the servers (Debian `valkey-server` on trixie; bookworm lacks it, so the docs point to Valkey's own packages or Debian Redis there; `memcached` from apt on both).

> **Revised by** [What are the tag scheme and rebuild policy?](08-tags-and-rebuilds.md): bookworm dropped; trixie only (MariaDB 11.8). The Valkey recipe's bookworm caveat no longer applies.
