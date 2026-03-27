#!/bin/bash
# =============================================================================
# Agency Automation Stack — Stop All Services
# =============================================================================

echo "Stopping all services..."
docker compose down
echo "All services stopped. Data is preserved in Docker volumes."
echo "Run ./start.sh to restart."
