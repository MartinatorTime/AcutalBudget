#!/bin/bash

# Increase the ping_group_range
echo "0 1024" > /proc/sys/net/ipv4/ping_group_range

# Set sysctl parameters
sysctl -w net.core.rmem_max=8388608
sysctl -w net.core.wmem_max=8388608
sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_wmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_mem='16777216 16777216 16777216'
sysctl -w net.ipv4.udp_mem='16777216 16777216 16777216'

cat << EOF > ./agent-config.yaml
metrics:
  global:
    scrape_interval: 60s
  configs:
  - name: hosted-prometheus
    scrape_configs:
      - job_name: cloudflare-tunnel
        static_configs:
        - targets: ['0.0.0.0:9191']
      - job_name: actualbudget
        static_configs:
        - targets: ['0.0.0.0:9091']
    remote_write:
      - url: $GRAFANA_URL
        basic_auth:
          username: $GRAFANA_USER
          password: $GRAFANA_PASS
EOF

# Execute the CMD
exec "$@"