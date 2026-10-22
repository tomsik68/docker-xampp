---
title: Publish beta tags and verify CI
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: [03-initial-push.md]
---
## Task

Let CI publish `8.4-beta` and `8.5-beta`. Verify: amd64 and arm64 both build and pass the smoke test, the digest merge works, the reusable workflow called from `rebuild-check` runs, and the Docker Hub description syncs. Fix whatever breaks. Beta tags start no clock.

## Progress

- [x] amd64 and arm64 build and pass the smoke test for 8.4 and 8.5 (run 39682006965)
- [x] Digest merge works: `8.4-beta` and `8.5-beta` are on Docker Hub for amd64 and arm64. Added a `BETA` switch to `build.yml` (flipped on T0 day).
- [x] Hub description sync works once `DOCKERHUB_TOKEN` has the Read, Write, Delete scope (the user re-issued it)
- [x] `rebuild-check` works (run 39688349134). Before T0 it checks the `-beta` tag when the plain tag is missing. A new `force` input on manual runs rebuilds every branch, which exercised the reusable `build.yml` call: all 4 builds and both publishes passed.
- [x] Added a ShellCheck workflow, which passes

## Resolution

Done. Beta tags `8.4-beta` and `8.5-beta` are published for amd64 and arm64 to Docker Hub and GHCR, the Hub description syncs, and the daily `rebuild-check` workflow is verified end to end. On a no-change day it correctly skips (run 39688232125).
