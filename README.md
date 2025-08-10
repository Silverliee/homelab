# 🏠 Homelab - Modular Docker Stack

A comprehensive homelab solution with modular architecture, deployed with Docker Compose. Features automatic permissions management and multi-stack organization for optimal maintainability.

## 📋 Table of Contents

- [Security Disclaimer](#-security-disclaimer)
- [Overview](#-overview)
- [Architecture](#-architecture)
- [Quick Start](#-quick-start)
- [Included Services](#-included-services)
- [Prerequisites](#-prerequisites)
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
- **🎬 Media Management**: Jellyfin with automated acquisition (Sonarr/Radarr)
- **⬇️ Download Management**: qBittorrent + NZBGet with indexer management
- **🌐 Reverse Proxy**: Traefik for unified access and load balancing

## 🏗️ Architecture

### Stack Organization

The homelab is organized into **4 modular stacks**:

#### 🔧 Infrastructure Stack
**Core services and networking**
- **Portainer**: Docker container management interface
- **Traefik**: Reverse proxy and load balancer
- **FlareSolverr**: Cloudflare bypass for indexers

#### 📊 Monitoring Stack
**Observability and metrics**
- **Prometheus**: Metrics collection and storage
- **Grafana**: Data visualization and dashboards
- **Node Exporter**: System metrics collection
- **cAdvisor**: Container metrics collection

#### 🎬 Media Stack
**Media server and content management**
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

## 🚀 Quick Start

### 1. Clone and Initialize
```bash
git clone <your-repo-url>
cd homelab

# Run the initialization script (Linux only)
chmod +x init-permissions.sh
./init-permissions.sh
```

### 2. Start All Services
```bash
# Start everything at once
docker-compose up -d

# Or start individual stacks
cd stacks/infrastructure && docker-compose up -d
cd ../monitoring && docker-compose up -d
```

### 3. Access Services
- **Portainer**: http://localhost:9000
- **Grafana**: http://localhost:3000 (admin/admin)
- **Jellyfin**: http://localhost:8096

## 🛠️ Included Services

### Infrastructure & Management
| Service | Port | Purpose |
|---------|------|---------|
| Portainer | 9000 | Docker management interface |
| Traefik | 8080 | Reverse proxy dashboard |

### Monitoring & Observability
| Service | Port | Purpose |
|---------|------|---------|
| Prometheus | 9090 | Metrics collection |
| Grafana | 3000 | Data visualization |
| Node Exporter | 9100 | System metrics |
| cAdvisor | 8081 | Container metrics |

### Media & Entertainment
| Service | Port | Purpose |
|---------|------|---------|
| Jellyfin | 8096 | Media streaming server |
| Sonarr | 8989 | TV series automation |
| Radarr | 7878 | Movie automation |
| Prowlarr | 9696 | Indexer management |

### Downloads & Acquisition
| Service | Port | Purpose |
|---------|------|---------|
| qBittorrent | 8082 | BitTorrent client |
| NZBGet | 6789 | Usenet client |
| FlareSolverr | 8191 | Cloudflare solver |

## 🔧 Prerequisites

- **Operating System**: Linux (Ubuntu, Debian, Raspberry Pi OS, etc.)
- **Docker Engine**: 20.10+
- **Docker Compose**: v2.0+
- **System Resources**: 4GB+ RAM, sufficient storage for media
- **Permissions**: sudo access for initialization script

## 📦 Installation

### Automatic Installation (Recommended)

```bash
# 1. Clone repository
git clone <your-repo-url>
cd homelab

# 2. Run initialization script
chmod +x init-permissions.sh
./init-permissions.sh
```

**The initialization script automatically:**
- ✅ Creates all required directories with proper permissions
- ✅ Sets up users for both LinuxServer and official Docker images
- ✅ Configures ACLs for cross-container file access
- ✅ Generates .env file with correct UID/GID mappings
- ✅ Handles mixed image compatibility (PUID/PGID vs fixed UIDs)

### Manual Installation

If you prefer manual setup:

```bash
# 1. Create directory structure
mkdir -p {data,storage,configs}
mkdir -p data/{portainer,traefik,prometheus,grafana,jellyfin/{config,cache},sonarr,radarr,prowlarr,qbittorrent,nzbget}
mkdir -p storage/{downloads,media/{movies,series,music}}
mkdir -p configs/{traefik,prometheus,grafana/{datasources,dashboard-configs,dashboards}}

# 2. Set permissions
sudo chown -R 911:911 data/ storage/
sudo chown -R 472:911 data/grafana
sudo chown -R 65534:911 data/prometheus

# 3. Create .env file
cp .env.example .env
# Edit .env with your values
```

## 🎛️ Stack Management

### Full Stack Operations
```bash
# Start all stacks
docker-compose up -d

# Stop all stacks  
docker-compose down

# View all services
docker-compose ps

# Follow logs for all services
docker-compose logs -f
```

### Individual Stack Operations
```bash
# Start specific stack
cd stacks/infrastructure
docker-compose up -d

# Restart stack services
docker-compose restart

# View stack logs
docker-compose logs -f

# Stop stack
docker-compose down
```

### Recommended Startup Order
1. **Infrastructure** (networking and management)
2. **Monitoring** (observability)
3. **Download** (acquisition services)
4. **Media** (content management)

## 🌐 Service Access

### Default Credentials

| Service | Username | Password | Notes |
|---------|----------|----------|-------|
| Grafana | admin | admin | Change on first login |
| qBittorrent | admin | adminadmin | Default LinuxServer credentials |
| NZBGet | nzbget | tegbzn6789 | Default LinuxServer credentials |

### Configuration Files

Service configurations are stored in:
- **Traefik**: `configs/traefik/`
- **Prometheus**: `configs/prometheus/prometheus.yml`
- **Grafana**: `configs/grafana/`

## 📊 Monitoring

### Available Dashboards
- **System Overview**: Node metrics, CPU, memory, disk usage
- **Container Metrics**: Docker container resource usage
- **Service Health**: Application-specific monitoring

### Accessing Metrics
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000
- **cAdvisor**: http://localhost:8081

### Key Metrics Monitored
- System resources (CPU, RAM, disk, network)
- Container resource usage and health
- Service availability and response times
- Docker daemon metrics

## 🔍 Troubleshooting

### Common Issues

**Permission Errors**
```bash
# Re-run the initialization script
./init-permissions.sh

# Or fix manually
sudo chown -R 911:911 data/ storage/
```

**Service Won't Start**
```bash
# Check service logs
docker-compose logs <service-name>

# Restart specific service
docker-compose restart <service-name>

# Rebuild service
docker-compose up -d --force-recreate <service-name>
```

**Port Conflicts**
```bash
# Check what's using a port
sudo netstat -tulpn | grep :<port>

# Modify port in .env file and restart
```

**Network Issues**
```bash
# Recreate network
docker network rm homelab
docker-compose up -d
```

### Useful Commands

```bash
# View all containers
docker ps -a

# Check container resource usage
docker stats

# View container logs
docker logs <container-name>

# Execute command in container
docker exec -it <container-name> /bin/bash

# Cleanup unused images and volumes
docker system prune -a
```

### Log Locations

Container logs are accessible via:
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs <service-name>

# Follow logs in real-time
docker-compose logs -f <service-name>
```

## 🔧 Customization

### Environment Variables

The `.env` file contains all configurable variables:

```bash
# User IDs (automatically configured)
PUID=911
PGID=911

# Paths
DATA_PATH=./data
STORAGE_PATH=./storage
CONFIG_PATH=./configs

# Service settings
WEBUI_PORT=8082
PROMETHEUS_RETENTION=15d
EXTERNAL_DNS=8.8.8.8
```

### Adding New Services

1. Choose appropriate stack directory
2. Add service to stack's `docker-compose.yml`
3. Update initialization script if needed
4. Restart stack

### Modifying Existing Services

1. Edit service configuration in respective stack
2. Restart affected stack
3. Verify service health in monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test changes thoroughly
4. Submit a pull request

### Development Guidelines

- Follow existing code structure
- Update documentation for changes
- Test permission handling
- Verify cross-platform compatibility where applicable

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- LinuxServer.io for excellent Docker images
- The open-source community for the amazing tools
- Docker team for containerization technology