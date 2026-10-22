---
title: Should the bundled DB admin UI be phpMyAdmin or an alternative?
type: wayfinder:research
status: closed
assignee: tomsik68
blocked_by: []
---
## Question

The stack-composition decision bundles phpMyAdmin at `/phpmyadmin`. However, phpMyAdmin 5.2.3, the current release, officially supports only PHP < 8.4, and we ship only 8.4 and 8.5. It runs in the smoke test, but only by luck rather than by support.

Survey the alternatives and compare each with phpMyAdmin: Adminer, AdminerEvo, a phpMyAdmin 6.x / dev snapshot, and any other maintained web-based MySQL/MariaDB admin tool.

For each one, find:
- **Maintenance:** release cadence, how it handles security advisories and CVE history, and who maintains it.
- **Support:** official PHP 8.4/8.5 support and MariaDB 11.8 compatibility.
- **Packaging:** how it ships (one file vs. a tarball, checksums or signatures) and whether `scripts/update-pins.sh` can track it.
- **Configuration:** whether it can be configured to forbid passwordless login.
- **Footprint:** its size in the image.
- **Familiarity:** for xampp migrants, who know phpMyAdmin.

Also find out when phpMyAdmin will officially support PHP 8.4+, such as an upcoming 5.2.x or 6.0 release.

Conclude with a recommendation: keep phpMyAdmin, switch, or ship one and document the other. Note what the choice changes in the docs, the `/phpmyadmin` URL that the migration guide promises, and the `PHPMYADMIN` env var.

## Resolution

Keep phpMyAdmin at `/phpmyadmin` behind the `PHPMYADMIN` toggle; URL and env var unchanged. phpMyAdmin 5.2.3 (and 6.0 snapshots) officially support only PHP < 8.4, with no date for 8.4+ support; it reportedly runs on 8.4 with deprecation notices. So: smoke-test it on both 8.4 and 8.5 images, state the upstream "< 8.4" limit in the docs, and document Adminer (actively maintained, single file, refuses passwordless login, but no upstream checksums/signatures) as a DIY drop-in in `docs/extending.md`. AdminerEvo is archived — ruled out. Fallback if phpMyAdmin breaks on 8.5: ship Adminer, keep `/phpmyadmin` working (serve or redirect), and give it its own `ADMINER` toggle. MariaDB 11.8 compatibility was not confirmed for any tool — verify in the smoke test.

Findings: [research/12-phpmyadmin-alternatives.md](../research/12-phpmyadmin-alternatives.md)
