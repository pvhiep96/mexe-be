#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rails/tmp/pids/server.pid

# Install missing gems
bundle check || bundle install

# Create database if it doesn't exist
bundle exec rails db:create 2>/dev/null || true

# Run database migrations
bundle exec rails db:migrate 2>/dev/null || true

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@" 