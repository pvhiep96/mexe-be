#!/bin/bash

echo "=========================================="
echo "    SETUP DATABASE FOR MEXE E-COMMERCE"
echo "=========================================="

# Check if we're in Docker environment
if [ -f /.dockerenv ]; then
    echo "Running in Docker container..."
else
    echo "Not running in Docker container, but continuing..."
fi

echo ""
echo "Step 1: Installing dependencies..."
bundle install

echo ""
echo "Step 2: Setting up database..."
echo "Dropping database if exists..."
bundle exec rails db:drop RAILS_ENV=development 2>/dev/null || echo "Database doesn't exist, continuing..."

echo "Creating database..."
bundle exec rails db:create RAILS_ENV=development

echo "Running migrations..."
bundle exec rails db:migrate RAILS_ENV=development

echo "Loading seeds..."
bundle exec rails db:seed RAILS_ENV=development

echo ""
echo "Step 3: Verifying setup..."
echo "Checking database tables..."
bundle exec rails runner "puts 'Database tables:'; ActiveRecord::Base.connection.tables.each { |t| puts \"  - #{t}\" }"

echo ""
echo "Checking record counts..."
bundle exec rails runner "
puts 'Record counts:'
puts \"  - Users: #{User.count}\"
puts \"  - Categories: #{Category.count}\"
puts \"  - Brands: #{Brand.count}\"
puts \"  - Products: #{Product.count}\"
puts \"  - Articles: #{Article.count}\"
puts \"  - Coupons: #{Coupon.count}\"
puts \"  - Stores: #{Store.count}\"
puts \"  - Settings: #{Setting.count}\"
"

echo ""
echo "=========================================="
echo "    DATABASE SETUP COMPLETED!"
echo "=========================================="
echo ""
echo "You can now start the Rails server with:"
echo "  bundle exec rails server -b 0.0.0.0"
echo ""
echo "Or run the application in Docker with:"
echo "  docker-compose up"
echo "" 