#!/bin/bash

# Quick Start Script for Docker Compose Setup
# This script helps you get started with Docker Compose

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   Pet Adoption Platform - Docker Compose Quick Start          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check Docker installation
echo "📦 Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "✅ Docker is installed"

# Check if Docker daemon is running
echo ""
echo "🔍 Checking if Docker daemon is running..."
if ! docker ps &> /dev/null; then
    echo ""
    echo "❌ ERROR: Docker daemon is not running!"
    echo ""
    echo "📋 SOLUTION:"
    echo "   Mac:"
    echo "     1. Open Applications > Docker.app"
    echo "     2. Wait for whale icon to appear in menu bar"
    echo "     3. Then run this script again"
    echo ""
    echo "   Linux:"
    echo "     1. Start Docker: sudo systemctl start docker"
    echo "     2. Then run this script again"
    echo ""
    echo "   Windows (WSL2):"
    echo "     1. Open Docker Desktop application"
    echo "     2. Wait for it to fully start"
    echo "     3. Then run this script again"
    echo ""
    exit 1
fi

echo "✅ Docker daemon is running"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ $(docker --version)"
echo "✅ $(docker-compose --version)"
echo ""

# Check if .env.docker exists
if [ ! -f .env.docker ]; then
    echo "📝 Creating .env.docker file..."
    cat > .env.docker << 'EOF'
# MongoDB Configuration
MONGO_URI=mongodb://mongodb:27017/petad

# Server Configuration
PORT=5000
JWT_SECRET=dev-secret-key-change-in-production

# Client Configuration
REACT_APP_API_URL=http://localhost:5000

# Node Environment
NODE_ENV=development
EOF
    echo "✅ Created .env.docker"
else
    echo "✅ .env.docker already exists"
fi

echo ""
echo "🐳 Building Docker images (this may take 2-5 minutes)..."
if ! docker-compose build; then
    echo ""
    echo "❌ Build failed"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   - Check Docker is running"
    echo "   - Try: docker-compose build --no-cache"
    echo "   - View logs: docker-compose logs"
    exit 1
fi
echo "✅ Build complete"

echo ""
echo "🚀 Starting services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be healthy (30 seconds)..."
sleep 30

echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🌐 Application URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:5000"
echo "   Database: mongodb://localhost:27017"

echo ""
echo "📝 Useful commands:"
echo "   View logs:          docker-compose logs -f"
echo "   Stop services:      docker-compose down"
echo "   Restart services:   docker-compose restart"
echo "   Enter server:       docker exec -it tailmate-server sh"

echo ""
echo "✨ Setup complete!"
echo ""
echo "For more information, see DOCKER_GUIDE.md"

echo ""
echo "✨ Setup complete!"
echo ""
echo "For more information, see DOCKER_GUIDE.md"
