#!/usr/bin/env bash
set -e

cd /app

OPTIONS=/data/options.json

# The image is node:24-slim (no python3). Read an option from options.json
# using node, which IS present.
read_opt() {
  node -e "
const fs = require('fs');
try {
  const d = JSON.parse(fs.readFileSync('$OPTIONS', 'utf8'));
  process.stdout.write(String(d['$1'] || ''));
} catch (e) {
  process.stdout.write('');
}
"
}

GOOGLE_MAPS_API_KEY="$(read_opt google_maps_api_key)"
OPENAI_API_KEY="$(read_opt openai_api_key)"
AISSTREAM_API_KEY="$(read_opt aisstream_api_key)"
FIRMS_MAP_KEY="$(read_opt firms_map_key)"
CESIUM_ION_TOKEN="$(read_opt cesium_ion_token)"
TOMTOM_API_KEY="$(read_opt tomtom_api_key)"

# Vite dev reads .env (not process.env) for import.meta.env.* when the var has no
# VITE_ prefix and the config's define targets import.meta.env.GOOGLE_MAPS_API_KEY.
cat > /app/.env <<EOF
GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}
OPENAI_API_KEY=${OPENAI_API_KEY}
AISSTREAM_API_KEY=${AISSTREAM_API_KEY}
FIRMS_MAP_KEY=${FIRMS_MAP_KEY}
CESIUM_ION_TOKEN=${CESIUM_ION_TOKEN}
TOMTOM_API_KEY=${TOMTOM_API_KEY}
EOF

EXPORT HOST=0.0.0.0
EXPORT PORT=5173

echo "God's Eye View starting on ${HOST}:${PORT}"
exec npm run dev -- --host "${HOST}" --port "${PORT}"
