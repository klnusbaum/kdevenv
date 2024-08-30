#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/lib.sh"

"$SCRIPT_DIR/stop.sh"
until [ "$(docker ps -f "name=^liveenv$" --format '{{.Names}}')" = "" ];
do
    sleep 0.5
done
"$SCRIPT_DIR/start.sh"
