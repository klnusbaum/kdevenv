#!/usr/bin/env bash 
DOCKER_BUILDKIT=1 docker build \
    --build-arg USER="$USER" \
    --build-arg UID="$UID" \
    --build-arg GID="$(id -g)" \
    -t kdevenv:1.0 .
