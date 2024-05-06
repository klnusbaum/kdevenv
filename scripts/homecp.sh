#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

docker cp "$1" "liveenv:/home/$CONTAINER_USER"
