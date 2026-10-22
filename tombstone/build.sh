#!/bin/sh
# Builds tombstone images over the original tomsik68/xampp images.
#
#   tombstone/build.sh warn|fail [TAG...]
#
# Without TAGs, builds all tags in tags.txt. Each image is tagged locally as
# tomsik68/xampp:TAG. Nothing is pushed.
#
# Bases are pinned by digest (tags.txt), so a tombstone never wraps a tombstone.
# Setting ENTRYPOINT clears the inherited CMD, so each tag's original CMD is
# copied into its generated Containerfile.
set -eu

MODE=${1:?usage: build.sh warn|fail [TAG...]}
shift
case "$MODE" in warn|fail) ;; *) echo "mode must be warn or fail" >&2; exit 2 ;; esac

DIR=$(cd "$(dirname "$0")" && pwd)
ENGINE=${ENGINE:-$(command -v docker || command -v podman)}
TAGS=${*:-$(grep -v '^#' "$DIR/tags.txt" | cut -d' ' -f1)}

for tag in $TAGS; do
  digest=$(awk -v t="$tag" '$1 == t { print $2 }' "$DIR/tags.txt")
  [ -n "$digest" ] || { echo "unknown tag: $tag" >&2; exit 1; }
  base="docker.io/tomsik68/xampp@$digest"

  "$ENGINE" pull -q "$base" >/dev/null
  if [ -n "$("$ENGINE" inspect "$base" --format '{{index .Config.Labels "xampp.tombstone"}}' 2>/dev/null | grep -v '<no value>')" ]; then
    echo "$base is already a tombstone" >&2; exit 1
  fi
  cmd=$("$ENGINE" inspect "$base" --format '{{json .Config.Cmd}}')

  ctx=$(mktemp -d)
  cp "$DIR/tombstone.sh" "$ctx/"
  cat > "$ctx/Containerfile" <<EOF
FROM $base
COPY --chmod=755 tombstone.sh /usr/local/bin/xampp-tombstone
ENV TOMBSTONE_MODE=$MODE
LABEL xampp.tombstone="$MODE" org.opencontainers.image.description="DEPRECATED: use tomsik68/lamp"
ENTRYPOINT ["/usr/local/bin/xampp-tombstone"]
CMD $cmd
EOF
  "$ENGINE" build -q --format docker -t "docker.io/tomsik68/xampp:$tag" "$ctx" >/dev/null
  rm -rf "$ctx"
  echo "built tomsik68/xampp:$tag ($MODE, from ${digest%"${digest#sha256:????????????}"})"
done
