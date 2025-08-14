#!/bin/bash

echo "🔧 Setting up Authentication for Mexe Backend..."

# Install gems
echo "📦 Installing required gems..."
bundle install

# Run migrations
echo "🗄️ Running database migrations..."
bundle exec rails db:migrate

# Create test user if not exists
echo "👤 Creating test user..."
bundle exec rails runner "
  unless User.exists?(email: 'test@example.com')
    user = User.create!(
      email: 'test@example.com',
      full_name: 'Test User',
      password: 'password123'
    )
    puts '✅ Test user created: test@example.com / password123'
  else
    puts '✅ Test user already exists: test@example.com / password123'
  end
"

# Test JWT service
echo "🔑 Testing JWT Service..."
bundle exec rails runner "
  begin
    token = JwtService.encode({ user_id: 1, test: true })
    decoded = JwtService.decode(token)
    puts '✅ JWT Service working correctly'
    puts '   Token: ' + token[0..50] + '...'
  rescue => e
    puts '❌ JWT Service error: ' + e.message
  end
"

echo "🚀 Setup completed! You can now:"
echo "   1. Start server: bundle exec rails server -p 3000"
echo "   2. Test login with: test@example.com / password123"
echo "   3. API endpoints available at: http://localhost:3000/api/v1/"
