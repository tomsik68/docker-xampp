---
title: T0 day: publish stable lamp and deprecate xampp
type: task
mode: HITL
status: closed
assignee: Tomas Jasek
blocked_by: [15-adminer.md, 04-beta-ci.md, 05-real-docker.md, 06-puid-bind-mounts.md, 07-auto-upgrade-test.md, 08-tombstones-and-notices.md]
---
## Task

In order, on one day:
1. Make `tomsik68/lamp` public if it is not already, and remove the own-repo exclusion from `lychee.toml`, and set `TAG_SUFFIX: ''` in `.github/workflows/scan.yml`. Then, in the repo settings, enable "Allow auto-merge" (needed by `update-pins.yml`) and private vulnerability reporting.
1. Push stable `8.x` and `latest` tags for lamp: commit `BETA: 'false'` in `.github/workflows/build.yml`.
2. Check that a fresh `docker pull` works and the migration guide URL resolves.
3. Push the warn-and-run tombstone over all 18 xampp tags.
4. Set the "DEPRECATED;" Hub description, add the README banners, open and pin the issue.
6. Check that the README shields (build, pulls, size, license) render on GitHub and on the Hub page.
5. Record the T0 date here and set the fail-closed date (T0 + 3 months) in the next ticket.

## Resolution

Done on **2026-10-22 (T0)**. Fail-closed date: **2027-01-22**, recorded in the fail-closed task.

- `tomsik68/lamp` is public, with auto-merge and private vulnerability reporting enabled. The T0 commit (`989d005`) un-excluded the repo in `lychee.toml`, set `TAG_SUFFIX: ''` and `BETA: 'false'`. The build passed and published `8.4`, `8.5`, `8` and `latest`. The README shields now use `for-the-badge` (`f6253f6`).
- Fresh pulls of `latest`, `8`, `8.4` and `8.5` work from Docker Hub and, anonymously, from GHCR. The GHCR package had to be made public by hand: package visibility doesn't follow the repo's. The migration guide URL returns 200.
- The warn-and-run tombstone was pushed over all 18 xampp tags. A fresh pull of `latest`, `7.4.33` and `5.6.40` returned the `xampp.tombstone=warn` label.
- The Hub short description is set to "DEPRECATED; …". The banner is on the GitHub README (`4e62767`) and in the Hub full description. The [pinned issue](https://github.com/tomsik68/docker-xampp/issues/74) is open; its draft was corrected to say Adminer instead of phpMyAdmin.
- The lamp shields render: build passing, pulls, size and license.
- Checks used podman (there's no docker on this machine).
