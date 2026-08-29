# God's Eye View - Home Assistant add-on
# Builds the Vite dev server (the app's API proxies live in vite.config.js,
# so it must run in dev mode) and serves it on the add-on ingress port.
FROM node:24-slim

LABEL \
  io.hass.version="0.1.7" \
  io.hass.type="app" \
  io.hass.arch="amd64"

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/bilawalsidhu/gods-eye-view.git /app \
    && cd /app \
    && npm ci \
    && sed -i 's/onlyUsingWithGoogleGeocoder: true/onlyUsingWithGoogleGeocoder: false/' src/main.js \
    && sed -i 's/^    server: {/    base: '"'"'.\/'"'"',\n    server: {/' vite.config.js \
    # The app's index.html hardcodes absolute asset paths (/style.css, /src/main.js,
    # /@vite/client, /logo.svg, /pin.svg). Behind HA's ingress prefix (/app/<slug>/)
    # those resolve to the HA root and 404, so the JS never runs and the globe is
    # stuck on "Initializing". Rewrite them to relative paths so they resolve under
    # the ingress subpath.
    && sed -i 's#href="/#href="./#g; s#src="/#src="./#g; s#data-logo-src="/#data-logo-src="./#g' index.html \
    && npx vite optimize

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 5173

ENTRYPOINT ["/run.sh"]
