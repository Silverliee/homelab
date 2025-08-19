# =============================================================================
# Homelab Makefile - Docker Compose Task Automation
# =============================================================================

# Global variables
COMPOSE_FILE = docker-compose.yml
ENV_FILE = .env
STACKS_DIR = stacks

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m # No Color

# =============================================================================
# Main rules - Global management
# =============================================================================

.PHONY: help init up down restart status logs clean

# Display help (default rule)
help:
	@echo "$(GREEN)🏠 Homelab Management Makefile$(NC)"
	@echo ""
	@echo "$(YELLOW)📋 Main commands:$(NC)"
	@echo "  make init          - Initialize permissions and directory structure"
	@echo "  make up            - Start all services"
	@echo "  make down          - Stop all services"
	@echo "  make restart       - Restart all services"
	@echo "  make status        - Show services status"
	@echo "  make logs          - Show real-time logs"
	@echo ""
	@echo "$(YELLOW)🏗️ Stack management:$(NC)"
	@echo "  make infra-up      - Start infrastructure stack"
	@echo "  make infra-down    - Stop infrastructure stack"
	@echo "  make monitoring-up - Start monitoring stack"
	@echo "  make media-up      - Start media stack"
	@echo "  make download-up   - Start download stack"
	@echo ""
	@echo "$(YELLOW)🔧 Maintenance:$(NC)"
	@echo "  make update        - Update Docker images"
	@echo "  make cleanup       - Clean unused Docker resources"
	@echo "  make backup        - Backup important data"
	@echo "  make health        - Check services health"
	@echo ""
	@echo "$(YELLOW)📊 Monitoring:$(NC)"
	@echo "  make monitor       - Show resource usage"
	@echo "  make disk-usage    - Show disk usage"
	@echo "  make validate      - Validate docker-compose files"

# Complete project initialization
init:
	@echo "$(GREEN)🚀 Initializing homelab...$(NC)"
	@chmod +x init-permissions.sh
	@./init-permissions.sh
	@echo "$(GREEN)✅ Initialization completed!$(NC)"

# Start all services
up: check-env
	@echo "$(GREEN)🚀 Starting all services...$(NC)"
	@docker compose up -d
	@echo "$(GREEN)✅ All services started!$(NC)"
	@make status

# Stop all services
down:
	@echo "$(YELLOW)⏹️ Stopping all services...$(NC)"
	@docker compose down
	@echo "$(GREEN)✅ All services stopped!$(NC)"

# Restart all services
restart: down up
	@echo "$(GREEN)🔄 Restart completed!$(NC)"

# Show services status
status:
	@echo "$(GREEN)📊 Services status:$(NC)"
	@docker compose ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Show real-time logs
logs:
	@echo "$(GREEN)📋 Real-time logs (Ctrl+C to stop):$(NC)"
	@docker compose logs -f

# =============================================================================
# Stack management
# =============================================================================

# Infrastructure Stack
infra-up:
	@echo "$(GREEN)🏗️ Starting infrastructure stack...$(NC)"
	@cd $(STACKS_DIR)/infrastructure && docker compose up -d

infra-down:
	@echo "$(YELLOW)⏹️ Stopping infrastructure stack...$(NC)"
	@cd $(STACKS_DIR)/infrastructure && docker compose down

infra-restart:
	@make infra-down
	@make infra-up

infra-logs:
	@echo "$(BLUE)📋 Infrastructure logs:$(NC)"
	@cd $(STACKS_DIR)/infrastructure && docker compose logs -f

# Monitoring Stack
monitoring-up:
	@echo "$(GREEN)📊 Starting monitoring stack...$(NC)"
	@cd $(STACKS_DIR)/monitoring && docker compose up -d

monitoring-down:
	@echo "$(YELLOW)⏹️ Stopping monitoring stack...$(NC)"
	@cd $(STACKS_DIR)/monitoring && docker compose down

monitoring-restart:
	@make monitoring-down
	@make monitoring-up

monitoring-logs:
	@echo "$(BLUE)📋 Monitoring logs:$(NC)"
	@cd $(STACKS_DIR)/monitoring && docker compose logs -f

# Media Stack
media-up:
	@echo "$(GREEN)🎬 Starting media stack...$(NC)"
	@cd $(STACKS_DIR)/media && docker compose up -d

media-down:
	@echo "$(YELLOW)⏹️ Stopping media stack...$(NC)"
	@cd $(STACKS_DIR)/media && docker compose down

media-restart:
	@make media-down
	@make media-up

media-logs:
	@echo "$(BLUE)📋 Media logs:$(NC)"
	@cd $(STACKS_DIR)/media && docker compose logs -f

# Download Stack
download-up:
	@echo "$(GREEN)⬇️ Starting download stack...$(NC)"
	@cd $(STACKS_DIR)/download && docker compose up -d

download-down:
	@echo "$(YELLOW)⏹️ Stopping download stack...$(NC)"
	@cd $(STACKS_DIR)/download && docker compose down

download-restart:
	@make download-down
	@make download-up

download-logs:
	@echo "$(BLUE)📋 Download logs:$(NC)"
	@cd $(STACKS_DIR)/download && docker compose logs -f

# Utilities Stack (if exists)
utilities-up:
	@echo "$(GREEN)🛠️ Starting utilities stack...$(NC)"
	@if [ -d "$(STACKS_DIR)/utilities" ]; then \
		cd $(STACKS_DIR)/utilities && docker compose up -d; \
	else \
		echo "$(YELLOW)⚠️ Utilities stack not found$(NC)"; \
	fi

utilities-down:
	@echo "$(YELLOW)⏹️ Stopping utilities stack...$(NC)"
	@if [ -d "$(STACKS_DIR)/utilities" ]; then \
		cd $(STACKS_DIR)/utilities && docker compose down; \
	else \
		echo "$(YELLOW)⚠️ Utilities stack not found$(NC)"; \
	fi

# =============================================================================
# Maintenance and utilities
# =============================================================================

# Check if .env file exists
check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)❌ .env file missing! Run 'make init' first.$(NC)"; \
		exit 1; \
	fi

# Update all Docker images
update:
	@echo "$(GREEN)🔄 Updating Docker images...$(NC)"
	@docker compose pull
	@echo "$(GREEN)✅ Images updated!$(NC)"
	@echo "$(YELLOW)💡 Run 'make restart' to apply updates$(NC)"

# Clean unused Docker resources
cleanup:
	@echo "$(GREEN)🧹 Cleaning Docker resources...$(NC)"
	@docker system prune -f
	@docker volume prune -f
	@echo "$(GREEN)✅ Cleanup completed!$(NC)"

# Backup important data
backup:
	@echo "$(GREEN)💾 Backing up data...$(NC)"
	@mkdir -p backups/$(shell date +%Y%m%d_%H%M%S)
	@tar -czf backups/$(shell date +%Y%m%d_%H%M%S)/data_backup.tar.gz data/
	@tar -czf backups/$(shell date +%Y%m%d_%H%M%S)/configs_backup.tar.gz configs/
	@echo "$(GREEN)✅ Backup completed in backups/ directory$(NC)"

# Check services health
health:
	@echo "$(GREEN)🏥 Checking services health...$(NC)"
	@echo "$(YELLOW)Dead/Exited containers:$(NC)"
	@docker ps --filter "status=exited" --filter "status=dead" --format "table {{.Names}}\t{{.Status}}" || echo "None"
	@echo ""
	@echo "$(YELLOW)Resource usage:$(NC)"
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

# =============================================================================
# Monitoring and statistics
# =============================================================================

# Show resource usage
monitor:
	@echo "$(GREEN)📊 Resource usage:$(NC)"
	@docker stats --no-stream

# Show disk usage
disk-usage:
	@echo "$(GREEN)💽 Disk usage:$(NC)"
	@echo "$(YELLOW)Data directory:$(NC)"
	@du -sh data/ 2>/dev/null || echo "Data directory doesn't exist"
	@echo ""
	@echo "$(YELLOW)Storage directory:$(NC)"
	@du -sh storage/ 2>/dev/null || echo "Storage directory doesn't exist"
	@echo ""
	@echo "$(YELLOW)Docker volumes:$(NC)"
	@docker system df

# Show logs for a specific service
logs-service:
	@if [ -z "$(SERVICE)" ]; then \
		echo "$(RED)❌ Please specify SERVICE variable: make logs-service SERVICE=servicename$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)📋 Logs for service $(SERVICE):$(NC)"
	@docker compose logs -f $(SERVICE)

# =============================================================================
# Ordered startup/shutdown
# =============================================================================

# Start stacks in recommended order
start-ordered:
	@echo "$(GREEN)🚀 Starting stacks in order...$(NC)"
	@echo "$(YELLOW)1/4 - Infrastructure...$(NC)"
	@make infra-up
	@sleep 5
	@echo "$(YELLOW)2/4 - Monitoring...$(NC)"
	@make monitoring-up
	@sleep 5
	@echo "$(YELLOW)3/4 - Download...$(NC)"
	@make download-up
	@sleep 5
	@echo "$(YELLOW)4/4 - Media...$(NC)"
	@make media-up
	@echo "$(GREEN)✅ All stacks started!$(NC)"

# Stop stacks in reverse order
stop-ordered:
	@echo "$(GREEN)⏹️ Stopping stacks in order...$(NC)"
	@make media-down
	@make download-down
	@make monitoring-down
	@make infra-down
	@echo "$(GREEN)✅ All stacks stopped!$(NC)"

# =============================================================================
# Development rules
# =============================================================================

# Validate docker-compose files syntax
validate:
	@echo "$(GREEN)✅ Validating docker-compose files...$(NC)"
	@docker compose config > /dev/null && echo "$(GREEN)✅ Main file valid$(NC)" || echo "$(RED)❌ Error in main file$(NC)"
	@for stack in infrastructure monitoring media download utilities; do \
		if [ -f "$(STACKS_DIR)/$$stack/docker-compose.yml" ]; then \
			cd $(STACKS_DIR)/$$stack && docker compose config > /dev/null && echo "$(GREEN)✅ Stack $$stack valid$(NC)" || echo "$(RED)❌ Error in stack $$stack$(NC)"; \
			cd ../..; \
		fi \
	done

# Pull latest images for all stacks
pull-all:
	@echo "$(GREEN)📥 Pulling latest images...$(NC)"
	@docker compose pull
	@for stack in infrastructure monitoring media download utilities; do \
		if [ -d "$(STACKS_DIR)/$$stack" ]; then \
			echo "$(YELLOW)Pulling $$stack stack...$(NC)"; \
			cd $(STACKS_DIR)/$$stack && docker compose pull; \
			cd ../..; \
		fi \
	done
	@echo "$(GREEN)✅ All images pulled!$(NC)"

# Show container sizes
container-sizes:
	@echo "$(GREEN)📏 Container sizes:$(NC)"
	@docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -20

# Show network information
network-info:
	@echo "$(GREEN)🌐 Network information:$(NC)"
	@docker network ls
	@echo ""
	@echo "$(YELLOW)Homelab network details:$(NC)"
	@docker network inspect homelab 2>/dev/null || echo "Homelab network not found"

# Emergency stop (force stop all containers)
emergency-stop:
	@echo "$(RED)🚨 Emergency stop - Force stopping all containers...$(NC)"
	@docker stop $$(docker ps -aq) 2>/dev/null || echo "No running containers"
	@echo "$(GREEN)✅ Emergency stop completed$(NC)"

# Show quick status overview
overview:
	@echo "$(GREEN)📊 Homelab Overview$(NC)"
	@echo ""
	@echo "$(YELLOW)Services Status:$(NC)"
	@docker compose ps --format table
	@echo ""
	@echo "$(YELLOW)Resource Usage:$(NC)"
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
	@echo ""
	@echo "$(YELLOW)Disk Usage:$(NC)"
	@echo "Data: $(shell du -sh data/ 2>/dev/null | cut -f1 || echo 'N/A')"
	@echo "Storage: $(shell du -sh storage/ 2>/dev/null | cut -f1 || echo 'N/A')"