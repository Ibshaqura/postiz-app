#!/usr/bin/env bash
# Build and roll out the wasalaa branch on the server.
#   /opt/postiz/src            git checkout of Ibshaqura/postiz-app (branch wasalaa)
#   /opt/postiz/fonts-private  thmanyah woff2 files (licence: never commit them)
#   /opt/postiz/docker-compose.yaml uses image postiz-wasalaa:latest
set -euo pipefail

SRC=/opt/postiz/src
BRANCH=${BRANCH:-wasalaa}
LOG=/opt/postiz/build.log

cd "$SRC"
git fetch -q origin "$BRANCH"
git checkout -q -B "$BRANCH" "origin/$BRANCH"
cp /opt/postiz/fonts-private/*.woff2 apps/frontend/src/fonts/thmanyah/

VERSION="$(git describe --tags --always 2>/dev/null || git rev-parse --short HEAD)-wasalaa"
start=$(date +%s)
echo "building $VERSION ..."
DOCKER_BUILDKIT=1 docker build -f Dockerfile.wasalaa \
  --build-arg NEXT_PUBLIC_VERSION="$VERSION" \
  -t postiz-wasalaa:latest . >"$LOG" 2>&1 || { tail -40 "$LOG"; exit 1; }
echo "build done in $(( $(date +%s) - start ))s"

cd /opt/postiz
docker compose up -d postiz
docker image prune -f >/dev/null
echo "deployed $VERSION"
