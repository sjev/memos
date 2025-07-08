# Base image with Go pre-installed
FROM golang:1.24-bullseye

# Arguments for user configuration
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000

# Install necessary packages and create a non-root user
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    make \
    gcc \
    jq \
    sqlite3 \
    && groupadd --gid $GID $USERNAME \
    && useradd --uid $UID --gid $GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Install protocol buffer tools
RUN apt-get update && apt-get install -y protobuf-compiler \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install buf CLI for protocol buffer generation
RUN curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o /usr/local/bin/buf \
    && chmod +x /usr/local/bin/buf

# Install golangci-lint for Go linting
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v2.1.6

# Switch to non-root user
USER $USERNAME

# Configure pnpm to avoid long path issues
RUN pnpm config set store-dir /home/dev/.pnpm-store && \
    pnpm config set virtual-store-dir .pnpm

# Set environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Set working directory
WORKDIR /workspaces/memos

# Pre-download Go modules for faster startup
COPY --chown=$USERNAME:$USERNAME go.mod go.sum ./
RUN go mod download

# Pre-install Node.js dependencies for faster startup
COPY --chown=$USERNAME:$USERNAME web/package.json web/pnpm-lock.yaml ./web/
RUN cd web && pnpm install --frozen-lockfile
