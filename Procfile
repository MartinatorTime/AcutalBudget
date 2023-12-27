actualbudget: node app.js
cf_tunnel: cloudflared tunnel --no-autoupdate --metrics 0.0.0.0:60123 run --token "$CF_TOKEN"
prometheus: ./prometheus/prometheus --config.file="prometheus.yml"
#grafana: ./grafanad