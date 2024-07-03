#!/usr/bin/env bash
set -euo pipefail

sudo chown root:docker /var/run/docker.sock
/usr/sbin/sshd -D
