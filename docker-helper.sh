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
        docker compos up -d
        echo "Services started. Waiting for health checks..."
        sleep 5
        docker compos ps
        ;;
    down)
        echo "Stopping all services..."
        docker compos down
        ;;
    rebuild)
        echo "Rebuilding Docker images..."
        docker compos build --no-cache
        ;;
    logs)
        docker compos logs -f
        ;;
    logs-server)
        docker compos logs -f server
        ;;
    logs-client)
        docker compos logs -f client
        ;;
    logs-db)
        docker compos logs -f mongodb
        ;;
    ps)
        docker compos ps
        ;;
    restart)
        echo "Restarting all services..."
        docker compos restart
        ;;
    clean)
        echo "Removing containers and volumes..."
        docker compos down -v
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
