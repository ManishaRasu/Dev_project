# Next Milestones - Step-by-Step Guide

## Overview
This guide walks you through the next phase of your project:
1. Git version control setup
2. Jenkins CI/CD integration
3. Production deployment
4. Monitoring & logging
5. Automated backups

---

# 📌 MILESTONE 1: Git Version Control Setup

## Why Git?
- Track code changes
- Enable team collaboration
- Required for Jenkins CI/CD
- Version history & rollback capability

## Step 1: Initialize Git Repository

### On Windows (PowerShell)
```powershell
cd e:\pet_adoption_platform
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### On Mac/Linux
```bash
cd ~/pet_adoption_platform
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

## Step 2: Create .gitignore File

```bash
# Already exists, verify it contains:
node_modules/
.env
.env.docker
.env.prod
*.log
.DS_Store
/build
/dist
docker compos.override.yml
```

If `.gitignore` doesn't exist, create it with the content above.

## Step 3: Stage All Files
```bash
git add .
```

## Step 4: Create Initial Commit
```bash
git commit -m "Initial commit: Pet adoption platform with Docker Compose setup"
```

## Step 5: Create GitHub Account & Repository

### A. Create GitHub Account
1. Go to https://github.com/signup
2. Create free account
3. Verify your email

### B. Create New Repository
1. Go to https://github.com/new
2. Repository name: `pet-adoption-platform`
3. Description: `Pet adoption platform with Docker Compose`
4. Set to **Public** (free) or **Private** (requires paid account)
5. Click **Create repository**

## Step 6: Connect Local to GitHub

### Copy your repository URL from GitHub (looks like: https://github.com/YOUR-USERNAME/pet-adoption-platform.git)

```bash
git remote add origin https://github.com/YOUR-USERNAME/pet-adoption-platform.git
git branch -M main
git push -u origin main
```

You'll be prompted for GitHub credentials. Enter your GitHub username and personal access token.

## Step 7: Create GitHub Personal Access Token (if needed)

1. Go to https://github.com/settings/tokens
2. Click **Generate new token**
3. Select scopes: `repo`, `workflow`
4. Click **Generate token**
5. **Copy the token** (you'll only see it once!)
6. Use this token as your password when git asks

## ✅ Verification
```bash
# Verify remote is set
git remote -v

# Should show:
# origin  https://github.com/YOUR-USERNAME/pet-adoption-platform.git (fetch)
# origin  https://github.com/YOUR-USERNAME/pet-adoption-platform.git (push)

# Verify code is on GitHub
# Visit https://github.com/YOUR-USERNAME/pet-adoption-platform
```

---

# 🔄 MILESTONE 2: Jenkins CI/CD Integration

## Why Jenkins?
- Automate build & deployment
- Run tests automatically
- Deploy on every code push
- Email notifications on failures

## Step 1: Install Jenkins

### Option A: Docker (Easiest)

```bash
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  --name jenkins \
  jenkins/jenkins:lts
```

Get initial admin password:
```bash
docker logs jenkins | grep -A 7 "Jenkins initial setup is required"
# Or manual: docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Option B: Direct Install
- **Windows**: Download from https://www.jenkins.io/download/
- **Mac**: `brew install jenkins-lts`
- **Linux**: Follow https://www.jenkins.io/doc/book/installing-jenkins/

### Option C: Cloud Jenkins (Jenkins as a Service)
- CloudBees: https://www.cloudbees.com/
- No installation needed, web-based

## Step 2: Access Jenkins

1. Open browser: http://localhost:8080
2. Enter the initial admin password (from Step 1)
3. Click **Install suggested plugins** (wait 5-10 minutes)
4. Create admin user:
   - Username: `admin`
   - Password: `strong-password`
   - Full name: `Your Name`
   - Email: `your.email@example.com`

## Step 3: Install Required Plugins

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Search and install:
   - ✅ **Docker** (if not already installed)
   - ✅ **Docker Compose**
   - ✅ **Git** (usually pre-installed)
   - ✅ **GitHub** (for webhooks)
   - ✅ **Email Extension** (for notifications)
3. Click **Download now and install after restart**
4. Check **Restart Jenkins when installation is complete**

## Step 4: Configure Docker in Jenkins

### If Jenkins is in Docker:

```bash
# Give Jenkins access to Docker
docker exec jenkins usermod -aG docker jenkins

# Restart Jenkins
docker restart jenkins
```

### If Jenkins is on host:

1. Go to **Manage Jenkins** → **Configure System**
2. Find **Docker** section
3. Click **Docker** → **Add Docker**
4. Set Docker URL: `unix:///var/run/docker.sock`
5. Click **Test Connection** → Should succeed
6. Click **Save**

## Step 5: Create New Pipeline Job

1. Click **New Item**
2. Enter name: `pet-adoption-deployment`
3. Select **Pipeline**
4. Click **OK**

## Step 6: Configure Pipeline Job

### General Settings
- Check: **GitHub project**
- Project URL: `https://github.com/YOUR-USERNAME/pet-adoption-platform`

### Build Triggers
- Check: **GitHub hook trigger for GITScm polling**
  (This triggers build on every push)

### Pipeline Settings
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/YOUR-USERNAME/pet-adoption-platform.git`
- Branch: `*/main`
- Script Path: `Jenkinsfile`

### Click **Save**

## Step 7: Set Up GitHub Webhook (Auto-trigger builds)

### A. Configure Jenkins

1. Go to **Manage Jenkins** → **Configure System**
2. Find **GitHub** section
3. Click **Add GitHub Server**
4. Leave URL as is: `https://api.github.com`
5. Click **Credentials** → **Add** → **Jenkins**
6. Kind: **GitHub Personal Access Token**
7. Token: Paste your GitHub token from earlier
8. ID: `github-token`
9. Click **Add Credentials**
10. Select the new credential from dropdown
11. Click **Test connection** → Should say "Credentials verified"
12. Click **Save**

### B. Configure GitHub Webhook

1. Go to your GitHub repo: https://github.com/YOUR-USERNAME/pet-adoption-platform
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Payload URL: `http://your-jenkins-server:8080/github-webhook/`
   - If local: `http://localhost:8080/github-webhook/`
   - If remote: Use your public IP or domain
4. Content type: `application/json`
5. Events: Select **Push events**
6. Click **Add webhook**

## Step 8: Test the Pipeline

### A. Manual Trigger
1. Go to Jenkins job: `pet-adoption-deployment`
2. Click **Build Now**
3. Watch the build in real-time
4. Should see all stages execute

### B. Automatic Trigger
1. Make a code change locally:
   ```bash
   echo "# Updated" >> README.md
   git add .
   git commit -m "Test webhook trigger"
   git push origin main
   ```
2. Watch Jenkins automatically trigger the build
3. Check Jenkins console for build output

## ✅ Verification

```bash
# Check Jenkins logs
docker logs jenkins  # If using Docker

# Verify job ran
# Go to Jenkins UI → View build history
```

---

# 🌍 MILESTONE 3: Production Deployment

## Why Production?
- Run your application for real users
- Different from local development
- Requires security & performance considerations

## Prerequisites
- A server/VPS (AWS, DigitalOcean, Azure, etc.)
- SSH access to server
- Domain name (optional but recommended)

## Step 1: Get a Production Server

### Option A: Cloud Providers (Recommended for beginners)
- **DigitalOcean Droplet** ($5/month): https://www.digitalocean.com/
- **AWS EC2** (free tier available): https://aws.amazon.com/ec2/
- **Linode** ($5/month): https://www.linode.com/
- **Hetzner** (€3/month): https://www.hetzner.com/

### Option B: On-Premises
- Your own server/computer running 24/7
- Requires: Ubuntu/CentOS, static IP, port forwarding

### Recommended Specs (minimum)
- **OS**: Ubuntu 20.04 LTS or later
- **CPU**: 2 cores
- **RAM**: 4GB
- **Storage**: 50GB SSD
- **Network**: 1Mbps upload/download

## Step 2: Install Docker on Production Server

### SSH into your server
```bash
ssh root@your-server-ip
# Or
ssh ubuntu@your-server-ip
```

### Install Docker

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (avoid sudo)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker compos --version
```

## Step 3: Clone Repository on Server

```bash
# Create app directory
mkdir -p /opt/pet-adoption-platform
cd /opt/pet-adoption-platform

# Clone repo
git clone https://github.com/YOUR-USERNAME/pet-adoption-platform.git .

# Verify files
ls -la
```

## Step 4: Create Production Secrets File

```bash
# Create .env.docker with production values
nano .env.docker
```

Add this content (change values):
```bash
# MongoDB Configuration
MONGO_URI=mongodb://mongodb:27017/petad
MONGO_USER=adminuser
MONGO_PASSWORD=super-secure-password-here-change-this

# Server Configuration
PORT=5000
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters

# Client Configuration
REACT_APP_API_URL=https://yourdomain.com  # Or your server IP

# Node Environment
NODE_ENV=production
```

Press `Ctrl+X` → `Y` → `Enter` to save.

## Step 5: Start Services with Production Config

```bash
# Build images
docker compos -f docker compos.prod.yml build

# Start services
docker compos -f docker compos.prod.yml up -d

# Verify services
docker compos -f docker compos.prod.yml ps

# Check logs
docker compos -f docker compos.prod.yml logs
```

## Step 6: Set Up Nginx Reverse Proxy (HTTPS)

### Install Nginx
```bash
sudo apt-get install nginx -y
```

### Create Nginx config
```bash
sudo nano /etc/nginx/sites-available/pet-adoption
```

Add this content:
```nginx
server {
    listen 80;
    server_name your-domain.com;  # Change this

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    # SSL certificates (use Certbot for free certificates)
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    # Front-end
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Back-end API
    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Enable Nginx config
```bash
sudo ln -s /etc/nginx/sites-available/pet-adoption /etc/nginx/sites-enabled/
sudo nginx -t  # Test configuration
sudo systemctl restart nginx
```

### Get Free SSL Certificate (using Certbot)
```bash
sudo apt-get install certbot python3-certbot-nginx -y
sudo certbot certonly --nginx -d your-domain.com
```

## Step 7: Set Up Auto-Start on Reboot

Create systemd service file:
```bash
sudo nano /etc/systemd/system/pet-adoption-docker.service
```

Add this content:
```ini
[Unit]
Description=Pet Adoption Platform Docker Compose
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/pet-adoption-platform
ExecStart=/usr/bin/docker compos -f docker compos.prod.yml up -d
ExecStop=/usr/bin/docker compos -f docker compos.prod.yml down
Restart=unless-stopped

[Install]
WantedBy=multi-user.target
```

Enable service:
```bash
sudo systemctl enable pet-adoption-docker
sudo systemctl start pet-adoption-docker
```

## Step 8: Set Up Automatic Updates

```bash
# Enable unattended security updates
sudo apt-get install unattended-upgrades -y
sudo systemctl enable unattended-upgrades
```

## ✅ Verification

```bash
# Check services running
docker compos -f docker compos.prod.yml ps

# Check logs
docker compos -f docker compos.prod.yml logs -f

# Test API
curl https://your-domain.com/health

# Test website (from browser)
https://your-domain.com
```

---

# 📊 MILESTONE 4: Monitoring & Logging

## Why Monitoring?
- Know when services go down
- Track performance issues
- Alert on errors
- Historical data for debugging

## Step 1: Local Testing - View Logs

```bash
# All logs
docker compos logs -f

# Specific service
docker compos logs -f server
docker compos logs -f client
docker compos logs -f mongodb

# Last 100 lines
docker compos logs --tail=100

# With timestamps
docker compos logs --timestamps
```

## Step 2: Set Up Local Log Rotation

Update `docker compos.yml`:
```yaml
services:
  server:
    # ... existing config ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  client:
    # ... existing config ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  mongodb:
    # ... existing config ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

Then restart:
```bash
docker compos restart
```

## Step 3: Container Resource Monitoring

```bash
# Real-time stats
docker stats

# Specific container
docker stats tailmate-server

# One-time snapshot
docker inspect --format='{{json .State}}' tailmate-server | jq
```

## Step 4: Set Up Prometheus + Grafana (Advanced)

### A. Add Prometheus to docker compos.yml

Create `prometheus.yml`:
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'docker'
    static_configs:
      - targets: ['localhost:9323']
```

Add to `docker compos.yml`:
```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    networks:
      - tailmate-network

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - tailmate-network

volumes:
  prometheus_data:
  grafana_data:
```

### B. Start Monitoring Stack

```bash
docker compos up -d prometheus grafana

# Access Grafana
# http://localhost:3001
# Username: admin
# Password: admin
```

## Step 5: Set Up Email Alerts

### Using simple shell script with cron:

Create `health-check.sh`:
```bash
#!/bin/bash

EMAIL="your-email@example.com"
HOSTNAME=$(hostname)

# Check server health
if ! curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "Server is DOWN on $HOSTNAME at $(date)" | \
    mail -s "ALERT: Pet Adoption Server Down" $EMAIL
fi

# Check MongoDB health
if ! docker exec tailmate-mongodb mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "MongoDB is DOWN on $HOSTNAME at $(date)" | \
    mail -s "ALERT: MongoDB Down" $EMAIL
fi
```

Make executable and add to crontab:
```bash
chmod +x health-check.sh
crontab -e

# Add line:
*/5 * * * * /path/to/health-check.sh
```

---

# 💾 MILESTONE 5: Automated Backups

## Why Backups?
- Protect against data loss
- Meet compliance requirements
- Disaster recovery capability
- Peace of mind

## Step 1: MongoDB Backup Script

Create `backup-mongodb.sh`:
```bash
#!/bin/bash

BACKUP_DIR="/opt/backups/mongodb"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup MongoDB
docker exec tailmate-mongodb mongodump --out /dump_$TIMESTAMP

# Compress backup
docker exec tailmate-mongodb tar czf /dump_$TIMESTAMP.tar.gz /dump_$TIMESTAMP

# Copy to host
docker cp tailmate-mongodb:/dump_$TIMESTAMP.tar.gz $BACKUP_FILE

# Cleanup (remove old backups older than 30 days)
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +30 -delete

# Log backup
echo "Backup completed: $BACKUP_FILE" >> /var/log/mongodb-backups.log

# Optional: Send to cloud storage
# aws s3 cp $BACKUP_FILE s3://your-bucket/pet-adoption/
```

## Step 2: Full Application Backup Script

Create `backup-application.sh`:
```bash
#!/bin/bash

BACKUP_DIR="/opt/backups/application"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

mkdir -p $BACKUP_DIR

# Backup entire application
tar --exclude='node_modules' \
    --exclude='.git' \
    --exclude='docker compos.override.yml' \
    -czf $BACKUP_FILE \
    /opt/pet-adoption-platform

# Keep only last 7 backups
find $BACKUP_DIR -name "backup_*.tar.gz" -type f | sort -r | tail -n +8 | xargs rm -f

echo "Application backup completed: $BACKUP_FILE" >> /var/log/app-backups.log
```

## Step 3: Schedule Backups with Cron

```bash
# Edit crontab
crontab -e

# Add these lines:
# Backup MongoDB daily at 2 AM
0 2 * * * /opt/backup-mongodb.sh

# Backup application daily at 3 AM
0 3 * * * /opt/backup-application.sh

# Weekly full backup (Sunday at 4 AM)
0 4 * * 0 /opt/backup-mongodb.sh && /opt/backup-application.sh
```

## Step 4: Cloud Backup Upload (AWS S3)

### A. Install AWS CLI
```bash
sudo apt-get install awscli -y
```

### B. Configure AWS Credentials
```bash
aws configure
# Enter:
# AWS Access Key ID
# AWS Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### C. Create S3 Upload Script

Update `backup-mongodb.sh` to add:
```bash
# Upload to S3
aws s3 cp $BACKUP_FILE s3://your-bucket-name/pet-adoption/backups/

# Verify upload
if [ $? -eq 0 ]; then
    echo "Successfully uploaded to S3: $BACKUP_FILE"
else
    echo "Failed to upload to S3" | mail -s "ALERT: Backup upload failed" your-email@example.com
fi
```

## Step 5: Restore from Backup

### MongoDB Restore
```bash
# Extract backup
tar xzf /opt/backups/mongodb/backup_2024-04-16_02-00-00.tar.gz

# Restore
docker exec -i tailmate-mongodb mongorestore /dump_2024-04-16_02-00-00
```

### Application Restore
```bash
# Stop services
docker compos down

# Restore files
cd ~
tar xzf /opt/backups/application/backup_2024-04-16_03-00-00.tar.gz

# Restart services
docker compos up -d
```

## ✅ Verification

```bash
# List recent backups
ls -lh /opt/backups/

# Check backup logs
tail -f /var/log/mongodb-backups.log
tail -f /var/log/app-backups.log

# Test restore (on test system)
tar xzf /opt/backups/application/backup_*.tar.gz -C /tmp/
```

---

## 📋 Complete Checklist

### Milestone 1: Git & GitHub
- [ ] Git initialized locally
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] Personal access token created
- [ ] .gitignore configured

### Milestone 2: Jenkins CI/CD
- [ ] Jenkins installed and running
- [ ] Docker plugin installed
- [ ] Pipeline job created
- [ ] GitHub webhook configured
- [ ] Automatic builds triggering on push
- [ ] All 7 pipeline stages passing

### Milestone 3: Production Deployment
- [ ] Production server provisioned
- [ ] Docker installed on server
- [ ] Repository cloned on server
- [ ] Production env file created
- [ ] Services running with prod config
- [ ] Nginx reverse proxy configured
- [ ] SSL certificate installed
- [ ] Auto-start on reboot configured

### Milestone 4: Monitoring & Logging
- [ ] Logs viewable via `docker compos logs`
- [ ] Log rotation configured
- [ ] Resource monitoring set up
- [ ] Email alerts configured
- [ ] (Optional) Prometheus + Grafana running

### Milestone 5: Backups
- [ ] Backup scripts created
- [ ] MongoDB backup working
- [ ] Application backup working
- [ ] Cron jobs scheduled
- [ ] S3 upload working (optional)
- [ ] Restore procedure tested

---

**Ready to start? Pick a milestone and follow the steps!** 🚀
