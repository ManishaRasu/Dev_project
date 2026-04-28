# Docker Daemon Not Running - Fix Guide

## The Problem
You see this error:
```
failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine
The system cannot find the file specified.
```

**What this means**: Docker Desktop is installed but not running.

---

## Solution for Windows

### Step 1: Start Docker Desktop
1. **Look at your system tray** (bottom-right corner of screen)
2. **Find the Docker whale icon** 🐳 - if not there, continue to Step 2
3. **Click the whale icon** to open Docker Desktop
4. **Wait 30-60 seconds** for Docker to fully start
   - You'll see "Docker is running" message
   - The whale icon will be steady (not grayed out)

### Step 2: If Docker Desktop isn't in system tray
1. Click **Windows Start button**
2. Type: `Docker` 
3. Click **Docker Desktop** in search results
4. A window will open - **wait for "Docker is running" message**
5. Close the window when ready

### Step 3: Verify Docker is running
Open PowerShell and run:
```powershell
docker ps
```

You should see output like:
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

If you see an error, Docker isn't fully started yet. Wait another 30 seconds.

### Step 4: Run the quickstart script
```powershell
.\quickstart.bat
```

---

## Solution for Mac

### Step 1: Start Docker Desktop
1. Open **Applications** folder
2. Find and double-click **Docker.app**
3. **Wait for the whale icon** to appear in the menu bar (top-right)
4. Click the whale icon → you should see "Docker is running"

### Step 2: Verify Docker is running
Open Terminal and run:
```bash
docker ps
```

### Step 3: Run the quickstart script
```bash
chmod +x quickstart.sh
./quickstart.sh
```

---

## Solution for Linux

### For Ubuntu/Debian
```bash
# Start Docker service
sudo systemctl start docker

# Verify it's running
docker ps

# (Optional) Enable auto-start on boot
sudo systemctl enable docker

# (Optional) Add your user to docker group (avoid sudo)
sudo usermod -aG docker $USER
newgrp docker
```

### For other Linux distributions
Refer to your package manager's Docker documentation.

### Run the quickstart script
```bash
chmod +x quickstart.sh
./quickstart.sh
```

---

## Quick Checklist

- [ ] Docker Desktop application is **open** (not just installed)
- [ ] Docker whale icon appears in system tray/menu bar
- [ ] `docker ps` command works without errors
- [ ] No "Docker daemon is not running" error message
- [ ] `.env.docker` file exists in project directory
- [ ] Run `.\quickstart.bat` or `./quickstart.sh`

---

## Verify Everything is Working

After starting Docker, test the setup:

```bash
# Check Docker is running
docker ps

# Check Docker Compose
docker compos --version

# Try running quickstart
.\quickstart.bat  # Windows
./quickstart.sh   # Mac/Linux
```

---

## Still Having Issues?

Try these commands to debug:

### Windows
```powershell
# Check if Docker service is actually running
Get-Service -Name Docker

# Restart Docker Desktop completely
# 1. Close Docker Desktop
# 2. Search for "Task Manager"
# 3. Find any remaining "docker" processes
# 4. Right-click → End Task
# 5. Reopen Docker Desktop app
```

### Mac/Linux
```bash
# Check Docker socket
ls -la /var/run/docker.sock

# Restart Docker
sudo systemctl restart docker  # Linux
# (Mac: Click whale icon menu → Restart)

# Check Docker logs
docker info
```

### All Platforms
```bash
# Run Docker health check
docker run hello-world

# If successful, you'll see:
# Hello from Docker!
# This message shows that your Docker installation is working correctly.
```

---

## If Docker isn't installed

Download and install Docker Desktop:
- **Windows**: https://www.docker.com/products/docker-desktop
- **Mac**: https://www.docker.com/products/docker-desktop
- **Linux**: Follow your package manager instructions

---

**Once Docker is running, come back and run the quickstart script!** 🚀
