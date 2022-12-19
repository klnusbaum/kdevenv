# syntax=docker/dockerfile:1
FROM archlinux
RUN pacman -Syu --noconfirm \
        sudo openssh zsh man \
        npm neovim git tree direnv jq lua-language-server rustup chezmoi

# Setup user account to mirror host user
ARG CONTAINER_USER
ARG CONTAINER_SHELL
RUN HOME_DIR="/home/$CONTAINER_USER"; \
    useradd --no-create-home --shell "$CONTAINER_SHELL" "$CONTAINER_USER"; \
    mkdir "$HOME_DIR"; \
    chown "$CONTAINER_USER:$CONTAINER_USER" "$HOME_DIR"; \
    echo "$CONTAINER_USER            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kdevenv;

# Choose Rust toolchain
RUN rustup default stable

# Install docker lua-language-server
RUN npm install -g dockerfile-language-server-nodejs
