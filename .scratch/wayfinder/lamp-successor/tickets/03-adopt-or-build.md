---
title: Recommend an existing image or build our own?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [01-existing-images.md]
---
## Question

Given the survey of existing images, do we point users to one of them as the successor, or build a new image under `tomsik68/`? If we point to one, which, and what gaps (if any) do we accept?

## Resolution

Build our own. No existing image is both maintained and single-container with a database, and the bundled DB in one `docker run` is non-negotiable — pointing users at a DB-less image plus a separate MariaDB breaks the audience promise. Accepted cost: we own ongoing rebuilds/CVE tracking. Builds on the research lean (official `php:*-apache` + distro MariaDB under supervisord), detailed in follow-up tickets.
