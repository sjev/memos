FROM golang:1.24-alpine

# Install basic tools and libc-dev for CGO
RUN apk add --no-cache git make gcc libc-dev curl

# Install buf CLI for protobuf generation
RUN curl -sSL https://github.com/bufbuild/buf/releases/latest/download/buf-Linux-x86_64 -o /usr/local/bin/buf && \
    chmod +x /usr/local/bin/buf

# Create app directory
WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Expose port
EXPOSE 8081

# Copy entrypoint script
COPY development/backend/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run without auto-restart
CMD ["/entrypoint.sh"]