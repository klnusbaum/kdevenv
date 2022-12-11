#!/usr/bin/env bash 
source "$(dirname ${BASH_SOURCE})/lib.sh"

DOCKER_BUILDKIT=1 docker build \
    --build-arg USER="$USER" \
    --build-arg UID="$UID" \
    --build-arg GID="$(id -g)" \
    --build-arg CONTAINER_SHELL="$CONTAINER_SHELL" \
    -t kdevenv:1.0 .
