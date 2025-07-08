FROM golang:1.24-alpine

# Install basic tools and libc-dev for CGO
RUN apk add --no-cache git make gcc libc-dev

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