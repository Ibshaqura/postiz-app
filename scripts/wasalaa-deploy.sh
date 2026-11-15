#!/usr/bin/env bash
# Build and roll out the wasalaa branch on the server.
#   /opt/postiz/src             git checkout of Ibshaqura/postiz-app (branch wasalaa)
#   /opt/postiz/fonts-private   thmanyah woff2 files (licence: never commit them)
#   /opt/postiz/docker-compose.yaml uses image postiz-wasalaa:latest
#
# Two images:
#   postiz-wasalaa-deps:<hash>  system packages + node_modules, rebuilt only
#                               when the dependency files below change
#   postiz-wasalaa:latest       the app, rebuilt on every deploy (fast)
set -euo pipefail

SRC=/opt/postiz/src
BRANCH=${BRANCH:-wasalaa}
LOG=/opt/postiz/build.log
export DOCKER_BUILDKIT=1

cd "$SRC"
git fetch -q origin "$BRANCH"
git checkout -q -B "$BRANCH" "origin/$BRANCH"
cp /opt/postiz/fonts-private/*.woff2 apps/frontend/src/fonts/thmanyah/

DEPS_HASH=$(cat pnpm-lock.yaml pnpm-workspace.yaml .npmrc Dockerfile.wasalaa-deps \
  $(git ls-files '*package.json' | sort) | sha256sum | cut -c1-12)
DEPS_IMAGE="postiz-wasalaa-deps:$DEPS_HASH"
VERSION="$(git rev-parse --short HEAD)-wasalaa"
: >"$LOG"
start=$(date +%s)

if ! docker image inspect "$DEPS_IMAGE" >/dev/null 2>&1; then
  echo "dependencies changed -> building $DEPS_IMAGE (slow, once) ..."
  docker build --provenance=false -f Dockerfile.wasalaa-deps -t "$DEPS_IMAGE" . >>"$LOG" 2>&1 \
    || { tail -40 "$LOG"; exit 1; }
  echo "deps image done in $(( $(date +%s) - start ))s"
fi

echo "building app $VERSION ..."
app_start=$(date +%s)
docker build --provenance=false -f Dockerfile.wasalaa \
  --build-arg DEPS_IMAGE="$DEPS_IMAGE" \
  --build-arg NEXT_PUBLIC_VERSION="$VERSION" \
  -t postiz-wasalaa:latest . >>"$LOG" 2>&1 || { tail -40 "$LOG"; exit 1; }
echo "app build done in $(( $(date +%s) - app_start ))s"

cd /opt/postiz
docker compose up -d postiz
# drop dangling images and deps images other than the current one
docker image prune -f >/dev/null
docker image ls postiz-wasalaa-deps --format '{{.Repository}}:{{.Tag}}' \
  | grep -v ":$DEPS_HASH\$" | xargs -r docker rmi >/dev/null 2>&1 || true
echo "deployed $VERSION in $(( $(date +%s) - start ))s total"
