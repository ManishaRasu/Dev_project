# Docker Compose Setup Guide - Pet Adoption Platform

## 📚 Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Understanding the Architecture](#understanding-the-architecture)
5. [Running Locally](#running-locally)
6. [Common Commands](#common-commands)
7. [Troubleshooting](#troubleshooting)
8. [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
9. [Production Deployment](#production-deployment)

---

## Overview

This project uses **Docker Compose** to orchestrate three main services:
- **MongoDB**: NoSQL database
- **Server**: Node.js/Express backend API
- **Client**: React frontend application

All services run in isolated containers and communicate via a shared Docker network. This ensures consistency across development, testing, and production environments.

### Benefits of Docker Compose
✅ Isolated dependencies per service  
✅ Consistent environment across machines  
✅ Easy local development  
✅ Simple multi-service orchestration  
✅ Automated CI/CD integration  

---

## Prerequisites

### Install Required Tools

#### Windows
1. **Docker Desktop for Windows**
   - Download: https://www.docker.com/products/docker-desktop
   - Requires Windows 10/11 Pro, Enterprise, or Education edition
   - Enables WSL 2 (Windows Subsystem for Linux 2)

2. **Verify Installation**
   ```powershell
   docker --version
   docker compos --version
   ```

#### Mac
```bash
# Using Homebrew
brew install docker

# Or download Docker Desktop from:
# https://www.docker.com/products/docker-desktop
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get install docker.io docker compos

# Add user to docker group (avoid sudo)
sudo usermod -aG docker $USER
newgrp docker
```

---

## Quick Start

### 1️⃣ Start All Services
```bash
# Windows
./docker-helper.bat up

# Mac/Linux
./docker-helper.sh up
```

### 2️⃣ Access the Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000/
- **MongoDB**: mongodb://localhost:27017

### 3️⃣ Stop Services
```bash
# Windows
./docker-helper.bat down

# Mac/Linux
./docker-helper.sh down
```

---

## Understanding the Architecture

### Service Topology

```
┌─────────────────────────────────────────┐
│       tailmate-network (bridge)         │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────┐  ┌──────────┐  ┌───────┐ │
│  │ MongoDB  │  │ Server   │  │Client │ │
│  │ :27017   │  │ :5000    │  │:3000  │ │
│  └──────────┘  └──────────┘  └───────┘ │
│       ↑             ↑            ↑      │
│       └─────────────┴────────────┘      │
│            Internal DNS                  │
│     (mongodb, server, client)            │
│                                         │
└─────────────────────────────────────────┘
```

### Service Details

#### MongoDB
- **Image**: mongo:7.0
- **Container**: tailmate-mongodb
- **Port**: 27017
- **Volumes**: mongodb_data, mongodb_config
- **Health**: Checks connection every 10 seconds

#### Server (Node.js/Express)
- **Dockerfile**: Dockerfile.server
- **Container**: tailmate-server
- **Port**: 5000
- **Environment**: Connected to MongoDB via `mongodb://mongodb:27017/petad`
- **Health**: Checks `/health` endpoint every 30 seconds
- **Dependencies**: Starts after MongoDB is healthy

#### Client (React)
- **Dockerfile**: Dockerfile.client
- **Container**: tailmate-client
- **Port**: 3000
- **Environment**: API_URL set to `http://localhost:5000/`
- **Features**: Hot-reload enabled for development

---

## Running Locally

### Development Setup

#### 1. Build from Source
```bash
docker compos build
```

#### 2. Start Services
```bash
docker compos up -d
```

#### 3. View Logs
```bash
# All services
docker compos logs -f

# Individual service
docker compos logs -f server
docker compos logs -f client
docker compos logs -f mongodb
```

#### 4. Access Shell in Container
```bash
# Server container
docker exec -it tailmate-server sh

# Client container
docker exec -it tailmate-client sh

# MongoDB container
docker exec -it tailmate-mongodb mongosh
```

#### 5. Run Commands Inside Container
```bash
# Example: npm install in server
docker exec tailmate-server npm install

# Example: check Node version
docker exec tailmate-server node --version
```

### Development with Hot Reload

Both client and server support hot-reload:

**Client (React)**:
- Any changes in `src/` auto-reload in browser
- Enabled by `CHOKIDAR_USEPOLLING=true`

**Server (Node.js)**:
- Restart server for changes:
  ```bash
  docker compos restart server
  ```

---

## Common Commands

### Using Docker Compose Directly

```bash
# Start services in foreground (see logs)
docker compos up

# Start services in background
docker compos up -d

# Stop services
docker compos down

# View running containers
docker compos ps

# View logs
docker compos logs -f

# Restart services
docker compos restart

# Rebuild images
docker compos build --no-cache

# Remove containers and volumes
docker compos down -v

# Execute command in container
docker exec -it tailmate-server npm install
```

### Using Helper Scripts

#### Windows (PowerShell)
```powershell
# Make script executable
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run commands
./docker-helper.bat up
./docker-helper.bat logs-server
./docker-helper.bat bash-server
```

#### Mac/Linux (Bash)
```bash
# Make script executable
chmod +x docker-helper.sh

# Run commands
./docker-helper.sh up
./docker-helper.sh logs-server
./docker-helper.sh bash-server
```

---

## Troubleshooting

### Issue: "Docker daemon is not running"
**Solution**: Start Docker Desktop application

### Issue: Port 3000 or 5000 already in use
**Solution**: 
```bash
# Find process using port
# Windows
netstat -ano | findstr :3000

# Mac/Linux
lsof -i :3000

# Kill process or use different port in docker compos.yml
```

### Issue: MongoDB connection refused
**Check**:
```bash
# Verify MongoDB is running
docker compos ps mongodb

# Check logs
docker compos logs mongodb

# Test connection
docker exec -it tailmate-mongodb mongosh --eval "db.adminCommand('ping')"
```

### Issue: React hot-reload not working
**Solution**:
```bash
# Rebuild with polling enabled
docker compos down -v
docker compos build
docker compos up -d
```

### Issue: "ENOENT" error when running npm
**Solution**: Rebuild Docker images
```bash
docker compos down -v
docker compos build --no-cache
docker compos up -d
```

### Issue: Services not communicating
**Check**:
```bash
# Verify network exists
docker network ls | grep tailmate

# Test internal DNS
docker exec tailmate-server ping mongodb
docker exec tailmate-server ping client
```

### View Detailed Error Logs
```bash
# See full logs with timestamps
docker compos logs --timestamps

# See last 100 lines
docker compos logs --tail=100

# Follow specific service
docker compos logs -f client
```

---

## Jenkins CI/CD Pipeline

### Overview
The `Jenkinsfile` automates Docker Compose build and deployment.

### Pipeline Stages

```
Checkout → Environment Check → Build Images → Start Services 
    → Health Checks → Run Tests → Service Status
```

### Setup Jenkins

#### 1. Prerequisites
- Jenkins server installed and running
- Docker and Docker Compose installed on Jenkins agent
- Git repository configured

#### 2. Create New Pipeline Job
1. Go to Jenkins dashboard
2. Click "New Item"
3. Enter job name: "tailmate-deployment"
4. Select "Pipeline"
5. Click "OK"

#### 3. Configure Pipeline
1. Under "Pipeline" section:
2. Select "Pipeline script from SCM"
3. Configure SCM:
   - SCM: Git
   - Repository URL: `https://github.com/your-repo/pet-adoption-platform.git`
   - Branch: `*/main`
4. Script Path: `Jenkinsfile`
5. Click "Save"

#### 4. Run Pipeline
1. Click "Build Now"
2. Watch build progress in "Build History"
3. Check console output for logs

### Pipeline Environment Variables
Customize in `Jenkinsfile`:
```groovy
environment {
    REGISTRY = "docker.io/yourusername"  // Docker Hub registry
    IMAGE_TAG = "${BUILD_NUMBER}"         // Use build number as tag
}
```

### Docker Registry Integration
For pushing images to Docker Hub or private registry:

```groovy
stage('Push Images') {
    steps {
        script {
            sh 'docker tag tailmate-server ${REGISTRY}/tailmate-server:${IMAGE_TAG}'
            sh 'docker push ${REGISTRY}/tailmate-server:${IMAGE_TAG}'
        }
    }
}
```

### Health Checks in Pipeline
The pipeline automatically checks:
- ✅ Docker and Docker Compose versions
- ✅ MongoDB connectivity and readiness
- ✅ Server `/health` endpoint
- ✅ Client availability
- ✅ Container logs for errors

---

## Production Deployment

### Pre-Production Checklist

- [ ] Update `JWT_SECRET` in `.env.docker`
- [ ] Set `NODE_ENV=production`
- [ ] Configure production MongoDB connection
- [ ] Set `REACT_APP_API_URL` to production backend
- [ ] Enable HTTPS for client
- [ ] Configure logging for all services
- [ ] Set up monitoring and alerting

### Environment Configuration (.env.docker)

```bash
# Security
JWT_SECRET=your-super-secret-key-minimum-32-chars

# Database
MONGO_URI=mongodb+srv://user:pass@cluster.mongodb.net/petad

# Node Environment
NODE_ENV=production

# Client Configuration
REACT_APP_API_URL=https://api.yourdomain.com

# Server Configuration
PORT=5000
```

### Docker Image Optimization

#### Multi-Stage Build (Advanced)
Create `Dockerfile.server.prod`:
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Runtime stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 5000
CMD ["npm", "run", "server"]
```

### Deployment to Server

#### Using Docker Compose on VPS
```bash
# SSH into server
ssh user@your-server.com

# Clone repository
git clone https://github.com/your-repo/pet-adoption-platform.git
cd pet-adoption-platform

# Create environment file
nano .env.docker

# Start services
docker compos -f docker compos.yml up -d
```

#### With Nginx Reverse Proxy
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
    }

    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_set_header Host $host;
    }
}
```

---

## Monitoring and Logging

### View Service Metrics
```bash
# CPU and memory usage
docker stats

# Container inspection
docker inspect tailmate-server
```

### Centralized Logging (Optional)
Add to `docker compos.yml`:
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### Health Status
```bash
# Check all services
docker compos ps

# Detailed health info
docker inspect --format='{{json .State.Health}}' tailmate-server | jq
```

---

## Next Steps

1. ✅ Run `docker compos up -d`
2. ✅ Test application at http://localhost:3000
3. ✅ Set up Jenkins pipeline
4. ✅ Configure monitoring
5. ✅ Plan production deployment

---

## Additional Resources

- **Docker Documentation**: https://docs.docker.com/
- **Docker Compose Docs**: https://docs.docker.com/compose/
- **MongoDB Docker**: https://hub.docker.com/_/mongo
- **Node Alpine**: https://hub.docker.com/_/node
- **Jenkins Documentation**: https://www.jenkins.io/doc/

---

**Questions or Issues?** Check troubleshooting section or review service logs with `docker compos logs -f`
