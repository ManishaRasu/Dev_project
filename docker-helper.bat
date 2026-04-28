@echo off
REM Docker Compose Helper Scripts for Pet Adoption Platform

setlocal enabledelayedexpansion

if "%1"=="" (
    echo Usage: docker-helper.bat [command]
    echo.
    echo Available commands:
    echo   up              - Start all services
    echo   down            - Stop all services
    echo   rebuild         - Rebuild docker images
    echo   logs            - View logs from all services
    echo   logs-server     - View server logs
    echo   logs-client     - View client logs
    echo   logs-db         - View database logs
    echo   ps              - Show running containers
    echo   restart         - Restart all services
    echo   clean           - Remove containers and volumes
    echo   bash-server     - Open bash in server container
    echo   bash-client     - Open bash in client container
    goto :EOF
)

if "%1"=="up" (
    echo Starting all services...
    docker compos up -d
    echo Services started. Waiting for health checks...
    timeout /t 5
    docker compos ps
    goto :EOF
)

if "%1"=="down" (
    echo Stopping all services...
    docker compos down
    goto :EOF
)

if "%1"=="rebuild" (
    echo Rebuilding Docker images...
    docker compos build --no-cache
    goto :EOF
)

if "%1"=="logs" (
    docker compos logs -f
    goto :EOF
)

if "%1"=="logs-server" (
    docker compos logs -f server
    goto :EOF
)

if "%1"=="logs-client" (
    docker compos logs -f client
    goto :EOF
)

if "%1"=="logs-db" (
    docker compos logs -f mongodb
    goto :EOF
)

if "%1"=="ps" (
    docker compos ps
    goto :EOF
)

if "%1"=="restart" (
    echo Restarting all services...
    docker compos restart
    goto :EOF
)

if "%1"=="clean" (
    echo Removing containers and volumes...
    docker compos down -v
    goto :EOF
)

if "%1"=="bash-server" (
    docker exec -it tailmate-server sh
    goto :EOF
)

if "%1"=="bash-client" (
    docker exec -it tailmate-client sh
    goto :EOF
)

echo Unknown command: %1
