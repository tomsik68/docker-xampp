---
title: What are the tag scheme and rebuild policy?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [06-stack-composition.md]
---
## Question

Which PHP branches get tags (upstream-supported only), tag naming (e.g. `8.3`, `8.3-apache`, `latest`), when a branch is dropped, rebuild cadence and triggers for CVE remediation (scheduled + upstream base updates), CI platform, and multi-arch (amd64/arm64).

Input from the stack-composition ticket: both `trixie` and `bookworm` variants are built. Decide which is unsuffixed/default, and a drop rule for a Debian variant (proposed: when upstream `php` stops publishing it or Debian LTS ends, whichever is first; bookworm regular security support already ended June 2026, LTS to ~June 2028).
- s6-overlay is not an apt package: the rebuild policy must also track its releases (e.g. Renovate/Dependabot bumping a pinned version + checksum).
- phpMyAdmin is a pinned upstream tarball too: track its releases alongside s6-overlay.

## Resolution

- **PHP branches:** launch with **8.4 and 8.5** only. A branch is added once the official `php` image publishes GA tags (no betas/RCs), and rebuilds stop on upstream EOL; its tags stay on the Hub, frozen and marked unsupported in the README.
- **Debian:** **trixie only** — bookworm dropped (revises the stack-composition decision). Forky gets evaluated when upstream `php` publishes it.
- **Tags:** moving `8.5`, `8.4`, `8`, `latest` (newest supported branch); `-trixie` aliases of each (`8.5-trixie`, …) to allow pinning ahead of forky; patch tags `8.5.X` / `8.5.X-trixie`, still rebuilt for OS CVEs until superseded. No `-apache` suffix. `latest` moves to a new branch as soon as it's added.
- **CI:** GitHub Actions in `tomsik68/lamp`; one `docker buildx` push per tag to Docker Hub and GHCR.
- **Arch:** `linux/amd64` + `linux/arm64`, built on native arm64 runners (no QEMU).
- **Rebuild triggers:** a **daily** check that rebuilds a tag **only when something changed** — base image (`php:X.Y-apache-trixie`) digest moved, or upgradable Debian packages exist in the built image. Plus Renovate PRs bumping pinned s6-overlay, phpMyAdmin and composer (version + checksum), auto-merged when green; plus manual `workflow_dispatch` for urgent CVEs. No blind weekly/no-cache rebuilds, so digests only change when content does.
- **Gate:** smoke test before any push — container starts, Apache serves PHP, MariaDB accepts connections, phpMyAdmin loads. Failure blocks the push.
