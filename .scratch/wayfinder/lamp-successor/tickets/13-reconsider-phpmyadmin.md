---
title: Should lamp switch from phpMyAdmin to Adminer after all?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Question

Revisit the [phpMyAdmin decision](12-phpmyadmin-alternatives.md) (keep phpMyAdmin at `/phpmyadmin`; switch to Adminer only if phpMyAdmin breaks) in light of what the beta showed:

- phpMyAdmin 5.2.3 (2025-10-08) is still the latest release, officially supports only PHP < 8.4, and vendored twig and symfony/cache with fixable HIGH/CRITICAL CVEs. We now patch those at build time with composer ([CI workflows task](../launch/14-more-ci-workflows.md)). That's extra upkeep we own, and it can break on any phpMyAdmin or library release.
- The smoke test now does a real phpMyAdmin login, and the Trivy scan fails on fixable findings, so a broken or vulnerable phpMyAdmin shows up quickly.

Decide: keep phpMyAdmin with the patch, switch to Adminer (or AdminerEvo), or ship both. Settle what triggers a later switch (e.g. a scan finding we can't patch, phpMyAdmin failing on a new PHP branch, no upstream release by a set date). If switching, settle the URL (`/phpmyadmin` kept as an alias?), the fate of the `PHPMYADMIN` toggle, how it's pinned and tracked by `update-pins.sh`, and what the migration guide and docs must say. Whatever is chosen must be in place before T0, because the migration guide and the README describe it.

## Working notes

- Q1: switch to Adminer for T0 (maintainer: similar experience, simpler to use, maintain and install, more secure). phpMyAdmin and its composer patch go away.
- Q2: bundle exactly one plugin, login defaults (localhost/root), pinned by sha256. Other plugins get a DIY section in docs/extending.md.
- Q3: Adminer served at /adminer; /phpmyadmin and /phpmyadmin/* get a 302 to /adminer; the toggle is renamed ADMINER=0 (it also disables the redirect), with no PHPMYADMIN alias since lamp has no stable release yet.

## Resolution

Switch to Adminer before T0. It gives a similar experience and is simpler to use, maintain and install. It is also more secure. phpMyAdmin is removed, along with the build-time composer patch for its vendored twig and symfony/cache.

- **Build:** the upstream MySQL-only single-file build with all languages.
- **Plugins:** only the official login-defaults plugin (localhost/root). `docs/extending.md` explains how to add other plugins. Check how Adminer 5 loads plugins when building.
- **URL:** Adminer is served at `/adminer`. `/phpmyadmin` and `/phpmyadmin/*` return a 302 to `/adminer`, so old xampp bookmarks still work.
- **Toggle:** `ADMINER=0` turns off Adminer and the redirect. There is no `PHPMYADMIN` alias, because lamp has had no stable release.
- **Pinning:** `update-pins.sh` pins Adminer and the plugin to the same release tag, each with a sha256 computed at bump time (upstream publishes no checksums). Bump PRs are always reviewed, never automerged, and must pass the smoke test (a real Adminer login against MariaDB 11.8) and Trivy.
- **Docs:** the README, `docs/configuration.md`, `docs/extending.md` and the migration guide replace phpMyAdmin with Adminer. The guide's "where is phpMyAdmin now" gotcha points to `/adminer` and the redirect.

This replaces the earlier phpMyAdmin decision. Work: [Replace phpMyAdmin with Adminer in lamp](../launch/15-adminer.md).
