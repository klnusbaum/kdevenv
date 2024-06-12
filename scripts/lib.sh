export CONTAINER_SHELL=/bin/zsh
export CONTAINER_USER="kurtis"
export CONTAINER_NAME="liveenv"
export HOME_VOLUME="devhome"
export USER_SSH_KEY_NAME="dev_ed25519"
export HOST_SSH_KEY_NAME="ssh_host_ed25519_key"
# Archlinux only supports amd64 so there are a number of places we need to explicitly specify it.
export PLATFORM="linux/amd64"
