#!/usr/bin/env bash
set -e

cd /app

OPTIONS=/data/options.json

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

export GOOGLE_MAPS_API_KEY="$(read_opt google_maps_api_key)"
export OPENAI_API_KEY="$(read_opt openai_api_key)"
export AISSTREAM_API_KEY="$(read_opt aisstream_api_key)"
export FIRMS_MAP_KEY="$(read_opt firms_map_key)"
export CESIUM_ION_TOKEN="$(read_opt cesium_ion_token)"
export TOMTOM_API_KEY="$(read_opt tomtom_api_key)"

HOST=0.0.0.0
PORT=5173

echo "God's Eye View starting on ${HOST}:${PORT}"
exec npm run dev -- --host "${HOST}" --port "${PORT}"
