# God's Eye View - Home Assistant add-on
# Builds the Vite app (honors base './' so asset paths are relative and work
# behind HA's ingress subpath) and serves it with `vite preview`, which keeps
# the upstream API proxies (configurePreviewServer) and avoids the dev-server's
# absolute-path module transform that breaks under ingress.
FROM node:24-slim

LABEL \
  io.hass.version="0.1.8" \
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
    # /@vite/client, /logo.svg, /pin.svg). Behind HA's ingress prefix those 404 and JS
    # never runs. Rewrite to relative paths. (Vite build emits relative assets anyway,
    # but this keeps the raw index.html consistent.)
    && sed -i 's#href="/#href="./#g; s#src="/#src="./#g; s#data-logo-src="/#data-logo-src="./#g' index.html \
    # The Google key is a runtime add-on option, not available at build. Bake a sentinel
    # into the bundle via define; run.sh replaces it with the real key at startup.
    && sed -i "s#JSON.stringify(env.GOOGLE_MAPS_API_KEY)#JSON.stringify('__GEV_GOOGLE_KEY__')#" vite.config.js \
    && npm run build

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 5173

ENTRYPOINT ["/run.sh"]
