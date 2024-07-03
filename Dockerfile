# syntax=docker/dockerfile:1
FROM archlinux:base
RUN sed -i '/NoExtract  \= usr\/share\/man/d' /etc/pacman.conf; \
    ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# Install rust and choose Rust toolchain
ENV RUSTUP_HOME=/opt/rust
RUN pacman -Syu --noconfirm rustup rust-analyzer cargo-watch; \
    rustup default stable; \
    rustup component add rust-src; \
    rustup toolchain install nightly; \
    echo "export RUSTUP_HOME=$RUSTUP_HOME" >> /etc/profile.d/rustenv.sh

RUN pacman -Syu --noconfirm \
    base-devel openssh zsh bind neofetch wget \
    man-db man-pages \
    kitty-terminfo \
    github-cli \
    kubectl kubectx \
    go gopls \
    docker \
    inetutils \
    npm neovim git tree direnv jq chezmoi ripgrep \
    lua-language-server \
    python python-lsp-server \
    typescript typescript-language-server \
    shellcheck shfmt bash-language-server \
    tailwindcss-language-server \
    texlive-latexrecommended texlive-binextra \
    tree-sitter-cli

ARG HOST_SSH_KEY_NAME
COPY ./keys/${HOST_SSH_KEY_NAME}* /etc/ssh/

# Setup user account to mirror host user
ARG CONTAINER_USER
ARG CONTAINER_SHELL
RUN useradd -G docker --shell "$CONTAINER_SHELL" -mk /dev/null "$CONTAINER_USER"; \
    echo "$CONTAINER_USER            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kdevenv;

# Install docker languages server
# note vscode-langservers-extracted is for HTML/CSS/JSON/ESLint
RUN npm install -g \
    dockerfile-language-server-nodejs \
    vscode-langservers-extracted \
    @withgraphite/graphite-cli@stable

ARG USER_SSH_KEY_NAME
COPY --chown=$CONTAINER_USER:$CONTAINER_USER ./keys/${USER_SSH_KEY_NAME}.pub /home/$CONTAINER_USER/.ssh/authorized_keys

COPY includes/server.sh /usr/bin/server.sh

EXPOSE 22/tcp
ENTRYPOINT [ "/usr/bin/server.sh" ] 
