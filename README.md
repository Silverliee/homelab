# 🏠 Homelab - Complete Docker Stack

A comprehensive homelab deployed with Docker Compose, including media services, monitoring, and network management.

## 📋 Table of Contents

- [Overview](#overview)
- [Included Services](#included-services)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Service Access](#service-access)
- [Monitoring](#monitoring)
- [Data Management](#data-management)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project provides a complete homelab solution featuring:
- **Media Management**: Jellyfin, Sonarr, Radarr, Prowlarr
- **Downloads**: qBittorrent, NZBGet, FlareSolverr
- **Monitoring**: Prometheus, Grafana, Node Exporter, cAdvisor
- **Management**: Portainer, Traefik

## 🛠️ Included Services

### Container Management
- **Portainer**: Web interface for managing Docker containers

### Network & Proxy
- **Traefik**: Reverse proxy and load balancer with dashboard

### Monitoring & Metrics
- **Prometheus**: Metrics collection system
- **Grafana**: Data visualization platform (admin/admin)
- **Node Exporter**: System metrics exporter
- **cAdvisor**: Container metrics collector

### Media Stack
- **Jellyfin**: Personal media server
- **Sonarr**: Automated TV series management
- **Radarr**: Automated movie management
- **Prowlarr**: Indexer manager

### Downloads
- **qBittorrent**: BitTorrent client with web interface
- **NZBGet**: Usenet client
- **FlareSolverr**: Cloudflare solver for bypassing protections

## 🔧 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 4GB RAM
- Sufficient disk space for media and data storage

## 🚀 Installation

1. **Clone the project**
```bash
git clone <your-repo>
cd homelab
```

2. **Create directory structure**
```bash
# Create data directories
mkdir -p data/{portainer,traefik,prometheus,grafana,jellyfin/{config,cache},sonarr,radarr,prowlarr,qbittorrent,nzbget}

# Create storage directories
mkdir -p storage/{media/{movies,series,music},downloads}
```

3. **Set permissions**
```bash
# Set user ownership (PUID=911, PGID=911)
sudo chown -R 911:911 data/ storage/
```

4. **Start services**
```bash
docker-compose up -d
```

## ⚙️ Configuration

### Important Environment Variables
- `PUID=911` and `PGID=911`: User ID for Linuxserver services
- `WEBUI_PORT=8082`: qBittorrent web interface port
- `GF_SECURITY_ADMIN_PASSWORD=admin`: Grafana admin password

### Prometheus Configuration
The `configs/prometheus/prometheus.yml` file configures monitoring targets:
- Prometheus itself (port 9090)
- Node Exporter (port 9100)
- cAdvisor (port 8080)
- Traefik (port 8080)
- Portainer (port 9000)

### Grafana Configuration
- Prometheus datasource automatically configured
- Dashboards provisioned from `configs/grafana/dashboards/`
- Admin interface accessible with admin/admin

## 🌐 Service Access

| Service | URL | Port | Credentials |
|---------|-----|------|-------------|
| Portainer | http://localhost:9000 | 9000 | Set up on first access |
| Traefik Dashboard | http://localhost:8080 | 8080 | - |
| Prometheus | http://localhost:9090 | 9090 | - |
| Grafana | http://localhost:3000 | 3000 | admin/admin |
| Jellyfin | http://localhost:8096 | 8096 | Configure on setup |
| Sonarr | http://localhost:8989 | 8989 | - |
| Radarr | http://localhost:7878 | 7878 | - |
| Prowlarr | http://localhost:9696 | 9696 | - |
| qBittorrent | http://localhost:8082 | 8082 | admin/adminadmin |
| NZBGet | http://localhost:6789 | 6789 | nzbget/tegbzn6789 |
| FlareSolverr | http://localhost:8191 | 8191 | - |

## 📊 Monitoring

### Collected Metrics
- **System**: CPU, memory, disk, network (Node Exporter)
- **Containers**: Docker resource usage (cAdvisor)
- **Services**: Availability and performance (Prometheus)

### Grafana Dashboards
Dashboards are automatically provisioned and include:
- System metrics (Node Exporter)
- Docker container metrics
- Homelab overview

## 💾 Data Management

### Directory Structure
```
homelab/
├── data/                   # Persistent service data
│   ├── grafana/           # Grafana configuration and dashboards
│   ├── prometheus/        # Prometheus database
│   ├── jellyfin/         # Jellyfin configuration
│   └── ...
├── storage/               # Media storage
│   ├── media/            # Movies, series, music
│   └── downloads/        # Temporary downloads
└── configs/              # Configuration files
    ├── grafana/
    ├── prometheus/
    └── traefik/
```

### Backup Recommendations
It's recommended to regularly backup:
- The `data/` directory (service configurations)
- The `configs/` directory (custom configurations)
- Optionally the `storage/media/` directory (media files)

## 🔍 Troubleshooting

### Useful Commands
```bash
# View service logs
docker-compose logs -f <service_name>

# Restart a service
docker-compose restart <service_name>

# Rebuild and restart
docker-compose up -d --force-recreate <service_name>

# Check container status
docker-compose ps
```

### Common Issues

**Permission Errors**
```bash
sudo chown -R 911:911 data/ storage/
```

**Ports Already in Use**
Check if ports are used by other services:
```bash
sudo netstat -tulpn | grep :<port>
```

**DNS Resolution Issues**
Some services use Google DNS (8.8.8.8) to resolve connectivity problems.

### Important Logs to Check
- Traefik: Proxy and routing issues
- Prometheus: Metrics collection errors
- *arr Services: Download and indexing problems

## 🔒 Security Notes

- Change default passwords in production environments
- Consider using environment files for sensitive data
- Implement proper firewall rules
- Use HTTPS with proper certificates in production

## 🚀 Getting Started Tips

1. **First Setup Order**:
   - Start with Portainer for container management
   - Configure Traefik for reverse proxy
   - Set up monitoring stack (Prometheus + Grafana)
   - Configure media services as needed

2. **Initial Configuration**:
   - Access Grafana and explore pre-configured dashboards
   - Set up Jellyfin media libraries
   - Configure download clients and indexers
   - Connect *arr services to download clients

## 🤝 Contributing

Feel free to open issues or propose improvements!

## 📝 Notes

- Data is stored in the `data/` directory (ignored by Git)
- Change default passwords in production
- Adapt paths according to your environment
- Check directory permissions if encountering issues
- Services use a custom bridge network called `homelab`
