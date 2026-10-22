---
title: Switch xampp to the fail-closed tombstone (T0 + 3 months)
type: task
mode: HITL
status: open
assignee:
blocked_by: [09-t0-day.md]
---
## Task

On **2027-01-22** (T0 + 3 months; T0 was 2026-10-22), push the fail-closed tombstone over all 18 tags. Check that it exits non-zero, and that `XAMPP_I_ACCEPT_THE_RISK=1` still runs the old stack. Close the open issues and PRs with a pointer to `tomsik68/lamp`.

## Notes

- Docker Image CI (`.github/workflows/docker-image.yml`) was disabled on 2026-10-22. It rebuilt the old xampp image and could have overwritten the tombstones. Keep it disabled. Build the fail-closed tombstones locally with `tombstone/build.sh fail`.
