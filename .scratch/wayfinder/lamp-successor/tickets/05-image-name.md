---
title: What is the successor image called and where does it live?
type: wayfinder:grilling
status: closed
assignee: Tomas Jasek
blocked_by: [03-adopt-or-build.md]
---
## Question

Name and home of the new image: Docker Hub namespace/repo (e.g. `tomsik68/lamp`), GitHub repo (new repo vs. reuse this one), and whether it's also published to GHCR.

## Resolution

- **Image:** `tomsik68/lamp` on Docker Hub. This is the name the docs use.
- **Mirror:** `ghcr.io/tomsik68/lamp`, pushed by the same CI build using `GITHUB_TOKEN`.
- **Source:** a new GitHub repo, `github.com/tomsik68/lamp`. The current `tomsik68/docker-xampp` repo will be archived.
- **Rejected:** reusing `tomsik68/xampp` for the new image. Every tag is still pulled, so existing users would silently switch to a different stack. Staying truly compatible would mean keeping SSH, root/root and the `/opt/lampp` layout, all of which we're dropping. Compatibility comes from path shims and a migration guide instead (see the config-and-volumes ticket).
