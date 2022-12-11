# syntax=docker/dockerfile:1
FROM debian:bullseye
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    sudo git curl tree gettext \
    procps jq zsh man direnv
COPY ./helpers /tmp/helpers

# Setup user account to mirror host user
ARG USER
ARG UID
ARG GID
ARG CONTAINER_SHELL
RUN groupadd --gid "$GID" "$USER"; \
    useradd --no-create-home --shell "$CONTAINER_SHELL" --uid "$UID" --gid "$GID" "$USER"; \
    usermod -aG sudo "$USER";

# Install Chezmoi
RUN CHEZMOI_URL="https://github.com/twpayne/chezmoi/releases/download/v2.27.3/chezmoi-linux-amd64"; \
    CHEZMOI_BIN="/usr/local/bin/chezmoi"; \
    CHEZMOI_CHECKSUM="be853a7399ed26bc236061158d3875fa1326612349122658815578e86c01ce90"; \
    /tmp/helpers/bin_getter "$CHEZMOI_URL" "$CHEZMOI_BIN" "$CHEZMOI_CHECKSUM"; \
    chmod 755 "$CHEZMOI_BIN";

# Install NVIM
RUN NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.deb"; \
    NVIM_DEB="/tmp/nvim-linux64.deb"; \
    NVIM_CHECKSUM="5774c0d299a27a77e4e497c018cbcc9d4291c3b019ada28880d08d1f3040e779"; \
    /tmp/helpers/bin_getter "$NVIM_URL" "$NVIM_DEB" "$NVIM_CHECKSUM" ; \
    dpkg -i "$NVIM_DEB" ; \
    rm "$NVIM_DEB";

# Install lua-language-server
RUN LUA_LSP_URL="https://github.com/sumneko/lua-language-server/releases/download/3.6.4/lua-language-server-3.6.4-linux-x64.tar.gz" ; \
    LUA_LSP_TAR="/tmp/lua-lsp.tar.gz"; \
    LUA_LSP_CHECKSUM="4ba34404a20d75a867c1aef19f0f98696e138aebcadbd104bba7619107f140ab"; \
    LUA_LSP_DIR="/opt/lua-lsp"; \
    LUA_LSP_BIN="/usr/local/bin/lua-language-server"; \
    /tmp/helpers/bin_getter "$LUA_LSP_URL" "$LUA_LSP_TAR" "$LUA_LSP_CHECKSUM"; \
    mkdir "$LUA_LSP_DIR"; \
    tar xvf "$LUA_LSP_TAR" -C "$LUA_LSP_DIR"; \
    rm "$LUA_LSP_TAR"; \
    LUA_LSP_DIR="$LUA_LSP_DIR" envsubst '$LUA_LSP_DIR' < /tmp/helpers/lua-language-server.template > "$LUA_LSP_BIN"; \
    chmod 755 "$LUA_LSP_BIN";

# Cleanup helpers
RUN rm -r /tmp/helpers
