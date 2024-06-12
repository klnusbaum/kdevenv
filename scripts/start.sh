#!/usr/bin/env bash

set -euo pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"
source "$(dirname ${BASH_SOURCE})/version.sh"
HOME_DIR="/home/$CONTAINER_USER"

docker run -d --rm \
    --platform "$PLATFORM" \
    -h kdevenv \
    --name $CONTAINER_NAME \
    --volume "$HOME_VOLUME:$HOME_DIR" \
    --volume "/var/run/docker.sock:/var/run/docker.sock" \
    -p 8080:8080 \
    -p 3000:22 \
    "kdevenv:${KDEVENV_VERSION}" > /dev/null
