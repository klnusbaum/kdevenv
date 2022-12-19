#!/usr/bin/env bash 
set euo -pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"

if [ -z "$(docker volume ls --filter name=$HOME_VOLUME --format {{.Name}})" ];
then
    docker volume create $HOME_VOLUME &> /dev/null
fi
echo "BUILDING WITH USER: $CONTAINER_USER"

docker build \
    --build-arg CONTAINER_USER="$CONTAINER_USER" \
    --build-arg CONTAINER_SHELL="$CONTAINER_SHELL" \
    -t kdevenv:1.0 .
