#!/bin/bash
set -e

echo "Starting Rails application..."

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rails/tmp/pids/server.pid

# Install missing gems
echo "Checking and installing gems..."
bundle check || bundle install

# Wait for database to be ready (useful for production with external databases)
echo "Waiting for database to be ready..."
until bundle exec rails db:version > /dev/null 2>&1; do
  echo "Database not ready, waiting..."
  sleep 2
done

# Create database if it doesn't exist
echo "Creating database if it doesn't exist..."
bundle exec rails db:create 2>/dev/null || echo "Database creation failed or database already exists"

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || echo "Migrations failed or no migrations to run"

# Optionally load seeds in development environment
if [ "$RAILS_ENV" = "development" ] || [ "$RAILS_ENV" = "test" ]; then
  echo "Loading seeds for $RAILS_ENV environment..."
  bundle exec rails db:seed 2>/dev/null || echo "Seeds failed or no seeds to load"
fi

echo "Database setup completed. Starting application..."

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@" 