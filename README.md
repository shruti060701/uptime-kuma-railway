# Uptime Kuma on Railway

Open-source, self-hosted monitoring & status page tool. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/uptime-kuma)

## Features

- **Real-time monitoring** — Track HTTP, HTTPS, TCP, DNS, Ping, and Socket endpoints with 20-second intervals
- **Status page** — Public-facing status dashboard showing service health and incident history
- **Incident tracking** — Record and communicate downtime with maintenance windows and notifications
- **Smart notifications** — Alerts via email, SMS, Slack, Discord, Telegram, Pushover, and 20+ integrations
- **No external dependencies** — Single container with embedded database persistence (MariaDB or SQLite, your choice on first run), runs entirely on your infrastructure
- **Unlimited monitors** — Create as many monitors as you need without per-monitor costs
- **Backup & restore** — Export and import monitor configurations and history

## Getting Started

1. Click the "Deploy on Railway" button above
2. Wait for deployment to complete, then visit your Railway domain
3. **First screen: choose a database.** Keep the pre-selected **"Embedded MariaDB"** and click Next — it runs inside the same container (no extra Railway service needed) and is the officially recommended option for new installs. Avoid "SQLite" if you might monitor many hosts on short intervals later — migrating from SQLite to MariaDB afterward isn't supported by Uptime Kuma, so this choice is effectively permanent. "MariaDB/MySQL" (external) isn't usable here since this template doesn't provision a separate database service.
4. **Second screen: create your admin account.** This is a fresh account you create yourself, not a pre-generated credential — pick any username and password.
5. Create your first monitor in the dashboard
6. Set up notifications by connecting your preferred channels (Slack, Discord, email, etc.)

## Configuration

### Persistent Data

All monitor data, incident history, and configuration is stored in `/app/data` on a Railway-managed volume. This persists across redeploys.

### Default Port

Uptime Kuma runs on port 3001 and is automatically exposed via your Railway public domain.

### Notifications

Configure notifications through the Uptime Kuma web interface:
- Settings → Notification
- Add your integration (Slack, Discord, email, etc.)
- Attach notifications to individual monitors

## Deployment Details

- **Image:** `louislam/uptime-kuma:2` (official Docker image)
- **Port:** 3001
- **Volume:** `/app/data` (database files + monitor history — embedded MariaDB by default, or SQLite if chosen on first run)
- **Memory:** 256 MB minimum recommended
- **CPU:** Shared instance sufficient for most workloads

## Monitoring Use Cases

- **Server health checks** — Verify APIs and web services are responding
- **Domain & certificate expiry** — Get alerted before SSL certificates expire
- **Scheduled maintenance** — Communicate planned downtime to users
- **Team visibility** — Share status page with stakeholders
- **SLA tracking** — Maintain uptime reports for compliance
- **Multi-region health** — Monitor endpoints across geographic regions

## Support & Documentation

- Official Docs: https://github.com/louislam/uptime-kuma/wiki
- GitHub Issues: https://github.com/louislam/uptime-kuma/issues
- Live Demo: https://demo.uptime.kuma.pet

## License

AGPL-3.0 — free to self-host forever
