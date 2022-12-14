# syntax=docker/dockerfile:1
FROM archlinux:base
RUN sed -i '/NoExtract  \= usr\/share\/man/d' /etc/pacman.conf

RUN pacman -Syu --noconfirm \
        base-devel openssh zsh bind \
        man-db man-pages \
        npm neovim git tree direnv jq chezmoi \
        lua-language-server \
        rustup rust-analyzer \
        python python-lsp-server

# Setup user account to mirror host user
ARG CONTAINER_USER
ARG CONTAINER_SHELL
RUN HOME_DIR="/home/$CONTAINER_USER"; \
    useradd --no-create-home --shell "$CONTAINER_SHELL" "$CONTAINER_USER"; \
    mkdir "$HOME_DIR"; \
    chown "$CONTAINER_USER:$CONTAINER_USER" "$HOME_DIR"; \
    echo "$CONTAINER_USER            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kdevenv;

# Choose Rust toolchain
ENV RUSTUP_HOME=/opt/rust
RUN rustup default stable; \
    rustup component add rust-src;

# Install docker lua-language-server
RUN npm install -g dockerfile-language-server-nodejs
