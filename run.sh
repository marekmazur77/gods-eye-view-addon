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

# Server-side keys are consumed by the app's upstream proxies via process.env.
export OPENAI_API_KEY
export AISSTREAM_API_KEY
export FIRMS_MAP_KEY
export CESIUM_ION_TOKEN
export TOMTOM_API_KEY
export GOOGLE_MAPS_API_KEY

# The built bundle has a sentinel (__GEV_GOOGLE_KEY__) in place of the Google key.
# Replace it with the real key so the 3D tiles load.
if [ -n "$GOOGLE_MAPS_API_KEY" ]; then
  grep -rl '__GEV_GOOGLE_KEY__' /app/dist 2>/dev/null | while read -r f; do
    sed -i "s#__GEV_GOOGLE_KEY__#${GOOGLE_MAPS_API_KEY}#g" "$f"
  done
  echo "Google Maps key injected into build."
else
  echo "WARN: no Google Maps API key configured; 3D tiles will not load."
fi

export HOST=0.0.0.0
export PORT=5173

echo "God's Eye View starting on ${HOST}:${PORT}"
exec npm run preview -- --host "${HOST}" --port "${PORT}"
