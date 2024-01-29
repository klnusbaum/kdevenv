#!/usr/bin/env bash 
set euo -pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"
source "$(dirname ${BASH_SOURCE})/version.sh"
readonly KEYS_DIR="$(dirname ${BASH_SOURCE})/keys"

if [ -z "$(docker volume ls --filter name=$HOME_VOLUME --format {{.Name}})" ];
then
    docker volume create $HOME_VOLUME &> /dev/null
fi

if [ ! -d "$KEYS_DIR" ]; then
    mkdir "$KEYS_DIR"
fi

if [ ! -f $KEYS_DIR/$USER_SSH_KEY_NAME.pub ]; then
    ssh-keygen -t ed25519 -f "$KEYS_DIR/$USER_KEY_NAME" -N "" -C "$CONTAINER_USER@kdevenv"
fi

if [ ! -f $KEYS_DIR/$HOST_SSH_KEY_NAME.pub ]; then
    ssh-keygen -t ed25519 -f "$KEYS_DIR/$HOST_SSH_KEY_NAME" -N "" -C "root@kdevenv"
fi

# new arch image builds are done every 7 days.
# so we should wait at most 7 days before refreshing out docker image.
SEVEN_DAYS_AGO=$(date --date="7 days ago" "+%Y-%m-%d")
ARCH_CREATED_AT=$(docker images  --format "{{ .CreatedAt }}" archlinux:base | awk '{print $1}')

SEVEN_DAYS_AGO_UNIX=$(date -d $SEVEN_DAYS_AGO +%s)
ARCH_CREATED_AT_UNIX=$(date -d $ARCH_CREATED_AT +%s)

if [ $SEVEN_DAYS_AGO_UNIX -ge $ARCH_CREATED_AT_UNIX ]; then
    docker pull archlinux:base
fi

DOCKER_GROUP_ID="$(getent group docker | cut -d: -f3)"

docker build \
    --build-arg CONTAINER_USER="$CONTAINER_USER" \
    --build-arg CONTAINER_SHELL="$CONTAINER_SHELL" \
    --build-arg DOCKER_GROUP_ID="$DOCKER_GROUP_ID" \
    --build-arg HOST_SSH_KEY_NAME="$HOST_SSH_KEY_NAME" \
    --build-arg USER_SSH_KEY_NAME="$USER_SSH_KEY_NAME" \
    -t "kdevenv:${KDEVENV_VERSION}" .
