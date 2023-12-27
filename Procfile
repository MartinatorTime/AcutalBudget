actualbudget: node app.js
cf_tunnel: cloudflared tunnel --no-autoupdate --metrics 0.0.0.0:9191 run --token "$CF_TOKEN"
grafana: ./grafana-agent-linux-amd64 --config.file=agent-config.yaml