# God's Eye View - Home Assistant add-on
# Builds the Vite dev server (the app's API proxies live in vite.config.js,
# so it must run in dev mode) and serves it on the add-on ingress port.
FROM node:24-slim

# Supervisor 2026.04+ no longer injects these labels automatically for build
# add-ons, and we do NOT use the HA base image - so set them explicitly.
LABEL \
  io.hass.version="0.1.0" \
  io.hass.type="app" \
  io.hass.arch="amd64"

# git/ca-certificates needed to clone the app at build; ca-certificates also
# required at runtime for the app's HTTPS upstream API proxies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/bilawalsidhu/gods-eye-view.git /app \
    && cd /app \
    && npm ci

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 5173

ENTRYPOINT ["/run.sh"]
