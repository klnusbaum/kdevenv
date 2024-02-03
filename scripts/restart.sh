#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(dirname ${BASH_SOURCE})"

$SCRIPT_DIR/stop.sh
$SCRIPT_DIR/start.sh
