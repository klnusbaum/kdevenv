#!/usr/bin/env bash
set -euo pipefail

socat UNIX-CONNECT:/var/run/host_docker.sock UNIX-LISTEN:/var/run/docker.sock,user=root,group=docker,mode=660 &
/usr/sbin/sshd -D
