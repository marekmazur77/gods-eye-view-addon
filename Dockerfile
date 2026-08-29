# God's Eye View - Home Assistant add-on
# Builds the Vite dev server (the app's API proxies live in vite.config.js,
# so it must run in dev mode) and serves it on the add-on ingress port.
FROM node:24-slim

LABEL \
  io.hass.version="0.1.5" \
  io.hass.type="app" \
  io.hass.arch="amd64"

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/bilawalsidhu/gods-eye-view.git /app \
    && cd /app \
    && npm ci \
    # Google Photorealistic 3D Tiles does NOT need the Geocoding API. The upstream
    # main.js sets onlyUsingWithGoogleGeocoder:true which hangs the loader on the
    # Geocoding API (not enabled) and leaves the app stuck on "Initializing".
    # Patch it so the 3D tiles load directly.
    && sed -i 's/onlyUsingWithGoogleGeocoder: true/onlyUsingWithGoogleGeocoder: false/' src/main.js \
    && npx vite optimize

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 5173

ENTRYPOINT ["/run.sh"]
