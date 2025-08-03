# Docker Setup for Mexe Backend

This directory contains Docker configurations for running the Rails application in both development and production environments.

## Prerequisites

- Docker
- Docker Compose
- Git

## Quick Start

### Development Environment

1. **Copy environment file:**
   ```bash
   cp env.example .env
   ```

2. **Edit the `.env` file with your configuration:**
   ```bash
   # Set your Rails master key
   RAILS_MASTER_KEY=your_actual_rails_master_key
   ```

3. **Start the development environment:**
   ```bash
   docker-compose up --build
   ```

4. **Access the application:**
   - Rails app: http://localhost:3000
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

### Production Environment

1. **Set up environment variables:**
   ```bash
   cp env.example .env
   # Edit .env with production values
   ```

2. **Start production services:**
   ```bash
   docker-compose -f docker-compose.prod.yml up --build -d
   ```

3. **Access the application:**
   - Rails app: http://localhost (via nginx)
   - Direct Rails: http://localhost:3000

## Available Commands

### Development

```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f web

# Run Rails console
docker-compose exec web rails console

# Run database migrations
docker-compose exec web rails db:migrate

# Run tests
docker-compose exec web rails test

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Production

```bash
# Start production services
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Stop production services
docker-compose -f docker-compose.prod.yml down
```

## Database Setup

### Development

The development environment uses PostgreSQL. The database will be automatically created when you first run the containers.

```bash
# Create database
docker-compose exec web rails db:create

# Run migrations
docker-compose exec web rails db:migrate

# Seed database
docker-compose exec web rails db:seed
```

### Production

For production, make sure to:

1. Set proper database credentials in `.env`
2. Run migrations after deployment
3. Set up database backups

## File Structure

```
mexe-be/
├── docker-compose.yml          # Development configuration
├── docker-compose.prod.yml     # Production configuration
├── docker-compose.override.yml # Local development overrides
├── Dockerfile                  # Production Dockerfile
├── Dockerfile.dev              # Development Dockerfile
├── entrypoint.sh              # Container entrypoint script
├── nginx.conf                 # Nginx configuration
├── env.example                # Environment variables template
└── README-Docker.md           # This file
```

## Services

### Development
- **web**: Rails application (port 3000)
- **db**: PostgreSQL database (port 5432)
- **redis**: Redis cache (port 6379)

### Production
- **web**: Rails application
- **db**: PostgreSQL database
- **redis**: Redis cache
- **nginx**: Reverse proxy and load balancer

## Volumes

- `postgres_data`: PostgreSQL data persistence
- `redis_data`: Redis data persistence
- `bundle_cache`: Ruby gems cache
- `rails_storage`: Rails Active Storage files
- `rails_logs`: Rails application logs
- `node_modules`: Node.js modules (development only)

## Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   # Check what's using the port
   lsof -i :3000
   # Stop the conflicting service or change ports in docker-compose.yml
   ```

2. **Database connection issues:**
   ```bash
   # Restart the database service
   docker-compose restart db
   ```

3. **Permission issues:**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

4. **Build cache issues:**
   ```bash
   # Rebuild without cache
   docker-compose build --no-cache
   ```

### Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs web
docker-compose logs db

# Follow logs in real-time
docker-compose logs -f web
```

## Security Notes

1. **Never commit `.env` files** - they contain sensitive information
2. **Use strong passwords** for production databases
3. **Enable HTTPS** in production by configuring SSL certificates
4. **Regularly update** Docker images and dependencies

## Performance Optimization

1. **Use volume caching** for gems and node_modules
2. **Configure nginx** for static asset serving
3. **Set up Redis** for session storage and caching
4. **Monitor resource usage** with `docker stats`

## Deployment

For production deployment:

1. Set up proper environment variables
2. Configure SSL certificates
3. Set up monitoring and logging
4. Configure backups
5. Set up CI/CD pipeline

## Support

For issues related to Docker setup, check:
- Docker documentation
- Rails Docker guides
- Container logs for specific error messages 