#!/usr/bin/env bash
set -e

# God's Eye View - Home Assistant add-on launcher.
# Supervisor writes the add-on options to /data/options.json. Read the API keys
# from there and export them as the environment variables the app expects, then
# start the Vite dev server bound to 0.0.0.0 so HA ingress can reach it.
cd /app

OPTIONS=/data/options.json

# Read a top-level string key from options.json using python3 (present in the image).
read_opt() {
  python3 -c "
import json, sys
try:
    d = json.load(open('$OPTIONS'))
    print(d.get('$1', ''))
except Exception:
    print('')
"
}

# Vite injects these into import.meta.env.* (see vite.config.js 'define'/loadEnv).
# Server-side keys are consumed by the app's upstream proxies via process.env.
export GOOGLE_MAPS_API_KEY="$(read_opt google_maps_api_key)"
export OPENAI_API_KEY="$(read_opt openai_api_key)"
export AISSTREAM_API_KEY="$(read_opt aisstream_api_key)"
export FIRMS_MAP_KEY="$(read_opt firms_map_key)"
export CESIUM_ION_TOKEN="$(read_opt cesium_ion_token)"
export TOMTOM_API_KEY="$(read_opt tomtom_api_key)"

# allow Vite to serve the injected env as-is
HOST=0.0.0.0
PORT=5173

echo "God's Eye View starting on ${HOST}:${PORT}"
exec npm run dev -- --host "${HOST}" --port "${PORT}"
