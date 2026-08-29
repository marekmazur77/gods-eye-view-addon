#!/usr/bin/env bash
set -e

# God's Eye View - Home Assistant add-on launcher.
# Injects the API keys from the add-on options into the app's expected env vars,
# then starts the Vite dev server bound to 0.0.0.0 so HA ingress can reach it.
cd /app

export GOOGLE_MAPS_API_KEY="${config_google_maps_api_key}"
export OPENAI_API_KEY="${config_openai_api_key}"
export AISSTREAM_API_KEY="${config_aisstream_api_key}"
export FIRMS_MAP_KEY="${config_firms_map_key}"
export CESIUM_ION_TOKEN="${config_cesium_ion_token}"
export TOMTOM_API_KEY="${config_tomtom_api_key}"

HOST=0.0.0.0
PORT=5173

echo "God's Eye View starting on ${HOST}:${PORT}"
exec npm run dev -- --host "${HOST}" --port "${PORT}"
