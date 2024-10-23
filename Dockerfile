FROM actualbudget/actual-server:latest

ENV PORT=8080 \
    LOG_FILE=/data/actual.log \
    DOMAIN=https://budget.martinatortime.us.to

VOLUME /data
USER root
# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y sqlite3 libpq5 wget curl tar lsof jq gpg ca-certificates openssl tmux procps unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Overmind (latest release)
RUN OVERMIND_VERSION=$(curl -s https://api.github.com/repos/DarthSim/overmind/releases/latest | jq -r '.tag_name') \
    && echo "$OVERMIND_VERSION" \
    && wget -O overmind.gz "https://github.com/DarthSim/overmind/releases/download/$OVERMIND_VERSION/overmind-${OVERMIND_VERSION}-linux-amd64.gz" \
    && gunzip overmind.gz \
    && chmod +x overmind \
    && mv overmind /usr/local/bin/

# Install cloudflared tunnel
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb \
    && dpkg -i cloudflared.deb

# Download and extract Caddy (latest release)
RUN CADDY_VERSION=$(wget -qO- https://api.github.com/repos/caddyserver/caddy/releases/latest | jq -r '.tag_name') \
    && wget -O caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/$CADDY_VERSION/caddy_${CADDY_VERSION#v}_linux_amd64.tar.gz" \
    && tar -xzf caddy.tar.gz -C /usr/local/bin/ caddy

# Delete downloaded archives
RUN rm -rf overmind.gunzip cloudflared.deb
    
# Copy files to docker
COPY config/Procfile ./Procfile
COPY config/Caddyfile /etc/caddy/Caddyfile

# Set some envs
ENV TINI_SUBREAPER yes \
    OVERMIND_AUTO_RESTART=all \
    OVERMIND_DAEMONIZE=1

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

# Start Overmind
CMD ["overmind", "start"]