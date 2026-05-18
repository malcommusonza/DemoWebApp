#!/bin/bash
# DevOps Bot - Auto-deployment script for DemoWebApp
# Runs on EC2, serves on port 60000, auto-pulls from GitHub

set -e

REPO_DIR="/opt/demo-webapp"
PORT=60000
BRANCH="main"

cd "$REPO_DIR"

echo "[$(date)] Pulling latest changes..."
git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date)] Changes detected - updating..."
    git pull origin $BRANCH
    
    echo "[$(date)] Reloading nginx..."
    # Kill old server if running
    pkill -f "python.*$PORT" 2>/dev/null || true
    
    # Start new server
    cd "$REPO_DIR"
    nohup python3 -m http.server $PORT > /var/log/demo-webapp.log 2>&1 &
    
    echo "[$(date)] Deployment complete - http://localhost:$PORT"
else
    echo "[$(date)] No changes detected"
fi