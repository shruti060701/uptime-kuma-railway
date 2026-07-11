FROM louislam/uptime-kuma:2

EXPOSE 3001

# Persistence is handled via a Railway Volume (attached separately with
# `railway volume add --mount-path /app/data`), not Docker's VOLUME
# instruction - Railway's builder rejects that outright: "dockerfile
# invalid: docker VOLUME at Line 5 is not supported, use Railway Volumes."

CMD ["node", "server/server.js"]
