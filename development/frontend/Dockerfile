FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

# Create app directory
WORKDIR /app

# Copy package files first for better caching
COPY web/package.json web/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copy source code
COPY web/ ./

# Expose port
EXPOSE 3000

# Start dev server
CMD ["pnpm", "dev", "--host", "0.0.0.0"]