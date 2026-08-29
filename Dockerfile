# God's Eye View - Home Assistant add-on
# Builds the Vite dev server (the app's API proxies live in vite.config.js,
# so it must run in dev mode) and serves it on the add-on ingress port.
FROM node:24-slim

# The add-on repo only carries the add-on files; the app itself is cloned here
# at build time (pinned to main) so the package it ships stays small and current.
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
