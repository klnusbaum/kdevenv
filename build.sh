#!/usr/bin/env bash 
set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/scripts"
source "$SCRIPT_DIR/lib.sh"
source "$SCRIPT_DIR/version.sh"
KEYS_DIR="$(dirname "${BASH_SOURCE[0]}")/keys"

seven_days_ago () {
    if [[ $OSTYPE == 'darwin'* ]]; then
        date -v-7d +%s
    else
        date -d "7 days ago" +%s
    fi
}

format_docker_date() {
    if [[ "$1" == '' ]]; then
        echo "0"
    elif [[ $OSTYPE == 'darwin'* ]]; then
        date -f "%Y-%m-%d %H:%M:%S %z %Z" -j "$1" +%s
    else
        date -d "$1" +%s
    fi
}

if [ -z "$(docker volume ls --filter name="$HOME_VOLUME" --format "{{.Name}}")" ];
then
    docker volume create "$HOME_VOLUME" &> /dev/null
fi

if [ ! -d "$KEYS_DIR" ]; then
    mkdir "$KEYS_DIR"
fi

if [ ! -f "$KEYS_DIR/$USER_SSH_KEY_NAME.pub" ]; then
    ssh-keygen -t ed25519 -f "$KEYS_DIR/$USER_SSH_KEY_NAME" -N "" -C "$CONTAINER_USER@kdevenv"
fi

if [ ! -f "$KEYS_DIR/$HOST_SSH_KEY_NAME.pub" ]; then
    ssh-keygen -t ed25519 -f "$KEYS_DIR/$HOST_SSH_KEY_NAME" -N "" -C "root@kdevenv"
fi

# new arch image builds are done every 7 days.
# so we should wait at most 7 days before refreshing out docker image.
ARCH_CREATED_AT=$(docker images  --format "{{ .CreatedAt }}" archlinux:base | awk '{print $1}')
ARCH_CREATED_AT_UNIX=$(format_docker_date "$ARCH_CREATED_AT")
if [ "$(seven_days_ago)" -ge "$ARCH_CREATED_AT_UNIX" ]; then
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
