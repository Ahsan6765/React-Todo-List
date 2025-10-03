#!/bin/bash

# ============================
# React-Todo Rebuild Script
# ============================

# Variables
IMAGE_NAME="react-todo"
IMAGE_TAG="v1"
CONTAINER_NAME="react-todo-container"

echo "====================================="
echo "🚀 Rebuilding and restarting container"
echo "====================================="

# Stop old container if running
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "🛑 Stopping old container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Build new image
echo "🔨 Building new Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

# Run container in detached mode
echo "▶️ Starting new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME:$IMAGE_TAG

# Show status
echo "====================================="
docker ps --filter "name=$CONTAINER_NAME"
echo "====================================="
echo "✅ Container '$CONTAINER_NAME' is running at http://localhost (or your VM IP)"
