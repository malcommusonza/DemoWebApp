# GitHub Auto-Deploy Setup for DemoWebApp

## Option 1: Webhook (Recommended for EC2)

1. **On your EC2 server:**
   ```bash
   # Install webhook listener
   pip3 install webhook-server
   
   # Run webhook listener on port 9000
   webhook-server --port 9000 --command "/opt/demo-webapp/deploy.sh"
   ```

2. **In GitHub repo settings:**
   - Go to Settings → Webhooks → Add webhook
   - Payload URL: `http://YOUR_EC2_IP:9000/`
   - Content type: `application/json`
   - Secret: `your-secret-key`
   - Events: Just push

3. **Set up nginx reverse proxy (if needed):**
   ```nginx
   location / {
       proxy_pass http://localhost:60000;
   }
   ```

## Option 2: Cron Poll (Simpler)

```bash
# Add to crontab
*/2 * * * * /opt/demo-webapp/deploy.sh >> /var/log/deploy.log 2>&1
```

## Current Setup

- **Port**: 60000
- **Server**: Python http.server (simple static file server)
- **Auto-deploy**: Webhook or cron-based

## Quick Start Commands

```bash
# Clone and setup
git clone https://github.com/malcommusonza/DemoWebApp /opt/demo-webapp
cd /opt/demo-webapp

# Start server
python3 -m http.server 60000

# Access at http://YOUR_EC2_IP:60000
```