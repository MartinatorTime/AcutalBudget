FROM actualbudget/actual-server:latest

ENV PORT=8080

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

# Delete downloaded archives
RUN rm -rf overmind.gunzip cloudflared.deb
    
# Copy files to docker
COPY Procfile .

# Set some envs
ENV TINI_SUBREAPER yes \
    OVERMIND_AUTO_RESTART=all \
    OVERMIND_DAEMONIZE=1

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

# Start Overmind
CMD ["overmind", "start"]