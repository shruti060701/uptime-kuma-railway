FROM louislam/uptime-kuma:2

EXPOSE 3001

VOLUME /app/data

CMD ["node", "server/server.js"]
