#!/usr/bin/env bash 
set euo -pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"
source "$(dirname ${BASH_SOURCE})/version.sh"

if [ -z "$(docker volume ls --filter name=$HOME_VOLUME --format {{.Name}})" ];
then
    docker volume create $HOME_VOLUME &> /dev/null
fi

# new arch image builds are done every 7 days.
# so we should wait at most 7 days before refreshing out docker image.
SEVEN_DAYS_AGO=$(date --date="7 days ago" "+%Y-%m-%d")
ARCH_CREATED_AT=$(docker images  --format "{{ .CreatedAt }}" archlinux:base | awk '{print $1}')

SEVEN_DAYS_AGO_UNIX=$(date -d $SEVEN_DAYS_AGO +%s)
ARCH_CREATED_AT_UNIX=$(date -d $ARCH_CREATED_AT +%s)

if [ $EIGHT_DAYS_AGO_UNIX -ge $ARCH_CREATED_AT_UNIX ]; then
    docker pull archlinux:base
fi

docker build \
    --build-arg CONTAINER_USER="$CONTAINER_USER" \
    --build-arg CONTAINER_SHELL="$CONTAINER_SHELL" \
    -t "kdevenv:${KDEVENV_VERSION}" .
