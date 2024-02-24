#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/lib.sh"

"$SCRIPT_DIR/stop.sh"
docker wait "$CONTAINER_NAME" >/dev/null 2>&1 || true
"$SCRIPT_DIR/start.sh"
