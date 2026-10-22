---
title: Build the xampp tombstones and draft the notices
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Task

In this repo, build the **warn-and-run** and **fail-closed** tombstone images (fail-closed exits non-zero unless `XAMPP_I_ACCEPT_THE_RISK=1` is set). Test both locally on a 5.6, a 7.4 and an 8.x tag. Draft the "DEPRECATED;" Hub short description, the README banner for Hub and GitHub, and the pinned issue, all pointing at `tomsik68/lamp` and the migration guide. **Push nothing.**

## Resolution

Built and tested locally under podman. Nothing was pushed or committed. Everything is in `tombstone/` in docker-xampp:
- `tombstone.sh`: the entrypoint. It prints the banner. In `fail` mode it exits 1 unless `XAMPP_I_ACCEPT_THE_RISK=1` is set. Otherwise it `exec`s the original command.
- `build.sh warn|fail [TAG...]`: builds each tag on top of its **original image, pinned by digest** in `tags.txt`. This means building fail-closed after warn-and-run is pushed doesn't wrap a tombstone. It copies each tag's original CMD (5.6 uses `sh /startup.sh`; later tags use `supervisord -n`) and refuses to build on top of an image that already has the `xampp.tombstone` label.
- `tags.txt`: all 18 tags and their digests, recorded 2026-10-21. The images are amd64 only.
- `NOTICES.md`: drafts of the Hub short description, the README banner and the pinned issue, with a `<T0+3mo>` placeholder.

Tested on 5.6.40, 7.4.33 and 8.2.12. Warn mode: the banner prints, the dashboard serves (302), and a custom command passes through. Fail mode: it exits 1 by default, and the opt-out serves (302).

Facts for T0 day:
- Tests needed `--userns=host --user root`, because the local `containers.conf` sets `userns = "keep-id"`. The **original** images fail under that setting too, so this isn't a tombstone regression.
- Pushing: build with `ENGINE=docker` or podman, then push the 18 local `tomsik68/xampp:TAG` tags. Building locally retags `tomsik68/xampp:*`, so don't push by accident before T0.
- The CI workflow's `paths` filter doesn't include `tombstone/`, so committing it won't trigger an xampp rebuild.
