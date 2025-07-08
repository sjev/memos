# Memos Development Environment

A Docker Compose-based development environment for Memos that provides:

- **Hot reload** for frontend (React) and manual restart for backend (Go)
- **Pre-populated database** with sample data
- **Service isolation** for better development experience
- **Tool-agnostic** approach (works with any editor/IDE)
- **Isolated development data** - all data stored in `development/data/`
- **Host networking** for simplified development setup

## Quick Start

1. **Prerequisites**
   - Docker and Docker Compose installed
   - Git repository cloned

2. **Initialize database (optional - done automatically)**
   ```bash
   cd development
   ./init-db.sh
   ```

3. **Start services**
   ```bash
   # Start backend
   ./start-backend.sh

   # Start frontend (in another terminal)
   ./start-frontend.sh
   ```

4. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8081
   - Health check: http://localhost:8081/healthz

## Services

### Backend (Go API)
- **Port**: 8081
- **Hot reload**: Manual restart via `./start-backend.sh`
- **Database**: SQLite with sample data
- **Environment**: Development mode
- **Networking**: Host mode (direct access to localhost)
- **Note**: Initial compilation takes 60-90 seconds due to Go dependencies

### Frontend (React)
- **Port**: 3000
- **Hot reload**: Vite dev server with HMR
- **API proxy**: Configured to http://localhost:8081
- **Networking**: Host mode (direct access to localhost)

### Database
- **Type**: SQLite
- **Location**: `./data/memos_dev.db`
- **Sample data**: Pre-populated with users, memos, and settings
- **Initialization**: Automatic via `init-db.sh`

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
# Start all services (traditional method)
docker-compose up

# Start with individual scripts (recommended)
./start-backend.sh      # Terminal 1
./start-frontend.sh     # Terminal 2
```

### Individual Services
```bash
# Start only backend
./start-backend.sh
# OR
docker-compose up backend

# Start only frontend
./start-frontend.sh
# OR
docker-compose up frontend

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Database Management
```bash
# Initialize database
./init-db.sh

# Reset database (removes all data)
rm -f ./data/memos_dev.db
./init-db.sh

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
├── docker-compose.yml          # Main orchestration file (simplified)
├── init-db.sh                 # Database initialization script
├── start-backend.sh           # Backend startup script
├── start-frontend.sh          # Frontend startup script
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
If ports 3000 or 8081 are already in use:

**Option 1: Kill existing processes**
```bash
sudo lsof -ti:3000 | xargs kill -9
sudo lsof -ti:8081 | xargs kill -9
```

**Option 2: Modify environment variables**
Edit the startup scripts or docker-compose.yml to use different ports.

### Database Issues
If you encounter database errors:

1. Stop services: `docker-compose down`
2. Remove database: `rm -f ./data/memos_dev.db`
3. Reinitialize: `./init-db.sh`
4. Restart: `./start-backend.sh`

### Build Issues
If containers fail to build:

1. Clean rebuild: `docker-compose build --no-cache`
2. Remove containers: `docker-compose down --rmi all`
3. Restart: `docker-compose up --build`

### Hot Reload Not Working
- **Backend**: Restart with `./start-backend.sh`
- **Frontend**: Restart with `./start-frontend.sh`
- **Permissions**: Check file permissions on mounted volumes
- **Network**: Ensure host networking is working properly

## Environment Variables

You can customize the development environment by setting these variables:

```bash
# Backend configuration
MEMOS_MODE=dev
MEMOS_PORT=8081
MEMOS_DRIVER=sqlite
MEMOS_DSN=/app/development/data/memos_dev.db

# Frontend configuration
DEV_PROXY_SERVER=http://localhost:8081
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