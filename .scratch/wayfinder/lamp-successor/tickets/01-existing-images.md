---
title: Does an existing maintained single-container LAMP image fit?
type: wayfinder:research
status: closed
assignee:
blocked_by: []
---
## Question

Survey existing single-container LAMP/PHP+MySQL images and tools (e.g. mattrayner/lamp, bitnami, webdevops, linuxserver, serversideup, DDEV/Lando as a contrast). For each: is it actively maintained, does it track official/upstream PHP security releases with automatic rebuilds, does it ship only supported PHP branches, does it run Apache+PHP+MySQL/MariaDB (+phpMyAdmin?) in **one container via a single `docker run`**, what is its license, and does it support multi-arch? Conclude with: does any fit, and which is the best candidate?

## Resolution

No existing image fits. The all-in-one images (mattrayner/lamp, fauria/lamp) are unmaintained, run EOL PHP and have no CI rebuilds. The maintained ones (serversideup/php, webdevops/php-apache) have no database. bitnami/lamp is gone, and DDEV/Lando need multiple containers plus their own CLI. Recommendation: build our own on official `php:*-apache` with MariaDB under supervisord, borrowing serversideup's and webdevops' CI and tag patterns. Caveats: the arch claim for webdevops is unverified, and a wider search might find small single-maintainer images.

Findings: branch `research/existing-images` (commit fef0e51), file `research/existing-images.md`.
