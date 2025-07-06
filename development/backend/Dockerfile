FROM golang:1.24-alpine

# Install basic tools
RUN apk add --no-cache git make gcc

# Create app directory
WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Expose port
EXPOSE 8081

# Run go directly with auto-rebuild script
CMD ["sh", "-c", "while true; do go run ./bin/memos/main.go --mode dev --port 8081 || sleep 1; done"]