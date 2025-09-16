#!/bin/bash

# Script để chạy development environment với Docker
# Tự động chạy bundle install khi cần thiết

echo "🚀 Starting MeXe Backend Development Environment..."

# Dừng containers hiện tại nếu có
echo "📦 Stopping existing containers..."
docker-compose down

# Build lại image để đảm bảo có entrypoint script
echo "🔨 Building Docker image..."
docker-compose build

# Chạy containers
echo "🏃 Starting containers..."
docker-compose up -d

# Hiển thị logs
echo "📋 Showing logs (Ctrl+C to stop viewing logs, containers will continue running)..."
docker-compose logs -f web
