#!/bin/sh
# Entrypoint of the tomsik68/xampp tombstone images. Prints the deprecation
# banner, then either runs the original command (warn) or refuses to (fail).

MIGRATION_URL="https://github.com/tomsik68/lamp/blob/main/docs/migrating-from-xampp.md"

banner() {
  cat >&2 <<EOF
################################################################################
#                                                                              #
#   tomsik68/xampp is DEPRECATED and no longer receives security updates.      #
#   Its PHP, MariaDB and Apache versions have known vulnerabilities.           #
#                                                                              #
#   Successor: tomsik68/lamp (supported PHP versions, rebuilt for CVEs)        #
#   Migration guide:                                                           #
#   $MIGRATION_URL
#                                                                              #
################################################################################
EOF
}

banner

if [ "$TOMBSTONE_MODE" = "fail" ] && [ "$XAMPP_I_ACCEPT_THE_RISK" != "1" ]; then
  cat >&2 <<EOF

This image no longer starts by default. Migrate to tomsik68/lamp, or, if you
understand the risk, start it anyway with:

  docker run -e XAMPP_I_ACCEPT_THE_RISK=1 ...

EOF
  exit 1
fi

exec "$@"
