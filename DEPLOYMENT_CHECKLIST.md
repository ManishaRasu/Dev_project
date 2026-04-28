# Docker Deployment Checklist

## Pre-Deployment Requirements

### Local Testing
- [ ] All services run successfully: `docker compos up -d`
- [ ] Frontend accessible at http://localhost:3000
- [ ] Backend accessible at http://localhost:5000/
- [ ] API health check passes: http://localhost:5000/health
- [ ] MongoDB is connected and working
- [ ] No build errors in console
- [ ] All environment variables are set correctly

### Security Configuration
- [ ] JWT_SECRET is strong (32+ characters, changed from default)
- [ ] No sensitive data committed to repository
- [ ] .env files are in .gitignore
- [ ] Docker registry credentials are secure
- [ ] MONGO_PASSWORD is changed from default

### Testing & Validation
- [ ] User authentication works
- [ ] Pet listing and filtering works
- [ ] Adopt/Buy functionality works
- [ ] Admin dashboard accessible
- [ ] Chat functionality works
- [ ] Image upload works
- [ ] Database persistence works (data survives restart)

---

## Development Environment Setup

### Initial Setup
```bash
# Clone repository
git clone <repo-url>
cd pet-adoption-platform

# Copy environment template
cp .env.docker.example .env.docker

# Update variables as needed
nano .env.docker
```

### Build & Run
```bash
# Build images
docker compos build

# Start services
docker compos up -d

# Verify services
docker compos ps
```

### Verification
- [ ] `docker compos ps` shows all 3 containers running
- [ ] MongoDB logs show successful startup
- [ ] Server logs show "Connected to MongoDB"
- [ ] Client logs show React is running
- [ ] No error messages in logs

---

## CI/CD Pipeline Setup (Jenkins)

### Jenkins Configuration
- [ ] Jenkins server is running
- [ ] Docker and Docker Compose are installed on Jenkins agent
- [ ] Jenkins has permission to run docker commands
- [ ] Git plugin is installed
- [ ] Pipeline plugin is installed

### Jenkinsfile Setup
- [ ] Jenkinsfile is in repository root
- [ ] Pipeline job points to Jenkinsfile
- [ ] Build triggers are configured (webhook or poll SCM)
- [ ] Build notifications are configured

### Pipeline Testing
- [ ] First build completes successfully
- [ ] All pipeline stages execute
- [ ] Health checks pass during build
- [ ] Services are healthy after deployment
- [ ] Logs show no errors

---

## Production Deployment

### Pre-Production
- [ ] Production server has Docker installed
- [ ] Production server has Docker Compose installed
- [ ] Production server has sufficient disk space
- [ ] Firewall rules allow ports 3000, 5000
- [ ] SSL/TLS certificates are ready
- [ ] Backup strategy is in place

### Configuration
- [ ] Production .env.docker created with all variables
- [ ] MongoDB credentials are strong and unique
- [ ] JWT_SECRET is unique and strong
- [ ] REACT_APP_API_URL points to production domain
- [ ] MONGO_URI points to production database

### Deployment
```bash
# On production server
git clone <repo-url>
cd pet-adoption-platform

# Create .env.docker with production values
nano .env.docker

# Build production images
docker compos -f docker compos.prod.yml build

# Start services
docker compos -f docker compos.prod.yml up -d

# Verify services
docker compos -f docker compos.prod.yml ps
```

### Post-Deployment Verification
- [ ] All services are running and healthy
- [ ] Frontend loads at production URL
- [ ] API responds to requests
- [ ] Database is accessible and initialized
- [ ] Health endpoints return 200
- [ ] Logs show no errors
- [ ] SSL certificates are valid (if using HTTPS)

### Monitoring Setup
- [ ] Container logs are being collected
- [ ] Resource usage is being monitored
- [ ] Error alerts are configured
- [ ] Health check alerts are configured
- [ ] Backup jobs are running

---

## Maintenance Tasks

### Regular Checks (Daily)
- [ ] Services are running: `docker compos ps`
- [ ] No error logs: `docker compos logs --tail=50`
- [ ] Health endpoints responding
- [ ] Database backups completed

### Weekly Maintenance
- [ ] Review logs for warnings
- [ ] Check disk space usage
- [ ] Verify backups are working
- [ ] Monitor resource usage

### Monthly Maintenance
- [ ] Update base images: `docker pull mongo:7.0`, etc.
- [ ] Rebuild Docker images with latest dependencies
- [ ] Test disaster recovery procedures
- [ ] Review and rotate credentials

---

## Troubleshooting Scenarios

### Scenario: Services won't start

**Check**:
```bash
docker compos ps
docker compos logs
```

**Common causes**:
- [ ] Port already in use → Change port in docker compos.yml
- [ ] Docker daemon not running → Start Docker Desktop
- [ ] No disk space → Free up space
- [ ] Permission denied → Check Docker permissions

### Scenario: MongoDB connection fails

**Check**:
```bash
docker exec -it tailmate-mongodb mongosh
```

**Common causes**:
- [ ] MongoDB not started → `docker compos up -d mongodb`
- [ ] Connection string wrong → Check MONGO_URI
- [ ] Authentication failed → Check MONGO_USER and MONGO_PASSWORD
- [ ] Network issue → Check network: `docker network ls`

### Scenario: API calls fail from frontend

**Check**:
```bash
curl http://localhost:5000/health
docker compos logs server
```

**Common causes**:
- [ ] Server not running → `docker compos up -d server`
- [ ] CORS not configured → Check server CORS settings
- [ ] API URL wrong → Check REACT_APP_API_URL
- [ ] Network isolation → Check docker network

### Scenario: Hot reload not working

**Solution**:
```bash
docker compos down -v
docker compos build --no-cache
docker compos up -d
```

---

## Rollback Procedures

### If deployment fails
```bash
# Stop current services
docker compos down

# Revert to previous code
git checkout <previous-commit>

# Rebuild and restart
docker compos build
docker compos up -d
```

### If database corrupted
```bash
# Backup current database
docker exec -it tailmate-mongodb mongodump --out /data/backup

# Remove volumes (WARNING: deletes data)
docker compos down -v

# Restart clean
docker compos up -d
```

---

## Documentation & Handover

### Create runbooks for:
- [ ] Starting services for the day
- [ ] Emergency shutdown procedures
- [ ] Failure response procedures
- [ ] Password rotation procedures
- [ ] Backup and restore procedures

### Team training:
- [ ] All team members can start/stop services
- [ ] Support team knows how to access logs
- [ ] Dev team understands Docker Compose setup
- [ ] Ops team can perform basic troubleshooting

---

## Performance & Scaling

### Current Setup Limits
- Single server deployment
- No load balancing
- No database replication
- All services on one machine

### For High Traffic:
- [ ] Set up Docker Swarm or Kubernetes
- [ ] Add load balancer (nginx, HAProxy)
- [ ] Replicate MongoDB
- [ ] Scale services horizontally
- [ ] Add caching layer (Redis)

---

**Last Updated**: 2024-04-16  
**Version**: 1.0

Use this checklist before each deployment to ensure nothing is missed!
