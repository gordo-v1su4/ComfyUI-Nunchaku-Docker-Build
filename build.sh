#!/bin/bash

# Build script for ComfyUI-Nunchaku Docker image
echo "Building ComfyUI-Nunchaku Docker image..."

# Build the Docker image
docker build -t comfyui-nunchaku:latest .

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo "🚀 You can now deploy this with docker-compose up -d"
    echo "🌐 Or push to a registry for Coolify deployment"
else
    echo "❌ Build failed. Check the logs above."
    exit 1
fi
