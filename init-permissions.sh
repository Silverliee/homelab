#!/bin/bash

# =============================================================================
# Homelab Permissions Initialization Script
# Handles both LinuxServer images (PUID/PGID) and official images (fixed UIDs)
# =============================================================================

set -e  # Exit on error

echo "🏠 Initializing Homelab permissions..."

# Configuration
DOCKER_USER_ID=${PUID:-911}
DOCKER_GROUP_ID=${PGID:-911}
DOCKER_USER_NAME="dockeruser"
DOCKER_GROUP_NAME="dockergroup"

# Official image UIDs
PROMETHEUS_UID=65534    # nobody user
GRAFANA_UID=472        # grafana user
TRAEFIK_UID=0          # root user

echo "📋 Using configuration:"
echo "   - PUID: $DOCKER_USER_ID (LinuxServer images)"
echo "   - PGID: $DOCKER_GROUP_ID"
echo "   - Prometheus UID: $PROMETHEUS_UID"
echo "   - Grafana UID: $GRAFANA_UID"

# =============================================================================
# 1. Create system users and groups if needed
# =============================================================================

echo "👤 Setting up system users and groups..."

# Create main docker group
if ! getent group $DOCKER_GROUP_ID > /dev/null 2>&1; then
    echo "   Creating group $DOCKER_GROUP_NAME (GID: $DOCKER_GROUP_ID)"
    sudo groupadd -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME
else
    echo "   Group GID $DOCKER_GROUP_ID already exists"
fi

# Create main docker user
if ! getent passwd $DOCKER_USER_ID > /dev/null 2>&1; then
    echo "   Creating user $DOCKER_USER_NAME (UID: $DOCKER_USER_ID)"
    sudo useradd -u $DOCKER_USER_ID -g $DOCKER_GROUP_ID -s /bin/bash -m $DOCKER_USER_NAME
else
    echo "   User UID $DOCKER_USER_ID already exists"
fi

# Ensure prometheus user exists and is in docker group
if ! getent passwd $PROMETHEUS_UID > /dev/null 2>&1; then
    echo "   Creating prometheus user (UID: $PROMETHEUS_UID)"
    sudo useradd -u $PROMETHEUS_UID -g $DOCKER_GROUP_ID -s /bin/false -M prometheus-docker
else
    echo "   Adding existing prometheus user to docker group"
    sudo usermod -a -G $DOCKER_GROUP_ID $(getent passwd $PROMETHEUS_UID | cut -d: -f1)
fi

# Ensure grafana user exists and is in docker group  
if ! getent passwd $GRAFANA_UID > /dev/null 2>&1; then
    echo "   Creating grafana user (UID: $GRAFANA_UID)"
    sudo useradd -u $GRAFANA_UID -g $DOCKER_GROUP_ID -s /bin/false -M grafana-docker
else
    echo "   Adding existing grafana user to docker group"
    sudo usermod -a -G $DOCKER_GROUP_ID $(getent passwd $GRAFANA_UID | cut -d: -f1)
fi

# =============================================================================
# 2. Define directory structure with ownership
# =============================================================================

# LinuxServer containers (use PUID/PGID)
declare -A LINUXSERVER_DIRS=(
    ["data/jellyfin"]="$DOCKER_USER_ID"
    ["data/sonarr"]="$DOCKER_USER_ID"
    ["data/radarr"]="$DOCKER_USER_ID"
    ["data/prowlarr"]="$DOCKER_USER_ID"
    ["data/qbittorrent"]="$DOCKER_USER_ID"
    ["data/nzbget"]="$DOCKER_USER_ID"
)

# Official images with fixed UIDs
declare -A OFFICIAL_DIRS=(
    ["data/prometheus"]="$PROMETHEUS_UID"
    ["data/grafana"]="$GRAFANA_UID"
    ["data/traefik"]="$TRAEFIK_UID"
    ["data/portainer"]="$TRAEFIK_UID"
)

# Shared storage directories (accessible by all)
STORAGE_DIRS=(
    "storage/downloads"
    "storage/downloads/complete"
    "storage/downloads/incomplete"
    "storage/downloads/watch"
    "storage/media"
    "storage/media/movies"
    "storage/media/series"
    "storage/media/music"
    "storage/media/books"
    "storage/backups"
)

# Configuration directories (host managed)
CONFIG_DIRS=(
    "configs/traefik"
    "configs/prometheus"
    "configs/grafana/datasources"
    "configs/grafana/dashboard-configs"
    "configs/grafana/dashboards"
)

# =============================================================================
# 3. Create directories with proper ownership
# =============================================================================

echo "📁 Creating directory structure..."

# Function to create and configure a directory
create_directory() {
    local dir="$1"
    local owner_uid="$2"
    local perms="$3"
    
    if [ ! -d "$dir" ]; then
        echo "   📂 Creating: $dir"
        mkdir -p "$dir"
    fi
    
    echo "   🔧 Configuring: $dir (UID:$owner_uid:$DOCKER_GROUP_NAME $perms)"
    sudo chown -R "$owner_uid:$DOCKER_GROUP_NAME" "$dir"
    sudo chmod -R "$perms" "$dir"
}

# Create LinuxServer directories
echo "📊 LinuxServer directories (PUID/PGID):"
for dir in "${!LINUXSERVER_DIRS[@]}"; do
    create_directory "$dir" "${LINUXSERVER_DIRS[$dir]}" "775"
done

# Create official image directories
echo "🔧 Official image directories (fixed UIDs):"
for dir in "${!OFFICIAL_DIRS[@]}"; do
    create_directory "$dir" "${OFFICIAL_DIRS[$dir]}" "775"
done

# Create shared storage directories (accessible by all containers)
echo "💾 Shared storage directories:"
for dir in "${STORAGE_DIRS[@]}"; do
    create_directory "$dir" "$DOCKER_USER_ID" "775"
    # Add supplementary group access for prometheus and grafana
    sudo setfacl -R -m "u:$PROMETHEUS_UID:rwx" "$dir" 2>/dev/null || true
    sudo setfacl -R -m "u:$GRAFANA_UID:rwx" "$dir" 2>/dev/null || true
done

# Create configuration directories
echo "⚙️ Configuration directories:"
for dir in "${CONFIG_DIRS[@]}"; do
    create_directory "$dir" "root" "755"
done

# =============================================================================
# 4. Setup advanced ACLs for cross-container access
# =============================================================================

if command -v setfacl > /dev/null 2>&1; then
    echo "🔒 Configuring advanced ACLs..."
    
    # Allow all container users to access shared data
    SHARED_DIRS=("${STORAGE_DIRS[@]}")
    
    for dir in "${SHARED_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # LinuxServer user access
            sudo setfacl -R -m "u:$DOCKER_USER_ID:rwx" "$dir"
            sudo setfacl -R -d -m "u:$DOCKER_USER_ID:rwx" "$dir"
            
            # Official image users access
            sudo setfacl -R -m "u:$PROMETHEUS_UID:rwx" "$dir"
            sudo setfacl -R -d -m "u:$PROMETHEUS_UID:rwx" "$dir"
            
            sudo setfacl -R -m "u:$GRAFANA_UID:rwx" "$dir"
            sudo setfacl -R -d -m "u:$GRAFANA_UID:rwx" "$dir"
            
            # Group access
            sudo setfacl -R -m "g:$DOCKER_GROUP_ID:rwx" "$dir"
            sudo setfacl -R -d -m "g:$DOCKER_GROUP_ID:rwx" "$dir"
        fi
    done
    echo "   ✅ ACLs configured for cross-container access"
else
    echo "   ⚠️ ACLs not available - using group permissions only"
fi

# =============================================================================
# 5. Final verification
# =============================================================================

echo "🔍 Final permissions verification..."

check_permissions() {
    local dir="$1"
    if [ -d "$dir" ]; then
        local owner=$(stat -c '%U:%G' "$dir")
        local perms=$(stat -c '%a' "$dir")
        echo "   ✅ $dir → $owner ($perms)"
    else
        echo "   ❌ $dir → DOES NOT EXIST"
    fi
}

echo "📊 Checking critical directories:"
check_permissions "data/jellyfin"
check_permissions "data/prometheus"
check_permissions "data/grafana"
check_permissions "storage/downloads"
check_permissions "storage/media"

# =============================================================================
# 6. Create .env file with image-specific variables
# =============================================================================

echo "🌐 Creating .env file..."

cat > .env << EOF
# =============================================================================
# Homelab Environment Variables
# Auto-generated by init-permissions.sh
# =============================================================================

# LinuxServer images (PUID/PGID supported)
PUID=$DOCKER_USER_ID
PGID=$DOCKER_GROUP_ID

# Official image UIDs (fixed, cannot be changed)
PROMETHEUS_UID=$PROMETHEUS_UID
GRAFANA_UID=$GRAFANA_UID
TRAEFIK_UID=$TRAEFIK_UID

# Timezone
TZ=Europe/Paris

# Base paths
DATA_PATH=./data
STORAGE_PATH=./storage
CONFIG_PATH=./configs

# Grafana configuration
GF_SECURITY_ADMIN_PASSWORD=admin
GF_USERS_ALLOW_SIGN_UP=false

# qBittorrent configuration
WEBUI_PORT=8082

# Network configuration
HOMELAB_NETWORK=homelab

# Service-specific variables
PROMETHEUS_RETENTION=15d
EXTERNAL_DNS=8.8.8.8

# =============================================================================
# Image compatibility notes:
# - LinuxServer images: Respect PUID/PGID variables
# - Official images: Use fixed UIDs, configured by this script
# - Shared storage: Accessible by all containers via ACLs
# =============================================================================
EOF

echo "   ✅ .env file created with multi-image UID support"

# =============================================================================
# 7. Final message
# =============================================================================

echo ""
echo "🎉 Multi-image initialization completed successfully!"
echo ""
echo "📋 Summary:"
echo "   ✅ LinuxServer images: UID=$DOCKER_USER_ID, GID=$DOCKER_GROUP_ID"
echo "   ✅ Prometheus: UID=$PROMETHEUS_UID (fixed)"
echo "   ✅ Grafana: UID=$GRAFANA_UID (fixed)"
echo "   ✅ Cross-container access configured via ACLs"
echo "   ✅ .env file created with all UID mappings"
echo ""
echo "🚀 You can now start your containers:"
echo "   docker-compose up -d"
echo ""
echo "⚠️ Important: Official images cannot change their UIDs!"
echo "   This script handles the compatibility automatically."