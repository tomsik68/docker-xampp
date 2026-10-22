# Deprecation notices

Published on T0 (2026-10-22). The fail-closed date is 2027-01-22 (T0 + 3 months).

## Docker Hub short description (max 100 characters)

```
DEPRECATED; use tomsik68/lamp. Unpatched PHP/MariaDB. Stops starting by default on 2027-01-22.
```

## README banner (top of the GitHub README and the Docker Hub full description)

```markdown
> [!WARNING]
> **This image is deprecated and no longer receives security updates.** Its PHP, MariaDB and Apache versions have known vulnerabilities.
>
> Use **[tomsik68/lamp](https://hub.docker.com/r/tomsik68/lamp)** instead: one `docker run`, supported PHP versions only, rebuilt automatically for CVEs. Follow the **[migration guide](https://github.com/tomsik68/lamp/blob/main/docs/migrating-from-xampp.md)**.
>
> **Timeline:** no tags are deleted. Since T0, every tag prints a deprecation banner on startup. From **2027-01-22**, every tag will refuse to start unless you set `-e XAMPP_I_ACCEPT_THE_RISK=1`. Shortly after that, this repository will be archived.
```

## Pinned GitHub issue

**Title:** tomsik68/xampp is deprecated: migrate to tomsik68/lamp

```markdown
`tomsik68/xampp` is deprecated. XAMPP for Linux ships a bundled PHP, MariaDB and Apache that this image can't patch, and several of the tags run PHP versions that reached end of life years ago.

**The successor is [tomsik68/lamp](https://github.com/tomsik68/lamp).** It's still a single `docker run` with Apache, PHP, MariaDB and Adminer. It ships only upstream-supported PHP versions and is rebuilt automatically when security fixes land.

**How to migrate:** see the [migration guide](https://github.com/tomsik68/lamp/blob/main/docs/migrating-from-xampp.md). In short: ports 80 and 3306 and the root/root login stay the same. SSH, the XAMPP dashboard and the `/opt/lampp` paths are gone. Move your database with a dump and restore.

**What happens to this image:**

| When | What changes |
|---|---|
| Now | Every tag prints a deprecation banner on startup and otherwise works as before. |
| 2027-01-22 | Every tag refuses to start unless you set `-e XAMPP_I_ACCEPT_THE_RISK=1`. |
| About a week later | The Docker Hub and GitHub repositories are archived (read-only, still pullable). |

No tags will be deleted. Questions about migrating are welcome here.
```
