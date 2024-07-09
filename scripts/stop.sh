#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
docker stop $CONTAINER_NAME >/dev/null
