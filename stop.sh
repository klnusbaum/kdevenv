#!/usr/bin/env bash

set -euo pipefail

source "$(dirname ${BASH_SOURCE})/lib.sh"
docker stop $CONTAINER_NAME > /dev/null
