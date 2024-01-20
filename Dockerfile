# syntax=docker/dockerfile:1
FROM archlinux:base
RUN sed -i '/NoExtract  \= usr\/share\/man/d' /etc/pacman.conf

RUN pacman -Syu --noconfirm \
        base-devel openssh zsh bind neofetch \
        man-db man-pages \
        docker \
        npm neovim git tree direnv jq chezmoi ripgrep \
        lua-language-server \
        rustup rust-analyzer \
        python python-lsp-server \
        typescript-language-server

ARG DOCKER_GROUP_ID
RUN groupmod -g "$DOCKER_GROUP_ID" docker

# Setup user account to mirror host user
ARG CONTAINER_USER
ARG CONTAINER_SHELL
RUN HOME_DIR="/home/$CONTAINER_USER"; \
    useradd -G docker --shell "$CONTAINER_SHELL" -mk /dev/null "$CONTAINER_USER"; \
    echo "$CONTAINER_USER            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kdevenv;

# Choose Rust toolchain
ENV RUSTUP_HOME=/opt/rust
RUN rustup default stable; \
    rustup component add rust-src; \
    rustup toolchain install nightly;

# Install docker languages server
RUN npm install -g dockerfile-language-server-nodejs typescript-language-server typescript
