#!/bin/bash
set -euo pipefail

# Check if tag argument is provided
if [ $# -lt 1 ]; then
  echo "❌ Usage: $0 <image-tag>"
  exit 1
fi

# Config
IMAGE_NAME="mexe"
IMAGE_TAG="$1"   # first argument
DOCKER_USER="quytv020494"

# Build image
echo "🚀 Building Docker image ${IMAGE_NAME}:${IMAGE_TAG} ..."
docker build --platform=linux/amd64 -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Tag image
echo "🏷️ Tagging image..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}

# Push image
echo "📤 Pushing to Docker Hub..."
docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}

echo "✅ Done! Pushed ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
