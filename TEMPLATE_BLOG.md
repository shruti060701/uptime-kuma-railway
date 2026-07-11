# Deploy and Host Uptime Kuma-self-hosted on Railway

Uptime Kuma is the open-source alternative to UptimeRobot and Pingdom. Track your API endpoints, websites, and services in real-time without paying per-monitor fees. Self-host on Railway and own your monitoring data completely.

## About Hosting Uptime Kuma-self-hosted

Self-hosting Uptime Kuma means your uptime data never touches a third-party server. All monitoring history, incident records, and notification settings live on your infrastructure. You get the privacy of on-premise monitoring with the simplicity of Railway's managed platform. No vendor lock-in, no per-monitor pricing—just unlimited monitoring at a fixed cost. Teams use Uptime Kuma to track SLA compliance, set up public status pages, and get instant alerts when services go down.

## Common Use Cases

- Production API monitoring with 20-second check intervals
- Public status pages showing real-time service health
- SSL certificate expiry notifications before renewal deadline
- Multi-region endpoint health checks across geographic regions
- SLA uptime reporting for customer compliance and audits

## Dependencies for Uptime Kuma-self-hosted Hosting

Uptime Kuma is a single-container application—no databases to configure, no separate services to manage. It bundles Node.js runtime, SQLite database, and the monitoring engine in one Docker image.

### Deployment Dependencies

- **Docker image:** `louislam/uptime-kuma:2` (official, maintained by Louis Lam)
- **Storage:** Railway-managed volume at `/app/data` (SQLite persistence)
- **Port:** 3001 (automatically exposed via Railway domain)
- **Memory:** 256 MB minimum (512 MB recommended for 50+ monitors)

## Why Deploy Uptime Kuma-self-hosted on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Uptime Kuma-self-hosted on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
