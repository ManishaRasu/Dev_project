@echo off
REM Quick Start Script for Docker Compose Setup (Windows)
REM This script helps you get started with Docker Compose

setlocal enabledelayedexpansion

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║   Pet Adoption Platform - Docker Compose Quick Start          ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Check Docker installation
echo 📦 Checking Docker installation...
docker --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop:
    echo    https://www.docker.com/products/docker-desktop
    exit /b 1
)

echo ✅ Docker is installed

REM Check if Docker daemon is running
echo.
echo 🔍 Checking if Docker daemon is running...
docker ps >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ ERROR: Docker daemon is not running!
    echo.
    echo 📋 SOLUTION:
    echo    1. Open "Docker Desktop" application
    echo    2. Wait for it to fully start (watch the system tray icon^)
    echo    3. Then run this script again
    echo.
    echo 💡 TIP: You should see the Docker whale icon in your system tray
    echo.
    timeout /t 5
    exit /b 1
)

echo ✅ Docker daemon is running

REM Check Docker Compose
docker compos --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker Compose is not installed.
    exit /b 1
)

for /f "tokens=*" %%i in ('docker --version') do set DOCKER_VERSION=%%i
for /f "tokens=*" %%i in ('docker compos --version') do set COMPOSE_VERSION=%%i

echo ✅ !DOCKER_VERSION!
echo ✅ !COMPOSE_VERSION!
echo.

REM Check if .env.docker exists
if not exist .env.docker (
    echo 📝 Creating .env.docker file...
    (
        echo # MongoDB Configuration
        echo MONGO_URI=mongodb://mongodb:27017/petad
        echo.
        echo # Server Configuration
        echo PORT=5000
        echo JWT_SECRET=dev-secret-key-change-in-production
        echo.
        echo # Client Configuration
        echo REACT_APP_API_URL=http://localhost:5000/
        echo.
        echo # Node Environment
        echo NODE_ENV=development
    ) > .env.docker
    echo ✅ Created .env.docker
) else (
    echo ✅ .env.docker already exists
)

echo.
echo 🐳 Building Docker images (this may take 2-5 minutes^)...
docker compos build
if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ Build failed
    echo.
    echo 💡 Troubleshooting:
    echo    - Check Docker Desktop is running: look for whale icon in system tray
    echo    - Try: docker compos build --no-cache
    echo    - View logs: docker compos logs
    exit /b 1
)
echo ✅ Build complete

echo.
echo 🚀 Starting services...
docker compos up -d
if %ERRORLEVEL% neq 0 (
    echo ❌ Failed to start services
    exit /b 1
)

echo.
echo ⏳ Waiting for services to be healthy (30 seconds^)...
timeout /t 30 /nobreak

echo.
echo 📊 Service Status:
docker compos ps

echo.
echo 🌐 Application URLs:
echo    Frontend: http://localhost:3000
echo    Backend:  http://localhost:5000/
echo    Database: mongodb://localhost:27017

echo.
echo 📝 Useful commands:
echo    View logs:          docker compos logs -f
echo    Stop services:      docker compos down
echo    Restart services:   docker compos restart
echo    Enter server:       docker exec -it tailmate-server sh

echo.
echo ✨ Setup complete!
echo.
echo For more information, see DOCKER_GUIDE.md
echo.
pause
