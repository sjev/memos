# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Memos** is a modern, open-source, self-hosted knowledge management and note-taking platform designed for privacy-conscious users and organizations. It provides a lightweight yet powerful solution for capturing, organizing, and sharing thoughts with comprehensive Markdown support and cross-platform accessibility.

### Key Technologies

- **Backend**: Go 1.24 with gRPC and Protocol Buffers
- **Frontend**: React 18 with TypeScript, Vite, and Tailwind CSS
- **Database**: SQLite (default), MySQL, PostgreSQL support
- **API**: RESTful HTTP/gRPC with grpc-gateway
- **Authentication**: JWT-based with OAuth2 providers

## Architecture Overview

### Backend Structure

```text
server/
├── router/
│   ├── api/v1/          # API v1 services and handlers
│   ├── frontend/        # Static frontend assets
│   └── rss/            # RSS feed generation
├── runner/             # Background job runners
└── profiler/           # Performance profiling
```

### Protocol Buffers & API

```text
proto/
├── api/v1/             # Public API definitions
│   ├── user_service.proto
│   ├── workspace_service.proto
│   ├── shortcut_service.proto
│   ├── idp_service.proto
│   └── webhook_service.proto
└── store/              # Internal data structures
    ├── workspace_setting.proto
    ├── user_setting.proto
    └── ...
```

### Data Layer

```text
store/
├── db/                 # Database drivers
│   ├── sqlite/
│   ├── mysql/
│   └── postgres/
├── migration/          # Database migrations
├── cache/              # Caching layer
└── test/               # Test utilities
```

## Recent Major Refactoring: Google AIP Compliance

### Overview

We recently completed a comprehensive refactoring to align the API with Google API Improvement Proposals (AIP) for resource-oriented API design. This involved updating protocol buffers, backend services, and frontend TypeScript code.

### Key Changes Made

#### 1. Protocol Buffer Refactoring

- **Resource Patterns**: Implemented standard resource naming (e.g., `users/{user}`, `workspace/settings/{setting}`)
- **Field Behaviors**: Added proper field annotations (`REQUIRED`, `OUTPUT_ONLY`, `IMMUTABLE`)
- **HTTP Annotations**: Updated REST mappings to follow RESTful conventions
- **Service Consolidation**: Merged `workspace_setting_service.proto` into `workspace_service.proto`

#### 2. Backend Service Updates

- **Resource Name Handling**: Added robust parsing for resource names
- **Method Signatures**: Updated to use resource names instead of raw IDs
- **Error Handling**: Improved error responses with proper gRPC status codes
- **Permission Checks**: Enhanced authorization based on user roles

#### 3. Frontend TypeScript Migration

- **Resource Name Utilities**: Helper functions for extracting IDs from resource names
- **State Management**: Updated MobX stores to use new resource formats
- **Component Updates**: React components now handle new API structures
- **Type Safety**: Enhanced TypeScript definitions for better type checking

## Common Development Commands

### Backend Development

```bash
# Build the application
go build -o ./build/memos ./bin/memos/main.go
# OR use the build script
./scripts/build.sh

# Run in development mode
go run ./bin/memos/main.go --mode dev --port 8081

# Run in production mode
go run ./bin/memos/main.go --mode prod --port 8081

# Run with custom database
go run ./bin/memos/main.go --mode dev --driver mysql --dsn "user:pass@tcp(localhost:3306)/memos"
go run ./bin/memos/main.go --mode dev --driver postgres --dsn "postgresql://user:pass@localhost/memos"

# Run with unix socket
go run ./bin/memos/main.go --mode dev --unix-sock /tmp/memos.sock
```

### Frontend Development

```bash
# Navigate to web directory and install dependencies
cd web && pnpm install

# Start development server (hot reload)
pnpm dev

# Build for production
pnpm build

# Build for release (outputs to server/router/frontend/dist)
pnpm release

# Lint TypeScript and JavaScript
pnpm lint
```

### Protocol Buffer Generation

```bash
# Generate protobuf files (requires buf CLI)
cd proto && buf generate
```

### Testing Commands

```bash
# Run all tests
go test ./...

# Run specific test packages
go test -v ./internal/util/...
go test -v ./store/test/...
go test -v ./server/router/api/v1/test/...
go test -v ./plugin/...

# Run tests with MySQL database
DRIVER=mysql DSN=root@/memos_test go test -v ./store/test/...

# Run tests with PostgreSQL database
DRIVER=postgres DSN=postgres://user:pass@localhost/memos_test go test -v ./store/test/...

# Test with coverage
go test -cover ./...
```

### Code Quality Standards

```bash
# Run linting (if configured)
golangci-lint run --timeout=3m

# Format Go code
go fmt ./...

# Frontend linting
cd web && pnpm lint
```

## Frontend Architecture

### Technology Stack

- **React 18**: Modern React with hooks and functional components
- **TypeScript**: Strict type checking for better development experience
- **Vite**: Fast build tool and development server
- **Tailwind CSS**: Utility-first CSS framework
- **MobX**: State management for reactive data flows

### Key Components

```text
web/src/
├── components/          # Reusable UI components
├── pages/              # Route-based page components
├── store/              # MobX state management
│   └── v2/             # Updated stores for AIP compliance
├── types/              # TypeScript type definitions
│   └── proto/          # Generated from Protocol Buffers
└── utils/              # Utility functions and helpers
```

## API Design Principles

### Resource-Oriented Design

Following Google AIP standards:

- **Resource Names**: Hierarchical, human-readable identifiers
- **Standard Methods**: List, Get, Create, Update, Delete patterns
- **Field Behaviors**: Clear annotations for API contracts
- **HTTP Mapping**: RESTful URL structures

### Error Handling

- **gRPC Status Codes**: Proper error classification
- **Detailed Messages**: Helpful error descriptions
- **Field Validation**: Input validation with clear feedback

### Authentication & Authorization

- **JWT Tokens**: Stateless authentication
- **Role-Based Access**: Host, User role differentiation
- **Context Propagation**: User context through request pipeline

## Database Schema

### Core Entities

- **Users**: User accounts with roles and permissions
- **Workspaces**: Workspace configuration and settings
- **Identity Providers**: OAuth2 and other auth providers
- **Webhooks**: External integration endpoints
- **Shortcuts**: User-defined quick actions

### Migration Strategy

- **Version-Controlled**: Database schema changes tracked
- **Multi-Database**: Support for SQLite, MySQL, PostgreSQL
- **Backward Compatibility**: Careful migration planning

## Deployment Options

### Docker

```dockerfile
# Multi-stage build for optimized images
FROM golang:1.24-alpine AS backend
FROM node:18-alpine AS frontend
FROM alpine:latest AS production
```

### Configuration

- **Environment Variables**: Runtime configuration
- **Profile-Based**: Development, staging, production profiles
- **Database URLs**: Flexible database connection strings

## Environment Variables

Key environment variables for configuration:

- `MEMOS_MODE`: Server mode (`dev`, `prod`, `demo`)
- `MEMOS_PORT`: Server port (default: 8081)
- `MEMOS_ADDR`: Server address (default: empty, binds to all interfaces)
- `MEMOS_UNIX_SOCK`: Unix socket path (overrides addr/port)
- `MEMOS_DRIVER`: Database driver (`sqlite`, `mysql`, `postgres`)
- `MEMOS_DSN`: Database connection string
- `MEMOS_INSTANCE_URL`: Public URL for the instance
- `MEMOS_DATA`: Data directory path

## Key Development Patterns

### Adding New API Endpoints

1. Define protobuf service in `proto/api/v1/`
2. Run `buf generate` to generate code
3. Implement service in `server/router/api/v1/`
4. Add database operations in `store/`
5. Update frontend types and components

### Database Operations

- Use store layer methods, not direct SQL queries
- All database operations support transactions
- Multi-database support (SQLite, MySQL, PostgreSQL)
- Caching is handled automatically for frequently accessed data

### Frontend Component Development

- Components are organized in `web/src/components/`
- Use TypeScript with strict typing
- Follow existing patterns for API calls using generated gRPC clients
- Use MobX for global state management
- Use consistent styling with Tailwind CSS

## Common Issues and Solutions

### Port Conflicts
- Default port 8081 may conflict with other services
- Use `--port` flag or `MEMOS_PORT` environment variable to change

### Database Permissions
- Ensure proper permissions for SQLite database files
- Verify network access for MySQL/PostgreSQL connections
- Check DSN format for database connections

### Protocol Buffer Compilation
- Requires `buf` CLI tool for code generation
- Run `buf generate` from `proto/` directory after proto changes

### Frontend Development
- Use `pnpm` instead of `npm` for package management
- Frontend dev server runs on port 3000 by default
- Backend API is proxied during development

## Contributing Guidelines

### Code Standards

1. **Protocol Buffers**: Follow AIP guidelines for new services
2. **Go Code**: Use `golangci-lint` configuration and `go fmt`
3. **TypeScript**: Strict mode with comprehensive type checking
4. **Testing**: Write tests for new features using existing test patterns

### Pull Request Process

1. **Lint Checking**: All linters must pass
2. **Test Coverage**: New code should include tests
3. **Documentation**: Update relevant documentation
4. **AIP Compliance**: New APIs should follow [AIP](https://google.aip.dev/) standards
