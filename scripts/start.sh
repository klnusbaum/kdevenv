#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$(dirname "${BASH_SOURCE[0]}")/version.sh"
HOME_DIR="/home/$CONTAINER_USER"

docker run -d --rm \
    --platform "$PLATFORM" \
    -h kdevenv \
    --name $CONTAINER_NAME \
    --volume "$HOME_VOLUME:$HOME_DIR" \
    --volume "/var/run/docker.sock:/var/run/host_docker.sock" \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 3000:3000 \
    -p 2222:22 \
    "kdevenv:${KDEVENV_VERSION}" >/dev/null
