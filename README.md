# 🏠 Homelab - Modular Docker Stack

A comprehensive homelab solution with modular architecture, deployed with Docker Compose. Features automatic permissions management, multi-stack organization, and Makefile automation for optimal maintainability.

## 📋 Table of Contents

- [Security Disclaimer](#-security-disclaimer)
- [Overview](#-overview)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Makefile Commands](#-makefile-commands)
- [Included Services](#-included-services)
- [Installation](#-installation)
- [Stack Management](#-stack-management)
- [Service Access](#-service-access)
- [Monitoring](#-monitoring)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## ⚠️ Security Disclaimer

**IMPORTANT: This configuration is designed for LOCAL NETWORK USE ONLY.**

This homelab setup is intended for your private network and **should NOT be exposed to the internet** without proper security hardening. Services use default credentials and minimal security configurations.

## 🎯 Overview

This project provides a modular homelab solution featuring:
- **🏗️ Modular Architecture**: Organized in logical stacks for easy management
- **🔧 Automatic Setup**: Script-based initialization with proper permissions
- **📊 Complete Monitoring**: Prometheus + Grafana observability stack
- **🎬 Media Management**: Jellyseerr + Jellyfin with automated acquisition (Sonarr/Radarr)
- **⬇️ Download Management**: qBittorrent + NZBGet with indexer management
- **🌐 Reverse Proxy**: nginx-proxy-manager for unified access and load balancing
- **⚡ Makefile Automation**: Simplified commands for all operations

## 🏗️ Architecture

### Stack Organization

The homelab is organized into **4 modular stacks**:

#### 🔧 Infrastructure Stack
**Core services and networking**
- **Homarr**: Main dashboard for homalab services 
- **Portainer**: Docker container management interface
- **nginx-proxy-manager**: Reverse proxy and load balancer
- **FlareSolverr**: Cloudflare bypass for indexers

#### 📊 Monitoring Stack
**Observability and metrics**
- **Prometheus**: Metrics collection and storage
- **Grafana**: Data visualization and dashboards
- **Node Exporter**: System metrics collection
- **cAdvisor**: Container metrics collection

#### 🎬 Media Stack
**Media server and content management**
- **Jellyseerr**: Media library manager
- **Jellyfin**: Personal media streaming server
- **Sonarr**: Automated TV series management
- **Radarr**: Automated movie management
- **Prowlarr**: Indexer management and integration

#### ⬇️ Download Stack
**Download clients and management**
- **qBittorrent**: BitTorrent client with web interface
- **NZBGet**: Usenet/NZB download client

### Directory Structure

```
homelab/
├── Makefile                    # Task automation
├── stacks/                     # Modular stack definitions
│   ├── infrastructure/
│   │   └── docker-compose.yml
│   ├── monitoring/
│   │   └── docker-compose.yml  
│   ├── media/
│   │   └── docker-compose.yml
│   └── download/
│       └── docker-compose.yml
├── data/                       # Persistent service data
├── storage/                    # Media and download storage
├── configs/                    # Service configurations
├── docker-compose.yml          # Main orchestration file
├── init-permissions.sh         # Automatic setup script
└── .env                        # Environment variables (auto-generated)
```

## 🔧 Prerequisites

- **Operating System**: Linux (Ubuntu, Debian, Raspberry Pi OS, etc.)
- **Docker Engine**: 20.10+
- **Docker Compose**: v2.0+
- **Make**: GNU Make utility
- **System Resources**: 4GB+ RAM, sufficient storage for media
- **Permissions**: sudo access for initialization script

### Installing Make

**Ubuntu/Debian/Raspberry Pi OS:**
```bash
sudo apt update
sudo apt install make
```

**CentOS/RHEL/Fedora:**
```bash
sudo dnf install make
```

**Check if already installed:**
```bash
make --version
```

## 🚀 Quick Start

### 1. Clone and Initialize
```bash
git clone <your-repo-url>
cd homelab

# Initialize the homelab (creates directories, sets permissions, generates .env)
make init
```

### 2. Start Services
```bash
# Start all services
make up

# Or start in recommended order
make start-ordered

# Check status
make status
```

### 3. Access Services
- **Homarr**: http://localhost:7575
- **Portainer**: http://localhost:9000
- **Grafana**: http://localhost:3000 (admin/admin)
- **Jellyfin**: http://localhost:8096
- **Jellyseerr**: http://localhost:5055

## ⚡ Makefile Commands

### Daily Operations
```bash
make help           # Show all available commands
make up             # Start all services
make down           # Stop all services
make restart        # Restart all services
make status         # Show services status
make logs           # Show real-time logs
make overview       # Quick status overview
```

### Stack Management
```bash
# Infrastructure stack
make infra-up
make infra-down
make infra-restart
make infra-logs

# Monitoring stack
make monitoring-up
make monitoring-down
make monitoring-restart
make monitoring-logs

# Media stack
make media-up
make media-down
make media-restart
make media-logs

# Download stack
make download-up
make download-down
make download-restart
make download-logs
```

### Maintenance
```bash
make update         # Update Docker images
make cleanup        # Clean unused Docker resources
make backup         # Backup important data
make health         # Check services health
make monitor        # Show resource usage
make disk-usage     # Show disk usage
make validate       # Validate docker-compose files
```

### Advanced Operations
```bash
make start-ordered  # Start stacks in recommended order
make stop-ordered   # Stop stacks in reverse order
make pull-all       # Pull latest images for all stacks
make emergency-stop # Force stop all containers
make network-info   # Show network information

# View logs for specific service
make logs-service SERVICE=jellyfin
```

## 🛠️ Included Services

### Infrastructure & Management
| Service      | Port | Purpose                     | Stack |
|--------------|------|-----------------------------|-------|
| Homarr       | 7575 | Homelab dashboard           | Infrastructure |
| Portainer    | 9000 | Docker management interface | Infrastructure |
| nginx-proxy-manager      | 8080 | Reverse proxy dashboard     | Infrastructure |
| FlareSolverr | 8191 | Cloudflare solver           | Infrastructure |

### Monitoring & Observability
| Service | Port | Purpose | Stack |
|---------|------|---------|-------|
| Prometheus | 9090 | Metrics collection | Monitoring |
| Grafana | 3000 | Data visualization | Monitoring |
| Node Exporter | 9100 | System metrics | Monitoring |
| cAdvisor | 8081 | Container metrics | Monitoring |

### Media & Entertainment
| Service   | Port | Purpose                | Stack |
|-----------|------|------------------------|-------|
| Jellyseer | 5055 | Media server manager   | Media |
| Jellyfin  | 8096 | Media streaming server | Media |
| Sonarr    | 8989 | TV series automation   | Media |
| Radarr    | 7878 | Movie automation       | Media |
| Prowlarr  | 9696 | Indexer management     | Media |

### Downloads & Acquisition
| Service | Port | Purpose | Stack |
|---------|------|---------|-------|
| qBittorrent | 8082 | BitTorrent client | Download |
| NZBGet | 6789 | Usenet client | Download |

## 📦 Installation

### Automatic Installation (Recommended)

```bash
# 1. Clone repository
git clone <your-repo-url>
cd homelab

# 2. Initialize everything
make init
```

**The initialization automatically:**
- ✅ Installs Make if not present (on supported systems)
- ✅ Creates all required directories with proper permissions
- ✅ Sets up users for both LinuxServer and official Docker images
- ✅ Configures ACLs for cross-container file access
- ✅ Generates .env file with correct UID/GID mappings
- ✅ Handles mixed image compatibility (PUID/PGID vs fixed UIDs)

### Manual Installation

If you prefer manual setup:

```bash
# 1. Install Make
sudo apt install make  # Ubuntu/Debian

# 2. Create directory structure
mkdir -p {data,storage,configs}
mkdir -p data/{portainer,nginx-proxy-manager,prometheus,grafana,jellyfin/{config,cache},sonarr,radarr,prowlarr,qbittorrent,nzbget}
mkdir -p storage/{downloads,media/{movies,series,music}}
mkdir -p configs/{nginx-proxy-manager,prometheus,grafana/{datasources,dashboard-configs,dashboards}}

# 3. Set permissions
sudo chown -R 911:911 data/ storage/
sudo chown -R 472:911 data/grafana
sudo chown -R 65534:911 data/prometheus

# 4. Create .env file
cp .env.example .env
# Edit .env with your values
```

## 🎛️ Stack Management

### Full Stack Operations
```bash
# Using Makefile (recommended)
make up              # Start all stacks
make down            # Stop all stacks
make restart         # Restart all stacks
make status          # View all services
make logs            # Follow logs for all services

# Traditional docker-compose
docker-compose up -d
docker-compose down
docker-compose ps
docker-compose logs -f
```

### Individual Stack Operations
```bash
# Using Makefile (recommended)
make media-up        # Start media stack
make media-restart   # Restart media stack
make media-logs      # View media stack logs
make media-down      # Stop media stack

# Traditional method
cd stacks/media
docker-compose up -d
docker-compose restart
docker-compose logs -f
docker-compose down
```

### Recommended Startup Order
1. **Infrastructure** (networking and management)
2. **Monitoring** (observability)
3. **Download** (acquisition services)
4. **Media** (content management)

```bash
# Automated startup in order
make start-ordered

# Manual startup
make infra-up
sleep 5
make monitoring-up
sleep 5
make download-up
sleep 5
make media-up
```

## 🌐 Service Access

### Web Interfaces
- **Homarr*: http://localhost:7575 - Homalab dashboard
- **Portainer**: http://localhost:9000 - Docker management
- **nginx-proxy-manager Dashboard**: http://localhost:80 - Proxy status
- **Grafana**: http://localhost:3000 - Monitoring dashboards (admin/admin)
- **Prometheus**: http://localhost:9090 - Metrics collection
- **Jellyseerr**: http://localhost:5055 - Media server manager
- **Jellyfin**: http://localhost:8096 - Media streaming
- **Sonarr**: http://localhost:8989 - TV series management
- **Radarr**: http://localhost:7878 - Movie management
- **Prowlarr**: http://localhost:9696 - Indexer management
- **qBittorrent**: http://localhost:8082 - BitTorrent downloads
- **NZBGet**: http://localhost:6789 - Usenet downloads

### Default Credentials
- **Grafana**: admin/admin (change on first login)
- **qBittorrent**: admin/adminpass (configure in web UI)
- **Other services**: No default credentials required

## 📊 Monitoring

### Built-in Dashboards
The monitoring stack provides comprehensive observability:

- **System Metrics**: CPU, memory, disk, network usage
- **Container Metrics**: Per-container resource consumption
- **Service Health**: Availability and response times
- **Storage Monitoring**: Disk usage and I/O performance

### Accessing Metrics
```bash
# View current resource usage
make monitor

# Check disk usage
make disk-usage

# Check services health
make health

# View detailed logs
make logs-service SERVICE=prometheus
```

### Custom Dashboards
Grafana dashboards are stored in `configs/grafana/dashboards/` and automatically provisioned.

## 🔧 Troubleshooting

### Common Issues

**Services won't start:**
```bash
# Check permissions
make health

# Validate configurations
make validate

# View detailed logs
make logs-service SERVICE=problematic-service
```

**Permission errors:**
```bash
# Re-run initialization
make init

# Check directory ownership
ls -la data/ storage/
```

**Resource issues:**
```bash
# Monitor resource usage
make monitor

# Clean up unused resources
make cleanup
```

**Network connectivity:**
```bash
# Check network configuration
make network-info

# Restart infrastructure stack
make infra-restart
```

### Debugging Commands
```bash
# Emergency stop all containers
make emergency-stop

# View container sizes
make container-sizes

# Validate all configurations
make validate

# Show quick overview
make overview
```

## 🔄 Maintenance

### Regular Maintenance Tasks

**Weekly:**
```bash
make update          # Update Docker images
make backup          # Backup configurations and data
make cleanup         # Clean unused resources
```

**Monthly:**
```bash
make health          # Full health check
make disk-usage      # Storage usage review
make monitor         # Performance review
```

### Backup Strategy
```bash
# Manual backup
make backup

# Backups are stored in backups/ with timestamp
# Includes both data/ and configs/ directories
```

### Updates
```bash
# Update images and restart
make update
make restart

# Or update specific stack
make media-down
make update
make media-up
```

## 📈 Performance Optimization

### Resource Limits
Each service includes resource limits optimized for Raspberry Pi 5:
- Memory limits prevent OOM conditions
- CPU limits ensure fair resource sharing
- Restart policies maintain service availability

### Monitoring Resource Usage
```bash
# Real-time monitoring
make monitor

# Historical data in Grafana
# Access: http://localhost:3000
```

## 🔧 Adding New Services

### To add a service:

1. Choose appropriate stack directory
2. Add service to stack's `docker-compose.yml`
3. Update initialization script if needed
4. Add Makefile targets if desired
5. Restart stack

### Example: Adding a new service to media stack
```bash
# Edit the stack
nano stacks/media/docker-compose.yml

# Restart the stack
make media-restart
```

### Modifying Existing Services

1. Edit service configuration in respective stack
2. Use Makefile to restart affected stack
3. Verify service health in monitoring

```bash
# Edit and restart
nano stacks/monitoring/docker-compose.yml
make monitoring-restart
make health
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test changes thoroughly with `make validate`
4. Update documentation if needed
5. Submit a pull request

### Development Guidelines

- Follow existing code structure
- Update Makefile targets for new features
- Test permission handling
- Update documentation for changes
- Verify cross-platform compatibility where applicable

### Testing Changes
```bash
# Validate configurations
make validate

# Test full restart
make down
make up

# Check health
make health
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- LinuxServer.io for excellent Docker images
- The open-source community for the amazing tools
- Docker team for containerization technology
- GNU Make for task automation