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

No separate Postgres, Redis, or other Railway database service is required — Uptime Kuma 2.x's own first-run wizard asks you to choose **Embedded MariaDB** or **SQLite**, both of which run entirely inside the same container on the `/app/data` volume. **Recommend keeping the default "Embedded MariaDB"** (officially recommended for new installs, better concurrent-write handling) — do not pick "MariaDB/MySQL" (external), since that requires a separate database service this template doesn't provision. Note that migrating from SQLite to MariaDB later is not supported by Uptime Kuma, so this is effectively a one-time, permanent choice — worth calling out explicitly to whoever deploys this, not just leaving them to guess.

---

## 4. Persistent Volume Configuration

The volume mounted at `/app/data` stores:
- **Monitor configurations** (HTTP/TCP/DNS/Ping endpoints and their settings)
- **Uptime history** (historical data for each monitor)
- **Incident records** (downtime events and duration)
- **Notification templates** (alert message configurations)
- **Database files** — either the embedded MariaDB data directory (default/recommended) or a single `kuma.sqlite3` file, depending on which option is chosen on first run (see section 3)

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

1. Visit your Railway domain (e.g., `uptime-kuma-prod-xyz.railway.app`) — root redirects to `/setup-database`
2. **Database choice screen:** keep the pre-selected "Embedded MariaDB" and click Next (see section 3 for why)
3. **Create admin account screen:** this is a fresh account created on the spot, not a pre-generated credential from any Railway variable — pick any username/password
4. Add your first monitor: Settings → Add Monitor
5. Test a simple HTTP endpoint (e.g., `https://www.google.com`)
6. Set up notifications if desired: Settings → Notification

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
- Data lives in the embedded MariaDB data directory under `/app/data` by default, or `/app/data/kuma.sqlite3` if SQLite was chosen on first run

### Docker VOLUME instruction breaks the build
- Railway's builder rejects Docker's native `VOLUME` instruction outright: `dockerfile invalid: docker VOLUME at Line N is not supported, use Railway Volumes`
- Never add `VOLUME /app/data` (or any `VOLUME` line) to the Dockerfile — persistence is handled entirely via `railway volume add --mount-path /app/data`, which doesn't require any Dockerfile declaration at all
- This bug was hit and fixed during this template's own initial build (commit `ce0984a`) — if you fork this template, don't reintroduce it

### Healthcheck timing out
- Increase timeout in railway.toml to 300 seconds if needed
- First startup creates database schema (~10-30 seconds)
- Subsequent starts are faster (~3-5 seconds)
