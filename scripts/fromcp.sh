#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

docker cp "liveenv:/home/$CONTAINER_USER/$1" "$1"
