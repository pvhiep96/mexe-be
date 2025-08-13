#!/bin/bash

# Deploy script for Northflank
# This script handles the deployment process and ensures all dependencies are met

set -e

echo "🚀 Starting deployment to Northflank..."

# Check if required environment variables are set
check_env_vars() {
    echo "🔍 Checking environment variables..."
    
    required_vars=(
        "RAILS_MASTER_KEY"
        "DATABASE_URL"
        "POSTGRES_PASSWORD"
    )
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "❌ Error: $var is not set"
            exit 1
        fi
    done
    
    echo "✅ Environment variables are properly set"
}

# Install system dependencies
install_dependencies() {
    echo "📦 Installing system dependencies..."
    
    apt-get update -qq
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        pkg-config \
        curl \
        libjemalloc2 \
        libvips \
        sqlite3 \
        postgresql-client
    
    # Clean up
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
    
    echo "✅ Dependencies installed successfully"
}

# Setup database
setup_database() {
    echo "🗄️ Setting up database..."
    
    # Wait for database to be ready
    echo "⏳ Waiting for database to be ready..."
    until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER; do
        echo "Database is not ready yet. Waiting..."
        sleep 2
    done
    
    echo "✅ Database is ready"
    
    # Run database setup
    echo "🔧 Running database setup..."
    bundle exec rails db:create 2>/dev/null || true
    bundle exec rails db:migrate
    bundle exec rails db:seed 2>/dev/null || true
    
    echo "✅ Database setup completed"
}

# Precompile assets
precompile_assets() {
    echo "🎨 Precompiling assets..."
    
    # Set dummy environment variables for assets precompilation
    export SECRET_KEY_BASE="dummy_key_for_assets_precompilation"
    export RAILS_MASTER_KEY="dummy_master_key_for_assets_precompilation"
    
    # Create temporary database for assets precompilation if needed
    if [ "$RAILS_ENV" = "production" ]; then
        echo "📝 Creating temporary database for assets precompilation..."
        bundle exec rails db:create 2>/dev/null || true
    fi
    
    # Precompile assets
    bundle exec rails assets:precompile
    
    # Clean up temporary database
    if [ "$RAILS_ENV" = "production" ]; then
        echo "🧹 Cleaning up temporary database..."
        bundle exec rails db:drop 2>/dev/null || true
    fi
    
    echo "✅ Assets precompiled successfully"
}

# Main deployment process
main() {
    echo "🎯 Starting main deployment process..."
    
    # Check environment variables
    check_env_vars
    
    # Install dependencies
    install_dependencies
    
    # Install Ruby gems
    echo "💎 Installing Ruby gems..."
    bundle install --jobs 4 --retry 3
    
    # Setup database
    setup_database
    
    # Precompile assets
    precompile_assets
    
    # Start the application
    echo "🚀 Starting Rails application..."
    exec bundle exec rails server -b 0.0.0.0
}

# Run main function
main "$@"
