---
title: What must be done before tomsik68/lamp is published?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [12-phpmyadmin-alternatives.md]
---
## Question

Settle the complete list of things that must be true before the new `tomsik68/lamp` repository and image go public, and which of them gate the first stable tag (T0, which starts the xampp deprecation clock). Each item should be marked as either a blocker before publishing or something that can follow later.

A local scaffold already exists at `~/workset/src/lamp` (not committed). It holds the Dockerfile, the s6 init, CI workflows, docs, a smoke test, and a sample site in `examples/sample-site`. It passes the smoke test for PHP 8.4 and 8.5 on amd64 under podman. Known open items to weigh:

- **Accounts and secrets:** create the GitHub repo `tomsik68/lamp` and the Docker Hub repo, and enable GHCR. Set the `DOCKERHUB_USERNAME`/`DOCKERHUB_TOKEN` and `PINS_TOKEN` secrets, and install the Renovate app.
- **Untested paths:** arm64 builds, the GitHub Actions workflows themselves (digest merge, the reusable workflow called from `rebuild-check`, the Hub description sync), and `docker` as opposed to podman (`HEALTHCHECK` is ignored in OCI format).
- **Known risks:** phpMyAdmin 5.2.3 officially supports only PHP < 8.4. MariaDB 10.4 → 11.8 `MARIADB_AUTO_UPGRADE` is untested. The default-password banner checks the env var, not the real password. Bind mounts and `PUID`/`PGID` with real host ownership are unverified.
- **Release mechanics:** what counts as "stable" (a pre-release or beta tag first?), the initial commit and history, a CHANGELOG or GitHub release notes, whether the sample site ships in the repo, and a security policy (`SECURITY.md`).
- **xampp side at T0:** the warn-and-run tombstone image for all 18 tags, the "DEPRECATED;" Hub description, README banners and the pinned issue (see the deprecation-plan ticket). Do these land at the same moment as the lamp publish, or right after?

## Resolution

Publish in two steps: first the public repo plus CI-built beta tags (`8.4-beta`, `8.5-beta`), which start no clock; then T0, the first non-beta `8.x`/`latest` push.

**Blocks the public push / beta:**
- GitHub repo `tomsik68/lamp`, Docker Hub repo, GHCR; secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `PINS_TOKEN`; Renovate app installed.
- One squashed initial commit; `examples/sample-site` stays in the repo.
- `SECURITY.md`: report through GitHub private vulnerability reporting (enable it); only current `8.x` tags supported; fixes ship as rebuilds.

**Blocks T0 (verified during beta):**
- Real CI builds and smoke-tests amd64 and arm64, digest merge works, the `rebuild-check` reusable workflow runs, and the Hub description syncs.
- One manual `docker run` on a real Docker host (not podman).
- Bind mounts with `PUID`/`PGID` using a non-1000 host UID.
- One manual `MARIADB_AUTO_UPGRADE=1` start on a real xampp (10.4) data dir. If it fails, drop that route from the migration guide; don't fix it.
- xampp tombstone images built and tested locally on a 5.6, a 7.4 and an 8.x tag; notices drafted. Nothing pushed.

**T0 day, in order:** push stable lamp → check that a fresh `docker pull` works and the migration guide URL resolves → the same day, push the tombstones for all 18 tags, the "DEPRECATED;" Hub description, the README banner and the pinned issue. The fail-closed date is T0 + 3 months.

**Can follow after T0:** the default-password banner checks the env var rather than the real password (document what it checks; fix later). Releases use GitHub Releases with generated notes; no CHANGELOG.
