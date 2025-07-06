# Memos Development Environment

A Docker Compose-based development environment for Memos that provides:

- **Hot reload** for frontend (React) and manual restart for backend (Go)
- **Pre-populated database** with sample data
- **Service isolation** for better development experience
- **Tool-agnostic** approach (works with any editor/IDE)
- **Isolated development data** - all data stored in `development/data/`

## Quick Start

1. **Prerequisites**
   - Docker and Docker Compose installed
   - Git repository cloned

2. **Start the development environment**
   ```bash
   cd development
   docker-compose up
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8081
   - Health check: http://localhost:8081/healthz

## Services

### Backend (Go API)
- **Port**: 8081
- **Hot reload**: Manual restart via `docker-compose restart backend`
- **Database**: SQLite with sample data
- **Environment**: Development mode
- **Note**: Initial compilation takes 60-90 seconds due to Go dependencies

### Frontend (React)
- **Port**: 3000
- **Hot reload**: Vite dev server with HMR
- **API proxy**: Automatically configured to backend

### Database
- **Type**: SQLite
- **Location**: `./data/memos_dev.db`
- **Sample data**: Pre-populated with users, memos, and settings

## Sample Users

The development environment includes these test users:

| Username | Password | Role  | Description |
|----------|----------|-------|-------------|
| admin    | demo     | HOST  | System administrator |
| demo     | demo     | USER  | Demo user account |
| john     | demo     | USER  | Software developer |

## Common Commands

### Full Stack
```bash
# Start all services
docker-compose up

# Start with logs
docker-compose up --build

# Stop all services
docker-compose down

# Restart everything
docker-compose restart
```

### Individual Services
```bash
# Start only backend
docker-compose up backend

# Start only frontend
docker-compose up frontend

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Database Management
```bash
# Reset database (removes all data)
docker-compose down -v
rm -f ./data/memos_dev.db
docker-compose up db-init

# Access database directly
sqlite3 ./data/memos_dev.db
```

## Development Workflow

1. **Make changes** to Go or React code
2. **Save files** - hot reload will automatically rebuild/refresh
3. **Test changes** in browser at http://localhost:3000
4. **Use API** directly at http://localhost:8081

## File Structure

```
development/
├── docker-compose.yml          # Main orchestration file
├── backend/
│   ├── Dockerfile             # Backend development container
│   └── entrypoint.sh          # Backend startup script
├── frontend/
│   ├── Dockerfile             # Frontend development container
│   └── entrypoint.sh          # Frontend startup script
├── seed/
│   └── sample-data.sql        # Sample database content
├── data/                      # Development database storage (gitignored)
│   └── memos_dev.db           # SQLite database file (auto-created)
├── test-setup.sh              # Environment validation script
└── README.md                  # This file
```

## Troubleshooting

### Port Conflicts
If ports 3000 or 8081 are already in use, modify the ports in `docker-compose.yml`:

```yaml
ports:
  - "3001:3000"  # Frontend
  - "8082:8081"  # Backend
```

### Database Issues
If you encounter database errors:

1. Stop services: `docker-compose down`
2. Remove database: `rm -f ./data/memos_dev.db`
3. Restart: `docker-compose up`

### Build Issues
If containers fail to build:

1. Clean rebuild: `docker-compose build --no-cache`
2. Remove containers: `docker-compose down --rmi all`
3. Restart: `docker-compose up --build`

### Hot Reload Not Working
- **Backend**: Restart with `docker-compose restart backend`
- **Frontend**: Ensure file watching is enabled in container
- **Permissions**: Check file permissions on mounted volumes

## Environment Variables

You can customize the development environment by setting these variables:

```bash
# Backend configuration
MEMOS_MODE=dev
MEMOS_PORT=8081
MEMOS_DRIVER=sqlite
MEMOS_DSN=/app/development/data/memos_dev.db

# Frontend configuration
VITE_API_URL=http://localhost:8081
CHOKIDAR_USEPOLLING=true
```

## Comparison with DevContainer

| Feature | DevContainer | Docker Compose |
|---------|-------------|----------------|
| Editor Support | VSCode only | Any editor |
| Service Isolation | Single container | Multiple containers |
| Hot Reload | Manual setup | Automatic |
| Database | Manual setup | Pre-populated |
| Startup | Manual | Automatic |
| Resource Usage | Higher | Lower |

## Migration from DevContainer

If you're migrating from the devcontainer setup:

1. **Close VSCode** devcontainer
2. **Navigate** to the `development/` directory
3. **Run** `docker-compose up`
4. **Open** your preferred editor and start coding!

## Contributing

When adding new features to the development environment:

1. Test changes with `docker-compose up --build`
2. Update this README if needed
3. Ensure both hot reload and database seeding work
4. Test with a fresh database: `docker-compose down -v && rm -f ./data/memos_dev.db && docker-compose up`