---
title: Add more lint and check workflows to lamp CI
type: task
mode: AFK
status: closed
assignee: Tomas Jasek
blocked_by: []
---
## Task

Add CI workflows to `tomsik68/lamp` that run alongside `build` and `shellcheck` on pushes to `main` and on PRs. Candidates (confirm the set before building):

- **actionlint**: lint the workflow files themselves. It catches expression and syntax errors that today only show up when a run starts.
- **hadolint**: lint the `Dockerfile`.
- **Markdown link check**: the README, `docs/` and the migration guide are linked from the xampp notices, so broken links there hurt.
- **Image vulnerability scan** (e.g. Trivy) on the beta images, reported to GitHub code scanning. The security promise of the successor is CVE remediation, so this makes that visible.

Pin each tool to a version (as ShellCheck is pinned to `v0.10.0`) so Renovate can bump it. Fix or explicitly suppress, with a reason, anything the new checks flag, so they start green.

## Progress

The user asked for all the candidates, plus a file name check and a binary file check.

- [x] `lint.yml` (commit a701bbf), green: actionlint 1.7.12, hadolint v2.15.1, lychee 0.24.2, `scripts/check-filenames.sh`, `scripts/check-no-binaries.sh` (exceptions go in `.binary-allowlist`)
- Fixed: `ls | grep` in `build.yml`; the Dockerfile now uses a bash `SHELL` with `pipefail`
- Suppressed, with reasons: DL3008 (unpinned apt packages, deliberate) and DL3064 (root/root default) in `.hadolint.yaml`; DL3025 on HEALTHCHECK and SC2086 on `$buildDeps` inline
- `lychee.toml` excludes `github.com/tomsik68/lamp/` while the repo is private. **Remove that on T0 day.**
- [x] Trivy (commit 30cbefb), `scan.yml`: scans the published `X.Y-beta` images after each build and daily, and fails on fixable HIGH/CRITICAL findings. Green.

## Resolution

Done. All five checks run in `lint.yml`, and the vulnerability scan is in `scan.yml`; everything is green.

The first scan found that phpMyAdmin 5.2.3 (the latest release) vendors twig (6 CRITICAL) and symfony/cache (4 HIGH). **The user chose to patch them**: the Dockerfile updates both with composer at build time, staying within their majors (twig 3.30.0, symfony/cache 5.4.54). This amends the phpMyAdmin decision: we keep phpMyAdmin, and we patch its libraries rather than wait for upstream.

Verifying that patch exposed a bug already in the published beta: PHP had no `mysqli`/`pdo_mysql` default socket, so `localhost` connections failed, including phpMyAdmin's login. It's fixed in `90-lamp.ini`. The smoke test now covers socket connections and a real phpMyAdmin login (it fails on the old build and passes on the new one).
