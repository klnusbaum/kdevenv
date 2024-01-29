# syntax=docker/dockerfile:1
FROM archlinux:base
RUN sed -i '/NoExtract  \= usr\/share\/man/d' /etc/pacman.conf

# Install rust and choose Rust toolchain
ENV RUSTUP_HOME=/opt/rust
RUN pacman -Syu --noconfirm rustup rust-analyzer; \
    rustup default stable; \
    rustup component add rust-src; \
    rustup toolchain install nightly;

RUN pacman -Syu --noconfirm \
        base-devel openssh zsh bind neofetch \
        man-db man-pages \
        kitty-terminfo \
        docker \
        npm neovim git tree direnv jq chezmoi ripgrep \
        lua-language-server \
        python python-lsp-server \
        typescript-language-server

ARG HOST_SSH_KEY_NAME
COPY ./keys/${HOST_SSH_KEY_NAME}* /etc/ssh/

ARG DOCKER_GROUP_ID
RUN groupmod -g "$DOCKER_GROUP_ID" docker

# Setup user account to mirror host user
ARG CONTAINER_USER
ARG CONTAINER_SHELL
RUN useradd -G docker --shell "$CONTAINER_SHELL" -mk /dev/null "$CONTAINER_USER"; \
    echo "$CONTAINER_USER            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kdevenv;

# Install docker languages server
RUN npm install -g dockerfile-language-server-nodejs typescript-language-server typescript

ARG USER_SSH_KEY_NAME
COPY --chown=$CONTAINER_USER:$CONTAINER_USER ./keys/${USER_SSH_KEY_NAME}.pub /home/$CONTAINER_USER/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
