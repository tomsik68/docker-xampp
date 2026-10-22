---
title: Add shields to the lamp README
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: [04-beta-ci.md]
---
## Task

Add shields.io badges to the top of the `tomsik68/lamp` README: CI build status, Docker Hub pulls, image size, and the license. The README doubles as the Hub description, so check that the badges render there too. This waits on the beta CI ticket, because the CI and Hub badges only work once the workflow and the Hub repo exist (the Hub pull badge also needs the repo to be public).

## Resolution

Four badges are now under the README title: build status (`build.yml` on `main`), Docker Hub pulls, image size of `latest`, and the license. They were pushed to `tomsik68/lamp` `main` as commit 53514e5. As of 2026-10-22, only the pulls badge renders (it shows 820). The build and license badges say "repo not found" while the repo is private, and image size says "tag not found" until `latest` exists. All of them should work once T0 day has run, so checking that they render on GitHub and on Hub has moved to step 6 of the T0 ticket.
