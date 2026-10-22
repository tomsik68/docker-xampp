# 12 — phpMyAdmin alternatives for `tomsik68/lamp` (PHP 8.4/8.5, MariaDB 11.8)

Researched 2026-10-21. These are primary sources only. Items marked "unverified" were not confirmed against a primary source.

## TL;DR
Keep **phpMyAdmin 5.2.x** at `/phpmyadmin`, behind the existing `PHPMYADMIN` toggle. Document that it is not officially supported on PHP 8.4/8.5 and that this is upstream's stated limit. Mention **Adminer** in the docs as a single-file alternative that users can drop in themselves. Don't ship it by default. AdminerEvo is dead.

## Comparison

| | phpMyAdmin 5.2.3 | phpMyAdmin 6.0 (dev snapshot) | Adminer 6.1.2 | AdminerEvo |
|---|---|---|---|---|
| Status | Stable. Released 2025-10-08; it is still the current stable a year later [1] | "In development". Daily snapshot dated 2026-10-20 [1] | Active. 10 releases between Jul and Oct 2026 (5.4.3 to 6.1.2) [2] | **Archived 2025-01-24**. The README points users to pematon/adminer [3] |
| Security handling | Signed releases, PMASA advisories [1] | Snapshots have SHA256 only, no PGP signature [1] | GitHub Security Advisories (GHSA) on nearly every release, e.g. XSS, CSRF and SQLite ATTACH issues in 5.4.3, 6.0.0, 6.0.2 and 6.1.1 [2] | None (archived) |
| Official PHP 8.4/8.5 | **No**: requires PHP ≥7.2 and <8.4 [1] | **No**: requires PHP ≥8.2 and <8.4 per the downloads table [1]. The docs say 6.0 is 8.2+ only [5] | Site says "PHP 5.3+, 7, 8" with no upper bound [4]. Release notes mention PHP 8.5 behaviour (PDO authorizer) [2] | n/a |
| MariaDB 11.8 | MySQL/MariaDB ≥5.5 [1]. 11.8 is not named (unverified) | same [1] | MySQL and MariaDB [4]. 11.8 is not named (unverified) | n/a |
| Packaging | Tarball. `all-languages.tar.xz` is 7.4 MB (english 5.3 MB), with PGP and SHA256 sidecar files [1] | Snapshot tarball, SHA256 only [1] | **Single PHP file**: ~556 kB full, ~281 kB MySQL-only English [4]. **No published checksums or signatures** [4] | n/a |
| Tracking by `update-pins.sh` | Yes, already done: `version.json` plus the `.sha256` sidecar | Not appropriate: a moving snapshot | Possible: `gh_latest vrana/adminer`. The SHA256 would have to be computed at pin time (trust on first use) because upstream publishes none | n/a |
| Forbid passwordless login | `$cfg['Servers'][$i]['AllowNoPassword']` (default false) [6] | same | Built in: "doesn't allow connections without a password" [4] | n/a |
| Familiarity for XAMPP migrants | **Highest**: XAMPP ships it at `/phpmyadmin` | same UI | Different, minimal UI | n/a |

## When will phpMyAdmin officially support PHP 8.4+?
No date has been announced. 5.2.4 exists only as `-dev` documentation [5], and the 6.0.0 milestone is still open [7]. Even the 6.0 snapshot keeps the `<8.4` bound in the downloads table [1]. Community reports, such as a Termux issue, say that 5.2.x works on PHP 8.4 with deprecation notices [8]. That evidence is informal, not official support. Treat "official 8.4/8.5 support" as unscheduled, and smoke-test `/phpmyadmin` in CI on both PHP tags.

## Other maintained tools
- Some hosted or desktop tools exist (not researched in depth). None is a self-hostable, single-PHP drop-in that would fit a LAMP image as well as these two.
- pematon/adminer is a fork recommended by AdminerEvo [3]. Upstream Adminer is maintained again, so it adds little (not further researched).

## Recommendation
**Keep phpMyAdmin; document Adminer as a do-it-yourself alternative.**
- **Docs:** state that phpMyAdmin 5.2.x is officially supported upstream only for PHP <8.4. Say the image tests it on 8.4 and 8.5, and suppress deprecation display (`display_errors` off for that alias). Add a short "prefer Adminer?" note: download the single file into the docroot, with its URL and the warning that upstream publishes no checksum.
- **`/phpmyadmin` URL:** unchanged. The migration guide's promise holds.
- **`PHPMYADMIN` env var:** unchanged. If Adminer is ever bundled later, add a separate `ADMINER` toggle rather than overloading `PHPMYADMIN`.
- **Fallback trigger:** if phpMyAdmin breaks on PHP 8.5 in CI before upstream fixes it, ship Adminer and keep `/phpmyadmin` working, either as a redirect or by serving Adminer at that path. Document the change, and pin it by computed SHA256 in `update-pins.sh`.

## Sources
1. https://www.phpmyadmin.net/downloads/
2. https://github.com/vrana/adminer/releases
3. https://github.com/adminerevo/adminerevo
4. https://www.adminer.org/en/
5. https://docs.phpmyadmin.net/en/master/require.html and https://docs.phpmyadmin.net/en/latest/require.html
6. https://docs.phpmyadmin.net/en/latest/config.html (AllowNoPassword)
7. https://github.com/phpmyadmin/phpmyadmin/milestone/269
8. https://github.com/termux/termux-packages/issues/22746
