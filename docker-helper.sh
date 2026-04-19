#!/bin/bash

# Docker Compose Helper Scripts for Pet Adoption Platform

if [ -z "$1" ]; then
    echo "Usage: ./docker-helper.sh [command]"
    echo ""
    echo "Available commands:"
    echo "  up              - Start all services"
    echo "  down            - Stop all services"
    echo "  rebuild         - Rebuild docker images"
    echo "  logs            - View logs from all services"
    echo "  logs-server     - View server logs"
    echo "  logs-client     - View client logs"
    echo "  logs-db         - View database logs"
    echo "  ps              - Show running containers"
    echo "  restart         - Restart all services"
    echo "  clean           - Remove containers and volumes"
    echo "  bash-server     - Open bash in server container"
    echo "  bash-client     - Open bash in client container"
    exit 0
fi

case "$1" in
    up)
        echo "Starting all services..."
        docker-compose up -d
        echo "Services started. Waiting for health checks..."
        sleep 5
        docker-compose ps
        ;;
    down)
        echo "Stopping all services..."
        docker-compose down
        ;;
    rebuild)
        echo "Rebuilding Docker images..."
        docker-compose build --no-cache
        ;;
    logs)
        docker-compose logs -f
        ;;
    logs-server)
        docker-compose logs -f server
        ;;
    logs-client)
        docker-compose logs -f client
        ;;
    logs-db)
        docker-compose logs -f mongodb
        ;;
    ps)
        docker-compose ps
        ;;
    restart)
        echo "Restarting all services..."
        docker-compose restart
        ;;
    clean)
        echo "Removing containers and volumes..."
        docker-compose down -v
        ;;
    bash-server)
        docker exec -it tailmate-server sh
        ;;
    bash-client)
        docker exec -it tailmate-client sh
        ;;
    *)
        echo "Unknown command: $1"
        ;;
esac
