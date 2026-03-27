#!/bin/bash
# =============================================================================
# Agency Automation Stack — Startup Script
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Agency Automation Stack — Starting    ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker Desktop first."
    echo "Download: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

if ! docker info &> /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Check .env
if [ ! -f .env ]; then
    echo -e "${YELLOW}No .env file found. Creating from template...${NC}"
    echo "Please edit .env with your API keys before continuing."
    exit 1
fi

echo -e "${GREEN}[1/4]${NC} Starting infrastructure (databases, Redis, Elasticsearch)..."
docker compose up -d n8n-postgres postiz-postgres postiz-redis temporal-postgresql temporal-elasticsearch
sleep 10

echo -e "${GREEN}[2/4]${NC} Starting Temporal workflow engine..."
docker compose up -d temporal
sleep 15

echo -e "${GREEN}[3/4]${NC} Starting Ollama + Open WebUI..."
docker compose up -d ollama open-webui
sleep 5

echo -e "${GREEN}[4/4]${NC} Starting application services (n8n, OpenOutreach, Postiz)..."
docker compose up -d n8n openoutreach postiz

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  All services started!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "  ${GREEN}n8n (Automation):${NC}        http://localhost:5678"
echo -e "  ${GREEN}Open WebUI (Chat AI):${NC}    http://localhost:3000"
echo -e "  ${GREEN}Postiz (Social Media):${NC}   http://localhost:4007"
echo -e "  ${GREEN}OpenOutreach (LinkedIn):${NC} http://localhost:6080/vnc.html"
echo -e "  ${GREEN}OpenOutreach Admin:${NC}      http://localhost:8000/admin/"
echo -e "  ${GREEN}Ollama API:${NC}              http://localhost:11434"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Pull an AI model:  docker exec ollama ollama pull llama3.1:8b"
echo "  2. Open n8n and create your first workflow"
echo "  3. Open Postiz and connect your social accounts"
echo "  4. Open OpenOutreach VNC and run the onboarding"
echo ""
