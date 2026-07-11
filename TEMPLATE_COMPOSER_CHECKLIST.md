# Railway Template Composer Checklist — Uptime Kuma

Apply these settings in the Railway template composer when generating the template from the project.

---

## 1. Healthcheck Settings

### uptime-kuma

- **Healthcheck Path:** `/`
- **Healthcheck Timeout:** `120` seconds (accommodates startup and database initialization)
- **Variable:** `RAILWAY_HEALTHCHECK_PATH` = `/` with description

---

## 2. Variable Descriptions (Add to EVERY variable)

### uptime-kuma Variables

| Variable | Description | Default / Reference |
|----------|-------------|---------------------|
| `PORT` | The port the Uptime Kuma web UI listens on. | `3001` |
| `RAILWAY_HEALTHCHECK_PATH` | Endpoint Railway uses to verify the service is healthy. | `/` |
| `UPTIME_KUMA_PORT` | Alternative port configuration (if needed). | `3001` |

---

## 3. No Database Service

Uptime Kuma uses an embedded SQLite database stored at `/app/data` on the Railway-managed volume. No separate Postgres, Redis, or other database services are required.

---

## 4. Persistent Volume Configuration

The volume mounted at `/app/data` stores:
- **Monitor configurations** (HTTP/TCP/DNS/Ping endpoints and their settings)
- **Uptime history** (historical data for each monitor)
- **Incident records** (downtime events and duration)
- **Notification templates** (alert message configurations)
- **SQLite database** (single `kuma.sqlite3` file)

Ensure the volume is created and attached before deploying:

```bash
railway volume add --mount-path /app/data
```

---

## 5. Secrets and Auto-Generated Values

Uptime Kuma does not require any API keys or secrets by default. The application uses the embedded SQLite database, so no database credentials are needed. All configuration (monitors, notifications, status pages) is done through the web UI after deployment.

---

## 6. Optional Environment Variables

These can be set but are not required for basic operation:

- `NODE_ENV` — Set to `production` for security (optional)
- `UPTIME_KUMA_LOG_LEVEL` — Set to `debug`, `info`, `warn`, or `error` (optional, defaults to `info`)

---

## 7. Post-Deploy Steps

After the template is published, test-deploy from a fresh Railway account (incognito window) to verify:

1. The service comes online within 120 seconds
2. The healthcheck at `/` returns HTTP 200 (or 301/302 redirect)
3. You can access the Uptime Kuma web UI at the Railway domain
4. You can create a new monitor from the dashboard
5. The `/app/data` volume persists across redeploys

### Initial Setup After Deploy

1. Visit your Railway domain (e.g., `uptime-kuma-prod-xyz.railway.app`)
2. Create an admin account with a strong password
3. Add your first monitor: Settings → Add Monitor
4. Test a simple HTTP endpoint (e.g., `https://www.google.com`)
5. Set up notifications if desired: Settings → Notification

---

## 8. Healthcheck Validation

The service should respond to `curl` with a 200 status:

```bash
curl -s -o /dev/null -w "%{http_code}" https://your-railway-domain/
# Expected output: 200
```

If you get 502/503, check logs:

```bash
railway logs
```

Common causes:
- Volume not attached yet (see `railway volume list`)
- Container still initializing (give it 30-60 seconds)
- Memory limit too low (ensure at least 256 MB allocated)

---

## 9. Troubleshooting

### Service won't start
- Check available memory: Railway dashboard → Service → Resources
- Minimum: 256 MB RAM
- Recommended: 512 MB RAM for 50+ monitors

### Volume not persisting data
- Verify volume is attached: `railway volume list`
- Confirm mount path is `/app/data`
- Monitor data is stored in SQLite file at `/app/data/kuma.sqlite3`

### Healthcheck timing out
- Increase timeout in railway.toml to 300 seconds if needed
- First startup creates database schema (~10-30 seconds)
- Subsequent starts are faster (~3-5 seconds)
