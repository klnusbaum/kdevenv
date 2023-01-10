#!/usr/bin/env bash 
set euo -pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"
source "$(dirname ${BASH_SOURCE})/version.sh"

if [ -z "$(docker volume ls --filter name=$HOME_VOLUME --format {{.Name}})" ];
then
    docker volume create $HOME_VOLUME &> /dev/null
fi

FIVE_DAYS_AGO=$(date --date="5 days ago" "+%Y-%m-%d")
ARCH_CREATED_AT=$(docker images  --format "{{ .CreatedAt }}" archlinux:base | awk '{print $1}')

FIVE_DAYS_AGO_UNIX=$(date -d $FIVE_DAYS_AGO +%s)
ARCH_CREATED_AT_UNIX=$(date -d $ARCH_CREATED_AT +%s)

if [ $FIVE_DAYS_AGO_UNIX -ge $ARCH_CREATED_AT_UNIX ]; then
    docker pull archlinux:base
fi

docker build \
    --build-arg CONTAINER_USER="$CONTAINER_USER" \
    --build-arg CONTAINER_SHELL="$CONTAINER_SHELL" \
    -t "kdevenv:${KDEVENV_VERSION}" .
