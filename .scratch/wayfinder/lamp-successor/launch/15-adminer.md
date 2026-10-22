---
title: Replace phpMyAdmin with Adminer in lamp
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Task

Carry out the [Adminer decision](../tickets/13-reconsider-phpmyadmin.md) in `tomsik68/lamp`:

- Remove phpMyAdmin, its composer patch step, and its pins.
- Install the pinned MySQL-only Adminer build and the login-defaults plugin, served at `/adminer`, with a 302 from `/phpmyadmin` and `/phpmyadmin/*`, all behind `ADMINER=0`.
- In `update-pins.sh`, pin Adminer and the plugin by version and sha256. Configure Renovate so these bumps are never automerged, and stop `update-pins.yml` from running `gh pr merge --auto` on Adminer bumps.
- Change the smoke test to do a real Adminer login against MariaDB and to check the redirect.
- Update the README, `docs/configuration.md`, `docs/extending.md` (plugin DIY section) and the migration guide.
- CI (build, lint, Trivy) is green on the 8.4 and 8.5 beta tags.

This must be done before [T0 day](09-t0-day.md).

## Progress (2026-10-22)

Done locally in `~/workset/src/lamp` (uncommitted). The smoke test passes for 8.4 and 8.5 under podman, and `ADMINER=0` returns 404 on both `/adminer/` and `/phpmyadmin/`.

- **Deviation from the decision:** Adminer is now 6.1.2, and there is no official `login-defaults` plugin in any release. Instead, a 10-line plugin of our own, `rootfs/usr/share/adminer/adminer-plugins/lamp-login.php`, pre-fills `root`. An empty server field means localhost. Adminer 5+ auto-loads `adminer-plugins/*.php`. The plugin lives in the repo, so there is nothing to pin. Only `adminer-X-mysql.php` is pinned, with its sha256.
- **Renovate:** these pins are not Renovate-managed (the dockerfile manager is disabled, and there are no regex managers). So no Renovate rule is needed. `update-pins.yml` now skips `gh pr merge --auto` whenever the `ARG ADMINER_*` lines change.
- **Smoke test:** reads the CSRF token, logs in as root/root, checks that `information_schema` is listed, and checks that `/phpmyadmin/index.php` returns a 302 to `/adminer/`.
- **Local podman note:** with `userns = "keep-id"` in `containers.conf`, run with `RUN_FLAGS='--userns=host --user 0:0'`.

Remaining: commit and push, then confirm that CI (build, lint, Trivy) is green on the beta tags.

## Resolution

Pushed as `5a94c86` to `tomsik68/lamp` main. CI is green: build (amd64+arm64, smoke test on 8.4 and 8.5, beta tags), lint, shellcheck and the Trivy scan.
